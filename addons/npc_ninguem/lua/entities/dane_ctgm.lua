AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 235
ENT.Models = {"models/jajoff/sps/cgi21s/tc13j/marine.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 300
ENT.WalkAnim = ACT_HL2MP_RUN_AR2

ENT.Faction = "Republic"
ENT.WeaponModel = "models/jajoff/sps/cgiweapons/tc13j/z6_chaingun.mdl"
ENT.WepOffsetPos = Vector(-7, -1.5, -6)
ENT.WepOffsetAng = Angle(170, -180, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 1000
ENT.DistMax = 2000

ENT.WeaponSound = "weapons/star_wars_battlefront/cw/wpn_rep_blaster_fire.wav"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 12
ENT.MultishotDelay = 0.2
ENT.minShootTime = 1.4
ENT.maxShootTime = 1.6
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 75, 75, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 10,
}

list.Set( "NPC", "dane_ctgm", {
	Name = "Clone Trooper GM",
	Class = "dane_ctgm",
	Category = "Nextbots REPUBLICA [Ninguém]"
} )

if CLIENT then
	language.Add("dane_ctgm", "Clone Trooper GM")
end