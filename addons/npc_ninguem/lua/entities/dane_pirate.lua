AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 95
ENT.Models = {"models/player/ohanak_gang/pm_pirate_soldier.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 250
ENT.WalkAnim = ACT_HL2MP_RUN_AR2

ENT.Faction = "CRIME"
ENT.WeaponModel = "models/sw_battlefront/weapons/westar_35_rifle.mdl"
ENT.WepOffsetPos = Vector(4, -1, -1)
ENT.WepOffsetAng = Angle(-185, 90, -20)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 100
ENT.DistMax = 500

ENT.WeaponSound = "everfall/weapons/scatter_gun/fire/blaster_scattergun_laser_close_var_02.mp3"
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
	Damage = 7,
}

list.Set( "NPC", "dane_pirate", {
	Name = "Pirata",
	Class = "dane_pirate",
	Category = "Nextbots EXTRAS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_pirate", "Pirata")
end