local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;
	local trackerUnitID = addonTable.trackerUnitID;

	local moduleName = "trackerRoaringBlaze";
	local trackerRoaringBlaze = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- Warlock SpellID's
	local SPELLID_CONFLAGRATE = 17962;
	local SPELLID_IMMOLATE_AURA = 157736;

	-- Player's GUID.
	local playerGUID = nil;

	-- Table to store GUIDs affected by the tracked spells
	local trackerList = {};

    -- Timer for reaper function to remove inactive enemies.
    local reaperTimer = nil;
    local REAP_INTERVAL = 1;

	-- Events
	-- Table of CLEU events for when a unit is removed from combat
	local CLEU_UNIT_REMOVED = {
		UNIT_DESTROYED = true,
		UNIT_DIED = true,
		UNIT_DISSIPATES = true,
	};

	-- List of CLEU events for applying auras
	local CLEU_DOT_ADDED = {
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_APPLIED_DOSE = true,
		SPELL_AURA_REFRESH = true,
		SPELL_CAST_SUCCESS = true,
	};

	-- List of CLEU events for aura ticks
	local CLEU_DOT_PERIODIC_EVENT = {
		SPELL_PERIODIC_DAMAGE = true,
		SPELL_PERIODIC_HEAL = true,
		SPELL_PERIODIC_ENERGIZE = true,
		SPELL_PERIODIC_DRAIN = true,
		SPELL_PERIODIC_LEECH = true,
	};

	-- List of CLEU events for removing auras
	local CLEU_DOT_REMOVED = {
		SPELL_AURA_REMOVED = true,
		SPELL_AURA_REMOVED_DOSE = true,
		SPELL_AURA_BROKEN = true,
		SPELL_AURA_BROKEN_SPELL = true,
	};

	-- List of CLEU events for spell damage
	local CLEU_SPELL_DAMAGE = {
		SPELL_DAMAGE = true,
	};
	--</private-static-properties>

	--<private-static-methods>
	-- Functions to determine whether the module should work
	local function useModule()
		-- Default to not using the module
		local returnValue = false;
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();

		-- Check to make sure the player has a specialization
		if currentSpec then
			-- Get talent info for Roaring Blaze
			local talentID, name, texture, selected, available = GetTalentInfo(1, 2, GetActiveSpecGroup());

			-- Check to make sure the player is a Destruction Warlock and has Roaring Blaze selected
			returnValue = (currentSpec == addonTable.WARLOCK_DESTRUCTION and selected) or false;
		end
		
		return returnValue;
	end

    local function wipeData()
        trackerList = {};
    end

	-- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerRoaringBlaze:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
		if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			local currentTime = GetTime();
			local sourceIsPlayer = isPlayer(sourceFlags);

			if CLEU_UNIT_REMOVED[combatEvent] and trackerList[destGUID] then
				trackerList[destGUID] = nil;
			elseif sourceIsPlayer then
				if spellID == SPELLID_IMMOLATE_AURA and (CLEU_DOT_ADDED[combatEvent] or CLEU_DOT_PERIODIC_EVENT[combatEvent]) then
					local spellName, spellRank = GetSpellInfo(spellID);
					local unitID = trackerUnitID:ConvertToUnitID(destGUID);

					if unitID then
						local duration, expirationTime = select(6, UnitDebuff(unitID, spellName, spellRank, "PLAYER"));

						if duration and expirationTime then
							if not trackerList[destGUID] or (trackerList[destGUID] and trackerList[destGUID].expiration < currentTime) then
								trackerList[destGUID] = { expiration = expirationTime, stacks = 0 };
							end
						end
					end
				elseif spellID == SPELLID_IMMOLATE_AURA and CLEU_DOT_REMOVED[combatEvent] and trackerList[destGUID] then
					trackerList[destGUID] = nil;
				elseif spellID == SPELLID_CONFLAGRATE and CLEU_SPELL_DAMAGE[combatEvent] and trackerList[destGUID] then
					trackerList[destGUID].stacks = trackerList[destGUID].stacks + 1;
				end
			end
		end
	end

    function trackerRoaringBlaze:PLAYER_REGEN_DISABLED()
        -- Reset tracking when combat starts.
        wipeData();
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    end

    function trackerRoaringBlaze:PLAYER_REGEN_ENABLED()
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    end

    -- Remove any information for roaring blaze on targets where it has expired.
    function trackerRoaringBlaze:TimerEvent()
		local refreshNeeded = false;
        local currentTime = GetTime();

        for GUID, data in pairs(trackerList) do			
            if currentTime > data.expiration then
                trackerList[GUID] = nil;
				refreshNeeded = true;
			end
        end

		if refreshNeeded then
			Ovale.refreshNeeded[playerGUID] = true;
		end
    end

	function trackerRoaringBlaze:OnEnable()
		playerGUID = Ovale.playerGUID;

        if not reaperTimer then
            reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
        end

        self:RegisterEvent("PLAYER_REGEN_ENABLED");
        self:RegisterEvent("PLAYER_REGEN_DISABLED");

        OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerRoaringBlaze:OnDisable()
        OvaleState:UnregisterState(self);

        if reaperTimer then
            self:CancelTimer(reaperTimer);
            reaperTimer = nil;
        end

        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:UnregisterEvent("PLAYER_REGEN_ENABLED");
        self:UnregisterEvent("PLAYER_REGEN_DISABLED");
	end
	--</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    trackerRoaringBlaze.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerRoaringBlaze.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns the True/False depending on if there is a Roaring Blaze count.
	statePrototype.RoaringBlazeActive = function(state, destGUID, atTime)
		local returnValue = 0;
		
		if destGUID and trackerList[destGUID] and atTime < trackerList[destGUID].expiration then
			returnValue = trackerList[destGUID].stacks;
		end

		return returnValue > 0;
	end

	-- This returns the Roaring Blaze time remaining in seconds, or 0.
	statePrototype.RoaringBlazeTimeRemaining = function(state, destGUID, atTime)
		local returnValue = 0;
		
		if destGUID and trackerList[destGUID] and atTime < trackerList[destGUID].expiration and trackerList[destGUID].stacks > 0 then
			returnValue = trackerList[destGUID].expiration - atTime;
		end

		return returnValue;
	end

	-- This returns the Roaring Blaze count, or 0.
	statePrototype.RoaringBlazeStacks = function(state, destGUID, atTime)
		local returnValue = 0;
		
		if destGUID and trackerList[destGUID] and atTime < trackerList[destGUID].expiration then
			returnValue = trackerList[destGUID].stacks;
		end

		return returnValue;
	end
    --</public-static-methods>
end