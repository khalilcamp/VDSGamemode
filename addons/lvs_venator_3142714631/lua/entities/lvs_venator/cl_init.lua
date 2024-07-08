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
	self:DamageFX()
end

ENT.EngineGlow = Material( "sprites/glow04_noz_gmod" )

function ENT:PostDrawTranslucent()
	if not self:GetEngineActive() then return end

	local Siz = 1100 + self:GetThrottle() * 1 + self:GetBoost() * 2
	
	local Size = 800 + self:GetThrottle() * 1 + self:GetBoost() * 2
	
	local Si = 200 + self:GetThrottle() * 1 + self:GetBoost() * 2
	
	local S = 450 + self:GetThrottle() * 1 + self:GetBoost() * 2
	
	
	
	render.SetMaterial( self.EngineGlow )
	render.DrawSprite( self:LocalToWorld( Vector(-3250, -640,450) ), Siz, Siz, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-3250, 640,450) ), Siz, Siz, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-3250, 540,450) ), Siz, Siz, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-3250, -540,450) ), Siz, Siz, Color( 0, 191, 255) )
	
	render.DrawSprite( self:LocalToWorld( Vector(-2050, 1150,540) ), Size, Size, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-2050, 1150,540) ), Size, Size, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-2050, -1150,540) ), Size, Size, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-2050, -1150,540) ), Size, Size, Color( 0, 191, 255) )
	
	render.DrawSprite( self:LocalToWorld( Vector(-1300, -1080,870) ), Si, Si, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1300, -1080,870) ), Si, Si, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1300, 1060,870) ), Si, Si, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-1300, 1060,870) ), Si, Si, Color( 0, 191, 255) )
	
	render.DrawSprite( self:LocalToWorld( Vector(-2100, -510,890) ), S, S, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-2100, -510,890) ), S, S, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-2100, 480,890) ), S, S, Color( 0, 191, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-2100, 480,890) ), S, S, Color( 0, 191, 255) )
	
	
	
	
	
	

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

function ENT:DamageFX()
	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05

		local HP = self:GetHP()
		local MaxHP = self:GetMaxHP()

		if HP > MaxHP * 0.5 then return end

		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(1026.3,-279.69,2501.65) ) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_defence_smallsmoke", effectdata )
		
	
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(6526.3,409.69,761.65) ) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_defence_smoke", effectdata )
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(2526.3,0,350) ) )
			effectdata:SetEntity( self )
		util.Effect( "lvs_defence_smoke", effectdata )
		
		
		
		



		

			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( Vector(3486.3,-899.69,861.65) ) )
				effectdata:SetNormal( self:GetUp() )
				effectdata:SetMagnitude( math.Rand(14.5,10) )
				effectdata:SetEntity( self )
			util.Effect( "lvs_defence_smoke", effectdata )
			
			
			
			
			
			
		
			
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( Vector(-286.3,1499.69,961.65) ) )
				effectdata:SetNormal( self:GetUp() )
				effectdata:SetMagnitude( math.Rand(104.5,100) )
				effectdata:SetEntity( self )
			util.Effect( "lvs_defence_smoke", effectdata )
			
			
		


		
		
	end
end


function ENT:OnStartBoost()
	self:EmitSound( "lvs/vehicles/startup1.wav", 85 )
end

function ENT:OnStopBoost()
	self:EmitSound( "lvs/vehicles/vwing/brake.wav", 85 )
end
