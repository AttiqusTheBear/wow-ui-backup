local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsDemonHunter";
    local keybindsDemonHunter = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_DEMONHUNTER then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.DEMONHUNTER_HAVOC then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDemonHunter = addonTable.commonDemonHunter,
					havocDemonHunter = addonTable.havocDemonHunter,
				};
			elseif currentSpec == addonTable.DEMONHUNTER_VENGEANCE then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDemonHunter = addonTable.commonDemonHunter,
					vengeanceDemonHunter = addonTable.vengeanceDemonHunter,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDemonHunter = addonTable.commonDemonHunter,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsDemonHunter:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsDemonHunter:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsDemonHunter:OnEnable()
			-- Create the override table for Demon Hunters.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementDemonHunter);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsDemonHunter:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end