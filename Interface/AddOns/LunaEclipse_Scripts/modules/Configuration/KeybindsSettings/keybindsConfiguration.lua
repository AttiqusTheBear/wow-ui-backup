local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsConfiguration";
    local keybindsConfiguration = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;

	addonTable.keybindOptions = {
		type = "group",
		name = "Keybind Display Overrides",
		handler = functionsConfiguration,
		args = {
		},
	};

	function keybindsConfiguration:OnInitialize()
		LibStub("AceConfig-3.0"):RegisterOptionsTable("LECS_KeybindSettings", addonTable.keybindOptions);

		addonTable.keybindSettingsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LECS_KeybindSettings", "Keybind Display Overrides", "LunaEclipse: Ovale Scripts");
	end
end