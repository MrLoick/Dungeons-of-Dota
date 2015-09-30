--[[ Dungeons of Dota game mode ]]

print( "Entering Dungeons of Dotas addon_game_mode.lua file." )

--------------------------------------------------------------------------------
-- Integer constants
--------------------------------------------------------------------------------
_G.nGOOD_TEAM = 2
_G.nBAD_TEAM = 3
_G.nNEUTRAL_TEAM = 4
_G.nDOTA_MAX_ABILITIES = 16
_G.nHERO_MAX_LEVEL = 25

_G.nROAMER_MAX_DIST_FROM_SPAWN = 256
_G.nCAMPER_MAX_DIST_FROM_SPAWN = 256
_G.nPATROLLER_MAX_DIST_FROM_SPAWN = 128
_G.nBOSS_MAX_DIST_FROM_SPAWN = 0
_G.nCREATURE_RESPAWN_TIME = 600

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Dungeons of Dota class
------------------------------------------------------------------------------------------------------------------------------------------------------
if CDod == nil then
	_G.CDod = class({}) -- put CDod in the global scope
	--refer to: http://stackoverflow.com/questions/6586145/lua-require-with-global-local
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Required .lua files, which just exist to help organize functions contained in our addon.  Make sure to call these beneath the mode's class creation.
------------------------------------------------------------------------------------------------------------------------------------------------------
require( "utility_functions" ) -- require utility_functions first since some of the other required files may use its functions
require( "events" )
require( "rpg_example_spawning" )
require( "worlditem_spawning" )

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Precache files and folders
------------------------------------------------------------------------------------------------------------------------------------------------------
function Precache( context )
    GameRules.dungeons_of_dota = CDod()
    GameRules.dungeons_of_dota:PrecacheSpawners( context )
    GameRules.dungeons_of_dota:PrecacheItemSpawners( context )

	PrecacheResource( "particle", "particles/addons_gameplay/player_deferred_light.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/hw_rosh_fireball_fire_launch.vpcf", context )
	PrecacheResource( "particle", "particles/econ/generic/generic_aoe_shockwave_1/generic_aoe_shockwave_1.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", context)

	PrecacheResource( "soundfile", "soundevents/game_sounds_main.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_triggers.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/creatures/game_sounds_spider.vsndevts", context )
end

--------------------------------------------------------------------------------
-- Activate Dungeons of Dota mode
--------------------------------------------------------------------------------
function Activate()
	-- When you don't have access to 'self', use 'GameRules.rpg_example' instead
		-- example Function call: GameRules.rpg_example:Function()
		-- example Var access: GameRules.rpg_example.m_Variable = 1
    GameRules.dungeons_of_dota:InitGameMode()
end

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function CDod:InitGameMode()
	print( "Entering CDod:InitGameMode" )
	self._GameMode = GameRules:GetGameModeEntity()

	self._GameMode:SetAnnouncerDisabled( true )
	self._GameMode:SetUnseenFogOfWarEnabled( true )
	self._GameMode:SetFixedRespawnTime( 3 )
	
	GameRules:SetGoldPerTick( 0 )
	GameRules:SetPreGameTime( 45 )
	GameRules:SetCustomGameSetupTimeout( 0 ) -- skip the custom team UI with 0, or do indefinite duration with -1
	GameRules:SetHeroSelectionTime( 300 )
	GameRules:SetPostGameTime( 45 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 ) -- Temp fix while GameRules:SetCustomGameSetupTimeout( 0 ) is broken
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 ) -- Temp fix while GameRules:SetCustomGameSetupTimeout( 0 ) is broken

	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CDod, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CDod, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDod, "OnEntityKilled" ), self )
	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( CDod, "OnPlayerGainedLevel" ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CDod, "OnItemPickedUp" ), self )

	self._tPlayerHeroInitStatus = {}	

	for nPlayerID = 0, DOTA_MAX_PLAYERS do
		PlayerResource:SetCustomTeamAssignment( nPlayerID, 2 ) -- put each player on Radiant team
		self._tPlayerHeroInitStatus[ nPlayerID ] = false
	end

	self:SetupSpawners()
	self:SetupItemSpawners()

	self._GameMode:SetContextThink( "CDod:GameThink", function() return self:GameThink() end, 0 )
end

--------------------------------------------------------------------------------
-- Main Think
--------------------------------------------------------------------------------
function CDod:GameThink()
	local flThinkTick = 0.2

	return flThinkTick
end

---------------------------------------------------------------------------
-- CreateWorldItemOnUnit
---------------------------------------------------------------------------
function CDod:CreateWorldItemOnUnit( sItemName, unit )
    local newItem = CreateItem( sItemName, nil, nil )
	CreateItemOnPositionSync( unit:GetAbsOrigin(), newItem )
end

---------------------------------------------------------------------------
-- CreateWorldItemOnPosition
---------------------------------------------------------------------------
function CDod:CreateWorldItemOnPosition( sItemName, vPos )
    local newItem = CreateItem( sItemName, nil, nil )
	CreateItemOnPositionSync( vPos, newItem )
	print( "Creating item " .. newItem:GetName() .. " on position: " .. tostring( vPos ) )
end

---------------------------------------------------------------------------
-- LaunchWorldItemFromUnit
---------------------------------------------------------------------------
function CDod:LaunchWorldItemFromUnit( sItemName, flLaunchHeight, flDuration, hUnit )
    local newItem = CreateItem( sItemName, nil, nil )
    local newWorldItem = CreateItemOnPositionSync( hUnit:GetOrigin(), newItem )
	newItem:LaunchLoot( false, flLaunchHeight, flDuration, hUnit:GetOrigin() + RandomVector( RandomFloat( 25, 100 ) ) )
	print( "Launching " .. newItem:GetName() .. " near " .. hUnit:GetUnitName() )
	self._GameMode:SetContextThink( "CDod:Think_PlayItemLandSound", function() return self:Think_PlayItemLandSound() end, flDuration )
end

function CDod:Think_PlayItemLandSound()
	EmitGlobalSound( "ui.inv_drop_highvalue" )
end