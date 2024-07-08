SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars Reworked Explosif"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Ping Launcher"
SWEP.Type							= "Galactic Grenade Launcher"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 75

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "Single"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 2
SWEP.Primary.DefaultClip			= 1*5
SWEP.Primary.RPM					= 40
SWEP.Primary.RPM_Burst				= 40
SWEP.Primary.Ammo					= "grenade"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 1750*2
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/launcher.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/reload_fast.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 350
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil
SWEP.DoMuzzleFlash 					= false
SWEP.Primary.Force = 0
SWEP.Primary.Knockback = 0

SWEP.Attachments = {
	-- [1] = { offset = { 0, 0 }, atts = {"nade_impact","nade_bacta","nade_dioxis"}, order = 1},
	-- [2] = { offset = { 0, 0 }, atts = {"ping_power_1500","ping_power_2250","ping_power_3000"}, order = 1},
}

SWEP.ProjectileModel 				= nil
SWEP.ProjectileVelocity 			= 1750*2.5
SWEP.ProjectileEntity               = "rw_sw_nade"

SWEP.FireModes = {
	"Single"
}


SWEP.IronRecoilMultiplier			= 1
SWEP.CrouchRecoilMultiplier			= 1
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.3
SWEP.CrouchAccuracyMultiplier		= 0.5
SWEP.ChangeStateAccuracyMultiplier	= 1.18
SWEP.JumpAccuracyMultiplier			= 2.6
SWEP.WalkAccuracyMultiplier			= 1.8
SWEP.NearWallTime 					= 0.5
SWEP.ToCrouchTime 					= 0.25
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ViewModel						= "models/bf2017/c_e11.mdl"
SWEP.WorldModel						= "models/bf2017/w_e11.mdl"
SWEP.ViewModelFOV					= 50
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "rpg"
SWEP.ReloadHoldTypeOverride 		= "rpg"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= false
SWEP.BlowbackVector 				= Vector(0,-4.5,0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= false
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= nil
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= nil
SWEP.ImpactDecal 					= nil

SWEP.VMPos = Vector(2, -2, 0)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.4
SWEP.Primary.KickUp					= 0
SWEP.Primary.KickDown				= 0
SWEP.Primary.KickHorizontal			= 0.6
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.03
SWEP.Primary.IronAccuracy 			= 0.03
SWEP.Primary.SpreadMultiplierMax 	= 2.3
SWEP.Primary.SpreadIncrement 		= 0.2
SWEP.Primary.SpreadRecovery 		= 0.8
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(1, -4, 2)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_e11_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-3, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["rocketlauncher"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/rps_sp4.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(1.5, -6, 0), angle = Angle(0, -90, 0), size = Vector(.5, .5, .5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	
}

SWEP.WElements = {
	["rocketlauncher"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/rps_sp4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-6, 2, 0), angle = Angle(-7, 0, 180), size = Vector(.8, .8, .8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.SequenceRateOverride       = {
	["reload"] = 0.5
}

SWEP.ThirdPersonReloadDisable		= false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_green" 
SWEP.Secondary.ScopeZoom 			= 4
SWEP.ScopeReticule_Scale 			= {1.06,1.065}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end

if CLIENT then
	local color_red = Color(255,0,0,100)
	hook.Add( "PostDrawTranslucentRenderables", "tfa_ping_launcher_hud", function()

		local ply = LocalPlayer()
		if not IsValid(ply) then return end

		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) then return end

		if wep:GetClass() != "rw_sw_pinglauncher" then return end

		local Grav = physenv.GetGravity()
		local FT = 0.01 -- RealFrameTime()
		local Pos = ply:EyePos()
		local Vel = ply:EyeAngles():Forward() * (wep.ProjectileVelocity or 1750*1.2)*.9

		cam.Start3D()
		local Iteration = 0
		while Iteration < 1000 do
			Iteration = Iteration + 1

			Vel = Vel + Grav * FT

			local StartPos = Pos
			local EndPos = Pos + Vel * FT

			local trace = util.TraceLine( {
				start = StartPos,
				endpos = EndPos,
				mask = MASK_SOLID,
				filter = ply
			} )

			//render.DrawLine( StartPos, EndPos, color_red )

			Pos = EndPos

			if trace.Hit then
				break
			end
		end
		cam.End3D()

		render.SetColorMaterial()
		render.DrawSphere( Pos, 30, 30, 30, color_red )
	
	end )

	/*
	hook.Add( "HUDPaint", "tfa_ping_launcher_hud", function()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		print("test")

		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) then return end

		if wep:GetClass() != "rw_sw_pinglauncher" then return end

		local Grav = physenv.GetGravity()
		local FT = 0.05 -- RealFrameTime()
		local Pos = ply:EyePos()
		local Vel = ply:EyeAngles():Forward() * (wep.ProjectileVelocity or 1750*0.5)

		cam.Start3D()
		local Iteration = 0
		while Iteration < 1000 do
			Iteration = Iteration + 1

			Vel = Vel + Grav * FT

			local StartPos = Pos
			local EndPos = Pos + Vel * FT

			local trace = util.TraceLine( {
				start = StartPos,
				endpos = EndPos,
				mask = MASK_SOLID_BRUSHONLY,
			} )

			render.DrawLine( StartPos, EndPos, color_red )

			Pos = EndPos

			if trace.Hit then
				break
			end
		end
		cam.End3D()

		local TargetPos = Pos:ToScreen()
		local dist = ply:EyePos():Distance(Pos)

		if not TargetPos.visible then return end

		surface.DrawCircle( TargetPos.x, TargetPos.y, 1/(dist*0.0001), color_red )
	end )
	*/
end

DEFINE_BASECLASS( SWEP.Base )