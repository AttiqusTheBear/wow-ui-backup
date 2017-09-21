
----------------------------------
-- module independent variables --
----------------------------------
local addon, ns = ...
local C, L, I = ns.LC.color, ns.L, ns.I


-----------------------------------------------------------
-- module own local variables and local cached functions --
-----------------------------------------------------------
local name = "Friends"; -- L["Friends"]
local ttName,ttName2,ttColumns,tt,tt2,createMenu=name.."TT",name.."TT2",8;
local unknownGameError = false;
local DSw, DSh =  0,  0;
local ULx, ULy =  0,  0;
local LLx, LLy = 32, 32;
local URx, URy =  5, 27;
local LRx, LRy =  5, 27;
local off, on = strtrim(gsub(ERR_FRIEND_OFFLINE_S,"%%s","")), strtrim(gsub(ERR_FRIEND_ONLINE_SS,"\124Hplayer:%%s\124h%[%%s%]\124h",""));
local gameIconPos = setmetatable({},{ __index = function(t,k) return format("%s:%s:%s:%s:%s:%s:%s:%s:%s:%s",DSw,DSh,ULx,ULy,LLx,LLy,URx,URy,LRx,LRy) end})
local _BNet_GetClientTexture = BNet_GetClientTexture
local gameShortcut = setmetatable({},{ __index = function(t, k) return k end });
gameShortcut[BNET_CLIENT_WTCG] = "HS";
gameShortcut[BNET_CLIENT_SC2] = "Sc2";
gameShortcut[BNET_CLIENT_OVERWATCH] = "Ow";
gameShortcut[BNET_CLIENT_HEROES] = "HotS";
local gameNames = {
	[BNET_CLIENT_WTCG]="Hearthstone",
	[BNET_CLIENT_WOW]="World of Warcraft",
	[BNET_CLIENT_D3]="Diablo 3",
	[BNET_CLIENT_HEROES]="Heroes of the Storme",
	[BNET_CLIENT_OVERWATCH]="Overwatch",
	[BNET_CLIENT_SC2]="Starcraft 2",
	--[BNET_CLIENT_CLNT]=""
	[BNET_CLIENT_APP]="Battle.net-Client"
}


-------------------------------------------
-- register icon names and default files --
-------------------------------------------
I[name] = {iconfile="Interface\\Addons\\"..addon.."\\media\\friends"}; --IconName::Friends--


