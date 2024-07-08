AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "sh_turretL1.lua" )
AddCSLuaFile( "sh_turretL2.lua" )
AddCSLuaFile( "sh_turretR1.lua" )
AddCSLuaFile( "sh_turretR2.lua" )
AddCSLuaFile( "sh_uturret.lua"  )
include("shared.lua")
include( "sh_turret.lua" )
include( "sh_turretL1.lua" )
include( "sh_turretL2.lua" )
include( "sh_turretR1.lua" )
include( "sh_turretR2.lua" )
include( "sh_uturret.lua" )

function ENT:BetterWeld(ent1, ent2, teleportDistance)
	local constraint = ents.Create("phys_constraint")
	local targetName1 = "lua_ent_" .. ent1:EntIndex()
	local targetName2 = "lua_ent_" .. ent2:EntIndex()
	ent1:SetKeyValue("targetname", targetName1)
	ent2:SetKeyValue("targetname", targetName2)
	constraint:SetKeyValue("attach1", targetName1)
	constraint:SetKeyValue("attach2", targetName2)

	if teleportDistance > 0 then
		constraint:SetKeyValue("teleportfollowdistance", teleportDistance)
	end

	constraint:Spawn()
	constraint:Activate()
	constraint:Fire("TurnOn")

	return constraint
end

---------------------------------------------------------------------- Initialization -------------------------------------------------------------------------------------------

function ENT:SpawnRepulsors()
	local e = ents.Create("prop_dynamic")
	e:SetModel("models/svenman/ut-at/repulsor.mdl")
	e:SetPos(self:GetPos())
	e:SetAngles(self:GetAngles())
	e:SetParent(self)
	e:SetSolid(SOLID_VPHYSICS)
	e:Spawn()
	e:Activate()
	--constraint.NoCollide( e, self, 0, 0 )
	self.Repulsors = e
end

function ENT:SpawnSeats()
	local e = ents.Create("prop_dynamic")
	e:SetModel("models/svenman/ut-at/seats.mdl")
	e:SetPos(self:GetPos())
	e:SetAngles(self:GetAngles())
	e:SetParent(self)
	e:SetSolid(SOLID_VPHYSICS)
	e:Spawn()
	e:Activate()
	--constraint.NoCollide( e, self, 0, 0 )
	self.Seats = e
end

function ENT:SpawnDoors()
	local e = ents.Create("prop_dynamic")
	e:SetModel("models/svenman/ut-at/doors.mdl")
	e:SetPos(self:GetPos())
	e:SetAngles(self:GetAngles())
	e:SetParent(self)
	e:SetSolid(SOLID_NONE)
	e:Spawn()
	e:Activate()
	self.Doors = e
end

function ENT:SpawnInside()
	local e = ents.Create("prop_dynamic")
	e:SetModel("models/svenman/ut-at/inside.mdl")
	e:SetPos(self:GetPos())
	e:SetAngles(self:GetAngles())
	e:SetParent(self)
	e:SetSolid(SOLID_NONE)
	e:Spawn()
	e:Activate()
	self.Inside = e
end

function ENT:SpawnBody()
	local e = ents.Create("prop_dynamic")
	e:SetModel("models/svenman/ut-at/body.mdl")
	e:SetPos(self:GetPos())
	e:SetAngles(self:GetAngles())
	e:SetParent(self)
	e:SetSolid(SOLID_NONE)
	e:Spawn()
	e:Activate()
	self.Body = e
end

function ENT:SpawnCable()
	local e = ents.Create("prop_dynamic")
	e:SetModel("models/svenman/ut-at/cable.mdl")
	e:SetPos(self:GetPos())
	e:SetAngles(self:GetAngles())
	e:SetParent(self)
	e:SetSolid(SOLID_NONE)
	e:Spawn()
	e:Activate()
	self.Cable = e
end


function ENT:SpawnLadderL()

	local bottom = self:GetPos()+Vector(253,345,0)

	local top = self:GetPos()+Vector(253,345,140)

	local ladderEnt = ents.Create("func_useableladder")
	ladderEnt:SetPos(LerpVector(0.5, top, bottom))
	ladderEnt:SetKeyValue("point0", tostring(bottom))
	ladderEnt:SetKeyValue("point1", tostring(top))

	ladderEnt:SetKeyValue("targetname", "ut_at_ladderL" .. ladderEnt:EntIndex())
	ladderEnt:SetParent(self)
	ladderEnt:Spawn()
	ladderEnt:Activate()

	self.LadderL = ladderEnt

end

