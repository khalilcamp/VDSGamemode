AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 60
ENT.Models = {"models/b1_inf/pm_droid_b1_inf_pvt.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.Faction = "CIS"
ENT.WeaponModel = "models/jajoff/sps/cgiweapons/tc13j/e5.mdl"
ENT.WepOffsetPos = Vector(-6, -3, 0)
ENT.WepOffsetAng = Angle(170, 180, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 100
ENT.DistMax = 500

ENT.WeaponSound = "everfall/weapons/e-5/b1/blasters_e5_laser_close_var_01.mp3"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 10
ENT.MultishotDelay = 0.2
ENT.minShootTime = 1.4
ENT.maxShootTime = 1.6
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 100, 100, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 10,
}

list.Set( "NPC", "dane_b1", {
	Name = "B1 Battledroid",
	Class = "dane_b1",
	Category = "Nextbots CIS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_b1", "B1 Battledroid")
end