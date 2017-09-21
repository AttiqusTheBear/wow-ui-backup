local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerDemons";
	local trackerDemons = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

    -- Player's GUID.
	local playerGUID = nil;

    -- GUIDs used as keys for this table are summoned demons with limited duration.
	local summonedDemons = {};

    -- Timer for reaper function to remove inactive enemies.
    local reaperTimer = nil;
    local REAP_INTERVAL = 1;

	-- Spells afffecting demons
	local SPELL_DEMONIC_EMPOWERMENT = 193396;
	local SPELL_IMPLOSION = 196278;

	-- Demons summoned for limited duration
	local CREATURE_DARKGLARE = 103673;
	local CREATURE_DOOMGUARD = 11859;
	local CREATURE_DREADSTALKERS = 98035; -- Categorized as a Vehicle
	local CREATURE_DREADSTALKERS_WILD_IMPS = 99737; -- Improved Dreadstalkers
	local CREATURE_FELGUARD = 17252;
	local CREATURE_FELHUNTER = 417;
	local CREATURE_IMP = 416;
	local CREATURE_INFERNAL = 89;
	local CREATURE_SUCCUBUS = 1863;
	local CREATURE_VOIDWALKER = 1860;
	local CREATURE_WILD_IMPS = 55659;
	
	-- CreatureIDs that override the actual summoned creatureID
	local SUMMONED_CREATURE_OVERRIDE_CREATUREID = {
		[CREATURE_DREADSTALKERS_WILD_IMPS] = CREATURE_WILD_IMPS,
	};

	-- Creature names that can be used for debugging purposes
	local SUMMONED_CREATURE_NAMES = {
		[CREATURE_DARKGLARE] = "Darkglare",
		[CREATURE_DOOMGUARD] = "Doomguard",
		[CREATURE_DREADSTALKERS] = "Dreadstalker",
		[CREATURE_FELGUARD] = "Felguard",
		[CREATURE_FELHUNTER] = "Felhunter",
		[CREATURE_IMP] = "Imp",
		[CREATURE_INFERNAL] = "Infernal",
		[CREATURE_SUCCUBUS] = "Succubus",
		[CREATURE_VOIDWALKER] = "Voidwalker",
		[CREATURE_WILD_IMPS] = "Wild Imp",
	};

	-- Summon duration for removing from the tracker
	local SUMMONED_CREATURE_DURATIONS = {
		[CREATURE_DARKGLARE] = 12,
		[CREATURE_DOOMGUARD] = 25,
		[CREATURE_DREADSTALKERS] = 12,
		[CREATURE_FELGUARD] = 25,
		[CREATURE_FELHUNTER] = 25,
		[CREATURE_IMP] = 25,
		[CREATURE_INFERNAL] = 25,
		[CREATURE_SUCCUBUS] = 25,
		[CREATURE_VOIDWALKER] = 25,
		[CREATURE_WILD_IMPS] = 12,
	};

	-- Creature UnitIDs to check for summon events
	local CLEU_SUMMON_CREATURES = {
		[CREATURE_DARKGLARE] = true,
		[CREATURE_DOOMGUARD] = true,
		[CREATURE_DREADSTALKERS_WILD_IMPS] = true,
		[CREATURE_FELGUARD] = true,
		[CREATURE_FELHUNTER] = true,
		[CREATURE_IMP] = true,
		[CREATURE_INFERNAL] = true,
		[CREATURE_SUCCUBUS] = true,
		[CREATURE_VOIDWALKER] = true,
		[CREATURE_WILD_IMPS] = true,
	};

	-- Vehicle UnitIDs to check for summon events
	local CLEU_SUMMON_VEHICLES = {
		[CREATURE_DREADSTALKERS] = true,
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
			-- Check to make sure the player is a Demonology Warlock
			returnValue = (currentSpec == addonTable.WARLOCK_DEMONOLOGY) or false;
		end

		return returnValue;
	end

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end

	-- Determines if the data is from an Demonic Empowerment event
	local function isDemonicEmpowerment(sourceIsPlayer, combatEvent, spellID)
		return sourceIsPlayer
		   and combatEvent == "SPELL_CAST_SUCCESS"
		   and spellID == SPELL_DEMONIC_EMPOWERMENT;
	end

	-- Determines if the data is from an Implosion event
	local function isValidImplosion(sourceIsPlayer, combatEvent, spellID)
		return sourceIsPlayer
		   and combatEvent == "SPELL_INSTAKILL"
		   and spellID == SPELL_IMPLOSION;
	end
	
    -- Determines if the summon is valid to track
	local function isValidSummon(sourceIsPlayer, unitType, creatureID)
        return sourceIsPlayer
		   and ((unitType == addonTable.GUID_VEHICLE and CLEU_SUMMON_VEHICLES[tonumber(creatureID)])
			 or (unitType == addonTable.GUID_NPC and CLEU_SUMMON_CREATURES[tonumber(creatureID)]));
    end
	--</private-static-methods>

	--<public-static-methods>
	function trackerDemons:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			local currentTime = GetTime();
			local sourceIsPlayer = isPlayer(sourceFlags);
	
			local unitInfo = LunaEclipse_Scripts:ParseGUID(destGUID);
			local creatureID = SUMMONED_CREATURE_OVERRIDE_CREATUREID[tonumber(unitInfo.CreatureID)] or tonumber(unitInfo.CreatureID);

			local refreshNeeded = false;
			
			if CLEU_UNIT_REMOVED[combatEvent] or isValidImplosion(sourceIsPlayer, combatEvent, spellID) then
				refreshNeeded = self:RemoveDemon(destGUID) or refreshNeeded;
			elseif CLEU_UNIT_SUMMONED[combatEvent] and isValidSummon(sourceIsPlayer, unitInfo.Type, unitInfo.CreatureID) then
				refreshNeeded = self:AddDemon(destGUID, creatureID, currentTime, SUMMONED_CREATURE_DURATIONS[creatureID]) or refreshNeeded;
			elseif isDemonicEmpowerment(sourceIsPlayer, combatEvent, spellID) then
				for ID, data in pairs(summonedDemons) do
					if not data.empowered then
						refreshNeeded = true;
					end

					data.empowered = true;
					data.empoweredEnd = currentTime + 12;
				end
			end    

			if refreshNeeded then
				Ovale.refreshNeeded[playerGUID] = true;
			end
		end
	end

    -- Remove Demons that have despawned, unempower demons no longer empowered.
    function trackerDemons:TimerEvent()
		local refreshNeeded = false;
        local currentTime = GetTime();

        for GUID, data in pairs(summonedDemons) do			
            if currentTime > data.despawnTime then
                refreshNeeded = self:RemoveDemon(GUID) or refreshNeeded;
            elseif data.empoweredEnd and currentTime > data.empoweredEnd then
				data.empowered = nil;
				data.empoweredEnd = nil;

				refreshNeeded = true;
			end
        end

		if refreshNeeded then
			Ovale.refreshNeeded[playerGUID] = true;
		end
    end

	function trackerDemons:AddDemon(GUID, creature, spawn, duration)
		local returnValue = false;

        if not summonedDemons[GUID] then
			returnValue = true;

			if duration then
 				summonedDemons[GUID] = { creatureID = creature, spawnTime = spawn, despawnTime = spawn + duration};
			else
 				summonedDemons[GUID] = { creatureID = creature, spawnTime = spawn};
			end
        end

		return returnValue;
    end

    function trackerDemons:RemoveDemon(GUID)
		local returnValue = false;

        if summonedDemons[GUID] then
			returnValue = true;

            summonedDemons[GUID] = nil;
        end
		
		return returnValue;
    end

	function trackerDemons:OnEnable()
		playerGUID = Ovale.playerGUID;

        if not reaperTimer then
            reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
        end

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

        OvaleState:RegisterState(self, self.statePrototype);
    end

    function trackerDemons:OnDisable()
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
    trackerDemons.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerDemons.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
    statePrototype.DemonActive = function(state, ID, atTime)
		local returnValue = 0;
     
		for GUID, data in pairs(summonedDemons) do
			if (not ID or ID == data.creatureID) and (not data.despawnTime or atTime < data.despawnTime) then
				returnValue = returnValue + 1;
			end
		end

		return returnValue > 0;
	end

    statePrototype.EmpoweredDemonCount = function(state, ID, atTime)
		local returnValue = 0;
     
		for GUID, data in pairs(summonedDemons) do
			if (not ID or ID == data.creatureID) and (not data.despawnTime or atTime < data.despawnTime) and (data.empowered and atTime < data.empoweredEnd) then
				returnValue = returnValue + 1;
			end
		end

		return returnValue or 0;
	end

    statePrototype.RegularDemonCount = function(state, ID, atTime)
		local returnValue = 0;
     
		for GUID, data in pairs(summonedDemons) do
			if (not ID or ID == data.creatureID) and (not data.despawnTime or atTime < data.despawnTime) and (not data.empowered or atTime >= data.empoweredEnd) then
				returnValue = returnValue + 1;
			end
		end
		
		return returnValue or 0;
	end

    statePrototype.TotalDemonCount = function(state, ID, atTime)
		local returnValue = 0;
     
		for GUID, data in pairs(summonedDemons) do
			if (not ID or ID == data.creatureID) and (not data.despawnTime or atTime < data.despawnTime) then
				returnValue = returnValue + 1;
			end
		end

		return returnValue or 0;
	end

    statePrototype.FirstDemonDespawn = function(state, ID, atTime)
		local returnValue = nil;
     
		for GUID, data in pairs(summonedDemons) do
			if (not ID or ID == data.creatureID) and (not data.despawnTime or atTime < data.despawnTime) then
				local remaining = data.despawnTime - atTime;
				
				if not returnValue or remaining < returnValue then
					returnValue = remaining;
				end
			end
		end
		
		return returnValue or 0;
	end

    statePrototype.LastDemonDespawn = function(state, ID, atTime)
		local returnValue = nil;
     
		for GUID, data in pairs(summonedDemons) do
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