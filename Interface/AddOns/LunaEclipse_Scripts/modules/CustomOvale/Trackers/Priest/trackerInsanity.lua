local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerInsanity";
	local trackerInsanity = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;
	local OvaleEquipment = Ovale.OvaleEquipment;

	-- Aura IDs
	local AURA_DISPERSION = 47585;
	local AURA_VOID_FORM = 194249;
	local AURA_VOID_TORRENT = 205065;

	-- Aura IDs to track drain stacks
	local CLEU_TRACK_AURA = {
		[AURA_VOID_FORM] = true,
	};

	-- Aura IDs to pause drain stacks
	local CLEU_AURA_PAUSE_DRAIN = {
		[AURA_DISPERSION] = true,
		[AURA_VOID_TORRENT] = true,
	};

	-- Events
	-- List of CLEU events for applying auras
	local CLEU_AURA_ADDED = {
		SPELL_AURA_APPLIED = true,
	};

	-- List of CLEU events for aura ticks
	local CLEU_AURA_PERIODIC_EVENT = {
		SPELL_AURA_APPLIED_DOSE = true,
	};

	-- List of CLEU events for removing auras
	local CLEU_AURA_REMOVED = {
		SPELL_AURA_REMOVED = true,
	};

    -- Table of CLEU events for when a unit is removed from combat.
    local CLEU_UNIT_REMOVED = {
        UNIT_DESTROYED = true,
        UNIT_DIED = true,
        UNIT_DISSIPATES = true,
    };

    -- Player's GUID.
	local playerGUID = nil;

	--- Insanity variables
	local voidForm = false;
	local insanityDrainStacks = 0;
	local pauseInsanityDrain = false;
	--</private-static-properties>

	--<private-static-methods>
	-- Functions to determine whether the module should work
	local function useModule()
		-- Default to not using the module
		local returnValue = false;
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();
	
		-- Check to make sure the player has a specialization
		if currentSpec then
			-- Check to make sure the player is a Shadow Priest
			returnValue = (currentSpec == addonTable.PRIEST_SHADOW) or false;
		end

		return returnValue;
	end

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end

	local function getInsanityDrain(drainStacks)
		local setBonusT20_4 = OvaleEquipment:GetArmorSetCount("T20") >= 4;
		local reduceInsanityRate = 1.00;
		
		if setBonusT20_4 then
			local specGroup = GetActiveSpecGroup();
			local nameSurrenderToMadness = select(2, GetTalentInfo(7, 3, specGroup));
			local activeSurrenderToMadness = select(11, UnitBuff("player", nameSurrenderToMadness));
        
			reduceInsanityRate = (activeSurrenderToMadness and 0.95) or 0.90;
		end    

		return (voidForm and (6.0 + (drainStacks * (2 / 3))) * reduceInsanityRate) or 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerInsanity:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
		if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			local sourceIsPlayer = isPlayer(sourceFlags);
			local destIsPlayer = isPlayer(destFlags);

			if CLEU_UNIT_REMOVED[combatEvent] and destIsPlayer then
				voidForm = false;
				pauseInsanityDrain = false;
				insanityDrainStacks = 0;
			elseif sourceIsPlayer then            
				if CLEU_AURA_ADDED[combatEvent] then
					if CLEU_TRACK_AURA[spellID] then
						voidForm = true;
						pauseInsanityDrain = false;
						insanityDrainStacks = 0;
					elseif CLEU_AURA_PAUSE_DRAIN[spellID] then
						pauseInsanityDrain = true;
					end
				elseif CLEU_AURA_PERIODIC_EVENT[combatEvent] then
					if CLEU_TRACK_AURA[spellID] and not pauseInsanityDrain then
						voidForm = true;
						insanityDrainStacks = insanityDrainStacks + 1;                       
					end
				elseif CLEU_AURA_REMOVED[combatEvent] then
					if CLEU_TRACK_AURA[spellID] then
						voidForm = false;
						pauseInsanityDrain = false;
						insanityDrainStacks = 0;
					elseif CLEU_AURA_PAUSE_DRAIN[spellID] then
						pauseInsanityDrain = false;
					end
				end
			end
		end
    end 

	function trackerInsanity:OnEnable()
		playerGUID = Ovale.playerGUID;
		
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerInsanity:OnDisable()
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
    trackerInsanity.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerInsanity.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This is the current insanity drain rate, returns 0 if not in void form.
	statePrototype.CurrentInsanityDrain = function(state)
		return (voidForm and getInsanityDrain(insanityDrainStacks)) or 0;
	end

	-- This is the number of insanity drain stacks the player has, returns 0 if not in void form.
	statePrototype.InsanityDrainStacks = function(state)
		return (voidForm and insanityDrainStacks) or 0;
	end
   --</public-static-methods>
end