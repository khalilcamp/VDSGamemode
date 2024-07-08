if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "npc_drg_rancor" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Juvenile Rancor"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/swtor/npcs/rancor_a01.mdl"}
ENT.Skins = {5}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(100, 100, 100)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false

-- Stats --
ENT.SpawnHealth = 1400
ENT.HealthRegen = 5
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)