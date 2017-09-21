local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.

local LunaEclipse_Scripts = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0");
_G[addonName] = LunaEclipse_Scripts;

local Ovale = LibStub("AceAddon-3.0"):GetAddon("Ovale");
addonTable.Ovale = Ovale;

local FORCE_DEBUG = false;

function LunaEclipse_Scripts:isCompatableWOWVersion()
    if addonTable.WOW_VERSION_MIN and addonTable.WOW_VERSION_MAX then
        local versionRunning = addonTable.CURRENT_WOW_VERSION;
		
        self:SendMessage(addonTable.LECS_DEBUG, addonName, "isCompatableWOWVersion", FORCE_DEBUG, false, "Valid WoW Version Detected!");
        return (versionRunning >= addonTable.WOW_VERSION_MIN) and (versionRunning <= addonTable.WOW_VERSION_MAX);
    end
	
    self:SendMessage(addonTable.LECS_DEBUG, addonName, "isCompatableWOWVersion", FORCE_DEBUG, false, "Invalid WoW Version Detected!");
    return false;
end

function LunaEclipse_Scripts:isRequiredOvaleVersion(requiredVersion)
	local requiredMajorVersion, requiredMinorVersion, requiredRevisionVersion, requiredBuildVersion = string.split(".", requiredVersion);

	local ovaleVersionString = Ovale.version or Ovale.OvaleVersion.version;
	local alphaPosition, betaPosition, ovaleVersion, versionType;

	alphaPosition = string.find(ovaleVersionString, "alpha");
	betaPosition = string.find(ovaleVersionString, "beta");
	
	if alphaPosition then
		ovaleVersion = string.sub(ovaleVersionString, 1, alphaPosition - 1);
		versionType = addonTable.OVALE_ALPHA;
	elseif betaPosition then
		ovaleVersion = string.sub(ovaleVersionString, 1, betaPosition - 1);
		versionType = addonTable.OVALE_BETA;
	else
		ovaleVersion = ovaleVersionString;
		versionType = addonTable.OVALE_RELEASE;
	end
	
	local majorVersion, minorVersion, revisionVersion, buildVersion = string.split(".", ovaleVersion);

	return tonumber(majorVersion) > tonumber(requiredMajorVersion)
		or (tonumber(majorVersion) == tonumber(requiredMajorVersion) and tonumber(minorVersion) > tonumber(requiredMinorVersion))
		or (tonumber(majorVersion) == tonumber(requiredMajorVersion) and tonumber(minorVersion) == tonumber(requiredMinorVersion) and tonumber(revisionVersion) >= tonumber(requiredRevisionVersion))
		or (tonumber(majorVersion) == tonumber(requiredMajorVersion) and tonumber(minorVersion) == tonumber(requiredMinorVersion) and tonumber(revisionVersion) == tonumber(requiredRevisionVersion) and tonumber(buildVersion) >= tonumber(requiredBuildVersion))
