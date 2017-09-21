
local DF = _G ["DetailsFramework"]
if (not DF) then
	print ("|cFFFFAA00FlashTaskBar: framework not found, if you just installed or updated the addon, please restart your client.|r")
	return
end
 
local _

local L = LibStub ("AceLocale-3.0"):GetLocale ("FlashTaskbarLocales", true)
if (not L) then
	DF:ShowPanicWarning ("FlashTaskbar Locale failed to load, restart your game client to finish addon updates.")
	return
end

do
	local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	SharedMedia:Register ("sound", "d_whip1", [[Interface\Addons\FlashTaskBar\sounds\sound_whip1.ogg]])
end

local default_config = {
	profile = {
		readycheck = true,
		arena_queue = true,
		group_queue = true,
		petbattle_queue = true,
		brawlers_queue = true,
		pull_timers = true,
		enter_combat = false,
		end_taxi = false,
		chat_scan = false,
		chat_scan_keywords = {},
		combat_log = false,
		combat_log_keywords = {},
		rare_scan = true,
		any_rare = true,
		rare_names = {},
		disconnect_logout = false,
		invite = true,
		invite_ignore_on_autoaccept = false,
		trade = true,
		bags_full = false,
		worldpvp = true,
		duel_request = true,
		summon = true,
		fatigue = true,
		on_chat_player_name = false,
		whisper_blink = true,
		battleground_end = false,
		timer_start = false,
		low_health = false,
		lost_health = false,
		
		sound_enabled = {
			readycheck = {enabled = false, sound = "d_whip1"},
			arena_queue = {enabled = false, sound = "d_whip1"},
			group_queue = {enabled = false, sound = "d_whip1"},
			petbattle_queue = {enabled = false, sound = "d_whip1"},
			brawlers_queue = {enabled = false, sound = "d_whip1"},
			pull_timers = {enabled = false, sound = "d_whip1"},
			enter_combat = {enabled = false, sound = "d_whip1"},
			end_taxi = {enabled = false, sound = "d_whip1"},
			chat_scan = {enabled = false, sound = "d_whip1"},
			combat_log = {enabled = false, sound = "d_whip1"},
			rare_scan = {enabled = false, sound = "d_whip1"},
			disconnect_logout = {enabled = false, sound = "d_whip1"},
			invite = {enabled = false, sound = "d_whip1"},
			trade = {enabled = false, sound = "d_whip1"},
			bags_full = {enabled = false, sound = "d_whip1"},
			worldpvp = {enabled = false, sound = "d_whip1"},
			duel_request = {enabled = false, sound = "d_whip1"},
			summon = {enabled = false, sound = "d_whip1"},
			fatigue = {enabled = false, sound = "d_whip1"},
			on_chat_player_name = {enabled = false, sound = "d_whip1"},
			whisper_blink = {enabled = false, sound = "d_whip1"},
			battleground_end = {enabled = false, sound = "d_whip1"},
			timer_start = {enabled = false, sound = "d_whip1"},
			low_health = {enabled = false, sound = "d_whip1"},
			lost_health = {enabled = false, sound = "d_whip1"},
		},
	}
}

local options_table = {
	name = "FlashTaskBar",
	type = "group",
	args = {

	}
}
local Flash
TaskBar = DF:CreateAddOn ("FlashTaskBar", "FlashTaskbarDB", default_config, options_table)
local lower = string.lower

--store the address of the original chat func
local ChatFrame_MessageEventHandler_Original = ChatFrame_MessageEventHandler

FlashTaskBar.last_flash = 0

function FlashTaskBar:DoFlash (config_key)
	if (FlashTaskBar.last_flash + 4 < GetTime()) then
		FlashClientIcon()
		local has_sound = FlashTaskBar.db.profile.sound_enabled
		if (has_sound and has_sound [config_key] and has_sound [config_key].enabled) then
			local file = LibStub:GetLibrary("LibSharedMedia-3.0"):Fetch ("sound", has_sound [config_key].sound)
			PlaySoundFile (file, "Master")
		end
		FlashTaskBar.last_flash = GetTime()
	end
end

