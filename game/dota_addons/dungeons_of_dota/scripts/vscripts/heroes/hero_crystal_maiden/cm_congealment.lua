function Congealment(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target

	ability.duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	if target:GetTeamNumber() == caster:GetTeamNumber() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_bite_root_datadriven", {duration=ability.duration})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_bite_heal_datadriven", {duration=ability.duration})
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_bite_root_datadriven", {duration=ability.duration})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_frost_bite_damage_datadriven", {duration=ability.duration})
	end
end
