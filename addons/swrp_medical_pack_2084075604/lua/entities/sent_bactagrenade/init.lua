AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
 
function ENT:Initialize()
 
    self.Entity:SetModel( "models/addoncontent/bactagrenade/bactagrenade.mdl" )
 
	self.Entity:PhysicsInit( SOLID_BSP )
    self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
    self.Entity:SetSolid( SOLID_BSP )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
    self.Entity:SetColor( Color( 255, 255, 255, 255 ) )
        
    self.Index = self.Entity:EntIndex()
        
    local phys = self.Entity:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end
 
function ENT:PhysicsCollide( data, physobj )
	local blasted = ents.FindInSphere( self.Entity:GetPos(), 500 )

	for k, v in pairs( blasted ) do
		if ( SERVER ) then
			if v:IsPlayer() then
				if v:Health() < v:GetMaxHealth() then
					v:SetHealth( math.Clamp( v:Health() + v:GetMaxHealth() * 0.1, 0, v:GetMaxHealth() ) )
				end
			end
		end
	end

	self.Entity:EmitSound("addoncontent/bactagrenade/bactagrenade.wav", 75, 50)

	local effectdata = EffectData() 
	effectdata:SetOrigin( self.Entity:GetPos() )
	util.Effect("effect_bactanade",effectdata)

	self.Entity:Remove()
end