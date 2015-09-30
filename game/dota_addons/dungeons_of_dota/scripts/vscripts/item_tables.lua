--[[ Item tables ]]

--------------------------------------------------------------------------------
-- Camp lists for each roamer group type
--------------------------------------------------------------------------------

local tTIER_01_ITEMS_ALL = {
	"item_broadsword_tier_one", "item_flask", "item_enchanted_mango", "item_ring_of_protection", "item_mithril_hammer", "item_helm_of_iron_will"
}

local tTIER_02_ITEMS_ALL = {
	"item_flask", "item_helm_of_iron_will", "item_broadsword_tier_two", "item_saprophytic_blade", "item_ritual_dirk", "item_boots", "item_chainmail", "item_mithril_hammer", "item_claymore", "item_ring_of_basilius"
}

local tTIER_03_ITEMS_ALL = {
	"item_phase_boots", "item_broadsword_tier_three", "item_platemail", "item_saprophytic_blade", "item_ritual_dirk", "item_helm_of_iron_will", "item_claymore", "item_helm_of_iron_will", "item_ring_of_basilius"
}

local tTIER_04_ITEMS_ALL = {
	"item_broadsword_epic", "item_bfury", "item_staff_of_the_ruminant", "item_butterfly", "item_cheese", "item_skadi"
}

local tKEY_GATE01 = {
	"item_orb_of_passage"
}

--------------------------------------------------------------------------------
-- All roamer lists
--------------------------------------------------------------------------------
local tITEMS_ALL = {
	worlditems_tier01 = tTIER_01_ITEMS_ALL,
	worlditems_tier02 = tTIER_02_ITEMS_ALL,
	worlditems_tier03 = tTIER_03_ITEMS_ALL,
	worlditems_tier04 = tTIER_04_ITEMS_ALL,
	worlditems_gate01_key = tKEY_GATE01
}

return tITEMS_ALL