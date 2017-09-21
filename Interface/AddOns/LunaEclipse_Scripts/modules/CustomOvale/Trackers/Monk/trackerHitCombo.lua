local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerHitCombo";
	local trackerHitCombo = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- Monk Hit Combo SpellID's
	local SPELL_BLACKOUT_KICK = 100784;
	local SPELL_CRACKLING_JADE_LIGHTNING = 117952;
	local SPELL_FISTS_OF_FURY = 113656;
	local SPELL_FLYING_SERPENT_KICK = 101545;
	local SPELL_RISING_SUN_KICK = 107428;
	local SPELL_SPINNING_CRANE_KICK = 101546;
	local SPELL_STRIKE_OF_THE_WINDLORD = 205320;
	local SPELL_TIGER_PALM = 100780;
	local SPELL_TOUCH_OF_DEATH = 115080;
	local SPELL_CHI_WAVE = 115098;
	local SPELL_CHI_BURST = 123986;
	local SPELL_RUSHING_JADE_WIND = 116847;
	local SPELL_WHIRLING_DRAGON_PUNCH = 152175;

	-- Hit Combo Aura
	local AURA_HIT_COMBO = 196741;

	-- Player's GUID.
	local playerGUID = nil;

	-- SpellIDs to track
	local CLEU_TRACK_SPELLID = {
		[SPELL_BLACKOUT_KICK] = true,
		[SPELL_CRACKLING_JADE_LIGHTNING] = true,
		[SPELL_FISTS_OF_FURY] = true,
		[SPELL_FLYING_SERPENT_KICK] = true,
		[SPELL_RISING_SUN_KICK] = true,
		[SPELL_SPINNING_CRANE_KICK] = true,
		[SPELL_STRIKE_OF_THE_WINDLORD] = true,
		[SPELL_TIGER_PALM] = true,
		[SPELL_TOUCH_OF_DEATH] = true,
		[SPELL_CHI_WAVE] = true,
		[SPELL_CHI_BURST] = true,
		[SPELL_RUSHING_JADE_WIND] = true,
		[SPELL_WHIRLING_DRAGON_PUNCH] = true,
	};

	-- Variables to store spell's tracked
	local currentSpell = 0;

	-- Internal local variables
	local trackingEnabled = false;
	local previousSpell = 0;

	-- Events
	-- Table of CLEU events for when a spell cast starts
	local CLEU_SPELLCAST_START = {
		SPELL_CAST_START = true,
	};

	-- List of CLEU events for when a spell cast ends
	local CLEU_SPELLCAST_FINISH = {
		SPELL_CAST_MISS  = true,
		SPELL_CAST_SUCCESS = true,
		SPELL_DAMAGE = true,
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_APPLIED_DOSE = true,
	};

	-- List of CLEU events for adding auras
	local CLEU_AURA_ADDED = {
		SPELL_AURA_APPLIED = true,
		SPELL_AURA_REFRESH = true,
		SPELL_AURA_APPLIED_DOSE = true,
		SPELL_CAST_SUCCESS = true,
	};

	-- List of CLEU events for removing auras
	local CLEU_AURA_REMOVED = {
		SPELL_AURA_REMOVED = true,
		SPELL_AURA_BROKEN = true,
		SPELL_AURA_BROKEN_SPELL = true,
	};
	--</private-static-properties>

	--<private-static-methods>
	-- Functions to determine whether the module should work
	local function useModule()
		-- Default to not using the module
		local returnValue = false;
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();
	
		-- Check to make sure the player has a specialization
		if currentSpec then
			-- Get talent info for Hit Combo
			local talentID, name, texture, selected, available = GetTalentInfo(6, 3, GetActiveSpecGroup());

			-- Check to make sure the player is a Windwalker Monk and has Hit Combo selected
			returnValue = (currentSpec == addonTable.MONK_WINDWALKER and selected) or false;
		end
		
		return returnValue;
	end

	-- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerHitCombo:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
		if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			local sourceIsPlayer = isPlayer(sourceFlags);
	
			if sourceIsPlayer then
				if spellID == AURA_HIT_COMBO then
					if CLEU_AURA_ADDED[combatEvent] then
						-- Aura gained so enable Hit Combo Tracking
						trackingEnabled = true;
					elseif CLEU_AURA_REMOVED[combatEvent] then
						-- Aura lost so disable Hit Combo Tracking
						trackingEnabled = false;
					end
				elseif CLEU_TRACK_SPELLID[spellID] then
					if CLEU_SPELLCAST_START[combatEvent] then
						-- Spell cast started, so store the information
						previousSpell = currentSpell;
						currentSpell = spellID;
					elseif CLEU_SPELLCAST_FINISH[combatEvent] then
						-- Spell cast finished, so store the information if its changed				
						if spellID and spellID ~= currentSpell then
							currentSpell = spellID;
						end

						previousSpell = 0;
					end
				end
			end
		end
	end

	function trackerHitCombo:OnEnable()
		playerGUID = Ovale.playerGUID;

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
 
		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerHitCombo:OnDisable()
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
    trackerHitCombo.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerHitCombo.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns the last used hit combo spell, or 0.
	statePrototype.LastHitComboSpell = function(state)
		-- Return the last spell, otherwise return 0
		return currentSpell or 0;
	end
    --</public-static-methods>
end