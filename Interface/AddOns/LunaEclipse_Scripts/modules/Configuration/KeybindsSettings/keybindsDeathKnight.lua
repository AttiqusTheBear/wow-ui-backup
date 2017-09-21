local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsDeathKnight";
    local keybindsDeathKnight = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_DEATHKNIGHT then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.DEATHKNIGHT_BLOOD then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDeathKnight = addonTable.commonDeathKnight,
					bloodDeathKnight = addonTable.bloodDeathKnight,
				};
			elseif currentSpec == addonTable.DEATHKNIGHT_FROST then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDeathKnight = addonTable.commonDeathKnight,
					frostDeathKnight = addonTable.frostDeathKnight,
				};
			elseif currentSpec == addonTable.DEATHKNIGHT_UNHOLY then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDeathKnight = addonTable.commonDeathKnight,
					unholyDeathKnight = addonTable.unholyDeathKnight,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDeathKnight = addonTable.commonDeathKnight,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsDeathKnight:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsDeathKnight:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsDeathKnight:OnEnable()
			-- Create the override table for Death Knights.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementDeathKnight);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsDeathKnight:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end