function FlashTaskBar.OnInit (self)

	--register slash
	SLASH_FLASHTASKBAR1 = "/flashtaskbar"
	function SlashCmdList.FLASHTASKBAR (msg, editbox)
		InterfaceOptionsFrame_OpenToCategory ("FlashTaskBar")
		InterfaceOptionsFrame_OpenToCategory ("FlashTaskBar")
	end

	--invite
	function FlashTaskBar:DelayInviteCheck()
		if (IsInGroup() or IsInRaid()) then
			return
		else
			FlashTaskBar:DoFlash("invite")
		end
	end

	--> wait 2 seconds before flash, other addons may auto answer the group invite
	function FlashTaskBar:CheckForGroupInvite()
		if (StaticPopup1 and StaticPopup1:IsShown()) then
			FlashTaskBar:DoFlash("invite")
		end
	end
	
	function FlashTaskBar:PARTY_INVITE_REQUEST()
		if (FlashTaskBar.db.profile.invite) then
			if (FlashTaskBar.db.profile.invite_ignore_on_autoaccept) then
				FlashTaskBar:ScheduleTimer ("DelayInviteCheck", 1.0)
			else
				FlashTaskBar:ScheduleTimer ("CheckForGroupInvite", 2.0)
			end
		end
	end
	FlashTaskBar:RegisterEvent ("PARTY_INVITE_REQUEST")
	
	--pet battle queue
	function FlashTaskBar:CheckPetBattleQueue()
		if (PetBattleQueueReadyFrame and PetBattleQueueReadyFrame:IsShown()) then
			FlashTaskBar:DoFlash("petbattle_queue")
		end
	end
	function FlashTaskBar:PET_BATTLE_QUEUE_STATUS (...)
		if (FlashTaskBar.db.profile.petbattle_queue) then
			FlashTaskBar:ScheduleTimer ("CheckPetBattleQueue", 1.5)
		end
	end
	FlashTaskBar:RegisterEvent ("PET_BATTLE_QUEUE_STATUS")

	function FlashTaskBar:UPDATE_BATTLEFIELD_STATUS()
		if (FlashTaskBar.db.profile.battleground_end) then
			if (WorldStateScoreFrame and WorldStateScoreFrame:IsShown()) then
				FlashTaskBar:DoFlash("battleground_end")
			end
		end
	end
	FlashTaskBar:RegisterEvent ("UPDATE_BATTLEFIELD_STATUS")

	--premade groups ready
	hooksecurefunc ("LFGListInviteDialog_Show", function()
		if (FlashTaskBar.db.profile.group_queue) then
			FlashTaskBar:DoFlash("group_queue")
			FlashTaskBar.last_flash = 0
		end
	end)
	
	--lfg lfpvp windows
	hooksecurefunc ("LFGDungeonReadyStatus_ResetReadyStates", function()
		if (FlashTaskBar.db.profile.group_queue) then
			FlashTaskBar:DoFlash("group_queue")
			FlashTaskBar.last_flash = 0
		end
	end)
	hooksecurefunc ("PVPReadyDialog_Display", function()
		if (FlashTaskBar.db.profile.arena_queue) then
			FlashTaskBar:DoFlash("arena_queue")
			FlashTaskBar.last_flash = 0
		end
	end)
	
	--game master
	hooksecurefunc ("HelpFrame_OnEvent", function (self, token)
		if (token == "GMRESPONSE_RECEIVED") then
			FlashTaskBar:DoFlash("")
		end
	end)
	
	--general alerts
	hooksecurefunc ("StaticPopup_Show", function (token, text_arg1, text_arg2, data, insertedFrame)
		if (token == "BFMGR_INVITED_TO_ENTER") then --> generic world pvp alert
			if (FlashTaskBar.db.profile.worldpvp) then
				FlashTaskBar:DoFlash("worldpvp")
			end
		
		elseif (token == "DUEL_REQUESTED" or token == "PET_BATTLE_PVP_DUEL_REQUESTED") then
			if (FlashTaskBar.db.profile.duel_request) then
				FlashTaskBar:DoFlash("duel_request")
			end
		
		elseif (token == "CONFIRM_SUMMON" or token == "CONFIRM_SUMMON_STARTING_AREA") then
			if (FlashTaskBar.db.profile.summon) then
				FlashTaskBar:DoFlash("summon")
			end
		
		elseif (token == "CHANNEL_INVITE" or token == "CHAT_CHANNEL_INVITE") then
			FlashTaskBar:DoFlash("")
		
		elseif (token == "PARTY_INVITE" or token == "PARTY_INVITE_XREALM") then
			if (not FlashTaskBar.db.profile.invite) then
				return
			end
			if (FlashTaskBar.db.profile.invite_ignore_on_autoaccept) then
				FlashTaskBar:ScheduleTimer ("DelayInviteCheck", 1.5)
			else
				FlashTaskBar:DoFlash("invite")
			end
		
		elseif (token == "TRADE_WITH_QUESTION") then
			if (FlashTaskBar.db.profile.trade) then
				FlashTaskBar:DoFlash("tarde")
			end
		end
		
	end)
	
	--brawlers guild
	function FlashTaskBar:CHAT_MSG_MONSTER_YELL (event, msg, source, _, _, player_name)
		if (player_name == UnitName ("player")) then
			if (FlashTaskBar.db.profile.brawlers_queue) then
				FlashTaskBar:DoFlash("brawlers_queue")
			end
		end
	end
	function FlashTaskBar:CheckForBrawlersGuild()
		local zoneName, zoneType, _, _, _, _, _, zoneMapID = GetInstanceInfo()
		if (zoneMapID == 369 or zoneMapID == 1043) then
			FlashTaskBar:RegisterEvent ("CHAT_MSG_MONSTER_YELL")
		else
			FlashTaskBar:UnregisterEvent ("CHAT_MSG_MONSTER_YELL")
		end
	end
	function FlashTaskBar:PLAYER_ENTERING_WORLD()
		FlashTaskBar:ScheduleTimer ("CheckForBrawlersGuild", 3)
	end
	function FlashTaskBar:ZONE_CHANGED_NEW_AREA()
		FlashTaskBar:ScheduleTimer ("CheckForBrawlersGuild", 3)
	end
	FlashTaskBar:RegisterEvent ("PLAYER_ENTERING_WORLD")
	FlashTaskBar:RegisterEvent ("ZONE_CHANGED_NEW_AREA")

	--pull timers
	function FlashTaskBar:CommReceived (_, prefix)
		if (not FlashTaskBar.db.profile.pull_timers) then
			return
		end
		if (prefix:find ("PT")) then
			FlashTaskBar:DoFlash("pull_timers")
		elseif (prefix:find ("BWPull")) then
			FlashTaskBar:DoFlash("pull_timers")
		end
	end
	FlashTaskBar:RegisterComm ("D4", "CommReceived")
	FlashTaskBar:RegisterComm ("BigWigs", "CommReceived")
	
	--readycheck
	function FlashTaskBar:READY_CHECK()
		if (FlashTaskBar.db.profile.readycheck) then
			FlashTaskBar:DoFlash("readycheck")
		end
	end
	FlashTaskBar:RegisterEvent ("READY_CHECK")
	
	--combat
	function FlashTaskBar:PLAYER_REGEN_DISABLED()
		if (FlashTaskBar.db.profile.enter_combat) then
			FlashTaskBar:DoFlash("enter_combat")
		end
	end
	FlashTaskBar:RegisterEvent ("PLAYER_REGEN_DISABLED")
	
	--taxi
	--after a true for UnitOnTaxi, wait until it is false again
	local CheckIfFlyingEnded = function (tickObject)
		if (not UnitOnTaxi ("player")) then
			tickObject:Cancel()
			FlashTaskBar:DoFlash("end_taxi")
			FlashTaskBar:Msg (L["STRING_CHAT_FLYPOINTENDED"])
		end
	end
	
	--after closing, check if the player is on a taxi
	local CheckIfIsFlying = function (tickObject)
		if (UnitOnTaxi ("player")) then
			if (FlashTaskBar.FlyingHasEndedCheck) then
				FlashTaskBar.FlyingHasEndedCheck:Cancel()
			end
			FlashTaskBar.FlyingHasEndedCheck = C_Timer.NewTicker (1, CheckIfFlyingEnded)
			tickObject:Cancel()
		end
	end
	
	--run when the player closes the taxi map
	function FlashTaskBar:TAXIMAP_CLOSED()
		if (FlashTaskBar.db.profile.end_taxi) then
			if (FlashTaskBar.IsFlyingTaxiCheck) then
				FlashTaskBar.IsFlyingTaxiCheck:Cancel()
			end
			FlashTaskBar.IsFlyingTaxiCheck = C_Timer.NewTicker (1, CheckIfIsFlying, 5) --only check for 5 seconds
		end
	end
	FlashTaskBar:RegisterEvent ("TAXIMAP_CLOSED")
	
	--disconenct
	GameMenuButtonLogout:HookScript ("OnClick", function() 
		FlashTaskBar.LogoutTolerance = GetTime()+30
	end)
	function FlashTaskBar:PLAYER_LOGOUT()
		if (FlashTaskBar.db.profile.disconnect_logout) then
			if (FlashTaskBar.LogoutTolerance and FlashTaskBar.LogoutTolerance > GetTime()) then
				return
			end
			FlashTaskBar:DoFlash("disconnect_logout")
		end
	end
	FlashTaskBar:RegisterEvent ("PLAYER_LOGOUT")
	
	--trade
	function FlashTaskBar:TRADE_SHOW()
		if (FlashTaskBar.db.profile.trade) then
			FlashTaskBar:DoFlash("trade")
		end
	end
	FlashTaskBar:RegisterEvent ("TRADE_SHOW")
	
	--bags full
	function FlashTaskBar:BAG_UPDATE()
		if (FlashTaskBar.db.profile.bags_full) then
			for backpack = 0, 4 do
				for slot = 1, GetContainerNumSlots (backpack) do
					local itemId = GetContainerItemID (backpack, slot)
					if (not itemId) then
						return
					end
				end
			end
			FlashTaskBar:DoFlash("bags_full")
		end
	end
	FlashTaskBar:RegisterEvent ("BAG_UPDATE")
	
	--fatigue
	function FlashTaskBar:MIRROR_TIMER_START (event, name, value, maxvalue, step, pause, label)
		if (FlashTaskBar.db.profile.fatigue) then
			if (name == "EXHAUSTION" and step == -1) then
				FlashTaskBar:DoFlash ("fatigue")
			end
		end
	end
	FlashTaskBar:RegisterEvent ("MIRROR_TIMER_START")

	--timer start
	function FlashTaskBar:START_TIMER()
		if (FlashTaskBar.db.profile.timer_start) then
			FlashTaskBar:DoFlash ("timer_start")
		end
	end
	FlashTaskBar:RegisterEvent ("START_TIMER")
	
	--low health
	FlashTaskBar.LastHealthBlink = time() - 30
	function FlashTaskBar.CheckTargetHealth()
		local targetHealth = UnitHealth ("target")
		if (targetHealth > 1) then
			local targetMaxHealth = UnitHealthMax ("target")
			if (targetMaxHealth) then
				if (FlashTaskBar.db.profile.low_health) then
					local percent = targetHealth / targetMaxHealth
					if (percent < 0.17) then
						if (FlashTaskBar.LastHealthBlink + 30 < time()) then
							FlashTaskBar:DoFlash ("low_health")
							FlashTaskBar.LastHealthBlink = time()
						end
					end
				end
				if (FlashTaskBar.db.profile.lost_health) then
					local percent = targetHealth / targetMaxHealth
					if (percent < 0.95) then
						if (FlashTaskBar.LastHealthBlink + 30 < time()) then
							FlashTaskBar:DoFlash ("lost_health")
							FlashTaskBar.LastHealthBlink = time()
						end
					end
				end
			end
		end
	end
	function FlashTaskBar:EnableCheckHealth (state)
		if (FlashTaskBar.HealthTicker) then
			FlashTaskBar.HealthTicker:Cancel()
		end
		if (state) then
			FlashTaskBar.HealthTicker = C_Timer.NewTicker (2, FlashTaskBar.CheckTargetHealth)
		else
			FlashTaskBar.HealthTicker = nil
		end
	end
	if (FlashTaskBar.db.profile.low_health) then
		FlashTaskBar:EnableCheckHealth (true)
	end
	if (FlashTaskBar.db.profile.lost_health) then
		FlashTaskBar:EnableCheckHealth (true)
	end
	
