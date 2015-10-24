function Kick( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1	
	-- print("Entering Kick")
	-- Clears any current command

	-- Ability variables
	ability.nDamageAmount = ability:GetLevelSpecialValueFor("damage", ability_level)
	ability.kick_direction = caster:GetForwardVector()
	ability.kick_distance = ability:GetLevelSpecialValueFor("push_length", ability_level)
	ability.kick_speed = 1600 * 1/30
	ability.kick_traveled = 0
	ability.kick_z = 0
end

function KickDamage( keys )
	-- print("Applying Damage")
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damageType = ability:GetAbilityDamageType()

	ApplyDamage({ victim = target, attacker = caster, damage = ability.nDamageAmount, damage_type = damageType, })
end

--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function KickHorizontal( keys )
	-- print("Moving horizontally")
	local caster = keys.target
	local ability = keys.ability

	if ability.kick_traveled < ability.kick_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.kick_direction * ability.kick_speed)
		ability.kick_traveled = ability.kick_traveled + ability.kick_speed
	else
		caster:InterruptMotionControllers(true)
	end
end

--[[Moves the caster on the vertical axis until movement is interrupted]]
function KickVertical( keys )
	-- print("Moving Vertically")
	local caster = keys.target
	local ability = keys.ability

	-- For the first half of the distance the unit goes up and for the second half it goes down
	if ability.kick_traveled < ability.kick_distance/2 then
		-- Go up
		-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
		ability.kick_z = ability.kick_z + ability.kick_speed/2
		-- Set the new location to the current ground location + the memorized z point
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.kick_z))
	else
		-- Go down
		ability.kick_z = ability.kick_z - ability.kick_speed/2
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.kick_z))
	end
end