---------------------------------------
-- module variables for registration --
---------------------------------------
ns.modules[name] = {
	desc = L["Broker to show you which friends are online on realm and BattleNet"],
	events = {
		"BATTLETAG_INVITE_SHOW", -- ?
		"BN_BLOCK_LIST_UPDATED",
		"BN_CONNECTED",
		"BN_CUSTOM_MESSAGE_CHANGED",
		"BN_CUSTOM_MESSAGE_LOADED",
		"BN_DISCONNECTED",
		"BN_FRIEND_ACCOUNT_OFFLINE",
		"BN_FRIEND_ACCOUNT_ONLINE",
		"BN_FRIEND_INFO_CHANGED",
		"BN_FRIEND_INVITE_ADDED",
		"BN_FRIEND_INVITE_REMOVED",
		"BN_INFO_CHANGED",
		"BN_SELF_ONLINE", -- same as BN_CONNECTED ?
		"FRIENDLIST_UPDATE",
		"PLAYER_ENTERING_WORLD",
		"PLAYER_LOGIN",
		"CHAT_MSG_SYSTEM"
	},
	updateinterval = nil, -- 10
	config_defaults = {
		-- broker button
		splitFriendsBroker = true,
		showFriendsBroker = true,
		showBNFriendsBroker = true,

		-- tooltip 1
		showFriends = true,
		showStatus = "1",
		showBNFriends = true,
		showBattleTags = "3",
		showRealm = "1",
		showGame = "1",
		showFaction = "2",
		showZone = true,
		showNotes = true,

		-- tooltip 2
		showBroadcastTT2 = true,
		showBattleTagTT2 = false,
		showRealIDTT2 = false,
		showFactionTT2 = false,
		showZoneTT2 = false,
		showGameTT2 = false,
		showNotesTT2 = false
	},
	config_allowed = nil,
	config_header = nil, -- use default header
	config_broker = {
		{ type="toggle", name="splitFriendsBroker",  label=L["Split friends on Broker"], tooltip=L["Split Characters and BattleNet-Friends on Broker Button"], event=true },
		{ type="toggle", name="showFriendsBroker",   label=L["Show friends"], tooltip=L["Display count of friends if 'Split friends on Broker' enabled otherwise add friends to summary count."], event=true },
		{ type="toggle", name="showBNFriendsBroker", label=L["Show BattleNet friends"], tooltip=L["Display count of BattleNet friends on Broker if 'Split friends on Broker' enabled otherwise add BattleNet friends to summary count."], event=true },
		{ type="toggle", name="showTotalCount",      label=L["Show total count"], tooltip=L["Display total count of friens and/or BattleNet friends on broker button"], event=true },
	},
	config_tooltip = {
		{ type="toggle", name="showFriends",    label=L["Show friends"],           tooltip=L["Display friends in tooltip"] },
		{ type="toggle", name="showBNFriends",  label=L["Show BattleNet friends"], tooltip=L["Display BattleNet friends in tooltip"] },
		{ type="select", name="showBattleTags", label=L["Show BattleTag/RealID"],  tooltip=L["Display BattleTag and/or RealID in tooltip"],
			values={
				["0"] = NONE.." / "..ADDON_DISABLED,
				["1"] = "RealID or BattleName",
				["2"] = "RealID or BattleName (BattleTag)",
				["3"] = "BattleTag",
			},
			default="3"
		},
		{ type="select", name="showRealm",      label=L["Show realm"], tooltip=L["Display realm name in tooltip (WoW only)"],
			values={
				["0"] = NONE.." / "..ADDON_DISABLED,
				["1"] = L["Realm name in own column"],
				["2"] = L["Realm name in character name column"],
				["3"] = L["* (Asterisk) behind character name if on foreign realm"]
			},
			default="1"
		},
		{ type="select", name="showGame",       label=L["Show game"], tooltip=L["Display game icon or game shortcut in tooltip"],
			values={
				["0"]=NONE.." / "..ADDON_DISABLED,
				["1"]=L["Game icon"],
				["2"]=L["Game shortcut"]
			},
			default="1"
		},
		{ type="select", name="showFaction",    label=L["Show faction"], tooltip=L["Display faction in tooltip (WoW only)"],
			values={
				["0"]=NONE.." / "..ADDON_DISABLED,
				["1"]=L["Icon behind character name"],
				["2"]=L["Faction name in own column"],
				["3"]=L["Faction icon in own column"]
			},
			default="2"
		},
		{ type="select", name="showStatus",    label=L["Show status"], tooltip=L["Display status like AFK in tooltip"],
			values={
				["0"]=NONE.." / "..ADDON_DISABLED,
				["1"]=L["Status icon"],
				["2"]=L["Status text"],
			},
			default="1"
		},
		{ type="toggle", name="showZone",       label=L["Show zone"], tooltip=L["Display zone in tooltip"] },
		{ type="toggle", name="showNotes",      label=L["Show notes"], tooltip=L["Display notes in tooltip"] },

		{ type="separator", alpha=0 },
		{ type="header", label=L["Second tooltip options"] },
		{ type="separator", inMenuInvisible=true },
		{ type="desc",   text=L["The secondary tooltip will be displayed by moving the mouse over a friend in main tooltip. The tooltip will be displayed if one of the following options activated."]},
		{ type="toggle", name="showBroadcastTT2", label=L["Show broadcast message"], tooltip=L["Display broadcast message in tooltip (BattleNet friend only)"] },
		{ type="toggle", name="showBattleTagTT2", label=L["Show BattleTag"], tooltip=L["Display BattleTag in tooltip (BattleNet friend only)"] },
		{ type="toggle", name="showRealIDTT2",    label=L["Show RealID"], tooltip=L["Display RealID in tooltip if available (BattleNet friend only)"] },
		{ type="toggle", name="showFactionTT2",   label=L["Show faction"], tooltip=L["Display faction in tooltip if available"] },
		{ type="toggle", name="showZoneTT2",      label=L["Show zone"], tooltip=L["Display zone in second tooltip"] },
		{ type="toggle", name="showGameTT2",      label=L["Show game"], tooltip=L["Display game in second tooltip"] },
		{ type="toggle", name="showNotesTT2",     label=L["Show notes"], tooltip=L["Display notes in second tooltip"] },
	},
	config_misc = nil,
	clickOptions = {
		["1_open_character_info"] = {
			cfg_label = "Open friends roster", -- L["Open friends roster"]
			cfg_desc = "open the friends roster", -- L["open the friends roster"]
			cfg_default = "_LEFT",
			hint = "Open friends roster",
			func = function(self,button)
				local _mod=name;
				securecall("ToggleFriendsFrame",1);
			end
		},
		["2_open_menu"] = {
			cfg_label = "Open option menu",
			cfg_desc = "open the option menu",
			cfg_default = "_RIGHT",
			hint = "Open option menu",
			func = function(self,button)
				local _mod=name;
				createMenu(self)
			end
		}
	}
}


