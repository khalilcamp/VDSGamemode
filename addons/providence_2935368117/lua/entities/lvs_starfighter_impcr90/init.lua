AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.SpawnNormalOffset = 25

function ENT:OnSpawn( PObj )
	PObj:SetMass( 200000 )

	local DriverSeat = self:AddDriverSeat( Vector(-3600,0 ,3200), Angle(0.46,3.95,0.04) )
	DriverSeat:SetCameraDistance( 13 )
	DriverSeat.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(2506.73,-450.61,1564), Angle(-0.44,-176.14,-0.03) )
	self:SetGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(530,-500.61,1564), Angle(-0.44,-176.14,-0.03) )
	self:SetSecondGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(-730,-500.61,1594), Angle(-0.44,-176.14,-0.03) )
	self:SetThirdGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(-2500,-620.61,1656), Angle(-0.44,-176.14,-0.03) )
	self:SetFourthGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(2506.73,450.61,1564), Angle(0.45,2.37,0) )
	self:SetFiveGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(530,500.61,1554), Angle(0.45,2.37,0) )
	self:SetSixGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(-730,500.61,1594), Angle(0.45,2.37,0) )
	self:SetSevenGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(-2500,620.61,1656), Angle(0.45,2.37,0) )
	self:SetEightGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(-350,20,1900), Angle(0.45,-90,0) )
	self:SetEightGunnerSeat( Pod )
	Pod.HidePlayer = true
	
	
	
	self:AddEngine( Vector(-4900,32,1292) )
	self:AddEngine( Vector(-4780,-345,1140) )
	self:AddEngine( Vector(-4780,405,1130) )
	self:AddEngine( Vector(-350,20,1900) )
	self:AddEngine( Vector(-2500,620.61,1656) )
	self:AddEngine( Vector(-730,500.61,1594) )
	self:AddEngine( Vector(-730,-500.61,1594) )
	self:AddEngine( Vector(530,500.61,1484) )
	self:AddEngine( Vector(530,-500.61,1484) )
	self:AddEngine( Vector(2506.73,450.61,1504) )
	self:AddEngine( Vector(-2500,-620.61,1656) )
	self:AddEngine( Vector(2506.73,-450.61,1504) )
	self:AddEngine( Vector(-3600,0 ,3200) )
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