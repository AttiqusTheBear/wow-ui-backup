local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerChannelling";
	local trackerChannelling = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	Ovale.trackerChannelling = trackerChannelling;

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- SpellIDs
	local SPELLID_MIND_FLAY = 15407;

	-- Tracked Spells
	local CLEU_TRACK_SPELLID = {
		[SPELLID_MIND_FLAY] = 4,
	};

    -- Player's GUID.
	local playerGUID = nil;

	-- Tick Info
	local totalTicks = {};
	local currentTick = {};
	local ticksRemaining = {};

	--<private-static-methods>
    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerChannelling:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
		local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;

		local sourceIsPlayer = isPlayer(sourceFlags);
		local destIsPlayer = isPlayer(destFlags);
		local currentTime = GetTime();

		if sourceIsPlayer and not destIsPlayer and CLEU_TRACK_SPELLID[spellID] then
			totalTicks[spellID] = totalTicks[spellID] or CLEU_TRACK_SPELLID[spellID];
			currentTick[spellID] = currentTick[spellID] or 0;
			ticksRemaining[spellID] = ticksRemaining[spellID] or totalTicks[spellID];

			if combatEvent == "SPELL_AURA_APPLIED" then					
				totalTicks[spellID] = CLEU_TRACK_SPELLID[spellID];
				currentTick[spellID] = 0;
				ticksRemaining[spellID] = totalTicks[spellID];
			elseif combatEvent == "SPELL_AURA_REFRESH" then					
				totalTicks[spellID] = math.min(CLEU_TRACK_SPELLID[spellID] + ticksRemaining[spellID], CLEU_TRACK_SPELLID[spellID] * 1.5);
				currentTick[spellID] = 0;
				ticksRemaining[spellID] = totalTicks[spellID] - currentTick[spellID];
			elseif combatEvent == "SPELL_PERIODIC_DAMAGE" then
				currentTick[spellID] = currentTick[spellID] + 1;
				ticksRemaining[spellID] = ticksRemaining[spellID] - 1;
			elseif combatEvent == "SPELL_AURA_REMOVED" then
				totalTicks[spellID] = nil;
				currentTick[spellID] = nil;
				ticksRemaining[spellID] = nil;
			end
		end
	end

	function trackerChannelling:OnEnable()
		playerGUID = Ovale.playerGUID;
		
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerChannelling:OnDisable()
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
    trackerChannelling.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerChannelling.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns the current number of ticks elapsed in the current channel, returns 0 if not currently channelling the spellID.
	statePrototype.CurrentChannelTick = function(state, spellID)
		return currentTick[spellID] or 0;
	end

	-- This returns the remaining number of ticks in the current channel, returns 0 if not currently channelling the spellID.
	statePrototype.RemainingChannelTick = function(state, spellID)
		return ticksRemaining[spellID] or 0;
	end

	-- This returns the total number of ticks for the current channel, returns 0 if not currently channelling the spellID.
	statePrototype.TotalChannelTick = function(state, spellID)
		return totalTicks[spellID] or 0;
	end
   --</public-static-methods>
end