--------------------------
-- some local functions --
--------------------------
function createMenu(self)
	if (tt~=nil) then ns.hideTooltip(tt); end
	ns.EasyMenu.InitializeMenu();
	ns.EasyMenu.addConfigElements(name);
	ns.EasyMenu.ShowMenu(self);
end

local function BNet_GetClientTexture(game,tt2)
	if ns.profile[name].showGame=="2" and not tt2 then
		return gameShortcut[game]
	else
		local icon = _BNet_GetClientTexture(game)
		return format("|T%s:%s|t",icon,gameIconPos[game])
	end
	return "";
end

local _status = function(afk,dnd)
	if ns.profile[name].showStatus=="1" then
		return ("|T%s:0|t"):format(_G["FRIENDS_TEXTURE_"  .. ((afk==true and "AFK") or (dnd==true and "DND") or "ONLINE")]);
	elseif ns.profile[name].showStatus=="2" then
		return (afk==true and C("gold","[AFK]")) or (dnd==true and C("ltred","[DND]")) or "";
	end
	return "";
end

local function broadcastTooltip(self)
	local broadcastText,broadcastTime = 13,14; -- BNGetFriendToonInfo
	if (self~=false) then
		local blue = C("ltblue","colortable");

		GameTooltip:SetOwner(self,"ANCHOR_NONE");
		if (select(1,self:GetCenter()) > (select(1,UIParent:GetWidth()) / 2)) then
			GameTooltip:SetPoint("RIGHT",tt,"LEFT",-2,0);
		else
			GameTooltip:SetPoint("LEFT",tt,"RIGHT",2,0);
		end
		GameTooltip:SetPoint("TOP",self,"TOP", 0, 4);

		GameTooltip:ClearLines();
		GameTooltip:AddLine(self.name,blue[1],blue[2],blue[3]);
		GameTooltip:AddLine(date("%Y-%m-%d %H:%M:%S",self.toonInfo[broadcastTime]),.7,.7,.7);
		GameTooltip:AddLine(SecondsToTime(time()-self.toonInfo[broadcastTime]),.7,.7,.7);
		GameTooltip:AddLine(self.toonInfo[broadcastText],1,1,1,true);
		GameTooltip:Show();
	else
		GameTooltip:Hide();
	end
end

