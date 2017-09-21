local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsWarrior";
    local keybindsWarrior = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_WARRIOR then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.WARRIOR_ARMS then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonWarrior = addonTable.commonWarrior,
					armsWarrior = addonTable.armsWarrior,
				};
			elseif currentSpec == addonTable.WARRIOR_FURY then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonWarrior = addonTable.commonWarrior,
					furyWarrior = addonTable.furyWarrior,
				};
			elseif currentSpec == addonTable.WARRIOR_PROTECTION then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonWarrior = addonTable.commonWarrior,
					protectionWarrior = addonTable.protectionWarrior,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonWarrior = addonTable.commonWarrior,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsWarrior:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsWarrior:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsWarrior:OnEnable()
			-- Create the override table for Warriors.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementWarrior);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsWarrior:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end