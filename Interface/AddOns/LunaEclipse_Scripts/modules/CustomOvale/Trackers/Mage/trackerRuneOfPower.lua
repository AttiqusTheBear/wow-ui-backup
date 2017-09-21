local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerRuneOfPower";
	local trackerRuneOfPower = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- SpellIDs
	local SPELLID_RUNE_OF_POWER = 116011;
	
	-- BuffIDs
	local AURA_RUNE_OF_POWER = 116014;

	-- Rune of Power Duration
	local RUNE_OF_POWER_DURATION = 10;
	
	-- SpellIDs to track.
	local CLEU_TRACK_SPELLID = {
		[SPELLID_RUNE_OF_POWER] = true,
	};

    -- Table of CLEU events for when a spell is finished casting.
    local CLEU_SPELLCAST_FINISHED = {
        SPELL_CAST_SUCCESS = true,
    };

    -- Player's GUID.
	local playerGUID = nil;
	
	-- Variables to store information about the Rune of Power.
	local runeActive = false;
	local runeExpires = 0;

	-- Timer for removing rune of power.
	local reaperTimer = nil;	
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
	function trackerRuneOfPower:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			
			local sourceIsPlayer = isPlayer(sourceFlags);
			local currentTime = GetTime();

			if sourceIsPlayer and CLEU_SPELLCAST_FINISHED[combatEvent] and CLEU_TRACK_SPELLID[spellID] then
				runeActive = true;
				runeExpires = currentTime + RUNE_OF_POWER_DURATION;
				
				if reaperTimer then
					self:CancelTimer(reaperTimer, true);
					reaperTimer = nil;
				end

				reaperTimer = self:ScheduleTimer("TimerEvent", RUNE_OF_POWER_DURATION);
			end
		end
	end

	function trackerRuneOfPower:TimerEvent()
		runeActive = false;
		runeExpires = 0;
		reaperTimer = nil;
	end

	function trackerRuneOfPower:OnEnable()
		playerGUID = Ovale.playerGUID;
		
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerRuneOfPower:OnDisable()
        OvaleState:UnregisterState(self);

		if reaperTimer then
			self:CancelTimer(reaperTimer);
			
			runeActive = false;
			runeExpires = 0;
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
    trackerRuneOfPower.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerRuneOfPower.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns whether the Rune of Power has been placed.
	statePrototype.RuneActive = function(state, atTime)
		return (runeActive and atTime < runeExpires) or false;
	end

 	-- This returns if the player currently is benefiting from the Rune of Power buff.
	statePrototype.RuneBuff = function(state)
		local spellName = GetSpellInfo(AURA_RUNE_OF_POWER);
		
		return UnitBuff("player", spellName, nil, "player");
	end

	-- This returns how many seconds is left before the Rune of Power disappears.
	statePrototype.RuneTimeRemaining = function(state, atTime)
		return (runeActive and atTime < runeExpires and runeExpires - atTime) or 0;
	end
   --</public-static-methods>
end