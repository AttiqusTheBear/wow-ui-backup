local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local moduleName = "trackerUnitID";
	local trackerUnitID = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	addonTable.trackerUnitID = trackerUnitID;
	
	-- Table to store GUIDs for UnitIDs
	local unitGUIDs = {};
	local unitNamePlatesGUIDs = {};

	-- Table of UnitID to check manually because there is no events
	local manualUnitIDs = {
		["mouseover"] = true,
		["boss1"] = true,
		["boss2"] = true,
		["boss3"] = true,
		["boss4"] = true,
		["arena1"] = true,
		["arena2"] = true,
		["arena3"] = true,
		["arena4"] = true,
		["arena5"] = true,
	};

	local function convertUnitID(unitID)
		local unitType, unitNumber;
		
		if unitID then
			unitType = string.match(unitID, "%a+");
			unitNumber = string.match(unitID, "%d+");
		end
		
		return unitType, unitNumber;
	end

	local function storeGroupUnitID(partyType, partyNumber)
		if partyType and partyNumber then
			local unitID = string.format("%s%s", partyType, partyNumber);
			local petUnitID = string.format("%spet%s", partyType, partyNumber);

			unitGUIDs[unitID] = UnitGUID(unitID);
			unitGUIDs[petUnitID] = UnitGUID(petUnitID);
		end
	end

	function trackerUnitID:ConvertToUnitID(GUID)		
		for unitID, storedGUID in pairs(unitNamePlatesGUIDs) do
			if GUID == storedGUID then
				return unitID;
			end
		end

		for unitID, storedGUID in pairs(unitGUIDs) do
			if GUID == storedGUID then
				return unitID;
			end
		end

		for unitID, data in pairs(manualUnitIDs) do
			if GUID == UnitGUID(unitID) then
				return unitID;
			end
		end
		
		return nil;
	end

	function trackerUnitID:GROUP_ROSTER_UPDATE(event, ...)
		for counter = 1, 4 do
			storeGroupUnitID("party", counter);
		end

		for counter = 1, 40 do
			storeGroupUnitID("raid", counter);
		end
	end

	function trackerUnitID:NAME_PLATE_UNIT_ADDED(event, ...)
		local unitID = ...;		

		unitNamePlatesGUIDs[unitID] = UnitGUID(unitID);
	end

	function trackerUnitID:NAME_PLATE_UNIT_REMOVED(event, ...)
		local unitID = ...;

		unitNamePlatesGUIDs[unitID] = nil;
	end

	function trackerUnitID:PLAYER_FOCUS_CHANGED(event, ...)
		local unitID = "focus";

		unitGUIDs[unitID] = UnitGUID(unitID);
	end

	function trackerUnitID:PLAYER_TARGET_CHANGED(event, ...)
		local unitID = "target";

		unitGUIDs[unitID] = UnitGUID(unitID);
	end

	function trackerUnitID:UNIT_PET(event, ...)
		local unitID = ...;
		local unitType, unitNumber = convertUnitID(unitID);
		local newUnitID;
		
		if unitID then
			if unitID == "player" then
				newUnitID = "pet";
			else			
				if unitType then
					if unitNumber then
						newUnitID = string.format("%spet%s", unitType, unitNumber);
					else
						newUnitID = string.format("%spet", unitType);
					end
				end
			end

			unitGUIDs[newUnitID] = UnitGUID(newUnitID);
		end
	end

	function trackerUnitID:UNIT_TARGET(event, ...)
		local unitID = ...;
		
		if unitID and unitID ~= "player" then
			local newUnitID = string.format("%starget", unitID);

			unitGUIDs[newUnitID] = UnitGUID(newUnitID);
		end
	end

	function trackerUnitID:OnEnable()
		-- Set player GUID to table
		unitGUIDs["player"] = UnitGUID("player");

		-- Nameplate Events
		self:RegisterEvent("NAME_PLATE_UNIT_ADDED");
		self:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
		
		-- Player specific Events
		self:RegisterEvent("PLAYER_TARGET_CHANGED");
		self:RegisterEvent("PLAYER_FOCUS_CHANGED");
		
		-- Events for any valid UnitID
		self:RegisterEvent("UNIT_PET");
		self:RegisterEvent("UNIT_TARGET");
		
		-- Group/Raid Events
		self:RegisterEvent("GROUP_ROSTER_UPDATE");
	end

	function trackerUnitID:OnDisable()
		-- Group/Raid Events
		self:UnregisterEvent("GROUP_ROSTER_UPDATE");

		-- Events for any valid UnitID
		self:UnregisterEvent("UNIT_TARGET");
		self:UnregisterEvent("UNIT_PET");

		-- Player specific Events
		self:UnregisterEvent("PLAYER_FOCUS_CHANGED");
		self:UnregisterEvent("PLAYER_TARGET_CHANGED");

		-- Nameplate Events
		self:UnregisterEvent("NAME_PLATE_UNIT_ADDED");
		self:UnregisterEvent("NAME_PLATE_UNIT_REMOVED");		
		
		-- Clear GUID tables
		unitNamePlatesGUIDs = nil;
		unitGUIDs = nil;
	end
end