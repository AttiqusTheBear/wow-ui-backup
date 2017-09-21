local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
    local Ovale = addonTable.Ovale;

    --<private-static-properties>
    local OvaleEnemies = Ovale.OvaleEnemies;

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

    -- Player's GUID.
	local playerGUID = nil;

    -- targets[GUID] = timestamp;
    local targets = {};
    -- myTargets[GUID] = timestamp;
    -- GUIDs used as keys for this table are a subset of the GUIDs used for targets.
    local myTargets = {};
	-- Group Summoned Creatures, not to be counted as enemies
	local groupSummons = {};

    -- Timer for reaper function to remove inactive enemies.
    local reaperTimer = nil;
	local timerInterval = 1;
    
	local ENEMY_REAP_INTERVAL = 5;
	local SUMMONS_REAP_INTERVAL = 30;

    -- Events
    -- Table of CLEU events for when a unit is summoned.
    local CLEU_UNIT_SUMMONED = {
        SPELL_SUMMON = true,
    };

    -- Table of CLEU events for when a unit is removed from combat.
    local CLEU_UNIT_REMOVED = {
        UNIT_DESTROYED = true,
        UNIT_DIED = true,
        UNIT_DISSIPATES = true,
    };

    --[[
        List of CLEU event suffixes that can correspond to the player damaging or try to
        damage (tag) an enemy, or vice versa.
    ]]
    local CLEU_TAG_SUFFIXES = {
        "_CAST_START",
        "_DAMAGE",
        "_MISSED",
        "_DRAIN",
        "_LEECH",
        "_INTERRUPT",
        "_DISPEL",
        "_DISPEL_FAILED",
        "_STOLEN",
        "_AURA_APPLIED",
        "_AURA_APPLIED_DOSE",
        "_AURA_REFRESH",
    };
    --</private-static-properties>

    --<public-static-properties>
    -- Total number of active enemies.
    OvaleEnemies.activeEnemies = 0;
    -- Total number of tagged enemies.
    OvaleEnemies.taggedEnemies = 0;
    --</public-static-properties>

    --<private-static-methods>
    local function wipeData()
		wipe(groupSummons);
		groupSummons = {};

        wipe(targets);
		targets = {};
        OvaleEnemies.activeEnemies = 0;

        wipe(myTargets);
        myTargets = {};
        OvaleEnemies.taggedEnemies = 0;
    end

    -- Functions to check Unit Info
    local function isPlayer(GUID, unitName, unitFlags)
        local unitInfo = LunaEclipse_Scripts:ParseGUID(GUID);

        return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
    end

    local function isGroupMember(GUID, unitName, unitFlags)
        local unitInfo = LunaEclipse_Scripts:ParseGUID(GUID);

        return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0
            or bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0 
            or bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0;
    end

    local function isEnemy(GUID, unitName, unitFlags)
        return bit.band(unitFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0;
    end

    local function isValid(GUID, unitName, unitFlags)
        return (GUID and GUID ~= "") 
           and unitName ~= nil
           and (bit.band(unitFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0
             or bit.band(unitFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
             or bit.band(unitFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0);
    end

    local function getUnitInfo(GUID, unitName, unitFlags)
        return isPlayer(GUID, unitName, unitFlags), isGroupMember(GUID, unitName, unitFlags), isEnemy(GUID, unitName, unitFlags), isValid(GUID, unitName, unitFlags);
    end

    -- Functions to check events
    local function isTagEvent(combatEvent)
        local returnValue = false;

        for _, eventSuffix in ipairs(CLEU_TAG_SUFFIXES) do
            if string.find(combatEvent, eventSuffix .. "$") then
                returnValue = true;
            end
        end

        return returnValue;
    end

    local function isValidEvent(combatEvent, sourceIsGroupMember, destIsGroupMember)
        return (sourceIsGroupMember or destIsGroupMember)
           and isTagEvent(combatEvent)
           and (sourceIsGroupMember
            or (not sourceIsGroupMember and combatEvent ~= "SPELL_PERIODIC_DAMAGE"));
    end
    --</private-static-methods>

    --<public-static-methods>
    function OvaleEnemies:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags = ...;

		local characterProfile = addonTable.characterSettings.profile;
        local currentTime = GetTime();

        local sourceIsPlayer, sourceIsGroupMember, sourceIsEnemy, sourceIsValid = getUnitInfo(sourceGUID, sourceName, sourceFlags);
        local destIsPlayer, destIsGroupMember, destIsEnemy, destIsValid = getUnitInfo(destGUID, destName, destFlags);

        if CLEU_UNIT_REMOVED[combatEvent] then
			if groupSummons[destGUID] then
				self:RemoveSummons(destGUID, true);
			else
				self:RemoveEnemy(destGUID, true);
			end
		elseif CLEU_UNIT_SUMMONED[combatEvent] and (sourceIsPlayer or sourceIsGroupMember) then
			self:AddSummons(destGUID, currentTime);
        elseif isValidEvent(combatEvent, sourceIsGroupMember, destIsGroupMember) then
            if sourceIsGroupMember and destIsValid and destIsEnemy then
				if addonTable.DEBUG_ENEMIES then
					local parseGUID = LunaEclipse_Scripts:ParseGUID(destGUID);
					
					characterProfile.EnemiesDebug[destGUID] = {
						Name = tostring(destName),
						Timestamp = date("%d/%m/%y %H:%M:%S");
						Flags = destFlags,
						unitInfo = parseGUID,
					};
				end

				if groupSummons[destGUID] then
					self:AddSummons(destGUID, currentTime);
				else
					self:AddEnemy(destGUID, currentTime, sourceIsPlayer);
				end
            elseif destIsGroupMember and sourceIsValid and sourceIsEnemy then
				if addonTable.DEBUG_ENEMIES then
					local parseGUID = LunaEclipse_Scripts:ParseGUID(sourceGUID);
					
					characterProfile.EnemiesDebug[sourceGUID] = {
						Name = tostring(sourceName),
						Flags = sourceFlags,
						unitInfo = parseGUID,
					};
				end

				if groupSummons[sourceGUID] then
					self:AddSummons(sourceGUID, currentTime);
				else
					self:AddEnemy(sourceGUID, currentTime);
				end
            end
        end
    end

    function OvaleEnemies:PLAYER_REGEN_DISABLED()
        -- Reset enemy tracking when combat starts.
        wipeData();
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    end

    function OvaleEnemies:PLAYER_REGEN_ENABLED()
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    end

    function OvaleEnemies:AddEnemy(GUID, timeStamp, playerTarget)
        if not targets[GUID] then
            self.activeEnemies = self.activeEnemies + 1;
            targets[GUID] = timeStamp;
            Ovale.refreshNeeded[playerGUID] = true;
        else
            targets[GUID] = timeStamp;
        end

        if playerTarget then
            if not myTargets[GUID] then
                self.taggedEnemies = self.taggedEnemies + 1;
                myTargets[GUID] = timeStamp;
                Ovale.refreshNeeded[playerGUID] = true;
            else
                myTargets[GUID] = timeStamp;
            end
        end 
    end

    function OvaleEnemies:AddSummons(GUID, timeStamp)
		groupSummons[GUID] = timeStamp;
    end

    function OvaleEnemies:RemoveEnemy(GUID, deathEvent)
        local refreshNeeded = false;
        local unitDied = (deathEvent and deathEvent == true);

        if targets[GUID] ~= nil then
            self.activeEnemies = max(0, self.activeEnemies - 1);
            targets[GUID] = nil;
            refreshNeeded = true;
        end

        if myTargets[GUID] ~= nil then
            self.taggedEnemies = max(0, self.taggedEnemies - 1);
            myTargets[GUID] = nil;
            refreshNeeded = true;
        end	

        if refreshNeeded then
            Ovale.refreshNeeded[playerGUID] = true;
            self:SendMessage("Ovale_InactiveUnit", GUID, unitDied);
        end
    end

    function OvaleEnemies:RemoveSummons(GUID, deathEvent)
        local refreshNeeded = false;
        local unitDied = (deathEvent and deathEvent == true);

        if groupSummons[GUID] ~= nil then
            groupSummons[GUID] = nil;
            refreshNeeded = true;
        end

        if refreshNeeded then
            Ovale.refreshNeeded[playerGUID] = true;
            self:SendMessage("Ovale_InactiveUnit", GUID, unitDied);
        end
    end

    --[[
        Remove units that have been inactive for at least ENEMY_REAP_INTERVAL
		or SUMMONS_REAP_INTERVAL seconds.  These units are not in combat with
		your group, out of range, or incapacitated and shouldn't count toward
		the number of active enemies.
    ]]
    function OvaleEnemies:RemoveInactiveUnits()
        local currentTime = GetTime();

		for GUID, timeStamp in pairs(groupSummons) do
            if currentTime - timeStamp > SUMMONS_REAP_INTERVAL then
                self:RemoveSummons(GUID);
            end
        end

		for GUID, timeStamp in pairs(targets) do
            if currentTime - timeStamp > ENEMY_REAP_INTERVAL then
                self:RemoveEnemy(GUID);
            end
        end
    end

    function OvaleEnemies:DebugEnemies()
        for GUID, lastSeen in pairs(targets) do
            local taggedTarget = myTargets[GUID];

            if taggedTarget then
                self:Print("Tagged enemy %s last seen at %f", GUID, taggedTarget);
            else
                self:Print("Enemy %s last seen at %f", GUID, lastSeen);
            end
        end

        self:Print("Total enemies: %d", self.activeEnemies);
        self:Print("Total tagged enemies: %d", self.taggedEnemies);
    end

    function OvaleEnemies:OnEnable()
		playerGUID = Ovale.playerGUID;

        if not reaperTimer then
            reaperTimer = self:ScheduleRepeatingTimer("RemoveInactiveUnits", timerInterval);
        end

        self:RegisterEvent("PLAYER_REGEN_DISABLED");
        self:RegisterEvent("PLAYER_REGEN_ENABLED");

        OvaleState:RegisterState(self, self.statePrototype);
    end

    function OvaleEnemies:OnDisable()
        OvaleState:UnregisterState(self);

        if reaperTimer then
            self:CancelTimer(reaperTimer);
            reaperTimer = nil;
        end

        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:UnregisterEvent("PLAYER_REGEN_DISABLED");
        self:UnregisterEvent("PLAYER_REGEN_ENABLED");
    end
    --</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    OvaleEnemies.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = OvaleEnemies.statePrototype;
    --</private-static-properties>

    --<state-properties>
    -- Total number of active enemies.
    statePrototype.activeEnemies = nil;
    -- Total number of tagged enemies.
    statePrototype.taggedEnemies = nil;
    -- Requested number of enemies.
    statePrototype.enemies = nil;
    --</state-properties>

    --<public-static-methods>
    -- Initialize the state.
    function OvaleEnemies:InitializeState(state)
        state.enemies = nil;
    end

    -- Reset the state to the current conditions.
    function OvaleEnemies:ResetState(state)
        state.activeEnemies = self.activeEnemies;
        state.taggedEnemies = self.taggedEnemies;
    end

    -- Release state resources prior to removing from the simulator.
    function OvaleEnemies:CleanState(state)
        state.activeEnemies = nil;
        state.taggedEnemies = nil;
        state.enemies = nil;
    end
    --</public-static-methods>
end