local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;
	local trackerUnitID = addonTable.trackerUnitID;

	local moduleName = "trackerFeralBleeds";
	local trackerFeralBleeds = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- Buffs affecting the damage multiplier
	local BUFF_BLOODTALONS = 145152;
	local BUFF_INCARNATION = 102543;
	local BUFF_PROWL = 5215;
	local BUFF_SAVAGE_ROAR = 52610;
	local BUFF_SHADOWMELD = 58984;
    local BUFF_TIGERS_FURY = 5217;

	-- Debuffs to track
	local DEBUFF_MOONFIRE = 155625;
	local DEBUFF_RAKE = 155722;
	local DEBUFF_RIP = 1079;
	local DEBUFF_THRASH = 106830;

	-- Buffs to track
	local CLEU_TRACK_BUFF_SPELLID = {
		[BUFF_BLOODTALONS] = true;
		[BUFF_INCARNATION] = true;
		[BUFF_PROWL] = true;
		[BUFF_SAVAGE_ROAR] = true;
		[BUFF_SHADOWMELD] = true;
		[BUFF_TIGERS_FURY] = true;
	};

	-- Debuffs to track
	local CLEU_TRACK_DEBUFF_SPELLID = {
		[DEBUFF_MOONFIRE] = true;
		[DEBUFF_RAKE] = true;
		[DEBUFF_RIP] = true;
		[DEBUFF_THRASH] = true;
	};

	-- Table of CLEU events for when a unit is removed from combat
	local CLEU_UNIT_REMOVED = {
		UNIT_DESTROYED = true,
		UNIT_DIED = true,
		UNIT_DISSIPATES = true,
	};

	-- List of CLEU events for applying auras
	local CLEU_AURA_ADDED = {
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_REFRESH = true,
	};

	-- List of CLEU events for removing auras
	local CLEU_AURA_REMOVED = {
		SPELL_AURA_REMOVED = true,
	};

	-- Tables to keep track of buffs and bleeds
	local buffSnapshots = {};
	local debuffSnapshots = {};

	-- Number of Combo Points and Damage multiplier
	local comboPoints = 0;

    -- Player's GUID.
	local playerGUID = nil;
	
	-- Timer
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
			-- Check to make sure the player is a Feral Druid
			returnValue = (currentSpec == addonTable.DRUID_FERAL) or false;
		end

		return returnValue;
	end

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end

	local function calculateBloodtalonsModifier(atTime)
		local returnValue = 1;

		if atTime and buffSnapshots[BUFF_BLOODTALONS] and buffSnapshots[BUFF_BLOODTALONS] > atTime then
			returnValue = 1.5;
		end

		return returnValue;
	end

	local function calculateGeneralModifier(atTime)
		local returnValue = 1;

		if atTime then
			if buffSnapshots[BUFF_TIGERS_FURY] and buffSnapshots[BUFF_TIGERS_FURY] > atTime then
				returnValue = returnValue * 1.15;
			end

			if buffSnapshots[BUFF_SAVAGE_ROAR] and buffSnapshots[BUFF_SAVAGE_ROAR] > atTime then
				returnValue = returnValue * 1.25;
			end
		end

		return returnValue;
	end

	local function calculateStealthModifier(atTime)
		local returnValue = 1;

		if atTime then
			if (buffSnapshots[BUFF_INCARNATION] and buffSnapshots[BUFF_INCARNATION] > atTime) or buffSnapshots[BUFF_PROWL] or buffSnapshots[BUFF_SHADOWMELD] then
				returnValue = 2;
			end
		end

		return returnValue;
	end

	local function calculateSpellModifier(spellID, atTime)
		local returnValue = 1;

		local modifierGeneral = calculateGeneralModifier(atTime);
		local modifierBloodtalons = calculateBloodtalonsModifier(atTime);
		local modifierStealth = calculateStealthModifier(atTime);

		if spellID == DEBUFF_MOONFIRE then
			returnValue = modifierGeneral;
		elseif spellID == DEBUFF_RAKE then
			returnValue = modifierGeneral * modifierBloodtalons * modifierStealth;
		elseif spellID == DEBUFF_RIP then
			returnValue = modifierGeneral * modifierBloodtalons * comboPoints;
		elseif spellID == DEBUFF_THRASH then
			returnValue = modifierGeneral * modifierBloodtalons;
		end

		return returnValue;
	end

	local function addBuff(spellID, expirationTime)
		buffSnapshots[spellID] = expirationTime;
	end

	local function removeBuff(spellID)
		buffSnapshots[spellID] = nil;
	end

	local function addDebuff(destGUID, spellID, atTime, expirationTime)
		local enemyData = debuffSnapshots[destGUID] or {};
			
		enemyData[spellID] = {
			CurrentModifier = calculateSpellModifier(spellID, atTime),
			ExpirationTime = expirationTime,
		};

		debuffSnapshots[destGUID] = enemyData;
	end

	local function getDebuff(destGUID, spellID, atTime)
		local returnValue = 0;

		local enemyData = debuffSnapshots[destGUID];
		local spellData = (type(enemyData) == "table" and enemyData[spellID]) or nil;

		if spellData and atTime < spellData.ExpirationTime then
			returnValue = spellData.CurrentModifier;
		end

		return returnValue;
	end

	local function removeDebuff(destGUID, spellID)
		local enemyData = debuffSnapshots[destGUID];

		if enemyData then
			if spellID then
				enemyData[spellID] = nil;
				debuffSnapshots[destGUID] = enemyData;
			else
				debuffSnapshots[destGUID] = nil;
			end
		end
	end	
	--</private-static-methods>

	--<public-static-methods>
	function trackerFeralBleeds:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			
			local sourceIsPlayer = isPlayer(sourceFlags);
			local spellName, spellRank = GetSpellInfo(spellID);
			local unitID = trackerUnitID:ConvertToUnitID(destGUID);
			local currentTime = GetTime();

			if CLEU_UNIT_REMOVED[combatEvent] then
				removeDebuff(destGUID);
			elseif sourceIsPlayer and unitID and CLEU_TRACK_BUFF_SPELLID[spellID] then
				local expirationTime = select(7, UnitBuff("player", spellName, nil, "PLAYER"));

				if CLEU_AURA_ADDED[combatEvent] and expirationTime then
					addBuff(spellID, expirationTime);
				elseif CLEU_AURA_REMOVED[combatEvent] then
					removeBuff(spellID);
				end
			elseif sourceIsPlayer and unitID and CLEU_TRACK_DEBUFF_SPELLID[spellID] then
				local expirationTime = select(7, UnitDebuff(unitID, spellName, nil, "PLAYER"));

				if CLEU_AURA_ADDED[combatEvent] and expirationTime then
					addDebuff(destGUID, spellID, currentTime, expirationTime);
				elseif CLEU_AURA_REMOVED[combatEvent] then
					removeDebuff(destGUID, spellID);
				end
			end
		end
	end

	function trackerFeralBleeds:UNIT_POWER(event, ...)
		local unit, type = ...;

		if unit == "player" and type == "COMBO_POINTS" then
			local newComboPoints = UnitPower("player", SPELL_POWER_COMBO_POINTS);

			if newComboPoints > 0 then
				comboPoints = newComboPoints;
			end
		end
	end

	function trackerFeralBleeds:TimerEvent()
		local currentTime = GetTime();

		for spellID, ExpirationTime in pairs(buffSnapshots) do
			if currentTime >= ExpirationTime then
				removeBuff(spellID);
			end
		end

		for destGUID, enemyData in pairs(debuffSnapshots) do
			if type(enemyData) == "table" then
				for spellID, spellData in pairs(enemyData) do
					if spellData.ExpirationTime and currentTime >= spellData.ExpirationTime then
						removeDebuff(destGUID, spellID);
					end
				end
			end
		end
	end

	function trackerFeralBleeds:OnEnable()
		playerGUID = Ovale.playerGUID;
		
		if not reaperTimer then
			reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
		end

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		self:RegisterEvent("UNIT_POWER");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerFeralBleeds:OnDisable()
        OvaleState:UnregisterState(self);

		if reaperTimer then
			self:CancelTimer(reaperTimer);
			reaperTimer = nil;
		end

		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:UnregisterEvent("UNIT_POWER");
	end
	--</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    trackerFeralBleeds.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerFeralBleeds.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns the multiplier for the Debuff currently applied to the target at the specified time.
	statePrototype.GetExistingMultiplier = function(state, atTime, destGUID, spellID)
		return getDebuff(destGUID, spellID, atTime);
	end

	-- This returns the multiplier for the Debuff if it was to be applied at the specified time.
	statePrototype.GetCurrentMultiplier = function(state, atTime, spellID)
		return calculateSpellModifier(spellID, atTime);
	end
    --</public-static-methods>
end