include("shared.lua")

function ENT:CalcViewOverride( ply, pos, angles, fov, pod )
	if self:GetDriver() == ply and not pod:GetThirdPersonMode() then
		local newpos = pos + self:GetForward() * 147 + self:GetUp() * 8

		return newpos, angles, fov
	else
		return pos, angles, fov
	end
end



function ENT:OnSpawn()
	self:RegisterTrail( Vector(-995.7,289.01,90.79), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-997.81,96.27,90.7), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-989.72,-97.46,90.44), 0, 20, 2, 2500, 150 )
	
end

function ENT:OnFrame()
	self:EngineEffects()
end

ENT.EngineColor = Color( 255, 220, 150, 255)
ENT.EngineGlow = Material( "sprites/light_glow02_add" )
ENT.EngineCenter = Material( "vgui/circle" )
ENT.EnginePos = {
	[1] = Vector(-4700,32,1292),
	[2] = Vector(-4580,-345,1140),
	[3] = Vector(-4580,405,1130)
}

function ENT:PostDraw()
	if not self:GetEngineActive() then return end

	cam.Start3D2D( self:LocalToWorld( Vector(-4650,32,1292) ), self:LocalToWorldAngles( Angle(-90,0,0) ), 1 )
		surface.SetDrawColor( self.EngineColor )
		surface.SetMaterial( self.EngineCenter )
		surface.DrawTexturedRectRotated( 0, 0, 20, 20 , 0 )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( self.EngineGlow )
		surface.DrawTexturedRectRotated( 0, 0, 20, 20 , 0 )
	cam.End3D2D()
	
	cam.Start3D2D( self:LocalToWorld( Vector(-4530,-345,1140) ), self:LocalToWorldAngles( Angle(-90,0,0) ), 1 )
		surface.SetDrawColor( self.EngineColor )
		surface.SetMaterial( self.EngineCenter )
		surface.DrawTexturedRectRotated( 0, 0, 20, 20 , 0 )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( self.EngineGlow )
		surface.DrawTexturedRectRotated( 0, 0, 20, 20 , 0 )
	cam.End3D2D()
	
	cam.Start3D2D( self:LocalToWorld( Vector(-4530,405,1130) ), self:LocalToWorldAngles( Angle(-90,0,0) ), 1 )
		surface.SetDrawColor( self.EngineColor )
		surface.SetMaterial( self.EngineCenter )
		surface.DrawTexturedRectRotated( 0, 0, 20, 20 , 0 )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( self.EngineGlow )
		surface.DrawTexturedRectRotated( 0, 0, 20, 20 , 0 )
	cam.End3D2D()
end

function ENT:PostDrawTranslucent()
	if not self:GetEngineActive() then return end

	local Size = 100 + self:GetThrottle() * 60 + self:GetBoost()

	render.SetMaterial( self.EngineGlow )

	for _, pos in pairs( self.EnginePos ) do
		render.DrawSprite(  self:LocalToWorld( pos ), Size, Size, self.EngineColor )
	end
end

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end

	local T = CurTime()

	if (self.nextEFX or 0) > T then return end

	self.nextEFX = T + 0.01

	local THR = self:GetThrottle()

	local emitter = self:GetParticleEmitter( self:GetPos() )

	if not IsValid( emitter ) then return end

	for _, v in pairs( self.EnginePos ) do
		local Sub = Mirror and 1 or -1
		local vOffset = self:LocalToWorld( v )
		local vNormal = -self:GetForward()

		vOffset = vOffset + vNormal * 5

		local particle = emitter:Add( "effects/muzzleflash2", vOffset )

		if not particle then continue end

		particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 0.1 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(15,45) )
		particle:SetEndSize( math.Rand(100,150) )
		particle:SetRoll( math.Rand(-1,1) * 100 )
		
		particle:SetColor( 255, 200, 50 )
	end
end
function ENT:OnStartBoost()
	self:EmitSound( "lvs/vehicles/startup1.wav", 85 )
end

function ENT:OnStopBoost()
	self:EmitSound( "lvs/vehicles/vwing/brake.wav", 85 )
end
