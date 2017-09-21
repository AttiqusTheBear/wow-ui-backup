local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "functionsConfiguration";
    local functionsConfiguration = LunaEclipse_Scripts:NewModule(moduleName, "AceConsole-3.0", "AceEvent-3.0");
    addonTable.functionsConfiguration = functionsConfiguration;

	local Ovale = addonTable.Ovale;

	function functionsConfiguration:getAOETooltip(spellName, cooldownIcon)
		cooldownIcon = (not cooldownIcon and "ShortCD") or cooldownIcon;

		return string.format("Display %s on the main rotation icons, this will delay the rotation until the ability is used.\n\nIf this is unchecked it will display on the %s icon instead!", tostring(spellName), tostring(cooldownIcon));	
	end

	function functionsConfiguration:getBuffTooltip(spellName, cooldownIcon)
		cooldownIcon = (not cooldownIcon and "ShortCD") or cooldownIcon;

		return string.format("Display %s on the %s icon.\n\nWill not show at all if disabled.", tostring(spellName), tostring(cooldownIcon));
	end

	function functionsConfiguration:getCooldownTooltip(spellName, cooldownIcon)
		cooldownIcon = (not cooldownIcon and "ShortCD") or cooldownIcon;

		return string.format("Display %s on the main rotation icons, this will delay the rotation until the ability is used.\n\nIf this is unchecked it will display on the %s icon instead!", tostring(spellName), tostring(cooldownIcon));	
	end

	function functionsConfiguration:getDebuffTooltip(spellName, debuffPresent)
		if spellName and debuffPresent then
			return string.format("Display %s on the rotation icons, when the target does not have the %s debuff.\n\nWill not show at all if disabled.", tostring(spellName), tostring(debuffPresent));
		elseif spellName and not buffPresent then
			return string.format("Display %s on the rotation icons.\n\nWill not show at all if disabled.", tostring(spellName));
		else
			return "";
		end
	end

	function functionsConfiguration:getDefensiveTooltip(spellName, cooldownIcon, healthPercent, buffPresent)
		cooldownIcon = (not cooldownIcon and "ShortCD") or cooldownIcon;

		if spellName and cooldownIcon and healthPercent and buffPresent then
			return string.format("Display %s on the %s icon, when you have the %s buff and you are below %s health.\n\nWill not show at all if disabled.", tostring(spellName), tostring(cooldownIcon), tostring(buffPresent), tostring(healthPercent));
		elseif spellName and cooldownIcon and healthPercent and not buffPresent then
			return string.format("Display %s on the %s icon, when you are below %s health.\n\nWill not show at all if disabled.", tostring(spellName), tostring(cooldownIcon), tostring(healthPercent));
		elseif spellName and cooldownIcon and not healthPercent and not buffPresent then
			return string.format("Display %s on the %s icon, when it is not active and is off cooldown.\n\nWill not show at all if disabled.", tostring(spellName), tostring(cooldownIcon));
		else
			return "";
		end
	end

	function functionsConfiguration:getKeybindTooltip(spellName)
		if spellName then
			return string.format("Set an override keybinding for %s, which Ovale will show instead of the detected the keybind.\n\nThis is useful for spells whose keybinds are not detected because the keybind was created in an unsupported addon such as BindPad!", tostring(spellName));
		else
			return "";
		end
	end

	function functionsConfiguration:getMultiDotTooltip(numberEnemies)
		return string.format("This will suggest applying DOTs to other targets if not enough targets have the DOT on them, it will stop suggesting once %s targets have the DOT applied to them.\n\nIf a cast has 'other' written on the rotation icons then it means apply it to an enemy that is not your current target.", tostring(numberEnemies));
	end

    function functionsConfiguration:getAddonValue(info)
		local returnValue;

		if info then
			local accountProfile = addonTable.accountSettings.profile;

 			returnValue = accountProfile.AddonSettings[info.arg];
		end

		return returnValue or false;
	end
	
	function functionsConfiguration:setAddonValue(info, value)
		if info then
			local accountProfile = addonTable.accountSettings.profile;

 			accountProfile.AddonSettings[info.arg] = value;
			addonTable[info.arg] = value;
		end
	end

    function functionsConfiguration:getClassValue(info)
		local returnValue;

		if info then
			local characterProfile = addonTable.characterSettings.profile;

 			returnValue = characterProfile.ClassSettings[info.arg];
		end

		return returnValue or false;
	end
	
	function functionsConfiguration:setClassValue(info, value)
		if info then
			local characterProfile = addonTable.characterSettings.profile;

 			characterProfile.ClassSettings[info.arg] = value;
			addonTable[info.arg] = value;
		end
	end

	function functionsConfiguration:getKeybindValue(info)
		local returnValue;

		if info then
			local key = info.arg;
			local characterProfile = addonTable.characterSettings.profile;

 			returnValue = characterProfile.KeybindSettings[key];
		end

		return returnValue or nil;
	end
	
	function functionsConfiguration:setKeybindValue(info, value)
		if info then
			local key = info.arg;
			local characterProfile = addonTable.characterSettings.profile;
			
 			characterProfile.KeybindSettings[key] = value;
		end
	end

    function functionsConfiguration:getMinimapIcon(info)
		local returnValue = true;

		if info then
			local accountProfile = addonTable.accountSettings.profile;

			returnValue = not accountProfile.LDBIconStorage.hide;
		end

		return returnValue;
	end
	
	function functionsConfiguration:setMinimapIcon(info, value)
		if info then
			local accountProfile = addonTable.accountSettings.profile;

			accountProfile.LDBIconStorage.hide = not value;

			self:SendMessage(addonTable.LECS_MINIMAP_TOGGLE);
		end
	end

    function functionsConfiguration:getScriptCheckbox(info)
		local returnValue;

		if info then
			local key = string.lower(info.arg);
			local ovaleWidget = Ovale:GetCheckBox(key);

			if ovaleWidget then
				returnValue = Ovale:IsChecked(key);
			else
				local ovaleProfile = Ovale.db.profile;

 				returnValue = ovaleProfile.check[key];
			end			
		end

		return returnValue or false;
	end
	
	function functionsConfiguration:setScriptCheckbox(info, value)
		if info then
			local key = string.lower(info.arg);
			local ovaleWidget = Ovale:GetCheckBox(key);

			if ovaleWidget then
				Ovale:SetCheckBox(key, value);
			else
				local ovaleProfile = Ovale.db.profile;

 				ovaleProfile.check[key] = value;
			end
		end
	end

    function functionsConfiguration:getScriptListbox(info)
		local returnValue;

		if info then
			local key = string.lower(info.arg);
			local ovaleWidget = Ovale:GetCheckBox(key);

			if ovaleWidget then
				returnValue = Ovale:GetListValue(key);
			else
				local ovaleProfile = Ovale.db.profile;

 				returnValue = ovaleProfile.list[key];
			end			
		end

		return returnValue or false;
	end
	
	function functionsConfiguration:setScriptListbox(info, value)
		if info then
			local key = string.lower(info.arg);
			local ovaleWidget = Ovale:GetListValue(key);

			if ovaleWidget then
				Ovale:SetListValue(key, value);
			else
				local ovaleProfile = Ovale.db.profile;

 				ovaleProfile.list[key] = value;
			end
		end
	end

	function functionsConfiguration:getScriptValue(info)
		local returnValue;

		if info then
			local key = string.lower(info.arg);
			local characterProfile = addonTable.characterSettings.profile;

 			returnValue = characterProfile.ScriptSettings[key];
		end

		return returnValue or false;
	end
	
	function functionsConfiguration:setScriptValue(info, value)
		if info then
			local key = string.lower(info.arg);
			local characterProfile = addonTable.characterSettings.profile;

 			characterProfile.ScriptSettings[key] = value;
		end
	end
end