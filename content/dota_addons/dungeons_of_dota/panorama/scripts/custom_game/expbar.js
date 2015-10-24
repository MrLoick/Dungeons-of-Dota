function SetTargetUIArmor(unit){
	var armor = (Entities.GetArmorForDamageType(unit, 1));
	$('#TargetArmorText').style.zIndex = 1000;

	$('#TargetArmorText').text = "Armor: " + armor.toFixed(2);
}

function SetTargetUIDamage(unit){
	var dmg = ((Entities.GetDamageMax(unit) + Entities.GetDamageMin(unit)) / 2);
	var dmgbonus = Entities.GetDamageBonus(unit);
	$('#TargetDamageText').style.zIndex = 1000;

	$('#TargetDamageText').text = "Damage: " + dmg + " + " + dmgbonus;
}

function SetTargetUILvl(unit){
	var lvl = Entities.GetLevel(unit);
	$('#TargetLvlText').style.zIndex = 1000;

	$('#TargetLvlText').text = "Level: " + lvl ;
}

function SetTargetUIExp(unit){
	var exp = Entities.GetCurrentXP(unit);
	var exptolvl = Entities.GetNeededXPToLevel(unit);

	//Staggering Z-Indices
	$('#TEBCContainer').style.zIndex = 999;
	$('#TargetExpBarColor').style.zIndex = 999;
	$('#TargetExpBarText').style.zIndex = 1000;

	$('#TargetExpBarText').text = exp + " / " + (exptolvl);
	if(exp != 0){
		$('#TargetExpBarColor').style.width = (((exptolvl - exp) / exptolvl) * 392 + "px")
	}
}

function TargetUIPeriodic(){
	var unit = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );

	SetTargetUIArmor(unit);
	SetTargetUIDamage(unit);
	SetTargetUILvl(unit);
	SetTargetUIExp(unit);
	$.Schedule(0.03, TargetUIPeriodic);
}
TargetUIPeriodic();
