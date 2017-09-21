local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;
	local OvaleData = Ovale.OvaleData;
	local OvaleGUID = Ovale.OvaleGUID;
	local OvaleEquipment = Ovale.OvaleEquipment;
	local OvaleSpellBook = Ovale.OvaleSpellBook;
	local OvaleArtifact = Ovale.OvaleArtifact;
	local OvaleHealth = Ovale.OvaleHealth;

	local OvaleCondition = Ovale.OvaleCondition;
	local Compare = OvaleCondition.Compare;
	local ParseCondition = OvaleCondition.ParseCondition;
	local TestBoolean = OvaleCondition.TestBoolean;
	local TestValue = OvaleCondition.TestValue;

	-- Legendary IDs
	local MANGAZAS_MADNESS = 132864;
	
	-- SpellID Constants
	local SPELLID_ARCANE_BLAST = 30451;
	local SPELLID_ARCANE_EXPLOSION = 1449;
	local SPELLID_ARCANE_MISSILES = 5143;

	local SPELLID_CONFLAGRATE = 17962;
	local SPELLID_FULL_MOON = 202771;
	local SPELLID_HALF_MOON = 202768;
	local SPELLID_NEW_MOON = 202767;

	local SPELLID_DISPERSION = 47585;
	local SPELLID_MIND_BLAST = 8092;

	local SPELLS_ADD_ARCANE_CHARGES = {
		[SPELLID_ARCANE_BLAST] = true,
		[SPELLID_ARCANE_EXPLOSION] = true,
		[SPELLID_ARCANE_MISSILES] = true,
	};
	
	local SPELLS_MODIFIED_ARCANE_CHARGES = {
		[SPELLID_ARCANE_BLAST] = true,
		[SPELLID_ARCANE_EXPLOSION] = true,
	};

	-- Artifact Trait Constants
	local TRAIT_FROM_THE_SHADOWS = 193642;
	local TRAIT_MASS_HYSTERIA = 194378;

	-- Internal function to round a number to x decimal places
	local function roundNumber(num, numDecimalPlaces)
		local mult = 10^(numDecimalPlaces or 0);
  
		return math.floor(num * mult + 0.5) / mult;
	end

	-- Internal function to perform a modulo operation
	local function Mod(a, b)
		return a - math.floor(a/b) * b;
	end

	do 
		--- Get the multiplier for the specified spellID currently on the target.
		-- @paramsig number or boolean
		-- @param spellID Optional. The spell ID for the debuff you want to get the multiplier of.
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return The multiplier of the debuff applied to the target.
		-- @return A boolean value for the result of the comparison.
		local function AppliedBleedMultiplier(positionalParams, namedParams, state, atTime)
			local spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
 			local target = ParseCondition(positionalParams, namedParams, state, "target");
			local targetGUID = OvaleGUID:UnitGUID(target);

			local value = state:GetExistingMultiplier(atTime, targetGUID, spellID);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("appliedbleedmultiplier", false, AppliedBleedMultiplier);

		--- Get the multiplier for the specified spellID if it was applied at the specified time.
		-- @paramsig number or boolean
		-- @param spellID Optional. The spell ID for the debuff you want to get the multiplier of.
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The multiplier for the debuff if it was applied at the specified time.
		-- @return A boolean value for the result of the comparison.
		local function CurrentBleedMultiplier(positionalParams, namedParams, state, atTime)
			local spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:GetCurrentMultiplier(atTime, spellID);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("currentbleedmultiplier", false, CurrentBleedMultiplier);
	end

	do
		--- Get whether the player is currently in an Arcane Burn Phase.
		-- @paramsig boolean
		-- @return A boolean value specifying when the player is in an Arcane Burn Phase.
		local function ArcaneBurnPhase(positionalParams, namedParams, state, atTime)
			local returnValue = state:ArcaneBurnActive();
			
			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("arcaneburnphase", false, ArcaneBurnPhase);

		--- Get the average time spent in Arcane Burn Phase based on previous Burn Phases.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The average time spent in Arcane Burn Phase in seconds.
		-- @return A boolean value for the result of the comparison.
		local function AverageArcaneBurn(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:ArcaneAverageBurnTime();
			
			return Compare(value, comparator, limit); 
		end

		OvaleCondition:RegisterCondition("averagearcaneburn", false, AverageArcaneBurn);
	
		--- Get the expected time to spent in Arcane Burn Phase based on previous Burn Phases and current Mana Percent.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The expected time to spend in Arcane Burn Phase in seconds based on Mana Percent.
		-- @return A boolean value for the result of the comparison.
		local function ExpectedArcaneBurn(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:ArcaneExpectedBurnTime();
			
			return Compare(value, comparator, limit); 
		end

		OvaleCondition:RegisterCondition("expectedarcaneburn", false, ExpectedArcaneBurn);

		--- Get the time spent in the Last Arcane Burn Phase.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The time spent in the Last Arcane Burn Phase in seconds.
		-- @return A boolean value for the result of the comparison.
		local function LastArcaneBurn(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:ArcaneLastBurnTime();
			
			return Compare(value, comparator, limit); 
		end

		OvaleCondition:RegisterCondition("lastarcaneburn", false, LastArcaneBurn);
	end

	do
		--- Get whether the player has the Bloodlust buff active.
		-- @paramsig boolean
		-- @return A boolean value specifying when the player has Bloodlust buff.
		local function BloodlustActive(positionalParams, namedParams, state, atTime)
			local returnValue = state:BloodlustActive(atTime);
			
			return TestBoolean(returnValue);
		end
		
		OvaleCondition:RegisterCondition("bloodlustactive", false, BloodlustActive);

		--- Get whether the player has the Bloodlust buff active.
		-- @paramsig number
		-- @return Will return 1 if the player has Bloodlust buff, otherwise will return 0.
		local function BloodlustActiveValue(positionalParams, namedParams, state, atTime)
			return (state:BloodlustActive(atTime) and 1) or 0;
		end
		
		OvaleCondition:RegisterCondition("bloodlustactivevalue", false, BloodlustActiveValue);
		
		--- Get whether the player has the Bloodlust debuff active.
		-- @paramsig boolean
		-- @return A boolean value specifying when the player has Bloodlust debuff.
		local function BloodlustDebuff(positionalParams, namedParams, state, atTime)
			local returnValue = state:BloodlustDebuff(atTime);
			
			return TestBoolean(returnValue);
		end
		
		OvaleCondition:RegisterCondition("bloodlustdebuff", false, BloodlustDebuff);

		--- Get whether the player has the Bloodlust debuff active.
		-- @paramsig number
		-- @return Will return 1 if the player has the Bloodlust debuff, otherwise will return 0.
		local function BloodlustDebuffValue(positionalParams, namedParams, state, atTime)
			return (state:BloodlustDebuff(atTime) and 1) or 0;
		end
		
		OvaleCondition:RegisterCondition("bloodlustdebuffvalue", false, BloodlustDebuffValue);
		
		--- Get the percentage of the group that has the debuff.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The percentage of group members with the bloodlust debuff.
		-- @return A boolean value for the result of the comparison.
		local function BloodlustPercentage(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:BloodlustPercentage(atTime);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("bloodlustpercentage", false, BloodlustPercentage);

		--- Get the time remaining on bloodlust.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The time remaining on bloodlust in seconds.
		-- @return A boolean value for the result of the comparison.
		local function BloodlustRemaining(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:BloodlustRemaining(atTime);
			
			return Compare(value, comparator, limit); 
		end

		OvaleCondition:RegisterCondition("bloodlustremaining", false, BloodlustRemaining);
	end

	do
		--- Returns whether the buff or debuff has just been applied.
		--- Buff/Debuff must have used less then 10% of the duration or 1 second whichever is larger
		-- @paramsig boolean
		-- @param spellID - The spell ID of the aura.
		-- @param any Optional. Sets by whom the aura was applied. If the aura can be applied by anyone, then set any=1.
		--     Defaults to any=0.
		--     Valid values: 0, 1.
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=player.
		--     Valid values: player, target, focus, pet.
		-- @return A boolean value for whether the buff/debuff is in the react period.
		local function BuffReact(positionalParams, namedParams, state, atTime)
			local returnValue = false;
			local auraID = positionalParams[1];
			local target, filter, mine = ParseCondition(positionalParams, namedParams, state);
			local aura = state:GetAura(target, auraID, filter, mine);
			
			if aura then
				local baseDuration = OvaleData:GetBaseDuration(auraID) or 1;
				local reactTime = math.max(baseDuration / 10, 1);
				local auraGained = aura.gain or 0;

				returnValue = atTime - auraGained <= reactTime;
			end

			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("buffreact", false, BuffReact);
		OvaleCondition:RegisterCondition("debuffreact", false, BuffReact);
	end

	do
		--- Get the number of elapsed ticks in the current channel of specified spell.
		-- @paramsig number or boolean
		-- @param spellID The spell ID for the channelled spell you want to get the information for.
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The number of elapsed ticks in the channel for the specified spell.
		-- @return A boolean value for the result of the comparison.
		local function ChannelCurrentTick(positionalParams, namedParams, state, atTime)
			local spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:CurrentChannelTick(spellID);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("channelcurrenttick", false, ChannelCurrentTick);

		--- Get the number of remaining ticks in the current channel of specified spell.
		-- @paramsig number or boolean
		-- @param spellID The spell ID for the channelled spell you want to get the information for.
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The number of remaining ticks in the channel for the specified spell.
		-- @return A boolean value for the result of the comparison.
		local function ChannelRemainingTicks(positionalParams, namedParams, state, atTime)
			local spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:RemainingChannelTick(spellID);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("channelremainingticks", false, ChannelRemainingTicks);

		--- Get the total number of ticks in the current channel of specified spell.
		-- @paramsig number or boolean
		-- @param spellID The spell ID for the channelled spell you want to get the information for.
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The total number of ticks in the channel for the specified spell.
		-- @return A boolean value for the result of the comparison.
		local function ChannelTotalTicks(positionalParams, namedParams, state, atTime)
			local spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:TotalChannelTick(spellID);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("channeltotalticks", false, ChannelTotalTicks);
	end

	do 
		--- Get the number of remaining ticks in the current channel of specified spell.
		-- @paramsig number or boolean
		-- @param spellID The spell ID for the channelled spell you want to get the information for.
		-- @return A boolean value for the result of the comparison.
		local function ChannelInterruptWithSpell(positionalParams, namedParams, state, atTime)
			local returnValue = false;
			
			local spellID = positionalParams[1];
			local currentCharges, maxCharges, cooldownStart, cooldownDuration = GetSpellCharges(spellID);
		
			if not maxCharges then
				cooldownStart, cooldownDuration = GetSpellCooldown(spellID);
				currentCharges = (cooldownStart == 0 and cooldownDuration == 0 and 1) or 0;
				maxCharges = 1;
			end	
		
			if currentCharges >= 1 then
				returnValue = true;
			end
			
			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("channelinterruptwithspell", false, ChannelInterruptWithSpell);
	end

	do
		--- Get whether the specified demon is active.
		-- @paramsig boolean
		-- @param creatureID Optional. The creature ID for the type of demon you want information about.
		-- @return A boolean value specifying if the demon is active or not.
		local function DemonActive(positionalParams, namedParams, state, atTime)
			local creatureID = positionalParams[1];
			local returnValue = state:DemonActive(creatureID, atTime);
			
			return TestBoolean(returnValue);
		end
		
		OvaleCondition:RegisterCondition("demonactive", false, DemonActive);

		--- Get counts of spawned demons.
		-- @paramsig number or boolean
		-- @param creatureID Optional. The creature ID for the type of demon you want information about.
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The count of demons of the type specified.
		-- @return A boolean value for the result of the comparison.
		local function EmpoweredDemonCount(positionalParams, namedParams, state, atTime)
			local creatureID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:EmpoweredDemonCount(creatureID, atTime);
			
			return Compare(value, comparator, limit);
		end

		local function RegularDemonCount(positionalParams, namedParams, state, atTime)
			local creatureID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:RegularDemonCount(creatureID, atTime);

			return Compare(value, comparator, limit); 
		end

		local function TotalDemonCount(positionalParams, namedParams, state, atTime)
			local creatureID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:TotalDemonCount(creatureID, atTime);

			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("empowereddemoncount", false, EmpoweredDemonCount);
		OvaleCondition:RegisterCondition("regulardemoncount", false, RegularDemonCount);
		OvaleCondition:RegisterCondition("totaldemoncount", false, TotalDemonCount);

		--- Get remaining time of spawned demons.
		-- @paramsig number or boolean
		-- @param creatureID Optional. The creature ID for the type of demon you want information about.
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The time until despawn of the specified demon.
		-- @return A boolean value for the result of the comparison.
		local function FirstDemonDespawn(positionalParams, namedParams, state, atTime)
			local creatureID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:FirstDemonDespawn(creatureID, atTime);

			return Compare(value, comparator, limit);
		end

		local function LastDemonDespawn(positionalParams, namedParams, state, atTime)
			local creatureID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:LastDemonDespawn(creatureID, atTime);

			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("firstdemondespawn", false, FirstDemonDespawn);
		OvaleCondition:RegisterCondition("lastdemondespawn", false, LastDemonDespawn);
	end

	do 
		--- Get the time until the next dispersion can be cast, if dispersion is not on cooldown it will show the full cooldown.
		-- @name TimeToNextDispersion
		-- @paramsig number or boolean
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @return The time until the next dispersion can be cast, if dispersion is not on cooldown it will show the full cooldown.
		-- @return A boolean value for the result of the comparison.
		local function TimeToNextDispersion(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];

			local rankFromTheShadows = OvaleArtifact:TraitRank(TRAIT_FROM_THE_SHADOWS) or 0;
			local returnValue = (GetSpellBaseCooldown(SPELLID_DISPERSION) / 1000) - (rankFromTheShadows * 10);
			
			local cooldownStart, cooldownDuration = GetSpellCooldown(SPELLID_DISPERSION);
			local globalCooldown = select(2, GetSpellCooldown(addonTable.SPELLID_GLOBAL_COOLDOWN));
		
			if cooldownStart > 0 and cooldownDuration > globalCooldown then
				returnValue = (cooldownStart + cooldownDuration) - GetTime();
			end

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("timetonextdispersion", false, TimeToNextDispersion);
	end

	do
		--- Get the number of targets affected by a tracked DOT.
		-- @name DOTTargetCount
		-- @paramsig number or boolean
		-- @param auraID - The aura spell ID.
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @return The count of the targets affected by the DOT.
		-- @return A boolean value for the result of the comparison.
		local function DOTTargetCount(positionalParams, namedParams, state, atTime)
			local auraID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local returnValue = state:DOTTargetCount(auraID, atTime);

			if not returnValue then
				returnValue = 0;
			end

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("dottargetcount", false, DOTTargetCount);
	end

	do
		--- Returns whether the Soul Effigy is active.
		-- @name EffigyActive
		-- @paramsig boolean
		-- @return A boolean value for whether the Soul Effigy is currently active.
		local function EffigyActive(positionalParams, namedParams, state, atTime)
			local returnValue = state:EffigyActive();

			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("effigyactive", false, EffigyActive);	

		--- Returns whether the SpellID is applied to the Soul Effigy.
		-- @name SoulEffigyDOTActive
		-- @paramsig boolean
		-- @param spellID The base spell ID.
		-- @return A boolean value for whether the Soul Effigy has the specified DOT on it.
		local function EffigyDOTActive(positionalParams, namedParams, state, atTime)
			local spellID = positionalParams[1];
			local returnValue = state:EffigyDOTActive(spellID, atTime);

			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("effigydotactive", false, EffigyDOTActive);	

		--- Returns the duration remaining of the DOT on the soul effigy.
		-- @name EffigyDOTRemaining
		-- @paramsig number or boolean
		-- @param spellID The base spell ID.
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @return The number of seconds.
		-- @return A boolean value for the result of the comparison.
		local function EffigyDOTRemaining(positionalParams, namedParams, state, atTime)
			local spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local returnValue = state:EffigyDOTRemaining(spellID, atTime);

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("effigydotremaining", false, EffigyDOTRemaining);	

		--- Returns the duration remaining of the DOT on the soul effigy.
		-- @name EffigyDOTStacks
		-- @paramsig number or boolean
		-- @param spellID The base spell ID.
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @return The number of stacks.
		-- @return A boolean value for the result of the comparison.
		local function EffigyDOTStacks(positionalParams, namedParams, state, atTime)
			local spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local returnValue = state:EffigyDOTStacks(spellID, atTime);

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("effigydotstacks", false, EffigyDOTStacks);	
	end

	do
		-- Internal function to get the time at which the aura reaches Pandemic stage, allowing for travel time of the spell to reapply it.
		local function PandemicTime(state, auraEnding, auraID, spellID)
			local spellInfo = spellID and OvaleData.spellInfo[spellID];
			-- Set the default return value to the current time, in case the aura does not exist so it will suggest reapplying it.
			local returnValue = GetTime();
			
			if state and auraID and auraEnding then
				local baseDuration = OvaleData:GetBaseDuration(auraID, state);
				local travelTime = (spellInfo and (spellInfo.travel_time or spellInfo.max_travel_time)) or 0;

				travelTime = ((travelTime > 0 and travelTime < 1) and 1) or travelTime;           			
				returnValue = auraEnding - (baseDuration * 0.3) - travelTime;
			end

			return returnValue;
		end

		--- Returns whether an aura on the soul effigy has less then 30% time left, accounting for travel time.
		-- @name EffigyInPandemicRange
		-- @paramsig boolean
		-- @param auraID The aura spell ID.
		-- @param spellID Optional. The base spell ID to calculate travel time.
		--     Travel time defaults to 0 seconds if no spell is specified.
		-- @return A boolean value based on if the aura on the soul effigy has less then 30% time remaining.
		local function EffigyInPandemicRange(positionalParams, namedParams, state, atTime)
			local auraID, spellID = positionalParams[1], positionalParams[2];
			local returnValue = false;
        
			if auraID then
				local auraEnding = state:EffigyDOTExpires(auraID);
				local pandemicTime = PandemicTime(state, auraEnding, auraID, spellID);
				
				if atTime >= pandemicTime and atTime <= auraEnding then
					returnValue = true;
				end
			else 
				returnValue = true;
			end
		
			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("effigyinpandemicrange", false, EffigyInPandemicRange);

		--- Get the number of seconds before the aura on the soul effigy reaches pandemic range.
		-- @name EffigyTimeToPandemicRange
		-- @paramsig number or boolean
		-- @param auraID The aura spell ID.
		-- @param spellID The base spell ID.
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @return The number of seconds.
		-- @return A boolean value for the result of the comparison.
		local function EffigyTimeToPandemicRange(positionalParams, namedParams, state, atTime)
			local auraID, spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3], positionalParams[4];
			local returnValue = 0;
        
			if auraID then
				local auraEnding = state:EffigyDOTExpires(auraID);
				local pandemicTime = PandemicTime(state, auraEnding, auraID, spellID);
				
				returnValue = pandemicTime - atTime;

				if returnValue < 0 then
					returnValue = 0;
				end
			end
		
			return Compare(returnValue, comparator, limit);
		end
		
		OvaleCondition:RegisterCondition("effigytimetopandemicrange", false, EffigyTimeToPandemicRange);

		--- Returns whether an aura has less then 30% time left, accounting for travel time.
		-- @name InPandemicRange
		-- @paramsig boolean
		-- @param auraID The aura spell ID.
		-- @param spellID Optional. The base spell ID to calculate travel time.
		--     Travel time defaults to 0 seconds if no spell is specified.
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=player.
		--     Valid values: player, target, focus, pet.
		-- @return A boolean value based on if the aura has less then 30% time remaining.
		local function InPandemicRange(positionalParams, namedParams, state, atTime)
			local auraID, spellID = positionalParams[1], positionalParams[2];
 			local target, filter, mine = ParseCondition(positionalParams, namedParams, state, "player");
			local auraInfo = state:GetAura(target, auraID, filter, mine);
			local returnValue = false;
        
			if auraInfo then
				local auraGain, auraStart, auraEnding = auraInfo.gain, auraInfo.start, auraInfo.ending;
				local pandemicTime = PandemicTime(state, auraEnding, auraID, spellID);
				
				if atTime >= pandemicTime and atTime <= auraEnding then
					returnValue = true;
				end
			else
				returnValue = true;
			end
		
			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("inpandemicrange", false, InPandemicRange);

		--- Get the number of seconds before the aura reaches pandemic range.
		-- @name TimeToPandemicRange
		-- @paramsig number or boolean
		-- @param auraID The aura spell ID.
		-- @param spellID The base spell ID.
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=player.
		--     Valid values: player, target, focus, pet.
		-- @return The number of seconds.
		-- @return A boolean value for the result of the comparison.
		local function TimeToPandemicRange(positionalParams, namedParams, state, atTime)
			local auraID, spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3], positionalParams[4];
 			local target, filter, mine = ParseCondition(positionalParams, namedParams, state, "player");
			local auraInfo = state:GetAura(target, auraID, filter, mine);
			local returnValue = 0;
        
			if auraInfo then
				local auraGain, auraStart, auraEnding = auraInfo.gain, auraInfo.start, auraInfo.ending;
				local pandemicTime = PandemicTime(state, auraEnding, auraID, spellID);
				
				returnValue = pandemicTime - atTime;

				if returnValue < 0 then
					returnValue = 0;
				end
			end
		
			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("timetopandemicrange", false, TimeToPandemicRange);
	end

	do
		-- Internal function for getting number of enemies.
		local function numEnemies(namedParams, state, atTime)
			local returnValue = state.enemies;
		
			if not returnValue then
				-- Use the profile's tagged enemies option or "opt_enemies_tagged" checkbox value as the default.
				if LunaEclipse_Scripts:IsPackageScript() then
					local useTagged = Ovale:IsChecked("opt_enemies_tagged");
				else
					local useTagged = Ovale.db.profile.apparence.taggedEnemies;
				end
			
				-- Override the default if "tagged" is explicitly given.
				if namedParams.tagged == 0 then
					useTagged = false;
				elseif namedParams.tagged == 1 then
					useTagged = true;
				end
			
				returnValue = (useTagged and state.taggedEnemies) or state.activeEnemies;
			end
		
			-- This ensures scripts have a value if not in combat or if in combat but nothing has been attacked.
			if returnValue < 1 then
				returnValue = 1;
			end

			return returnValue;
		end

		--- Get the number of hostile enemies on the battlefield.
		-- The minimum value returned is 1.
		-- @name Enemies
		-- @paramsig number or boolean
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @param tagged Optional. By default, all enemies are counted. To count only enemies directly tagged by the player, set tagged=1.
		--     Defaults to tagged=0.
		--     Valid values: 0, 1.
		-- @return The number of enemies.
		-- @return A boolean value for the result of the comparison.
		local function Enemies(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local returnValue = numEnemies(namedParams, state, atTime);
		
			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("enemies", false, Enemies);

		--- Get the number of members in the players group, returns 1 if not in a group.
		-- @name GroupMembers
		-- @paramsig number or boolean
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @return The number of group members.
		-- @return A boolean value for the result of the comparison.
		local function GroupMembers(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local returnValue = GetNumGroupMembers();
        		
			if returnValue == 0 then
				returnValue = 1;
			end

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("groupmembers", false, GroupMembers);

		--- Get the number of targets for multi-dotting.
		-- @name MultiDOTTargets
		-- @paramsig number or boolean
		-- @param overrideMax Optional. The number to override the config setting with.
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @return The number of enemies, or maxTargets, whichever is lower.
		-- @return A boolean value for the result of the comparison.
		local function MultiDOTTargets(positionalParams, namedParams, state, atTime)
			local overrideMax, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local returnValue = numEnemies(namedParams, state, atTime);
			local maxTargets = Ovale:GetListValue("opt_multi_dot_targets");
			
			maxTargets = maxTargets and string.sub(maxTargets, string.find(maxTargets, "_") + 1) or nil;
			maxTargets = maxTargets and overrideMax and math.min(tonumber(maxTargets), tonumber(overrideMax)) or nil;

			returnValue = returnValue and maxTargets and math.min(tonumber(returnValue), tonumber(maxTargets)) or returnValue;

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("multidottargets", false, MultiDOTTargets);
	end
	
	do
		--- Test if the player has a particular item equipped.
		-- @name HasEquippedItem
		-- @paramsig boolean
		-- @param item Item to be checked whether it is equipped.
		-- @param yesno Optional. If yes, then return true if the item is equipped. If no, then return true if it isn't equipped.
		--     Default is yes.
		--     Valid values: yes, no.
		-- @param ilevel Optional.  Checks the item level of the equipped item.  If not specified, then any item level is valid.
		--     Defaults to not specified.
		--     Valid values: ilevel=N, where N is any number.
		-- @param slot Optional. Sets the inventory slot to check.  If not specified, then all slots are checked.
		--     Defaults to not specified.
		--     Valid values: slot=SLOTNAME, where SLOTNAME is a valid slot name, e.g., HandSlot.
		local function HasEquippedItem(positionalParams, namedParams, state, atTime)
			local itemID, yesno = positionalParams[1], positionalParams[2];
			local iLevel, slot = namedParams.iLevel, namedParams.slot;
			
			local boolean = false;
			local slotID;
			
			if type(itemID) == "number" then
				if slot then
					slotID = OvaleEquipment:HasEquippedItem(itemID, slot);
				else
					slotID = OvaleEquipment:HasEquippedItem(itemID);
				end
		
				if slotID and (not iLevel or (iLevel and iLevel == OvaleEquipment:GetEquippedItemLevel(slotID))) then
					boolean = true;
				end
			elseif OvaleData.itemList[itemID] then
				for _, itemIDs in pairs(OvaleData.itemList[itemID]) do
					if slot then
						slotID = OvaleEquipment:HasEquippedItem(itemIDs, slot);
					else
						slotID = OvaleEquipment:HasEquippedItem(itemIDs);
					end

					if slotID and (not iLevel or (iLevel and iLevel == OvaleEquipment:GetEquippedItemLevel(slotID))) then
						boolean = true;
						break;
					end
				end
			end
			
			return TestBoolean(boolean, yesno);
		end

		OvaleCondition:RegisterCondition("hasequippeditem", false, HasEquippedItem);
	end

	do
		-- Internal function for getting information about stealable buffs
		local function getStealableBuffs(atTime)
			local returnValue;

			local buffCounter = 1
			local stealableCounter = 0;
            local buffName, _, _, _, _, _, expirationTime, _, isStealable, _, spellID = UnitAura("target", buffCounter, "HELPFUL");
			 
			while buffName do
				if spellID and isStealable and (expirationTime and atTime < expirationTime) then
                    if not returnValue then
						returnValue = {};
					end

					stealableCounter = stealableCounter + 1;
					
					returnValue[spellID] = {
						name = buffName,
						stealable = isStealable,
						expires = expirationTime,
					};
                end
                
				buffCounter = buffCounter + 1;
                buffName, _, _, _, _, _, expirationTime, _, isStealable, _, spellID = UnitAura("target", buffCounter, "HELPFUL");
			end
			
			return returnValue, stealableCounter;
		end

		--- Get counts of stealable buffs.
		-- @name CountStealable
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The count of stealable buffs.
		-- @return A boolean value for the result of the comparison.
		local function CountStealable(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local stealableBuffs, countStealable = getStealableBuffs(atTime);
			
			return Compare(countStealable, comparator, limit);
		end

		--- Test if the target has any buffs that can be stolen with spellsteal.
		-- @name HasStealable
		-- @paramsig boolean
		-- @return A boolean value based on if there is any auras on the target that can be stolen.
		local function HasStealable(positionalParams, namedParams, state, atTime)
			local returnValue = false;
			local stealableBuffs, countStealable = getStealableBuffs(atTime);

			if countStealable > 0 then
				returnValue = true;
			end

			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("countstealable", false, CountStealable);
		OvaleCondition:RegisterCondition("hasstealable", false, HasStealable);
	end

	do 
		--- Get current Insanity Drain.
		-- @name InsanityDrain
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The current insanity drain, will return 0 if not in void form.
		-- @return A boolean value for the result of the comparison.
		local function InsanityDrain(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:CurrentInsanityDrain() or 0;
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("insanitydrain", false, InsanityDrain);

		--- Get Insanity Drain Stacks.
		-- @name InsanityDrainStacks
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The number of insanity drain stacks the player has, will return 0 if not in void form.
		-- @return A boolean value for the result of the comparison.
		local function InsanityDrainStacks(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:InsanityDrainStacks() or 0;
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("insanitydrainstacks", false, InsanityDrainStacks);
	end

	do
		--- Returns whether the target is a raid boss
		-- @paramsig boolean
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return A boolean value which will return true it's a raid boss, meaning either a world boss or a boss with no level information.
		local function IsRaidBoss(positionalParams, namedParams, state, atTime)
			local target = ParseCondition(positionalParams, namedParams, state, "target");

			local unitID = "target";
			local unitExists = UnitExists(unitID) or false;
			local isRaidBoss = (unitExists and (UnitClassification(unitID) == "worldboss" or UnitLevel(unitID) < 0)) or false;

			local targetGUID = UnitGUID(target);
			local unitGUID;

			if not isRaidBoss then
				-- Current target is not marked as a world boss, so lets check for valid boss UnitIDs, this will also find dungeon bosses.
				for counter = 1, 4 do
					-- Only check if the Unit Exists if the return value is still false.
					if not isRaidBoss then
						unitID = string.format("%s%s", "boss", tostring(counter));
						unitExists = UnitExists(unitID) or false;
						unitGUID = UnitGUID(unitID);

						isRaidBoss = (unitExists and unitGUID == targetGUID and (UnitClassification(unitID) == "worldboss" or UnitLevel(unitID) < 0)) or false;
					end
				end
			end

			-- Return whether it found a boss or not.
			return TestBoolean(isRaidBoss);
		end

		--- Returns whether the target is a dungeon or raid boss
		-- @paramsig boolean
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return A boolean value which will return true it's a dungeon or raid boss, this only checks for the presence of valid boss unitIDs.
		local function IsDungeonBoss(positionalParams, namedParams, state, atTime)
			local target = ParseCondition(positionalParams, namedParams, state, "target");

			local unitID = "target";
			local unitExists = UnitExists(unitID) or false;
			local isDungeonBoss = (unitExists and (UnitClassification(unitID) == "worldboss" or UnitLevel(unitID) < 0)) or false;

			local targetGUID = UnitGUID(target);
			local unitGUID;
		
			if not isDungeonBoss then
				-- Current target is not marked as a world boss, so lets check for valid boss UnitIDs, this will also find dungeon bosses.
				for counter = 1, 4 do
					-- Only check if the Unit Exists if the return value is still false.
					if not isDungeonBoss then
						unitID = string.format("%s%s", "boss", tostring(counter));
						unitExists = UnitExists(unitID) or false;
						unitGUID = UnitGUID(unitID);
						
						isDungeonBoss = (unitExists and unitGUID == targetGUID) or false;
					end
				end
			end

			-- Return whether it found a boss or not.
			return TestBoolean(isDungeonBoss);
		end

		--- Returns whether a cooldown should be used based on user preferences
		-- @paramsig boolean
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return A boolean value which will return true if the boss fight matches user requirements, 
		--         either a raid boss, or 5 man boss and user has not selected use cooldowns in raid only.
		local function IsBoss(positionalParams, namedParams, state, atTime)
			-- Get the users setting.
			local raidOnly = Ovale:IsChecked("opt_major_cds_raid_only");
			-- Return whether it found a valid boss or not based on the users settings.
			local returnValue = (not raidOnly and IsDungeonBoss(positionalParams, namedParams, state, atTime)) or IsRaidBoss(positionalParams, namedParams, state, atTime);

			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("israidboss", false, IsRaidBoss);
		OvaleCondition:RegisterCondition("isdungeonboss", false, IsDungeonBoss);
		OvaleCondition:RegisterCondition("isboss", false, IsBoss);

		--- Returns whether its a raid boss fight
		-- @paramsig boolean
		-- @return A boolean value which will return true it's a raid boss, meaning either a world boss or a boss with no level information.
		local function IsRaidBossFight(positionalParams, namedParams, state, atTime)
			local unitID = "target";
			local unitExists = UnitExists(unitID) or false;
			local isRaidBoss = (unitExists and (UnitClassification(unitID) == "worldboss" or UnitLevel(unitID) < 0)) or false;
			
			if not isRaidBoss then
				-- Current target is not marked as a world boss, so lets check for valid boss UnitIDs, this will also find dungeon bosses.
				for counter = 1, 4 do
					-- Only check if the Unit Exists if the return value is still false.
					if not isRaidBoss then
						unitID = string.format("%s%s", "boss", tostring(counter));
						unitExists = UnitExists(unitID) or false;
						isRaidBoss = (unitExists and (UnitClassification(unitID) == "worldboss" or UnitLevel(unitID) < 0)) or false;
					end
				end
			end

			-- Return whether it found a boss or not.
			return TestBoolean(isRaidBoss);
		end

		--- Returns whether its a dungeon or raid boss fight
		-- @paramsig boolean
		-- @return A boolean value which will return true it's a dungeon or raid boss, this only checks for the presence of valid boss unitIDs.
		local function IsDungeonBossFight(positionalParams, namedParams, state, atTime)
			local unitID = "target";
			local unitExists = UnitExists(unitID) or false;
			local isDungeonBoss = (unitExists and (UnitClassification(unitID) == "worldboss" or UnitLevel(unitID) < 0)) or false;
		
			if not isDungeonBoss then
				-- Current target is not marked as a world boss, so lets check for valid boss UnitIDs, this will also find dungeon bosses.
				for counter = 1, 4 do
					-- Only check if the Unit Exists if the return value is still false.
					if not isDungeonBoss then
						unitID = string.format("%s%s", "boss", tostring(counter));
						isDungeonBoss = UnitExists(unitID) or false;
					end
				end
			end

			-- Return whether it found a boss or not.
			return TestBoolean(isDungeonBoss);
		end

		--- Returns whether a cooldown should be used based on user preferences
		-- @paramsig boolean
		-- @return A boolean value which will return true if the boss fight matches user requirements, 
		--         either a raid boss, or 5 man boss and user has not selected use cooldowns in raid only.
		local function IsBossFight(positionalParams, namedParams, state, atTime)
			-- Get the users setting.
			local raidOnly = Ovale:IsChecked("opt_major_cds_raid_only");
			-- Return whether it found a valid boss or not based on the users settings.
			local returnValue = (not raidOnly and IsDungeonBossFight()) or IsRaidBossFight();

			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("israidbossfight", false, IsRaidBossFight);
		OvaleCondition:RegisterCondition("isdungeonbossfight", false, IsDungeonBossFight);
		OvaleCondition:RegisterCondition("isbossfight", false, IsBossFight);
	end
	
	do
		--- Get whether the player has Lady Vashj Grasp active.
		-- @paramsig boolean
		-- @return A boolean value specifying when the player has placed a Rune of Power.
		local function LadyVashjGraspActive(positionalParams, namedParams, state, atTime)
			local returnValue = state:LVGActive();
			
			return TestBoolean(returnValue);
		end
				
		--- Get the number of seconds since Lady Vashj Grasp triggered a Finger of Frost.
		-- Seconds will be -1 if Lady Vashj Grasp is not active.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The time since the last Finger of Frost triggered by Lady Vashj Grasp in seconds
		-- @return A boolean value for the result of the comparison.
		local function LadyVashjGraspLastFoF(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:LVGLastFoF(atTime) or -1;

			return Compare(value, comparator, limit);
		end

		--- Get the number of seconds until the next Lady Vashj Grasp triggered Finger of Frost.
		-- Seconds will be -1 if Lady Vashj Grasp is not active.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The time remaining until the next Finger of Frost triggered by Lady Vashj Grasp in seconds.
		-- @return A boolean value for the result of the comparison.
		local function LadyVashjGraspNextFoF(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:LVGNextFoF(atTime) or -1;
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("ladyvashjgraspactive", false, LadyVashjGraspActive);
		OvaleCondition:RegisterCondition("ladyvashjgrasplastfof", false, LadyVashjGraspLastFoF);
		OvaleCondition:RegisterCondition("ladyvashjgraspnextfof", false, LadyVashjGraspNextFoF);
	end

	do
		-- Internal function to calculate the current charges reported for the reported spell cost.
		-- This is needed because decaying charges does not lower the spell cost until charges reaches 0,
		-- so a spell can be cast with 2 charges at a cost of 3 charges.
		local function calculateCharges(cost, baseCost)
			local returnValue = 0;
			
			for counter = 0, 4 do
				if not returnValue and cost == baseCost * (1 + counter * 1.25) then
					returnValue = counter;
				end
			end

			return returnValue;
		end

		-- Internal function to determine base mana cost of a spell, in case it increases with charges.
		local function baseCost(spellID)
			local returnValue = 0;

			local playerLevel = UnitLevel("player");			
			local baseMana = LunaEclipse_Scripts:GetBaseMana(playerLevel);
			local powerCost = GetSpellPowerCost(spellID)[1];
			
			if powerCost and powerCost.type == SPELL_POWER_MANA then
				returnValue = roundNumber(baseMana * (powerCost.costPercent / 100), 0);
			end

			return returnValue;
		end

		-- Internal function to determine if a spell is being cast
		local function spellCasting(target, spellID)
			local castSpellID, returnValue;

			-- Get the information about the current spellcast.
			local spellName = UnitCastingInfo(target);
			
			-- If no spell information check to see if channeling a spell
			if not spellName then
				spellName = UnitChannelInfo(target);
			end

			-- Spell cast detected, so save the relevant information.
			if spellName then
 				castSpellID = select(7, GetSpellInfo(spellName));
			end

			if castSpellID then
				if not spellID then
					returnValue = castSpellID;
				else
					returnValue = (castSpellID == spellID);
				end
			end

			return returnValue;
		end

		--- Test if the target is casting the given spell.
		-- @paramsig number or boolean
		-- @param SpellID Optional. The SpellID to check.
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=player.
		--     Valid values: player, target, focus, pet.
		-- @return The SpellID being cast.
		-- @return A boolean value for the result of the comparison.
		local function IsCasting(positionalParams, namedParams, state, atTime)
			local spellID = positionalParams[1];
			local target = ParseCondition(positionalParams, namedParams, state, "player");
			local returnValue = spellCasting(target, spellID);
			
			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("iscasting", false, IsCasting)

		--- Get the amount of mana required to cast the given spell.
		-- This returns zero for spells that use either mana or another resource based on stance/specialization, e.g., Monk's Jab.
		-- @name ManaCost
		-- @paramsig number or boolean
		-- @param id The spell ID.
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @param max Optional. Set max=1 to return the maximum mana cost for the spell.
		--     Defaults to max=0.
		--     Valid values: 0, 1
		-- @param target Optional. Sets the target of the spell. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return The amount of mana.
		-- @return A boolean value for the result of the comparison.
		local function ManaCost(positionalParams, namedParams, state, atTime)
			local spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local target = ParseCondition(positionalParams, namedParams, state, "target");
			
			local maxCost = (namedParams.max == 1);
			local value = state:PowerCost(spellID, "mana", atTime, target, maxCost) or 0;

			if spellID and SPELLS_MODIFIED_ARCANE_CHARGES[spellID] then
				local maxArcaneCharges = UnitPowerMax("player", SPELL_POWER_ARCANE_CHARGES);

				local baseManaCost = baseCost(spellID);
				local maxManaCost = baseManaCost * (1 + maxArcaneCharges * 1.25)

				local arcaneCharges = calculateCharges(value, baseManaCost) + 1;
				local arcaneCasting = false;

				for spellID, enabled in pairs(SPELLS_ADD_ARCANE_CHARGES) do
					if not arcaneCasting then
						arcaneCasting = spellCasting("player", spellID);

						if arcaneCasting then
							value = math.min((value / (1 + (arcaneCharges - 1) * 1.25)) * (1 + arcaneCharges * 1.25), maxManaCost);
						end
					end
				end
			end
			
			return Compare(value, comparator, limit);
		end
		
		OvaleCondition:RegisterCondition("manacost", false, ManaCost);
	end

	do
		--- Get the spellID of the last Hit Combo spell cast.
		-- @name HitComboLastSpell
		-- @paramsig number or boolean
		-- @param spellID Optional. The spellID to compare against.
		-- @return The SpellID of the Hit Combo Spell last used.
		-- @return A boolean value for the result of the comparison of the last spell to the provided spellID.
		local function LastHitComboSpell(positionalParams, namedParams, state, atTime)
			local spellID = positionalParams[1];
			local returnValue = state:LastHitComboSpell();

			if not returnValue then
				returnValue = 0;
			end

			if spellID then
				return TestBoolean(spellID == returnValue);
			else
				return Compare(returnValue);
			end
		end

		OvaleCondition:RegisterCondition("lasthitcombospell", false, LastHitComboSpell);
	end

	do
		--- Get whether a legendary item has been equipped.
		-- @name LegendaryEquipped
		-- @paramsig boolean
		-- @return A boolean value based on whether the item is equipped or not.
		local function LegendaryEquipped(positionalParams, namedParams, state, atTime)
			local itemID = positionalParams[1];
			local returnValue = (itemID and IsEquippedItem(itemID)) or false;
			
			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("legendaryequipped", false, LegendaryEquipped);

		--- Get whether a legendary item has been equipped.
		-- @name LegendaryEquippedValue
		-- @paramsig number
		-- @return Returns 1 if the item is equipped, 0 otherwise.
		local function LegendaryEquippedValue(positionalParams, namedParams, state, atTime)
			local itemID = positionalParams[1];
			local returnValue = (itemID and IsEquippedItem(itemID)) and 1 or 0;
			
			return returnValue;
		end

		OvaleCondition:RegisterCondition("legendaryequippedvalue", false, LegendaryEquippedValue);
	end

	do 
		--- Get the time remaining on the Lord of Flames internal cooldown.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The time remaining on the internal cooldown in seconds.
		-- @return A boolean value for the result of the comparison.
		local function LordOfFlamesCooldown(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:LordOfFlamesCooldown(atTime);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("lordofflamescooldown", false, LordOfFlamesCooldown);
	end

	do
		--- Get the non Execute capable players percent.
		-- @name NonExecutePercent
		-- @paramsig number
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @return The percentage of non execute capable players.
		local function NonExecutePercent(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local returnValue = state:nonExecutePercent();

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("nonexecutepercent", false, NonExecutePercent);
	end

	do
		--- Get whether a pets spell is on cooldown.
		-- @name PetSpellCooldown
		-- @paramsig number or boolean
		-- @param id The spell ID.
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @return The number of seconds.
		-- @return A boolean value for the result of the comparison.
		local function PetSpellCooldown(positionalParams, namedParams, state, atTime)
			local spellID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local start, duration, enabled, modRate = GetSpellCooldown(spellID);
			
			local returnValue = (start > 0 and atTime < (start + duration) and (start + duration) - atTime) or 0;

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("petspellcooldown", false, PetSpellCooldown);
	end

	do 
		--- Get whether the player is moving, will only return true if the user has checked the moving option in the settings.
		-- @name MovementCheck
		-- @paramsig boolean
		-- @return A boolean value based on whether the player is moving, will return false if the movement check option is not enabled.
		local function MovementCheck(positionalParams, namedParams, state, atTime)
			-- Get the users setting.
			local checkMoving = Ovale:IsChecked("opt_moving");
			local returnValue = (checkMoving and GetUnitSpeed("player") * 100 / 7 > 0) or false;

			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("movementcheck", false, MovementCheck);

		--- Get whether the target is in range of the specified spell.
		-- @name RangeCheck
		-- @paramsig boolean
		-- @param id The spell ID.
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return A boolean value based on whether the target is in range.
		--         Will return true if the range check option is not enabled, spell does not return range information or there is no unit selected for the target information.
		local function RangeCheck(positionalParams, namedParams, state, atTime)
			local spellID = positionalParams[1];
			local target = ParseCondition(positionalParams, namedParams, state, "target");
			local checkRange = Ovale:IsChecked("opt_range_check");
			local inRange = OvaleSpellBook:IsSpellInRange(spellID, target);

			returnValue = (checkRange and (not inRange or inRange == 1)) or not checkRange;

			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("rangecheck", false, RangeCheck);
	end

	do
		--- Get whether a potion is on combat lockdown.
		-- @name PotionCombatLockdown
		-- @paramsig boolean
		-- @return A boolean value based on if the potion is on combat lockdown.
		local function PotionCombatLockdown(positionalParams, namedParams, state, atTime)
			local returnValue = state:PotionCombatLockdown();

			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("potioncombatlockdown", false, PotionCombatLockdown);
	end

	do
		--- Returns whether the target is affected by Roaring Blaze.
		-- @name RoaringBlazeActive
		-- @paramsig boolean
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return A boolean value based on if the targets immolate is affected by roaring blaze.
		local function RoaringBlazeActive(positionalParams, namedParams, state, atTime)
			local target = ParseCondition(positionalParams, namedParams, state, "target");
			local GUID = OvaleGUID:UnitGUID(target);

			local returnValue = state:RoaringBlazeActive(GUID, atTime);

			return TestBoolean(returnValue);
		end

		OvaleCondition:RegisterCondition("roaringblazeactive", false, RoaringBlazeActive);

		--- Returns the state for Conflagrate and Roaring Blaze.
		-- @name RoaringBlazeConflagrate
		-- @paramsig number or boolean
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return The number or additional recharges needed.
		-- @return A boolean value for the result of the comparison.
		local function RoaringBlazeAdditionalConflagrateCharges(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local target = ParseCondition(positionalParams, namedParams, state, "target");
			local GUID = OvaleGUID:UnitGUID(target);
			
			local chargesRoaringBlaze = state:RoaringBlazeStacks(GUID, atTime);
			local chargesConflagrate = state:GetSpellCharges(SPELLID_CONFLAGRATE, atTime) or 0;
			
			local returnValue = 3 - chargesRoaringBlaze - chargesConflagrate;

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("roaringblazeadditionalconflagratecharges", false, RoaringBlazeAdditionalConflagrateCharges);

		--- Returns the number of Roaring Blaze stacks the target has gained.
		-- @name RoaringBlazeStacks
		-- @paramsig number or boolean
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return The number of stacks of roaring blaze.
		-- @return A boolean value for the result of the comparison.
		local function RoaringBlazeStacks(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local target = ParseCondition(positionalParams, namedParams, state, "target");
			local GUID = OvaleGUID:UnitGUID(target);

			local returnValue = state:RoaringBlazeStacks(GUID, atTime);

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("roaringblazestacks", false, RoaringBlazeStacks);

		--- Returns the time remaining on the Roaring Blaze buff.
		-- @name RoaringBlazeTimeRemaining
		-- @paramsig number or boolean
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return The number of seconds of roaring blaze remaining.
		-- @return A boolean value for the result of the comparison.
		local function RoaringBlazeTimeRemaining(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local target = ParseCondition(positionalParams, namedParams, state, "target");
			local GUID = OvaleGUID:UnitGUID(target);

			local returnValue = state:RoaringBlazeTimeRemaining(GUID, atTime);

			return Compare(returnValue, comparator, limit);
		end

		OvaleCondition:RegisterCondition("roaringblazetimeremaining", false, RoaringBlazeTimeRemaining);
	end

	do
		--- Get whether the player has placed a Rune of Power.
		-- @paramsig boolean
		-- @return A boolean value specifying when the player has placed a Rune of Power.
		local function RuneOfPowerActive(positionalParams, namedParams, state, atTime)
			local returnValue = state:RuneActive(atTime);
			
			return TestBoolean(returnValue);
		end
		
		--- Get whether the player has the Rune of Power buff.
		-- @paramsig boolean
		-- @return A boolean value specifying when the player has Rune of Power buff.
		local function RuneOfPowerBuff(positionalParams, namedParams, state, atTime)
			local returnValue = state:RuneBuff();
			
			return TestBoolean(returnValue);
		end
		
		--- Get the time remaining on the Rune of Power.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The time remaining on the placed Rune of Power.
		-- @return A boolean value for the result of the comparison.
		local function RuneOfPowerTimeRemaining(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:RuneTimeRemaining(atTime);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("runeofpoweractive", false, RuneOfPowerActive);
		OvaleCondition:RegisterCondition("runeofpowerbuff", false, RuneOfPowerBuff);
		OvaleCondition:RegisterCondition("runeofpowertimeremaining", false, RuneOfPowerTimeRemaining);
	end

	do
		--- Test if the player has one of the Scythe Of Elune spells in their spellbook.
		-- @name HasScytheOfElune
		-- @paramsig boolean
		-- @param yesno Optional. If yes, then return true if the spell has been learned.
		--     If no, then return true if the player hasn't learned the spell.
		--     Default is yes.
		--     Valid values: yes, no.
		-- @return A boolean value.
		local function HasScytheOfElune(positionalParams, namedParams, state, atTime)
			local yesno = positionalParams[1];
			local returnValue = OvaleSpellBook:IsKnownSpell(SPELLID_FULL_MOON) or OvaleSpellBook:IsKnownSpell(SPELLID_HALF_MOON) or OvaleSpellBook:IsKnownSpell(SPELLID_NEW_MOON);
			
			return TestBoolean(returnValue, yesno);
		end
		
		OvaleCondition:RegisterCondition("hasscytheofelune", false, HasScytheOfElune);

		--- Get the number of charges for the Scythe Of Elune.
		-- @name ScytheOfEluneCharges
		-- @paramsig number or boolean
		-- @param operator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param number Optional. The number to compare against.
		-- @return The number of charges.
		-- @return A boolean value for the result of the comparison.
		local function ScytheOfEluneCharges(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local charges = state:ScytheSpellCharges();

			return Compare(charges, comparator, limit);
		end
		
		OvaleCondition:RegisterCondition("scytheofelunecharges", false, ScytheOfEluneCharges);

		--- Get the spellID of the active Scythe Of Elune spell.
		-- @name ScytheOfEluneSpell
		-- @paramsig number or boolean
		-- @param spellID Optional. The spellID to compare against.
		-- @return The SpellID of the active Scythe Of Elune spell.
		-- @return A boolean value for the result of the comparison of the active Scythe Of Elune spell to the provided spellID.
		local function ScytheOfEluneSpell(positionalParams, namedParams, state, atTime)
			local checkSpellID = positionalParams[1];
			local spellID = state:ScytheSpellID();

			if checkSpellID then
				return TestBoolean(checkSpellID == spellID);
			else
				return Compare(spellID);
			end
		end

		OvaleCondition:RegisterCondition("scytheofelunespell", false, ScytheOfEluneSpell);
	end

	do 
		--- Get the number of Shadowy Apparitions on the specified target.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @param target Optional. Sets the target to check. The target may also be given as a prefix to the condition.
		--     Defaults to target=target.
		--     Valid values: player, target, focus, pet.
		-- @return The number of shadowy apparitions targetting the specified unit.
		-- @return A boolean value for the result of the comparison.
		local function ShadowyApparitions(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local target = ParseCondition(positionalParams, namedParams, state, "target");
			local GUID = OvaleGUID:UnitGUID(target);
			local value = state:TargetShadowyApparitions(GUID);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("shadowyapparitions", false, ShadowyApparitions);

		--- Get the total number of Shadowy Apparitions on all targets.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The total number of shadowy apparitions active.
		-- @return A boolean value for the result of the comparison.
		local function TotalShadowyApparitions(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:TotalShadowyApparitions();
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("totalshadowyapparitions", false, TotalShadowyApparitions);
	end

	do 
		--- Get the time remaining on the Sindorei Spite internal cooldown.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The time remaining on the internal cooldown in seconds.
		-- @return A boolean value for the result of the comparison.
		local function SindoreiSpiteCooldown(positionalParams, namedParams, state, atTime)
		--- Get the Surrender to Madness check value.
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:SindoreiSpiteCooldown(atTime);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("sindoreispitecooldown", false, SindoreiSpiteCooldown);
	end

	do 
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The Surrender to Madness check value.
		-- @return A boolean value for the result of the comparison.
		local function SurrendToMadnessCheck(positionalParams, namedParams, state, atTime)
			local returnValue = 0
			local comparator, limit = positionalParams[1], positionalParams[2];

			if state.inCombat then
				local combatStart = state.combatStartTime;
				
				local timeInCombat = atTime - combatStart;
				local timeToDie = OvaleHealth:UnitTimeToDie("target");
				local expectedCombat = timeInCombat + timeToDie;
				local nonExecutePercent = state:nonExecutePercent();

				local modifierValue = 0;

				if expectedCombat <= 450 then
					modifierValue = Mod((450 - expectedCombat), 5);
				elseif expectedCombat > 450 and expectedCombat < 600 then
					modifierValue = -Mod((-450 + expectedCombat), 10);
				end

				local beltEquipped = (IsEquippedItem(MANGAZAS_MADNESS) and 1) or 0;
				local setBonusT19_2 = (OvaleEquipment:GetArmorSetCount("T19") >= 2 and 1) or 0;
				local setBonusT20_4 = (OvaleEquipment:GetArmorSetCount("T20") >= 4 and 1) or 0;

				local spellHaste = UnitSpellHaste("player") / 100;				

				local talentFotM = (select(4, GetTalentInfo(1, 2, GetActiveSpecGroup())) and 1) or 0;
				local talentReaper = (select(4, GetTalentInfo(4, 2, GetActiveSpecGroup())) and 1) or 0;
				local talentSanlayn = (select(4, GetTalentInfo(5, 1, GetActiveSpecGroup())) and 1) or 0;
				local traitMassHysteria = OvaleArtifact:TraitRank(TRAIT_MASS_HYSTERIA) or 0;

				returnValue = (0.8 * (83 + (20 + 20 * talentFotM) * setBonusT20_4 - (5 * talentSanlayn) + ((33 - 13 * setBonusT20_4) * talentReaper) + setBonusT19_2 * 4 + 8 * beltEquipped + (spellHaste * 10 * (1 + 0.7 * setBonusT20_4)) * (2 + (0.8 * setBonusT19_2) + (1 * talentReaper) + (2 * traitMassHysteria) - (1 * talentSanlayn)))) - (modifierValue * nonExecutePercent);
			end
			
			return Compare(math.min(returnValue, 180), comparator, limit);
		end

		OvaleCondition:RegisterCondition("surrendtomadnesscheck", false, SurrendToMadnessCheck);
	end

	do
		--- Get whether the player has placed Totem Mastery Totems.
		-- @paramsig boolean
		-- @return A boolean value specifying when the player has placed Totem Mastery Totems.
		local function TotemsActive(positionalParams, namedParams, state, atTime)
			local returnValue = state:TotemsActive(atTime);
			
			return TestBoolean(returnValue);
		end
		
		
		--- Get whether the player has the Totem Mastery buff.
		-- @paramsig boolean
		-- @return A boolean value specifying when the player has Totem Mastery buffs.
		local function TotemsBuff(positionalParams, namedParams, state, atTime)
			local returnValue = state:TotemsBuff();
			
			return TestBoolean(returnValue);
		end
		
		--- Get the time remaining on Totem Mastery.
		-- @paramsig number or boolean
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The time remaining on the placed Totem Mastery totems.
		-- @return A boolean value for the result of the comparison.
		local function TotemsTimeRemaining(positionalParams, namedParams, state, atTime)
			local comparator, limit = positionalParams[1], positionalParams[2];
			local value = state:TotemsTimeRemaining(atTime);
			
			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("totemsactive", false, TotemsActive);
		OvaleCondition:RegisterCondition("totemsbuff", false, TotemsBuff);
		OvaleCondition:RegisterCondition("totemstimeremaining", false, TotemsTimeRemaining);
	end

	do
		--- Get whether the specified undead is active.
		-- @paramsig boolean
		-- @param creatureID Optional. The creature ID for the type of undead you want information about.
		-- @return A boolean value specifying if the undead is active or not.
		local function UndeadActive(positionalParams, namedParams, state, atTime)
			local creatureID = positionalParams[1];
			local returnValue = state:UndeadActive(creatureID, atTime);
			
			return TestBoolean(returnValue);
		end
		
		OvaleCondition:RegisterCondition("undeadactive", false, UndeadActive);

		--- Get counts of spawned undead.
		-- @paramsig number or boolean
		-- @param creatureID Optional. The creature ID for the type of undead you want information about.
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The count of undead of the type specified.
		-- @return A boolean value for the result of the comparison.
		local function UndeadCount(positionalParams, namedParams, state, atTime)
			local creatureID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:UndeadCount(creatureID, atTime);

			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("undeadcount", false, UndeadCount);

		--- Get remaining time of spawned undead.
		-- @paramsig number or boolean
		-- @param creatureID Optional. The creature ID for the type of undead you want information about.
		-- @param comparator Optional. Comparison operator: less, atMost, equal, atLeast, more.
		-- @param limit Optional. The number to compare against.
		-- @return The time until despawn of the specified undead.
		-- @return A boolean value for the result of the comparison.
		local function FirstUndeadDespawn(positionalParams, namedParams, state, atTime)
			local creatureID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:FirstUndeadDespawn(creatureID, atTime);

			return Compare(value, comparator, limit);
		end

		local function LastUndeadDespawn(positionalParams, namedParams, state, atTime)
			local creatureID, comparator, limit = positionalParams[1], positionalParams[2], positionalParams[3];
			local value = state:LastUndeadDespawn(creatureID, atTime);

			return Compare(value, comparator, limit);
		end

		OvaleCondition:RegisterCondition("firstundeaddespawn", false, FirstUndeadDespawn);
		OvaleCondition:RegisterCondition("lastundeaddespawn", false, LastUndeadDespawn);
	end
end