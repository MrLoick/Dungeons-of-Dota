
function eclipse_start(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	ability.bounceTable = {}

	ability.damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	ability.radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	ability.beam_interval = ability:GetLevelSpecialValueFor("beam_interval", ability:GetLevel() - 1)
	ability.beams = ability:GetLevelSpecialValueFor("beams", ability:GetLevel() - 1) 
	ability.max_hit_count = ability:GetLevelSpecialValueFor("hit_count", ability:GetLevel() - 1)

	for delay = 0, (ability.beams-1) * ability.beam_interval, ability.beam_interval do
		Timers:CreateTimer(delay, function ()
				if caster:IsAlive() == false then
					return
				end

				local unitsNearTarget = FindUnitsInRadius(caster:GetTeamNumber(),
			                            caster:GetAbsOrigin(),
			                            nil,
			                            ability.radius,
			                            DOTA_UNIT_TARGET_TEAM_ENEMY,
			                            DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			                            DOTA_UNIT_TARGET_FLAG_NONE,
			                            FIND_ANY_ORDER,
			                            false)

				-- finds the first target with < max_hit_count
				target = nil
				for k, v in pairs(unitsNearTarget) do
					if ability.bounceTable[v] == nil or ability.bounceTable[v] < ability.max_hit_count then
						target = v
						break
					end
				end

				-- if it finds a target, deals damage and then adds it to the bounceTable
				if target ~= nil then
					local caster_point = caster:GetAbsOrigin()
					local target_point = target:GetAbsOrigin()
					local caster_point_temp = Vector(caster_point.x, caster_point.y, 0)
					local target_point_temp = Vector(target_point.x, target_point.y, 0)
					local point_difference_normalized = (target_point_temp - caster_point_temp):Normalized()
					local velocity_per_second = point_difference_normalized * keys.TravelSpeed
					local meteor_fly_original_point = (target_point - (velocity_per_second * keys.LandTime)) + Vector (0, 0, 1000) 
					beam  = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, keys.caster)
					ParticleManager:SetParticleControl(beam, 0, meteor_fly_original_point)
					ParticleManager:SetParticleControl(beam, 1, target_point)
					ParticleManager:SetParticleControl(beam, 2, Vector(1.3, 0, 0))

					EmitSoundOn("Hero_Invoker.ChaosMeteor.Cast", target)
					EmitSoundOn("Hero_Invoker.ChaosMeteor.Loop", caster)

					local damageTable = {
							victim = target,
							attacker = caster,
							damage = ability.damage,
							damage_type = DAMAGE_TYPE_MAGICAL} 
					ApplyDamage(damageTable)

					ability.bounceTable[target] = ((ability.bounceTable[target] or 0) + 1)

					Timers:CreateTimer({
						endTime = keys.LandTime,
						callback = function()
							--Create a dummy unit will follow the path of the meteor, providing flying vision, sound, damage, etc.			
							local chaos_meteor_dummy_unit = CreateUnitByName("npc_dota_dummy_caster", target_point, false, nil, nil, keys.caster:GetTeam())
							
							caster:StopSound("Hero_Invoker.ChaosMeteor.Loop")
							chaos_meteor_dummy_unit:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
							
							
							--Store the damage to deal in a variable attached to the dummy unit, so leveling Exort after Meteor is cast will have no effect.
						
							local chaos_meteor_duration = keys.TravelDistance / keys.TravelSpeed
							local chaos_meteor_velocity_per_frame = velocity_per_second * .03
							
							--It would seem that the Chaos Meteor projectile needs to be attached to a particle in order to move and roll and such.
							local projectile_information =  
							{
								EffectName = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
								vSpawnOrigin = target_point,
								fDistance = keys.TravelDistance,
								fStartRadius = 0,
								fEndRadius = 0,
								Source = chaos_meteor_dummy_unit,
								bHasFrontalCone = false,
								iMoveSpeed = keys.TravelSpeed,
								bReplaceExisting = false,
								bProvidesVision = true,
								iVisionTeamNumber = keys.caster:GetTeam(),
								iVisionRadius = keys.VisionDistance,
								bDrawsOnMinimap = false,
								bVisibleToEnemies = true, 
								iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
								iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
								iUnitTargetType = DOTA_UNIT_TARGET_NONE ,
								fExpireTime = GameRules:GetGameTime() + chaos_meteor_duration,
							}
							
							projectile_information.vVelocity = velocity_per_second
							local chaos_meteor_projectile = ProjectileManager:CreateLinearProjectile(projectile_information)
							
							--Adjust the dummy unit's position every frame.
							local endTime = GameRules:GetGameTime() + chaos_meteor_duration - 0.1
							Timers:CreateTimer({
								callback = function()
									chaos_meteor_dummy_unit:SetAbsOrigin(chaos_meteor_dummy_unit:GetAbsOrigin() + chaos_meteor_velocity_per_frame)
									if GameRules:GetGameTime() > endTime then
										--Stop the sound, particle, and damage when the meteor disappears.
										chaos_meteor_dummy_unit:StopSound("Hero_Invoker.ChaosMeteor.Destroy")
									
										--Have the dummy unit linger in the position the meteor ended up in, in order to provide vision.
										return 
									else 
										return .03
									end
								end
							})
						end
					})
				end
			end)
	end 
end