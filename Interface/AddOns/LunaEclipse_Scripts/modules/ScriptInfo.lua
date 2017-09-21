local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local moduleName = "ScriptInfo";
	local ScriptInfo = LunaEclipse_Scripts:NewModule(moduleName);
	addonTable.ScriptInfo = ScriptInfo;

	local TalentManager = addonTable.TalentManager;

	local function ConvertVersionNumber(versionNumber)
		if versionNumber then
			local majorVersion, minorVersion, revisionNumber;

			majorVersion = tonumber(string.sub(versionNumber, 1, 1));
			minorVersion = tonumber(string.sub(versionNumber, 2, 3));
			revisionNumber = tonumber(string.sub(versionNumber, 4, 5));

			if revisionNumber == 0 then
				return string.format("%s.%s", tostring(majorVersion), tostring(minorVersion));
			else
				return string.format("%s.%s.%s", tostring(majorVersion), tostring(minorVersion), tostring(revisionNumber));
			end
		else
			return nil;
		end
	end

	local function FormatVersion(versionNumber)
		if versionNumber then
			local versionString = ConvertVersionNumber(versionNumber);

			if versionNumber ~= addonTable.CURRENT_WOW_VERSION then
				return string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_INACTIVE, tostring(versionString), addonTable.TEXT_COLOR_TAG_END);
			else
				return string.format("%s%s%s", addonTable.TEXT_COLOR_TAG_ACTIVE, tostring(versionString), addonTable.TEXT_COLOR_TAG_END);
			end
		else
			return nil;
		end
	end

	local function FormatURL(URL)
		local classID = LunaEclipse_Scripts:GetClass();

		return string.format("%s%s%s%s%s%s%s", addonTable.CLASS_COLOUR_CODES[classID], "[|Hurl:", URL, "|h", URL, "|h]", addonTable.TEXT_COLOR_TAG_END);
	end

	local function FormatMessage(messageTitle, messageText)
		return string.format("%s%s:%s %s", addonTable.TEXT_COLOR_TAG_HIGHLIGHT, messageTitle, addonTable.TEXT_COLOR_TAG_END, messageText)
	end

	local function ShowMessage(addonName, ...)
		print(string.format("%s%s%s", "|cff1784d1", tostring(addonName), addonTable.TEXT_COLOR_TAG_END));

		for argumentCounter = 1, select("#", ...) do
			message = select(argumentCounter, ...);
			
			if message then
				print(string.format("%s%s", addonTable.MESSAGE_INDENT, tostring(select(argumentCounter, ...))));
			end
		end
	end

	-- Return nil if there is no script information
	function ScriptInfo:GetScriptInfo(scriptName)
		local returnValue;
		
		if scriptName then
			local scriptInfo = addonTable.scriptInfo[scriptName];
		
			if scriptInfo then
				returnValue = {
					SpecializationID = scriptInfo.SpecializationID;
					ScriptAuthor = scriptInfo.ScriptAuthor,
					ScriptCredits = scriptInfo.ScriptCredits,
					GuideAuthor = scriptInfo.GuideAuthor,
					GuideLink = (scriptInfo.GuideLink and FormatURL(scriptInfo.GuideLink)) or nil,
					WoWVersion = scriptInfo.WoWVersion,
					FormattedWoWVersion = (scriptInfo.WoWVersion and FormatVersion(scriptInfo.WoWVersion)) or nil,
				};
			end
		end

		return returnValue;
	end

	function ScriptInfo:ScriptExists(currentSpec)
		local returnValue = false;

		if currentSpec then
			for scriptName, data in pairs(addonTable.scriptInfo) do
				if not returnValue and currentSpec == data.SpecializationID	then
					returnValue = true;
				end
			end
		end

		return returnValue;
	end


	function ScriptInfo:ShowScriptMessage(currentSpec)
		local accountProfile = addonTable.accountSettings.profile;
		local currentScript = LunaEclipse_Scripts:GetCurrentScript();

		if currentSpec and currentScript and LunaEclipse_Scripts:IsPackageScript() and accountProfile.LDBIconStorage.hide then
			local addonTitle = LunaEclipse_Scripts:AddonInfo();
			local currentSpecName = select(2, GetSpecializationInfoByID(currentSpec));			
			local buildInfo = TalentManager:GetCurrentBuildInfo();
			local scriptInfo = self:GetScriptInfo(currentScript);

			if scriptInfo then
				local scriptAuthor = (scriptInfo and scriptInfo.ScriptAuthor) or nil;
				local scriptCredits = (scriptInfo and scriptInfo.ScriptCredits) or nil;
				local guideAuthor = (scriptInfo and scriptInfo.GuideAuthor) or nil;
				local guideLink = (scriptInfo and scriptInfo.GuideLink) or nil;
				local formattedWoWVersion = (scriptInfo and scriptInfo.FormattedWoWVersion) or nil;

				local textScriptAuthor = (scriptAuthor and FormatMessage("Script Author", scriptAuthor)) or nil;
				local textScriptCredits = (scriptCredits and FormatMessage("Script Credits", scriptCredits)) or nil;
				local textGuideLink = FormatMessage(string.format("%s's guide", tostring(guideAuthor)), tostring(guideLink));				
				local textFormattedWoWVersion = (formattedWoWVersion and FormatMessage("WoW Version", formattedWoWVersion)) or nil;
				local textMessageExtra = (buildInfo and buildInfo.Name == addonTable.CUSTOM_BUILD and "Please check out the guide for information on best talent choices to work with this script!") or nil;
				
				ShowMessage(addonTitle, textScriptAuthor, textScriptCredits, textGuideLink, textFormattedWoWVersion, textMessageExtra);
			else
				local textMessage = string.format("%sThe %q rotation is not currently supported by this addon!|r", addonTable.TEXT_COLOR_TAG_INACTIVE, currentSpecName);
				local textMessageExtra = "Sorry for any inconvience, please use the Default Ovale script package.";

				ShowMessage(addonTitle, textMessage, textMessageExtra);
			end
		end
	end
end