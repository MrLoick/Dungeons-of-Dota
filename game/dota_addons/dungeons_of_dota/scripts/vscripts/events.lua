--[[ Events ]]

--------------------------------------------------------------------------------
-- GameEvent:OnGameRulesStateChange
--------------------------------------------------------------------------------
function CDod:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		print( "OnGameRulesStateChange: Custom Game Setup" )
		GameRules:SetTimeOfDay( 0.25 )
		SendToServerConsole( "dota_daynightcycle_pause 1" )

	elseif nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		print( "OnGameRulesStateChange: Hero Selection" )

	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		print( "OnGameRulesStateChange: Pre Game Selection" )
		self:SpawnCreatures()
		self:SpawnItems()

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print( "OnGameRulesStateChange: Game In Progress" )

	elseif nNewState == DOTA_GAMERULES_STATE_POST_GAME then
		print( "OnGameRulesStateChange: Post Game" )

	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnNPCSpawned
--------------------------------------------------------------------------------
function CDod:OnNPCSpawned( event )
	hSpawnedUnit = EntIndexToHScript( event.entindex )

	if hSpawnedUnit:IsOwnedByAnyPlayer() and hSpawnedUnit:IsRealHero() then
		local hPlayerHero = hSpawnedUnit
		self._GameMode:SetContextThink( "self:Think_InitializePlayerHero( hPlayerHero )", function() return self:Think_InitializePlayerHero( hPlayerHero ) end, 0 )
	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnEntityKilled
--------------------------------------------------------------------------------
function CDod:OnEntityKilled( event )
	hDeadUnit = EntIndexToHScript( event.entindex_killed )
	hAttackerUnit = EntIndexToHScript( event.entindex_attacker )

	if hDeadUnit:IsCreature() then
		self:PlayDeathSound( hDeadUnit )
		self:GrantItemDrop( hDeadUnit )

		if hAttackerUnit.PlayKillEffect ~= nil then
			hAttackerUnit:PlayKillEffect( hDeadUnit )
		end
	end
end

--------------------------------------------------------------------------------
-- GrantItemDrop
--------------------------------------------------------------------------------
function CDod:GrantItemDrop( hDeadUnit )
	if hDeadUnit.itemTable == nil then
		return
	end

	local flMaxHeight = RandomFloat( 300, 450 )

	if RandomFloat( 0, 1 ) > 0.45 then
		local sItemName = GetRandomElement( hDeadUnit.itemTable )
		self:LaunchWorldItemFromUnit( sItemName, flMaxHeight, 0.5, hDeadUnit )
	end
end

--------------------------------------------------------------------------------
-- PlayDeathSound
--------------------------------------------------------------------------------
function CDod:PlayDeathSound( hDeadUnit )
	if hDeadUnit:GetUnitName() == "npc_dota_creature_zombie" or hDeadUnit:GetUnitName() == "npc_dota_creature_zombie_crawler" then
		EmitSoundOn( "Zombie.Death", hDeadUnit )

	elseif hDeadUnit:GetUnitName() == "npc_dota_creature_bear" then
		EmitSoundOn( "Bear.Death", hDeadUnit )

	elseif hDeadUnit:GetUnitName() == "npc_dota_creature_bear_large" then
		EmitSoundOn( "BearLarge.Death", hDeadUnit )

	end
end

--------------------------------------------------------------------------------
-- Think_InitializePlayerHero
--------------------------------------------------------------------------------
function CDod:Think_InitializePlayerHero( hPlayerHero )
	if not hPlayerHero then
		return 0.1
	end

	local nPlayerID = hPlayerHero:GetPlayerID()

	if self._tPlayerHeroInitStatus[ nPlayerID ] == false then
		PlayerResource:SetCameraTarget( nPlayerID, hPlayerHero )
		PlayerResource:SetOverrideSelectionEntity( nPlayerID, hPlayerHero )
		PlayerResource:SetGold( nPlayerID, 0, true )
		PlayerResource:SetGold( nPlayerID, 0, false )
		hPlayerHero:HeroLevelUp( false )
		hPlayerHero:UpgradeAbility( hPlayerHero:GetAbilityByIndex( 0 ) )
		hPlayerHero:UpgradeAbility( hPlayerHero:GetAbilityByIndex( 1 ) )
		hPlayerHero:SetIdleAcquire( false )

		if GetMapName() == "ruinous_dungeon" or "misty_heights" or "fiery_depths" or "dead_ends" or "icy_demise" then
			local nLightParticleID = ParticleManager:CreateParticle( "particles/addons_gameplay/player_deferred_light.vpcf", PATTACH_ABSORIGIN, hPlayerHero )
			ParticleManager:SetParticleControlEnt( nLightParticleID, PATTACH_ABSORIGIN, hPlayerHero, PATTACH_ABSORIGIN, "attach_origin", hPlayerHero:GetAbsOrigin(), true )
		end

		self._tPlayerHeroInitStatus[ nPlayerID ] = true
	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnPlayerGainedLevel
--------------------------------------------------------------------------------
function CDod:OnPlayerGainedLevel( event )
	local hPlayer = EntIndexToHScript( event.player )
	local hPlayerHero = hPlayer:GetAssignedHero()

	hPlayerHero:SetHealth( hPlayerHero:GetMaxHealth() )
	hPlayerHero:SetMana( hPlayerHero:GetMaxMana() )
end

function CDod:OnItemPickedUp( event )
	local hPlayerHero = EntIndexToHScript( event.HeroEntityIndex )
	EmitGlobalSound( "ui.inv_equip_highvalue" )
end