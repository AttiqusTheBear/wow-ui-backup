
NXInfo = {
	["profileKeys"] = {
		["Siodhachan - Burning Blade"] = "Default",
		["Manannán - Burning Blade"] = "Default",
		["Attiqus - Burning Blade"] = "Default",
		["Rezu - Thunderlord"] = "Default",
	},
	["profiles"] = {
		["Default"] = {
			["InfoData"] = {
				{
					["Items"] = {
						"<IfLTOrCombat;1;Health%><Health><c>HP <t> <HealthChange><c><t> <IfCombat>|cffff4040* <Threat%;player><c><t>", -- [1]
						"<IfLTOrCombat;1;Health%>     <Health%><c><t>%<BarH%;G;Health%><t>", -- [2]
						"<IfMana><Mana><c>MP <t> <ManaChange><c><t>", -- [3]
						"<IfMana>     <Mana%><c><t>%<BarH%;B;Mana%><t>", -- [4]
						"<Combo><c><t>", -- [5]
						"<Cooldown><c><t>", -- [6]
						"<Cast><c><t>", -- [7]
					},
				}, -- [1]
				{
					["Items"] = {
						"<THealth><c>HP <t>", -- [1]
						"     <THealth%><c><t>%<BarH%;G;THealth%><t>", -- [2]
						"<TMana><c>MP <t>", -- [3]
						"     <TMana%><c><t>%<BarH%;B;TMana%><t>", -- [4]
						"<Cast;target><c><t>", -- [5]
					},
				}, -- [2]
				["Version"] = 0.24,
			},
		},
	},
}
