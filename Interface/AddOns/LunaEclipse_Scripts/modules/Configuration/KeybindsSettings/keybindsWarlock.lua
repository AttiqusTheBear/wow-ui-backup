local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsWarlock";
    local keybindsWarlock = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_WARLOCK then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.WARLOCK_AFFLICTION then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonWarlock = addonTable.commonWarlock,
					afflictionWarlock = addonTable.afflictionWarlock,
				};
			elseif currentSpec == addonTable.WARLOCK_DEMONOLOGY then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonWarlock = addonTable.commonWarlock,
					demonologyWarlock = addonTable.demonologyWarlock,
				};
			elseif currentSpec == addonTable.WARLOCK_DESTRUCTION then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonWarlock = addonTable.commonWarlock,
					destructionWarlock = addonTable.destructionWarlock,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonWarlock = addonTable.commonWarlock,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsWarlock:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsWarlock:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsWarlock:OnEnable()
			-- Create the override table for Warlocks.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementWarlock);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsWarlock:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end