
----------------------------------
-- module independent variables --
----------------------------------
local addon, ns = ...
local C, L, I = ns.LC.color, ns.L, ns.I


-----------------------------------------------------------
-- module own local variables and local cached functions --
-----------------------------------------------------------
local name = "Stuff" -- L["Stuff"]
local ttName,tt2Name = name.."TT",name.."TT2"
local tt,tt2 = nil
local last_click = 0
local nextAction = nil;
local clickActions = {
	{"Do you really want to logout from this character?",function() securecall('Logout'); end}, -- L["Do you really want to logout from this character?"]
	{"Do you really want to left the game?",function() securecall('Quit'); end}, -- L["Do you really want to left the game?"]
	{"Do you really want to reload the UI?",function() securecall('ReloadUI'); end}, -- L["Do you really want to reload the UI?"]
	{"Do you really want to switch display mode?",function() SetCVar('gxWindow', 1 - GetCVar('gxWindow')); securecall('RestartGx'); end}, -- L["Do you really want to switch display mode?"]
}
local timeout=5;
local timeout_counter=0;


-------------------------------------------
-- register icon names and default files --
-------------------------------------------
I[name] = {iconfile="Interface\\Addons\\"..addon.."\\media\\stuff"}; --IconName::Stuff--


---------------------------------------
-- module variables for registration --
---------------------------------------
ns.modules[name] = {
	desc = L["Broker to allow you to do...Stuff! Switch to windowed mode, reload ui, logout and quit."],
	events = {},
	updateinterval = nil, -- 10
	config_defaults = {},
	config_allowed = nil,
	config_header = nil, -- use default header
	config_broker = nil,
	config_tooltip = nil,
	config_misc = nil,
}


--------------------------
-- some local functions --
--------------------------
StaticPopupDialogs["BE_CONFIRM_RELOADUI"] = {
	text = L["Are you sure you want to Reload the UI?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		ReloadUI()
	end,
	timeout = 20,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 5,
}

local function pushedTooltip(parent,id,msg)
	if (tt) and (tt.key) and (tt.key==ttName) then ns.hideTooltip(tt); end
	tt2 = ns.acquireTooltip({tt2Name, 1, "LEFT"},{true},{parent});

	tt2:Clear();
	tt2:AddLine(C("orange",L[msg]));
	tt2:AddSeparator();
	tt2:AddLine(C("yellow",L["Then push again..."]).." "..timeout_counter);

	if (id==nextAction) then
		timeout_counter = timeout_counter - 1;
		C_Timer.After(1,function()
			if (timeout_counter==0) or (nextAction==nil) then
				ns.hideTooltip(tt2);
				tt2=nil;
			elseif (id==nextAction) then
				pushedTooltip(parent,id,msg);
			end
		end);
	end

	ns.roundupTooltip(tt2);
end

local function toggleWindowMode()
	ns.SetCVar("gxWindow", 1 - tonumber(GetCVar("gxWindow")));
	RestartGx();
end

local function reloadUI()
	StaticPopup_Show("BE_CONFIRM_RELOADUI");
end

local function createTooltip(tt)
	if (tt) and (tt.key) and (tt.key~=ttName) then return end -- don't override other LibQTip tooltips...

	local line, column

	if tt.lines~=nil then tt:Clear(); end
	tt:AddHeader(C("dkyellow",L[name]))
	tt:AddLine (" ")

	line, column = tt:AddLine(L["Windowed / Fullscreen"])
	tt:SetLineScript(line, "OnMouseUp", toggleWindowMode);

	line, column = tt:AddLine(L["Reload UI"])
	tt:SetLineScript(line, "OnMouseUp", reloadUI); -- Use static Popup to avoid taint.

	line, column = tt:AddLine(LOGOUT)
	tt:SetLineScript(line, "OnMouseUp", Logout);

	line, column = tt:AddLine(L["Quit Game"])
	tt:SetLineScript(line, "OnMouseUp", Quit);

	if ns.profile.GeneralOptions.showHints then
		tt:AddLine(" ")
		line, column = nil, nil
		tt:AddLine(
			C("copper",L["Left-click"]).." || "..C("green",LOGOUT)
			.."|n"..
			C("copper",L["Right-click"]).." || "..C("green",L["Quit game"])
			--.."|n"..
			--C("copper",L["Shift+Left-click"]).." || "..C("green",L["Switch window/fullscreen mode"])
			.."|n"..
			C("copper",L["Shift+Left-click"]).." || "..C("green",L["Reload UI"])
		)
	end
	ns.roundupTooltip(tt);
end

------------------------------------
-- module (BE internal) functions --
------------------------------------

-- ns.modules[name].init = function() end
-- ns.modules[name].onevent = function(self,event,msg) end
-- ns.modules[name].optionspanel = function(panel) end
-- ns.modules[name].onmousewheel = function(self,direction) end
-- ns.modules[name].ontooltip = function(tt) end


-------------------------------------------
-- module functions for LDB registration --
-------------------------------------------
ns.modules[name].onenter = function(self)
	if (ns.tooltipChkOnShowModifier(false)) then return; end
	tt = ns.acquireTooltip({ttName, 1, "LEFT"},{false},{self});
	createTooltip(tt);
end

ns.modules[name].onleave = function(self)
	timeout_counter=0;
	nextAction=nil;
end

ns.modules[name].onclick = function(self,button)
	if ns.profile[name].disableOnClick then return end
	local shift = IsShiftKeyDown()

	local _= function(id)
		local a = clickActions[id] or {"Error",function() end};
		if (id~=nextAction) then
			nextAction=id;
			timeout_counter=timeout;
			pushedTooltip(self,id,a[1]);
			C_Timer.After(timeout, function()
				if (id==nextAction) then
					nextAction=nil;
				end
			end);
		elseif (id==nextAction) then
			a[2]();
		end
	end

	if (button=="LeftButton") and (not shift) then
		_(1); -- logout
	elseif (button=="RightButton") and (not shift) then
		_(2); -- quit
	elseif (button=="LeftButton") and (shift) then
		_(3); -- reload
	elseif (button=="RightButton") and (shift) then
		-- _(4); -- display mode
	end
end

-- ns.modules[name].ondblclick = function(self,button) end
