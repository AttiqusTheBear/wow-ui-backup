local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsHunter";
    local keybindsHunter = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_HUNTER then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.HUNTER_BEASTMASTERY then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonHunter = addonTable.commonHunter,
					beastMasteryHunter = addonTable.beastMasteryHunter,
				};
			elseif currentSpec == addonTable.HUNTER_MARKSMANSHIP then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonHunter = addonTable.commonHunter,
					marksmanshipHunter = addonTable.marksmanshipHunter,
				};
			elseif currentSpec == addonTable.HUNTER_SURVIVAL then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonHunter = addonTable.commonHunter,
					survivalHunter = addonTable.survivalHunter,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonHunter = addonTable.commonHunter,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsHunter:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsHunter:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsHunter:OnEnable()
			-- Create the override table for Hunters.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementHunter);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsHunter:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end