local function createTooltip2(self,data)
	if not (ns.profile[name].showBroadcastTT2 or ns.profile[name].showBattleTagTT2 or ns.profile[name].showRealIDTT2 or ns.profile[name].showZoneTT2 or ns.profile[name].showGameTT2 or ns.profile[name].showNotesTT2) then return end
	local color1 = "ltblue";
	tt2 = ns.acquireTooltip(
		{ttName2, 3, "LEFT","RIGHT","RIGHT"},
		{true,true},
		{self, "horizontal", tt}
	);
	if tt2.lines~=nil then tt2:Clear(); end
	local l=tt2:AddHeader(C("dkyellow",NAME));
	tt2:SetCell(l,2,C(data.class or color1,ns.scm(data.name)),nil,nil,0);
	tt2:AddSeparator();
	-- game
	if ns.profile[name].showGameTT2 then
		tt2:SetCell(tt2:AddLine(C(color1,data.client=="App" and L["Program"] or GAME)),2,gameNames[data.client] .." ".. BNet_GetClientTexture(data.client,true),nil,"RIGHT",0);
	end
	if data.client==BNET_CLIENT_WOW then
		-- realm
		if (data.realm) then
			tt2:SetCell(tt2:AddLine(C(color1,L["Realm"])),2,data.realm,nil,"RIGHT",0);
		end
		-- faction
		if ns.profile[name].showFactionTT2 then
			tt2:SetCell(tt2:AddLine(C(color1,FACTION)),2, data.factionL .. " |TInterface\\PVPFrame\\PVP-Currency-".. data.factionT ..":14:14:0:-1:32:32:3:29:3:29|t", nil,"RIGHT",0);
		end
	end
	-- zone
	if ns.profile[name].showZoneTT2 and data.zone then
		tt2:SetCell(tt2:AddLine(C(color1,ZONE)),2,data.zone,nil,"RIGHT",0);
	end
	-- notes
	if ns.profile[name].showNotesTT2 and data.note:len()>0 then
		tt2:AddSeparator(4,0,0,0,0);
		tt2:SetCell(tt2:AddLine(),1,C(color1,L["Note"]),nil,nil,0);
		tt2:AddSeparator();
		tt2:SetCell(tt2:AddLine(),1,ns.scm(data.note,true),nil,"LEFT",0);
	end
	-- broadcast
	if ns.profile[name].showBroadcastTT2 and data.broadcast:len()>0 then
		tt2:AddSeparator(4,0,0,0,0);
		tt2:SetCell(tt2:AddLine(),1,C(color1,BATTLENET_BROADCAST),nil,nil,0);
		tt2:AddSeparator();
		if not ns.profile.GeneralOptions.scm then
			broadcast=ns.strWrap(broadcast,48);
		end
		tt2:SetCell(tt2:AddLine(),1,data.broadcast,nil,"LEFT",0);
		if data.broadcastTime then
			tt2:SetCell(tt2:AddLine(),1,C("ltgray","("..L["Active since"]..": "..SecondsToTime(time()-data.broadcastTime)..")"),nil,"RIGHT",0);
		end
	end

	ns.roundupTooltip(tt2);
end

local function tooltipLineScript_OnMouseUp(self,data,button)
	if data.type=="realm" then
		-- whisper toon to toon
		if IsAltKeyDown() then
			InviteUnit(data.name_realm);
		else
			ChatFrame_SendTell(data.name_realm);
		end
	elseif data.type=="battlenet" then
		-- battlenet whisper
		if IsAltKeyDown() then
			if self.client=="WoW" then
				BNInviteFriend(data.toonID);
			end
		else
			local name = data.account; -- account name
			if button=="RightButton" then
				name = data.name; -- toon name
				if ns.realm~=data.realm then
					name = name .."-".. ns.stripRealm(data.realm);
				end
			end
			securecall("ChatFrame_SendSmartTell",name);
		end
	end
end

