--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile()

ENT.Type            = "anim"

if CLIENT then
	function ENT:Initialize()
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
		util.Effect( "lfs_explosion_capital", effectdata )
	end
	
	function ENT:OnRemove()
	end
	
	function ENT:Draw()
	end
end

if SERVER then
	function ENT:Initialize()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false ) 
		
		local gibs = {
			"models/XQM/wingpiece2.mdl",
		}
		
		self.GibModels = istable( self.GibModels ) and self.GibModels or gibs
		
		self.Gibs = {}
		self.DieTime = CurTime() + 30


		
		for _, v in pairs( self.GibModels ) do
			local ent = ents.Create( "prop_physics" )
			
			if IsValid( ent ) then
				table.insert( self.Gibs, ent ) 
				
				ent:SetPos( self:GetPos() )
				ent:SetAngles( self:GetAngles() )
				ent:SetModel( v )
				ent:Spawn()
				ent:SetBodygroup( 1, 1 ) 	
				ent:Activate()


				
				local PhysObj = ent:GetPhysicsObject()
				if IsValid( PhysObj ) then
					PhysObj:SetVelocityInstantaneous( VectorRand() * 41 )
					PhysObj:AddAngleVelocity( VectorRand() * 10 ) 
					PhysObj:EnableDrag( false ) 
				end
		
				ent.particleeffect = ents.Create( "info_particle_system" )
				ent.particleeffect:SetKeyValue( "effect_name" , "fire_small_03")
				ent.particleeffect:SetKeyValue( "start_active" , 1)
				ent.particleeffect:SetOwner( ent )
				ent.particleeffect:SetPos( ent:GetPos() )
				ent.particleeffect:SetAngles( ent:GetAngles() )
				ent.particleeffect:SetParent( ent )
				ent.particleeffect:Spawn()
				ent.particleeffect:Activate()
				ent.particleeffect:Fire( "Stop", "", math.random(1,59) )
				
				timer.Simple( 45 + math.Rand(0,0.5), function()
					if not IsValid( ent ) then return end
					ent:SetRenderFX( kRenderFxFadeFast  ) 
				end)
			end
		end
	end

	function ENT:Think()
		if self.DieTime < CurTime() then
			self:Remove()
		end

		
		self:NextThink( CurTime() )
		return true
	end

	function ENT:OnRemove()
		if istable( self.Gibs ) then
			for _, v in pairs( self.Gibs ) do
				if IsValid( v ) then
					v:Remove()
				end
			end
		end
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	function ENT:PhysicsCollide( data, physobj )
	end
end