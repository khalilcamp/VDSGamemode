
EFFECT.MatSmoke = {
	"particle/smokesprites_0001",
	"particle/smokesprites_0002",
	"particle/smokesprites_0003",
	"particle/smokesprites_0004",
	"particle/smokesprites_0005",
	"particle/smokesprites_0006",
	"particle/smokesprites_0007",
	"particle/smokesprites_0008",
	"particle/smokesprites_0009",
	"particle/smokesprites_0010",
	"particle/smokesprites_0011",
	"particle/smokesprites_0012",
	"particle/smokesprites_0013",
	"particle/smokesprites_0014",
	"particle/smokesprites_0015",
	"particle/smokesprites_0016"
}

function EFFECT:Init( data )
	local pos  = data:GetOrigin()

	local emitter = ParticleEmitter( pos, false )

	if not emitter then return end

	local VecCol = (render.GetLightColor( pos ) * 0.8 + Vector(0.2,0.2,0.2)) * 255

	for i = 0,2 do
		local particle = emitter:Add( self.MatSmoke[math.random(1,#self.MatSmoke)], pos )

		if not particle then continue end

		particle:SetVelocity( VectorRand() * 200 )
		particle:SetDieTime( math.Rand(4,6) )
		particle:SetAirResistance( 150 ) 
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( 100 )
		particle:SetEndSize( 200 )
		particle:SetRollDelta( math.Rand(-1,1) )
		particle:SetColor( math.min( VecCol.r, 70 ), math.min( VecCol.g, 70 ), math.min( VecCol.b, 70 ) )
		particle:SetGravity( VectorRand() * 250 )
		particle:SetCollide( true )
		particle:SetBounce( 1 )
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
