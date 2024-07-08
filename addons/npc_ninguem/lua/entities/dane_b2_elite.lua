AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 1600
ENT.Models = {"models/tor/cis/b2/rocket.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkAnim = ACT_HL2MP_WALK_PISTOL

ENT.Faction = "CIS"
ENT.WeaponModel = "None"
ENT.WepOffsetPos = Vector(10, 0, 0)
ENT.WepOffsetAng = Angle(170, 180, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 200
ENT.DistMax = 500

ENT.WeaponSound = "everfall/weapons/e-5c/blasters_e-5c_laser_close_var_01.mp3"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 8
ENT.MultishotDelay = 0.1
ENT.minShootTime = 1
ENT.maxShootTime = 1.5
ENT.BulletTable = {
	Num = 2,
	Spread = Vector( 75, 75, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 25,
}

list.Set( "NPC", "dane_b2_elite", {
	Name = "B3 Battledroid",
	Class = "dane_b2_elite",
	Category = "Nextbots CIS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_b2", "B3 Battledroid")
end