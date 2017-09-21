local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local Ovale = addonTable.Ovale;

	local function OnDropDownValueChanged(ovaleWidget)
		-- Reflect the value change into the profile (model).
		local id = ovaleWidget:GetUserData("name");
	
		Ovale.db.profile.list[id] = ovaleWidget:GetValue();
		Ovale:SendMessage("Ovale_ListValueChanged", id);
	end

	function Ovale:GetListValue(id)
		local ovaleWidget = self.listWidget[id];
		local returnValue;

		if not ovaleWidget then
			local characterProfile = addonTable.characterSettings.profile;
			
			returnValue = characterProfile.ScriptSettings[id];
		else
			returnValue = ovaleWidget:GetValue();
		end

		return returnValue;
	end

	function Ovale:SetListValue(id, newState)
		-- New check I added to determine if id is a string
		if type(id) == "string" then
			local ovaleProfile = Ovale.db.profile;
			local ovaleWidget = Ovale.listWidget[id];

			ovaleWidget:SetValue(newState);
			ovaleProfile.list[id] = newState;

			OnDropDownValueChanged(ovaleWidget)
		end
	end

	local function OnCheckBoxValueChanged(ovaleWidget)
		-- Reflect the value change into the profile (model).
		local id = ovaleWidget:GetUserData("name");
		
		Ovale.db.profile.check[id] = ovaleWidget:GetValue();
		Ovale:SendMessage("Ovale_CheckBoxValueChanged", id);
	end

	function Ovale:GetCheckBox(id)
		local ovaleWidget;
		
		if type(id) == "string" then
			ovaleWidget = self.checkBoxWidget[id];
		elseif type(id) == "number" then
			-- "id" is a number, so count checkboxes until we reach the correct one (indexed from 0).
			local counter = 0;
			
			for _, checkBox in pairs(self.checkBoxWidget) do
				if counter == id then
					ovaleWidget = checkBox;
					break;
				end
				
				counter = counter + 1;
			end
		end
		
		return ovaleWidget;
	end
	
	-- Set the checkbox control to the specified on/off (true/false) value.
	function Ovale:SetCheckBox(id, newState)
		local ovaleWidget = self:GetCheckBox(id);
		
		if ovaleWidget then
			local oldValue = ovaleWidget:GetValue();
			
			if oldValue ~= newState then
				ovaleWidget:SetValue(newState);
				OnCheckBoxValueChanged(ovaleWidget);
			end
		end
	end

	-- Toggle the checkbox control.
	function Ovale:ToggleCheckBox(id)
		local ovaleWidget = self:GetCheckBox(id);
		
		if ovaleWidget then
			local newState = not ovaleWidget:GetValue();
			
			ovaleWidget:SetValue(newState);
			OnCheckBoxValueChanged(ovaleWidget);
		end
	end

	-- Determine whether a checkbox is checked, return false if not found.
	function Ovale:IsChecked(id)
		local ovaleWidget = self:GetCheckBox(id);
		local returnValue;

		if not ovaleWidget then
			local characterProfile = addonTable.characterSettings.profile;
			
			returnValue = characterProfile.ScriptSettings[id];
		else
			returnValue = ovaleWidget:GetValue();
		end

		return returnValue or false;
	end
end