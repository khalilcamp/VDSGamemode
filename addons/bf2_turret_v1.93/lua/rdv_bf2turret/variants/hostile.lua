local OBJ = RDV.BF2_TURRET.AddVariant("Hostile")

-- OBJ:SetEnemyTeams({ -- TARGET SELECT PLAYER TEAMS
--    TEAM_CITIZEN,
-- })

OBJ:SetEnemyTeams(true) -- TARGET ALL PLAYERS

OBJ:SetEnemyVehicles({ -- TARGET SPECIFIC LFS VEHICLES
    "lunasflightschool_combineheli",
})

OBJ:SetEnemyNPCs({ -- TARGET SPECIFIC NPC's
    "npc_antlionguard",
	"npc_combine_s",
	"npc_helicopter",
	"npc_manhack",
	"antlion",
	"npc_drg_zombie",
	"npc_drg_headcrab",
})

OBJ:SetAttackDamage(5)

OBJ:Register()