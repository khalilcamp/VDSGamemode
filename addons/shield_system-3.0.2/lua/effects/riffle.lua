-- edited version of the normal gmod selection ring
EFFECT.Mat = Material( "effects/select_ring" )

function EFFECT:Init( data )

	local size = 8
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )

	local Pos = data:GetOrigin() + data:GetNormal() * 2

	self:SetPos( Pos )

	-- This 0.01 is a hack.. to prevent the angle being weird and messing up when we change it back to a normal
	self:SetAngles( data:GetNormal():Angle() + Angle( 0.01, 0.01, 0.01 ) )

	self:SetParentPhysNum( data:GetAttachment() )

	if ( IsValid( data:GetEntity() ) ) then
		self:SetParent( data:GetEntity() )
	end

	self.Pos = data:GetOrigin()
	self.Normal = data:GetNormal()

	self.MaxSize = data:GetScale()
	self.Size = 0
	self.Alpha = 255
	self.Speed = math.Rand(0.5, 1.5)
end

function EFFECT:Think()

	self.Alpha = self.Alpha * ( 1 - self.Size / self.MaxSize )
	self.Size = self.Size + FrameTime() * 256 * self.Speed

	if self.Size >= self.MaxSize then return false end
	return true

end

function EFFECT:Render()

	if ( self.Alpha < 1 ) then return end

	render.SetMaterial( self.Mat )

	render.DrawQuadEasy( self.Pos, self:GetAngles():Forward(), self.Size, self.Size, Color( math.Rand( 10, 150 ), math.Rand( 170, 220 ), math.Rand( 240, 255 ), self.Alpha ) )

end
