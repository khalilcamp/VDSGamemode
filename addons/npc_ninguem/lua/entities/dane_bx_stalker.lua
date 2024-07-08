AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 800
ENT.Models = {"models/mag_base/pm_droid_mag_base.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 250
ENT.WalkAnim = ACT_HL2MP_RUN_AR2

ENT.Faction = "CIS"
ENT.WeaponModel = "models/jajoff/sps/cgiweapons/tc13j/e5elite.mdl"
ENT.WepOffsetPos = Vector(-9, -1, 0)
ENT.WepOffsetAng = Angle(170, 180, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 500
ENT.DistMax = 1000

ENT.WeaponSound = "everfall/weapons/e-5/bx/blasters_e5_bx_laser_close_var_05.mp3"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 5
ENT.MultishotDelay = 0.2
ENT.minShootTime = 1.2
ENT.maxShootTime = 1.8
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 50, 50, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 35,
}

list.Set( "NPC", "dane_bx_stalker", {
	Name = "Magna Droid",
	Class = "dane_bx_stalker",
	Category = "Nextbots CIS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_bx_stalker", "BX Stalker")
end