local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerShadowyApparitions";
	local trackerShadowyApparitions = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- SpellIDs
	local SPELLID_SHADOWY_APPARITION_CREATE = 147193;
	local SPELLID_SHADOWY_APPARITION_IMPACT = 148859;

	-- Tables of Spells to track.
	local CLEU_TRACKED_SPELLS_CREATE = {
		[SPELLID_SHADOWY_APPARITION_CREATE] = true,
	};

	local CLEU_TRACKED_SPELLS_IMPACT = {
		[SPELLID_SHADOWY_APPARITION_IMPACT] = true,
	};

	-- Events
	-- Table of CLEU events for when a unit is removed from combat
	local CLEU_UNIT_REMOVED = {
		UNIT_DESTROYED = true,
		UNIT_DIED = true,
		UNIT_DISSIPATES = true,
	};

	-- List of CLEU events for applying auras
	local CLEU_SPIRIT_CREATE = {
		SPELL_CAST_SUCCESS = true,
	};

	-- List of CLEU events for aura ticks
	local CLEU_SPIRIT_IMPACT = {
		SPELL_DAMAGE = true,
	};

    -- Player's GUID.
	local playerGUID = nil;
	
	-- Stores the Shadowy Apparitions
	local targetApparitions = {};
	local totalApparitions = 0;

	-- Timer.
	local reaperTimer = nil;
	local REAP_INTERVAL = 1;

	local inactivePeriod = 10;
	--</private-static-properties>

	--<private-static-methods>
	-- Functions to determine whether the module should work
	local function useModule()
		-- Default to not using the module
		local returnValue = false;
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();
	
		-- Check to make sure the player has a specialization
		if currentSpec then
			-- Check to make sure the player is a Shadow Priest
			returnValue = (currentSpec == addonTable.PRIEST_SHADOW) or false;
		end

		return returnValue;
	end

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end

	-- Function to add new targets that have no data, does nothing if data already exists
	local function addTarget(destGUID)
		if not targetApparitions[destGUID] then
			targetApparitions[destGUID] = {};
			targetApparitions[destGUID].Count = 0;
		end
	end

	-- Function to remove targets when they die or have been inactive for set period of time.
	local function removeTarget(destGUID)
		if targetApparitions[destGUID] and targetApparitions[destGUID].Count > 0 then
			totalApparitions = totalApparitions - targetApparitions[destGUID].Count;
		end
				
		targetApparitions[destGUID] = nil;
	end

	-- Add Spirit, create the target data if necessary
	local function addSpirit(destGUID, currentTime)
		addTarget(destGUID);

		targetApparitions[destGUID].Count = targetApparitions[destGUID].Count + 1;
		targetApparitions[destGUID].LastUpdate = currentTime;

		totalApparitions = totalApparitions + 1;
	end

	-- Remove Spirit when it causes damage
	local function removeSpirit(destGUID, currentTime)
		if targetApparitions[destGUID] and targetApparitions[destGUID].Count > 0 then   
			targetApparitions[destGUID].Count = targetApparitions[destGUID].Count - 1;
			targetApparitions[destGUID].LastUpdate = currentTime;
                
			if targetApparitions[destGUID].Count < 1 then
				removeTarget(destGUID);
			end
		end

		totalApparitions = totalApparitions - 1;
	end

	local function wipeData()
		wipe(targetApparitions);
		targetApparitions = {};
		totalApparitions = 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerShadowyApparitions:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			
			local sourceIsPlayer = isPlayer(sourceFlags);
			local destIsPlayer = isPlayer(destFlags);
			local currentTime = GetTime();

			if CLEU_UNIT_REMOVED[combatEvent] then
				if destIsPlayer then
					wipeData();
				else
					removeTarget(destGUID);
				end
			elseif sourceIsPlayer then
				if CLEU_SPIRIT_CREATE[combatEvent] and CLEU_TRACKED_SPELLS_CREATE[spellID] then
					addSpirit(destGUID, currentTime);
				elseif CLEU_SPIRIT_IMPACT[combatEvent] and CLEU_TRACKED_SPELLS_IMPACT[spellID] then
					removeSpirit(destGUID, currentTime);
				end
			end
		end
	end

    function trackerShadowyApparitions:PLAYER_REGEN_ENABLED()
		-- Combat has ended so wipe all stored data.
		wipeData();
	end

	function trackerShadowyApparitions:TimerEvent()
		local currentTime = GetTime();
	
		for destGUID, data in pairs(targetApparitions) do
			if data.LastUpdate and currentTime - data.LastUpdate > inactivePeriod then
				removeTarget(destGUID);
			end
		end
	end

	function trackerShadowyApparitions:OnEnable()
		playerGUID = Ovale.playerGUID;
		
		if not reaperTimer then
			reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
		end

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:RegisterEvent("PLAYER_REGEN_ENABLED");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerShadowyApparitions:OnDisable()
        OvaleState:UnregisterState(self);

		if reaperTimer then
			self:CancelTimer(reaperTimer);
			reaperTimer = nil;
		end

		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:UnregisterEvent("PLAYER_REGEN_ENABLED");
	end
	--</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    trackerShadowyApparitions.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerShadowyApparitions.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns the number of shadowy apparitions on a particular target.
	statePrototype.TargetShadowyApparitions = function(state, destGUID)
		return (targetApparitions[destGUID] and targetApparitions[destGUID].Count) or 0;
	end

	-- This returns the total number of shadowy apparitions on all targets.
	statePrototype.TotalShadowyApparitions = function(state)
		return totalApparitions;
	end
   --</public-static-methods>
end