local function createTooltip(tt)
	if (tt) and (tt.key) and (tt.key~=ttName) then return end -- don't override other LibQTip tooltips...

	local columns,split,l,c=8,ns.profile[name].splitFriendsTT;
	local numFriends, friendsOnline = GetNumFriends();
	local numBNFriends, numOnlineBNFriends = BNGetNumFriends();
	if tt.lines~=nil then tt:Clear(); end
	tt:SetCell(tt:AddLine(),1,C("dkyellow",L[name]),tt:GetHeaderFont(),"LEFT",0);

	local _, _, _, broadcastText = BNGetInfo();
	if broadcastText~=nil and broadcastText~="" then
		tt:AddSeparator(4,0,0,0,0);
		tt:SetCell(tt:AddLine(),1,C("dkyellow",L["My current broadcast message"]),nil,nil,columns);
		tt:AddSeparator();
		tt:SetCell(tt:AddLine(),1,C("white",ns.scm(broadcastText,true)),nil,nil,columns);
	end

	local bnetIDAccount, accountName, battleTag, isBattleTag, characterName, bnetIDGameAccount, _client, isBnetOnline, lastBnetOnline, isBnetAFK, isBnetDND, messageText, BnetNoteText, isRIDFriend, messageTime, canSoR = 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16; -- BNGetFriendInfo
	local accountName,battleTag,isBattleTagPresence,isOnline,isAFK,isDND,noteText = 2,3,4,8,10,11,13; -- BNGetFriendInfo
	local toonName,client,realmName,_,faction,_,class,_,zoneName,level,gameText,broadcastText,broadcastTime,_,toonID = 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16; -- BNGetFriendGameAccountInfo
	local fi,nt,ti;
	local visible = {};

	tt:AddSeparator(4,0,0,0,0);
	tt:AddLine(
		(ns.profile[name].showBattleTags=="0" and "") or (split==true and C("ltblue",  BATTLENET_OPTIONS_LABEL)) or C("ltyellow",L["Real ID"].."/"..BATTLETAG), -- 1
		C("ltyellow",LEVEL),		-- 2
		C("ltyellow",CHARACTER),	-- 3
		ns.profile[name].showGame~="0"    and C("ltyellow",GAME)       or "", -- 4
		ns.profile[name].showZone         and C("ltyellow",ZONE)       or "", -- 5
		ns.profile[name].showRealm=="1"   and C("ltyellow",L["Realm"]) or "", -- 6
		ns.profile[name].showFaction=="2" and C("ltyellow",FACTION)    or "", -- 7
		ns.profile[name].showNotes        and C("ltyellow",L["Notes"]) or ""  -- 8
	);
	tt:AddSeparator();

	if ns.profile[name].showBNFriends then
		tt:SetCell(tt:AddLine(),1,C("ltgray",L["BattleNet friends"]),nil,"LEFT",0);
		if not BNConnected() then
			tt:SetCell(tt:AddLine(),1,"    "..C("ltred",BATTLENET_UNAVAILABLE),nil,"LEFT",0);
		elseif numOnlineBNFriends==0 then
			tt:SetCell(tt:AddLine(),1,"    "..C("gray",L["Currently no battle.net friends online..."]),nil,"LEFT",0);
		else
			-- RealId	Status Character	Level	Zone	Game	Realm	Notes
			for i=1, numBNFriends do
				local nt,fi = BNGetNumFriendGameAccounts(i),{BNGetFriendInfo(i)};
				if fi[isOnline] then
					for I=1, nt do
						local ti = {BNGetFriendGameAccountInfo(i, I)};
						local bcIcon = ti[broadcastText]~="" and "|Tinterface\\chatframe\\ui-chatinput-focusicon:0|t" or "";
						if visible[fi[accountName]..ti[client]..ti[zoneName]] then
							-- filter duplicates...
						elseif (nt>1 and ti[client]~="App") or nt==1 then
							local isBNColor=false;
							visible[fi[accountName]..ti[client]..ti[zoneName]] = true;
							if ti[toonName]=="" or ti[client]=="Hero" then
								if fi[isBattleTag] then
									ti[toonName] = fi[accountName];
								else
									ti[toonName] = strsplit("#",fi[battleTag]);
								end
								isBNColor=true;
							end
							local l = tt:AddLine();
							-- battle tags / realids
							if ns.profile[name].showBattleTags~="0" then
								local a,b = strsplit("#",fi[battleTag]);
								local BattleTag = C("ltblue",ns.scm(a))..C("ltgray","#"..ns.scm(b));
								local bnName=C("ltblue",ns.scm(fi[accountName]));
								-- 0 Disabled
								-- 1 Name
								-- 2 Name (BattleTag)
								-- 3 BattleTag
								if ns.profile[name].showBattleTags=="2" then
									bnName = bnName .. C("white"," (")..BattleTag..C("white",")");
								elseif ns.profile[name].showBattleTags=="3" then
									bnName = BattleTag;
								end
								tt:SetCell(l,1,"    "..bnName..bcIcon); -- 1
							end
							-- level
							tt:SetCell(l,2,C("white",ti[level]));		-- 2
							-- toon name
							local nameStr = _status(fi[isAFK],fi[isDND])..C(isBNColor and "ltblue" or ti[class],ns.scm(ti[toonName]));
							if tonumber(ns.profile[name].showRealm)>1 and ti[realmName]~=ns.realm_short and ti[client]~="App" then
								if ns.profile[name].showRealm=="2" then
									nameStr = nameStr..C("dkyellow","-"..ns.scm(ti[realmName]));
								else
									nameStr = nameStr..C("dkyellow","*");
								end
							end
							if ns.profile[name].showFaction=="1" and ti[client]=="WoW" and ti[faction] then
								nameStr = nameStr.."|TInterface\\PVPFrame\\PVP-Currency-"..ti[faction]..":16:16:0:-1:32:32:2:30:2:30|t";
							end
							if ns.profile[name].showBattleTags=="0" and ti[client]~="App" then
								nameStr = nameStr.." "..bcIcon;
							end
							tt:SetCell(l,3,nameStr); -- 3
							-- game icon or text
							if ns.profile[name].showGame~="0" then
								tt:SetCell(l,4,C("white", BNet_GetClientTexture(ti[client]) ));	-- 4
							end
							if ti[client]=="WoW" then
								-- zone
								if ns.profile[name].showZone then
									if ti[zoneName] and ti[zoneName]:match("^"..GARRISON_LOCATION_TOOLTIP) and ti[zoneName]~=GARRISON_LOCATION_TOOLTIP then
										ti[zoneName] = GARRISON_LOCATION_TOOLTIP;
									end
									tt:SetCell(l,5,C("white",ti[zoneName]~="" and ti[zoneName] or ti[gameText]));			-- 5
								end
								-- realm (own column)
								if ns.profile[name].showRealm=="1" then
									local realm,_ = ti[realmName];
									if type(realm)=="string" and realm:len()>0 then
										_,realm = ns.LRI:GetRealmInfo(realm);
									end
									tt:SetCell(l,6,C("white",realm));			-- 6
								end
								-- faction (own column)
								if ns.profile[name].showFaction=="2" then
									tt:SetCell(l,7,C("white",_G["FACTION_"..ti[faction]:upper()] or ti[faction]));		-- 7
								elseif ns.profile[name].showFaction=="3" then
									tt:SetCell(l,7,"|TInterface\\PVPFrame\\PVP-Currency-"..ti[faction]..":16:16:0:-1:32:32:2:30:2:30|t");
								end
							elseif ns.profile[name].showZone then
								-- zone or current screen
								tt:SetCell(l,5,C("white",C("white",ti[zoneName]~="" and ti[zoneName] or ti[gameText])),nil,nil,3); -- 5 6 7
							end
							-- notes
							if ns.profile[name].showNotes and fi[noteText] then
								tt:SetCell(l,8,C("white",C("white",ns.scm(fi[noteText],true)))); -- 8
							end

							local data = {
								type = "battlenet",
								toonID = ti[16],
								account = fi[2],
								class = ti[8] or false,
								name = ti[2],
								client = ti[3],
								realm = ti[4],
								factionT = ti[6]:upper(),
								factionL = _G["FACTION_"..ti[6]:upper()],
								zone = ti[3]~="App" and (ti[10] or ti[12]) or false,
								note = (fi[13] or ""):trim(),
								broadcast = (fi[12] or ""):trim(),
								broadcastTime = fi[15] or false,
							};

							tt:SetLineScript(l, "OnMouseUp", tooltipLineScript_OnMouseUp, data);
							tt:SetLineScript(l, "OnEnter", createTooltip2, data);
						end
					end
				end
			end
		end
	end

	if ns.profile[name].showFriends then
		tt:SetCell(tt:AddLine(),1,C("ltgray",L["Friends"]),nil,"LEFT",0);
		if friendsOnline==0 then
			tt:SetCell(tt:AddLine(),1,"    "..C("gray",L["Currently no friends online..."]),nil,"LEFT",0);
		else
			local charName,level,class,area,connected,status,note,cName,cRealm,cGame=1,2,3,4,5,6,7,18,19,20; -- GetFriendInfo
			local l,c,s,n,_;
			for i=1, numFriends do
				local v = {GetFriendInfo(i)};
				if v[charName]:find("-") then
					v[cName], v[cRealm] = strsplit("-",v[charName]);
				else
					v[cName], v[cRealm] = v[charName],ns.realm;
				end
				v[cGame] = BNET_CLIENT_WOW;
				if visible[v[cName]..v[cRealm]..v[area]] then
					-- filter duplicates...
				elseif (v[charName]) and (v[connected]) then
					visible[v[cName]..v[cRealm]..v[area]] = true;

					local l = tt:AddLine("","","","","","","","");
					tt:SetCell(l,2,C("white",v[level]));

					local nameStr = _status((status=="AFK"),(status=="DND")) .. C(v[class]:upper(),ns.scm(v[cName]));
					if tonumber(ns.profile[name].showRealm)>1 and cRealm~=ns.realm then
						if ns.profile[name].showRealm=="2" then
							local realm,_ = v[cRealm];
							if type(realm)=="string" and realm:len()>0 then
								_,realm = ns.LRI:GetRealmInfo(realm);
							end
							nameStr = nameStr..C("dkyellow","-"..ns.scm(realm));
						else
							nameStr = nameStr..C("dkyellow","*");
						end
					end
					if ns.profile[name].showFaction=="1" then
						nameStr = nameStr.."|TInterface\\PVPFrame\\PVP-Currency-"..ns.player.faction..":16:16:0:-1:32:32:2:30:2:30|t";
					end
					tt:SetCell(l,3,nameStr);

					-- game icon or text
					if ns.profile[name].showGame~="0" then
						tt:SetCell(l,4,C("white",BNet_GetClientTexture(v[cGame])));
					end
					-- zone
					if ns.profile[name].showZone then
						if v[area]:match("^"..GARRISON_LOCATION_TOOLTIP) and v[area]~=GARRISON_LOCATION_TOOLTIP then
							v[area] = GARRISON_LOCATION_TOOLTIP;
						end
						tt:SetCell(l,5,C("white",v[area]));
					end
					-- realm
					if ns.profile[name].showRealm=="1" then
						local realm = v[cRealm];
						if type(realm)=="string" and realm:len()>0 then
							_,realm = ns.LRI:GetRealmInfo(realm);
						end
						tt:SetCell(l,6,C("white",realm));
					end
					-- faction
					if ns.profile[name].showFaction=="2" then
						tt:SetCell(l,7,C("white",ns.player.factionL or ns.player.faction));
					elseif ns.profile[name].showFaction=="3" then
						tt:SetCell(l,7,"|TInterface\\PVPFrame\\PVP-Currency-"..ns.player.faction..":16:16:0:-1:32:32:2:30:2:30|t");
					end
					-- notes
					if ns.profile[name].showNotes then
						tt:SetCell(l,8,C("white",ns.scm(v[note] or "")));
					end

					--local data = {type="realm",info=v};
					local data = {
						type = "realm",
						name_realm = v[1],
						class = v[3],
						name = v[18],
						client = BNET_CLIENT_WOW,
						realm = v[19],
						factionT = ns.player.faction:upper(),
						factionL = ns.player.factionL,
						zone = v[4],
						note = (v[7] or ""):trim(),
						-- broadcast = nil,
						-- broadcastTime = nil,
					};

					tt:SetLineScript(l, "OnMouseUp", tooltipLineScript_OnMouseUp, data);
					tt:SetLineScript(l, "OnEnter", createTooltip2, data);
				end
			end
		end
	end

	if not ns.profile[name].showBNFriends and not ns.profile[name].showFriends then
		tt:AddLine(C("ltgray",L["No friends to diplay. You have both disabled for tooltip"]));
	end

	if (ns.profile.GeneralOptions.showHints) then
		tt:AddSeparator(3,0,0,0,0);
		tt:SetCell(tt:AddLine(),1,C("ltblue",L["Click"]).." || "..C("green",L["Whisper with a friend"]) .." - ".. C("ltblue",L["Alt+Click"]).." || "..C("green",L["Invite a friend"]),nil,nil,columns);
		ns.clickOptions.ttAddHints(tt,name,nil,2);
	end

	ns.roundupTooltip(tt);
