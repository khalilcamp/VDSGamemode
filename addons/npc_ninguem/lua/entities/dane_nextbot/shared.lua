ENT.Base = "base_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 100
ENT.Models = {"models/jajoff/sps/cgidroid/jlm/droidb1.mdl"}
ENT.BloodColour = DONT_BLEED
ENT.DaneNextbot = true

ENT.Faction = "CIS"
ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5_blaster.mdl"
ENT.WepOffsetPos = Vector(10, 0, 0)
ENT.WepOffsetAng = Angle(170, 180, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 100
ENT.DistMax = 500

ENT.WeaponSound = "w/e5.wav"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 0
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
	Damage = 3,
}