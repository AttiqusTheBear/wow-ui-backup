local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

local baseDataBroker = LibStub("LibDataBroker-1.1");
local addonIcon = LibStub("LibDBIcon-1.0");
local addonTooltip = LibStub("LibQTip-1.0");

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) and baseDataBroker and addonIcon and addonTooltip then
    local moduleName = "LDBManager";
    local LDBManager = LunaEclipse_Scripts:NewModule(moduleName, "AceConsole-3.0", "AceEvent-3.0");
    addonTable.LDBManager = LDBManager;

	local TalentManager = addonTable.TalentManager;
	local ScriptInfo = addonTable.ScriptInfo;
	local functionsTables = addonTable.functionsTables;

    local dataTextName = "LunaEclipse: Custom Ovale Scripts";
    local availableBuildsName = "LunaEclipse_AvailableBuilds_Menu";
	
    local reloadRequired;	
    local iconTooltip;
    local dataBroker;

    local availableBuildsFrame = CreateFrame("Frame", availableBuildsName, UIParent, "UIDropDownMenuTemplate");
    local availableBuildsList = {
        { text = "Available Builds", isTitle = true, notCheckable = true },
    };

	local LDBDefaults = {
        icon = "Interface\\ICONS\\spell_nature_bloodlust",
        hide = false,
    };
	
    local clickTexture = {
        texture = "Interface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME",
        height = "16", width = "12",
        xOffset = "0", yOffset = "-1",
        xDimension = "512",	yDimension = "512",
        leftClick = {
            left = "9",	right = "69", top = "228", bottom = "308",
        },
        rightClick = {
            left = "9",	right = "69", top = "330", bottom = "410",
        },
    };

    local leftButtonTextureString = string.format("|T%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s|t", clickTexture.texture, clickTexture.height, clickTexture.width, clickTexture.xOffset, clickTexture.yOffset, clickTexture.xDimension, clickTexture.yDimension, clickTexture.leftClick.left, clickTexture.leftClick.right, clickTexture.leftClick.top, clickTexture.leftClick.bottom);
    local rightButtonTextureString = string.format("|T%s:%s:%s:%s:%s:%s:%s:%s:%s:%s:%s|t", clickTexture.texture, clickTexture.height, clickTexture.width, clickTexture.xOffset, clickTexture.yOffset, clickTexture.xDimension, clickTexture.yDimension, clickTexture.rightClick.left, clickTexture.rightClick.right, clickTexture.rightClick.top, clickTexture.rightClick.bottom);

    local function mergeTables(returnValue, mergeTable)
        if mergeTable then
            for key, value in pairs(mergeTable) do
                returnValue[key] = value;
            end
        end
		
        return returnValue;
    end
	
    local function setupTooltip()
        local addonTitle, addonAuthor, addonVersion = LunaEclipse_Scripts:AddonInfo(true);

        local availableBuilds = TalentManager:GetAvailableBuilds();
		local buildInfo = TalentManager:GetCurrentBuildInfo();
		local changesAllowed = TalentManager:TalentChangesAllowed();

        local currentSpecInfo = LunaEclipse_Scripts:GetSpecializationInfo();
		local currentSpec = LunaEclipse_Scripts:GetSpecialization();
		
		local currentScript = LunaEclipse_Scripts:GetCurrentScript();
		local scriptInfo = ScriptInfo:GetScriptInfo(currentScript);
		local scriptExists = ScriptInfo:ScriptExists(currentSpec);

        iconTooltip:Clear();
        iconTooltip:AddHeader(string.format("%s%s:%s %s%s%s", HIGHLIGHT_FONT_COLOR_CODE, addonTitle, addonTable.TEXT_COLOR_TAG_END, addonTable.TEXT_COLOR_TAG_DEFAULT, addonVersion, addonTable.TEXT_COLOR_TAG_END));

		iconTooltip:AddLine(" ");
		iconTooltip:AddHeader(string.format("%s%s%s", HIGHLIGHT_FONT_COLOR_CODE, "Script Information", addonTable.TEXT_COLOR_TAG_END));
			
		if not currentSpec then
			iconTooltip:AddLine(string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_DEFAULT, "No specialization selected so unable to use an Ovale script.", addonTable.TEXT_COLOR_TAG_END));
		elseif LunaEclipse_Scripts:IsPackageScript() then
			if scriptInfo then
				local scriptAuthor = (scriptInfo and scriptInfo.ScriptAuthor) or nil;
				local scriptCredits = (scriptInfo and scriptInfo.ScriptCredits) or nil;
				local guideAuthor = (scriptInfo and scriptInfo.GuideAuthor) or nil;
				local guideLink = (scriptInfo and scriptInfo.GuideLink) or nil;
				local formattedWoWVersion = (scriptInfo and scriptInfo.FormattedWoWVersion) or nil;

				if scriptAuthor then
					iconTooltip:AddLine(string.format("%s%s:%s %s%s%s", addonTable.TEXT_COLOR_TAG_DEFAULT, "Script Author", addonTable.TEXT_COLOR_TAG_END, HIGHLIGHT_FONT_COLOR_CODE, scriptAuthor, addonTable.TEXT_COLOR_TAG_END));		
				end

				if scriptCredits then
					iconTooltip:AddLine(string.format("%s%s:%s %s%s%s", addonTable.TEXT_COLOR_TAG_DEFAULT, "Script Credits", addonTable.TEXT_COLOR_TAG_END, HIGHLIGHT_FONT_COLOR_CODE, scriptCredits, addonTable.TEXT_COLOR_TAG_END));		
				end

				if guideAuthor then
					iconTooltip:AddLine(string.format("%s%s:%s %s%s%s", addonTable.TEXT_COLOR_TAG_DEFAULT, "Guide Author", addonTable.TEXT_COLOR_TAG_END, HIGHLIGHT_FONT_COLOR_CODE, guideAuthor, addonTable.TEXT_COLOR_TAG_END));		
				end

				if guideLink then
					iconTooltip:AddLine(string.format("%s%s:%s %s", addonTable.TEXT_COLOR_TAG_DEFAULT, "Guide Link", addonTable.TEXT_COLOR_TAG_END, guideLink));		
				end

				if formattedWoWVersion then
					iconTooltip:AddLine(string.format("%s%s:%s %s", addonTable.TEXT_COLOR_TAG_DEFAULT, "WoW Version", addonTable.TEXT_COLOR_TAG_END, formattedWoWVersion));		
				end
			else
				iconTooltip:AddLine(string.format("%sThe %q rotation is not currently supported by this addon!%s", addonTable.TEXT_COLOR_TAG_DEFAULT, currentSpecInfo.name, addonTable.TEXT_COLOR_TAG_END));			
				iconTooltip:AddLine(string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_DEFAULT, "Sorry for any inconvience, please use the Default Ovale script package.", addonTable.TEXT_COLOR_TAG_END));			
			end
		elseif scriptExists then
			-- Script is present, but not currently being used.
			iconTooltip:AddLine(string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_DEFAULT, "Not currently using the included LunaEclipse's Custom Ovale Script at present!", addonTable.TEXT_COLOR_TAG_END));			
		elseif not scriptExists then
			-- No script exists.
			iconTooltip:AddLine(string.format("%sThe %q rotation is not currently supported by this addon!%s", addonTable.TEXT_COLOR_TAG_DEFAULT, currentSpecInfo.name, addonTable.TEXT_COLOR_TAG_END));			
			iconTooltip:AddLine(string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_DEFAULT, "Sorry for any inconvience, please use the Default Ovale script package.", addonTable.TEXT_COLOR_TAG_END));			
		end

        iconTooltip:AddLine(" ");
		iconTooltip:AddLine(string.format("%s%s:%s %s%s%s", HIGHLIGHT_FONT_COLOR_CODE, "Talent Changes Allowed", addonTable.TEXT_COLOR_TAG_END, (changesAllowed and addonTable.TEXT_COLOR_TAG_ACTIVE) or addonTable.TEXT_COLOR_TAG_INACTIVE, (changesAllowed and "Yes") or "No", addonTable.TEXT_COLOR_TAG_END));		
		iconTooltip:AddLine(string.format("%s%s:%s %s%s%s", HIGHLIGHT_FONT_COLOR_CODE, "Current Build", addonTable.TEXT_COLOR_TAG_END, addonTable.TEXT_COLOR_TAG_ACTIVE, buildInfo.Name, addonTable.TEXT_COLOR_TAG_END));

        iconTooltip:AddLine(" ");
		iconTooltip:AddHeader(string.format("%s%s%s", HIGHLIGHT_FONT_COLOR_CODE, "Available Talent Builds", addonTable.TEXT_COLOR_TAG_END));

        if not functionsTables:EmptyTable(availableBuilds) then
			for buildName, talentString in pairs(availableBuilds) do
				iconTooltip:AddLine(string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_DEFAULT, buildName, addonTable.TEXT_COLOR_TAG_END));
			end
		else
			iconTooltip:AddLine(string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_DEFAULT, "No preset builds available!", addonTable.TEXT_COLOR_TAG_END));
		end
			
        if changesAllowed then
			iconTooltip:AddLine(" ");
			iconTooltip:AddHeader(string.format("%s%s%s", HIGHLIGHT_FONT_COLOR_CODE, "Mouse Actions", addonTable.TEXT_COLOR_TAG_END));		
            -- Left mouse button functionallity to be added later.
			-- iconTooltip:AddLine(string.format("%s%s:%s %s", addonTable.TEXT_COLOR_TAG_DEFAULT, "Create/Modify Talent Build", addonTable.TEXT_COLOR_TAG_END, leftButtonTextureString));
			iconTooltip:AddLine(string.format("%s%s:%s %s", addonTable.TEXT_COLOR_TAG_DEFAULT, "Change Current Talent Build", addonTable.TEXT_COLOR_TAG_END, rightButtonTextureString));
		end
		
        iconTooltip:AddLine();
        iconTooltip:Show();
    end

    local function onLeftClick()
		-- No action on Left Click at present.
    end
	
    local function onRightClick()
		local availableBuilds = TalentManager:GetAvailableBuilds();

		local currentSpecInfo = LunaEclipse_Scripts:GetSpecializationInfo();
		local buildInfo = TalentManager:GetCurrentBuildInfo();

		local changesAllowed = TalentManager:TalentChangesAllowed();
		local counter = 2;

        if availableBuilds and changesAllowed then
            if iconTooltip then
				iconTooltip:Hide();
			end
            
			for buildName, talentString in pairs(availableBuilds) do
				if not availableBuildsList[counter] then
					availableBuildsList[counter] = {};
				end

				availableBuildsList[counter].text = string.format("%s%s%s%s", (buildInfo.Name == buildName and addonTable.TEXT_COLOR_TAG_ACTIVE) or addonTable.TEXT_COLOR_TAG_INACTIVE, buildName, (buildInfo.Name == buildName and " (Active)") or "", addonTable.TEXT_COLOR_TAG_END);
				availableBuildsList[counter].func = function() TalentManager:ApplyBuild(buildName) end;
				availableBuildsList[counter].notCheckable = true;

				counter = counter + 1;
			end

			for deleteCounter = counter, #availableBuildsList do
				availableBuildsList[deleteCounter] = nil;
			end

            EasyMenu(availableBuildsList, availableBuildsFrame, "cursor", -15, -7, "MENU", 2);
		end
    end

    local function onClick(frame, button)
        if button == "LeftButton" then
            onLeftClick();
        elseif button == "RightButton" then
            onRightClick();
        end
    end

    local function onEnter(self)
        iconTooltip = addonTooltip:Acquire("LECS_ToolTip", 1, "LEFT");
        iconTooltip:SmartAnchorTo(self);
		
        setupTooltip();   
    end

    local function onLeave(self)
        addonTooltip:Release(iconTooltip);
        iconTooltip = nil;
    end

    function LDBManager:UpdateToolTip()
        if iconTooltip then
            setupTooltip();
        end
    end

    function LDBManager:UpdateLDB()
		local accountProfile = addonTable.accountSettings.profile;

        local currentSpecInfo = LunaEclipse_Scripts:GetSpecializationInfo();
        local buildInfo = TalentManager:GetCurrentBuildInfo();
		local talentText = (currentSpecInfo and currentSpecInfo.icon and string.format('|T%s:14:14:0:0:64:64:4:60:4:60|t', currentSpecInfo.icon)) or "";
 
        dataBroker.text = string.format("%s %s: %s", talentText, "Build", buildInfo.Name) or LDBDefaults.text;
        dataBroker.icon = (currentSpecInfo and currentSpecInfo.icon) or LDBDefaults.icon;
		
        for key, value in pairs(accountProfile.LDBIconStorage) do
            dataBroker[key] = value;
        end

        addonIcon:Refresh(dataTextName, accountProfile.LDBIconStorage);

        if iconTooltip then
            setupTooltip();
        end
    end

    function LDBManager:ToggleMinimapIcon()
		local accountProfile = addonTable.accountSettings.profile;

 		if accountProfile.LDBIconStorage.hide then
			addonIcon:Hide(dataTextName);
		else
			addonIcon:Show(dataTextName);
			
			if reloadRequired then
				StaticPopup_Show("LECS_TOGGLE_MINIMAP");
				reloadRequired = false;
			end
		end
   end
	
    function LDBManager:OnInitialize()		
		local accountProfile = addonTable.accountSettings.profile;
        local LDBIconData = {
            type = "data source",
            OnClick = onClick,
            OnLeave = onLeave,
            OnEnter = onEnter,
        };

        LDBIconData = mergeTables(LDBIconData, LDBDefaults);
        LDBIconData = mergeTables(LDBIconData, accountProfile.LDBIconStorage);

        reloadRequired = accountProfile.LDBIconStorage.hide;

        dataBroker = baseDataBroker:NewDataObject(dataTextName, LDBIconData);			
        addonIcon:Register(dataTextName, dataBroker, accountProfile.LDBIconStorage);
    end

    function LDBManager:OnEnable()
        self:RegisterEvent("MODIFIER_STATE_CHANGED", "UpdateToolTip");
        self:RegisterEvent("PLAYER_LOGIN", "UpdateLDB");
        self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "UpdateLDB");
		self:RegisterEvent("PLAYER_TALENT_UPDATE", "UpdateToolTip");

        self:RegisterMessage(addonTable.LECS_MINIMAP_TOGGLE, "ToggleMinimapIcon");
    end

    function LDBManager:OnDisable()
		self:UnregisterMessage(addonTable.LECS_MINIMAP_TOGGLE);

        self:UnregisterEvent("MODIFIER_STATE_CHANGED");
        self:UnregisterEvent("PLAYER_LOGIN");
        self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");		
        self:UnregisterEvent("PLAYER_TALENT_UPDATE");		
    end
end