function ENT:SpawnLadderR()

	local bottom = self:GetPos()+Vector(253,-345,0)

	local top = self:GetPos()+Vector(253,-345,140)

	local ladderEnt = ents.Create("func_useableladder")
	ladderEnt:SetPos(LerpVector(0.5, top, bottom))
	ladderEnt:SetKeyValue("point0", tostring(bottom))
	ladderEnt:SetKeyValue("point1", tostring(top))

	ladderEnt:SetKeyValue("targetname", "ut_at_ladderR" .. ladderEnt:EntIndex())
	ladderEnt:SetParent(self)
	ladderEnt:Spawn()
	ladderEnt:Activate()
	
	self.LadderR = ladderEnt
	
end


function ENT:OnSpawn(PObj)

	PObj:SetMass( 2500 )
	self:SetPos(self:GetPos()+ self:GetUp()*100)
	self:SpawnRepulsors()
	self:SpawnInside()
	self:SpawnCable()
	self:SpawnSeats()
	self:SpawnDoors()
	self:SpawnBody()
	--self:SpawnLadderR()
	--self:SpawnLadderL()

	self:PlayAnimation("doors_open", _, self.Doors)
	self.Repulsors:SetSolid(SOLID_NONE)
	self.Seats:SetSolid(SOLID_VPHYSICS) 

	local DriverSeat = self:AddDriverSeat( Vector(470,0,160), Angle(0,-90,0) )
	DriverSeat.HidePlayer = false
	DriverSeat.ExitPos =  Vector(220,0,100)

	self:GetDriverSeat():SetCameraDistance( 1 )

	local TurretSeat = self:AddPassengerSeat( Vector(-20,0,90), Angle(0,-90,0) )
	self:SetTurretSeat( TurretSeat )
	TurretSeat.ExitPos = Vector(55,0,73)
	
	local TurretL1Seat = self:AddPassengerSeat( Vector(-150.5,60,85), Angle(0,0,0) )
	self:SetTurretL1Seat( TurretL1Seat )
	TurretL1Seat.ExitPos = Vector(-80,60,73)
	
	local TurretL2Seat = self:AddPassengerSeat( Vector(-275,60,85), Angle(0,0,0) )
	self:SetTurretL2Seat( TurretL2Seat )
	TurretL2Seat.ExitPos = Vector(-210,60,73)
	
	local TurretR1Seat = self:AddPassengerSeat( Vector(-150.5,-60,85), Angle(0,-180,0) )
	self:SetTurretR1Seat( TurretR1Seat )
	TurretR1Seat.ExitPos = Vector(-80,-60,73)
	
	local TurretR2Seat = self:AddPassengerSeat( Vector(-275,-60,85), Angle(0,-180,0) )
	self:SetTurretR2Seat( TurretR2Seat )
	TurretR2Seat.ExitPos = Vector(-210,-60,73)
	
	local UnderturretSeat = self:AddPassengerSeat( Vector(353,0,182), Angle(0,-90,0) )
	self:SetUnderturretSeat( UnderturretSeat )
	UnderturretSeat.ExitPos = Vector(220,0,100)
	
	self:AddPassengerSeat( Vector(297,35,113), Angle(0,90,0)).ExitPos = Vector(230,35,100)
	self:AddPassengerSeat( Vector(297,60.5,113), Angle(0,90,0)).ExitPos = Vector(230,60,100)
	self:AddPassengerSeat( Vector(297,86,113), Angle(0,90,0)).ExitPos = Vector(230,86,100)
	self:AddPassengerSeat( Vector(297,112,113), Angle(0,90,0)).ExitPos = Vector(230,112,100)
	self:AddPassengerSeat( Vector(297,139,113), Angle(0,90,0)).ExitPos = Vector(230,139,100)
	self:AddPassengerSeat( Vector(297,165,113), Angle(0,90,0)).ExitPos = Vector(230,165,100)
	self:AddPassengerSeat( Vector(297,190.4,113), Angle(0,90,0)).ExitPos = Vector(230,165,100)
	
	self:AddPassengerSeat( Vector(297,-35,113), Angle(0,90,0)).ExitPos = Vector(230,-35,100)
	self:AddPassengerSeat( Vector(297,-60.5,113), Angle(0,90,0)).ExitPos = Vector(230,-60,100)
	self:AddPassengerSeat( Vector(297,-86,113), Angle(0,90,0)).ExitPos = Vector(230,-86,100)
	self:AddPassengerSeat( Vector(297,-112,113), Angle(0,90,0)).ExitPos = Vector(230,-112,100)
	self:AddPassengerSeat( Vector(297,-139,113), Angle(0,90,0)).ExitPos = Vector(230,-139,100)
	self:AddPassengerSeat( Vector(297,-165,113), Angle(0,90,0)).ExitPos = Vector(230,-165,100)
	self:AddPassengerSeat( Vector(297,-190.4,113), Angle(0,90,0)).ExitPos = Vector(230,-165,100)

	self:AddPassengerSeat( Vector(188,-129,113), Angle(0,0,0)).ExitPos = Vector(188,-62,100)
	self:AddPassengerSeat( Vector(161,-129,113), Angle(0,0,0)).ExitPos = Vector(161,-62,100)
	self:AddPassengerSeat( Vector(139,-129,113), Angle(0,0,0)).ExitPos = Vector(139,-62,100)

	self:AddPassengerSeat( Vector(188,129,113), Angle(0,180,0)).ExitPos = Vector(188,62,100)
	self:AddPassengerSeat( Vector(161,129,113), Angle(0,180,0)).ExitPos = Vector(161,62,100)
	self:AddPassengerSeat( Vector(139,129,113), Angle(0,180,0)).ExitPos = Vector(139,62,100)
	
	self:ManipulateBoneAngles(self:LookupBone("sidecannonR"), Angle(0,0,-21))
	self:ManipulateBoneAngles(self:LookupBone("sidecannonL"), Angle(0,0,-21))
	self:SetLightsOn(false)

	self:InitWheels()