end


------------------------------------
-- module (BE internal) functions --
------------------------------------
-- ns.modules[name].init = function() end

ns.modules[name].onevent = function(self,event,msg)
	if event=="PLAYER_LOGIN" then
		if ns.profile[name].disableGameIcons~=nil then
			ns.profile[name].showGame = ns.profile[name].disableGameIcons and "text" or "icon";
			ns.profile[name].disableGameIcons = nil;
		end
		if type(ns.profile[name].showBattleTags)=="boolean" then
			ns.profile[name].showBattleTags = ns.profile[name].showBattleTags and "3" or "0";
		end
		if ns.profile[name].splitFriendsBroker==nil then
			ns.profile[name].splitFriendsBroker = ns.profile[name].splitFriends;
			ns.profile[name].splitFriends = nil;
			ns.profile[name].splitFriendsTT = nil;
		end
		return;
	elseif (event=="BE_UPDATE_CLICKOPTIONS") then
		ns.clickOptions.update(ns.modules[name],ns.profile[name]);
		return;
	end
	local dataobj = self.obj or ns.LDB:GetDataObjectByName(ns.modules[name].ldbName);
	local numBNFriends, numOnlineBNFriends = 0,0;
	if BNConnected() then
		numBNFriends, numOnlineBNFriends = BNGetNumFriends();
	end
	local numFriends, friendsOnline = GetNumFriends();
	local broadcastText = select(4,BNGetInfo());


	if ns.profile[name].splitFriendsBroker then
		local friends = friendsOnline;
		local bnfriends = numOnlineBNFriends;
		if ns.profile[name].showTotalCount then
			friends = friends.."/"..numFriends;
			bnfriends = bnfriends.."/"..numBNFriends;
		end
		dataobj.text = friends .." ".. C(BNConnected() and "ltblue" or "red",bnfriends);
	else
		local txt = numOnlineBNFriends + friendsOnline;
		if ns.profile[name].showTotalCount then
			txt = txt .."/".. (numBNFriends + numFriends);
		end
		dataobj.text = txt .. (BNConnected()==false and "("..C("red","BNet Off")..")" or "");
	end

	if (broadcastText) and (strlen(broadcastText)>0) then
		dataobj.text=dataobj.text.." |Tinterface\\chatframe\\ui-chatinput-focusicon:0|t";
	end

	if (tt) and (tt.key) and (tt.key==ttName) and (tt:IsShown()) then
		createTooltip(tt);
	end
end

-- ns.modules[name].optionspanel = function(panel) end
-- ns.modules[name].onmousewheel = function(self,direction) end
-- ns.modules[name].ontooltip = function(tt) end


-------------------------------------------
-- module functions for LDB registration --
-------------------------------------------
ns.modules[name].onenter = function(self)
	if (ns.tooltipChkOnShowModifier(false)) then return; end
	tt = ns.acquireTooltip(
		{ttName, ttColumns, "LEFT","CENTER", "LEFT", "CENTER", "LEFT", "LEFT", "LEFT", "LEFT"},
		{false},
		{self}
	);
	createTooltip(tt);
end

-- ns.modules[name].onleave = function(self) end
-- ns.modules[name].onclick = function(self,button)
-- ns.modules[name].ondblclick = function(self,button) end
