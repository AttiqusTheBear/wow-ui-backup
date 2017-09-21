local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsShaman";
    local keybindsShaman = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_SHAMAN then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.SHAMAN_ELEMENTAL then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonShaman = addonTable.commonShaman,
					elementalShaman = addonTable.elementalShaman,
				};
			elseif currentSpec == addonTable.SHAMAN_ENHANCEMENT then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonShaman = addonTable.commonShaman,
					enhancementShaman = addonTable.enhancementShaman,
				};
			elseif currentSpec == addonTable.SHAMAN_RESTORATION then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonShaman = addonTable.commonShaman,
					restorationShaman = addonTable.restorationShaman,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonShaman = addonTable.commonShaman,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsShaman:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsShaman:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsShaman:OnEnable()
			-- Create the override table for Shamans.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementShaman);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsShaman:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end