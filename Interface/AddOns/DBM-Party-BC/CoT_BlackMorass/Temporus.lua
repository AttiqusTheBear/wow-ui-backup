local mod	= DBM:NewMod(553, "DBM-Party-BC", 12, 255)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 606 $"):sub(12, -3))
mod:SetCreatureID(17880)
mod:SetEncounterID(1921)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 31458 38592",
	"SPELL_AURA_REMOVED 31458"
)

--TODO, actual CD timers
local specWarnSpellReflect	= mod:NewSpecialWarningReflect(38592, "SpellCaster", nil, 2, 1, 2)
local specWarnHasten		= mod:NewSpecialWarningDispel(31458, "MagicDispeller", nil, nil, 1, 2)

local timerSpellReflect		= mod:NewBuffActiveTimer(6, 38592, nil, "SpellCaster", 2)
local timerHasten			= mod:NewTargetTimer(10, 31458, nil, "MagicDispeller|Healer|Tank", 2)

local voiceHasten			= mod:NewVoice(31458, "MagicDispeller")--dispelboss
local voiceReflect			= mod:NewVoice(38592, "SpellCaster")--stopattack

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 31458 and not args:IsDestTypePlayer() then     --Hasten
		timerHasten:Start(args.destName)
		specWarnHasten:Show(args.destName)
		voiceHasten:Play("dispelboss")
	elseif args.spellId == 38592 then
		specWarnSpellReflect:Show(args.destName)
		timerSpellReflect:Start()
		voiceReflect:Play("stopattack")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 31458 then
		timerHasten:Cancel(args.destName)
    end
end