AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 750
ENT.Models = {"models/player/hk77.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 165
ENT.WalkAnim = ACT_HL2MP_WALK_PISTOL

ENT.Faction = "CIS"
ENT.WeaponModel = "None"
ENT.WepOffsetPos = Vector(10, 0, 0)
ENT.WepOffsetAng = Angle(170, 180, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 100
ENT.DistMax = 500

ENT.WeaponSound = "everfall/weapons/glie-44/blasters_glie44_laser_close_var_01.mp3"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 15
ENT.MultishotDelay = 0.2
ENT.minShootTime = 0.8
ENT.maxShootTime = 1.2
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 50, 50, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 15,
}

list.Set( "NPC", "dane_hk77", {
	Name = "Droid HK-77",
	Class = "dane_hk77",
	Category = "Nextbots CIS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_hk77", "Droid HK-77")
end