--[[Author: Pizzalol
	Date: 26.09.2015.
	Clears current caster commands and disjoints projectiles while setting up everything required for movement]]
function Punch( keys )
	print("Entering Punch")
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	-- Clears any current command and disjoints projectiles
	ProjectileManager:ProjectileDodge(caster)
	-- Ability variables
	ability.nDamageAmount = caster:GetAverageTrueAttackDamage() * ability:GetLevelSpecialValueFor("crit_multiplier", ability_level) * 1/100
	ability.punch_direction = caster:GetForwardVector()
	ability.push_length = ability:GetLevelSpecialValueFor("push_length", ability_level)
	ability.push_speed = 1600 * 1/30
	ability.punch_traveled = 0
	ability.punch_z = 0
end

function PunchDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damageType = ability:GetAbilityDamageType()

	ApplyDamage({ victim = target, attacker = caster, damage = ability.nDamageAmount, damage_type = damageType, })
end

--[[Moves the caster on the vertical axis until movement is interrupted]]
function PunchVertical( keys )
	local caster = keys.target
	local ability = keys.ability

	-- For the first half of the distance the unit goes up and for the second half it goes down
	if ability.punch_traveled < ability.push_length then
		-- Go up
		-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
		ability.punch_z = ability.punch_z + ability.push_speed/2
		-- Set the new location to the current ground location + the memorized z point
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.punch_z))
		ability.punch_traveled = ability.punch_traveled + ability.push_speed
	else
		-- Go down
		ability.punch_z = ability.punch_z - ability.push_speed/2
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.punch_z))
		caster:InterruptMotionControllers(true)
	end
end