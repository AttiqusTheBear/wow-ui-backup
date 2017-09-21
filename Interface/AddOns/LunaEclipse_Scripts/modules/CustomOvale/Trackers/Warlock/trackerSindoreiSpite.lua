local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerSindoreiSpite";
	local trackerSindoreiSpite = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- SpellID information
	local SINDOREI_SPITE_BUFF = 208871;
	local INTERNAL_COOLDOWN = 180;

    -- Player's GUID.
	local playerGUID = nil;

	-- Variable to store when cooldown ends
	local cooldownEnd = 0;

	-- Timer for reaper function to remove cooldown information once it is off cooldown.
	local reaperTimer = nil;
	local REAP_INTERVAL = 1;

	--<private-static-methods>
	-- Functions to determine whether the module should work
	local function useModule()
		-- Default to not using the module
		local returnValue = false;
		local classID = LunaEclipse_Scripts:GetClass();
	
		if classID then
			-- Check to make sure the player is a Warlock
			returnValue = (classID == addonTable.CLASS_WARLOCK) or false;
		end

		return returnValue;
	end

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerSindoreiSpite:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local characterProfile = addonTable.characterSettings.profile;

			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			local currentTime = GetTime();
			local sourceIsPlayer = isPlayer(sourceFlags);

			if sourceIsPlayer and combatEvent == "SPELL_AURA_APPLIED" and spellID == SINDOREI_SPITE_BUFF then
				cooldownEnd = currentTime + INTERNAL_COOLDOWN;
				characterProfile.Trackers.trackerSindoreiSpite.cooldownEnd = cooldownEnd;
			end
		end
	end

	function trackerSindoreiSpite:TimerEvent()
		local characterProfile = addonTable.characterSettings.profile;
		local currentTime = GetTime();

		if cooldownEnd > 0 and cooldownEnd < currentTime then
			cooldownEnd = 0;
			characterProfile.Trackers.trackerSindoreiSpite.cooldownEnd = cooldownEnd;
		end
	end

	function trackerSindoreiSpite:OnEnable()
		local characterProfile = addonTable.characterSettings.profile;

		playerGUID = Ovale.playerGUID;
		cooldownEnd = characterProfile.Trackers.trackerSindoreiSpite.cooldownEnd;

		if not reaperTimer then
			reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
		end
	
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

        OvaleState:RegisterState(self, self.statePrototype);
    end

    function trackerSindoreiSpite:OnDisable()
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
    trackerSindoreiSpite.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerSindoreiSpite.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
    -- Returns the number of seconds remaining on the Internal Cooldown, returns 0 if not on cooldown
	statePrototype.SindoreiSpiteCooldown = function(state, atTime)
		return (atTime < cooldownEnd and cooldownEnd - atTime) or 0;
	end
    --</public-static-methods>
end