--------> chat scan
	
	local player_name = lower (UnitName ("player"))
	local do_chat_scan = function (_, message)
		message = lower (message)
		if (FlashTaskBar.db.profile.chat_scan) then
			for _, keyword in ipairs (FlashTaskBar.db.profile.chat_scan_keywords) do
				if (message:find (lower (keyword))) then
					FlashTaskBar:DoFlash ("chat_scan")
					return
				end
			end
		end
		
		if (FlashTaskBar.db.profile.on_chat_player_name) then
			if (message:find (player_name)) then
				FlashTaskBar:DoFlash("")
			end
		end
	end
	
	function FlashTaskBar:EnableChatScan()
		FlashTaskBar:RegisterEvent ("CHAT_MSG_EMOTE", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_MONSTER_EMOTE", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_MONSTER_SAY", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_MONSTER_WHISPER", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_MONSTER_YELL", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_RAID_BOSS_EMOTE", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_RAID_BOSS_WHISPER", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_SYSTEM", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_SAY", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_YELL", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_CHANNEL", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_PARTY", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_GUILD", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_INSTANCE_CHAT", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_OFFICER", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_PARTY_LEADER", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_RAID", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_RAID_LEADER", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_RAID_WARNING", do_chat_scan)
		
		player_name = lower (UnitName ("player"))
	end	
	
	function FlashTaskBar:DisableChatScan()
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_EMOTE")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_MONSTER_EMOTE")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_MONSTER_SAY")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_MONSTER_WHISPER")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_MONSTER_YELL")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_RAID_BOSS_EMOTE")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_RAID_BOSS_WHISPER")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_SYSTEM")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_SAY")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_YELL")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_CHANNEL")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_PARTY")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_GUILD")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_INSTANCE_CHAT")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_OFFICER")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_PARTY_LEADER")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_RAID")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_RAID_LEADER")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_RAID_WARNING")
	end

	function FlashTaskBar:DoNotFlashOnWhisper()
		_G.ChatFrame_MessageEventHandler = ChatFrame_MessageEventHandler_WithNoFlash
	end
	
	function FlashTaskBar:EnableFlashOnWhisper()
		_G.ChatFrame_MessageEventHandler = ChatFrame_MessageEventHandler_Original
	end 
	
	if (FlashTaskBar.db.profile.whisper_blink) then
		FlashTaskBar:EnableFlashOnWhisper()
	else
		FlashTaskBar:DoNotFlashOnWhisper()
	end
	
--------> combat log scan

	local combat_log_keywords = {}
	local do_combat_log_scan = function (event, time, token, hidding, who_serial, who_name, who_flags, who_flags2, target_serial, target_name, target_flags, target_flags2, ...)
		if (target_name and combat_log_keywords [lower (target_name)]) then
			FlashTaskBar:DoFlash("combat_log")
		end
	end
	
	function FlashTaskBar:BuildCombatLogKeywordTable()
		wipe (combat_log_keywords)
		for _, keyword in ipairs (FlashTaskBar.db.profile.combat_log_keywords) do
			combat_log_keywords [lower (keyword)] = true
		end
	end
	
	function FlashTaskBar:EnableCombatLogScan()
		FlashTaskBar:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED", do_combat_log_scan)
		FlashTaskBar:BuildCombatLogKeywordTable()
	end
	
	function FlashTaskBar:DisableCombatLogScan()
		FlashTaskBar:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
	end
	
--------> rare mob scan

	local do_rare_mob_scan = function()
		for i = 1, C_Vignettes.GetNumVignettes() do
			local serial = C_Vignettes.GetVignetteGUID (i)
			if (serial) then
				local _, _, name, objectIcon = C_Vignettes.GetVignetteInfoFromInstanceID (serial)
				if (objectIcon and (objectIcon == 41 or objectIcon == 4733)) then
					if (FlashTaskBar.db.profile.any_rare) then
						FlashTaskBar:DoFlash("rare_scan")
					elseif (name) then
						for _, npc_name in ipairs (FlashTaskBar.db.profile.rare_names) do
							npc_name = lower (npc_name)
							name = lower (name)
							if (npc_name == name) then
								FlashTaskBar:DoFlash("rare_scan")
							end
						end
					end
				end
			end
		end
	end
	
	function FlashTaskBar:EnableRareMobScan()
		FlashTaskBar:RegisterEvent ("VIGNETTE_ADDED", do_rare_mob_scan) --"VIGNETTE_REMOVED"
	end
	
	function FlashTaskBar:DisableRareMobScan()
		FlashTaskBar:UnregisterEvent ("VIGNETTE_ADDED")
	end
 
--> overrides
	--replace the built-in flash function from the game client to flash when the player enters in combat
	if (LowHealthFrame) then
		function LowHealthFrame:SetInCombat(inCombat)
			if self.inCombat ~= inCombat then
				self.inCombat = inCombat;
				if ( self.inCombat ) then
					--FlashClientIcon();
				end
				self:EvaluateVisibleState();
			end
		end
	end

