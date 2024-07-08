AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 1250
ENT.Models = {"models/odd/swtor/player/hk51_a02.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 275
ENT.WalkAnim = ACT_HL2MP_RUN_AR2

ENT.Faction = "CRIME"
ENT.WeaponModel = "models/jajoff/sps/cgiweapons/tc13j/westarm35_rifle.mdl"
ENT.WepOffsetPos = Vector(-6, -5, 1)
ENT.WepOffsetAng = Angle(165, 180, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 100
ENT.DistMax = 500

ENT.WeaponSound = "everfall/weapons/t-21/style_1/blasters_t21_laser_close_var_01.mp3"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 1
ENT.MultishotDelay = 0.3
ENT.minShootTime = 1.2
ENT.maxShootTime = 1.8
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 50, 50, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 15,
}

list.Set( "NPC", "dane_hk47", {
	Name = "Droid Assassino",
	Class = "dane_hk47",
	Category = "Nextbots EXTRAS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_hk47", "Escória")
end