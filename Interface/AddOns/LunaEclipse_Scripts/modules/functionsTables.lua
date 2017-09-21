local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
    local moduleName = "functionsTables";
    local functionsTables = LunaEclipse_Scripts:NewModule(moduleName);

    addonTable.functionsTables = functionsTables;

	local function compareTables(compareTable, comparisonTable)
		local returnValue = true;

	    for key, value in pairs(compareTable) do
            if type(value) == "table" then
				returnValue = functionsTables:EquateTables(value, comparisonTable[key]);
            else
				if comparisonTable[key] then
					returnValue = (value == comparisonTable[key]);
				else
					returnValue = false;
				end
            end
				
			if returnValue == false then
				break;
			end
        end

		return returnValue;
	end
	
	function functionsTables:CountTable(tableName)
		local returnValue = 0;
		
		if tableName then
			for tableKey, tableValue in pairs(tableName) do
				returnValue = returnValue + 1;
			end
		end
		
        return returnValue;
	end

    function functionsTables:DuplicateTables(originalTable)
        local returnValue = {};

        if originalTable then
            for key, value in pairs(originalTable) do
                if type(value) == "table" then
                    returnValue[key] = self:DuplicateTables(value);
                else
                    returnValue[key] = value;
                end
            end
        end
		
        return returnValue;
    end

    function functionsTables:EmptyTable(testTable)
        return self:CountTable(testTable) == 0;
    end

    function functionsTables:EquateTables(firstTable, secondTable)
        local returnValue = false;

        if firstTable and secondTable then
			-- Compare the contents of the first table to the second table for missing or unequal values
			returnValue = compareTables(firstTable, secondTable);
			
			-- Check to see if the contents were the same
			if returnValue then
				-- Compare the contents of the second table to the first table for missing values
				returnValue = compareTables(secondTable, firstTable);
			end
		end

        return returnValue;
    end

    function functionsTables:MergeTables(originalTable, mergeTable)
        local returnValue = self:DuplicateTables(originalTable);

		if mergeTable then
            for key, value in pairs(mergeTable) do
                returnValue[key] = value;
            end
        end
		
        return returnValue;
    end
end