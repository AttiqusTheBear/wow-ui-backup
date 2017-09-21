local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;
	local trackerUnitID = addonTable.trackerUnitID;

	local moduleName = "trackerBloodlust";
	local trackerBloodlust = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

    -- Player's GUID.
	local playerGUID = nil;
	
	-- Shard of the Exodar Legendary
	local SHARD_OF_THE_EXODAR = 132410;

	-- BUFF IDs
	local BUFF_BLOODLUST = 2825;
	local BUFF_HEROISM = 32182;
	local BUFF_TIMEWARP = 80353;
	local BUFF_ANCIENT_HYSTERIA = 90355;
	local BUFF_NETHERWINDS = 160452;
	local BUFF_DRUMS_OF_RAGE = 146555;

	-- Debuff IDs
	local DEBUFF_SATED = 57724;
	local DEBUFF_EXHAUSTION = 57723;
	local DEBUFF_TEMPORAL_DISPLACEMENT = 80354;
	local DEBUFF_INSANITY = 95809;
	local DEBUFF_FATIGUED = 160455;

	-- Buffs to track
	local CLEU_TRACK_BUFF = {
		[BUFF_BLOODLUST] = true,
		[BUFF_HEROISM] = true,
		[BUFF_TIMEWARP] = true,
		[BUFF_ANCIENT_HYSTERIA] = true,
		[BUFF_NETHERWINDS] = true,
		[BUFF_DRUMS_OF_RAGE] = true,
	};

	-- Debuffs to track
	local CLEU_TRACK_DEBUFF = {
		[DEBUFF_SATED] = true,
		[DEBUFF_EXHAUSTION] = true,
		[DEBUFF_TEMPORAL_DISPLACEMENT] = true,
		[DEBUFF_INSANITY] = true,
		[DEBUFF_FATIGUED] = true,
	};

	-- Variable to store whether the player is currently under the effects of Bloodlust
	local playerBloodlust = nil;
	local playerDebuff = nil;
	local playerDebuffReceived = false;

	-- Table to store GUIDs affected by the bloodlust debuff
	local debuffList = {};
	local groupGUIDs = {};

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
		SPELL_CAST_SUCCESS = true,
	};

	-- List of CLEU events for removing auras
	local CLEU_ARUA_REMOVED = {
		SPELL_AURA_REMOVED = true,
		SPELL_AURA_BROKEN = true,
		SPELL_AURA_BROKEN_SPELL = true,
	};
	
	-- Reap Timer for removing entries.
	local reaperTimer = nil;	
	local REAP_INTERVAL = 1;
	--</private-static-properties>

	--<private-static-methods>
    -- Functions to check Unit Info
    local function isPlayer(GUID, unitName, unitFlags)
        return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
    end

    local function isGroupMember(GUID, unitName, unitFlags)
        local unitInfo = LunaEclipse_Scripts:ParseGUID(GUID);
		
        return unitInfo.Type == addonTable.GUID_PLAYER
		  and (bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0
            or bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0 
            or bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0);
    end

    local function isEnemy(GUID, unitName, unitFlags)
        return bit.band(unitFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0;
    end

    local function isValid(GUID, unitName, unitFlags)
        return (GUID and GUID ~= "") 
           and unitName ~= nil
           and (bit.band(unitFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0
                or bit.band(unitFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
                or bit.band(unitFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0);
    end

    local function getUnitInfo(GUID, unitName, unitFlags)
        return isPlayer(GUID, unitName, unitFlags), isGroupMember(GUID, unitName, unitFlags), isEnemy(GUID, unitName, unitFlags), isValid(GUID, unitName, unitFlags);
    end

	-- Function to get the number of group members with the debuff
	local function getDebuffCount(atTime)
		local returnValue = 0;
		local playerDebuffStored = false;

		for GUID, expirationTime in pairs(debuffList) do
			if not playerDebuffStored and GUID == playerGUID then
				playerDebuffStored = true;
			end
			
			if atTime < expirationTime then
				returnValue = returnValue + 1;
			end
		end
		
		if not playerDebuffStored and playerDebuff and atTime < playerDebuff then
			returnValue = returnValue + 1;
		end
		
		return returnValue;
	end

	-- Function to get the number of group members
	local function getGroupMemberCount()
		local returnValue = GetNumGroupMembers();
        		
		if returnValue == 0 then
			returnValue = 1;
		end
		
		return returnValue;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerBloodlust:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
		local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
		local currentTime = GetTime();
			
		local sourceIsPlayer, sourceIsGroupMember, sourceIsEnemy, sourceIsValid = getUnitInfo(sourceGUID, sourceName, sourceFlags);
		local destIsPlayer, destIsGroupMember, destIsEnemy, destIsValid = getUnitInfo(destGUID, destName, destFlags);

        if CLEU_UNIT_REMOVED[combatEvent] then
			-- Remove player from Debuff list because they died.
			self:RemovePlayer(destGUID);
		elseif destIsPlayer and CLEU_TRACK_BUFF[spellID] then					
			if CLEU_AURA_ADDED[combatEvent] then
				local unitID = trackerUnitID:ConvertToUnitID(destGUID);
				
				if unitID then
					local currentTime = GetTime();
					local spellName = GetSpellInfo(spellID);
					local expirationTime = select(7, UnitBuff(unitID, spellName));
					local equippedShard = IsEquippedItem(SHARD_OF_THE_EXODAR);
						
					-- Set bloodlust information
					playerBloodlust = expirationTime;

					if sourceIsPlayer and equippedShard and not playerDebuff then
						-- Add debuf information because the player has Shard of Exodar and doesn't get the debuff
						playerDebuff = currentTime + 600;
					end
				end
			elseif CLEU_ARUA_REMOVED[combatEvent] then
				-- Remove bloodlust information
				playerBloodlust = nil;
			end
		elseif destIsGroupMember and CLEU_TRACK_DEBUFF[spellID] then
			if CLEU_AURA_ADDED[combatEvent] then
				local unitID = trackerUnitID:ConvertToUnitID(destGUID);
				
				if unitID then
					local spellName = GetSpellInfo(spellID);
					local expirationTime = select(7, UnitDebuff(unitID, spellName));
						
					-- Add player to Debuff list
					self:AddPlayer(destGUID, expirationTime);
				end
			elseif CLEU_ARUA_REMOVED[combatEvent] then
				-- Remove player from Debuff list
				self:RemovePlayer(destGUID);
			end
		end
	end

    function trackerBloodlust:PLAYER_REGEN_ENABLED()
		local unitID, spellName, debuffFound;

		for GUID, expirationTime in pairs(debuffList) do
			debuffFound = nil;
			unitID = groupGUIDs[GUID];

			if unitID then
				for spellID, tracked in pairs(CLEU_TRACK_DEBUFF) do
					if not debuffFound then
						spellName = GetSpellInfo(spellID);
						debuffFound = UnitDebuff(unitID, spellName);
					end
				end
			end

			if not unitID or not debuffFound then
				self:RemovePlayer(GUID);
			end
		end
	end

	function trackerBloodlust:GROUP_ROSTER_UPDATE(event, ...)
		local unitGUID, unitID, startPos, endPos;
		local isGrouped = IsInGroup();

		if isGrouped then
			local isRaid = IsInRaid();

			wipe(groupGUIDs);
			groupGUIDs = {};

			if isRaid then
				for counter = 1, 40 do
					unitID = string.format("raid%s", counter);
					unitGUID = UnitGUID(unitID);

					if unitGUID then
						groupGUIDs[unitGUID] = unitID;
					end
				end
			else
				for counter = 1, 4 do
					unitID = string.format("party%s", counter);
					unitGUID = UnitGUID(unitID);

					if unitGUID then
						groupGUIDs[unitGUID] = unitID;
					end
				end
			end
		else
			wipe(groupGUIDs);
			groupGUIDs = {};
		end
	end

	function trackerBloodlust:AddPlayer(GUID, expirationTime)
		if GUID and expirationTime then
			if GUID == playerGUID then
				playerDebuffReceived = true;
				playerDebuff = expirationTime;
			end

			debuffList[GUID] = expirationTime;
		
			Ovale.refreshNeeded[playerGUID] = true;
		end
	end

	function trackerBloodlust:RemovePlayer(GUID)
		if GUID then
			local refreshNeeded = false;

			if playerDebuff and GUID == playerGUID then
				playerDebuffReceived = false;
				playerDebuff = nil;
			end

			if debuffList[GUID] then
				debuffList[GUID] = nil;
				refreshNeeded = true;
			end

			if refreshNeeded then
				Ovale.refreshNeeded[playerGUID] = true;
				self:SendMessage("Ovale_InactiveUnit", GUID, false);
			end
		end
	end

	function trackerBloodlust:TimerEvent()
		-- Check to see if the expire times have passed for both playerBloodlust and debuffList
		local currentTime = GetTime();

		if playerBloodlust and currentTime >= playerBloodlust then
			-- Remove bloodlust information
			playerBloodlust = nil;
		end

		if playerDebuff and currentTime >= playerDebuff then
			-- Remove bloodlust debuff information
			playerDebuff = nil;
		end

		for GUID, expirationTime in pairs(debuffList) do
			if not groupGUIDs[GUID] or currentTime >= expirationTime then
				self:RemovePlayer(GUID);
			end
		end
	end

	function trackerBloodlust:OnEnable()
		playerGUID = Ovale.playerGUID;
		
        if not reaperTimer then
            reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
        end

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:RegisterEvent("PLAYER_REGEN_ENABLED");

		-- Group/Raid Events
		self:RegisterEvent("GROUP_ROSTER_UPDATE");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerBloodlust:OnDisable()
        OvaleState:UnregisterState(self);

        if reaperTimer then
            self:CancelTimer(reaperTimer);
            reaperTimer = nil;
        end

		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:UnregisterEvent("PLAYER_REGEN_ENABLED");

		-- Group/Raid Events
		self:UnregisterEvent("GROUP_ROSTER_UPDATE");
	end
	--</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    trackerBloodlust.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerBloodlust.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns whether the player currently has a bloodlust buff.
	statePrototype.BloodlustActive = function(state, atTime)
		return (playerBloodlust and atTime < playerBloodlust) or false;
	end

	-- This returns whether the player currently has a bloodlust debuff.
	statePrototype.BloodlustDebuff = function(state, atTime)
		return (debuffList[playerGUID] and atTime < debuffList[playerGUID]) or false;
	end

	-- This returns the percentage of group members with the bloodlust debuff.
	statePrototype.BloodlustPercentage = function(state, atTime)
		local percentDebuff = (getDebuffCount(atTime) / getGroupMemberCount()) * 100;

		return percentDebuff;
	end

	-- This returns the amount of time left on the players bloodlust.
	statePrototype.BloodlustRemaining = function(state, atTime)
		local timeRemaining = (playerBloodlust and (playerBloodlust - atTime)) or 0;

		return timeRemaining;
	end
    --</public-static-methods>
end