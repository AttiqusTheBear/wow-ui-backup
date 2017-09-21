--[[
local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerCooldownReduction";
	local trackerCooldownReduction = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	Ovale.trackerCooldownReduction = trackerCooldownReduction;

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;
	local OvaleArtifact = Ovale.OvaleArtifact;
	local OvaleEquipment = Ovale.OvaleEquipment;

	-- SpellIDs
	local SPELLID_ARMY_OF_THE_DEAD = 42650;

	-- Tracked Spell Cooldowns
	local CLEU_TRACKED_SPELLID = {
		[SPELLID_ARMY_OF_THE_DEAD] = true,
	};

	-- Amount of time the spell cooldown will be reduced by
	local CLEU_SPELL_COOLDOWN_REDUCTION_TIMES = {
		[SPELLID_ARMY_OF_THE_DEAD] = 6,
	};

	-- List of CLEU events for applying auras
	local CLEU_AURA_ADDED = {
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_APPLIED_DOSE = true,
		SPELL_AURA_REFRESH = true,
		SPELL_CAST_SUCCESS = true,
	};

	-- List of CLEU events for aura ticks
	local CLEU_AURA_PERIODIC_EVENT = {
		SPELL_PERIODIC_DAMAGE = true,
		SPELL_PERIODIC_HEAL = true,
		SPELL_PERIODIC_ENERGIZE = true,
		SPELL_PERIODIC_DRAIN = true,
		SPELL_PERIODIC_LEECH = true,
	};

	-- List of CLEU events for removing auras
	local CLEU_AURA_REMOVED = {
		SPELL_AURA_REMOVED = true,
		SPELL_AURA_REMOVED_DOSE = true,
		SPELL_AURA_BROKEN = true,
		SPELL_AURA_BROKEN_SPELL = true,
	};

    -- Player's GUID.
	local playerGUID = nil;

	-- Variable to store number of times the spell has been reduced.
	local spellReductionCount = {};

	--<private-static-methods>
    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end

	-- Function to get spell cooldown.
	local function getCooldown(spellID, atTime)
		local returnValue = 0;

		local globalCooldown = select(2, GetSpellCooldown(addonTable.SPELLID_GLOBAL_COOLDOWN));
		local currentCharges, maxCharges, cooldownStart, cooldownDuration = GetSpellCharges(spellID);
		
		if not maxCharges then
			cooldownStart, cooldownDuration = GetSpellCooldown(spellID);
			currentCharges = (cooldownStart == 0 and cooldownDuration == 0 and 1) or 0;
			maxCharges = 1;
		end	
		
		if cooldownStart > 0 and cooldownDuration > globalCooldown then
			local cooldownReductionCount = spellReductionCount[spellID] or 0;
			local cooldownReductionTime = CLEU_SPELL_COOLDOWN_REDUCTION_TIMES[spellID] or 0;

			returnValue = (cooldownStart + cooldownDuration) - atTime;
		end
		
		return currentCharges, maxCharges, math.max(returnValue, 0);	
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerCooldownReduction:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
		local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			
		local sourceIsPlayer = isPlayer(sourceFlags);
		local currentTime = GetTime();
	end

	function trackerCooldownReduction:RUNE_POWER_UPDATE(event, ...)
		local runeIndex, isEnergize = ...;
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();
		local setBonusT20_4 = OvaleEquipment:GetArmorSetCount("T20") >= 4;

		if not isEnergize and setBonusT20_4 and currentSpec == addonTable.DEATHKNIGHT_UNHOLY then
			local reductionCount = spellReductionCount[SPELLID_ARMY_OF_THE_DEAD] or 0;

			spellReductionCount[SPELLID_ARMY_OF_THE_DEAD] = reductionCount + 1;
		end
	end

	function trackerCooldownReduction:SPELL_UPDATE_USABLE(event, ...)
		local reductionCount, spellCooldown;
		local currentTime = GetTime();

		for spellID, tracked in pairs(CLEU_TRACKED_SPELLID) do
			reductionCount = spellReductionCount[spellID];
			spellCooldown = select(3, getCooldown(spellID, currentTime));
			
			if reductionCount and not spellCooldown then
				spellReductionCount[spellID] = nil;
			end
		end
	end

	function trackerCooldownReduction:OnEnable()
		playerGUID = Ovale.playerGUID;
		
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		self:RegisterEvent("RUNE_POWER_UPDATE");

		self:RegisterEvent("SPELL_UPDATE_USABLE");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerCooldownReduction:OnDisable()
        OvaleState:UnregisterState(self);

		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		self:UnregisterEvent("RUNE_POWER_UPDATE");

		self:UnregisterEvent("SPELL_UPDATE_USABLE");
	end
	--</public-static-methods>
]]
    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
--[[
    --<public-static-properties>
    trackerCooldownReduction.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerCooldownReduction.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns the average length of time the spell's cooldown has been reduced in the past.
	statePrototype.ArcaneReductionTime = function(state, spellID)
	end

	-- This returns how many times the spell's cooldown has been reduced.
	statePrototype.CurrentReductionStacks = function(state, spellID)
	end

	-- This returns how long the spell's cooldown has been reduced.
	statePrototype.CurrentReductionTime = function(state, spellID)
	end
   --</public-static-methods>
end
]]