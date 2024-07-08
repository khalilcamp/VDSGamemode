AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.SpawnNormalOffset = 25

function ENT:OnSpawn( PObj )
	PObj:SetMass( 120000 )

	local DriverSeat = self:AddDriverSeat( Vector(3260,-0.5,1600.9), Angle(0.46,3.95,0.04) )
	DriverSeat:SetCameraDistance( 17 )
	DriverSeat.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(3000,-400,1000), Angle(-0.44,-90.14,-80) )
	self:SetGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(2000,-400,1000), Angle(-0.44,-90.14,-80) )
	self:SetSecondGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1000,-400,1000), Angle(-0.44,-90.14,-80) )
	self:SetThirdGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(3000,400,1000), Angle(-0.44,-90.14,-80) )
	self:SetFourthGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(2000,400,1000), Angle(-0.44,-90.14,-80) )
	self:SetFiveGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1000,400,1000), Angle(-0.44,-90.14,-80) )
	self:SetSixGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1500,-400,1000), Angle(-0.44,-90.14,-80) )
	self:SetSevenGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1500,400,1000), Angle(-0.44,-90.14,-80) )
	self:SetEightGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(2200.41,0,1500), Angle(-0.44,-270.14,0) )
	self:SetNineGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	

	
	
	self:AddEngine( Vector(-1901.7,130,1020.7) )
	self:AddEngine( Vector(-1901.7,-130,1020.7) )
	self:AddEngine( Vector(-1720,240, 840) )
	self:AddEngine( Vector(-1720,-240, 840) )
	self:AddEngine( Vector(-1401,105,750.2) )
	self:AddEngine( Vector(-1401,-105,750.2) )
	self:AddEngine( Vector(-1901.7,0,1225) )
	self:AddEngine( Vector(3260,-0.5,1620.9) )
	self:AddEngine( Vector(2200.41,0,1500) )
	self:AddEngine( Vector(1600.41,500,1500) )
	self:AddEngine( Vector(1600.41,-500,1500) )
	self:AddEngine( Vector(3000.41,500,1300) )
	self:AddEngine( Vector(3000.41,-500,1300) )
	self:AddEngineSound( Vector(423.99,-9.67,244.98) )
	

	self.PrimarySND = self:AddSoundEmitter( Vector(887.61,-0.5,444.9), "lvs/vehicles/wpn_xwing_blaster_fire.mp3", "lvs/vehicles/wpn_xwing_blaster_fire.mp3" )
	self.PrimarySND:SetSoundLevel( 130 )
	
	self.SNDTail = self:AddSoundEmitter( Vector(200,0,150), "lvs/vehicles/atte/fire.mp3", "lvs/vehicles/atte/fire.mp3" )
	self.SNDTail:SetSoundLevel( 130 )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/startup1.wav" )
	else
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/stop.wav" )
	end
end