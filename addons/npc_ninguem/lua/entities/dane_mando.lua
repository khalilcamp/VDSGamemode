AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 250
ENT.Models = {"models/jajoff/sps/jlmbase/characters/CWDW_trooper.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 250
ENT.WalkAnim = ACT_HL2MP_RUN_AR2

ENT.Faction = "MANDALORIANO"
ENT.WeaponModel = "models/sw_battlefront/weapons/westar_35_rifle.mdl"
ENT.WepOffsetPos = Vector(4, 0, -2)
ENT.WepOffsetAng = Angle(-185, 90, -10)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 100
ENT.DistMax = 500

ENT.WeaponSound = "everfall/weapons/probe_droid/blasters_probotlaser_laser_close_var_01.mp3"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 2
ENT.MultishotDelay = 0.2
ENT.minShootTime = 1.2
ENT.maxShootTime = 1.8
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 50, 50, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 5,
}

list.Set( "NPC", "dane_mando", {
	Name = "Mandaloriano",
	Class = "dane_mando",
	Category = "Nextbots EXTRAS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_mando", "Escória")
end