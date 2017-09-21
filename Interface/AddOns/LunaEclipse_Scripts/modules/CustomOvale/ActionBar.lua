local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
    local Ovale = addonTable.Ovale;

    --<private-static-properties>
	local OvaleActionBar = addonTable.Ovale.OvaleActionBar;
    --</private-static-properties>
	
    --<private-static-methods>
	local function formatKeybind(keybindText)
		-- Shorten the keybinding names.
		if keybindText and strlen(keybindText) > 4 then
			-- Convert to Uppercase
			keybindText = strupper(keybindText);
			-- Strip whitespace.
			keybindText = gsub(keybindText, "%s+", "");
			-- Convert modifiers to a single character.
			keybindText = gsub(keybindText, "ALT%-", "A-");
			keybindText = gsub(keybindText, "CTRL%-", "C-");
			keybindText = gsub(keybindText, "SHIFT%-", "S-");
			-- Shorten numberpad keybinding names.
			keybindText = gsub(keybindText, "NUMPAD", "N");
			keybindText = gsub(keybindText, "PLUS", "+");
			keybindText = gsub(keybindText, "MINUS", "-");
			keybindText = gsub(keybindText, "MULTIPLY", "*");
			keybindText = gsub(keybindText, "DIVIDE", "/");
			keybindText = gsub(keybindText, "SPACE", "SP");
		end
		
		return keybindText;
	end

	-- Get keybind info based on either the SpellID or SlotID whichever is given.
	local function getDefaultKeybind(slotID)
		--[[
			ACTIONBUTTON1..12			=> primary (1..12, 13..24), bonus (73..120)
			MULTIACTIONBAR1BUTTON1..12	=> bottom left (61..72)
			MULTIACTIONBAR2BUTTON1..12	=> bottom right (49..60)
			MULTIACTIONBAR3BUTTON1..12	=> top right (25..36)
			MULTIACTIONBAR4BUTTON1..12	=> top left (37..48)
		--]]
		local actionName;
		
		if Bartender4 then
			actionName = "CLICK BT4Button" .. slotID .. ":LeftButton";
		else
			if slotID <= 24 or slotID > 72 then
				actionName = "ACTIONBUTTON" .. (((slotID - 1) % 12) + 1);
			elseif slotID <= 36 then
				actionName = "MULTIACTIONBAR3BUTTON" .. (slotID - 24);
			elseif slotID <= 48 then
				actionName = "MULTIACTIONBAR4BUTTON" .. (slotID - 36);
			elseif slotID <= 60 then
				actionName = "MULTIACTIONBAR2BUTTON" .. (slotID - 48);
			else
				actionName = "MULTIACTIONBAR1BUTTON" .. (slotID - 60);
			end
		end

		local keybindText = actionName and GetBindingKey(actionName);
		
		-- Shorten the keybinding names.
		keybindText = formatKeybind(keybindText);

		return keybindText;
	end

	-- Get a Keybind to display instead of the detected, this is useful for addons that Ovale can't detect keybindings for, such as BindPad.
	local function getOverrideKeybind(slotID)
		local returnValue;
		
		if slotID < 0 then
			local characterProfile = addonTable.characterSettings.profile;

			returnValue = characterProfile.KeybindSettings[slotID * -1];
			returnValue = (returnValue and returnValue ~= "" and formatKeybind(returnValue)) or nil;
		end
		
		return returnValue;
	end

	local function ParseHyperlink(hyperlink)
		local color, linkType, linkData, text = strmatch(hyperlink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+)|?h?%[?([^%[%]]*)%]?|?h?|?r?");

		return color, linkType, linkData, text
	end
    --</private-static-methods>

    --<public-static-methods>
	function OvaleActionBar:UpdateActionSlot(slotID)
		-- Clear old slotID and associated actions.
		local action = OvaleActionBar.action[slotID];

		if OvaleActionBar.spell[action] == slotID then
			OvaleActionBar.spell[action] = nil;
		elseif OvaleActionBar.item[action] == slotID then
			OvaleActionBar.item[action] = nil;
		elseif OvaleActionBar.macro[action] == slotID then
			OvaleActionBar.macro[action] = nil;
		end

		OvaleActionBar.action[slotID] = nil;

		-- Map the current action in the slotID.
		local actionType, ID, subType = GetActionInfo(slotID);
		
		if actionType == "spell" then
			ID = tonumber(ID);

			if ID then
				if not OvaleActionBar.spell[ID] or slotID < OvaleActionBar.spell[ID] then
					OvaleActionBar.spell[ID] = slotID;
				end
				
				OvaleActionBar.action[slotID] = ID;
			end
		elseif actionType == "item" then
			ID = tonumber(ID);
			
			if ID then
				if not OvaleActionBar.item[ID] or slotID < OvaleActionBar.item[ID] then
					OvaleActionBar.item[ID] = slotID;
				end
				
				OvaleActionBar.action[slotID] = ID;
			end
		elseif actionType == "macro" then
			ID = tonumber(ID);

			if ID then
				local actionText = GetActionText(slotID);

				if actionText then
					if not OvaleActionBar.macro[actionText] or slotID < OvaleActionBar.macro[actionText] then
						OvaleActionBar.macro[actionText] = slotID;
					end
					
					local _, _, spellID = GetMacroSpell(ID);

					if spellID then
						if not OvaleActionBar.spell[spellID] or slotID < OvaleActionBar.spell[spellID] then
							OvaleActionBar.spell[spellID] = slotID;
						end
						
						OvaleActionBar.action[slotID] = spellID;
					else
						local _, hyperlink = GetMacroItem(ID);
						
						if hyperlink then
							local _, _, linkData = ParseHyperlink(hyperlink);
							local itemID = gsub(linkData, ":.*", "");
							
							itemID = tonumber(itemID);
							
							if itemID then
								if not OvaleActionBar.item[itemID] or slotID < OvaleActionBar.item[itemID] then
									OvaleActionBar.item[itemID] = slotID;
								end
								
								OvaleActionBar.action[slotID] = itemID;
							end
						end
					end
					
					if not OvaleActionBar.action[slotID] then
						OvaleActionBar.action[slotID] = actionText;
					end
				end
			end
		end
		
		if OvaleActionBar.action[slotID] then
			OvaleActionBar:Debug("Mapping button %s to %s.", slotID, OvaleActionBar.action[slotID]);
		else
			OvaleActionBar:Debug("Clearing mapping for button %s.", slotID);
		end

		OvaleActionBar.keybind[slotID] = getDefaultKeybind(slotID);
	end

	function OvaleActionBar:UpdateKeyBindings()
		for slotID = 1, 120 do
			OvaleActionBar.keybind[slotID] = getDefaultKeybind(slotID);
		end
	end

	-- Get the keybinding for an action slotID.
	function OvaleActionBar:GetBinding(slotID)
		--print(tostring(slotID));
		return getOverrideKeybind(slotID) or OvaleActionBar.keybind[slotID];
	end

	-- Get the action slotID that matches a spell ID.
	function OvaleActionBar:GetForSpell(spellID)
		local savedKeybind;
		local characterProfile = addonTable.characterSettings.profile;
		local replacementID = addonTable.replacementSpells[spellID] or spellID;

		savedKeybind = characterProfile.KeybindSettings[replacementID];
		savedKeybind = (savedKeybind and savedKeybind ~= "" and formatKeybind(savedKeybind)) or nil;

		return (savedKeybind and (replacementID * -1)) or OvaleActionBar.spell[spellID];
	end
    --</public-static-methods>
end