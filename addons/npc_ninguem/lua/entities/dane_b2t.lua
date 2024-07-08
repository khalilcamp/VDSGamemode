AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 100
ENT.Models = {"models/tor/cis/b2/training.mdl"}
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

ENT.WeaponSound = "w/b2_blaster.wav"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 3
ENT.MultishotDelay = 0.2
ENT.minShootTime = 0.8
ENT.maxShootTime = 1.2
ENT.BulletTable = {
	Num = 2,
	Spread = Vector( 75, 75, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 3,
}

list.Set( "NPC", "dane_b2t", {
	Name = "B2 Battledroid Treino",
	Class = "dane_b2t",
	Category = "Nextbots CIS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_b2t", "B2 Battledroid")
end