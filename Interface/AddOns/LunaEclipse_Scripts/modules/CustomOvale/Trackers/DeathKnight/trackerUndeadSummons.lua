local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerUndeadSummons";
	local trackerUndeadSummons = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

    -- Player's GUID.
	local playerGUID = nil;
	
    -- Timer for reaper function to remove expired summons.
    local reaperTimer = nil;
    local REAP_INTERVAL = 1;

    -- GUIDs used as keys for this table are summoned undead with limited duration.
	local summonedUndead = {};
	
	-- SpellIDs associated with the tracked Summons
	local SPELLID_APOCALYPSE = 205491;
	local SPELLID_ARMY_OF_THE_DEAD = 42651;
	local SPELLID_DARK_ARBITER = 207349;
	local SPELLID_GARGOYLE = 49206;
	local SPELLID_SHAMBLING_HORROR = 191759;

	-- Pets summoned
	local CREATURE_ABOMINATION = 106848;
	local CREATURE_GHOUL = 26125;

	-- Creatures summoned
	local CREATURE_APOCALYPSE = 999999;  -- Fake creatureID to seperate Army of the Dead Ghouls from Apocalypse Ghouls
	local CREATURE_ARMY_OF_THE_DEAD = 24207;
	local CREATURE_ARMY_OF_THE_DEAD_SPECIAL = 111101;  -- Special Army of the Dead spawn relating to Apocalypse Hidden Skin
	local CREATURE_DARK_ARBITER = 100876;
	local CREATURE_GARGOYLE = 27829;
	local CREATURE_SHAMBLING_HORROR = 97055;
	local CREATURE_SKULKER = 99541;

	-- CreatureIDs that override the actual summoned creatureID
	local SUMMONED_CREATURE_OVERRIDE_CREATUREID = {
		[SPELLID_APOCALYPSE] = CREATURE_APOCALYPSE,
		[SPELLID_ARMY_OF_THE_DEAD] = CREATURE_ARMY_OF_THE_DEAD,
	};

	-- Creature names that can be used for debugging purposes
	local SUMMONED_CREATURE_NAMES = {
		[CREATURE_ARMY_OF_THE_DEAD] = "Army of the Dead",
		[CREATURE_DARK_ARBITER] = "Dark Arbiter",
		[CREATURE_GARGOYLE] = "Gargoyle",
		[CREATURE_SHAMBLING_HORROR] = "Shambling Horror",
	};

	-- Summon duration for removing from the tracker
	local SUMMONED_CREATURE_DURATIONS = {
		[SPELLID_APOCALYPSE] = 15,
		[SPELLID_ARMY_OF_THE_DEAD] = 40,
		[SPELLID_DARK_ARBITER] = 15,
		[SPELLID_GARGOYLE] = 40,
		[SPELLID_SHAMBLING_HORROR] = 3,
	};

	-- Creature UnitIDs to check for summon events
	local CLEU_SUMMON_CREATURES = {
		[CREATURE_ARMY_OF_THE_DEAD] = true,
		[CREATURE_DARK_ARBITER] = true,
		[CREATURE_GARGOYLE] = true,
		[CREATURE_SHAMBLING_HORROR] = true,
	};

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

	--<private-static-methods>
	-- Functions to determine whether the module should work
	local function useModule()
		-- Default to not using the module
		local returnValue = false;
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();
	
		-- Check to make sure the player has a specialization
		if currentSpec then
			-- Check to make sure the player is a Unholy Death Knight
			returnValue = (currentSpec == addonTable.DEATHKNIGHT_UNHOLY) or false;
		end

		return returnValue;
	end

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end

    -- Determines if the summon is valid to track
	local function isValidSummon(sourceIsPlayer, unitType, creatureID)
        return sourceIsPlayer
		   and (unitType == addonTable.GUID_NPC and CLEU_SUMMON_CREATURES[tonumber(creatureID)]);
    end
	--</private-static-methods>

	--<public-static-methods>
	function trackerUndeadSummons:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;

			local currentTime = GetTime();
			local sourceIsPlayer = isPlayer(sourceFlags);
	
			local unitInfo = LunaEclipse_Scripts:ParseGUID(destGUID);
			local creatureID = SUMMONED_CREATURE_OVERRIDE_CREATUREID[spellID] or tonumber(unitInfo.CreatureID);

			local refreshNeeded = false;

			if CLEU_UNIT_REMOVED[combatEvent] then
				refreshNeeded = self:RemoveUndead(destGUID) or refreshNeeded;
			elseif CLEU_UNIT_SUMMONED[combatEvent] and isValidSummon(sourceIsPlayer, unitInfo.Type, unitInfo.CreatureID) then
				-- Check to see if the special Army of the Dead ghoul spawned for the Apocalypse Hidden Skin quest
				if addonTable.unholyDK_hiddenskin and (tonumber(unitInfo.CreatureID) == CREATURE_ARMY_OF_THE_DEAD_SPECIAL) then
					-- Special ghoul spawned, so show a raid warning to bring it to the players attention!
					RaidNotice_AddMessage(RaidWarningFrame, "Apocalyspe Hidden Skin Spawn Detected!", ChatTypeInfo["RAID_WARNING"]);
					PlaySoundFile("Sound\\Creature\\LichKing\\IC_Lich King_Special01.ogg");
				end
				
				refreshNeeded = self:AddUndead(destGUID, creatureID, currentTime, SUMMONED_CREATURE_DURATIONS[spellID]) or refreshNeeded;
			end    
			
			if refreshNeeded then
				Ovale.refreshNeeded[playerGUID] = true;
			end
		end
	end

    -- Remove undead that have despawned.
    function trackerUndeadSummons:TimerEvent()
		local refreshNeeded = false;
        local currentTime = GetTime();

        for GUID, data in pairs(summonedUndead) do			
            if data.despawnTime and currentTime > data.despawnTime then
                refreshNeeded = self:RemoveUndead(GUID) or refreshNeeded;
			end
        end

		if refreshNeeded then
			Ovale.refreshNeeded[playerGUID] = true;
		end
    end

	function trackerUndeadSummons:AddUndead(GUID, creature, spawn, duration)
		local returnValue = false;

        if not summonedUndead[GUID] then
			returnValue = true;

			if duration then
 				summonedUndead[GUID] = { creatureID = creature, spawnTime = spawn, despawnTime = spawn + duration};
			else
 				summonedUndead[GUID] = { creatureID = creature, spawnTime = spawn};
			end
        end

		return returnValue;
    end

    function trackerUndeadSummons:RemoveUndead(GUID)
		local returnValue = false;

        if summonedUndead[GUID] then
			returnValue = true;
            summonedUndead[GUID] = nil;
        end

		return returnValue;
    end

	function trackerUndeadSummons:OnEnable()
		playerGUID = Ovale.playerGUID;

        if not reaperTimer then
            reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
        end

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
 
		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerUndeadSummons:OnDisable()
        OvaleState:UnregisterState(self);

        if reaperTimer then
            self:CancelTimer(reaperTimer);
            reaperTimer = nil;
        end

        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	end
	--</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    trackerUndeadSummons.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerUndeadSummons.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
    statePrototype.UndeadActive = function(state, ID, atTime)
		local returnValue = 0;
     
		for GUID, data in pairs(summonedUndead) do
			if (not ID or ID == data.creatureID) and (not data.despawnTime or atTime < data.despawnTime) then
				returnValue = returnValue + 1;
			end
		end

		return returnValue > 0;
	end

    statePrototype.UndeadCount = function(state, ID, atTime)
		local returnValue = 0;
     
		for GUID, data in pairs(summonedUndead) do
			if (not ID or ID == data.creatureID) and (not data.despawnTime or atTime < data.despawnTime) then
				returnValue = returnValue + 1;
			end
		end

		return returnValue or 0;
	end

    statePrototype.FirstUndeadDespawn = function(state, ID, atTime)
		local returnValue = nil;
     
		for GUID, data in pairs(summonedUndead) do
			if (not ID or ID == data.creatureID) and (not data.despawnTime or atTime < data.despawnTime) then
				local remaining = data.despawnTime - atTime;
				
				if not returnValue or remaining < returnValue then
					returnValue = remaining;
				end
			end
		end

		return returnValue or 0;
	end

    statePrototype.LastUndeadDespawn = function(state, ID, atTime)
		local returnValue = nil;
     
		for GUID, data in pairs(summonedUndead) do
			if (not ID or ID == data.creatureID) and (not data.despawnTime or atTime < data.despawnTime) then
				local remaining = data.despawnTime - atTime;
				
				if not returnValue or remaining > returnValue then
					returnValue = remaining;
				end
			end
		end
		
		return returnValue or 0;
	end
    --</public-static-methods>
end