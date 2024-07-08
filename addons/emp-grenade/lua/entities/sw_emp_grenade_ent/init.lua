AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/thejoe/w_emp.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:DrawShadow( true )
end

function ENT:Think()
	if not self.ExplodeTimer then return end
	if self.ExplodeTimer <= CurTime() then
		self:Explode()
		self:Remove()
	end
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:PhysicsCollide( data )
	if SERVER and not self.isrolled then
		self:Explode()
		self:Remove()
	end
end

function ENT:OnRemove()
end

function ENT:Explode()
	self:EmitSound("ambient/energy/weld1.wav")
	local entpos = self:GetPos() 

	self:EmitSound("")

	timer.Simple(math.Rand(0.1,0.3), function()
		for i=1,10 do
			local lightning = ents.Create( "point_tesla" )
			lightning:SetPos(entpos + Vector(0,0,1))
			lightning:SetKeyValue("m_SoundName", "")
			lightning:SetKeyValue("texture", "sprites/bluelight1.spr")
			lightning:SetKeyValue("m_Color", "255 255 150")
			lightning:SetKeyValue("m_flRadius", "100")
			lightning:SetKeyValue("beamcount_max", "25")
			lightning:SetKeyValue("thick_min", "10")
			lightning:SetKeyValue("thick_max", "20")
			lightning:SetKeyValue("lifetime_min", "0.3")
			lightning:SetKeyValue("lifetime_max", "0.7")
			lightning:SetKeyValue("interval_min", "0.15")
			lightning:SetKeyValue("interval_max", "0.25")
			lightning:Spawn()
			lightning:Fire("DoSpark", "", 0)
			lightning:Fire("kill", "", 0.7)
		end
	end)

	EMPGrenade:HandleShock(self,entpos)
end

function ENT:OnTakeDamage( dmginfo )
	self:Explode()
	self:Remove()
end