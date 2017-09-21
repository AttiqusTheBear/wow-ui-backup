local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
    local Ovale = addonTable.Ovale;
	local trackerUnitID = addonTable.trackerUnitID;

    --<private-static-properties>
	local moduleName = "groupTracker";
	local groupTracker = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	addonTable.groupTracker = groupTracker;

    -- Forward declarations for module dependencies.
    local OvaleState = Ovale.OvaleState;

    -- Player's GUID.
	local playerGUID = nil;
	local groupMembers = {};

	local alwaysExecute = {
		[addonTable.PRIEST_SHADOW] = true,
		[addonTable.WARRIOR_ARMS] = true,
		[addonTable.WARRIOR_FURY] = true,
	};

	local conditionalExecute = {
		[addonTable.HUNTER_MARKSMANSHIP] = 100,
	};
    --</private-static-properties>

    --<private-static-methods>
    local function wipeData()
		wipe(groupMembers);
		groupMembers = {};
    end

	local function calculateNonExecute()
        local returnValue = 0;

		local execute = 0;
        local nonExecute = 0;

		local unitID, unitLevel;

		for GUID, specializationID in pairs(groupMembers) do
			unitID = trackerUnitID:ConvertToUnitID(GUID);
			unitLevel = UnitLevel(unitID);

			if alwaysExecute[specializationID] or (conditionalExecute[specializationID] and conditionalExecute[specializationID] <= unitLevel) then
				execute = execute + 1;
			else
				nonExecute = nonExecute + 1;
			end
		end

		if nonExecute + execute >= 1 then
			returnValue = nonExecute / (nonExecute + execute);
		end
		
		return returnValue;
	end
    --</private-static-methods>

    --<public-static-methods>
	function groupTracker:GROUP_ROSTER_UPDATE(event, ...)
		local inGroup = IsInGroup();
		local inRaid = (inGroup and IsInRaid()) or false;
		local unitID, unitGUID, unitInfo, unitSpecialization;

		wipeData();
		groupMembers[playerGUID] = GetInspectSpecialization("player") or 0;

		if inRaid then
			for counter = 1, 40 do
				unitID = string.format("%s%s", "raid", counter);
				unitGUID = UnitGUID(unitID);

				if unitGUID then
					unitInfo = LunaEclipse_Scripts:ParseGUID(unitGUID);

					if unitInfo.Type == addonTable.GUID_PLAYER then
						unitSpecialization = GetInspectSpecialization(unitID) or 0;

						groupMembers[unitGUID] = unitSpecialization;
					end
				end
			end
		elseif inGroup then
			for counter = 1, 4 do
				unitID = string.format("%s%s", "party", counter);
				unitGUID = UnitGUID(unitID);

				if unitGUID then
					unitInfo = LunaEclipse_Scripts:ParseGUID(unitGUID);
					
					if unitInfo.Type == addonTable.GUID_PLAYER then
						unitSpecialization = GetInspectSpecialization(unitID) or 0;
					
						groupMembers[unitGUID] = unitSpecialization;
					end
				end
			end
		end
	end

 	function groupTracker:PLAYER_SPECIALIZATION_CHANGED(event, ...)
		local unitID = select(1, ...);

		if unitID then
			local unitGUID = UnitGUID(unitID);

			if unitGUID then
				unitInfo = LunaEclipse_Scripts:ParseGUID(unitGUID);
					
				if unitInfo.Type == addonTable.GUID_PLAYER then
					unitSpecialization = GetInspectSpecialization(unitID) or 0;
					
					groupMembers[unitGUID] = unitSpecialization;
				end
			end
		end
	end

    function groupTracker:OnEnable()
		playerGUID = Ovale.playerGUID;

		groupMembers[playerGUID] = GetInspectSpecialization("player") or 0;

		self:RegisterEvent("GROUP_ROSTER_UPDATE");
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");

        OvaleState:RegisterState(self, self.statePrototype);
    end

    function groupTracker:OnDisable()
		self:UnregisterEvent("GROUP_ROSTER_UPDATE");
		self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");

        OvaleState:UnregisterState(self);
    end
    --</public-static-methods>

    --[[
    ----------------------------------------------------------------------------
        State machine for simulator.
    ----------------------------------------------------------------------------
    ]]
    --<public-static-properties>
    groupTracker.statePrototype = {};
    --</public-static-properties>

    --<private-static-properties>
    local statePrototype = groupTracker.statePrototype;
    --</private-static-properties>

    --<public-static-methods>
	statePrototype.nonExecutePercent = function(state)
		return calculateNonExecute() or 0;
	end
    --</public-static-methods>
end