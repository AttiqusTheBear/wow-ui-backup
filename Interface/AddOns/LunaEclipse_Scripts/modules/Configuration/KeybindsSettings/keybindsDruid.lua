local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsDruid";
    local keybindsDruid = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_DRUID then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.DRUID_BALANCE then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDruid = addonTable.commonDruid,
					balanceDruid = addonTable.balanceDruid,
				};
			elseif currentSpec == addonTable.DRUID_FERAL then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDruid = addonTable.commonDruid,
					feralDruid = addonTable.feralDruid,
				};
			elseif currentSpec == addonTable.DRUID_GUARDIAN then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDruid = addonTable.commonDruid,
					guardianDruid = addonTable.guardianDruid,
				};
			elseif currentSpec == addonTable.DRUID_RESTORATION then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDruid = addonTable.commonDruid,
					restorationDruid = addonTable.restorationDruid,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonDruid = addonTable.commonDruid,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsDruid:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsDruid:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsDruid:OnEnable()
			-- Create the override table for Druids.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementDruid);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsDruid:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end