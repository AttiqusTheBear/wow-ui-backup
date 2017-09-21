local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsRogue";
    local keybindsRogue = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_ROGUE then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.ROGUE_ASSASSINATION then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonRogue = addonTable.commonRogue,
					assassinationRogue = addonTable.assassinationRogue,
				};
			elseif currentSpec == addonTable.ROGUE_OUTLAW then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonRogue = addonTable.commonRogue,
					outlawRogue = addonTable.outlawRogue,
				};
			elseif currentSpec == addonTable.ROGUE_SUBTLETY then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonRogue = addonTable.commonRogue,
					subtletyRogue = addonTable.subtletyRogue,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonRogue = addonTable.commonRogue,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsRogue:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsRogue:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsRogue:OnEnable()
			-- Create the override table for Rogues.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementRogue);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsRogue:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end