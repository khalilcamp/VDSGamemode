AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 35
ENT.Models = {"models/b1_training/pm_droid_b1_training.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.Faction = "CIS"
ENT.WeaponModel = "models/jajoff/sps/cgiweapons/tc13j/e5.mdl"
ENT.WepOffsetPos = Vector(-3, 0, 0)
ENT.WepOffsetAng = Angle(170, 180, 0)

ENT.SightRange = 90000
ENT.ShootRange = 90000

ENT.DistMin = 100
ENT.DistMax = 500

ENT.WeaponSound = "everfall/weapons/e-5/b1/blasters_e5_laser_close_var_01.mp3"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 15
ENT.MultishotDelay = 0.2
ENT.minShootTime = 1.4
ENT.maxShootTime = 1.6
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 75, 75, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 3,
}

list.Set( "NPC", "dane_b1t", {
	Name = "B1 Battledroid Treino",
	Class = "dane_b1t",
	Category = "Nextbots CIS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_b1t", "B1 Battledroid")
end