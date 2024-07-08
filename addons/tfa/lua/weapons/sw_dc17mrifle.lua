SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_3dscoped_base"
SWEP.Category						= "Ninguem Weapon Pack"
SWEP.Manufacturer 					= "BlasTech Industries"
SWEP.Author							= "Kai"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "DC-17m Rifle"
SWEP.Type							= "Republic Heavy Modular Blaster Rifle"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 3
SWEP.SlotPos						= 100

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= true
SWEP.SelectiveFire					= true
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "auto"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true
SWEP.MuzzleFlashEffect 				= ""

SWEP.Primary.ClipSize				= 50
SWEP.Primary.DefaultClip			= 50*5
SWEP.Primary.RPM					= 530
SWEP.Primary.RPM_Burst				= nil
SWEP.Primary.Ammo					= "ar2"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 52495*0.75
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("everfall/weapons/dc-17m/blaster/blasters_dc17m_laser_close_var_03.mp3");
SWEP.Primary.ReloadSound 			= Sound ("everfall/weapons/miscellaneous/reload/overheat/overheat_manualcooling_var_03.mp3");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 30
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil
SWEP.DoMuzzleFlash 					= false

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

SWEP.ProjectileEntitie 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/bf2017/c_dlt19.mdl"
SWEP.WorldModel						= "models/bf2017/w_dlt19.mdl"
SWEP.ViewModelFOV					= 70
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"
SWEP.ReloadHoldTypeOverride 		= "ar2"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-1,-0.035)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= false
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_blue"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_blue"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(2.02, 0, -4.82)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.3
SWEP.Primary.KickUp					= 0.10
SWEP.Primary.KickDown				= 0.06
SWEP.Primary.KickHorizontal			= 0.05
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.02
SWEP.Primary.IronAccuracy 			= 0.003
SWEP.Primary.SpreadMultiplierMax 	= 2.2
SWEP.Primary.SpreadIncrement 		= 0.2
SWEP.Primary.SpreadRecovery 		= 0.8
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(-5.5, -3.4, 3.5)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.RunSightsPos = Vector(5.226, 0, -3)
SWEP.RunSightsAng = Vector(-22, 35, -22)

SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.Scope1Pos = Vector(-5.4, -15, 0)
SWEP.Scope1Ang = Vector(0, 0, 0)
SWEP.Attachments = {
    [1] = {
        header = "Firemodes",
        offset = {0, 0},
        atts = {"training_mod","stealth_mod","rw_rep_mod_stun10"},
    },
    [2] = {
        header = "Modules",
        offset = {0, 0},
        atts = {"dc17m_sniper_sps","dc17m_rocket_sps"},
    },
}

SWEP.ViewModelBoneMods = {
	["v_dlt19_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 1), angle = Angle(0, 0, 0) },
}

SWEP.VElements = {
	["dc17m"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/dc17m_rifle.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(1.5, -10, 0), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 1, [1] = 0, [2] = 0, [3] = 3}},
    ["sniper_module"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/dc17m_rifle.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(1.5, -10, 0), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 0, [1] = 2, [2] = 1, [3] = 3},active = false},
    ["scope_hp1"] = { type = "Model", model = "models/squad/sf_plates/sf_plate1x1.mdl", bone = "", rel = "", pos = Vector (.9, 25.7, 8.7), angle = Angle(-90, 90, 0), size = Vector(0.11, 0.11, 0), color = Color(0, 200, 255, 255), surpresslightning = false, material = "cs574/scopes/dc17msniperret", skin = 0, bodygroup = {},active = false},
    ["scope2_hp2"] = { type = "Model", model = "models/squad/sf_plates/sf_plate1x1.mdl", bone = "", rel = "", pos = Vector (.9, 10.7, 8.7), angle = Angle(-90, 90, 0), size = Vector(0.11, 0.11, 0), color = Color(0, 200, 255, 255), surpresslightning = false, material = "cs574/scopes/dc17msniperret", skin = 0, bodygroup = {},active = false},
    ["sniper_module_scope"] = { type = "Model", model = "models/rtcircle.mdl", bone = "", rel = "", pos = Vector(0.25, 10.7, 8.05), angle = Angle(-180, -90, 180), size = Vector(0.33, 0.33, 0.33), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {},active = false},
    ["grenade_module"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/dc17m_rifle.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(1.5, -10, 0), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 0, [1] = 0, [2] = 2, [3] = 3},active = false},
}
SWEP.WElements = {
	["dc17m"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/dc17m_rifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-7, 1.5, 0), angle = Angle(-15, 0, 180), size = Vector(.9, .9, .9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] =1, [1] = 0, [2] = 0, [3] = 3}},
    ["sniper_module"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/dc17m_rifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-7, 1.5, 0), angle = Angle(-15, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 0, [1] = 2, [2] = 1, [3] = 3},active = false},
    ["grenade_module"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/dc17m_rifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-7, 1.5, 0), angle = Angle(-15, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 0, [1] = 0, [2] = 2, [3] = 3},active = false},
}
SWEP.LuaShellEject = false
SWEP.LuaShellEffect = ""

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "cs574/scopes/dc17msniperret" 
SWEP.Secondary.ScopeZoom 			= 10
SWEP.ScopeReticule_Scale 			= {0,0}

if surface then
	SWEP.Secondary.ScopeTable = nil
end

DEFINE_BASECLASS( SWEP.Base )
function SWEP:ShootBullet(...)
    if self:IsAttached("dc17m_rocket_sps") and IsFirstTimePredicted() then
        if SERVER then
            timer.Simple(0, function()
                local ent = ents.Create("rw_sw_nade")
                local dir
                local ang = self.Owner:EyeAngles()
                rec, aimcone = self:CalculateConeRecoil()
                dir = ang:Forward()
                ang:RotateAroundAxis(ang:Right(), - aimcone / 2)
                if !self:GetIronSights( issighting ) then
                    ent:SetPos(self.Owner:GetShootPos() + ang:Forward()*10 + ang:Right()*13 + ang:Up()*-10)
                end
                if self:GetIronSights( issighting ) then
                    ent:SetPos(self.Owner:GetShootPos() + ang:Forward()*25 + ang:Right() + ang:Up()*-25)
                end
                ent:SetOwner(self.Owner)
                ent:Spawn()
                ent:SetVelocity(dir * 1500)
                local phys = ent:GetPhysicsObject()
                if IsValid(phys) then
                    phys:SetVelocity(dir * 1500)
                    phys:EnableGravity( true )
                    phys:EnableDrag(false)
                end
            end)
        end
        return
    end
    return BaseClass.ShootBullet(self,...)
end