
FACTION.name = "Marinha Republicana"
FACTION.description = "A grande frota da Republica Galáctica já tem séculos de existência, mas agora ela está em um de seus momentos mais dificeis de todo sua história."
FACTION.color = Color(255, 200, 100, 255)
FACTION.isGloballyRecognized = true
FACTION.pay = 25
FACTION.weapons = {"mvp_hands", "weapon_fists"}
FACTION.models = {
	"models/navy/gnavycrewman.mdl",
	"models/navy/gnavyadmiral.mdl",
	"models/navy/gnavyrsb.mdl",
	"models/navy/gnavyofficer.mdl",
  	"models/jajoff/sps/republic/tc13j/army_01.mdl", 
	"models/jajoff/sps/republic/tc13j/army01_female.mdl", 
	"models/jajoff/sps/republic/tc13j/army_02.mdl", 
	"models/jajoff/sps/republic/tc13j/army02_female.mdl", 
	"models/jajoff/sps/republic/tc13j/army_03.mdl", 
	"models/jajoff/sps/republic/tc13j/army03_female.mdl", 
	"models/jajoff/sps/republic/tc13j/navy_01.mdl",
	"models/jajoff/sps/republic/tc13j/navy01_female.mdl", 
	"models/jajoff/sps/republic/tc13j/navy_02.mdl", 
	"models/jajoff/sps/republic/tc13j/navy02_female.mdl", 
	"models/jajoff/sps/republic/tc13j/navy_03.mdl",
	"models/jajoff/sps/republic/tc13j/navy03_female.mdl", 
	"models/jajoff/sps/republic/tc13j/navy_04.mdl", 
	"models/jajoff/sps/republic/tc13j/navy04_female.mdl", 
	"models/jajoff/sps/republic/tc13j/navy_medic_female.mdl", 
	"models/jajoff/sps/republic/tc13j/rsb01.mdl", 
	"models/jajoff/sps/republic/tc13j/rsb02.mdl", 
	"models/jajoff/sps/republic/tc13j/rsb02_female.mdl", 
	"models/jajoff/sps/republic/tc13j/rsb03.mdl",
	"models/jajoff/sps/republic/tc13j/rsb03_female.mdl",
}

function FACTION:OnSpawn(client)
    client:SetMaxHealth(100)
    client:SetHealth(100)
    client:SetRunSpeed(500)
    client:SetArmor(50)
    client:SetMaxArmor(50)
end


FACTION.isDefault = false

FACTION_MARINHA = FACTION.index
FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true
