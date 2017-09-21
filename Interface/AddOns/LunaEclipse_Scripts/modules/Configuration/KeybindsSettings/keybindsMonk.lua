local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsMonk";
    local keybindsMonk = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_MONK then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.MONK_BREWMASTER then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonMonk = addonTable.commonMonk,
					brewmasterMonk = addonTable.brewmasterMonk,
				};
			elseif currentSpec == addonTable.MONK_MISTWEAVER then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonMonk = addonTable.commonMonk,
					mistweaverMonk = addonTable.mistweaverMonk,
				};
			elseif currentSpec == addonTable.MONK_WINDWALKER then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonMonk = addonTable.commonMonk,
					windwalkerMonk = addonTable.windwalkerMonk,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonMonk = addonTable.commonMonk,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsMonk:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsMonk:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsMonk:OnEnable()
			-- Create the override table for Monks.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementMonk);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsMonk:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end