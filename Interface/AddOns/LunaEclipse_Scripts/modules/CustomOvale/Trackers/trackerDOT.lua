local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;
	local trackerUnitID = addonTable.trackerUnitID;

	local moduleName = "trackerDOT";
	local trackerDOT = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- Death Knight SpellID's
	local AURA_BLOOD_PLAGUE = 55078;
	local AURA_FROST_FEVER = 55095;
	local AURA_VIRULENT_PLAGUE = 191587;

	-- Druid SpellID's
	local AURA_MOONFIRE = 164812;
	local AURA_MOONFIRE_CAT = 155625;
	local AURA_RAKE = 155722;
	local AURA_RIP = 1079;
	local AURA_STELLAR_FLARE = 202347;
	local AURA_SUNFIRE = 164815;
	local AURA_THRASH = 106830;
	
	-- Hunter SpellID's
	local AURA_SERPENT_STING = 87935;

	-- Monk SpellID's
	local AURA_RISING_SUN = 107428;

	-- Priest SpellID's
	local AURA_SHADOW_WORD_PAIN = 589;
	local AURA_VAMPIRIC_TOUCH = 34914;

	-- Warlock SpellID's
	local AURA_AGONY = 980;
	local AURA_CORRUPTION = 146739;
	local AURA_DOOM = 603;
	local AURA_ERADICATION = 196414;
	local AURA_HAVOC = 80240;
	local AURA_IMMOLATE = 157736;
	local AURA_PHANTOM_SINGULARITY = 205179;
	local AURA_RAIN_OF_FIRE = 5740;
	local AURA_SEED_OF_CORRUPTION = 27243;
	local AURA_SHADOWBURN = 17877;
	local AURA_SHADOWFLAME = 205181;
	local AURA_SIPHON_LIFE = 63106;
	local AURA_UNSTABLE_AFFLICTION = 30108;

	-- Player's GUID.
	local playerGUID = nil;

	-- SpellIDs to track
	local CLEU_TRACK_SPELLID = {
		-- Death Knight SpellID's
		[AURA_BLOOD_PLAGUE] = true,
		[AURA_FROST_FEVER] = true,
		[AURA_VIRULENT_PLAGUE] = true,

		-- Druid SpellID's
		[AURA_MOONFIRE] = true,
		[AURA_MOONFIRE_CAT] = true,
		[AURA_RAKE] = true,
		[AURA_RIP] = true,
		[AURA_STELLAR_FLARE] = true,
		[AURA_SUNFIRE] = true,
		[AURA_THRASH] = true,

		-- Hunter SpellID's
		[AURA_SERPENT_STING] = true,

		-- Monk SpellID's
		[AURA_RISING_SUN] = true,

		-- Priest SpellID's
		[AURA_SHADOW_WORD_PAIN] = true,
		[AURA_VAMPIRIC_TOUCH] = true,

		-- Warlock SpellID's
		[AURA_AGONY] = true,
		[AURA_CORRUPTION] = true,
		[AURA_DOOM] = true,
		[AURA_ERADICATION] = true,
		[AURA_HAVOC] = true,
		[AURA_IMMOLATE] = true,
		[AURA_PHANTOM_SINGULARITY] = true;
		[AURA_RAIN_OF_FIRE] = true,
		[AURA_SEED_OF_CORRUPTION] = true,
		[AURA_SHADOWBURN] = true,
		[AURA_SHADOWFLAME] = true,
		[AURA_SIPHON_LIFE] = true,
		[AURA_UNSTABLE_AFFLICTION] = true,		
	};

	-- Table to store GUIDs affected by the tracked spells
	local tableList = {};

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

	-- Timer for reaper function to remove inactive enemies.
	local reaperTimer = nil;
	local REAP_INTERVAL = 1;
	--</private-static-properties>

	--<private-static-methods>
	-- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerDOT:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
		local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
		local currentTime = GetTime();
		local sourceIsPlayer = isPlayer(sourceFlags);
	
		if CLEU_UNIT_REMOVED[combatEvent] then
			self:RemoveEnemy(destGUID);
		elseif sourceIsPlayer and CLEU_TRACK_SPELLID[spellID] then
			if CLEU_DOT_ADDED[combatEvent] or CLEU_DOT_PERIODIC_EVENT[combatEvent] then
				local spellName, spellRank = GetSpellInfo(spellID);
				local unitID = trackerUnitID:ConvertToUnitID(destGUID);

				if unitID then
					local stacks, _, duration, expirationTime = select(4, UnitDebuff(unitID, spellName, spellRank, "PLAYER"));

					if stacks and duration and expirationTime then
						self:AddEnemy(destGUID, spellID, currentTime, expirationTime, stacks);
					end
				end
			elseif CLEU_DOT_REMOVED[combatEvent] then
				self:RemoveEnemy(destGUID, spellID);
			end
		end
	end

	function trackerDOT:AddEnemy(GUID, spellID, timeStamp, expirationTime, numStacks)
		if spellID then
			if not tableList[spellID] then
				tableList[spellID] = {};
			end

			local tableUpdate = tableList[spellID];
	    	
			if tableUpdate then
				tableUpdate[GUID] = { expiration = expirationTime, stacks = numStacks, lastupdate = timeStamp };

				tableList[spellID] = tableUpdate;
				Ovale.refreshNeeded[playerGUID] = true;
			end
		end
	end

	function trackerDOT:RemoveEnemy(GUID, spellID)
		local refreshNeeded = false;
		local unitDied = not spellID;

		if not spellID then
			for spellID, tableUpdate in pairs(tableList) do
				if tableUpdate[GUID] then
					tableUpdate[GUID] = nil;
					tableList[spellID] = tableUpdate;
					refreshNeeded = true;
				end
			end
		else
			local tableUpdate = tableList[spellID];
	    	
			if tableUpdate then
				if tableUpdate[GUID] then
					tableUpdate[GUID] = nil;
					tableList[spellID] = tableUpdate;
					refreshNeeded = true;
				end
			end
		end

		if refreshNeeded then
			Ovale.refreshNeeded[playerGUID] = true;
			self:SendMessage("Ovale_InactiveUnit", GUID, unitDied);
		end
	end

	function trackerDOT:TimerEvent()
		local currentTime = GetTime();

		for spellID, tableUpdate in pairs(tableList) do
			for GUID, data in pairs(tableUpdate) do
				if data.expiration ~= 0 and currentTime > data.expiration then
					self:RemoveEnemy(GUID, spellID);
				end
			end
		end
	end

	function trackerDOT:OnEnable()
		playerGUID = Ovale.playerGUID;

		if not reaperTimer then
			reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
		end
	
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

        OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerDOT:OnDisable()
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
    trackerDOT.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerDOT.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns the count for the SpellID passed to it
	statePrototype.DOTTargetCount = function(state, spellID, atTime)
		local returnValue = 0;
		local tableUpdate = tableList[spellID];
	    
		if tableUpdate then
			for GUID, data in pairs(tableUpdate) do
				if (atTime < data.expiration or data.expiration == 0) then
					returnValue = returnValue + 1;
				end
			end
		end

		return returnValue or 0;
	end
    --</public-static-methods>
end