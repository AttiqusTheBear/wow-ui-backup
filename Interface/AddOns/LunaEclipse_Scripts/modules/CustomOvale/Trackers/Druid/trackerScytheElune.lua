local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local moduleName = "trackerScytheElune";
	local trackerScytheElune = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0", "AceTimer-3.0");

	local OvaleSpellBook = Ovale.OvaleSpellBook;

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

	-- SpellIDs for Scythe of Elune Spells
	local SPELLID_FULL_MOON = 202771;
	local SPELLID_HALF_MOON = 202768;
	local SPELLID_NEW_MOON = 202767;

	-- SpellID of the spell that will replace the current one
	local SPELLID_NEXT_SPELL = {
		[SPELLID_FULL_MOON] = SPELLID_NEW_MOON,
		[SPELLID_HALF_MOON] = SPELLID_FULL_MOON,
		[SPELLID_NEW_MOON] = SPELLID_HALF_MOON,
	};
	
	-- SpellIDs to track
	local CLEU_TRACK_SPELLID = {
		[SPELLID_FULL_MOON] = true,
		[SPELLID_HALF_MOON] = true,
		[SPELLID_NEW_MOON] = true,
	};
	
	-- Max Charges
	local MAX_CHARGES = 0;

    -- Player's GUID.
	local playerGUID = nil;
	
	-- SpellID and number of charges of Scythe of Elune Spell
	local scytheSpellID = nil;
	local scytheCharges = nil;

	-- Variable to store Scythe of Elune Spellbook Index
	local spellBookIndex = nil;

	-- Local variable used to know if a cast successfully got the cancelled event
	local castFinish = 0;
	local isCasting = false;

	-- Timers for charge cooldown.
	local cooldownTimer = nil;
	local reaperTimer = nil;
	
	local REAP_INTERVAL = 0.2;
	--</private-static-properties>

	--<private-static-methods>
	-- Functions to determine whether the module should work
	local function useModule()
		-- Default to not using the module
		local returnValue = false;
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();
	
		-- Check to make sure the player has a specialization
		if currentSpec then
			-- Check to make sure the player is a Balance Druid
			returnValue = (currentSpec == addonTable.DRUID_BALANCE) or false;
		end

		return returnValue;
	end

    -- Functions to check Unit Info
	local function isPlayer(unitFlags)
		return bit.band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0;
	end

	-- Parse a in-game link to get the information from it
	local function ParseHyperlink(hyperlink)
		local color, linkType, linkData, text = strmatch(hyperlink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d*):?%d?|?h?%[?([^%[%]]*)%]?|?h?|?r?");
		
		return color, linkType, linkData, text;
	end

	-- Get the spell book index for the given spellID.
	local function getSpellBookIndex(spellID)
		for bookTab = 1, 2 do
			local name, texture, offset, numSpells = GetSpellTabInfo(bookTab);

			if name then
				for spellIndex = offset + 1, offset + numSpells do
					if spellID == select(2, GetSpellBookItemInfo(spellIndex, BOOKTYPE_SPELL)) then
						return spellIndex;
					end
				end
			end
		end

		return nil;
	end

	-- Function to advance active spell to the next spell
	local function advanceSpellID(spellID)
		local returnValue = 0;
		
		if spellID then
			returnValue = SPELLID_NEXT_SPELL[spellID];
		end
		
		return returnValue;
	end
	
	-- Function to determine active spell
	local function activeScytheSpell(spellBookIndex)
		local returnValue = 0;
			
		if spellBookIndex then
			local spellLink = GetSpellLink(spellBookIndex, BOOKTYPE_SPELL);

			if spellLink then
				local linkData, spellName = select(3, ParseHyperlink(spellLink));
				
				returnValue = tonumber(linkData);
			end
		end

		return returnValue;
	end
	--</private-static-methods>

	--<public-static-methods>
	function trackerScytheElune:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
        if useModule() then
			local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID = ...;
			
			local sourceIsPlayer = isPlayer(sourceFlags);
			local currentSpell = activeScytheSpell(spellBookIndex);
			local currentCharges = GetSpellCharges(SPELLID_NEW_MOON);

			if sourceIsPlayer and CLEU_TRACK_SPELLID[spellID] then
				if combatEvent == "SPELL_CAST_START" then
					local castingTime = select(4, GetSpellInfo(spellID));
					local latencyHome, latencyWorld = select(3, GetNetStats());

					isCasting = true;
					castFinish = GetTime() + castingTime + math.max(latencyHome, latencyWorld);

					scytheSpellID = advanceSpellID(currentSpell);
					scytheCharges = math.max(currentCharges - 1, 0);
				elseif combatEvent == "SPELL_CAST_SUCCESS" then
					isCasting = false
				elseif combatEvent == "SPELL_CAST_FAILED" then
					isCasting = false
				end
			end
		end
	end

	function trackerScytheElune:SPELLS_CHANGED(event, ...)
		spellBookIndex = getSpellBookIndex(SPELLID_NEW_MOON);
		
		local currentSpellID = activeScytheSpell(spellBookIndex);
		local currentCharges, maxCharges = GetSpellCharges(SPELLID_NEW_MOON);
				
		scytheSpellID = (currentSpellID ~= scytheSpellID and currentSpellID) or scytheSpellID;
		scytheCharges = (currentCharges ~= scytheCharges and currentCharges) or scytheCharges;

		MAX_CHARGES = maxCharges or 0;
	end

	function trackerScytheElune:AddCharge()
		scytheCharges = math.min(scytheCharges + 1, MAX_CHARGES);

		cooldownTimer = nil;
	end

	function trackerScytheElune:TimerEvent()
		local currentTime = GetTime();

		if currentTime > castFinish or not isCasting or (isCasting and not IsCurrentSpell(spellBookIndex, BOOKTYPE_SPELL)) then
			local currentSpellID = activeScytheSpell(spellBookIndex);
			local currentCharges = GetSpellCharges(SPELLID_NEW_MOON);
				
			scytheSpellID = (currentSpellID ~= scytheSpellID and currentSpellID) or scytheSpellID;
			scytheCharges = (currentCharges ~= scytheCharges and currentCharges) or scytheCharges;

			isCasting = false
			castFinish = 0;
		end

		if not cooldownTimer then
			local cooldownStart, cooldownDuration = select(3, GetSpellCharges(SPELLID_NEW_MOON));
			local cooldownEnd = cooldownStart + cooldownDuration;
			local currentTime = GetTime();

			if cooldownStart < currentTime and currentTime < cooldownEnd then
				local timerValue = cooldownEnd - currentTime;
	
				cooldownTimer = self:ScheduleTimer("AddCharge", timerValue);
			end
		end
	end

	function trackerScytheElune:OnEnable()
		playerGUID = Ovale.playerGUID;
		
		if not reaperTimer then
			reaperTimer = self:ScheduleRepeatingTimer("TimerEvent", REAP_INTERVAL);
		end

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		self:RegisterEvent("SPELLS_CHANGED");

		OvaleState:RegisterState(self, self.statePrototype);
	end

	function trackerScytheElune:OnDisable()
        OvaleState:UnregisterState(self);

		if reaperTimer then
			self:CancelTimer(reaperTimer);
			reaperTimer = nil;
		end

		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        self:UnregisterEvent("SPELLS_CHANGED");
	end
	--</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    trackerScytheElune.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = trackerScytheElune.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	-- This returns the spellID for the current Scythe of Elune Spell
	statePrototype.ScytheSpellID = function(state)
		return scytheSpellID;
	end

	-- This returns the count for the SpellID passed to it
	statePrototype.ScytheSpellCharges = function(state)
		local returnValue = scytheCharges or 0;

		if returnValue < 0 then
			returnValue = 0;
		elseif returnValue > MAX_CHARGES then
			returnValue = MAX_CHARGES;
		end

		return returnValue;
	end
    --</public-static-methods>
end