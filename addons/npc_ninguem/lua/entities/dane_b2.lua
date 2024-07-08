AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 200
ENT.Models = {"models/tor/cis/b2/trp.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkAnim = ACT_HL2MP_WALK_PISTOL

ENT.Faction = "CIS"
ENT.WeaponModel = "None"
ENT.WepOffsetPos = Vector(10, 0, 0)
ENT.WepOffsetAng = Angle(170, 180, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 100
ENT.DistMax = 300

ENT.WeaponSound = "everfall/weapons/b2_arm_blaster/style_1/blasters_e5-b2_laser_close_var_01.mp3"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 3
ENT.MultishotDelay = 0.2
ENT.minShootTime = 0.8
ENT.maxShootTime = 1.2
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 85, 85, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 7,
}

list.Set( "NPC", "dane_b2", {
	Name = "B2 Battledroid",
	Class = "dane_b2",
	Category = "Nextbots CIS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_b2", "B2 Battledroid")
end