local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsPaladin";
    local keybindsPaladin = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_PALADIN then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.PALADIN_HOLY then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonPaladin = addonTable.commonPaladin,
					holyPaladin = addonTable.holyPaladin,
				};
			elseif currentSpec == addonTable.PALADIN_PROTECTION then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonPaladin = addonTable.commonPaladin,
					protectionPaladin = addonTable.protectionPaladin,
				};
			elseif currentSpec == addonTable.PALADIN_RETRIBUTION then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonPaladin = addonTable.commonPaladin,
					retributionPaladin = addonTable.retributionPaladin,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonPaladin = addonTable.commonPaladin,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsPaladin:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsPaladin:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsPaladin:OnEnable()
			-- Create the override table for Paladins.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementPaladin);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsPaladin:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end