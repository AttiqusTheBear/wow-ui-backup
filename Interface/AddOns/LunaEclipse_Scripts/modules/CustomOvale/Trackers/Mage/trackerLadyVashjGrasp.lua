local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerLadyVashjGrasp";
	local trackerLadyVashjGrasp = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- AuraID
	local AURA_LADY_VASHJ_GRASP = 208147;

	-- AuraID to track
	local CLEU_TRACK_SPELLID = {
		[AURA_LADY_VASHJ_GRASP] = true,
	};

	-- List of CLEU events for applying auras
	local CLEU_AURA_ADDED = {
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_APPLIED_DOSE = true,
		SPELL_AURA_REFRESH = true,
		SPELL_CAST_SUCCESS = true,
	};

	-- List of CLEU events for removing auras
	local CLEU_AURA_REMOVED = {
		SPELL_AURA_REMOVED = true,
		SPELL_AURA_REMOVED_DOSE = true,
		SPELL_AURA_BROKEN = true,
		SPELL_AURA_BROKEN_SPELL = true,
	};

	-- Time at which Lady Vashj Grasp aura was gained, nil if not active.
	local auraGained = nil;

    -- Player's GUID.
	local playerGUID = nil;
	--</private-static-properties>

	--<private-static-methods>
	-- Functions to determine whether the module should work
	local function useModule()
		-- Default to not using the module
		local returnValue = false;
		local playerClass = LunaEclipse_Scripts:GetClass();
	
		-- Check to make sure the player has a class information
		if playerClass then
			-- Check to make sure the player is a Mage
			returnValue = (playerClass == addonTable.CLASS_MAGE) or false;
		end

		return returnValue;
	end

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerLadyVashjGrasp:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			
			local sourceIsPlayer = isPlayer(sourceFlags);
			local currentTime = GetTime();

			if CLEU_TRACK_SPELLID[spellID] then
				if CLEU_AURA_ADDED[combatEvent] then
					auraGained = currentTime;			
				elseif CLEU_AURA_REMOVED[combatEvent] then
					auraGained = nil;
				end
			end
		end
	end

	function trackerLadyVashjGrasp:OnEnable()
		playerGUID = Ovale.playerGUID;
		
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerLadyVashjGrasp:OnDisable()
        OvaleState:UnregisterState(self);

		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	end
	--</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    trackerLadyVashjGrasp.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerLadyVashjGrasp.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns whether Lady Vashj Grasp is currently active.
	statePrototype.LVGActive = function(state)
		return auraGained ~= nil;
	end
	
	-- This returns the number of seconds since the last finger of frost from Lady Vashj Grasp.
	statePrototype.LVGLastFoF = function(state, atTime)
		return (auraGained and (atTime - auraGained) % 10) or nil;
	end

	-- This returns the number of seconds until the next finger of frost from Lady Vashj Grasp.
	statePrototype.LVGNextFoF = function(state, atTime)
		return (auraGained and 10 - ((atTime - auraGained) % 10)) or nil;
	end
   --</public-static-methods>
end