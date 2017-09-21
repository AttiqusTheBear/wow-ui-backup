local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;
	local trackerUnitID = addonTable.trackerUnitID;

	local moduleName = "trackerSoulEffigy";
	local trackerSoulEffigy = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	local NPC_SOUL_EFFIGY = 103679;

	local AURA_AGONY = 980;
	local AURA_CORRUPTION = 146739;
	local AURA_SIPHON_LIFE = 63106;
	local AURA_SOUL_EFFIGY = 205178;
	local AURA_UNSTABLE_AFFLICTION = 30108;

	-- Stored GUIDs.
	local effigyGUID = nil;
	local effigyTargetGUID = nil;
	local playerGUID = nil;

	-- Table to store tracked spells
	local appliedDOTs = {};

    -- Timer for reaper function to remove inactive enemies.
    local reaperTimer = nil;
    local REAP_INTERVAL = 1;

	-- SpellIDs to track
	local CLEU_TRACK_SPELLID = {
		[AURA_SOUL_EFFIGY] = true,
	};

	-- DOT SpellIDs to track
	local CLEU_TRACK_DOT_SPELLID = {
		[AURA_AGONY] = true,
		[AURA_CORRUPTION] = true,
		[AURA_SIPHON_LIFE] = true,
		[AURA_UNSTABLE_AFFLICTION] = true,		
	};

	local CLEU_TRACK_SUMMON_CREATUREID = {
		[NPC_SOUL_EFFIGY] = true,
	};

	-- Events
	-- Table of CLEU events for when a unit is summoned
	local CLEU_UNIT_SUMMONED = {
		SPELL_SUMMON = true,
	};

	-- Table of CLEU events for when a unit is removed from combat
	local CLEU_UNIT_REMOVED = {
		UNIT_DESTROYED = true,
		UNIT_DIED = true,
		UNIT_DISSIPATES = true,
	};

	-- Table of CLEU events for successful spell casts
	local CLEU_SPELL_CASTS = {
		SPELL_CAST_SUCCESS = true,
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
	--</private-static-properties>

	--<private-static-methods>
	-- Functions to determine whether the module should work
	local function useModule()
		-- Default to not using the module
		local returnValue = false;
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();
	
		-- Check to make sure the player has a specialization
		if currentSpec then
			local talentID, name, texture, selected, available = GetTalentInfo(7, 1, GetActiveSpecGroup());

			-- Check to make sure the player is a Affliction Warlock and has Soul Effigy selected
			returnValue = (currentSpec == addonTable.WARLOCK_AFFLICTION and selected) or false;
		end
		
		return returnValue;
	end

    local function wipeData()
		effigyGUID = nil;
		effigyTargetGUID = nil;
        appliedDOTs = {};
    end

    -- Functions to check Unit Info
	local function isSoulEffigy(destGUID)
		return destGUID == effigyGUID;
	end

	local function isSoulEffigyTarget(destGUID)
		return destGUID == effigyTargetGUID;
	end

	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerSoulEffigy:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
		if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			local currentTime = GetTime();
			local sourceIsPlayer = isPlayer(sourceFlags);

			local unitInfo = LunaEclipse_Scripts:ParseGUID(destGUID);
			local creatureID = tonumber(unitInfo.CreatureID);
	
			if isSoulEffigyTarget(destGUID) then
				if CLEU_UNIT_REMOVED[combatEvent] then
					wipeData();
				elseif sourceIsPlayer and CLEU_DOT_REMOVED[combatEvent] and CLEU_TRACK_SPELLID[spellID] then
					wipeData();
				end	
			elseif sourceIsPlayer then
				if CLEU_SPELL_CASTS[combatEvent] and CLEU_TRACK_SPELLID[spellID] then
					effigyTargetGUID = destGUID;
				elseif CLEU_UNIT_SUMMONED[combatEvent] and CLEU_TRACK_SUMMON_CREATUREID[creatureID] then
					effigyGUID = destGUID;
				elseif isSoulEffigy(destGUID) and CLEU_TRACK_DOT_SPELLID[spellID] then
					if CLEU_DOT_ADDED[combatEvent] or CLEU_DOT_PERIODIC_EVENT[combatEvent] then
						local spellName, spellRank = GetSpellInfo(spellID);
						local unitID = trackerUnitID:ConvertToUnitID(destGUID);

						if unitID then
							local stacks, _, duration, expirationTime = select(4, UnitDebuff(unitID, spellName, spellRank, "PLAYER"));
							
							if stacks and duration and expirationTime then
								self:AddDOT(spellID, currentTime, expirationTime, stacks);
							end
						end
					elseif CLEU_DOT_REMOVED[combatEvent] then
						self:RemoveDOT(spellID);
					end
				end
			end
		end
	end

	function trackerSoulEffigy:AddDOT(spellID, timeStamp, expirationTime, numStacks)
		if spellID then
			appliedDOTs[spellID] = { expiration = expirationTime, stacks = numStacks, lastupdate = timeStamp };
			Ovale.refreshNeeded[playerGUID] = true;
		end
	end

	function trackerSoulEffigy:RemoveDOT(spellID)
		if spellID and appliedDOTs[spellID] then
			appliedDOTs[spellID] = nil;

			Ovale.refreshNeeded[playerGUID] = true;
		end
	end

    -- Remove any information for DOTs that have expired.
    function trackerSoulEffigy:TimerEvent()
        local currentTime = GetTime();

        for spellID, data in pairs(appliedDOTs) do			
            if data.expiration ~= 0 and currentTime > data.expiration then
                self:RemoveDOT(spellID);
			end
        end
    end

	function trackerSoulEffigy:OnEnable()
		playerGUID = Ovale.playerGUID;

        if not reaperTimer then
            reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
        end

        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

        OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerSoulEffigy:OnDisable()
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
    trackerSoulEffigy.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerSoulEffigy.statePrototype;
    --</private-static-properties>

	statePrototype.EffigyActive = function(state)
		return effigyGUID ~= nil;
	end

    --<public-static-methods>
	statePrototype.EffigyDOTActive = function(state, spellID, atTime)
		local returnValue = false;

		if appliedDOTs[spellID] and (atTime < appliedDOTs[spellID].expiration or appliedDOTs[spellID].expiration == 0) then
			returnValue = true;
		end

		return returnValue;
	end

	-- This returns the expiration time for the SpellID passed to it, returns nil if the DOT is not active
	statePrototype.EffigyDOTExpires = function(state, spellID)
		local returnValue = 0;

		if appliedDOTs[spellID] then
			returnValue = (appliedDOTs[spellID].expiration > 0 and appliedDOTs[spellID].expiration) or math.huge();
		end

		return returnValue;
	end

	-- This returns the duration for the SpellID passed to it, returns 0 if the DOT is not active
	statePrototype.EffigyDOTRemaining = function(state, spellID, atTime)
		local returnValue = 0;

		if appliedDOTs[spellID] and (atTime < appliedDOTs[spellID].expiration or appliedDOTs[spellID].expiration == 0) then
			returnValue = (appliedDOTs[spellID].expiration > 0 and appliedDOTs[spellID].expiration - atTime) or math.huge();
		end

		return returnValue;
	end

 	-- This returns the stacks for the SpellID passed to it, will return 0 if DOT does not stack or is not active
	statePrototype.EffigyDOTStacks = function(state, spellID, atTime)
		local returnValue = 0;

		if appliedDOTs[spellID] and (atTime < appliedDOTs[spellID].expiration or appliedDOTs[spellID].expiration == 0) then
			returnValue = appliedDOTs[spellID].stacks;
		end

		return returnValue;
	end
   --</public-static-methods>
end