function frost_nova_on_spell_start(keys)
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	BlastFinalRadius = ability:GetLevelSpecialValueFor("blast_final_radius", ability_level)
	BlastDamage = ability:GetLevelSpecialValueFor("blast_damage", ability_level)

	local shivas_guard_particle = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(shivas_guard_particle, 1, Vector(BlastFinalRadius, BlastFinalRadius / keys.BlastSpeedPerSecond, keys.BlastSpeedPerSecond))
	
	keys.caster:EmitSound("DOTA_Item.ShivasGuard.Activate")
	keys.caster.shivas_guard_current_blast_radius = 0
	
	--Every .03 seconds, damage and apply a movement speed debuff to all units within the current radius of the blast (centered around the caster)
	--that do not already have the debuff.
	--Stop the timer when the blast has reached its maximum radius.
	Timers:CreateTimer({
		endTime = .03, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()
			keys.ability:CreateVisibilityNode(keys.caster:GetAbsOrigin(), keys.BlastVisionRadius, keys.BlastVisionDuration)  --Shiva's Guard's active provides 800 flying vision around the caster, which persists for 2 seconds.
		
			keys.caster.shivas_guard_current_blast_radius = keys.caster.shivas_guard_current_blast_radius + (keys.BlastSpeedPerSecond * .03)
			local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, keys.caster.shivas_guard_current_blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for i, individual_unit in ipairs(nearby_enemy_units) do
				if not individual_unit:HasModifier("modifier_item_shivas_guard_datadriven_blast_debuff") then
					ApplyDamage({victim = individual_unit, attacker = keys.caster, damage = BlastDamage, damage_type = DAMAGE_TYPE_MAGICAL,})
					
					--This impact particle effect should radiate away from the caster of Shiva's Guard.
					local shivas_guard_impact_particle = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, individual_unit)
					local target_point = individual_unit:GetAbsOrigin()
					local caster_point = individual_unit:GetAbsOrigin()
					ParticleManager:SetParticleControl(shivas_guard_impact_particle, 1, target_point + (target_point - caster_point) * 30)
					
					ability:ApplyDataDrivenModifier(keys.caster, individual_unit, "modifier_item_shivas_guard_datadriven_blast_debuff", nil)
				end
			end
			
			if keys.caster.shivas_guard_current_blast_radius < BlastFinalRadius then  --If the blast should still be expanding.
				return .03
			else  --The blast has reached or exceeded its intended final radius.
				keys.caster.shivas_guard_current_blast_radius = 0
				return nil
			end
		end
	})
end