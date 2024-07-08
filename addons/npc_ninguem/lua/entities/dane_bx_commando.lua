AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 300
ENT.Models = {"models/bx_captain/pm_droid_bx_captain.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 300
ENT.WalkAnim = ACT_HL2MP_RUN_AR2

ENT.Faction = "CIS"
ENT.WeaponModel = "models/jajoff/sps/cgiweapons/tc13j/e5elite.mdl"
ENT.WepOffsetPos = Vector(-8, -2, 0)
ENT.WepOffsetAng = Angle(170, 180, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 600
ENT.DistMax = 700

ENT.WeaponSound = "everfall/weapons/e-5/bx/blasters_e5_bx_laser_close_var_01.mp3"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 5
ENT.MultishotDelay = 0.3
ENT.minShootTime = 1.6
ENT.maxShootTime = 2
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 50, 50, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 10,
}

list.Set( "NPC", "dane_bx_commando", {
	Name = "BX Commando",
	Class = "dane_bx_commando",
	Category = "Nextbots CIS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_bx_commando", "BX Commando")
end