end

function ENT:InitWheels()
	
	local WheelMass = 25
	local WheelRadius = 30
	local WheelPos = {
		Vector(172.5, 230, -0),
		Vector(97	 , 230, -0),
		Vector(21.5 , 230, -0),
		Vector(-54	 , 230, -0),
		Vector(-129.5 , 230, -0),
		Vector(-205   , 230, -0),
		Vector(-280.5 , 230, -0),
		Vector(-356   , 230, -0),
		

		Vector(172.5, -230, -0),
		Vector(97	 , -230, -0),
		Vector(21.5 , -230, -0),
		Vector(-54	 , -230, -0),
		Vector(-129.5 , -230, -0),
		Vector(-205   , -230, -0),
		Vector(-280.5 , -230, -0),
		Vector(-356   , -230, -0),

		Vector(-530   , -246, 0),
		Vector(-530	   , 246, 0),

		Vector(-530   , -246, 64),
		Vector(-530	   , 246, 64),
	}

	for _, Pos in pairs( WheelPos ) do
		self:AddWheel( Pos, WheelRadius, WheelMass, 10 )
	end
end


---------------------------------------------------------------------- OnTick -------------------------------------------------------------------------------------------

--override, because I don't want the engine to start once someone enters the Tank
function ENT:OnDriverChanged( Old, New, VehicleIsActive )

	self:SetEngineActive( false )
	self:SetMove( 0, 0 )
end

function ENT:AnimMove()
	local phys = self:GetPhysicsObject()

	if not IsValid( phys ) then return end

	local steer = phys:GetAngleVelocity().z

	local VelL = self:WorldToLocal( self:GetPos() + self:GetVelocity() )

	self:SetPoseParameter( "move_x", math.Clamp(-VelL.x / self.MaxVelocityX,-1,1) )
	self:SetPoseParameter( "move_y", math.Clamp(-VelL.y / self.MaxVelocityY + steer / 100,-1,1) )
end

function ENT:OnTick()
	if self:GetAI() then self:SetAI( false ) end
	self:AnimMove()
	self:OnTickExtra()
	
end

function ENT:OnCollision( data, physobj )
	if self:WorldToLocal( data.HitPos ).z < 0 then return true end -- dont detect collision  when the lower part of the model touches the ground

	return false
end

function ENT:OnVehicleSpecificToggled( IsActive )
	self:SetLightsOn(IsActive)
	self:EmitSound( "buttons/lightswitch2.wav", 75, 105 )
end

