AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.SpawnNormalOffset = 25

function ENT:OnSpawn( PObj )
	PObj:SetMass( 100000000 )

	local DriverSeat = self:AddDriverSeat( Vector(820,-0.5,2550), Angle(0.46,3.95,0.04) )
	DriverSeat:SetCameraDistance( 15 )
	DriverSeat.HidePlayer = true
	
	self.SNDDorsal = self:AddSoundEmitter( Vector(-171.69,0,45), "lvs/vehicles/laat/fire.mp3", "lvs/vehicles/laat/fire.mp3" )
	self.SNDDorsal:SetSoundLevel( 110 )
	
	self.SNDVentral = self:AddSoundEmitter( Vector(-171.69,0,45), "lvs/vehicles/atte/fire.mp3", "lvs/vehicles/atte/fire.mp3" )
	self.SNDVentral:SetSoundLevel( 110 )

	local DorsalGunner = self:AddPassengerSeat( Vector(-280,-920,1050), Angle(0,-180,0) )
	DorsalGunner.HidePlayer = true
	DorsalGunner.ExitPos = Vector(-1000, 70, 0)
	
	local DorsalGunner = self:AddPassengerSeat( Vector(-280,920,1050), Angle(0,0,0) )
	DorsalGunner.HidePlayer = true
	DorsalGunner.ExitPos = Vector(-1000, 70, 0)
	
	local DorsalGunner = self:AddPassengerSeat( Vector(525,870,1050), Angle(0,0,0) )
	DorsalGunner.HidePlayer = true
	DorsalGunner.ExitPos = Vector(-1000, 70, 0)
	
	local DorsalGunner = self:AddPassengerSeat( Vector(525,-870,1050), Angle(0,-180,0) )
	DorsalGunner.HidePlayer = true
	DorsalGunner.ExitPos = Vector(-1000, 70, 0)
	
	local DorsalGunner = self:AddPassengerSeat( Vector(1375,-830,1030), Angle(0,-180,0) )
	DorsalGunner.HidePlayer = true
	DorsalGunner.ExitPos = Vector(-1000, 70, 0)
	
	local DorsalGunner = self:AddPassengerSeat( Vector(1375,830,1030), Angle(0,0,0) )
	DorsalGunner.HidePlayer = true
	DorsalGunner.ExitPos = Vector(-1000, 70, 0)
	
	
	local DorsalGunner = self:AddPassengerSeat( Vector(2200,810,1000), Angle(0,0,0) )
	DorsalGunner.HidePlayer = true
	DorsalGunner.ExitPos = Vector(-1000, 70, 0)
	
	
	local DorsalGunner = self:AddPassengerSeat( Vector(2200,-810,1000), Angle(0,-180,0) )
	DorsalGunner.HidePlayer = true
	DorsalGunner.ExitPos = Vector(-1000, 70, 0)
	
	local VentralGunner = self:AddPassengerSeat( Vector(7000,0,10), Angle(0, -90, 0) )
	VentralGunner.HidePlayer = true
	VentralGunner.ExitPos = Vector(-1000, -130, 0)

	
	
	
	
	self:AddEngine( Vector(20,-0.5,210) )
	self:AddEngine( Vector(706.73, -310,-14) )
	self:AddEngine( Vector(706.73, 310,-14) )
	self:AddEngine( Vector(876.73, -210,104) )
	self:AddEngine( Vector(876.73, 210,104) )
	self:AddEngine( Vector(1500.73, 130,104) )
	self:AddEngine( Vector(1500.73, -130,104) )
	self:AddEngineSound( Vector(423.99,-9.67,244.98) )

	self.PrimarySND = self:AddSoundEmitter( Vector(887.61,-0.5,444.9), "lvs/vehicles/wpn_xwing_blaster_fire.mp3", "lvs/vehicles/wpn_xwing_blaster_fire.mp3" )
	self.PrimarySND:SetSoundLevel( 110 )
	
	self.SNDTail = self:AddSoundEmitter( Vector(200,0,150), "lvs/vehicles/atte/fire.mp3", "lvs/vehicles/atte/fire.mp3" )
	self.SNDTail:SetSoundLevel( 110 )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/startup1.wav" )
	else
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/stop.wav" )
	end
end

