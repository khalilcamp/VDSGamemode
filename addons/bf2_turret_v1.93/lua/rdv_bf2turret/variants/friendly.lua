local OBJ = RDV.BF2_TURRET.AddVariant("Friendly")

OBJ:SetEnemyVehicles({ -- TARGET SPECIFIC LFS VEHICLES
    "lunasflightschool_combineheli",
})

OBJ:SetDestructTime(60)

OBJ:SetEnemyNPCs({ -- TARGET SPECIFIC NPC's
    "dane_b1",
	"dane_b1t",
	"dane_b2",
	"dane_b2t",
	"dane_b2_elite",
	"dane_bx_commando",
	"dane_geo",
    "dane_bx_stalker",
    "dane_scum",
    "dane_mando",
    "dane_pirate",
    "dane_trando",
    "dane_zyg",
})

OBJ:SetAttackDamage(5)

OBJ:Register()