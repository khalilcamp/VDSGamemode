SWEP.Gun							= ("bf2017_e5c")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "KillgraveRP Weapon Pack"
SWEP.Manufacturer 					= "Baktoid Armor Workshop"
SWEP.Author							= "Kai"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= true
SWEP.PrintName						= "E-5c"
SWEP.Type							= "CIS Repeating Blaster"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 78
SWEP.Slot							= 3
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
SWEP.DefaultFireMode 				= "auto"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 50
SWEP.Primary.DefaultClip			= 100
SWEP.Primary.RPM					= 650
SWEP.Primary.RPM_Burst				= 650
SWEP.Primary.Ammo					= "ar2"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 35000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("everfall/weapons/e-5c/blasters_e-5c_laser_close_var_04.mp3");
SWEP.Primary.ReloadSound 			= Sound ("w/heavy.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 20
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil
SWEP.LuaShellEffect 				= nil

SWEP.FireModes = {
	"Auto",
	"Single"
}


SWEP.IronRecoilMultiplier			= 0.5
SWEP.CrouchRecoilMultiplier			= 0.25
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.3
SWEP.CrouchAccuracyMultiplier		= 0.81
SWEP.ChangeStateAccuracyMultiplier	= 1.18
SWEP.JumpAccuracyMultiplier			= 2
SWEP.WalkAccuracyMultiplier			= 1.18
SWEP.NearWallTime 					= 0.25
SWEP.ToCrouchTime 					= 0.25
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/weapons/synbf3/c_t21.mdl"
SWEP.WorldModel						= "models/weapons/synbf3/w_t21.mdl"
SWEP.ViewModelFOV					= 70
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"

SWEP.ShowWorldModel = false
SWEP.LuaShellEject = false


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
SWEP.TracerName 					= "rw_sw_laser_red"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_red"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(3.5, -5, -02.15)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.7
SWEP.Primary.KickUp					= 0.15
SWEP.Primary.KickDown				= 0.12
SWEP.Primary.KickHorizontal			= 0.12
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.0185
SWEP.Primary.IronAccuracy 			= 0.005
SWEP.Primary.SpreadMultiplierMax 	= 2
SWEP.Primary.SpreadIncrement 		= 0.22
SWEP.Primary.SpreadRecovery 		= 0.8
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 0.85
SWEP.IronSightsMoveSpeed 			= 0.75

SWEP.IronSightsPos = Vector(-5.22, -2, 0.95+2)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, -1)
SWEP.RunSightsAng = Vector(-14, 29, -19)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_t21_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
   	["e5c"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/e5c.mdl", bone = "v_t21_reference001", rel = "", pos = Vector(1.8, -10, 1.5), angle = Angle(0,-90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
   	["Ironsight"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/mando_westar35_scope2.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(.65, 3, 6.51), angle = Angle(180, 90, 180), size = Vector(.7, .7, .7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.WElements = {
	["e5c"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/e5c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-5, 2.5, 0), angle = Angle(-11, 0, 180), size = Vector(.9, .9, .9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/gdcw_elcanreticle" 
SWEP.Secondary.ScopeZoom 			= 10
SWEP.ScopeReticule_Scale 			= {2.5,2.5}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end
DEFINE_BASECLASS( SWEP.Base )