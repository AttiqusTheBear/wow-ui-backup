
WowLua_DB = {
	["currentPage"] = 2,
	["fontSize"] = 14,
	["pages"] = {
		{
			["untitled"] = true,
			["name"] = "Untitled 1",
			["content"] = "print(GetQuestCurrencyInfo(\"reward\",47040))\nfunction QuestIsDarkmoonMonthly()\n   if QuestIsDaily() then return false end\n   local id = GetQuestID()\n   local scope = id and QuestExceptions[id]\n   if scope and scope ~= \"Darkmoon\" then return false end -- one-time referral quests\n   for i=1,GetNumRewardCurrencies() do\n      local name,texture,amount = GetQuestCurrencyInfo(\"reward\",i)\n      if texture and texture:find(\"_ticket_darkmoon_\") then\n         return true\n      end\n   end\n   return false\nend\nprint(QuestIsDarkmoonMonthly())\n\nfor i=1, GetNumRewardCurrencies() do\n   local name, texture, amount = GetQuestCurrencyInfo(\"reward\", i)\n   if texture:find(\"_ticket_darkmoon_\") then\n      print(\"true\")\n   end\nend\n",
		}, -- [1]
		{
			["untitled"] = true,
			["name"] = "Untitled 2",
			["content"] = "for i=1, GetNumRewardCurrencies() do local name, texture, amount = GetQuestCurrencyInfo(\"reward\", i);if name and name ~= \"\" then print((\"%d - %s - %a\"):format(name, texture, amount))  end end\n",
		}, -- [2]
	},
	["untitled"] = 3,
}
