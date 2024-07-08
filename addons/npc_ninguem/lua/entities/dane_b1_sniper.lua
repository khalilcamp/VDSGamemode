AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 35
ENT.Models = {"models/red_co/pm_droid_b1_sec_co.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.Faction = "CIS"
ENT.WeaponModel = "models/weapons/star_wars_battlefront/cis_sniper_rifle.mdl"
ENT.WepOffsetPos = Vector(0, 0, 0)
ENT.WepOffsetAng = Angle(170, 267, 5)

ENT.SightRange = 15000
ENT.ShootRange = 15000

ENT.DistMin = 15000
ENT.DistMax = 15000

ENT.WeaponSound = "everfall/weapons/ee-4/blasters_ee4_laser_close_var_01.mp3"
ENT.ShootBone = "ValveBiped.Bip01_R_Hand"
ENT.Multishot = 5
ENT.MultishotDelay = 10.2
ENT.minShootTime = 3.5
ENT.maxShootTime = 3.5
ENT.BulletTable = {
	Num = 1,
	Spread = Vector( 25, 25, 0 ),
	Tracer = 1,
	TracerName = "rw_sw_laser_red",
	Force = 1,
	HullSize = 0,
	Damage = 50,
}

list.Set( "NPC", "dane_b1_sniper", {
	Name = "B1 Battledroid Sniper",
	Class = "dane_b1_sniper",
	Category = "Nextbots CIS [Ninguém]"
} )

if CLIENT then
	language.Add("dane_b1_sniper", "B1 Battledroid Sninper")
end