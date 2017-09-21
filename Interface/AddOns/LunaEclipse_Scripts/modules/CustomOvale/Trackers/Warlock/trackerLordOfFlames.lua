local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerLordOfFlames";
	local trackerLordOfFlames = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- SpellID information
	local LORD_OF_FLAMES_BUFF = 226802;
	local INTERNAL_COOLDOWN = 600;

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

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerLordOfFlames:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local characterProfile = addonTable.characterSettings.profile;

			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			local currentTime = GetTime();
			local sourceIsPlayer = isPlayer(sourceFlags);

			if sourceIsPlayer and combatEvent == "SPELL_AURA_APPLIED" and spellID == LORD_OF_FLAMES_BUFF then
				cooldownEnd = currentTime + INTERNAL_COOLDOWN;
				characterProfile.Trackers.trackerLordOfFlames.cooldownEnd = cooldownEnd;
			end
		end
	end

	function trackerLordOfFlames:TimerEvent()
		local characterProfile = addonTable.characterSettings.profile;
		local currentTime = GetTime();

		if cooldownEnd > 0 and cooldownEnd < currentTime then
			cooldownEnd = 0;
			characterProfile.Trackers.trackerLordOfFlames.cooldownEnd = cooldownEnd;
		end
	end

	function trackerLordOfFlames:OnEnable()
		local characterProfile = addonTable.characterSettings.profile;

		playerGUID = Ovale.playerGUID;
		cooldownEnd = characterProfile.Trackers.trackerLordOfFlames.cooldownEnd;

		if not reaperTimer then
			reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
		end
	
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

        OvaleState:RegisterState(self, self.statePrototype);
    end

    function trackerLordOfFlames:OnDisable()
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
    trackerLordOfFlames.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerLordOfFlames.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
    -- Returns the number of seconds remaining on the Internal Cooldown, returns 0 if not on cooldown
	statePrototype.LordOfFlamesCooldown = function(state, atTime)
		return (atTime < cooldownEnd and cooldownEnd - atTime) or 0;
	end
    --</public-static-methods>
end