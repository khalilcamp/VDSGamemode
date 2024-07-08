AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 135
ENT.Models = {"models/herm/ct/trooper/trooper.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 300
ENT.WalkAnim = ACT_HL2MP_RUN_AR2

ENT.Faction = "Republic"
ENT.WeaponModel = "models/jajoff/sps/cgiweapons/tc13j/dc15s.mdl"
ENT.WepOffsetPos = Vector(-8, -2.5, 0)
ENT.WepOffsetAng = Angle(170, 180, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 1000
ENT.DistMax = 2000

ENT.WeaponSound = "everfall/weapons/dc-15s/blasters_dc15_laser_close_var_01.mp3"
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

list.Set( "NPC", "dane_ct", {
	Name = "Clone Trooper",
	Class = "dane_ct",
	Category = "Nextbots REPUBLICA [Ninguém]"
} )

if CLIENT then
	language.Add("dane_ct", "Clone Trooper")
end