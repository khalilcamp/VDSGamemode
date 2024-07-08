include("shared.lua")
include( "sh_turret.lua" )
include( "sh_turretL1.lua" )
include( "sh_turretL2.lua" )
include( "sh_turretR1.lua" )
include( "sh_turretR2.lua" )
include( "sh_uturret.lua" )
---------------------------------------------------------------------- Views and Perspektiv -------------------------------------------------------------------------------------------

function ENT:DamageFX()
	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local HP = self:GetHP()
		local MaxHP = self:GetMaxHP()

		if HP > MaxHP * 0.5 then return end

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-30,0,43) ) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_engine_blacksmoke", effectdata )

		if HP <= MaxHP * 0.25 then
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( Vector(-85,65,14) ) )
				effectdata:SetNormal( self:GetUp() )
				effectdata:SetMagnitude( math.Rand(0.5,1.5) )
				effectdata:SetEntity( self )
			util.Effect( "lvs_exhaust_fire", effectdata )

			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( Vector(-85,-65,14) ) )
				effectdata:SetNormal( self:GetUp() )
				effectdata:SetMagnitude( math.Rand(0.5,1.5) )
				effectdata:SetEntity( self )
			util.Effect( "lvs_exhaust_fire", effectdata )
		end
	end
end

function ENT:OnFrame()
	self:DamageFX()
end

local white = Color(255,255,255,255)
local red = Color(255,0,0,255)


function ENT:LVSPreHudPaint( X, Y, ply )
	if self:GetIsCarried() then return false end

	if ply == self:GetDriver() then
		
		local Col = self:WeaponsInRange() and white or red


		local Pos2D = self:GetEyeTrace().HitPos:ToScreen() 

		self:PaintCrosshairCenter( Pos2D, Col )
		self:PaintCrosshairOuter( Pos2D, Col )
		self:LVSPaintHitMarker( Pos2D )
	end

	return true
end



---------------------------------------------------------------------- Let there be light -------------------------------------------------------------------------------------------


function ENT:OnRemoved()
	self:RemoveLight()
end

local spotlight = Material( "effects/lvs/laat_spotlight" )
local glow_spotlight = Material( "sprites/light_glow02_add" )


function ENT:RemoveLight()

	if IsValid( self.projector_L1_top ) then
		self.projector_L1_top:Remove()
		self.projector_L1_top = nil
	end

	if IsValid( self.projector_L2_top ) then
		self.projector_L2_top:Remove()
		self.projector_L2_top = nil
	end

	if IsValid( self.projector_L1_bot ) then
		self.projector_L1_bot:Remove()
		self.projector_L1_bot = nil
	end

	if IsValid( self.projector_R1_top ) then
		self.projector_R1_top:Remove()
		self.projector_R1_top = nil
	end

	if IsValid( self.projector_R2_top ) then
		self.projector_R2_top:Remove()
		self.projector_R2_top = nil
	end

	if IsValid( self.projector_R1_bot ) then
		self.projector_R1_bot:Remove()
		self.projector_R1_bot = nil
	end

	if IsValid( self.projector_L1_not ) then
		self.projector_L1_not:Remove()
		self.projector_L1_not = nil
	end

end

