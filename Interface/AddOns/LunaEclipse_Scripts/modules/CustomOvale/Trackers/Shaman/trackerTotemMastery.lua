local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerTotemMastery";
	local trackerTotemMastery = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- SpellIDs
	local SPELLID_TOTEM_MASTERY = 210643;

	-- AuraIDs
	local AURA_EMBER_TOTEM = 210658;
	local AURA_RESONANCE_TOTEM = 202192;
	local AURA_STORM_TOTEM = 210652;
	local AURA_TAILWIND_TOTEM = 210659;

	-- Totem Mastery Duration
	local TOTEM_MASTERY_DURATION = 120;

	-- SpellIDs to track.
	local CLEU_TRACK_SPELLID = {
		[SPELLID_TOTEM_MASTERY] = true,
	};

    -- Table of CLEU events for when a spell is finished casting.
    local CLEU_SPELLCAST_FINISHED = {
        SPELL_CAST_SUCCESS = true,
    };

    -- Player's GUID.
	local playerGUID = nil;
	
	-- Variables to store information about the Totem Mastery Totems.
	local totemActive = false;
	local totemExpires = 0;

	-- Timer for removing totems.
	local reaperTimer = nil;
	local REAP_INTERVAL = 1;

	--</private-static-properties>

	--<private-static-methods>
	-- Functions to determine whether the module should work
	local function useModule()
		-- Default to not using the module
		local returnValue = false;
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();
	
		-- Check to make sure the player has a specialization
		if currentSpec then
			-- Check to make sure the player is an Elemental Shaman
			returnValue = (currentSpec == addonTable.SHAMAN_ELEMENTAL) or false;
		end

		return returnValue;
	end

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerTotemMastery:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			
			local sourceIsPlayer = isPlayer(sourceFlags);
			local currentTime = GetTime();

			if sourceIsPlayer and CLEU_SPELLCAST_FINISHED[combatEvent] and CLEU_TRACK_SPELLID[spellID] then
				totemActive = true;
				totemExpires = currentTime + TOTEM_MASTERY_DURATION;

				if reaperTimer then
					self:CancelTimer(reaperTimer);
					reaperTimer = nil;
				end

				reaperTimer = self:ScheduleTimer("TimerEvent", TOTEM_MASTERY_DURATION);
			end
		end
	end

	function trackerTotemMastery:TimerEvent()
		totemActive = false;
		totemExpires = 0;
		reaperTimer = nil;
	end

	function trackerTotemMastery:OnEnable()
		playerGUID = Ovale.playerGUID;
		
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerTotemMastery:OnDisable()
        OvaleState:UnregisterState(self);

		if reaperTimer then
			self:CancelTimer(reaperTimer);
			
			totemActive = false;
			totemExpires = 0;
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
    trackerTotemMastery.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerTotemMastery.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns whether the Totem Mastery Totems has been placed.
	statePrototype.TotemsActive = function(state, atTime)
		return (totemActive and atTime < totemExpires) or false;
	end

 	-- This returns if the player currently is benefiting from the Totem Mastery Totems buffs.
	statePrototype.TotemsBuff = function(state)
		local emberTotem = GetSpellInfo(AURA_EMBER_TOTEM);
		local resonanceTotem = GetSpellInfo(AURA_RESONANCE_TOTEM);
		local stormTotem = GetSpellInfo(AURA_STORM_TOTEM);
		local tailwindTotem = GetSpellInfo(AURA_TAILWIND_TOTEM);

		local activeEmberTotem = UnitBuff("player", emberTotem, nil, "player");
		local activeResonanceTotem = UnitBuff("player", resonanceTotem, nil, "player");
		local activeStormTotem = UnitBuff("player", stormTotem, nil, "player");
		local activeTailwindTotem = UnitBuff("player", tailwindTotem, nil, "player");

		return activeEmberTotem and activeResonanceTotem and activeStormTotem and activeTailwindTotem;
	end

	-- This returns how many seconds is left before the Totem Mastery Totems disappears.
	statePrototype.TotemsTimeRemaining = function(state, atTime)
		return (totemActive and atTime < totemExpires and totemExpires - atTime) or 0;
	end
   --</public-static-methods>
end