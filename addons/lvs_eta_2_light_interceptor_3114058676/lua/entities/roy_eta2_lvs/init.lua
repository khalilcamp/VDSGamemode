AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.SpawnNormalOffset = 100

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )

	self:AddDriverSeat( Vector(-28,0,-18), Angle(0,-90,20) )

	self:AddEngine( Vector(-82.408,12.3,-14.986) )
	self:AddEngine( Vector(-82.408,-12.3,-14.986) )
	self:AddEngineSound( Vector(0,0,10) )
	
	self.PrimarySND = self:AddSoundEmitter( Vector(118.24,0,49.96), "lvs/vehicles/naboo_n1_starfighter/fire.mp3", "lvs/vehicles/naboo_n1_starfighter/fire.mp3" )
	self.PrimarySND:SetSoundLevel( 110 )

	self.SNDLeft = self:AddSoundEmitter( Vector(74.669,59.924,-13.864), "lvs/vehicles/droidtrifighter/fire_wing.mp3", "lvs/vehicles/droidtrifighter/fire_wing.mp3" )
	self.SNDLeft:SetSoundLevel( 110 )

	self.SNDRight = self:AddSoundEmitter( Vector(74.669,-59.924,-13.864), "lvs/vehicles/droidtrifighter/fire_wing.mp3", "lvs/vehicles/droidtrifighter/fire_wing.mp3" )
	self.SNDRight:SetSoundLevel( 110 )

	--[[
	self:AddDS( {
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	mins = Vector(-40,-20,-30),
	maxs =  Vector(40,20,30),
	Callback = function( tbl, ent, dmginfo )
		print(dmginfo:GetDamage())
	end
	})
	]]

	self:SetMaxThrottle( 1.2 )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/start.wav" )
	else
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/stop.wav" )
		self:SetFoils( false )
	end
end

function ENT:OnTick()
	if self:ForceDisableFoils() then
		if self:GetThrottle() < 0.1 then
			self:DisableVehicleSpecific()
		end
	end
end

function ENT:OnVehicleSpecificToggled( new )
	local cur = self:GetFoils()

	if not cur and self:ForceDisableFoils() then return end

	if cur ~= new then
		self:SetFoils( new )
	end
end

function ENT:OnFoilsChanged( name, old, new)
	if new == old then return end

	if new == true then
		self:SetMaxThrottle( 1 )
	else
		self:SetMaxThrottle( 1.2 )
	end
end

function ENT:ForceDisableFoils()
	local trace = util.TraceLine( {
		start = self:LocalToWorld( Vector(0,0,50) ),
		endpos = self:LocalToWorld( Vector(0,0,-150) ),
		filter = self:GetCrosshairFilterEnts()
	} )
	
	return trace.Hit
end

function ENT:OnMaintenance()
	self:RemoveAllDecals()
end