SWEP.Gun							= ("tfa_3dscoped_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_3dscoped_base"
SWEP.Category						= "KillgraveRP Weapon Pack"
SWEP.Manufacturer 					= "Concordian Crescent Technologies"
SWEP.Author							= "Kai"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "GALAAR-15 Blaster Rifle"
SWEP.Type							= "Mandalorian Battle Rifle"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 78
SWEP.Slot							= 2
SWEP.SlotPos						= 100
SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= true
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "Automatic"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 40
SWEP.Primary.DefaultClip			= 40*8
SWEP.Primary.RPM					= 150
SWEP.Primary.RPM_Burst				= 350
SWEP.Primary.Ammo					= "ar2"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 35000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.35
SWEP.Primary.Sound 					= Sound ("everfall/weapons/e-5/bx/blasters_e5_bx_laser_close_var_03.mp3");
SWEP.Primary.ReloadSound 			= Sound ("w/rifles.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 60
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil
SWEP.LuaShellEffect 				= nil

SWEP.FireModes = {
	"Automatic",
	"3Burst",
	"Single"
}

SWEP.IronRecoilMultiplier			= 0.65
SWEP.CrouchRecoilMultiplier			= 0.85
SWEP.JumpRecoilMultiplier			= 0.8
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.2
SWEP.CrouchAccuracyMultiplier		= 0.8
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 2.2
SWEP.WalkAccuracyMultiplier			= 1.8
SWEP.NearWallTime 					= 0.5
SWEP.ToCrouchTime 					= 0.25
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/weapons/synbf3/c_e11.mdl"
SWEP.WorldModel						= "models/weapons/synbf3/w_e11.mdl"
SWEP.ViewModelFOV					= 75
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"

SWEP.ShowWorldModel = false
SWEP.LuaShellEject = false


SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-2,-0.075)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= ""

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_yellow"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_yellow"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(2, -7, -1)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.4
SWEP.Primary.KickUp					= 0.2/2
SWEP.Primary.KickDown				= 0.15/2
SWEP.Primary.KickHorizontal			= 0.055/2
SWEP.Primary.StaticRecoilFactor 	= 0.65
SWEP.Primary.Spread					= 0.035
SWEP.Primary.IronAccuracy 			= 0.0001
SWEP.Primary.SpreadMultiplierMax 	= 0.4
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector( -4.825, -6, 2.96)
SWEP.IronSightsAng = Vector(-01, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, -1.5)
SWEP.RunSightsAng = Vector(-22, 32.50, -19)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_e11_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
    ["w11"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/westarm35_rifle.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(.30, -12, 1.3), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
   	["Ironsight"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/mando_westar35_scope.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(-1, 0, 4), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["scope"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_e11_reference001", rel = "", pos = Vector( -1, -1.4, 05.26), angle = Angle(0, 90, 0), size = Vector(0.23, 0.23, 0.23), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} },
}

SWEP.WElements = {
    ["w11"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/westarm35_rifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-8, 2, -0), angle = Angle(-11.5, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
   	["Ironsight"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/mando_westar35_scope.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.5, .85, -5), angle = Angle(170, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_yellow" 
SWEP.Secondary.ScopeZoom 			= 4
SWEP.ScopeReticule_Scale 			= {1.1,1.1}

DEFINE_BASECLASS( SWEP.Base )