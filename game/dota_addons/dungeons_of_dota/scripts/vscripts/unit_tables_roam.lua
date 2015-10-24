--[[ Roam types and their units ]]
local tITEMS_ALL = require( "item_tables" )

--------------------------------------------------------------------------------
-- Camp lists for each roamer group type
--------------------------------------------------------------------------------
local kMIN_CAMP_COUNT = 10
local kMAX_CAMP_COUNT = 12
local nROAMER_MAX_DIST_FROM_SPAWN = 256
local tSMALL_ROAM_UNITS_ALL = {
	{
		unitNames = { "npc_dota_creature_zombie", "npc_dota_creature_zombie_crawler" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier01
	},
	{
		unitNames = { "npc_dota_creature_zombie_two", "npc_dota_creature_zombie_crawler_two" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier01
	},
	{
		unitNames = { "npc_dota_creature_skeleton", "npc_dota_creature_skeleton_archer" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier01
	},
	{
		unitNames = { "npc_dota_creature_ghoul", "npc_dota_creature_ghoul_one" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier01
	},
	{
		unitNames = { "npc_dota_creature_gargoyle_small", "npc_dota_creature_gargoyle_small", "npc_dota_creature_harpy_one", "npc_dota_creature_harpy_two" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier01
	}
}

local tMEDIUM_ROAM_UNITS_ALL = {
	{
		unitNames = { "npc_dota_creature_gargoyle_one", "npc_dota_creature_gargoyle_two", "npc_dota_creature_elemental_water", "npc_dota_creature_gargoyle_two" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier02
	},
	{
		unitNames = { "npc_dota_creature_ghost_small", "npc_dota_creature_abomination", "npc_dota_creature_ghost_small", "npc_dota_creature_ghost", "npc_dota_creature_ghost_small", "npc_dota_creature_ghost_red" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier02
	},
	{
		unitNames = { "npc_dota_creature_soulstealer", "npc_dota_creature_soulstealer_fire" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier02
	},
	{
		unitNames = { "npc_dota_creature_kobold_small", "npc_dota_creature_kobold_small", "npc_dota_creature_kobold_one", "npc_dota_creature_kobold_one", "npc_dota_creature_kobold_one", "npc_dota_creature_kobold_large" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier02
	}
}

local tLARGE_ROAM_UNITS_ALL = {
	{
		unitNames = { "npc_dota_creature_spider_small", "npc_dota_creature_abomination", "npc_dota_creature_spider_small", "npc_dota_creature_spider" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier03
	},
	{
		unitNames = { "npc_dota_creature_elemental_darkness", "npc_dota_creature_fiend_darkness", "npc_dota_creature_griffin_corrupt", "npc_dota_creature_fiend_darkness" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier03
	},
	{
		unitNames = { "npc_dota_creature_fiend_hell", "npc_dota_creature_warrior_hell", "npc_dota_creature_demon_hell", "npc_dota_creature_warrior_hell" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier03
	},
	{
		unitNames = { "npc_dota_creature_fiend_ice", "npc_dota_creature_elemental_ice", "npc_dota_creature_griffin_corrupt", "npc_dota_creature_elemental_ice" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier03
	},
	{
		unitNames = { "npc_dota_creature_rider", "npc_dota_creature_phantasm", "npc_dota_creature_phantasm", "npc_dota_creature_griffin_corrupt" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier03
	},
	{
		unitNames = { "npc_dota_creature_scorpion", "npc_dota_creature_scarab", "npc_dota_creature_weaver_one", "npc_dota_creature_weaver_two" },
		minCount = kMIN_CAMP_COUNT, maxCount = kMAX_CAMP_COUNT,
		maxDistanceFromSpawn = nROAMER_MAX_DIST_FROM_SPAWN,
		itemTable = tITEMS_ALL.worlditems_tier03
	}
}

local tBOSS_UNITS_BOSSES = {
	{
		unitNames = { "npc_dota_creature_mini_roshan" },
		minCount = 1, maxCount = 1,
		maxDistanceFromSpawn = 256,
		itemTable = tITEMS_ALL.worlditems_tier04
	}
}

--------------------------------------------------------------------------------
-- All roamer lists
--------------------------------------------------------------------------------
local tROAM_UNITS_ALL = {
	roam_small = tSMALL_ROAM_UNITS_ALL,
	roam_medium = tMEDIUM_ROAM_UNITS_ALL,
	roam_large = tLARGE_ROAM_UNITS_ALL,
	camp_boss = tBOSS_UNITS_BOSSES
}

return tROAM_UNITS_ALL
