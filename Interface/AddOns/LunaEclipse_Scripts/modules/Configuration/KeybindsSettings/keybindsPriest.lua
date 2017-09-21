local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsPriest";
    local keybindsPriest = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_PRIEST then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.PRIEST_DISCIPLINE then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonPriest = addonTable.commonPriest,
					disciplinePriest = addonTable.disciplinePriest,
				};
			elseif currentSpec == addonTable.PRIEST_HOLY then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonPriest = addonTable.commonPriest,
					holyPriest = addonTable.holyPriest,
				};
			elseif currentSpec == addonTable.PRIEST_SHADOW then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonPriest = addonTable.commonPriest,
					shadowPriest = addonTable.shadowPriest,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonPriest = addonTable.commonPriest,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsPriest:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsPriest:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsPriest:OnEnable()
			-- Create the override table for Priests.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementPriest);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsPriest:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end