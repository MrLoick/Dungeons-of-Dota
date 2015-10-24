function SetTargetUIHealth(unit){
	var health = Entities.GetHealth(unit);
	var maxhealth = Entities.GetMaxHealth(unit);

	//Staggering Z-Indices
	$('#THBCContainer').style.zIndex = 999;
	$('#TargetHealthBarColor').style.zIndex = 999;
	$('#TargetHealthBarText').style.zIndex = 1000;

	$('#TargetHealthBarText').text = health + " / " + maxhealth;
	if(maxhealth != 0){
		$('#TargetHealthBarColor').style.width = ((health / maxhealth) * 602 + "px")
	}
}

function SetTargetUIMana(unit){
	var mana = Entities.GetMana(unit);
	var maxmana = Entities.GetMaxMana(unit);

	//Staggering Z-Indices
	$('#TMBCContainer').style.zIndex = 999;
	$('#TargetManaBarColor').style.zIndex = 999;
	$('#TargetManaBarText').style.zIndex = 1000;

	$('#TargetManaBarText').text = mana + " / " + maxmana;
	if(maxmana != 0){
		$('#TargetManaBarColor').style.width = ((mana / maxmana) * 602 + "px")
	}
}

function TargetUIPeriodic(){
	var unit = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );

	SetTargetUIHealth(unit);
	SetTargetUIMana(unit);
	$.Schedule(0.03, TargetUIPeriodic);
}
TargetUIPeriodic();

