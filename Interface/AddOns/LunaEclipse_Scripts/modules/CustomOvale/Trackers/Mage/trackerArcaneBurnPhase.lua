local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerArcaneBurnPhase";
	local trackerArcaneBurnPhase = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");
	Ovale.trackerArcaneBurnPhase = trackerArcaneBurnPhase;

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;
	local OvaleArtifact = Ovale.OvaleArtifact;
	local OvaleEquipment = Ovale.OvaleEquipment;
	local OvaleHealth = Ovale.OvaleHealth;

	-- SpellIDs
	local SPELLID_ARCANE_POWER = 12042;
	local SPELLID_EVOCATION = 12051;
	local SPELLID_PRESENCE_OF_MIND = 205025;
	local SPELLID_RUNE_OF_POWER = 116011;

	-- TraitIDs
	local TRAIT_AEGWYNNS_IMPERATIVE = 187264;

	-- Base Durations
	local ARCANE_POWER_DURATION = 10;

	-- List of CLEU events for applying auras
	local CLEU_AURA_ADDED = {
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_APPLIED_DOSE = true,
		SPELL_AURA_REFRESH = true,
		SPELL_CAST_SUCCESS = true,
	};

    -- Player's GUID.
	local playerGUID = nil;

	-- Variable to store burn phase information
	local burnPhase = false;
	local startBurnPhase = 0;
	local startManaPercent = 100;

	local totalTime = 0;
	local countBurnPhases = 0;

	local averageBurnPhaseTime = 0;
	local lastBurnPhaseTime = 0;

	local percentMana = 100;

	-- Timer for function to check if should use arcane burn.
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
			-- Check to make sure the player is an Arcane Mage
			returnValue = (currentSpec == addonTable.MAGE_ARCANE) or false;
		end

		return returnValue;
	end

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end

	-- Internal function to round a number to x decimal places
	local function roundNumber(num, numDecimalPlaces)
		local mult = 10^(numDecimalPlaces or 0);
  
		return math.floor(num * mult + 0.5) / mult;
	end

	local function calculateManaPercent()
		local currentMana = UnitPower("player", SPELL_POWER_MANA);
		local maxMana = UnitPowerMax("player", SPELL_POWER_MANA);

		return roundNumber((currentMana / maxMana) * 100, 2);
	end

	local function getCooldown(spellID)
		local returnValue = 0;
		
		local currentCharges, maxCharges, cooldownStart, cooldownDuration = GetSpellCharges(spellID);
		
		if not maxCharges then
			cooldownStart, cooldownDuration = GetSpellCooldown(spellID);
			currentCharges = (cooldownStart == 0 and cooldownDuration == 0 and 1) or 0;
			maxCharges = 1;
		end	
		
		if cooldownStart > 0 and cooldownDuration > 0 then
			returnValue = (cooldownStart + cooldownDuration) - GetTime();
		end
		
		return currentCharges, maxCharges, math.max(returnValue, 0);	
	end

	local function getSavedInfo()
		local characterProfile = addonTable.characterSettings.profile;

		burnPhase = characterProfile.Trackers.trackerArcaneBurnPhase.burnPhase;
		startBurnPhase = characterProfile.Trackers.trackerArcaneBurnPhase.startBurnPhase;
		startManaPercent = characterProfile.Trackers.trackerArcaneBurnPhase.startManaPercent;

		totalTime = characterProfile.Trackers.trackerArcaneBurnPhase.totalTime;
		countBurnPhases = characterProfile.Trackers.trackerArcaneBurnPhase.countBurnPhases;

		averageBurnPhaseTime = characterProfile.Trackers.trackerArcaneBurnPhase.averageBurnPhaseTime;
		lastBurnPhaseTime = characterProfile.Trackers.trackerArcaneBurnPhase.lastBurnPhaseTime;
	end

	local function setSavedInfo(fullSave)
		local characterProfile = addonTable.characterSettings.profile;

		if fullSave then
			characterProfile.Trackers.trackerArcaneBurnPhase.burnPhase = burnPhase;
			characterProfile.Trackers.trackerArcaneBurnPhase.startBurnPhase = startBurnPhase;
			characterProfile.Trackers.trackerArcaneBurnPhase.startManaPercent = startManaPercent;

			characterProfile.Trackers.trackerArcaneBurnPhase.totalTime = totalTime;
			characterProfile.Trackers.trackerArcaneBurnPhase.countBurnPhases = countBurnPhases;

			characterProfile.Trackers.trackerArcaneBurnPhase.averageBurnPhaseTime = averageBurnPhaseTime;
			characterProfile.Trackers.trackerArcaneBurnPhase.lastBurnPhaseTime = lastBurnPhaseTime;
		else
			characterProfile.Trackers.trackerArcaneBurnPhase.burnPhase = burnPhase;
			characterProfile.Trackers.trackerArcaneBurnPhase.startBurnPhase = startBurnPhase;
		end
	end

	local function endBurn(currentTime, recordBurn)
		if burnPhase then
			if recordBurn then
				burnPhase = false;

				-- Adjust the last burn phase duration to an estimate based mana starting percent
				lastBurnPhaseTime = ((currentTime - startBurnPhase) / startManaPercent) * 100;
				startBurnPhase = 0;

				totalTime = totalTime + lastBurnPhaseTime;
				countBurnPhases = countBurnPhases + 1;
				averageBurnPhaseTime = totalTime / countBurnPhases;		
			else
				burnPhase = false;
				startBurnPhase = 0;
			end

			setSavedInfo(recordBurn);
		end
	end

	local function startBurn(currentTime)
		if not burnPhase then
			startBurnPhase = currentTime;
			startManaPercent = calculateManaPercent();

			burnPhase = true;

			setSavedInfo();
		end
	end

	local function calculateTimeToBurn()
		local returnValue = 0;
		local manaPercent = calculateManaPercent() / 100;
		local expectedBurnPhase = averageBurnPhaseTime * manaPercent;
		local durationArcanePower = ARCANE_POWER_DURATION + (OvaleArtifact:TraitRank(TRAIT_AEGWYNNS_IMPERATIVE) or 0);

		local _, _, cooldownArcanePower = getCooldown(SPELLID_ARCANE_POWER);
		local evocationCharges, _, cooldownEvocation = getCooldown(SPELLID_EVOCATION);
		
		if evocationCharges == 2 then
			returnValue = 0;
		elseif evocationCharges == 1 then
			returnValue = math.max((cooldownArcanePower - expectedBurnPhase) + durationArcanePower, 0);
		elseif evocationCharges == 0 then
			returnValue = math.max(cooldownArcanePower, cooldownEvocation - expectedBurnPhase);
		end

		if OvaleEquipment:GetArmorSetCount("T20") >= 4 then
			local _, _, cooldownPoM = getCooldown(SPELLID_PRESENCE_OF_MIND);

			returnValue = math.max(cooldownPoM, returnValue);
		end

		if select(4, GetTalentInfo(3, 2, GetActiveSpecGroup())) then
			local chargesRoP, _, cooldownRoP = getCooldown(SPELLID_RUNE_OF_POWER);

			if chargesRoP == 0 then
				returnValue = math.max(cooldownRoP, returnValue);
			end
		end

		local timeToDie = OvaleHealth:UnitTimeToDie("target");

		if timeToDie < returnValue then
			returnValue = 0;
		end

		return returnValue;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerArcaneBurnPhase:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			
			local sourceIsPlayer = isPlayer(sourceFlags);
			local currentTime = GetTime();
		
			if sourceIsPlayer and CLEU_AURA_ADDED[combatEvent] and spellID == SPELLID_EVOCATION then				
				endBurn(currentTime, true);
				
				if not burnPhase and calculateTimeToBurn() == 0 then
					startBurn(currentTime);
				end
			end
		end
	end

    function trackerArcaneBurnPhase:PLAYER_REGEN_DISABLED()
		local currentTime = GetTime();

		if not burnPhase and calculateTimeToBurn() == 0 then
			startBurn(currentTime);
		end

		if not reaperTimer then
			reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
		end
    end

    function trackerArcaneBurnPhase:PLAYER_REGEN_ENABLED()
		-- Burn Phase ended because player left combat.
		-- Don't record time because it likely shorter then normal.
		local currentTime = GetTime();

		endBurn(currentTime);

		if reaperTimer then
			self:CancelTimer(reaperTimer);
			reaperTimer = nil;
		end
    end

	function trackerArcaneBurnPhase:TimerEvent()
		local currentTime = GetTime();

		if not burnPhase and calculateTimeToBurn() == 0 then
			startBurn(currentTime);
		end
	end

	function trackerArcaneBurnPhase:OnEnable()
		playerGUID = Ovale.playerGUID;
		
		getSavedInfo();

		if LunaEclipse_Scripts:InCombat() then
			self:PLAYER_REGEN_DISABLED();
		end

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:RegisterEvent("PLAYER_REGEN_DISABLED");
        self:RegisterEvent("PLAYER_REGEN_ENABLED");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerArcaneBurnPhase:OnDisable()
        OvaleState:UnregisterState(self);

		if reaperTimer then
			self:CancelTimer(reaperTimer);
			reaperTimer = nil;
		end

		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:UnregisterEvent("PLAYER_REGEN_DISABLED");
        self:UnregisterEvent("PLAYER_REGEN_ENABLED");
	end
	--</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    trackerArcaneBurnPhase.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerArcaneBurnPhase.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns whether the arcane burn phase is active or not.
	statePrototype.ArcaneBurnActive = function(state)
		return burnPhase or false;
	end

	-- This returns the average length of time of a burn phase based on all previous burn phases.
	statePrototype.ArcaneAverageBurnTime = function(state)
		return averageBurnPhaseTime or 0;
	end

	-- This returns how long a burn phase is expected to last based on current mana percentage.
	statePrototype.ArcaneExpectedBurnTime = function(state)
		local manaPercent = calculateManaPercent() / 100;

		return (averageBurnPhaseTime * manaPercent) or 0;
	end

	-- This returns the length of time the last burn phase lasted, this is adjust to 100% mana based on time for actual mana.
	statePrototype.ArcaneLastBurnTime = function(state)
		return lastBurnPhaseTime or 0;
	end
   --</public-static-methods>
end