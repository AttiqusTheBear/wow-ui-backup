local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
    local moduleName = "TalentManager";
    local TalentManager = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
    addonTable.TalentManager = TalentManager;

	-- Codex Buff IDs.
	local AURA_CODEX_OF_THE_CLEAR_MIND = 227564; -- Level 100
	local AURA_CODEX_OF_THE_TRANQUIL_MIND = 226234; -- Max Level
	
	-- Preparation Buff IDs.
	local AURA_PREPARATION_ARENA = 32727;
	local AURA_PREPARATION_DUNGEON = 228128;

	-- Tome Buff IDs.
	local AURA_TOME_OF_THE_CLEAR_MIND = 227563; -- Level 109
	local AURA_TOME_OF_THE_TRANQUIL_MIND = 227041;  -- Max Level

	-- Tome and Codex buffs to check and the max valid level.
	-- Entries with a max level of 9999 is max level, the 9999 will ensure even if level cap is increased the spell will still count as valid.
	local TOME_BUFF_AURA = {
		[AURA_CODEX_OF_THE_CLEAR_MIND] = 100,
		[AURA_CODEX_OF_THE_TRANQUIL_MIND] = 9999, 
		[AURA_TOME_OF_THE_CLEAR_MIND] = 109,
		[AURA_TOME_OF_THE_TRANQUIL_MIND] = 9999,
	};

	-- Preparation buffs to check.
	local PREPARATION_AURA = {
		[AURA_PREPARATION_ARENA] = true,
		[AURA_PREPARATION_DUNGEON] = true,
	};

	-- Table to store changing talents queue, and the queued builds name.
	local talentQueue;
	local queuedBuild;

	local function queueCountFailed()
		-- Set the default return value.
		local returnValue = 0;
		
		-- Loop through all talents in the changes queue.
		for talentID, data in pairs(talentQueue) do
			-- Check to see if the talent failed.
			if data.failed then
				-- Only increase the counter if failed.
				returnValue = returnValue + 1;
			end
		end
		
		-- Return the count.
		return returnValue;
	end
	
    local function queueCountUnchecked()
		-- Set the default return value.
		local returnValue = 0;
		
		-- Loop through all talents in the changes queue.
		for talentID, data in pairs(talentQueue) do
			-- Check to see if the talent failed.
			if not data.failed then
				-- Only increase the counter if did not fail.
				returnValue = returnValue + 1;
			end
		end
		
		-- Return the count.
		return returnValue;
	end

	local function displayFailedTalents()
		-- Get the current active specialization.
		local specGroup = GetActiveSpecGroup();
		-- Get the count of the total number of talent changes that failed.
		local failedTalents = queueCountFailed();

		local talentString; 
		local counter = 0;

		-- Loop through all the talents in the queue, these should all be failed as successful ones are removed.
		for talentID, data in pairs(talentQueue) do
			-- Increase the counter.
			counter = counter + 1;
				
			if counter == 1 then
				-- First entry so just store the name.
				talentString = string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_ACTIVE, data.Name, addonTable.TEXT_COLOR_TAG_END);
			elseif counter == failedTalents then
				-- Last entry and there is more then one, so use "and" to join the new name.
				talentString = string.format("%s and %s%s%s", talentString, addonTable.TEXT_COLOR_TAG_ACTIVE, data.Name, addonTable.TEXT_COLOR_TAG_END);
			else
				-- Not first or last entry so seperate with commas.
				talentString = string.format("%s, %s%s%s", talentString, addonTable.TEXT_COLOR_TAG_ACTIVE, data.Name, addonTable.TEXT_COLOR_TAG_END);
			end
		end

		-- Display the popup window with the talent names that failed.
		StaticPopup_Show("LECS_TALENT_CHANGES_FAILED", string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_ACTIVE, queuedBuild, addonTable.TEXT_COLOR_TAG_END), talentString);

		-- Delete the talent queue now that the popup message box has been displayed.
		talentQueue = nil;
    end

	local function queueVerifyCompleted()
		local uncheckedTalents = queueCountUnchecked();
		local failedTalents = queueCountFailed();

		-- Check to see that all talents in the queue have been checked and at least one talent failed.
		if queuedBuild and uncheckedTalents == 0 then
			if failedTalents >= 1 then
				-- Display the popup window displaying the talents that failed.
				displayFailedTalents();
			end
			
			-- Reset queued builds name, as we have now finished the queue.
			queuedBuild = nil;
		end

	end

	local function queueAddTalent(talentID, talentName)
		-- Check to see if the talent queue is setup.
		if not talentQueue then
			-- It's not so lets make it a blank table.
			talentQueue = {};
		end

		-- Check to see if we were passed a talent.
		if talentID and talentName then
			-- Add it to the queue with a value of false meaning it hasn't been checked.
			talentQueue[talentID] = { Name = talentName };			
			-- Try to learn the talent.
			LearnTalent(talentID);
		end
	end

	local function queueRemoveTalent(talentID)
		-- Check to see if we were passed a talent, and that it is a talent currently in the queue.
		if talentID and talentQueue[talentID] then
			-- Set the entry to nil to remove it from the queue.
			talentQueue[talentID] = nil;
		end
	end

	local function queueTalentFailed(talentID)
		-- Check to see if we were passed a talent, and that it is a talent currently in the queue.
		if talentID and talentQueue[talentID] then
			-- Mark it as failed because it was a talent we were tracking.
			talentQueue[talentID].failed = true;
		end
	end

	local function applyTalents(buildTalents)
		-- Check that talents information was given
		if buildTalents then
			-- Get the current specialization group.
			local specGroup = GetActiveSpecGroup();
			-- Get the maximum row the player can select talents from.
			local numRows = GetMaxTalentTier();
			local selected, tier, column;

			-- Loop through all talents in the table.
			for talentID, talentName in pairs(buildTalents) do
				-- Get whether the talent is already selected.
				selected = select(4, GetTalentInfoByID(talentID, specGroup));
				-- Get the rown and column of the talent position.
				tier, column = select(8, GetTalentInfoByID(talentID, specGroup));
				
				-- Check to make sure the talent doesn't require a higher level to learn.
				if tier <= numRows then
					-- Check to see that the talent is not already selected.
					if not selected then 
						-- It's not selected and we have the required level so add it to the queue.
						queueAddTalent(talentID, talentName);
					end
				end
			end
		end
	end

	local function replaceTalentInString(talentString, tier, column)		
		-- Split the talent string, inserting the new column info into the correct position.
		return string.format("%s%s%s", string.sub(talentString, 1, tier - 1), tostring(column), string.sub(talentString, tier + 1));
	end

	local function covertStringToTalents(talentString, specGroup)
		local returnValue;
		
		-- Check to see if a talent string and specialization was given.
		if talentString and specGroup then
			local talentID, name;
			-- Get the number of rows in the talent string.
			local numRows = string.len(talentString);
			local column;
			
			-- Loop through the rows in the talent string.
			for row = 1, numRows do
				-- Set the column based on the value in the talent string.
				column = tonumber(string.sub(talentString, row, row));	
				
				-- Make sure a valid column is specified.
				if column >= 1 and column <= 3 then
					-- Get the infomation about the talent being checked.
					talentID, name = GetTalentInfo(row, column, specGroup);

					-- Check to see if the returnValue contains data.
					if not returnValue then
						-- It doesn't contain data so set it up as a new table.
						returnValue = {};
					end
						
					-- Store the talent name using the ID as the table key.
					returnValue[talentID] = name;
				end
			end
		end

		-- Return the talent table or nil if the player has no specialization.
		return returnValue;
	end

	local function convertTalentsToString(buildTalents, specGroup)
		-- Set default return value with no talents chosen.
		local returnValue = "0000000";

		if buildTalents and specGroup then
			local tier, column;

			-- Loop through all talents in the table.
			for talentID, talentName in pairs(buildTalents) do
				-- Get the rown and column of the talent position.
				tier, column = select(8, GetTalentInfoByID(talentID, specGroup));
				-- Modify the return value with the new information.
				returnValue = replaceTalentInString(returnValue, tier, column);
			end
		end

		-- Return the completed string.
		return returnValue;
	end

	local function equateTalentStrings(currentTalentString, buildTalentString)
		-- Set the return value to false by default.
		local returnValue = false;

		-- Check to see if we were supplied both a build talent string and preset talent string.
		if currentTalentString and buildTalentString then
			local currentTalent, buildTalent;
			-- Get the max number of talent rows to check.
			local numRows = GetMaxTalentTier();

			-- We have two strings to compare, so lets start by presuming they match.
			returnValue = true;

			-- Loop through all the rows the player can choose talents from.
			for row = 1, numRows do
				-- Get the column number of the talent from the current build.
				currentTalent = tonumber(string.sub(currentTalentString, row, row));
				-- Get the column number of the talent from the preset build.
				buildTalent = tonumber(string.sub(buildTalentString, row, row));

				-- Check to see if the talents don't match, and a talent is specified in the preset build.
				if currentTalent ~= buildTalent and buildTalent ~= 0 then
					-- They don't match so set the returnValue to false.
					returnValue = false;
					-- Exit the loop as there is no need to check any more.
					break;
				end
			end
		end

		-- Return whether the strings match, will also return false if no strings are provided.
		return returnValue;
	end

	local function getBuildName(talentString, specGroup)
        local returnValue;

		-- Check to make sure we have been given talents and specialization
		if talentString and specGroup then
			-- Gets the available builds for the current specialization.
			local specBuilds = TalentManager:GetAvailableBuilds();
			
			-- Check to see if we actually found some preset builds.
			if specBuilds then
				-- Loop through every build in the table.
				for buildName, buildTalentString in pairs(specBuilds) do
					-- Check to see if the stored talent string matches the talent string for the current talents.
					if equateTalentStrings(talentString, buildTalentString) then
						-- It matches so set the return value to the build name.
						returnValue = buildName;
						-- We found a match so lets just exit the loop.
						break;
					end
				end
			end
		end
		
		-- Return the build name if found, otherwise return "Custom Build" if there was no match.
		return returnValue or addonTable.CUSTOM_BUILD;
	end

	local function checkBuffActive(spellName)
		local returnValue;

		-- Only check for the buff if a spell name is given.
		if spellName then
			-- Return whether a buff is found on the player.
			returnValue = UnitBuff("player", spellName);
		end

		-- Return whether the buff was found, otherwise return false.
		return returnValue ~= nil;
	end

	local function getBuffActive()
		local returnValue;
		
		-- Get the players level to see if the buff is valid on them.
		local playerLevel = UnitLevel("player");
		local spellName;

		-- Loop through the array of tome and codex buffs to check.
		for spellID, requiredLevel in pairs(TOME_BUFF_AURA) do
			-- Get the spell name from the ID.
			spellName = GetSpellInfo(spellID);
			-- Check to ensure both the buff is active, and the player is of a valid level.
			returnValue = checkBuffActive(spellName) and (playerLevel <= requiredLevel);

			-- If a valid buff is found exit the loop, we don't need to check any more
			if returnValue then
				break;
			end
		end

		-- Return whether the buff was found, otherwise return false.		
		return returnValue or false;
	end
	
	local function getPreparationActive()
		local returnValue;
		local spellName;

		-- Loop through the array of preparation buffs to check.
		for spellID, enabled in pairs(PREPARATION_AURA) do
			-- Get the spell name from the ID.
			spellName = GetSpellInfo(spellID);			
			-- Check to ensure the buff is active
			returnValue = checkBuffActive(spellName);

			-- If a valid buff is found exit the loop, we don't need to check any more
			if returnValue then
				break;
			end
		end

		-- Return whether the buff was found, otherwise return false.
		return returnValue or false;
	end

	function TalentManager:ApplyBuild(buildName)
		-- Store whether talent changes are currently allowed.
		local changesAllowed = self:TalentChangesAllowed();

		if changesAllowed and buildName and buildName ~= "" then
			-- Get a talent table of the talents associated with the build name.
			local buildTalents = self:GetBuildTalents(buildName);

			if buildTalents then
				-- Strip any quotes from the build name just in case.
				queuedBuild = gsub(buildName, "\"", "");

				-- Learn the talents for the build name specified.
				applyTalents(buildTalents);
			else
				-- There is no talent information for the build name so display the popup message box.
				StaticPopup_Show("LECS_TALENT_CHANGES_TALENT_BUILD_UNAVAILABLE");
			end
		elseif not changesAllowed then
			-- Changes are not currently allowed, so display the popup message box.
			StaticPopup_Show("LECS_TALENT_CHANGES_NOT_PERMITTED");
		else
			-- No build name was given so display the popup message box.
			StaticPopup_Show("LECS_TALENT_CHANGES_NO_TALENT_BUILD");
		end
	end

	function TalentManager:GetAvailableBuilds()
		-- Get the builds from the account-wide profile.
		local presetBuilds = addonTable.presetBuilds;
		local currentScript = LunaEclipse_Scripts:GetCurrentScript();
		-- Get the players current specialization.
		local scriptName = currentScript;
        
		-- Return the builds available for the players specialization, will return nil if there are no builds.
		return (presetBuilds and presetBuilds[scriptName]) or nil;
	end

	function TalentManager:GetBuildTalents(buildName)
		local returnValue;		

		-- Check to see if we have a build name and make sure its not empty.
		if buildName and buildName ~= "" then
			-- Strip any quotes from the build name just in case.
			buildName = gsub(buildName, "\"", "");

			-- Get a table of the defined builds for the current specialization.
			local specBuilds = self:GetAvailableBuilds();

			-- Check to see if there is a table of builds, and that it contains a build with the name specified.
			if specBuilds and specBuilds[buildName] then
				-- Get the current specialization group.
				local specGroup = GetActiveSpecGroup();

				-- The build exists so convert the talent string into a talent table and store it in the return value.
				returnValue = covertStringToTalents(specBuilds[buildName], specGroup);
			end
		end

		-- Return the stored talent table, or nil if the build name did not exist or the player has no specialization chosen.
		return returnValue;
	end

	function TalentManager:GetCurrentBuildInfo()
		local returnValue;       
		-- Get the current specialization group.
		local specGroup = GetActiveSpecGroup();

		-- Check to see that the player has an active specialization.
        if specGroup then
			-- Get the players current talents as a table.
			local currentTalents = self:GetCurrentTalents();
			-- Convert the talent table into a talent string.
			local talentString = convertTalentsToString(currentTalents, specGroup);
			
			-- Set the return value data for the build.
			returnValue = {
				Name = getBuildName(talentString, specGroup),
				Talents = currentTalents,
			};
		end

		-- Return the infomation found, or nil if the player does not have a specialization.
		return returnValue;
	end

	function TalentManager:GetCurrentTalents()
		local returnValue;		
		-- Get the current specialization group.
		local specGroup = GetActiveSpecGroup();

		-- Check to see that the player has an active specialization.
		if specGroup then
			local talentID, name, texture, selected;
			-- Get the maximum row the player can select talents from.
			local numRows = GetMaxTalentTier();

			-- Loop through the rows where the player could choose talents from.
			for row = 1, numRows do
				-- Loop through each talent in the row.
				for column = 1, 3 do	
					-- Get the infomation about the talent being checked.
					talentID, name, texture, selected = GetTalentInfo(row, column, specGroup);

					-- Check to see if the talent is selected.
					if selected then
						-- Check to see if the returnValue contains data.
						if not returnValue then
							-- It doesn't contain data so set it up as a new table.
							returnValue = {};
						end
						
						-- Store the talent name using the ID as the table key.
						returnValue[talentID] = name;
						-- We found a talent in this row, so lets just move on to the next row.
						break;
					end
				end
			end
		end
		
		-- Return the table of selected talents, or nil if the player doesn't have any talents selected.
		return returnValue;
	end
	
	function TalentManager:TalentChangesAllowed()
		local returnValue;
		
		-- Check to make sure the player is not in combat.
		if not LunaEclipse_Scripts:InCombat() then
			-- Set the return value to true if the player is in a resting zone, or they have a valid preparation or tome buff.
			returnValue = IsResting() or getPreparationActive() or getBuffActive();
		end

		-- Return whether talent changes are allowed.
		return returnValue or false;
	end

    function TalentManager:OnEnable()
		-- Events to check for talent changes.
		self:RegisterEvent("PLAYER_LEARN_TALENT_FAILED");
		self:RegisterEvent("PLAYER_TALENT_UPDATE");
    end

    function TalentManager:OnDisable()		
		-- Events to check for talent changes.
		self:UnregisterEvent("PLAYER_LEARN_TALENT_FAILED");
		self:UnregisterEvent("PLAYER_TALENT_UPDATE");
    end

	function TalentManager:PLAYER_LEARN_TALENT_FAILED(event, ...)
		-- Check to see there is even a queue to check
		if talentQueue then
			-- Get the list of talents that failed since the last clear.
			local failedTalents = GetFailedTalentIDs();
			local talentID;

			-- Loop through the failed talents.
			for counter = 1, #failedTalents do
				-- Get the talent ID.
				talentID = failedTalents[counter];
			
				-- Mark the talent as failed, this only happens if it is already in the queue.
				queueTalentFailed(talentID);
			end

			-- Clear the list of failed talents.
			ClearFailedTalentIDs();		

			-- Check if the talent queue has been completed.
			queueVerifyCompleted();
		end
	end
	
	function TalentManager:PLAYER_TALENT_UPDATE(event, ...)
		-- Check to see there is even a queue to check
		if talentQueue then
			-- Get the current specialization group.
			local specGroup = GetActiveSpecGroup();

			-- We have no way of telling which talent succeeded, so loop through all the talents in the queue.
			for talentID, data in pairs(talentQueue) do
				-- Check to see if the talent has not already been marked as failed.
				if not data.failed then
					-- Check to see if the talent in the queue is now selected.
					if select(4, GetTalentInfoByID(talentID, specGroup)) then
						-- The talent is now selected so remove it from the queue.
						queueRemoveTalent(talentID);
					end
				end
			end
		
			-- Check if the talent queue has been completed.
			queueVerifyCompleted();
		end
	end
end