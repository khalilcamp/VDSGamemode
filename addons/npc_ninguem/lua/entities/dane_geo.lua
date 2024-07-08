AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 300
ENT.Models = {"models/swrp/swrp/geonosian_01.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 300
ENT.WalkAnim = ACT_HL2MP_RUN_AR2

ENT.Faction = "CIS"
ENT.WeaponModel = "models/weapons/star_wars_battlefront/cis_sonic_blaster.mdl"
ENT.WepOffsetPos = Vector(10, 0, 0)
ENT.WepOffsetAng = Angle(-179, -80, 3)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 100
ENT.DistMax = 500

ENT.WeaponSound = "weapons/star_wars_battlefront/cw/wpn_cis_sonicblaster_fire.wav"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 2
ENT.MultishotDelay = 0.9
ENT.minShootTime = 1.4
ENT.maxShootTime = 1.6
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 75, 75, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 25,
}

list.Set( "NPC", "dane_geo", {
	Name = "Geonosiano",
	Class = "dane_geo",
	Category = "Nextbots CIS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_geo", "B1 Battledroid")
end