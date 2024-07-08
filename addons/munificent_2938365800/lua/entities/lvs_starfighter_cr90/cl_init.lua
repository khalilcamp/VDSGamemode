include("shared.lua")


ENT.EngineFXPos = {
	Vector(-1901.7,0,1225),
	Vector(-1901.7,130,1020.7),
	Vector(-1901.7,-130,1020.7),
	Vector(-1720,240, 840),
	Vector(-1720,-240, 840),
	Vector(-1401,105,750.2),
	Vector(-1401,-105,750.2),
}

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-1901.7,0,1225), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-1901.7,130,1020.7), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-1901.7,-130,1020.7), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-1720,240, 840), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-1720,-240, 840), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-1401,105,750.2), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-1401,-105,743.16), 0, 20, 2, 2500, 150 )
end

function ENT:OnFrame()
	self:EngineEffects()
end

ENT.EngineGlow = Material( "sprites/light_glow02_add" )

function ENT:PostDrawTranslucent()
	if not self:GetEngineActive() then return end

	local Size = 250 + self:GetThrottle() * 40 + self:GetBoost() * 0.8
	
	local Siz = 650 + self:GetThrottle() * 40 + self:GetBoost() * 0.8
	
	local Si = 450 + self:GetThrottle() * 40 + self:GetBoost() * 0.8

	render.SetMaterial( self.EngineGlow )
	render.DrawSprite( self:LocalToWorld( Vector(-1901.7,0,1225) ), Siz, Siz, Color( 10,108,255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1901.7,130,1020.7) ), Siz, Siz, Color(10,108,255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1901.7,-130,1020.7) ), Siz, Siz, Color( 10,108,255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1720,240, 840) ), Si, Si, Color( 10,108,255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1720,-240, 840) ), Si, Si, Color( 10,108,255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1401,105,750.2) ), Size, Size, Color( 10,108,255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1401,-105,743.16) ), Size, Size, Color( 10,108,255) )
end

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end

	local T = CurTime()

	if (self.nextEFX or 0) > T then return end

	self.nextEFX = T + 0.01

	local THR = self:GetThrottle()

	local emitter = self:GetParticleEmitter( self:GetPos() )

	if not IsValid( emitter ) then return end

	for _, v in pairs( self.EngineFXPos ) do
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
		particle:SetStartSize( math.Rand(15,25) )
		particle:SetEndSize( math.Rand(0,50) )
		particle:SetRoll( math.Rand(-1,1) * 100 )
		
		particle:SetColor( 0,0,255 )
	end
end

function ENT:OnStopBoost()
	self:EmitSound( "lvs/vehicles/vwing/brake.wav", 185 )
end