function ENT:PreDrawTranslucent()
	
	--------------------------------------------------------------------Frontlights------------------------------------------------------------------------------------------------

	if not self:GetLightsOn() then self:RemoveLight() return end

	if not IsValid( self.projector_L2_top  ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 10 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( true ) 
		thelamp:SetFarZ( 2500 ) 
		thelamp:SetNearZ( 75 ) 
		thelamp:SetFOV( 100 )
		self.projector_L2_top  = thelamp
	end

	if not self.projector_L1_top_ID then
		self.projector_L1_top_ID = self:LookupAttachment( "spot_L1_top" )
		
	else

		local attachment = self:GetAttachment( self.projector_L1_top_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10  , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
		end
	end


	if not self.projector_L2_top_ID then
		self.projector_L2_top_ID = self:LookupAttachment( "spot_L2_top" )
	else
		local attachment = self:GetAttachment( self.projector_L2_top_ID )
		

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10 , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
			if IsValid( self.projector_L2_top ) then
				self.projector_L2_top:SetPos( self:LocalToWorld(Vector(530,0, 200	)))
				self.projector_L2_top:SetAngles( Dir:Angle() )
				self.projector_L2_top:Update()
			end
		end
	end


	if not self.projector_L1_bot_ID then
		self.projector_L1_bot_ID = self:LookupAttachment( "spot_L1_bot" )
	else
		local attachment = self:GetAttachment( self.projector_L1_bot_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10 , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
		end
	end

	
	if not self.projector_R1_top_ID then
		self.projector_R1_top_ID = self:LookupAttachment( "spot_R1_top" )
	else
		local attachment = self:GetAttachment( self.projector_R1_top_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10 , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
		end
	end


	if not self.projector_R2_top_ID then
		self.projector_R2_top_ID = self:LookupAttachment( "spot_R2_top" )
	else
		local attachment = self:GetAttachment( self.projector_R2_top_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10 , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
			
		end
	end

	
	if not self.projector_R1_bot_ID then
		self.projector_R1_bot_ID = self:LookupAttachment( "spot_R1_bot" )
	else
		local attachment = self:GetAttachment( self.projector_R1_bot_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10 , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
		end
	end

	return false

end


/*
function ENT:PaintZoom( X, Y, ply )
	local TargetZoom = ply:lvsKeyDown( "ZOOM" ) and 1 or 0

	zoom = zoom + (TargetZoom - zoom) * RealFrameTime() * 10

	X = X * 0.5
	Y = Y * 0.5

	surface.SetDrawColor( Color(255,255,255,255 * zoom) )
	surface.SetMaterial(zoom_mat ) 
	surface.DrawTexturedRectRotated( X + X * 0.5, Y * 0.5, X, Y, 0 )
	surface.DrawTexturedRectRotated( X + X * 0.5, Y + Y * 0.5, Y, X, 270 )
	surface.DrawTexturedRectRotated( X * 0.5, Y * 0.5, Y, X, 90 )
	surface.DrawTexturedRectRotated( X * 0.5, Y + Y * 0.5, X, Y, 180 )
end

function ENT:LVSHudPaint( X, Y, ply )
	if self:GetIsCarried() then return end

	if ply ~= self:GetDriver() then
		local pod = ply:GetVehicle()

		if pod == self:GetTurretSeat() then
			self:PaintZoom( X, Y, ply )
		end

		return
	end

	local Pos2D = self:GetEyeTrace().HitPos:ToScreen()

	local _,_, InRange = self:GetAimAngles()

	local Col = InRange and white or red

	self:PaintCrosshairCenter( Pos2D, Col )
	self:PaintCrosshairOuter( Pos2D, Col )
	self:LVSPaintHitMarker( Pos2D )

	self:PaintZoom( X, Y, ply )
end

ENT.IconEngine = Material( "lvs/engine.png" )

function ENT:LVSHudPaintInfoText( X, Y, W, H, ScrX, ScrY, ply )
	local Vel = self:GetVelocity():Length()
	local kmh = math.Round(Vel * 0.09144,0)

	draw.DrawText( "km/h ", "LVS_FONT", X + 72, Y + 35, color_white, TEXT_ALIGN_RIGHT )
	draw.DrawText( kmh, "LVS_FONT_HUD_LARGE", X + 72, Y + 20, color_white, TEXT_ALIGN_LEFT )

	if ply ~= self:GetDriver() then return end

	local hX = X + W - H * 0.5
	local hY = Y + H * 0.25 + H * 0.25

	surface.SetMaterial( self.IconEngine )
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawTexturedRectRotated( hX + 4, hY + 1, H * 0.5, H * 0.5, 0 )
	surface.SetDrawColor( color_white )
	surface.DrawTexturedRectRotated( hX + 2, hY - 1, H * 0.5, H * 0.5, 0 )

	if self:GetIsCarried() then
		draw.SimpleText( "X" , "LVS_FONT",  hX, hY, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	else
		local Throttle = Vel / 150
		self:LVSDrawCircle( hX, hY, H * 0.35, math.min( Throttle, 1 ) )
	end
end



function ENT:RemoveLight()
	if IsValid( self.projector ) then
		self.projector:Remove()
		self.projector = nil
	end
end

function ENT:OnRemoved()
	self:RemoveLight()
end


ENT.LightMaterial = Material( "effects/lvs/laat_spotlight" )
ENT.GlowMaterial = Material( "sprites/light_glow02_add" )

*/
/*

function ENT:LFSCalcViewFirstPerson( view,ply )
	return self:LFSCalcViewThirdPerson( view, ply, true )
end

function ENT:LFSCalcViewThirdPerson( view, ply, FirstPerson )
	local Pod = ply:GetVehicle()
	
	if FirstPerson then
		view.origin = view.origin
		return view
	end
	
	if ply == self:GetTurretL1Driver() then
		self:ThirdPersonPerspectivTurret("turretL1",Vector(0,0,10),100,ply,view,self)
	end

	if ply == self:GetTurretL2Driver() then
		self:ThirdPersonPerspectivTurret("turretL2",Vector(0,0,10),100,ply,view,self)
	end

	if ply == self:GetTurretR1Driver() then
		self:ThirdPersonPerspectivTurret("turretR1",Vector(0,0,10),100,ply,view,self)
	end

	if ply == self:GetTurretR2Driver() then
		self:ThirdPersonPerspectivTurret("turretR2",Vector(0,0,10),100,ply,view,self)
	end
	
	if ply == self:GetUnderturretDriver() then
		self:ThirdPersonPerspectivTurret("underturretL",Vector(0,0,10),100,ply,view,self)
	end
	
	if ply == self:GetTurretDriver() then
		self:ThirdPersonPerspectivTurret("frontcannon",Vector(0,0,10),100,ply,view,self)
	end	

	return view
end

function ENT:ThirdPersonPerspectivTurret(attachment,adjustment,radius,ply,view,self)

	local views = Vector(0,0,0)
	local radius = radius or 100
	local viewbone = self:GetAttachment(self:LookupAttachment( attachment))

	view.origin = viewbone.Pos + adjustment
	
	local Zoom = ply:KeyDown( IN_ATTACK2 ) or ply:KeyDown( IN_ZOOM )
	local Rate = FrameTime() * 5
		
	self.Zoomin = isnumber( self.Zoomin ) and self.Zoomin + math.Clamp((Zoom and 1 or 0) - self.Zoomin,-Rate,Rate) or 0
	view.fov = 75 - 30 * self.Zoomin

	radius = radius * (1 - self.Zoomin) + 100 * self.Zoomin

	view.angles.x = viewbone.Ang.z -90
	view.angles.y = viewbone.Ang.y -90


	local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
	local WallOffset = 4

	local tr = util.TraceHull( {
		start = view.origin,
		endpos = TargetOrigin,
		filter = function( e )
			local c = e:GetClass()
			local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS
			
			return collide
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )
	
	view.origin = tr.HitPos
	
	if tr.Hit and not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end
	
end

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-100,0,40) ) )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	return self:LFSCalcViewThirdPerson( view, ply, true )
end

function ENT:LFSCalcViewThirdPerson( view, ply, FirstPerson )
	local Pod = ply:GetVehicle()
	
	if FirstPerson then
		view.origin = view.origin
		return view
	end
	
	if ply == self:GetTurretL1Driver() then
		self:ThirdPersonPerspectivTurret("turretL1",Vector(0,0,10),100,ply,view,self)
	end

	if ply == self:GetTurretL2Driver() then
		self:ThirdPersonPerspectivTurret("turretL2",Vector(0,0,10),100,ply,view,self)
	end

	if ply == self:GetTurretR1Driver() then
		self:ThirdPersonPerspectivTurret("turretR1",Vector(0,0,10),100,ply,view,self)
	end

	if ply == self:GetTurretR2Driver() then
		self:ThirdPersonPerspectivTurret("turretR2",Vector(0,0,10),100,ply,view,self)
	end
	
	if ply == self:GetUnderturretDriver() then
		self:ThirdPersonPerspectivTurret("underturretL",Vector(0,0,10),100,ply,view,self)
	end
	
	if ply == self:GetTurretDriver() then
		self:ThirdPersonPerspectivTurret("frontcannon",Vector(0,0,10),100,ply,view,self)
	end	

	return view
end

function ENT:ThirdPersonPerspectivTurret(attachment,adjustment,radius,ply,view,self)

	local views = Vector(0,0,0)
	local radius = radius or 100
	local viewbone = self:GetAttachment(self:LookupAttachment( attachment))

	view.origin = viewbone.Pos + adjustment
	
	local Zoom = ply:KeyDown( IN_ATTACK2 ) or ply:KeyDown( IN_ZOOM )
	local Rate = FrameTime() * 5
		
	self.Zoomin = isnumber( self.Zoomin ) and self.Zoomin + math.Clamp((Zoom and 1 or 0) - self.Zoomin,-Rate,Rate) or 0
	view.fov = 75 - 30 * self.Zoomin

	radius = radius * (1 - self.Zoomin) + 100 * self.Zoomin

	view.angles.x = viewbone.Ang.z -90
	view.angles.y = viewbone.Ang.y -90


	local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
	local WallOffset = 4

	local tr = util.TraceHull( {
		start = view.origin,
		endpos = TargetOrigin,
		filter = function( e )
			local c = e:GetClass()
			local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS
			
			return collide
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )
	
	view.origin = tr.HitPos
	
	if tr.Hit and not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end
	
end


function ENT:LFSHudPaintPassenger( X, Y, ply )

	if ply == self:GetTurretL1Driver() then
		HUDPaint("turretL1",self:GetAmmoPrimary(),self,"PRI",X,Y)
	end

	if ply == self:GetTurretL2Driver() then
		HUDPaint("turretL2",self:GetAmmoPrimary(),self,"PRI",X,Y)
	end

	if ply == self:GetTurretR1Driver() then
		HUDPaint("turretR1",self:GetAmmoPrimary(),self,"PRI",X,Y)
	end

	if ply == self:GetTurretR2Driver() then
		HUDPaint("turretR2",self:GetAmmoPrimary(),self,"PRI",X,Y)
	end
	
	if ply == self:GetUnderturretDriver() then
		HUDPaint("underturretL",self:GetAmmoPrimary(),self,"PRI",X,Y)
	end
	
	if ply == self:GetTurretDriver() then
		HUDPaint("frontcannon",self:GetAmmoSecondary(),self,"SEC",X,Y)
	end
		
end

function HUDPaint(attachment,ammotype,self,ammotext,X,Y)
	draw.SimpleText( ammotext, "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( ammotype, "LFS_FONT", 120, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
	local ID = self:LookupAttachment( attachment )
	local Muzzle = self:GetAttachment( ID )

	if Muzzle then
		local startpos = Muzzle.Pos
		local Trace = util.TraceHull( {
			start = startpos,
			endpos = (startpos + Muzzle.Ang:Up() * 50000),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = function( ent ) if ent == self or ent:GetClass() == "lunasflightschool_missile" then return false end return true end
		} )
		local HitPos = Trace.HitPos:ToScreen()

		local X = HitPos.x
		local Y = HitPos.y

		if self:GetIsCarried() then
			surface.SetDrawColor( 255, 0, 0, 255 )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
		end
		
		simfphys.LFS.DrawCircle( X, Y, 10 )
		surface.DrawLine( X + 10, Y, X + 20, Y ) 
		surface.DrawLine( X - 10, Y, X - 20, Y ) 
		surface.DrawLine( X, Y + 10, X, Y + 20 ) 
		surface.DrawLine( X, Y - 10, X, Y - 20 ) 
		
	
		surface.SetDrawColor( 0, 0, 0, 80 )
		simfphys.LFS.DrawCircle( X + 1, Y + 1, 10 )
		surface.DrawLine( X + 11, Y + 1, X + 21, Y + 1 ) 
		surface.DrawLine( X - 9, Y + 1, X - 16, Y + 1 ) 
		surface.DrawLine( X + 1, Y + 11, X + 1, Y + 21 ) 
		surface.DrawLine( X + 1, Y - 19, X + 1, Y - 16 ) 
	end

end

function ENT:LFSHudPaint( X, Y, data, ply ) -- driver only
end

function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
	draw.SimpleText( "SPEED", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( speed.."km/h", "LFS_FONT", 120, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	draw.SimpleText( "PRI", "LFS_FONT", 10, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( AmmoPrimary, "LFS_FONT", 120, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
	draw.SimpleText( "SEC", "LFS_FONT", 10, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( AmmoSecondary, "LFS_FONT", 120, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "ut-at_engine" )
		self.ENG:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
	self:RemoveLight()
end

---------------------------------------------------------------------- Let there be light -------------------------------------------------------------------------------------------

function ENT:RemoveLight()

	if IsValid( self.projector_L1_top ) then
		self.projector_L1_top:Remove()
		self.projector_L1_top = nil
	end

	if IsValid( self.projector_L2_top ) then
		self.projector_L2_top:Remove()
		self.projector_L2_top = nil
	end

	if IsValid( self.projector_L1_bot ) then
		self.projector_L1_bot:Remove()
		self.projector_L1_bot = nil
	end

	if IsValid( self.projector_R1_top ) then
		self.projector_R1_top:Remove()
		self.projector_R1_top = nil
	end

	if IsValid( self.projector_R2_top ) then
		self.projector_R2_top:Remove()
		self.projector_R2_top = nil
	end

	if IsValid( self.projector_R1_bot ) then
		self.projector_R1_bot:Remove()
		self.projector_R1_bot = nil
	end

	if IsValid( self.projector_L1_not ) then
		self.projector_L1_not:Remove()
		self.projector_L1_not = nil
	end

end

local spotlight = Material( "effects/lfs_base/spotlight_projectorbeam" )
local glow_spotlight = Material( "sprites/light_glow02_add" )


function ENT:Draw()
	self:DrawModel()
	
	--------------------------------------------------------------------Frontlights------------------------------------------------------------------------------------------------

	if not self:GetLightsOn() then self:RemoveLight() return end


	if not IsValid( self.projector_L1_top  ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 10 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( false )
		thelamp:SetFarZ( 5000 ) 
		thelamp:SetNearZ( 75 ) 
		thelamp:SetFOV( 40 )
		self.projector_L1_top  = thelamp
	end

	if not IsValid( self.projector_L2_top  ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 10 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( false ) 
		thelamp:SetFarZ( 5000 ) 
		thelamp:SetNearZ( 75 ) 
		thelamp:SetFOV( 40 )
		self.projector_L2_top  = thelamp
	end

	if not IsValid( self.projector_L1_bot  ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 10 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( false ) 
		thelamp:SetFarZ( 5000 ) 
		thelamp:SetNearZ( 75 ) 
		thelamp:SetFOV( 40 )
		self.projector_L1_bot  = thelamp
	end

	if not IsValid( self.projector_R1_top  ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 10 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( false ) 
		thelamp:SetFarZ( 5000 ) 
		thelamp:SetNearZ( 75 ) 
		thelamp:SetFOV( 40 )
		self.projector_R1_top  = thelamp
	end

	if not IsValid( self.projector_R2_top  ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 10 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( false ) 
		thelamp:SetFarZ( 5000 ) 
		thelamp:SetNearZ( 75 ) 
		thelamp:SetFOV( 40 )
		self.projector_R2_top  = thelamp
	end

	if not IsValid( self.projector_R1_bot  ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 10 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( false ) 
		thelamp:SetFarZ( 5000 ) 
		thelamp:SetNearZ( 75 ) 
		thelamp:SetFOV( 40 )
		self.projector_R1_bot  = thelamp
	end


	if not self.projector_L1_top_ID then
		self.projector_L1_top_ID = self:LookupAttachment( "spot_L1_top" )
		
	else

		local attachment = self:GetAttachment( self.projector_L1_top_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10  , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
			if IsValid( self.projector_L1_top ) then
				self.projector_L1_top:SetPos( StartPos )
				self.projector_L1_top:SetAngles( Dir:Angle() )
				self.projector_L1_top:Update()
			end
		end
	end


	if not self.projector_L2_top_ID then
		self.projector_L2_top_ID = self:LookupAttachment( "spot_L2_top" )
	else
		local attachment = self:GetAttachment( self.projector_L2_top_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10 , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
			if IsValid( self.projector_L2_top ) then
				self.projector_L2_top:SetPos( StartPos )
				self.projector_L2_top:SetAngles( Dir:Angle() )
				self.projector_L2_top:Update()
			end
		end
	end


	if not self.projector_L1_bot_ID then
		self.projector_L1_bot_ID = self:LookupAttachment( "spot_L1_bot" )
	else
		local attachment = self:GetAttachment( self.projector_L1_bot_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10 , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
			if IsValid( self.projector_L1_bot ) then
				self.projector_L1_bot:SetPos( StartPos )
				self.projector_L1_bot:SetAngles( Dir:Angle() )
				self.projector_L1_bot:Update()
			end
		end
	end

	
	if not self.projector_R1_top_ID then
		self.projector_R1_top_ID = self:LookupAttachment( "spot_R1_top" )
	else
		local attachment = self:GetAttachment( self.projector_R1_top_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10 , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
			if IsValid( self.projector_R1_top ) then
				self.projector_R1_top:SetPos( StartPos )
				self.projector_R1_top:SetAngles( Dir:Angle() )
				self.projector_R1_top:Update()
			end
		end
	end


	if not self.projector_R2_top_ID then
		self.projector_R2_top_ID = self:LookupAttachment( "spot_R2_top" )
	else
		local attachment = self:GetAttachment( self.projector_R2_top_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10 , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
			if IsValid( self.projector_R2_top ) then
				self.projector_R2_top:SetPos( StartPos )
				self.projector_R2_top:SetAngles( Dir:Angle() )
				self.projector_R2_top:Update()
			end
		end
	end

	
	if not self.projector_R1_bot_ID then
		self.projector_R1_bot_ID = self:LookupAttachment( "spot_R1_bot" )
	else
		local attachment = self:GetAttachment( self.projector_R1_bot_ID )

		if attachment then
			local StartPos = attachment.Pos
			local Dir = attachment.Ang:Up()

			render.SetMaterial( glow_spotlight )
			render.DrawSprite( StartPos + Dir * 10 , 200, 200, Color( 240, 200, 0, 255) )

			render.SetMaterial( spotlight )
			render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 1500, 350, 0, 0.99, Color( 240, 200, 0, 10) ) 
			
			if IsValid( self.projector_R1_bot ) then
				self.projector_R1_bot:SetPos( StartPos )
				self.projector_R1_bot:SetAngles( Dir:Angle() )
				self.projector_R1_bot:Update()
			end
		end
	end

end
*/
-- made by me -svenman
