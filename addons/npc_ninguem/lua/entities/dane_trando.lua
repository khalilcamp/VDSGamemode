AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 120
ENT.Models = {"models/hunter/pm_trandoshan_hunter.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 250
ENT.WalkAnim = ACT_HL2MP_RUN_AR2

ENT.Faction = "CRIME"
ENT.WeaponModel = "models/hauptmann/star wars/weapons/relby_v10.mdl"
ENT.WepOffsetPos = Vector(9, -1, 1)
ENT.WepOffsetAng = Angle(-185, 181, -1)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 100
ENT.DistMax = 500

ENT.WeaponSound = "everfall/weapons/relby-k23/blasters_k23stinger_laser_close_var_01.mp3"
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

list.Set( "NPC", "dane_trando", {
	Name = "Trando",
	Class = "dane_trando",
	Category = "Nextbots EXTRAS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_trando", "Trando")
end