--> build options panel
	
	local options = {
		{
			type = "toggle",
			name = L["STRING_READYCHECK"],
			desc = L["STRING_READYCHECK_DESC"],
			order = 1,
			get = function() return FlashTaskBar.db.profile.readycheck end,
			set = function (self, val) 
				FlashTaskBar.db.profile.readycheck = not FlashTaskBar.db.profile.readycheck
			end,
		},
		{
			type = "toggle",
			name = L["STRING_PVPQUEUES"],
			desc = L["STRING_PVPQUEUES_DESC"],
			order = 2,
			get = function() return FlashTaskBar.db.profile.arena_queue end,
			set = function (self, val) 
				FlashTaskBar.db.profile.arena_queue = not FlashTaskBar.db.profile.arena_queue
			end,
		},
		{
			type = "toggle",
			name = L["STRING_FINDERQUEUES"],
			desc = L["STRING_FINDERQUEUES_DESC"],
			order = 3,
			get = function() return FlashTaskBar.db.profile.group_queue end,
			set = function (self, val) 
				FlashTaskBar.db.profile.group_queue = not FlashTaskBar.db.profile.group_queue
			end,
		},
		{
			type = "toggle",
			name = L["STRING_PETBATTLES"] ,
			desc = L["STRING_PETBATTLES_DESC"] ,
			order = 6,
			get = function() return FlashTaskBar.db.profile.petbattle_queue end,
			set = function (self, val) 
				FlashTaskBar.db.profile.petbattle_queue = not FlashTaskBar.db.profile.petbattle_queue
			end,
		},
		{
			type = "toggle",
			name = L["STRING_BRAWLERS"],
			desc = L["STRING_BRAWLERS_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.brawlers_queue end,
			set = function (self, val) 
				FlashTaskBar.db.profile.brawlers_queue = not FlashTaskBar.db.profile.brawlers_queue
			end,
		},		
		{
			type = "toggle",
			name = L["STRING_PULL"],
			desc = L["STRING_PULL_DESC"],
			order = 4,
			get = function() return FlashTaskBar.db.profile.pull_timers end,
			set = function (self, val) 
				FlashTaskBar.db.profile.pull_timers = not FlashTaskBar.db.profile.pull_timers
			end,
		},
		{
			type = "toggle",
			name = L["STRING_ENTERCOMBAT"],
			desc = L["STRING_ENTERCOMBAT_DESC"],
			order = 5,
			get = function() return FlashTaskBar.db.profile.enter_combat end,
			set = function (self, val) 
				FlashTaskBar.db.profile.enter_combat = not FlashTaskBar.db.profile.enter_combat
			end,
		},
		{
			type = "toggle",
			name = L["STRING_FLYPOINT"],
			desc = L["STRING_FLYPOINT_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.end_taxi end,
			set = function (self, val) 
				FlashTaskBar.db.profile.end_taxi = not FlashTaskBar.db.profile.end_taxi
			end,
		},
		{
			type = "toggle",
			name = L["STRING_DISCONNECT"],
			desc = L["STRING_DISCONNECT_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.disconnect_logout end,
			set = function (self, val) 
				FlashTaskBar.db.profile.disconnect_logout = not FlashTaskBar.db.profile.disconnect_logout
			end,
		},
		
		{
			type = "toggle",
			name = L["STRING_INVITES"],
			desc = L["STRING_INVITES_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.invite end,
			set = function (self, val) 
				FlashTaskBar.db.profile.invite = not FlashTaskBar.db.profile.invite
			end,
		},		
		{
			type = "toggle",
			name = L["STRING_INVITEIGNORE"],
			desc = L["STRING_INVITEIGNORE_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.invite_ignore_on_autoaccept end,
			set = function (self, val) 
				FlashTaskBar.db.profile.invite_ignore_on_autoaccept = not FlashTaskBar.db.profile.invite_ignore_on_autoaccept
			end,
		},
		
		{
			type = "toggle",
			name = L["STRING_TRADE"],
			desc = L["STRING_TRADE_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.trade end,
			set = function (self, val) 
				FlashTaskBar.db.profile.trade = not FlashTaskBar.db.profile.trade
			end,
		},
		{
			type = "toggle",
			name = L["STRING_BAGSFULL"],
			desc = L["STRING_BAGSFULL_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.bags_full end,
			set = function (self, val) 
				FlashTaskBar.db.profile.bags_full = not FlashTaskBar.db.profile.bags_full
			end,
		},
		{
			type = "toggle",
			name = L["STRING_WORLDPVP"],
			desc = L["STRING_WORLDPVP_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.worldpvp end,
			set = function (self, val) 
				FlashTaskBar.db.profile.worldpvp = not FlashTaskBar.db.profile.worldpvp
			end,
		},
		{
			type = "toggle",
			name = L["STRING_DUELREQUEST"] ,
			desc = L["STRING_DUELREQUEST_DESC"] ,
			order = 6,
			get = function() return FlashTaskBar.db.profile.duel_request end,
			set = function (self, val) 
				FlashTaskBar.db.profile.duel_request = not FlashTaskBar.db.profile.duel_request
			end,
		},		
		{
			type = "toggle",
			name = L["STRING_SUMMON"],
			desc = L["STRING_SUMMON_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.summon end,
			set = function (self, val) 
				FlashTaskBar.db.profile.summon = not FlashTaskBar.db.profile.summon
			end,
		},
		{
			type = "toggle",
			name = L["STRING_FATIGUE"],
			desc = L["STRING_FATIGUE_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.fatigue end,
			set = function (self, val) 
				FlashTaskBar.db.profile.fatigue = not FlashTaskBar.db.profile.fatigue
			end,
		},
		{
			type = "toggle",
			name = L["STRING_PLAYERNAME"],
			desc = L["STRING_PLAYERNAME_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.on_chat_player_name end,
			set = function (self, val) 
				FlashTaskBar.db.profile.on_chat_player_name = not FlashTaskBar.db.profile.on_chat_player_name
				if (FlashTaskBar.db.profile.on_chat_player_name) then
					FlashTaskBar:EnableChatScan()
				else
					--ver se tem alguma outra fun��o usando o chat scan
					if (not FlashTaskBar.db.profile.chat_scan) then
						FlashTaskBar:DisableChatScan()
					end
				end
			end,
		},
		
		{
			type = "toggle",
			name = L["STRING_ONWHISPER"],
			desc = L["STRING_ONWHISPER_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.whisper_blink end,
			set = function (self, val) 
				FlashTaskBar.db.profile.whisper_blink = not FlashTaskBar.db.profile.whisper_blink
				if (FlashTaskBar.db.profile.whisper_blink) then
					FlashTaskBar:EnableFlashOnWhisper()
				else
					FlashTaskBar:DoNotFlashOnWhisper()
				end
			end,
		},
		
		{
			type = "toggle",
			name = L["STRING_BATTLEGROUND"],
			desc = L["STRING_BATTLEGROUND_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.battleground_end end,
			set = function (self, val) 
				FlashTaskBar.db.profile.battleground_end = not FlashTaskBar.db.profile.battleground_end
			end,
		},
		
		{
			type = "toggle",
			name = L["STRING_ONCOUNTDOWN"],
			desc = L["STRING_ONCOUNTDOWN_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.timer_start end,
			set = function (self, val) 
				FlashTaskBar.db.profile.timer_start = not FlashTaskBar.db.profile.timer_start
			end,
		},
		
		{
			type = "toggle",
			name = L["STRING_TARGETLOWHEALTH"],
			desc = L["STRING_TARGETLOWHEALTH_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.low_health end,
			set = function (self, val) 
				FlashTaskBar.db.profile.low_health = not FlashTaskBar.db.profile.low_health
				if (FlashTaskBar.db.profile.low_health) then
					FlashTaskBar:EnableCheckHealth (true)
				else
					FlashTaskBar:EnableCheckHealth (false)
				end
			end,
		},

		{
			type = "toggle",
			name = L["STRING_TARGETLOSTHEALTH"],
			desc = L["STRING_TARGETLOSTHEALTH_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.lost_health end,
			set = function (self, val) 
				FlashTaskBar.db.profile.lost_health = not FlashTaskBar.db.profile.lost_health
				if (FlashTaskBar.db.profile.lost_health) then
					FlashTaskBar:EnableCheckHealth (true)
				else
					FlashTaskBar:EnableCheckHealth (false)
				end
			end,
		},
	}
	
	local options_text_template = FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = FlashTaskBar:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = FlashTaskBar:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
	
	local general_text1 = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_GENERALSETTINGS"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	general_text1:SetPoint ("topleft", main_frame, "topleft", 10, -50)
	FlashTaskBar:SetFontSize (general_text1, 16)
	
	local general_settings_frame = CreateFrame ("frame", "FlashTaskBarGeneralOptionsFrame", FlashTaskBar.OptionsFrame1)
	general_settings_frame:SetPoint ("topleft", 0, 0)
	general_settings_frame:SetSize (1, 1)
	
	FlashTaskBar:BuildMenu (general_settings_frame, options, 15, -77, 280, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
	
	local y_chat_scan = -250
	
	local camping_text1 = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_CAMPINGSETTINGS"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	camping_text1:SetPoint ("topleft", main_frame, "topleft", 10, y_chat_scan)
	local sound_button_y = y_chat_scan
	FlashTaskBar:SetFontSize (camping_text1, 16)
	y_chat_scan = y_chat_scan - 30
	
	--> chat scan settings
	
	--> title label
	local blink_on_chat = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_CHATSCAN"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	blink_on_chat:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan)	
	
	--> enabled
	local enable_chat_filter = function (_, _, value)
		FlashTaskBar.db.profile.chat_scan = value
		if (value) then
			FlashTaskBar:EnableChatScan()
		else
			--ver se tem alguma outra fun��o usando o chat scan
			if (not FlashTaskBar.db.profile.on_chat_player_name) then
				FlashTaskBar:DisableChatScan()
			end
		end
	end
	local chat_scan_switch, chat_scan_label = FlashTaskBar:CreateSwitch (FlashTaskBar.OptionsFrame1, enable_chat_filter, FlashTaskBar.db.profile.chat_scan, _, _, _, _, "switch_enable_chat_scan", _, _, _, _, L["STRING_CHATSCAN_ENABLED"] .. ":", FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	chat_scan_switch:SetAsCheckBox()
	chat_scan_switch.tooltip = L["STRING_CHATSCAN_ENABLED_DESC"]
	chat_scan_label:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-20)	
	
	--> key words
	--add
	local chat_scan_keyword, label_chat_scan_keyword = FlashTaskBar:CreateTextEntry (FlashTaskBar.OptionsFrame1, function()end, 120, 20, "entry_add_keyword", _, L["STRING_ADDKEYWORD"] .. ":", FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	label_chat_scan_keyword:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-40)	
	
	local add_key_word_func = function()
		local keyword = chat_scan_keyword.text
		if (keyword ~= "") then
			tinsert (FlashTaskBar.db.profile.chat_scan_keywords, keyword)
		end
		chat_scan_keyword.text = ""
		chat_scan_keyword:ClearFocus()
		FlashTaskBar.OptionsFrame1.dropdown_keyword_remove:Refresh()
		FlashTaskBar.OptionsFrame1.dropdown_keyword_remove:Select (1, true)
	end
	local button_add_keyword = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, add_key_word_func, 60, 18, L["STRING_ADD"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_add_keyword:SetPoint ("left", chat_scan_keyword, "right", 2, 0)
	
	--remove
	local dropdown_keyword_erase_fill = function()
		local t = {}
		for i, keyword in ipairs (FlashTaskBar.db.profile.chat_scan_keywords) do
			t [#t+1] = {value = i, label = keyword, onclick = empty_func}
		end
		return t
	end
	local label_keyword_remove = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_ERASEKEYWORD"] .. ": ", FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	local dropdown_keyword_remove = FlashTaskBar:CreateDropDown (FlashTaskBar.OptionsFrame1, dropdown_keyword_erase_fill, _, 160, 20, "dropdown_keyword_remove", _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	dropdown_keyword_remove:SetPoint ("left", label_keyword_remove, "right", 2, 0)

	local keyword_remove = function()
		local value = dropdown_keyword_remove.value
		tremove (FlashTaskBar.db.profile.chat_scan_keywords, value)
		dropdown_keyword_remove:Refresh()
		dropdown_keyword_remove:Select (1, true)
	end
	local button_keyword_remove = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, keyword_remove, 60, 18, L["STRING_REMOVE"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_keyword_remove:SetPoint ("left", dropdown_keyword_remove, "right", 2, 0)
	label_keyword_remove:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-60)
	
	--ativar o chat scan se necess�rio
	if (FlashTaskBar.db.profile.chat_scan or FlashTaskBar.db.profile.on_chat_player_name) then
		FlashTaskBar:EnableChatScan()
	end
	
	--> combat log scan settings
	--> title label
	local blink_on_combatlog = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_COMBATLOGSCAN"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	blink_on_combatlog:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-90)		
	
	--> enabled
	local enable_combatlog_filter = function (_, _, value)
		FlashTaskBar.db.profile.combat_log = value
		if (value) then
			FlashTaskBar:EnableCombatLogScan()
		else
			FlashTaskBar:DisableCombatLogScan()
		end
	end
	local combatlog_scan_switch, combatlog_scan_label = FlashTaskBar:CreateSwitch (FlashTaskBar.OptionsFrame1, enable_combatlog_filter, FlashTaskBar.db.profile.combat_log, _, _, _, _, "switch_enable_combatlog_scan", _, _, _, _, L["STRING_COMBATLOGSCAN_ENABLED"]  .. ":", FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	combatlog_scan_switch.tooltip = L["STRING_COMBATLOGSCAN_ENABLED_DESC"] 
	combatlog_scan_switch:SetAsCheckBox()
	combatlog_scan_label:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-110)	
	
	--> key words
	--add
	local combatlog_scan_keyword, label_combatlog_scan_keyword = FlashTaskBar:CreateTextEntry (FlashTaskBar.OptionsFrame1, function()end, 120, 20, "entry_add_keyword", _, L["STRING_RARENPCSCAN_NPCNAME"] .. ":", FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	label_combatlog_scan_keyword:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-130)	
	
	local add_key_word_func = function()
		local keyword = combatlog_scan_keyword.text
		if (keyword ~= "") then
			tinsert (FlashTaskBar.db.profile.combat_log_keywords, keyword)
		end
		combatlog_scan_keyword.text = ""
		combatlog_scan_keyword:ClearFocus()
		FlashTaskBar.OptionsFrame1.dropdown_combatlog_keyword_remove:Refresh()
		FlashTaskBar.OptionsFrame1.dropdown_combatlog_keyword_remove:Select (1, true)
		FlashTaskBar:BuildCombatLogKeywordTable()
	end
	local button_add_keyword = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, add_key_word_func, 60, 18, L["STRING_ADD"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_add_keyword:SetPoint ("left", combatlog_scan_keyword, "right", 2, 0)
	
	--remove
	local dropdown_keyword_erase_fill = function()
		local t = {}
		for i, keyword in ipairs (FlashTaskBar.db.profile.combat_log_keywords) do
			t [#t+1] = {value = i, label = keyword, onclick = empty_func}
		end
		return t
	end
	local label_keyword_remove = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_REMOVE_TITLE"] .. ": ", FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	local dropdown_keyword_remove = FlashTaskBar:CreateDropDown (FlashTaskBar.OptionsFrame1, dropdown_keyword_erase_fill, _, 160, 20, "dropdown_combatlog_keyword_remove", _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	dropdown_keyword_remove:SetPoint ("left", label_keyword_remove, "right", 2, 0)

	local keyword_remove = function()
		local value = dropdown_keyword_remove.value
		tremove (FlashTaskBar.db.profile.combat_log_keywords, value)
		dropdown_keyword_remove:Refresh()
		dropdown_keyword_remove:Select (1, true)
		FlashTaskBar:BuildCombatLogKeywordTable()
	end
	local button_keyword_remove = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, keyword_remove, 60, 18, L["STRING_REMOVE"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_keyword_remove:SetPoint ("left", dropdown_keyword_remove, "right", 2, 0)
	label_keyword_remove:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-150)
	
	if (FlashTaskBar.db.profile.combat_log) then
		FlashTaskBar:EnableCombatLogScan()
	end

	--> rare mob scan settings
	--> title label
	local blink_on_raremob = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_RARENPCSCAN"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	blink_on_raremob:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-180)		
	
	--> enabled
	local enable_raremob_filter = function (_, _, value)
		FlashTaskBar.db.profile.rare_scan = value
		if (value) then
			FlashTaskBar:EnableRareMobScan()
		else
			FlashTaskBar:DisableRareMobScan()
		end
	end
	local raremob_scan_switch, raremob_scan_label = FlashTaskBar:CreateSwitch (FlashTaskBar.OptionsFrame1, enable_raremob_filter, FlashTaskBar.db.profile.rare_scan, _, _, _, _, "switch_enable_raremob_scan", _, _, _, _, L["STRING_RARENPCSCAN_ENABLED"] .. ":", FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	raremob_scan_switch:SetAsCheckBox()
	raremob_scan_switch.tooltip = L["STRING_RARENPCSCAN_DESC"]
	raremob_scan_label:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-200)	
	
	--> all rares
	local enable_raremob_all_filter = function (_, _, value)
		FlashTaskBar.db.profile.any_rare = value
	end
	local raremob_all_scan_switch, raremob_all_scan_label = FlashTaskBar:CreateSwitch (FlashTaskBar.OptionsFrame1, enable_raremob_all_filter, FlashTaskBar.db.profile.any_rare, _, _, _, _, "switch_enable_raremob_all_scan", _, _, _, _, L["STRING_RARENPCSCAN_ANYNPC"] .. ":", FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	raremob_all_scan_switch:SetAsCheckBox()
	raremob_all_scan_label:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-220)	
	
	--> key words
	--add
	local raremob_scan_keyword, label_raremob_scan_keyword = FlashTaskBar:CreateTextEntry (FlashTaskBar.OptionsFrame1, function()end, 120, 20, "raremob_add_keyword", _, L["STRING_RARENPCSCAN_NPCNAME"] .. ":", FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	label_raremob_scan_keyword:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-240)	
	
	local add_key_word_func = function()
		local keyword = raremob_scan_keyword.text
		if (keyword ~= "") then
			tinsert (FlashTaskBar.db.profile.rare_names, keyword)
		end
		raremob_scan_keyword.text = ""
		raremob_scan_keyword:ClearFocus()
		FlashTaskBar.OptionsFrame1.dropdown_rare_keyword_remove:Refresh()
		FlashTaskBar.OptionsFrame1.dropdown_rare_keyword_remove:Select (1, true)
	end
	local button_add_keyword = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, add_key_word_func, 60, 18, L["STRING_ADD"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_add_keyword:SetPoint ("left", raremob_scan_keyword, "right", 2, 0)
	
	--remove
	local dropdown_keyword_erase_fill = function()
		local t = {}
		for i, keyword in ipairs (FlashTaskBar.db.profile.rare_names) do
			t [#t+1] = {value = i, label = keyword, onclick = empty_func}
		end
		return t
	end
	local label_keyword_remove = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_REMOVE_TITLE"] .. ": ", FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	local dropdown_keyword_remove = FlashTaskBar:CreateDropDown (FlashTaskBar.OptionsFrame1, dropdown_keyword_erase_fill, _, 160, 20, "dropdown_rare_keyword_remove", _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	dropdown_keyword_remove:SetPoint ("left", label_keyword_remove, "right", 2, 0)

	local keyword_remove = function()
		local value = dropdown_keyword_remove.value
		tremove (FlashTaskBar.db.profile.rare_names, value)
		dropdown_keyword_remove:Refresh()
		dropdown_keyword_remove:Select (1, true)
	end
	local button_keyword_remove = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, keyword_remove, 60, 20, L["STRING_REMOVE"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_keyword_remove:SetPoint ("left", dropdown_keyword_remove, "right", 2, 0)
	label_keyword_remove:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-260)
	
	if (FlashTaskBar.db.profile.rare_scan) then
		FlashTaskBar:EnableRareMobScan()
	end
	
	--> sound options
	local sound_x = 380
	local sound_text1 = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_SOUNDSETTINGS"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	sound_text1:SetPoint ("topleft", main_frame, "topleft", sound_x, sound_button_y)
	FlashTaskBar:SetFontSize (sound_text1, 16)
	
	local open_sound_panel = function()
		if (_G.FlashTaskbarSoundSettings) then
			_G.FlashTaskbarSoundSettings:Show()
			return
		end
		
		local f = DF:Create1PxPanel (FlashTaskBar.OptionsFrame1, 450, 300, "", "FlashTaskbarSoundSettings", nil, nil, nil)
		f:SetPoint ("center", FlashTaskBar.OptionsFrame1, "center")
		f:SetSize (FlashTaskBar.OptionsFrame1:GetSize())
		f:SetFrameLevel (FlashTaskBar.OptionsFrame1:GetFrameLevel()+5)
		f:SetLocked (true)
		
		f:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], tile = true, tileSize = 64})
		f:SetBackdropColor (0, 0, 0, 1)
		
		local close_sound_settings = FlashTaskBar:CreateButton (f, function() f:Hide() end, 160, 20, L["STRING_CLOSESOUNDPANEL"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
		close_sound_settings:SetPoint ("topleft", f, "topleft", 10, -500)
		close_sound_settings:SetIcon ([[Interface\Scenarios\ScenarioIcon-Check]], 16, 16, "overlay", {0, 1, 0, 1}, nil, 6, nil, 1)
		
		local sound_title = FlashTaskBar:CreateLabel (f, L["STRING_SOUNDSETTINGS"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
		sound_title:SetPoint ("topleft", f, "topleft", 10, -50)
		FlashTaskBar:SetFontSize (sound_title, 16)
		local sound_title_desc = FlashTaskBar:CreateLabel (f, L["STRING_SOUNDSETTINGS_DESC"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
		sound_title_desc:SetPoint ("topleft", f, "topleft", 10, -70)
		
		local localize_key = {
			readycheck = "READYCHECK",
			arena_queue = "PVPQUEUES",
			group_queue = "FINDERQUEUES",
			petbattle_queue = "PETBATTLES",
			brawlers_queue = "BRAWLERS",
			pull_timers = "PULL",
			enter_combat = "ENTERCOMBAT",
			end_taxi = "FLYPOINT",
			chat_scan = "CHATSCAN",
			combat_log = "COMBATLOGSCAN",
			rare_scan = "RARENPCSCAN",
			disconnect_logout = "DISCONNECT",
			invite = "INVITES",
			trade = "TRADE",
			bags_full = "BAGSFULL",
			worldpvp = "WORLDPVP",
			duel_request = "DUELREQUEST",
			summon = "SUMMON",
			fatigue = "FATIGUE",
			battleground_end = "BATTLEGROUND",
			on_chat_player_name = "PLAYERNAME",
		}
		
		--the game cannot play sounds when logging off
		local settings = {
			"rare_scan",
			"arena_queue",
			"group_queue",
			"readycheck",
			"petbattle_queue",
			"brawlers_queue",
			"pull_timers",
			"enter_combat",
			"end_taxi",
			"chat_scan",
			"combat_log",
			"invite",
			"trade",
			"bags_full",
			"worldpvp",
			"duel_request",
			"summon",
			"fatigue",
			"on_chat_player_name",
			"battleground_end"
		}
		
		local sound_options = {}
		local y = -95
		local x = 10
		
		local checkbox_ontoggle = function (self, _, value)
			self.MyConfigTable.enabled = not self.MyConfigTable.enabled
		end
		local sound_dropdown_selected = function (self, _, value)
			self.MyConfigTable.sound = value
			PlaySoundFile (LibStub:GetLibrary("LibSharedMedia-3.0"):Fetch ("sound", value), "Master")
		end
		local SoundTable
		local sound_dropdown_fill = function (capsule)
			if (not SoundTable) then
				SoundTable = {}
				local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
				for name, _ in pairs (SharedMedia:HashTable ("sound")) do 
					tinsert (SoundTable, {value = name, label = name, onclick = sound_dropdown_selected})
				end
			end
			return SoundTable 
		end
		
		local switch_name = 999
		for index, config_key in  ipairs (settings) do
			local name_locale = L["STRING_" .. localize_key [config_key]] .. ":"
			local desc_locale = L["STRING_" .. localize_key [config_key] .. "_DESC"]
			local config_table = FlashTaskBar.db.profile.sound_enabled [config_key]
			
			local label = FlashTaskBar:CreateLabel (f, name_locale, FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
			label.color = "yellow"
			label:SetPoint (x, y)

			local checkbox = FlashTaskBar:CreateSwitch (f, checkbox_ontoggle, config_table.enabled, _, _, _, _, _, nil, _, _, _, _, FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
			checkbox:SetAsCheckBox()
			checkbox.tooltip = desc_locale
			checkbox.MyConfigTable = config_table
			checkbox:SetPoint (x + 120, y)
			
			local dropdown = FlashTaskBar:CreateDropDown (f, sound_dropdown_fill, config_table.sound, 160, 20, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			dropdown.MyConfigTable = config_table
			dropdown:SetPoint (x + 180, y)
		
			y = y - 20
			
			switch_name = switch_name + 1
		end
		
		FlashTaskBar.NoBGSound = FlashTaskBar:CreateLabel (f, "*Enable 'Sound in Background'\nunder System > Sound*", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
		FlashTaskBar.NoBGSound.color = "red"
		FlashTaskBar.NoBGSound.fontsize = 12
		FlashTaskBar.NoBGSound.align = "center"
		FlashTaskBar.NoBGSound:SetPoint (415, -150)

		f:SetScript ("OnShow", function()
			local isBGSoundDisabled = GetCVar ("Sound_EnableSoundWhenGameIsInBG")
			if (isBGSoundDisabled == "0") then
				FlashTaskBar.NoBGSound:Show()
			else
				FlashTaskBar.NoBGSound:Hide()
			end
		end)
	end
	
	local open_sound_settings = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, open_sound_panel, 160, 18, L["STRING_OPENSOUNDPANEL"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	open_sound_settings:SetPoint ("topleft", main_frame, "topleft", sound_x-1, sound_button_y-30)
	open_sound_settings:SetIcon ([[Interface\Buttons\UI-GuildButton-MOTD-Up]], 16, 15, "overlay", {1, 0, 0, 1}, nil, 6, nil, 1)
end


function ChatFrame_MessageEventHandler_WithNoFlash (self, event, ...)
	if ( strsub(event, 1, 8) == "CHAT_MSG" ) then
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...;
		if (arg16) then
			-- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)
			return true;
		end

		local type = strsub(event, 10);
		local info = ChatTypeInfo[type];
		local chatFilters = {};
		
		local filter = false;
		if ( chatFilters[event] ) then
			local newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14;
			for _, filterFunc in next, chatFilters[event] do
				filter, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14 = filterFunc(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);
				if ( filter ) then
					return true;
				elseif ( newarg1 ) then
					arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14;
				end
			end
		end

		local coloredName = GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);

		local channelLength = strlen(arg4);
		local infoType = type;
		if ( (strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST") and ((arg1 ~= "INVITE") or (type ~= "CHANNEL_NOTICE_USER")) ) then
			if ( arg1 == "WRONG_PASSWORD" ) then
				local staticPopup = _G[StaticPopup_Visible("CHAT_CHANNEL_PASSWORD") or ""];
				if ( staticPopup and strupper(staticPopup.data) == strupper(arg9) ) then
					-- Don't display invalid password messages if we're going to prompt for a password (bug 102312)
					return;
				end
			end

			local found = 0;
			for index, value in pairs(self.channelList) do
				if ( channelLength > strlen(value) ) then
					-- arg9 is the channel name without the number in front...
					if ( ((arg7 > 0) and (self.zoneChannelList[index] == arg7)) or (strupper(value) == strupper(arg9)) ) then
						found = 1;
						infoType = "CHANNEL"..arg8;
						info = ChatTypeInfo[infoType];
						if ( (type == "CHANNEL_NOTICE") and (arg1 == "YOU_LEFT") ) then
							self.channelList[index] = nil;
							self.zoneChannelList[index] = nil;
						end
						break;
					end
				end
			end
			if ( (found == 0) or not info ) then
				return true;
			end
		end

		local chatGroup = Chat_GetChatCategory(type);
		local chatTarget;
		if ( chatGroup == "CHANNEL" ) then
			chatTarget = tostring(arg8);
		elseif ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			if(not(strsub(arg2, 1, 2) == "|K")) then
				chatTarget = strupper(arg2);
			else
				chatTarget = arg2;
			end
		end

		if ( FCFManager_ShouldSuppressMessage(self, chatGroup, chatTarget) ) then
			return true;
		end

		if ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			if ( self.privateMessageList and not self.privateMessageList[strlower(arg2)] ) then
				return true;
			elseif ( self.excludePrivateMessageList and self.excludePrivateMessageList[strlower(arg2)]
				and ( (chatGroup == "WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") or (chatGroup == "BN_WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") ) ) then
				return true;
			end
		end

		if (self.privateMessageList) then
			-- Dedicated BN whisper windows need online/offline messages for only that player
			if ( (chatGroup == "BN_INLINE_TOAST_ALERT" or chatGroup == "BN_WHISPER_PLAYER_OFFLINE") and not self.privateMessageList[strlower(arg2)] ) then
				return true;
			end

			-- HACK to put certain system messages into dedicated whisper windows
			if ( chatGroup == "SYSTEM") then
				local matchFound = false;
				local message = strlower(arg1);
				for playerName, _ in pairs(self.privateMessageList) do
					local playerNotFoundMsg = strlower(format(ERR_CHAT_PLAYER_NOT_FOUND_S, playerName));
					local charOnlineMsg = strlower(format(ERR_FRIEND_ONLINE_SS, playerName, playerName));
					local charOfflineMsg = strlower(format(ERR_FRIEND_OFFLINE_S, playerName));
					if ( message == playerNotFoundMsg or message == charOnlineMsg or message == charOfflineMsg) then
						matchFound = true;
						break;
					end
				end

				if (not matchFound) then
					return true;
				end
			end
		end

		if ( type == "SYSTEM" or type == "SKILL" or type == "CURRENCY" or type == "MONEY" or
		     type == "OPENING" or type == "TRADESKILLS" or type == "PET_INFO" or type == "TARGETICONS" or type == "BN_WHISPER_PLAYER_OFFLINE") then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif (type == "LOOT") then
			-- Append [Share] hyperlink if this is a valid social item and you are the looter.
			-- arg5 contains the name of the player who looted
			if (C_Social.IsSocialEnabled() and UnitName("player") == arg5) then
				local itemID, creationContext = GetItemInfoFromHyperlink(arg1);
				if (itemID and C_Social.GetLastItem() == itemID) then
					arg1 = arg1 .. " " .. Social_GetShareItemLink(itemID, creationContext, true);
				end
			end
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,7) == "COMBAT_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,6) == "SPELL_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,10) == "BG_SYSTEM_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,11) == "ACHIEVEMENT" ) then
			-- Append [Share] hyperlink
			if (arg12 == UnitGUID("player") and C_Social.IsSocialEnabled()) then
				local achieveID = GetAchievementInfoFromHyperlink(arg1);
				if (achieveID) then
					arg1 = arg1 .. " " .. Social_GetShareAchievementLink(achieveID, true);
				end
			end
			self:AddMessage(format(arg1, "|Hplayer:"..arg2.."|h".."["..coloredName.."]".."|h"), info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,18) == "GUILD_ACHIEVEMENT" ) then
			local message = format(arg1, "|Hplayer:"..arg2.."|h".."["..coloredName.."]".."|h");
			if (C_Social.IsSocialEnabled()) then
				local achieveID = GetAchievementInfoFromHyperlink(arg1);
				if (achieveID) then
					local isGuildAchievement = select(12, GetAchievementInfo(achieveID));
					if (isGuildAchievement) then
						message = message .. " " .. Social_GetShareAchievementLink(achieveID, true);
					end
				end
			end
			self:AddMessage(message, info.r, info.g, info.b, info.id);
		elseif ( type == "IGNORED" ) then
			self:AddMessage(format(CHAT_IGNORED, arg2), info.r, info.g, info.b, info.id);
		elseif ( type == "FILTERED" ) then
			self:AddMessage(format(CHAT_FILTERED, arg2), info.r, info.g, info.b, info.id);
		elseif ( type == "RESTRICTED" ) then
			self:AddMessage(CHAT_RESTRICTED_TRIAL, info.r, info.g, info.b, info.id);
		elseif ( type == "CHANNEL_LIST") then
			if(channelLength > 0) then
				self:AddMessage(format(_G["CHAT_"..type.."_GET"]..arg1, tonumber(arg8), arg4), info.r, info.g, info.b, info.id);
			else
				self:AddMessage(arg1, info.r, info.g, info.b, info.id);
			end
		elseif (type == "CHANNEL_NOTICE_USER") then
			local globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"];
			if ( not globalstring ) then
				globalstring = _G["CHAT_"..arg1.."_NOTICE"];
			end
			if(strlen(arg5) > 0) then
				-- TWO users in this notice (E.G. x kicked y)
				self:AddMessage(format(globalstring, arg8, arg4, arg2, arg5), info.r, info.g, info.b, info.id);
			elseif ( arg1 == "INVITE" ) then
				self:AddMessage(format(globalstring, arg4, arg2), info.r, info.g, info.b, info.id);
			else
				self:AddMessage(format(globalstring, arg8, arg4, arg2), info.r, info.g, info.b, info.id);
			end
			if ( arg1 == "INVITE" and GetCVarBool("blockChannelInvites") ) then
				self:AddMessage(CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE, info.r, info.g, info.b, info.id);
			end
		elseif (type == "CHANNEL_NOTICE") then
			local globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"];
			if( arg1 == "TRIAL_RESTRICTED" ) then
				globalstring = CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL;
			else
				if ( not globalstring ) then
					globalstring = _G["CHAT_"..arg1.."_NOTICE"];
				end
			end
			local accessID = ChatHistory_GetAccessID(Chat_GetChatCategory(type), arg8);
			local typeID = ChatHistory_GetAccessID(infoType, arg8, arg12);
			self:AddMessage(format(globalstring, arg8, arg4), info.r, info.g, info.b, info.id, accessID, typeID);
		elseif ( type == "BN_INLINE_TOAST_ALERT" ) then
			local globalstring = _G["BN_INLINE_TOAST_"..arg1];
			local message;
			if ( arg1 == "FRIEND_REQUEST" ) then
				message = globalstring;
			elseif ( arg1 == "FRIEND_PENDING" ) then
				message = format(BN_INLINE_TOAST_FRIEND_PENDING, BNGetNumFriendInvites());
			elseif ( arg1 == "FRIEND_REMOVED" or arg1 == "BATTLETAG_FRIEND_REMOVED" ) then
				message = format(globalstring, arg2);
			elseif ( arg1 == "FRIEND_ONLINE" or arg1 == "FRIEND_OFFLINE") then
				local _, accountName, battleTag, _, characterName, _, client = BNGetFriendInfoByID(arg13);
				if (client and client ~= "") then
					local _, _, battleTag = BNGetFriendInfoByID(arg13);
					characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client) or "";
					local characterNameText = BNet_GetClientEmbeddedTexture(client, 14)..characterName;
					local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s] (%s)|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2, characterNameText);
					message = format(globalstring, playerLink);
				else
					local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2);
					message = format(globalstring, playerLink);
				end
			else
				local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2);
				message = format(globalstring, playerLink);
			end
			self:AddMessage(message, info.r, info.g, info.b, info.id);
		elseif ( type == "BN_INLINE_TOAST_BROADCAST" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveExtraSpaces(arg1);
				arg1 = RemoveNewlines(arg1);
				local playerLink = format("|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h", arg2, arg13, arg11, Chat_GetChatCategory(type), 0, arg2);
				self:AddMessage(format(BN_INLINE_TOAST_BROADCAST, playerLink, arg1), info.r, info.g, info.b, info.id);
			end
		elseif ( type == "BN_INLINE_TOAST_BROADCAST_INFORM" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveExtraSpaces(arg1);
				self:AddMessage(BN_INLINE_TOAST_BROADCAST_INFORM, info.r, info.g, info.b, info.id);
			end
		else
			local body;

			local _, fontHeight = FCF_GetChatWindowInfo(self:GetID());

			if ( fontHeight == 0 ) then
				--fontHeight will be 0 if it's still at the default (14)
				fontHeight = 14;
			end

			-- Add AFK/DND flags
			local pflag;
			if(strlen(arg6) > 0) then
				if ( arg6 == "GM" ) then
					--If it was a whisper, dispatch it to the GMChat addon.
					if ( type == "WHISPER" ) then
						return;
					end
					--Add Blizzard Icon, this was sent by a GM
					pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
				elseif ( arg6 == "DEV" ) then
					--Add Blizzard Icon, this was sent by a Dev
					pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
				else
					pflag = _G["CHAT_FLAG_"..arg6];
				end
			else
				pflag = "";
			end
			if ( type == "WHISPER_INFORM" and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2) ) then
				return;
			end

			local showLink = 1;
			if ( strsub(type, 1, 7) == "MONSTER" or strsub(type, 1, 9) == "RAID_BOSS") then
				showLink = nil;
			else
				arg1 = gsub(arg1, "%%", "%%%%");
			end

			-- Search for icon links and replace them with texture links.
			for tag in string.gmatch(arg1, "%b{}") do
				local term = strlower(string.gsub(tag, "[{}]", ""));
				-- If arg17 is true, don't convert to raid icons
				if ( not arg17 and ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
					arg1 = string.gsub(arg1, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
				elseif ( GROUP_TAG_LIST[term] ) then
					local groupIndex = GROUP_TAG_LIST[term];
					local groupList = "[";
					for i=1, GetNumGroupMembers() do
						local name, rank, subgroup, level, class, classFileName = GetRaidRosterInfo(i);
						if ( name and subgroup == groupIndex ) then
							local classColorTable = RAID_CLASS_COLORS[classFileName];
							if ( classColorTable ) then
								name = string.format("\124cff%.2x%.2x%.2x%s\124r", classColorTable.r*255, classColorTable.g*255, classColorTable.b*255, name);
							end
							groupList = groupList..(groupList == "[" and "" or PLAYER_LIST_DELIMITER)..name;
						end
					end
					groupList = groupList.."]";
					arg1 = string.gsub(arg1, tag, groupList);
				end
			end

			--Remove groups of many spaces
			arg1 = RemoveExtraSpaces(arg1);

			local playerLink;

			if ( type ~= "BN_WHISPER" and type ~= "BN_WHISPER_INFORM" ) then
				playerLink = "|Hplayer:"..arg2..":"..arg11..":"..chatGroup..(chatTarget and ":"..chatTarget or "").."|h";
			else
				playerLink = "|HBNplayer:"..arg2..":"..arg13..":"..arg11..":"..chatGroup..(chatTarget and ":"..chatTarget or "").."|h";
			end

			local message = arg1;
			if ( arg14 ) then	--isMobile
				message = ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b)..message;
			end

			local relevantDefaultLanguage = self.defaultLanguage;
			if ( (type == "SAY") or (type == "YELL") ) then
				relevantDefaultLanguage = self.alternativeDefaultLanguage;
			end
			if ( (strlen(arg3) > 0) and (arg3 ~= relevantDefaultLanguage) ) then
				local languageHeader = "["..arg3.."] ";
				if ( showLink and (strlen(arg2) > 0) ) then
					body = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..playerLink.."["..coloredName.."]".."|h");
				else
					body = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..arg2);
				end
			else
				if ( not showLink or strlen(arg2) == 0 ) then
					if ( type == "TEXT_EMOTE" ) then
						body = message;
					else
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..arg2, arg2);
					end
				else
					if ( type == "EMOTE" ) then
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink..coloredName.."|h");
					elseif ( type == "TEXT_EMOTE") then
						body = string.gsub(message, arg2, pflag..playerLink..coloredName.."|h", 1);
					elseif (type == "GUILD_ITEM_LOOTED") then
						body = string.gsub(message, "$s", "|Hplayer:"..arg2.."|h".."["..coloredName.."]".."|h");
					else
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink.."["..coloredName.."]".."|h");
					end
				end
			end

			-- Add Channel
			arg4 = gsub(arg4, "%s%-%s.*", "");
			if(channelLength > 0) then
				body = "|Hchannel:channel:"..arg8.."|h["..arg4.."]|h "..body;
			end

			--Add Timestamps
			if ( CHAT_TIMESTAMP_FORMAT ) then
				body = BetterDate(CHAT_TIMESTAMP_FORMAT, time())..body;
			end

			local accessID = ChatHistory_GetAccessID(chatGroup, chatTarget);
			local typeID = ChatHistory_GetAccessID(infoType, chatTarget, arg12 or arg13);
			self:AddMessage(body, info.r, info.g, info.b, info.id, accessID, typeID);
		end

		if ( type == "WHISPER" or type == "BN_WHISPER" ) then
			--BN_WHISPER FIXME
			ChatEdit_SetLastTellTarget(arg2, type);
			if ( self.tellTimer and (GetTime() > self.tellTimer) ) then
				--PlaySound("TellMessage");
			end
			self.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME;
			--FCF_FlashTab(self);
			--FlashClientIcon();
		end

		if ( not self:IsShown() ) then
			if ( (self == DEFAULT_CHAT_FRAME and info.flashTabOnGeneral) or (self ~= DEFAULT_CHAT_FRAME and info.flashTab) ) then
				if ( not CHAT_OPTIONS.HIDE_FRAME_ALERTS or type == "WHISPER" or type == "BN_WHISPER" ) then	--BN_WHISPER FIXME
					if (not FCFManager_ShouldSuppressMessageFlash(self, chatGroup, chatTarget) ) then
						FCF_StartAlertFlash(self);
					end
				end
			end
		end

		return true;
	end
end

