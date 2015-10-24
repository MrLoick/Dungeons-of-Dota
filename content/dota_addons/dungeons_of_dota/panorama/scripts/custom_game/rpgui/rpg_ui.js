//TARGET UI
var currentTargetType = "sdf";
var offsets = {
	basic: {
		width: "200px",
		top: "20px"
	},
	
	medium: {
	
	},
	
	epic: {
	
	},
	
	grandeur: {
		panelWidth: "652",
		
		width: "600",
		
		hpBarOffsetBottom: "19",
		hpBarOffsetLeft: "83",
		hpBarWidth: "494",
		hpBarHeight: "19",
		   
		imageWidth: "700",
		imageHeight: "100",
	}
}
function SetTargetUIType(type){
	currentTargetType = type;
	//Background
	$('#TargetHealthBarBackground').SetImage("file://{images}/custom_game/rpgbar/hp_bar_" + type + ".png");
	
	//Health Bar
	$('#TargetHealthBar').style.width = offsets[type].imageWidth + "px";
	$('#TargetHealthBar').style.height = offsets[type].imageHeight + "px";
	
	//Colored Bar
	$('#TargetHealthBarColor').style.width = offsets[type].hpBarWidth + "px";
	$('#TargetHealthBarColor').style.height = offsets[type].hpBarHeight + "px";
	$('#TargetHealthBarColor').style.margin = "0px 0px " + offsets[type].hpBarOffsetBottom + "px " + offsets[type].hpBarOffsetLeft + "px";
	
	//Staggering Z-Indices
	$('#THBCContainer').style.zIndex = 999;
	$('#TargetHealthBarColor').style.zIndex = 999;
	$('#TargetHealthBarText').style.zIndex = 1000;
	//$('#TargetHealthBarBackground').style.zIndex = 997;
}

function SetTargetUIName(name){
	$('#TargetName').text = name; 
}  
function SetTargetUIHealth(unit){
	var health = Entities.GetHealth(unit);
	var max = Entities.GetMaxHealth(unit);
	$('#TargetHealthBarText').text = health + " / " + max;
	if(max != 0){
		$('#TargetHealthBarColor').style.width = ((health / max) * offsets[currentTargetType].hpBarWidth) + "px";
	}
}
function SetTargetUISubtext(text){
	$('#TargetAbilities').text = text;
}
 
 function GetTargetUnit()
{
	var mouseEntities = GameUI.FindScreenEntities( GameUI.GetCursorPosition() );
	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	mouseEntities = mouseEntities.filter( function(e) { return e.entityIndex !== localHeroIndex } );
	for ( var e of mouseEntities )
	{
		if ( !e.accurateCollision ){
			continue
		}
		 
		else if(Entities.IsItemPhysical(e.entityIndex)){
			return
		}

		else if(Entities.IsBuilding(e.entityIndex)){
			return
		}

		return e.entityIndex;
	}

	for ( var e of mouseEntities )
	{
		return e.entityIndex;
	}

	return 0;
}
 var i = 0
function TargetUIPeriodic(){
	if(currentTargetType != "grandeur"){
		SetTargetUIType("grandeur");
	}
	var unit = GetTargetUnit();
	if(!unit || Entities.GetMaxHealth(unit) == -1){
		$('#TargetPanel').visible = false;
		$.Schedule(0.03, TargetUIPeriodic);
		return;
	}else{
		$('#TargetPanel').visible = true;
	}
	SetTargetUIName($.Localize(Entities.GetUnitName(unit)));
	//SetTargetUIName("hi");
	SetTargetUIHealth(unit);
	SetTargetUISubtext("DAMAGE: " + Math.ceil((Entities.GetDamageMin(unit) + Entities.GetDamageMax(unit)) / 2) + "    ARMOR : " + Math.ceil(Entities.GetArmorForDamageType(unit, 1)));
	$.Schedule(0.03, TargetUIPeriodic);
}
TargetUIPeriodic();