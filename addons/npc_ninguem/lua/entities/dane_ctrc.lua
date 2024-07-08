AddCSLuaFile()

ENT.Base = "dane_nextbot"
ENT.AutomaticFrameAdvance = true
ENT.CollisionBounds = Vector(10, 10, 72)

ENT.MaxHealth = 400
ENT.Models = {"models/player/budds/cgi_commandos/unmarked/unmarked_commando_white.mdl"}
ENT.BloodColour = DONT_BLEED

ENT.WalkSpeed = 300
ENT.WalkAnim = ACT_HL2MP_RUN_AR2

ENT.Faction = "Republic"
ENT.WeaponModel = "models/weapons/star_wars_battlefront/rep_dc17_rifle.mdl"
ENT.WepOffsetPos = Vector(8, 0, -3)
ENT.WepOffsetAng = Angle(535, 270, 0)

ENT.SightRange = 5000
ENT.ShootRange = 5000

ENT.DistMin = 1000
ENT.DistMax = 2000

ENT.WeaponSound = "everfall/weapons/dc-17m/blaster/blasters_dc17m_laser_close_var_01.mp3"
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

list.Set( "NPC", "dane_ctrc", {
	Name = "Clone Trooper RC",
	Class = "dane_ctrc",
	Category = "Nextbots REPUBLICA [Ninguém]"
} )

if CLIENT then
	language.Add("dane_ctrc", "Clone Trooper RC")
end