end

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local ADDON_NAME = addonName;
	local ADDON_TITLE = GetAddOnMetadata(ADDON_NAME, "Title");
	local ADDON_AUTHOR = GetAddOnMetadata(ADDON_NAME, "Author");
	local ADDON_VERSION = GetAddOnMetadata(ADDON_NAME, "Version");

	local OvaleScripts = Ovale.OvaleScripts;
	local OvalePaperDoll = Ovale.OvalePaperDoll;

	local ScriptInfo;
	local previousSpec;

    local defaultAccountSettings = {
        profile = {
            AddonSettings = {
				switchNoScript = true,
				switchOldScript = false,
				switchUseNamplates = true,
			},

            LDBIconStorage = {
                hide = false,
            },
        },
    };

    local defaultCharacterSettings = {
        profile = {
            ScriptSettings = {
				opt_melee_range = true,
				opt_potion = true,
				opt_interrupt = true,
				opt_enemies_tagged = false,
				opt_major_cds_raid_only = true,
				opt_multi_dot_targets = "mdt_4",
			},

			KeybindSettings = {},

			SpecializationScripts = {},
			CustomScripts = {},

			NameplateSettings = {
				nameplateShowAll = true,
				nameplateShowEnemies = false,
				nameplateShowEnemyMinus = true,
				nameplateDistance = 60,
			},

			ClassSettings = {
				unholyDK_hiddenskin = false,
			},
 
			Trackers = {
				trackerArcaneBurnPhase = {
					burnPhase = false,
					startBurnPhase = 0,
					totalTime = 0,
					countBurnPhases = 0,
					averageBurnPhaseTime = 0,
					lastBurnPhaseTime = 0,
				},

				trackerSindoreiSpite = {
					cooldownEnd = 0,
				},

				trackerLordOfFlames = {
					cooldownEnd = 0,
				},
			},
			
			EnemiesDebug = {},
        },
    };

	local function backupNameplateSettings()
		local characterProfile = addonTable.characterSettings.profile;

		-- Get current Show All Nameplates setting and back it up to account settings profile
		addonTable.nameplateShowAll = GetCVarBool("nameplateShowAll");
 		characterProfile.NameplateSettings.nameplateShowAll = addonTable.nameplateShowAll;

		-- Get current Show Enemy Nameplates setting and back it up to account settings profile
		addonTable.nameplateShowEnemies = GetCVarBool("nameplateShowEnemies");
 		characterProfile.NameplateSettings.nameplateShowEnemies = addonTable.nameplateShowEnemies;

		-- Get current Show Enemy Minus Nameplates setting and back it up to account settings profile
		addonTable.nameplateShowEnemyMinus = GetCVarBool("nameplateShowEnemyMinus");
 		characterProfile.NameplateSettings.nameplateShowEnemyMinus = addonTable.nameplateShowEnemyMinus;

		-- Get current Nameplate Range setting and back it up to the account settings profile
		local currentDistance, defaultDistance = GetCVarInfo("nameplateMaxDistance");

		addonTable.nameplateDistance = (addonTable.nameplateDistance ~= true and tonumber(currentDistance)) or tonumber(defaultDistance);
 		characterProfile.NameplateSettings.nameplateDistance = addonTable.nameplateDistance;
	end

	local function backupScriptSettings()
		local characterProfile = addonTable.characterSettings.profile;
		local specInfo = LunaEclipse_Scripts:GetSpecializationInfo();
		
		characterProfile.SpecializationScripts[specInfo.name] = addonTable.currentScript;

		if addonTable.customScript and addonTable.customScript ~= "" then
			characterProfile.CustomScripts[specInfo.name] = addonTable.customScript;
		else
			characterProfile.CustomScripts[specInfo.name] = nil;
		end
	end

	local function changeScript()
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();
		
		if currentSpec then 
			local characterProfile = addonTable.characterSettings.profile;
			local specInfo = LunaEclipse_Scripts:GetSpecializationInfo();

			local currentScript = LunaEclipse_Scripts:GetCurrentScript();
			local scriptInfo = ScriptInfo:GetScriptInfo(currentScript);
			local scriptGuideVersion = (scriptInfo and scriptInfo.WoWVersion) or nil;
			
			if addonTable.currentScript and addonTable.currentScript == addonTable.CUSTOM_NAME then
				-- Custom script last used for the specialization so use it regardless.
				addonTable.currentScript = addonTable.CUSTOM_NAME;

				Ovale.db.profile.code = addonTable.customScript;
				OvaleScripts:RegisterScript(Ovale.playerClass, nil, addonTable.CUSTOM_NAME, addonTable.CUSTOM_DESCRIPTION, addonTable.customScript, "script");
			elseif addonTable.switchNoScript
			   and not addonTable.packageScript then
					-- No default package script available so switch to default Ovale script if the switch script setting is set.
					OvaleScripts:SetScript(addonTable.defaultScript);
			elseif addonTable.switchOldScript
				and (scriptInfo and scriptGuideVersion)
				and scriptGuideVersion < addonTable.CURRENT_WOW_VERSION then
					-- Switch to default Ovale script if the script is out of date and switch script setting is set.
					OvaleScripts:SetScript(addonTable.defaultScript);
			elseif addonTable.packageScript
			   and (not addonTable.currentScript or addonTable.currentScript == "LunaEclipse") then
					-- No last used script saved or currently using script name from previous versions
					-- so use the default script for the package.
					addonTable.currentScript = addonTable.packageScript;
					OvaleScripts:SetScript(addonTable.packageScript);
			else
				-- Set the script to the script last used for the specification.
				OvaleScripts:SetScript(addonTable.currentScript);
			end	

			if not previousSpec or currentSpec ~= previousSpec then 
				previousSpec = currentSpec;
				ScriptInfo:ShowScriptMessage(currentSpec);
			end
		end
	end

	local function getSavedNameplateSettings()
		local characterProfile = addonTable.characterSettings.profile;

		addonTable.nameplateShowAll = characterProfile.NameplateSettings.nameplateShowAll;
		addonTable.nameplateShowEnemies = characterProfile.NameplateSettings.nameplateShowEnemies;
		addonTable.nameplateShowEnemyMinus = characterProfile.NameplateSettings.nameplateShowEnemyMinus;
		addonTable.nameplateDistance = characterProfile.NameplateSettings.nameplateDistance;
	end
	
	local function enableNameplates()
		SetCVar("nameplateShowAll", true);
		SetCVar("nameplateShowEnemies", true);
		SetCVar("nameplateShowEnemyMinus", true);
		SetCVar("nameplateMaxDistance", 40);
	end	

	local function resetNameplates()
		SetCVar("nameplateShowEnemyMinus", addonTable.nameplateShowEnemyMinus);
		SetCVar("nameplateShowEnemies", addonTable.nameplateShowEnemies);
		SetCVar("nameplateShowAll", addonTable.nameplateShowAll);
		SetCVar("nameplateMaxDistance", addonTable.nameplateDistance)
	end

	local function setupConfiguration()
		local currentScript = LunaEclipse_Scripts:GetCurrentScript();

		if currentScript and addonTable.scriptSettings[currentScript] then
			addonTable.scriptOptions.args = addonTable.scriptSettings[currentScript];
		else
			addonTable.scriptOptions.args = {};
		end
	end

	function LunaEclipse_Scripts:OnInitialize()
		ScriptInfo = addonTable.ScriptInfo;
		
		addonTable.accountSettings = LibStub("AceDB-3.0"):New("LECS_AccountSettings", defaultAccountSettings, true);
        addonTable.characterSettings = LibStub("AceDB-3.0"):New("LECS_CharacterSettings", defaultCharacterSettings, true);
				
		local accountProfile = addonTable.accountSettings.profile;
		local characterProfile = addonTable.characterSettings.profile;

		-- Save the addon settings in the addon table
		for key, value in pairs(accountProfile.AddonSettings) do
			addonTable[key] = value;
		end

		-- Save the class specific settings in the addon table
 		for key, value in pairs(characterProfile.ClassSettings) do
			addonTable[key] = value;
		end

		self:AddonInfo_Display();
	end

	function LunaEclipse_Scripts:OnEnable()
		-- Get the previous settings saved in the addon settings profile for resetting to.
		-- This is in case you were in combat when you actually quit the game last, so it resets to the correct settings.
		getSavedNameplateSettings();

		if self:InCombat() and addonTable.switchUseNamplates then
			-- The addon is set to use nameplates, enable the needed nameplates for tracking.
			enableNameplates();
		elseif not self:InCombat() and addonTable.switchUseNamplates then
			-- The addon is set to use nameplates, reset the settings back to their previous setting.
			resetNameplates();
		end			

        self:RegisterChatCommand("LECS", "CMDLine");

		self:RegisterEvent("PLAYER_LOGIN");
        self:RegisterEvent("PLAYER_REGEN_ENABLED");
        self:RegisterEvent("PLAYER_REGEN_DISABLED");
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
	end

	function LunaEclipse_Scripts:OnDisable()
		self:UnregisterMessage("Ovale_ScriptChanged");

		self:UnregisterEvent("PLAYER_LOGIN");
        self:UnregisterEvent("PLAYER_REGEN_ENABLED");
        self:UnregisterEvent("PLAYER_REGEN_DISABLED");
		self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
 
		self:UnregisterChatCommand("LECS");
	end

    function LunaEclipse_Scripts:CMDLine(...)
		-- Nothing here, command line is only for testing features.
		local addonTitle, addonAuthor, addonVersion = LunaEclipse_Scripts:AddonInfo();
		local parameter = ...;

		if string.upper(parameter) == "DEBUG_ENEMIES" then
			addonTable.DEBUG_ENEMIES = not addonTable.DEBUG_ENEMIES;

			print(string.format("Enemy Debugging: %s", tostring(addonTable.DEBUG_ENEMIES)));
		else		
			print(string.format("%s Version: %s - Command line not supported!", addonTitle, addonVersion));
			print("Command line is only used for testing purposes!");
		end
    end

	function LunaEclipse_Scripts:AddonInfo(stripTags)
		if not stripTags then
			return string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_HIGHLIGHT, ADDON_TITLE, addonTable.TEXT_COLOR_TAG_END), string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_MESSAGE, ADDON_AUTHOR, addonTable.TEXT_COLOR_TAG_END), string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_HIGHLIGHT, ADDON_VERSION, addonTable.TEXT_COLOR_TAG_END);
		else
			return ADDON_TITLE, ADDON_AUTHOR, ADDON_VERSION;
		end
	end

	function LunaEclipse_Scripts:AddonInfo_Display()
		local addonTitle, addonAuthor, addonVersion = LunaEclipse_Scripts:AddonInfo();
	
		print(string.format("%s Version: %s loaded!", addonTitle, addonVersion));
	end

	function LunaEclipse_Scripts:GetClass()
		local classIndex = select(3, UnitClass("player"));

		return classIndex;
	end

	function LunaEclipse_Scripts:GetBaseMana(playerLevel)
		-- Return Variables
		local returnValue = addonTable.BASE_MANA[playerLevel];

		-- Check to see if we can get character information	
		local classID = self:GetClass();
		local currentSpec = self:GetSpecialization();

		if classID == CLASS_PRIEST
			or classID == addonTable.CLASS_MAGE 
			or classID == addonTable.CLASS_WARLOCK 
			or currentSpec == addonTable.PALADIN_HOLY 
			or currentSpec == addonTable.SHAMAN_ELEMENTAL or currentSpec == addonTable.SHAMAN_RESTORATION
			or currentSpec == addonTable.MONK_MISTWEAVER
			or currentSpec == addonTable.DRUID_BALANCE or currentSpec == addonTable.DRUID_RESTORATION then
				-- Priest, Mage and Warlock all have a Casters Base Mana pool no matter their specialization.
				-- Paladin, Shaman, Monk and Druid are Hybrid classes, they can either have Standard Base Mana pool or Caster Base Mana pool
				-- depending on their specialization.
				returnValue = addonTable.BASE_MANA[playerLevel] * 5;
		end

		return returnValue;
	end

	function LunaEclipse_Scripts:GetCurrentScript()
		return addonTable.currentScript or addonTable.Ovale.db.profile.source;
	end

	function LunaEclipse_Scripts:GetDefaultScript(currentSpec)
		return addonTable.DEFAULT_SCRIPT[currentSpec];
	end

	function LunaEclipse_Scripts:SetDefaultScript(specID, scriptName)
		if specID and scriptName then
			addonTable.DEFAULT_SCRIPT[specID] = scriptName;
		end
	end

	function LunaEclipse_Scripts:GetSpecialization()
		local returnValue;
		local specIndex = GetSpecialization();

		if specIndex then 
			returnValue = GetSpecializationInfo(specIndex);
		end

		return returnValue;
    end

    function LunaEclipse_Scripts:GetSpecializationInfo()
        local returnValue = nil;		
        local specIndex = GetSpecialization();

        if specIndex then 
            local specID, specName, specDescription, specIcon, specRole, specPrimaryStat = GetSpecializationInfo(specIndex);

            returnValue = {
                id = specID,
                name = specName,
                description = specDescription,
                icon = specIcon,
                role = specRole,
                primaryStat = specPrimaryStat,
            };
        end
		
		return returnValue;
	end

	function LunaEclipse_Scripts:InCombat()
		return UnitAffectingCombat("player");
	end
	
	function LunaEclipse_Scripts:IsPackageScript()
		return (addonTable.scriptInfo[addonTable.Ovale.db.profile.source] and true) or false;
	end

	function LunaEclipse_Scripts:OptionsKeybind(ID)	
 		local characterProfile = addonTable.characterSettings.profile;
		local key = string.lower(ID);
		local value = not characterProfile.ScriptSettings[key];

		characterProfile.ScriptSettings[key] = value;
		addonTable[key] = value;
	end

    function LunaEclipse_Scripts:ParseGUID(GUID)
		local unitType = string.split("-", GUID);
		local serverID, instanceID, zoneID, playerID, creatureID, spawnID;

		if unitType == addonTable.GUID_PLAYER then
			serverID, playerID = select(2, string.split("-", GUID));
		elseif unitType == addonTable.GUID_VIGNETTE then
			serverID, instanceID, zoneID = select(3, string.split("-", GUID));
			spawnID = select(7, string.split("-", GUID));
		else
			serverID, instanceID, zoneID, creatureID, spawnID = select(3, string.split("-", GUID));
		end        

		local returnValue = {
			Type = unitType,
			ServerID = serverID,
			InstanceID = instanceID,
			ZoneID = zoneID,
			PlayerID = playerID,
			CreatureID = creatureID,
			SpawnID = spawnID,
		};

		return returnValue;
    end

	function LunaEclipse_Scripts:ScriptKeybind(ID)	
		local key = string.lower(ID);
		local checked = not Ovale:IsChecked(key);
		local keyText = _G[string.format("BINDING_NAME_%s", string.upper(tostring(key)))];
		local statusText = (checked and string.format("%sOn!%s", addonTable.TEXT_COLOR_TAG_ACTIVE, addonTable.TEXT_COLOR_TAG_END)) or string.format("%sOff!%s", addonTable.TEXT_COLOR_TAG_INACTIVE, addonTable.TEXT_COLOR_TAG_END);

		Ovale:ToggleCheckBox(key);

		print(string.format("%s %s", keyText, statusText));
	end

	function LunaEclipse_Scripts:PLAYER_LOGIN(event, ...)
		local currentSpec = self:GetSpecialization();
	
		if currentSpec and (not previousSpec or currentSpec ~= previousSpec) then 
			local characterProfile = addonTable.characterSettings.profile;
			local specInfo = self:GetSpecializationInfo();

			addonTable.defaultScript = OvaleScripts:GetDefaultScriptName(Ovale.playerClass, OvalePaperDoll:GetSpecialization(GetSpecialization()));
			addonTable.packageScript = LunaEclipse_Scripts:GetDefaultScript(specInfo.id);

			addonTable.currentScript = characterProfile.SpecializationScripts[specInfo.name];
			addonTable.customScript = characterProfile.CustomScripts[specInfo.name] or Ovale.db.profile.code;
			
			changeScript();
			backupScriptSettings();
			setupConfiguration();

			previousSpec = currentSpec;
		end

		self:RegisterMessage("Ovale_ScriptChanged", "OVALE_SCRIPT_CHANGED");
	end

    function LunaEclipse_Scripts:PLAYER_REGEN_DISABLED()
		-- Backup the current Nameplates settings
		backupNameplateSettings();

		-- If the addon is set to use nameplates, enable the needed nameplates for tracking
		if addonTable.switchUseNamplates then
			enableNameplates();
		end
    end

    function LunaEclipse_Scripts:PLAYER_REGEN_ENABLED()
		-- If the addon is set to use nameplates, reset the settings back to their previous setting
		if addonTable.switchUseNamplates then
			resetNameplates();
		end
    end

	function LunaEclipse_Scripts:PLAYER_SPECIALIZATION_CHANGED(event, ...)
		local eventUnit = select(1, ...);

		if eventUnit == "player" then
			local characterProfile = addonTable.characterSettings.profile;
			local specInfo = self:GetSpecializationInfo();

			addonTable.defaultScript = OvaleScripts:GetDefaultScriptName(Ovale.playerClass, OvalePaperDoll:GetSpecialization(GetSpecialization()));
			addonTable.packageScript = LunaEclipse_Scripts:GetDefaultScript(specInfo.id);
			
			addonTable.currentScript = characterProfile.SpecializationScripts[specInfo.name];
			addonTable.customScript = characterProfile.CustomScripts[specInfo.name] or Ovale.db.profile.code;
						
			changeScript();
			backupScriptSettings();
			setupConfiguration();
		end
	end

	function LunaEclipse_Scripts:OVALE_SCRIPT_CHANGED()
		local characterProfile = addonTable.characterSettings.profile;
		local specInfo = self:GetSpecializationInfo();
		
		addonTable.currentScript = ((addonTable.packageScript or addonTable.Ovale.db.profile.source == addonTable.CUSTOM_NAME) and addonTable.Ovale.db.profile.source) or nil;
		addonTable.customScript = addonTable.Ovale.db.profile.code;

		backupScriptSettings();
		setupConfiguration();
	end
end