include("shared.lua")


ENT.EngineFXPos = {
	Vector(-2900,0,-30),
	Vector(-2900,0,-30), 	
	Vector(-2900,-864,-30),
	Vector(-2900,-864,-30),
	Vector(-2900,864,-30),
	Vector(-2900,864,-30),
}

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-1156.11,1335.7,368.39), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-1156.11,-1335.7,368.39), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-1158.6,1335.03,481.42), 0, 20, 2, 2500, 150 )
	self:RegisterTrail( Vector(-1158.6,-1335.03,481.42), 0, 20, 2, 2500, 150 )
end

function ENT:OnFrame()
	self:EngineEffects()
end

ENT.EngineGlow = Material( "sprites/light_glow02_add" )

function ENT:PostDrawTranslucent()
	if not self:GetEngineActive() then return end

	local Size = 700 + self:GetThrottle() * 40 + self:GetBoost() * 0.8

	render.SetMaterial( self.EngineGlow )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,0,-30) ), Size, Size, Color(242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,0,-30) ), Size, Size, Color( 242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,0,-30) ), Size, Size, Color(242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,0,-30) ), Size, Size, Color( 242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,-864,-30) ), Size, Size, Color( 242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,-864,-30) ), Size, Size, Color( 242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,-864,-30) ), Size, Size, Color( 242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,-864,-30) ), Size, Size, Color( 242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,864,-30) ), Size, Size, Color( 242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,864,-30) ), Size, Size, Color( 242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,864,-30) ), Size, Size, Color( 242, 140, 40) )
	render.DrawSprite( self:LocalToWorld( Vector(-2900,864,-30) ), Size, Size, Color( 242, 140, 40) )
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

		particle:SetVelocity( vNormal * math.Rand(2000,1000) + self:GetVelocity() )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 0.1 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(20,25) )
		particle:SetEndSize( math.Rand(0,50) )
		particle:SetRoll( math.Rand(-1,1) * 100 )
		
		particle:SetColor(255, 95, 31)
	end
end

function ENT:OnStartBoost()
	self:EmitSound( "lvs/vehicles/frigates/takeoff2.mp3", 500 )
end

function ENT:OnStopBoost()
	self:EmitSound( "lvs/vehicles/vwing/brake.wav", 120 )
end
