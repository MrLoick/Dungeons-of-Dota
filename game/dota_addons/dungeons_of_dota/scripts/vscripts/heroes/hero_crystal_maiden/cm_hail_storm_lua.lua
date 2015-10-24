function BlizzardStartPoint( event )
	local caster = event.caster
	local ability = event.ability
	local ability_level = ability:GetLevel() - 1
	local point = event.target_points[1]
	local wait = ability:GetLevelSpecialValueFor("wave_duration", ability_level)

	ability.radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	ability.damage = ability:GetLevelSpecialValueFor("wave_damage", ability_level)
	ability.wave_interval = ability:GetLevelSpecialValueFor("wave_interval", ability_level)

	caster.blizzard_dummy_point = CreateUnitByName("npc_dota_dummy_caster", point, false, caster, caster, caster:GetTeam())
	ability:ApplyDataDrivenModifier(caster, caster.blizzard_dummy_point, "modifier_blizzard_wave", nil)
	caster.blizzard_dummy_point:EmitSound("hero_Crystal.freezingField.wind")

    Timers:CreateTimer(wait,function()
	caster.blizzard_dummy_point:RemoveModifierByName("modifier_blizzard_wave")
	caster.blizzard_dummy_point:StopSound("hero_Crystal.freezingField.wind")
	
	local blizzard_dummy_point_pointer = caster.blizzard_dummy_point
	Timers:CreateTimer((wait - 0.1),function() blizzard_dummy_point_pointer:RemoveSelf() end) end)
end


--[[function BlizzardWaveStart( event )
	local caster = event.caster
	event.ability:ApplyDataDrivenModifier(caster, caster.blizzard_dummy_point, "modifier_blizzard_thinker", nil)
end]]

-- -- Create the particles with small delays between each other
function BlizzardWave( event )
	print("BlizzardWave")
	local caster = event.caster
	local ability = event.ability
	local target = event.target


	local target_position = event.target:GetAbsOrigin() --event.target_points[1]
    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
    local distance = 100

    for delay = 0, 1/10 do
    	Timers:CreateTimer(delay, function ()
		local unitsNearTarget = FindUnitsInRadius(caster:GetTeamNumber(),
			target_position,
			nil,
			ability.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		target = nil
		for k, v in ipairs(unitsNearTarget) do
			target = v
			break
		end

		if target ~= nil then
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = ability.damage,
				damage_type = DAMAGE_TYPE_MAGICAL} 
			ApplyDamage(damageTable)
		end

		end)
    end

    -- Center explosion
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle1, 0, target_position )

	local fv = caster:GetForwardVector()
    local distance = 100

    Timers:CreateTimer(0.05,function()
    local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle2, 0, target_position+RandomVector(100) ) end)

    Timers:CreateTimer(0.1,function()
	local particle3 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle3, 0, target_position-RandomVector(100) ) end)

    Timers:CreateTimer(0.15,function()
	local particle4 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle4, 0, target_position+RandomVector(RandomInt(50,100)) ) end)

    Timers:CreateTimer(0.2,function()
	local particle5 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	 ParticleManager:SetParticleControl( particle5, 0, target_position-RandomVector(RandomInt(50,100)) ) end)
end

function BlizzardEnd( event )
	local caster = event.caster
	caster.blizzard_dummy_point:RemoveModifierByName("modifier_blizzard_wave")
	caster:RemoveModifierByName("modifier_blizzard_channelling")
	caster.blizzard_dummy_point:StopSound("hero_Crystal.freezingField.wind")
	
	local blizzard_dummy_point_pointer = caster.blizzard_dummy_point
	Timers:CreateTimer(0.4,function() blizzard_dummy_point_pointer:RemoveSelf() end)
	
end