function ENT:OnTickExtra()
	
	self.Body:SetSkin(self:GetSkin())

	if IsValid(self:GetUnderturretDriver()) then

		if self:GetUnderturretDriver():KeyPressed(IN_JUMP) then	
			

			if self.isON then
				self.Inside:SetSkin(1)
				self.Seats:SetSkin(1)
				self.Doors:SetSkin(1)
				self.isON = false
			else
				self.Inside:SetSkin(0)
				self.Seats:SetSkin(0)
				self.Doors:SetSkin(0)
				self.isON = true
			end

		end

	end
	
	
	
	local TurretPod = self:GetTurretSeat()
	if IsValid( TurretPod ) then
		local TurretDriver = TurretPod:GetDriver()
		if TurretDriver ~= self:GetTurretDriver() then
			self:SetTurretDriver( TurretDriver )
		end
	end
	
	local TurretL1Pod = self:GetTurretL1Seat()
	if IsValid( TurretL1Pod ) then
		local TurretL1Driver = TurretL1Pod:GetDriver()
		if TurretL1Driver ~= self:GetTurretL1Driver() then
			self:SetTurretL1Driver( TurretL1Driver )
		end
	end
	
	local TurretL2Pod = self:GetTurretL2Seat()
	if IsValid( TurretL2Pod ) then
		local TurretL2Driver = TurretL2Pod:GetDriver()
		if TurretL2Driver ~= self:GetTurretL2Driver() then
			self:SetTurretL2Driver( TurretL2Driver )
		end
	end
	
	local TurretR1Pod = self:GetTurretR1Seat()
	if IsValid( TurretR1Pod ) then
		local TurretR1Driver = TurretR1Pod:GetDriver()
		if TurretR1Driver ~= self:GetTurretR1Driver() then
			self:SetTurretR1Driver( TurretR1Driver )
		end
	end
	
	local TurretR2Pod = self:GetTurretR2Seat()
	if IsValid( TurretR2Pod ) then
		local TurretR2Driver = TurretR2Pod:GetDriver()
		if TurretR2Driver ~= self:GetTurretR2Driver() then
			self:SetTurretR2Driver( TurretR2Driver )
		end
	end
	
	local UnderturretPod = self:GetUnderturretSeat()
	if IsValid( UnderturretPod ) then
		local UnderturretDriver = UnderturretPod:GetDriver()
		if UnderturretDriver ~= self:GetUnderturretDriver() then
			self:SetUnderturretDriver( UnderturretDriver )
		end
	end

end

function ENT:Explode()
	if self.ExplodedAlready then return end

	self.ExplodedAlready = true

	local Driver = self:GetDriver()

	if IsValid( Driver ) then
		self:HurtPlayer( Driver, 1000, self.FinalAttacker, self.FinalInflictor )
	end

	if istable( self.pSeats ) then
		for _, pSeat in pairs( self.pSeats ) do
			if not IsValid( pSeat ) then continue end

			local psgr = pSeat:GetDriver()
			if not IsValid( psgr ) then continue end

			self:HurtPlayer( psgr, 1000, self.FinalAttacker, self.FinalInflictor )
		end
	end

	local ent = ents.Create( "lvs_ut-at_destruction" )
	if IsValid( ent ) then
		ent:SetModel( self:GetModel() )
		ent:SetPos( self:GetPos() )
		ent:SetAngles( self:GetAngles() )
		ent.GibModels = self.GibModels
		ent.Vel = self:GetVelocity()
		ent:Spawn()
		ent:Activate()
	end

	self:Remove()
end


---------------------------------------------------------------------- Engine -------------------------------------------------------------------------------------------

function ENT:StartEngine()
	if self:GetEngineActive() or not self:IsEngineStartAllowed() then return end


	self:PlayAnimation("doors_close",_, self.Doors)

	--self.LadderL:SetKeyValue("StartDisabled", 1)
	--self.LadderR:SetKeyValue("StartDisabled", 1)

	timer.Simple(0.5, function()
		self.Repulsors:SetSolid(SOLID_VPHYSICS)
		self.Seats:SetSolid(SOLID_NONE) 
		self:ManipulateBoneAngles(self:LookupBone("sidecannonR"), Angle(0,0,0))
		self:ManipulateBoneAngles(self:LookupBone("sidecannonL"),  Angle(0,0,0))
	end)

	self:SetEngineActive( true )
	self:OnEngineActiveChanged( true )
end

function ENT:StopEngine()
	if not self:GetEngineActive() then return end

	self:PlayAnimation("doors_open",_, self.Doors)

	--self.LadderL:SetKeyValue("StartDisabled", 0)
	--self.LadderR:SetKeyValue("StartDisabled", 0)

	self.Repulsors:SetSolid(SOLID_NONE)
	self.Seats:SetSolid(SOLID_VPHYSICS) 
	self:ManipulateBoneAngles(self:LookupBone("sidecannonR"), Angle(0,0,-21))
	self:ManipulateBoneAngles(self:LookupBone("sidecannonL"),  Angle(0,0,-21))

	self:SetEngineActive( false )
	self:OnEngineActiveChanged( false )
end

