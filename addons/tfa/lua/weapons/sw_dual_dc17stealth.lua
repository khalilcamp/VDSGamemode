SWEP.Gun							= ("sw_dual_dc17")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "Ninguem Weapon Pack"
SWEP.Manufacturer 					= "Blastech Industries"
SWEP.Author							= "Kai"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Dual DC-17 (Stealth)"
SWEP.Type							= "Republic Dual Blaster Pistol"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 0
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 1
SWEP.SlotPos						= 100

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "auto"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 15*2
SWEP.Primary.DefaultClip			= 20*8
SWEP.Primary.RPM					= 230*2*0.8
SWEP.Primary.RPM_Burst				= 230*2*0.8
SWEP.Primary.Ammo					= "pistol"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 32000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/dc19.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/pistols.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 12
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.Akimbo 						= true

SWEP.DoMuzzleFlash 					= false
SWEP.CustomMuzzleFlash 				= false
SWEP.MuzzleFlashEffect 				= "none"

SWEP.FireModes = {
	"Single"
}

SWEP.IronRecoilMultiplier			= 0.44
SWEP.CrouchRecoilMultiplier			= 0.33
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.18
SWEP.CrouchAccuracyMultiplier		= 0.7
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 2.6
SWEP.WalkAccuracyMultiplier			= 1.18
SWEP.NearWallTime 					= 0.25
SWEP.ToCrouchTime 					= 0.1
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/strasser/weapons/c_ddeagle.mdl"
SWEP.WorldModel						= "models/bf2017/w_scoutblaster.mdl"
SWEP.ViewModelFOV					= 90
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "duel"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-2.5,-0.05)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= ""

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_dual_laser_black"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_black"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(0, -6, -3)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.6
SWEP.Primary.KickUp					= 0.35/3
SWEP.Primary.KickDown				= 0.15/3
SWEP.Primary.KickHorizontal			= 0.055/3
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.005
SWEP.Primary.IronAccuracy 			= 0.005
SWEP.Primary.SpreadMultiplierMax 	= 1.6
SWEP.Primary.SpreadIncrement 		= 0.3
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.8

SWEP.IronSightsPos = Vector(0, -5, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, -7.5, -10)
SWEP.RunSightsAng = Vector(37.5, 0, 0)
SWEP.InspectPos = Vector(0, -5, -5)
SWEP.InspectAng = Vector(37.5,0,0)

SWEP.LuaShellEject = false

SWEP.Attachments = {
[1] = {atts = {"training_mod"},order = 1},
}

SWEP.VElements = {
	["dc17"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/dc17.mdl", bone = "LeftHand_1stP", rel = "", pos = Vector(-9, 2.2, 0), angle = Angle(0, 0, 78), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dc17+"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/dc17.mdl", bone = "RightHand_1stP", rel = "", pos = Vector(9, -2.2, 3), angle = Angle(180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.WElements = {
	["dc17"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/dc17.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-7.7, -1.5, 1.5), angle = Angle(0, -10, 2), size = Vector(.89, .89, .89), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dc17+"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/dc17.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-7.7, 1, -1.5), angle = Angle(0, -8, 180), size = Vector(.89, .89, .89), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ProceduralHolsterPos = Vector(0,-8,-8)
SWEP.ProceduralHolsterAng = Vector(37.5,0,0)
SWEP.DoProceduralReload = true
SWEP.ProceduralReloadTime = 2.3

SWEP.ThirdPersonReloadDisable		= false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/gdcw_elcanreticle" 
SWEP.Secondary.ScopeZoom 			= 1
SWEP.ScopeReticule_Scale 			= {1.1,1.1}
if surface then
	SWEP.Secondary.ScopeTable = nil
end
DEFINE_BASECLASS( SWEP.Base )