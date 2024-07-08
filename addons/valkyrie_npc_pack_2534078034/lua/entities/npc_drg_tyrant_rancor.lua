if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "npc_drg_rancor" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Tyrant Rancor"
ENT.Category = "[Valkyrie] Creature NPCs"
ENT.Models = {"models/swtor/npcs/rancor_a01.mdl"}
ENT.Skins = {8}
ENT.ModelScale = 1.2
ENT.CollisionBounds = Vector(120, 120, 120)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false

-- Stats --
ENT.SpawnHealth = 1000
ENT.HealthRegen = 5
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)