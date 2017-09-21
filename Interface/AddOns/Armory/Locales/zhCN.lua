--[[

    Please do NOT edit this file but go to http://wow.curseforge.com/addons/armory/localization/ instead.

    Original translators: Jokey
    
    The contents of this file will be generated automatically.
    
]]--

local L = LibStub("AceLocale-3.0"):NewLocale("Armory", "zhCN");
if ( not L ) then 
    return;
end

-- Armory
--Translation missing 
L["ARMORY_ALTS"] = "Alts"
--Translation missing 
L["ARMORY_BAGS"] = "Bags"
L["ARMORY_BANK_CONTAINER_NAME"] = "银行"
--Translation missing 
L["ARMORY_BONUS_PATTERN"] = "(.+) Bonus"
--Translation missing 
L["ARMORY_BUZZ_WORDS"] = [=[of
the]=]
--Translation missing 
L["ARMORY_BY_DATE"] = "View by date"
--Translation missing 
L["ARMORY_BY_GROUP"] = "View by group"
--Translation missing 
L["ARMORY_CAN_LEARN"] = "Learnable by"
--Translation missing 
L["ARMORY_CHECK_CD_NONE"] = "No cooldowns found"
L["ARMORY_CHECK_MAIL_DISABLED"] = "邮件过期检查功能被关闭."
L["ARMORY_CHECK_MAIL_MESSAGE"] = "%1$s (%2$s) 的邮箱中 '%3$s' 将在 %4$s 天后过期!"
L["ARMORY_CHECK_MAIL_NONE"] = "无邮件将过期."
L["ARMORY_CHECK_MAIL_POPUP"] = "有邮件将要过期. 使用 '/ar check' 获得更多信息."
--Translation missing 
L["ARMORY_CMD_CHECK"] = "check"
--Translation missing 
L["ARMORY_CMD_CHECK_INVALID"] = "Specify the number of days to check or none for default."
L["ARMORY_CMD_CHECK_MENUTEXT"] = "检查邮件过期"
L["ARMORY_CMD_CHECK_TEXT"] = "检查邮箱邮件是否过期"
--Translation missing 
L["ARMORY_CMD_CHECKCD"] = "cooldown|cd"
--Translation missing 
L["ARMORY_CMD_CHECKCD_TEXT"] = "check tradeskill cooldowns"
--Translation missing 
L["ARMORY_CMD_CONFIG"] = "config"
L["ARMORY_CMD_CONFIG_TEXT"] = "开启设置界面"
--Translation missing 
L["ARMORY_CMD_DELETE"] = "delete"
--Translation missing 
L["ARMORY_CMD_DELETE_ALL"] = "all"
L["ARMORY_CMD_DELETE_ALL_MSG"] = "Armory数据已全部清除."
L["ARMORY_CMD_DELETE_ALL_TEXT"] = "删除所有数据"
--Translation missing 
L["ARMORY_CMD_DELETE_CHAR"] = "char"
L["ARMORY_CMD_DELETE_CHAR_MSG"] = "Armory 已删除 '%1$s' 在服务器 '%2$s'上的数据 ."
L["ARMORY_CMD_DELETE_CHAR_NOT_FOUND"] = "Armory 末找到 '%1$s' 在服务器 '%2$s'上的数据"
--Translation missing 
L["ARMORY_CMD_DELETE_CHAR_PARAMS_TEXT"] = "[name] [realm]"
L["ARMORY_CMD_DELETE_CHAR_TEXT"] = "删除一个角色"
--Translation missing 
L["ARMORY_CMD_DELETE_REALM"] = "realm"
L["ARMORY_CMD_DELETE_REALM_MSG"] = "Armory 服务器 '%s' 已被全部删除."
L["ARMORY_CMD_DELETE_REALM_NOT_FOUND"] = "Armory 服务器 '%s' 未找到!"
--Translation missing 
L["ARMORY_CMD_DELETE_REALM_PARAMS_TEXT"] = "[name]"
L["ARMORY_CMD_DELETE_REALM_TEXT"] = "删除所有服务器角色"
--Translation missing 
L["ARMORY_CMD_DOWNLOAD"] = "download"
L["ARMORY_CMD_DOWNLOAD_TEXT"] = "从公会成员处下载配方"
--Translation missing 
L["ARMORY_CMD_FIND"] = "find"
--Translation missing 
L["ARMORY_CMD_FIND_ALL"] = "all"
L["ARMORY_CMD_FIND_FOUND"] = "共发现: %d"
--Translation missing 
L["ARMORY_CMD_FIND_GLYPH"] = "glyph"
--Translation missing 
L["ARMORY_CMD_FIND_GLYPH_TOOLTIP"] = "Use '?' or '%s' to find glyphs you haven't learned yet."
--Translation missing 
L["ARMORY_CMD_FIND_INVENTORY"] = "inventory"
--Translation missing 
L["ARMORY_CMD_FIND_ITEM"] = "item"
--Translation missing 
L["ARMORY_CMD_FIND_MENUTEXT"] = "Search database"
L["ARMORY_CMD_FIND_NOT_FOUND"] = "未发现"
--Translation missing 
L["ARMORY_CMD_FIND_PARAMS_TEXT"] = "[namepart]"
--Translation missing 
L["ARMORY_CMD_FIND_QUEST"] = "quest"
L["ARMORY_CMD_FIND_QUEST_REWARD"] = "任务奖励"
--Translation missing 
L["ARMORY_CMD_FIND_SKILL"] = "skill"
--Translation missing 
L["ARMORY_CMD_FIND_SPELL"] = "spell"
L["ARMORY_CMD_FIND_TEXT"] = "查找 %s"
--Translation missing 
L["ARMORY_CMD_HELP"] = "help"
L["ARMORY_CMD_HELP_TEXT"] = "显示这个使用方法"
--Translation missing 
L["ARMORY_CMD_LOOKUP"] = "lookup"
L["ARMORY_CMD_LOOKUP_MENUTEXT"] = "查找信息"
L["ARMORY_CMD_LOOKUP_TEXT"] = "从其它玩家处查找信息"
--Translation missing 
L["ARMORY_CMD_RESET"] = "reset"
--Translation missing 
L["ARMORY_CMD_RESET_FRAME"] = "frames"
L["ARMORY_CMD_RESET_FRAME_MENUTEXT"] = "重置窗口位置"
--Translation missing 
L["ARMORY_CMD_RESET_FRAME_SUCCESS"] = "frames reset"
L["ARMORY_CMD_RESET_FRAME_TEXT"] = "重置窗口位置"
--Translation missing 
L["ARMORY_CMD_RESET_SETTINGS"] = "settings"
--Translation missing 
L["ARMORY_CMD_RESET_SETTINGS_SUCCESS"] = "settings reset"
L["ARMORY_CMD_RESET_SETTINGS_TEXT"] = "重置所有设置到默认状态"
--Translation missing 
L["ARMORY_CMD_SET_ALTCLICKSEARCH_MENUTEXT"] = "Search Alt-clicked link"
--Translation missing 
L["ARMORY_CMD_SET_ALTCLICKSEARCH_TEXT"] = "start a search when Alt-clicking a chat link"
--Translation missing 
L["ARMORY_CMD_SET_ALTCLICKSEARCH_TOOLTIP"] = "If enabled, the find command will be invoked while holding down the Alt key and clicking a searchable link in the chat frame."
--Translation missing 
L["ARMORY_CMD_SET_CHECKBUTTON_MENUTEXT"] = "Hide Armory button"
--Translation missing 
L["ARMORY_CMD_SET_CHECKBUTTON_TEXT"] = "hide the Armory check button on the character frame"
--Translation missing 
L["ARMORY_CMD_SET_CHECKBUTTON_TOOLTIP"] = "If enabled, the Armory check button in the lower left corner of the character frame will not be shown."
--Translation missing 
L["ARMORY_CMD_SET_CHECKCOOLDOWNS_MENUTEXT"] = "Check available cooldowns"
--Translation missing 
L["ARMORY_CMD_SET_CHECKCOOLDOWNS_TEXT"] = "check available cooldowns on startup"
--Translation missing 
L["ARMORY_CMD_SET_CHECKCOOLDOWNS_TOOLTIP"] = "If enabled, tradeskill cooldowns that became available while you were offline will be displayed when you log in."
--Translation missing 
L["ARMORY_CMD_SET_COLLAPSE_MENUTEXT"] = "Collapse character frame"
--Translation missing 
L["ARMORY_CMD_SET_COLLAPSE_TEXT"] = "collapse the character frame"
--Translation missing 
L["ARMORY_CMD_SET_COLLAPSE_TOOLTIP"] = "If enabled, the character frame will be collapsed when Armory's layout is active."
--Translation missing 
L["ARMORY_CMD_SET_COOLDOWNEVENTS_MENUTEXT"] = "Include tradeskill cooldowns"
--Translation missing 
L["ARMORY_CMD_SET_COOLDOWNEVENTS_TEXT"] = "include tradeskill cooldowns in event list"
--Translation missing 
L["ARMORY_CMD_SET_COOLDOWNEVENTS_TOOLTIP"] = "If enabled, tradeskill cooldowns will be included in Armory's event list."
--Translation missing 
L["ARMORY_CMD_SET_COUNTALL_MENUTEXT"] = "Include all realms in counts"
--Translation missing 
L["ARMORY_CMD_SET_COUNTALL_TEXT"] = "include item counts for all realms"
--Translation missing 
L["ARMORY_CMD_SET_COUNTALL_TOOLTIP"] = "If enabled, totals are shown for all realms; otherwise only for the current and connected realms."
--Translation missing 
L["ARMORY_CMD_SET_COUNTPERSLOT_MENUTEXT"] = "Totals per bag/bank slot"
--Translation missing 
L["ARMORY_CMD_SET_COUNTPERSLOT_TEXT"] = "show item counts per bag/bank slot"
--Translation missing 
L["ARMORY_CMD_SET_COUNTPERSLOT_TOOLTIP"] = "If enabled, items counts are shown per bag or bank slot, where slot '0' represents the backpack or bank itself."
--Translation missing 
L["ARMORY_CMD_SET_COUNTXFACTION_MENUTEXT"] = "Include all factions in counts"
--Translation missing 
L["ARMORY_CMD_SET_COUNTXFACTION_TEXT"] = "include item counts for all factions"
--Translation missing 
L["ARMORY_CMD_SET_COUNTXFACTION_TOOLTIP"] = "If enabled, totals are shown for all factions; otherwise only for the current faction."
--Translation missing 
L["ARMORY_CMD_SET_DEFAULTSEARCH_MENUTEXT"] = "Default search domain"
--Translation missing 
L["ARMORY_CMD_SET_DEFAULTSEARCH_TEXT"] = "default domain"
--Translation missing 
L["ARMORY_CMD_SET_DEFAULTSEARCH_TOOLTIP"] = "The search domain to use when none is specified."
--Translation missing 
L["ARMORY_CMD_SET_ENABLED_MENUTEXT"] = "Enable character"
--Translation missing 
L["ARMORY_CMD_SET_ENABLED_TEXT"] = "include this character in Armory"
--Translation missing 
L["ARMORY_CMD_SET_ENABLED_TOOLTIP"] = [=[If enabled, Armory will perform data collection for the current character.
Note that changing this option will result in a UI reload.]=]
--Translation missing 
L["ARMORY_CMD_SET_EVENTLOCALTIME_MENUTEXT"] = "Use local time for events"
--Translation missing 
L["ARMORY_CMD_SET_EVENTLOCALTIME_TEXT"] = "use local time in event list"
--Translation missing 
L["ARMORY_CMD_SET_EVENTLOCALTIME_TOOLTIP"] = "If enabled, local time is used in the event list; otherwise the realm time."
--Translation missing 
L["ARMORY_CMD_SET_EVENTWARNINGS_MENUTEXT"] = "Event notifications"
--Translation missing 
L["ARMORY_CMD_SET_EVENTWARNINGS_TEXT"] = "enable event notifications"
--Translation missing 
L["ARMORY_CMD_SET_EVENTWARNINGS_TOOLTIP"] = "If enabled, you will be warned about confirmed events of your characters that are about to become due."
L["ARMORY_CMD_SET_EXPDAYS_INVALID"] = "%1$s 必须在 0 (不警告) 和 %2$d 之间!"
--Translation missing 
L["ARMORY_CMD_SET_EXPDAYS_PARAMS_TEXT"] = "numdays"
L["ARMORY_CMD_SET_EXPDAYS_TEXT"] = "邮箱中邮件到期警告等级"
L["ARMORY_CMD_SET_EXPDAYS_TOOLTIP"] = "将按照所指定的天数检查邮箱中的物品是否将过期 (0 为关闭警告)."
--Translation missing 
L["ARMORY_CMD_SET_EXTENDEDSEARCH_MENUTEXT"] = "Extended find"
--Translation missing 
L["ARMORY_CMD_SET_EXTENDEDSEARCH_TEXT"] = "look in tooltip text for matches when using find"
--Translation missing 
L["ARMORY_CMD_SET_EXTENDEDSEARCH_TOOLTIP"] = "If enabled, the find command will look in the tooltip text for matches; otherwise only the name is checked."
--Translation missing 
L["ARMORY_CMD_SET_EXTENDEDTRADE_MENUTEXT"] = "Enable profession filters"
--Translation missing 
L["ARMORY_CMD_SET_EXTENDEDTRADE_TEXT"] = "Enable subclass and slot filters"
--Translation missing 
L["ARMORY_CMD_SET_EXTENDEDTRADE_TOOLTIP"] = [=[If enabled, the professions can be filtered on subclass and/or item slots.
If you experience problems with other add-ons you can disable this feature to get a simple list that doesn't trigger any events (a categorized list will be available by shift-clicking the link button).]=]
L["ARMORY_CMD_SET_GLOBALSEARCH_MENUTEXT"] = "全局搜索"
L["ARMORY_CMD_SET_GLOBALSEARCH_TEXT"] = "搜索所有服务器"
L["ARMORY_CMD_SET_GLOBALSEARCH_TOOLTIP"] = "如果打开此功能, 搜索命令将搜索整个数据库; 否则只搜索当前服务器数据库."
--Translation missing 
L["ARMORY_CMD_SET_HIDELOGON_MENUTEXT"] = "Hide warning when logging in"
--Translation missing 
L["ARMORY_CMD_SET_HIDELOGON_TEXT"] = "don't show a warning when logging in"
--Translation missing 
L["ARMORY_CMD_SET_HIDELOGON_TOOLTIP"] = "If enabled, the warning will not be displayed when you log in."
L["ARMORY_CMD_SET_HIDEMMTOOLBAR_MENUTEXT"] = "隐藏迷你地图小按钮和工具条"
L["ARMORY_CMD_SET_HIDEMMTOOLBAR_TEXT"] = "当 ArmoryTitan/Fu 被读取时隐藏迷你地图小按钮"
L["ARMORY_CMD_SET_HIDEMMTOOLBAR_TOOLTIP"] = "如果开启, 当 ArmoryTitan/Fu 被读取时将隐藏迷你地图小按钮."
--Translation missing 
L["ARMORY_CMD_SET_IGNOREALTS_MENUTEXT"] = "Ignore mail from alts"
--Translation missing 
L["ARMORY_CMD_SET_IGNOREALTS_TEXT"] = "ignore warnings for mails from alts"
--Translation missing 
L["ARMORY_CMD_SET_IGNOREALTS_TOOLTIP"] = "If enabled, the popup warning will not be shown for expired mails that were sent (not returned) by one of your other characters. Note that characters must be known to Armory for this to work."
L["ARMORY_CMD_SET_LASTVIEWED_MENUTEXT"] = "按选择保存"
L["ARMORY_CMD_SET_LASTVIEWED_TEXT"] = "记忆最后一个角色的物品"
L["ARMORY_CMD_SET_LASTVIEWED_TOOLTIP"] = "如果打开此功能, 将只保存最后一个角色的设置."
--Translation missing 
L["ARMORY_CMD_SET_LDBLABEL_MENUTEXT"] = "Enable LDB label"
--Translation missing 
L["ARMORY_CMD_SET_LDBLABEL_TEXT"] = "enable LibDataBroker label display"
--Translation missing 
L["ARMORY_CMD_SET_LDBLABEL_TOOLTIP"] = "If enabled, a text label is shown in LibDataBroker display add-ons."
--Translation missing 
L["ARMORY_CMD_SET_MAILCHECKCOUNT_MENUTEXT"] = "Check for remaining mail"
--Translation missing 
L["ARMORY_CMD_SET_MAILCHECKCOUNT_TEXT"] = "check for remaining mail in the inbox"
--Translation missing 
L["ARMORY_CMD_SET_MAILCHECKCOUNT_TOOLTIP"] = "If enabled, a warning will be shown when not all mails were scanned because the inbox display limit has been exceeded."
--Translation missing 
L["ARMORY_CMD_SET_MAILCHECKVISIT_MENUTEXT"] = "Warn for unnoticed mail"
--Translation missing 
L["ARMORY_CMD_SET_MAILCHECKVISIT_TEXT"] = "include the last mailbox visit when checking for mail"
--Translation missing 
L["ARMORY_CMD_SET_MAILCHECKVISIT_TOOLTIP"] = "If enabled, a warning will be shown when a character's mailbox hasn't been opened for at least 30 minus expiration threshold number of days and therefore may contain mail without being noticed."
--Translation missing 
L["ARMORY_CMD_SET_MAILEXCLUDEVISIT_MENUTEXT"] = "Exclude this character's mailbox visit"
--Translation missing 
L["ARMORY_CMD_SET_MAILEXCLUDEVISIT_TEXT"] = "don't check this character's mailbox visit"
--Translation missing 
L["ARMORY_CMD_SET_MAILEXCLUDEVISIT_TOOLTIP"] = "If enabled, the current character's mailbox visit will be excluded from the check."
--Translation missing 
L["ARMORY_CMD_SET_MAILHIDECOUNT_MENUTEXT"] = "Hide remaining mail scan warning"
--Translation missing 
L["ARMORY_CMD_SET_MAILHIDECOUNT_TEXT"] = "don't show a warning when the mailbox is closed"
--Translation missing 
L["ARMORY_CMD_SET_MAILHIDECOUNT_TOOLTIP"] = "If enabled, the warning for remaining mail will not be shown when you close the mailbox."
L["ARMORY_CMD_SET_MMB_ANGLE_TEXT"] = "迷你地图按钮角度"
--Translation missing 
L["ARMORY_CMD_SET_MMB_GLOBAL_MENUTEXT"] = "position the button the same for all characters"
--Translation missing 
L["ARMORY_CMD_SET_MMB_GLOBAL_TEXT"] = "Use same position for all"
--Translation missing 
L["ARMORY_CMD_SET_MMB_GLOBAL_TOOLTIP"] = "If enabled, the angle and radius will be the same for all characters."
L["ARMORY_CMD_SET_MMB_RADIUS_TEXT"] = "迷你地图按钮位置"
L["ARMORY_CMD_SET_NOVALUE"] = "当前设置: %s"
L["ARMORY_CMD_SET_NOVALUE_TEXT"] = "显示当前设置"
--Translation missing 
L["ARMORY_CMD_SET_OFF"] = "off"
--Translation missing 
L["ARMORY_CMD_SET_ON"] = "on"
--Translation missing 
L["ARMORY_CMD_SET_PAUSEINCOMBAT_MENUTEXT"] = "Pause in combat"
--Translation missing 
L["ARMORY_CMD_SET_PAUSEINCOMBAT_TEXT"] = "do not scan when in combat"
--Translation missing 
L["ARMORY_CMD_SET_PAUSEINCOMBAT_TOOLTIP"] = "If enabled Armory pauses scanning when you get into combat and resumes afterwards."
--Translation missing 
L["ARMORY_CMD_SET_PAUSEININSTANCE_MENUTEXT"] = "Remain paused in instance"
--Translation missing 
L["ARMORY_CMD_SET_PAUSEININSTANCE_TEXT"] = "do not resume when in an instance"
--Translation missing 
L["ARMORY_CMD_SET_PAUSEININSTANCE_TOOLTIP"] = "If enabled, getting out of combat in an instance will not process any postponed updates. Be aware that in this case item counts in tooltips will not be updated either."
L["ARMORY_CMD_SET_PERCHARACTER_MENUTEXT"] = "每一个角色单独记忆配置文件"
L["ARMORY_CMD_SET_PERCHARACTER_TEXT"] = "使用单独设置文件"
L["ARMORY_CMD_SET_PERCHARACTER_TOOLTIP"] = "如果打开此功能,  'search all' 和 'last character' 设置将只基于每个角色."
--Translation missing 
L["ARMORY_CMD_SET_RESTRICTIVESEARCH_MENUTEXT"] = "Restrictive find"
--Translation missing 
L["ARMORY_CMD_SET_RESTRICTIVESEARCH_TEXT"] = "don't include obtainable objects when using find"
--Translation missing 
L["ARMORY_CMD_SET_RESTRICTIVESEARCH_TOOLTIP"] = "If enabled, the find command will not consider obtainable objects, like rewards or craftables, as possible matches."
--Translation missing 
L["ARMORY_CMD_SET_SCALEONMOUSEWHEEL_MENUTEXT"] = "enable mouse wheel"
--Translation missing 
L["ARMORY_CMD_SET_SCALEONMOUSEWHEEL_TEXT"] = "Enable mouse wheel"
--Translation missing 
L["ARMORY_CMD_SET_SCALEONMOUSEWHEEL_TOOLTIP"] = "If enabled, scrolling the mouse wheel while hovering over the background of Armory's main frame will change the UI scale."
--Translation missing 
L["ARMORY_CMD_SET_SCANONENTER_MENUTEXT"] = "Force scan on login"
--Translation missing 
L["ARMORY_CMD_SET_SCANONENTER_TEXT"] = "force a scan on the next login"
--Translation missing 
L["ARMORY_CMD_SET_SCANONENTER_TOOLTIP"] = [=[If enabled Armory will forcibly update all accessible character data on the next login.
This setting will reset itself automatically.]=]
L["ARMORY_CMD_SET_SEARCHALL_MENUTEXT"] = "按 'search all' 保存"
L["ARMORY_CMD_SET_SEARCHALL_TEXT"] = "记忆所有角色的'search all'设置"
L["ARMORY_CMD_SET_SEARCHALL_TOOLTIP"] = "如果打开此功能, 物品清单中的 'search all' 设置将保存为所有角色共用."
L["ARMORY_CMD_SET_SHAREALL_MENUTEXT"] = "共享所有角色"
L["ARMORY_CMD_SET_SHAREALL_TEXT"] = "共享你所有角色的信息"
L["ARMORY_CMD_SET_SHAREALL_TOOLTIP"] = "如果打开此功能, 你所有角色的信息都将被共享; 反之则只共享你当前角色的信息."
L["ARMORY_CMD_SET_SHAREALT_MENUTEXT"] = "显示和其它角色的关联"
L["ARMORY_CMD_SET_SHAREALT_TEXT"] = "显示和其它角色的关联"
L["ARMORY_CMD_SET_SHAREALT_TOOLTIP"] = "如果打开此功能, 当前角色与你其它角色的关系将被显示(例 显示为小号). 关闭此功能则为单独的角色."
--Translation missing 
L["ARMORY_CMD_SET_SHARECHANNEL_MENUTEXT"] = "enable lookup channel"
--Translation missing 
L["ARMORY_CMD_SET_SHARECHANNEL_TEXT"] = "Enable custom channel"
--Translation missing 
L["ARMORY_CMD_SET_SHARECHANNEL_TOOLTIP"] = "If enabled, lookup requests can be sent through the provided channel which you can share with a specific group of players."
L["ARMORY_CMD_SET_SHARECHARACTER_MENUTEXT"] = "共享角色信息"
L["ARMORY_CMD_SET_SHARECHARACTER_TEXT"] = "共享你的角色信息"
L["ARMORY_CMD_SET_SHARECHARACTER_TOOLTIP"] = "如果打开此功能, 其它 Armory 用户能够查看你的装备及天赋."
L["ARMORY_CMD_SET_SHAREGUILD_MENUTEXT"] = "共享公会角色"
L["ARMORY_CMD_SET_SHAREGUILD_TEXT"] = "共享公会角色信息"
L["ARMORY_CMD_SET_SHAREGUILD_TOOLTIP"] = "如果打开此功能, 当角色为同一公会时将共享所有信息."
L["ARMORY_CMD_SET_SHAREINCOMBAT_MENUTEXT"] = "战斗中共享"
L["ARMORY_CMD_SET_SHAREINCOMBAT_TEXT"] = "战斗中共享"
L["ARMORY_CMD_SET_SHAREINCOMBAT_TOOLTIP"] = "如果打开此功能, 当你在战斗中也会接受共享请求. 关闭此功能也许会提高效率"
L["ARMORY_CMD_SET_SHAREININSTANCE_MENUTEXT"] = "副本时共享"
L["ARMORY_CMD_SET_SHAREININSTANCE_TEXT"] = "副本时共享"
L["ARMORY_CMD_SET_SHAREININSTANCE_TOOLTIP"] = "如果打开此功能, 当你在一个副本中时也会接受共享请求. 关闭此功能也许会提高效率."
--Translation missing 
L["ARMORY_CMD_SET_SHAREITEMS_MENUTEXT"] = "Share items"
--Translation missing 
L["ARMORY_CMD_SET_SHAREITEMS_TEXT"] = "share your inventory items"
--Translation missing 
L["ARMORY_CMD_SET_SHAREITEMS_TOOLTIP"] = "If enabled, other Armory users who are using the same custom channel can search for items in your inventory."
L["ARMORY_CMD_SET_SHAREQUESTS_MENUTEXT"] = "共享任务"
L["ARMORY_CMD_SET_SHAREQUESTS_TEXT"] = "共享你的任务"
L["ARMORY_CMD_SET_SHAREQUESTS_TOOLTIP"] = "如果打开此功能, 其它 Armory 用户能够搜索你的任务数据."
L["ARMORY_CMD_SET_SHARESKILLS_MENUTEXT"] = "专业共享"
L["ARMORY_CMD_SET_SHARESKILLS_TEXT"] = "共享你的专业配方"
L["ARMORY_CMD_SET_SHARESKILLS_TOOLTIP"] = "如果打开此功能, 其它 Armory 用户可以搜索你的配方数据."
--Translation missing 
L["ARMORY_CMD_SET_SHOW2NDSKILLRANK_MENUTEXT"] = "Include secondary skills"
--Translation missing 
L["ARMORY_CMD_SET_SHOW2NDSKILLRANK_TEXT"] = "include secondary skill ranks"
--Translation missing 
L["ARMORY_CMD_SET_SHOW2NDSKILLRANK_TOOLTIP"] = "If enabled, skill ranks are added for secondary skills; otherwise only for primary skills."
--Translation missing 
L["ARMORY_CMD_SET_SHOWACHIEVEMENTS_MENUTEXT"] = "Show achievements in links"
--Translation missing 
L["ARMORY_CMD_SET_SHOWACHIEVEMENTS_TEXT"] = "show characters in linked achievements"
--Translation missing 
L["ARMORY_CMD_SET_SHOWACHIEVEMENTS_TOOLTIP"] = "If enabled, characters that earned or are in progress with the achievement linked in the chat frame are added to its tooltip."
L["ARMORY_CMD_SET_SHOWALTEQUIP_MENUTEXT"] = "显示可选装备"
L["ARMORY_CMD_SET_SHOWALTEQUIP_TEXT"] = "显示可选装备槽"
L["ARMORY_CMD_SET_SHOWALTEQUIP_TOOLTIP"] = "如果打开此功能, 试衣间将显示包裹中其它可装备于此槽的装备."
--Translation missing 
L["ARMORY_CMD_SET_SHOWCANLEARN_MENUTEXT"] = "Show 'learnable by' in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWCANLEARN_TEXT"] = "show 'learnable by' in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWCANLEARN_TOOLTIP"] = "If enabled, tooltips will show which character can learn the recipe or glyph."
--Translation missing 
L["ARMORY_CMD_SET_SHOWCOUNTTOTAL_MENUTEXT"] = "Show item count totals"
--Translation missing 
L["ARMORY_CMD_SET_SHOWCOUNTTOTAL_TEXT"] = "include item count totals"
--Translation missing 
L["ARMORY_CMD_SET_SHOWCOUNTTOTAL_TOOLTIP"] = "If enabled a grand total will be added to the item counts."
--Translation missing 
L["ARMORY_CMD_SET_SHOWCRAFTERS_MENUTEXT"] = "Show crafters in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWCRAFTERS_TEXT"] = "show crafters in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWCRAFTERS_TOOLTIP"] = "If enabled, item tooltips will show which character can craft that item."
L["ARMORY_CMD_SET_SHOWEQCTOOLTIPS_MENUTEXT"] = "显示装备比较信息"
L["ARMORY_CMD_SET_SHOWEQCTOOLTIPS_TEXT"] = "显示装备比较信息"
L["ARMORY_CMD_SET_SHOWEQCTOOLTIPS_TOOLTIP"] = "如果打开此功能, 按住Alt键可显示装备比较信息."
--Translation missing 
L["ARMORY_CMD_SET_SHOWGEARSETS_MENUTEXT"] = "Show gear sets in tooltip"
--Translation missing 
L["ARMORY_CMD_SET_SHOWGEARSETS_TEXT"] = "show equipment set names in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWGEARSETS_TOOLTIP"] = "If enabled and equipment belongs to a gear set, the name of the set will be shown in its tooltip."
--Translation missing 
L["ARMORY_CMD_SET_SHOWGEMS_MENUTEXT"] = "Show gemming details"
--Translation missing 
L["ARMORY_CMD_SET_SHOWGEMS_TEXT"] = "show socket gemming details in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWGEMS_TOOLTIP"] = "If enabled, the color of the socket and the name of the gem will be added to the item tooltip."
--Translation missing 
L["ARMORY_CMD_SET_SHOWHASSKILL_MENUTEXT"] = "Show 'attainable by' in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWHASSKILL_TEXT"] = "show 'attainable by' in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWHASSKILL_TOOLTIP"] = "If enabled, tooltips will show which character will eventually be able to learn the recipe or glyph."
L["ARMORY_CMD_SET_SHOWITEMCOUNT_MENUTEXT"] = "显示物品堆叠数据"
L["ARMORY_CMD_SET_SHOWITEMCOUNT_TEXT"] = "显示物品堆叠数据"
L["ARMORY_CMD_SET_SHOWITEMCOUNT_TOOLTIP"] = "如果打开此功能, 信息提示栏将显示每个角色包裹中的物品堆叠数据."
--Translation missing 
L["ARMORY_CMD_SET_SHOWKNOWNBY_MENUTEXT"] = "Show 'known by' in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWKNOWNBY_TEXT"] = "show 'known by' in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWKNOWNBY_TOOLTIP"] = "If enabled, tooltips will show which character already knows the recipe or glyph."
L["ARMORY_CMD_SET_SHOWMINIMAP_MENUTEXT"] = "显示迷你地图按钮"
L["ARMORY_CMD_SET_SHOWMINIMAP_TEXT"] = "显示迷你地图按钮"
L["ARMORY_CMD_SET_SHOWMINIMAP_TOOLTIP"] = "如果打开此功能, 将在迷你地图上显示一个方便开启Armory的小按钮."
--Translation missing 
L["ARMORY_CMD_SET_SHOWMMGLOBAL_MENUTEXT"] = "minimap button for all"
--Translation missing 
L["ARMORY_CMD_SET_SHOWMMGLOBAL_TEXT"] = "Use one minimap button for all characters"
--Translation missing 
L["ARMORY_CMD_SET_SHOWMMGLOBAL_TOOLTIP"] = "If enabled, one minimap button will be shown for all characters. If not, you'll have to enable or disable the minimap button for each character individually."
L["ARMORY_CMD_SET_SHOWQUESTALTS_MENUTEXT"] = "显示小号的任务链接"
L["ARMORY_CMD_SET_SHOWQUESTALTS_TEXT"] = "在任务链接中显示是哪一个角色的任务"
L["ARMORY_CMD_SET_SHOWQUESTALTS_TOOLTIP"] = "如果打开此功能, 在聊天窗口显示的任务链接提示中将显示归属于哪个角色所有."
L["ARMORY_CMD_SET_SHOWSHAREMSG_MENUTEXT"] = "显示数据共享信息"
L["ARMORY_CMD_SET_SHOWSHAREMSG_TEXT"] = "显示数据共享信息"
L["ARMORY_CMD_SET_SHOWSHAREMSG_TOOLTIP"] = "如果打开此功能, 当数据共享时信息将显示在聊天窗口."
--Translation missing 
L["ARMORY_CMD_SET_SHOWSKILLRANK_MENUTEXT"] = "Show skill ranks in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWSKILLRANK_TEXT"] = "show skill ranks in tooltips"
--Translation missing 
L["ARMORY_CMD_SET_SHOWSKILLRANK_TOOLTIP"] = "If enabled, skill ranks are added to skill button tooltips."
--Translation missing 
L["ARMORY_CMD_SET_SHOWSUMMARY_MENUTEXT"] = "Summary sheet"
--Translation missing 
L["ARMORY_CMD_SET_SHOWSUMMARY_TEXT"] = "show summary sheet"
--Translation missing 
L["ARMORY_CMD_SET_SHOWSUMMARY_TOOLTIP"] = "If enabled a character summary sheet will be show when hovering over the minimap or LDB button."
L["ARMORY_CMD_SET_SHOWUNEQUIP_MENUTEXT"] = "显示不可装备的物品"
L["ARMORY_CMD_SET_SHOWUNEQUIP_TEXT"] = "显示不可装备的物品"
L["ARMORY_CMD_SET_SHOWUNEQUIP_TOOLTIP"] = "如果打开此功能, 包裹中所有物品都将无条件可装备到槽中."
L["ARMORY_CMD_SET_SUCCESS"] = "%1$s 设置到 %2$s"
--Translation missing 
L["ARMORY_CMD_SET_SUMMARYDELAY_TEXT"] = "Popup Delay"
--Translation missing 
L["ARMORY_CMD_SET_SUMMARYDELAY_TOOLTIP"] = "Adjust the delay at which the summary will be shown."
--Translation missing 
L["ARMORY_CMD_SET_SYSTEMWARNINGS_MENUTEXT"] = "Enable system warnings"
--Translation missing 
L["ARMORY_CMD_SET_SYSTEMWARNINGS_TEXT"] = "enable system warning messages"
--Translation missing 
L["ARMORY_CMD_SET_SYSTEMWARNINGS_TOOLTIP"] = [=[If enabled, warning messages are displayed when something is wrong (e.g. the server is not returning any data).
 
You are strongly advised to keep this setting enabled. It is generally better to find the cause of the message and solve the issue. For example disabling the subclass and slot filters can be used as a workaround to prevent most trade skill update warnings. As a trade-off you'll lose some functionality though.]=]
--Translation missing 
L["ARMORY_CMD_SET_USECLASSCOLORS_MENUTEXT"] = "Use class colors"
--Translation missing 
L["ARMORY_CMD_SET_USECLASSCOLORS_TEXT"] = "use class colors for character names"
--Translation missing 
L["ARMORY_CMD_SET_USECLASSCOLORS_TOOLTIP"] = "If enabled, class colors are used when displaying character names."
--Translation missing 
L["ARMORY_CMD_SET_USEENCODING_MENUTEXT"] = "Prefer memory over CPU"
--Translation missing 
L["ARMORY_CMD_SET_USEENCODING_TEXT"] = "prefer memory usage over processing speed"
--Translation missing 
L["ARMORY_CMD_SET_USEENCODING_TOOLTIP"] = "If enabled, data will will stored in a binary encoded format taking up less memory but using more CPU for storage and retrieval. Enabling this option will decrease performance,"
--Translation missing 
L["ARMORY_CMD_SET_USEFACTIONFILTER_MENUTEXT"] = "Realm & faction filter"
--Translation missing 
L["ARMORY_CMD_SET_USEFACTIONFILTER_TEXT"] = "enable realm and faction filter"
--Translation missing 
L["ARMORY_CMD_SET_USEFACTIONFILTER_TOOLTIP"] = [=[If enabled, only characters on the current and connected realms and belonging to the current faction will be shown. This will also affect tooltip information.
Note that for item counts there is a separate realm and faction setting.]=]
--Translation missing 
L["ARMORY_CMD_SET_USEINPROGRESSCOLOR_MENUTEXT"] = "Use different color for 'in progress'"
--Translation missing 
L["ARMORY_CMD_SET_USEINPROGRESSCOLOR_TEXT"] = "colorize 'in progress' differently"
--Translation missing 
L["ARMORY_CMD_SET_USEINPROGRESSCOLOR_TOOLTIP"] = "If enabled, a different color will be used for achievements still in progress by a character."
--Translation missing 
L["ARMORY_CMD_SET_USEMAZIEL_MENUTEXT"] = "Use two stat panels"
--Translation missing 
L["ARMORY_CMD_SET_USEMAZIEL_TEXT"] = "hide talent build and professions"
--Translation missing 
L["ARMORY_CMD_SET_USEMAZIEL_TOOLTIP"] = "If enabled, the talent and profession frames will be replaced by a second stat panel."
--Translation missing 
L["ARMORY_CMD_SET_USEOVERLAY_MENUTEXT"] = "Enable character model overlay"
--Translation missing 
L["ARMORY_CMD_SET_USEOVERLAY_TEXT"] = "replace character model with Armory layout"
--Translation missing 
L["ARMORY_CMD_SET_USEOVERLAY_TOOLTIP"] = "If enabled, Armory's layout will replace the character model when the character frame is collapsed."
--Translation missing 
L["ARMORY_CMD_SET_WARNINGSOUND_MENUTEXT"] = "Warning sound"
--Translation missing 
L["ARMORY_CMD_SET_WARNINGSOUND_TEXT"] = "warning message sound"
--Translation missing 
L["ARMORY_CMD_SET_WARNINGSOUND_TOOLTIP"] = "Select a sound to play when an automated warning or error message is displayed in the chat frame."
--Translation missing 
L["ARMORY_CMD_SET_WEEKLYRESET_MENUTEXT"] = "Weekly reset"
--Translation missing 
L["ARMORY_CMD_SET_WEEKLYRESET_TEXT"] = "weekly server reset"
--Translation missing 
L["ARMORY_CMD_SET_WEEKLYRESET_TOOLTIP"] = "Select the day on which the server resets weekly (Tuesday for US servers and Wednesday for EU servers)."
--Translation missing 
L["ARMORY_CMD_SET_WINDOWSEARCH_MENUTEXT"] = "Show find results in window"
--Translation missing 
L["ARMORY_CMD_SET_WINDOWSEARCH_TEXT"] = "show find command results in a dedicated window"
--Translation missing 
L["ARMORY_CMD_SET_WINDOWSEARCH_TOOLTIP"] = "If enabled, the results of the find command will be presented in a separate window; otherwise the results are shown in the chat window."
L["ARMORY_CMD_TOGGLE"] = "开启或关闭 Armory"
L["ARMORY_CMD_USAGE"] = "使用方法:"
--Translation missing 
L["ARMORY_COOLDOWN_AVAILABLE"] = "Cooldown of '%1$s' is available again for %2$s (%3$s)."
--Translation missing 
L["ARMORY_COOLDOWN_WARNING"] = "%s in %d |4minute:minutes;"
--Translation missing 
L["ARMORY_CRAFTABLE_BY"] = "Craftable by"
L["ARMORY_DB_INCOMPATIBLE"] = [=[数据库与当前版本 Armory 不一致, 将被删除.
你需要将每一个角色重新登录以重建数据库. 注意所有的角色数据共享设置也将被重置为默认状态.]=]
L["ARMORY_DELETE_UNIT"] = "你真的想从数据库中删除 %s ?"
L["ARMORY_DELETE_UNIT_HINT"] = "右键点击删除"
L["ARMORY_EQUIPMENT"] = "装备"
--Translation missing 
L["ARMORY_EQUIPPED"] = "Equipped"
L["ARMORY_ERROR"] = "错误"
--Translation missing 
L["ARMORY_EVENT_WARNING"] = "%s starts in %d |4minute:minutes;"
--Translation missing 
L["ARMORY_EXPIRATION_LABEL"] = "Expiration"
--Translation missing 
L["ARMORY_EXPIRATION_SUBTEXT"] = "These options allow you to change the behavior of the mail expiration check."
--Translation missing 
L["ARMORY_EXPIRATION_TITLE"] = "Mail Expiration"
--Translation missing 
L["ARMORY_EXTENDED"] = "Extended"
L["ARMORY_FILTER_ALL"] = "选择所有"
L["ARMORY_FILTER_CLEAR"] = "清除选择"
L["ARMORY_FILTER_DISABLE"] = "关闭过滤器"
L["ARMORY_FILTER_ENABLE"] = "开启过滤器"
L["ARMORY_FILTER_LABEL"] = "过滤器: %s"
L["ARMORY_FILTER_TOOLTIP"] = "点击查看全局物品过滤器."
--Translation missing 
L["ARMORY_FIND_BUTTON"] = "Find"
--Translation missing 
L["ARMORY_FIND_LABEL"] = "Find"
--Translation missing 
L["ARMORY_FIND_SUBTEXT"] = "These options allow you to change the behavior of the find command."
--Translation missing 
L["ARMORY_FIND_TITLE"] = "Search Database"
L["ARMORY_FONT_COLOR"] = "文字颜色"
--Translation missing 
L["ARMORY_FULLY_RESTED"] = "Fully rested in: %s"
--Translation missing 
L["ARMORY_GLOBAL"] = "Global"
L["ARMORY_GLYPH"] = "雕文"
L["ARMORY_IGNORE_REASON_COMBAT"] = "战斗时关闭共享功能"
L["ARMORY_IGNORE_REASON_INSTANCE"] = "副本时关闭共享功能"
L["ARMORY_IGNORE_REASON_SHARING"] = "共享被关闭"
L["ARMORY_IGNORE_REASON_VERSION"] = "不支持的版本协议"
--Translation missing 
L["ARMORY_INFO"] = "INFO"
--Translation missing 
L["ARMORY_INVALID_ITEM"] = "Invalid item, please rescan."
L["ARMORY_INVENTORY_BAGLAYOUT"] = "使用背包布局"
L["ARMORY_INVENTORY_BAGLAYOUT_TOOLTIP"] = "背包布局与实际情况一致."
L["ARMORY_INVENTORY_ICONVIEW"] = "图标查看"
L["ARMORY_INVENTORY_ICONVIEW_TOOLTIP"] = "标准查看"
L["ARMORY_INVENTORY_LISTVIEW"] = "显示清单"
L["ARMORY_INVENTORY_LISTVIEW_TOOLTIP"] = "在清单中显示包裹物品而不是图标."
L["ARMORY_INVENTORY_SEARCH_ALL"] = "搜索所有角色"
L["ARMORY_INVENTORY_SEARCH_ALL_TOOLTIP"] = "搜索数据库中所有角色的包裹物品."
L["ARMORY_INVENTORY_SEARCH_TEXT_TOOLTIP"] = [=[输入你的过滤标准.

注意你如果你希望根据品质过滤可以用'='后面跟随 %s, %s, %s, %s, %s, %s, %s 或 %s 或 0-7的数字来代替品质等级(例子 '=4' 就代表着史诗物品).]=]
--Translation missing 
L["ARMORY_KNOWN_BY"] = "Known by"
--Translation missing 
L["ARMORY_LINK_HINT"] = "Shift-click to link"
--Translation missing 
L["ARMORY_LINK_TRADESKILL_TOOLTIP"] = "Shift-click opens your profession."
L["ARMORY_LOOKUP_BUTTON"] = "查找"
L["ARMORY_LOOKUP_CHARACTER"] = "查找角色"
--Translation missing 
L["ARMORY_LOOKUP_CHARACTER_SEARCH_TOOLTIP"] = [=[Enter your filter criterion.

Note that this can also be the name of someone's alt.]=]
--Translation missing 
L["ARMORY_LOOKUP_DETAIL"] = "Click for details"
L["ARMORY_LOOKUP_DISABLED"] = "数据共享被关闭."
L["ARMORY_LOOKUP_IGNORED"] = "请求被拒绝 (理由: %s)"
--Translation missing 
L["ARMORY_LOOKUP_ITEM"] = "Lookup item"
--Translation missing 
L["ARMORY_LOOKUP_NODETAIL"] = "No details available"
--Translation missing 
L["ARMORY_LOOKUP_NOT_CACHED"] = "Item information missing; please retry"
--Translation missing 
L["ARMORY_LOOKUP_PLAYER_HINT"] = [=[Shift-click for player info
Right-click to whisper]=]
L["ARMORY_LOOKUP_QUEST"] = "查找任务"
L["ARMORY_LOOKUP_QUEST_AREA"] = "任务地区"
L["ARMORY_LOOKUP_QUEST_NAME"] = "任务名称"
--Translation missing 
L["ARMORY_LOOKUP_QUEST_SEARCH_TOOLTIP"] = [=[Enter your filter criterion.

Note that you also request for characters having quests in a certain area by selecting the corresponding option in the dropdown.]=]
--Translation missing 
L["ARMORY_LOOKUP_REALM_ALIAS"] = "Looked up"
L["ARMORY_LOOKUP_REQUEST_DETAIL"] = "请求的数据: %s"
L["ARMORY_LOOKUP_REQUEST_RECEIVED"] = "数据共享请求接收自 %s"
L["ARMORY_LOOKUP_REQUEST_SENT"] = "请求信息发送到 %s"
L["ARMORY_LOOKUP_RESPONSE_RECEIVED"] = "响应信息接收自 %s"
L["ARMORY_LOOKUP_RESPONSE_SENT"] = "响应信息发送到 %s"
L["ARMORY_LOOKUP_SEARCH_EXACT"] = "精确匹配"
L["ARMORY_LOOKUP_SKILL"] = "查找配方"
--Translation missing 
L["ARMORY_LOOKUP_SKILL_SEARCH_TOOLTIP"] = [=[Enter your filter criterion.

Character names returned can be clicked to access their skill window.
Note that you can request a full recipe list by entering just an asterisk (*).]=]
--Translation missing 
L["ARMORY_MAIL_COUNT_WARNING1"] = "The inbox still contains %d |4mail:mails; that couldn't be scanned."
--Translation missing 
L["ARMORY_MAIL_COUNT_WARNING2"] = "%1$s (%2$s) has %d |4mail:mails; that couldn't be scanned."
--Translation missing 
L["ARMORY_MAIL_COUNT_WARNING3"] = "Unknown sender detected. Please reopen your mail to force a rescan if this is unexpected."
--Translation missing 
L["ARMORY_MAIL_ITEM_COUNT"] = "Number of items:"
--Translation missing 
L["ARMORY_MAIL_LAST_VISIT"] = "Last visit:"
--Translation missing 
L["ARMORY_MAIL_REMAINING"] = "Mail remaining:"
--Translation missing 
L["ARMORY_MAIL_VISIT_WARNING"] = "%1$s (%2$s) hasn't visited the mailbox for %3$s. Please log in to check your inbox."
L["ARMORY_MINIMAP_LABEL"] = "迷你地图"
L["ARMORY_MINIMAP_SUBTEXT"] = "这个选项控制是否显示迷你地图按钮."
L["ARMORY_MINIMAP_TITLE"] = "Armory 迷你地图按钮"
L["ARMORY_MISC_LABEL"] = "综合"
L["ARMORY_MISC_SUBTEXT"] = "这个选项可以让你修改一些综合设置."
L["ARMORY_MISC_TITLE"] = "综合设置"
L["ARMORY_MODULES_LABEL"] = "模块"
L["ARMORY_MODULES_SUBTEXT"] = "这个选项可以让你设置哪个模块被激活."
L["ARMORY_MODULES_TITLE"] = "Armory 模块"
L["ARMORY_MONEY_TOTAL"] = "%1$s %2$s 合计:"
--Translation missing 
L["ARMORY_NO_DATA"] = "No data available"
--Translation missing 
L["ARMORY_OPEN_HINT"] = "Click to open"
--Translation missing 
L["ARMORY_PANDARIA_GEM_RESEARCH"] = "Pandaria Gem Research"
L["ARMORY_QUEST_TOOLTIP_LABEL"] = "以下小号有此任务:"
L["ARMORY_RECIPE"] = "配方"
--Translation missing 
L["ARMORY_RECIPE_WARNING"] = [=[Recipe %s not found in LibRecipes. Trying to make an educated guess.
Please check with '/armory find skill ...' to be sure.]=]
--Translation missing 
L["ARMORY_REPUTATION_SUMMARY"] = "%1$s - %2$s (%3$d/%4$d, %5$d left)"
--Translation missing 
L["ARMORY_SEARCHING"] = "Searching..."
--Translation missing 
L["ARMORY_SELECT_UNIT_HINT"] = "Left-click to select this character."
L["ARMORY_SHARE_DOWNLOAD_LOADERROR"] = "无法读取 %1$s; 理由: %2$s"
L["ARMORY_SHARE_LABEL"] = "共享"
L["ARMORY_SHARE_SUBTEXT1"] = "这个选项可以让你与其它 Armory 用户共享数据. 注意这个设置只基于每一个角色而非全局设置."
L["ARMORY_SHARE_SUBTEXT2"] = "下面这个选项可设置为全局设置."
L["ARMORY_SHARE_TITLE"] = "数据共享"
L["ARMORY_SHORTDATE_FORMAT"] = "ARMORY_SHORTDATE_FORMAT"
L["ARMORY_SLASH_ALTERNATIVES"] = "/ar"
--Translation missing 
L["ARMORY_SOCIAL_ADD_TOOLTIP"] = "Shift-click to add to your current list."
L["ARMORY_SUBTEXT"] = "这个设置界面将让你可以修改 Armory 的配置."
--Translation missing 
L["ARMORY_SUMMARY_LABEL"] = "Summary"
--Translation missing 
L["ARMORY_SUMMARY_SUBTEXT1"] = "These options allow you to change Armory's character summary sheet."
--Translation missing 
L["ARMORY_SUMMARY_SUBTEXT2"] = "Select the information to show."
--Translation missing 
L["ARMORY_SUMMARY_TITLE"] = "Summary Options"
L["ARMORY_TALENTS"] = "主要天赋:"
L["ARMORY_TOOLTIP_HINT1"] = "左键点击以开启或关闭 Armory"
L["ARMORY_TOOLTIP_HINT2"] = "右键点击打开设置界面"
--Translation missing 
L["ARMORY_TOOLTIP_LABEL"] = "Tooltip"
--Translation missing 
L["ARMORY_TOOLTIP_SUBTEXT"] = "These options allow you to add information to tooltips."
--Translation missing 
L["ARMORY_TOOLTIP_TITLE"] = "Tooltip Enhancement"
L["ARMORY_TOOLTIP1"] = "角色:"
L["ARMORY_TOOLTIP2"] = "服务器:"
--Translation missing 
L["ARMORY_TOTAL"] = "Total: %d"
L["ARMORY_TRADE_ALCHEMY"] = "炼金术"
L["ARMORY_TRADE_BLACKSMITHING"] = "锻造"
L["ARMORY_TRADE_COOKING"] = "烹饪"
L["ARMORY_TRADE_ENCHANTING"] = "附魔"
L["ARMORY_TRADE_ENGINEERING"] = "工程学"
L["ARMORY_TRADE_FIRST_AID"] = "急救"
L["ARMORY_TRADE_FISHING"] = "钓鱼"
L["ARMORY_TRADE_HERBALISM"] = "草药学"
L["ARMORY_TRADE_INSCRIPTION"] = "铭文"
L["ARMORY_TRADE_JEWELCRAFTING"] = "珠宝加工"
L["ARMORY_TRADE_LEATHERWORKING"] = "制皮"
L["ARMORY_TRADE_MINING"] = "采矿"
L["ARMORY_TRADE_POISONS"] = "毒药"
L["ARMORY_TRADE_SKILLS"] = "商业技能:"
L["ARMORY_TRADE_SKINNING"] = "剥皮"
L["ARMORY_TRADE_TAILORING"] = "裁缝"
--Translation missing 
L["ARMORY_TRADE_UPDATE_FAILED"] = "Profession data incomplete. Please reopen and close your profession window again."
--Translation missing 
L["ARMORY_TRADE_UPDATE_WARNING"] = "Profession data not saved. Please use the close button to trigger an update."
L["ARMORY_TRADESKILL_SEARCH_TEXT_TOOLTIP"] = [=[输入你的过滤标准.

注意你可以输出例如'10', '~10' 或 '10-20' 来过滤等级.]=]
L["ARMORY_TRANSMUTE"] = "转化"
--Translation missing 
L["ARMORY_UPDATE_SUSPENDED"] = "suspended"
--Translation missing 
L["ARMORY_VOID_STORAGE_ABBR"] = "Void"
L["ARMORY_WARNING"] = "警告"
--Translation missing 
L["ARMORY_WHAT"] = "What"
--Translation missing 
L["ARMORY_WHERE"] = "Where"
--Translation missing 
L["ARMORY_WHO"] = "Who"
--Translation missing 
L["ARMORY_WILL_LEARN"] = "Attainable by"
--Translation missing 
L["ARMORY_XP_SUMMARY"] = "Level %1$d (%2$s) %3$d XP to go, %4$s rested"
--Translation missing 
L["BINDING_NAME_ARMORY_ACHIEVEMENT"] = "Open achievement pane"
--Translation missing 
L["BINDING_NAME_ARMORY_CHARACTER"] = "Open character frame"
--Translation missing 
L["BINDING_NAME_ARMORY_CURRENCY"] = "Open currency frame"
--Translation missing 
L["BINDING_NAME_ARMORY_INVENTORY"] = "Open inventory"
--Translation missing 
L["BINDING_NAME_ARMORY_PET"] = "Open pet frame"
--Translation missing 
L["BINDING_NAME_ARMORY_PVP"] = "Open PVP frame"
--Translation missing 
L["BINDING_NAME_ARMORY_QUEST"] = "Open quest log"
--Translation missing 
L["BINDING_NAME_ARMORY_RAID"] = "Open raid frame"
--Translation missing 
L["BINDING_NAME_ARMORY_REPUTATION"] = "Open reputation frame"
--Translation missing 
L["BINDING_NAME_ARMORY_SOCIAL"] = "Open social pane"
--Translation missing 
L["BINDING_NAME_ARMORY_SPELLBOOK"] = "Open spellbook"
--Translation missing 
L["BINDING_NAME_ARMORY_TALENT"] = "Open talent frame"
L["BINDING_NAME_ARMORY_TOGGLE"] = "开启 / 关闭 Armory"
--Translation missing 
L["BINDING_NAME_ARMORY_TRADESKILL1"] = "Open primary profession 1"
--Translation missing 
L["BINDING_NAME_ARMORY_TRADESKILL2"] = "Open primary profession 2"
L["BINDING_NAME_CURRENT_CHARACTER"] = "选择当前角色"
--Translation missing 
L["BINDING_NAME_FIND"] = "Toggle database search"
L["BINDING_NAME_LOOKUP"] = "是否查找"
L["BINDING_NAME_NEXT_CHARACTER"] = "下一个角色"
L["BINDING_NAME_PREVIOUS_CHARACTER"] = "前一个角色"
