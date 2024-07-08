AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.SpawnNormalOffset = 25

function ENT:OnSpawn( PObj )
	
	PObj:SetMass( 120000 )

	local DriverSeat = self:AddDriverSeat( Vector(-499.45,0.54,1040.98), Angle(0,90,0.15) )
	DriverSeat:SetCameraDistance( 2.5 )
	DriverSeat.HidePlayer = true
	DriverSeat.ExitPos = Vector(1879.81,29.22,220)	
	
	local Pod = self:AddPassengerSeat( Vector(276.72,-500,-360), Angle(-0.07,-90,0.45) )
	self:SetGunnerSeat( Pod )
	Pod.ExitPos = Vector(293.55,2.98,260)
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(276.72,500,-360), Angle(0.01,-90,0.15) )
	self:SetSecondGunnerSeat( Pod )
	Pod.ExitPos = Vector(-799.28,-531.3,220)
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(276.72,-500,320), Angle(0.01,-90,0.15) )
	self:SetThirdGunnerSeat( Pod )
	Pod.ExitPos = Vector(-799.28,531.3,220)
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(276.72,500,320), Angle(0,-90,-0.16) )
	self:SetFourthGunnerSeat( Pod )
	Pod.ExitPos = Vector(-1279.6,-5.85,220)
	Pod.HidePlayer = true

	local Pod = self:AddPassengerSeat( Vector(-1124.7,-3.6,675.25), Angle(0,-90,-0.16) )
	self:SetFifthGunnerSeat( Pod )
	Pod.ExitPos = Vector(-1279.6,-5.85,220)
	Pod.HidePlayer = true

	-- p s
	
	local Pod = self:AddPassengerSeat( Vector(1790.83,392.41,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1790.83,392.41,220)
	Pod.HidePlayer = true	
	
	local Pod = self:AddPassengerSeat( Vector(1713.34,390.64,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1713.34,390.64,220)
	Pod.HidePlayer = true	
	
	local Pod = self:AddPassengerSeat( Vector(1640.54,393.17,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1640.54,393.17,220)
	Pod.HidePlayer = true	
	
	local Pod = self:AddPassengerSeat( Vector(1545.44,390.77,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1545.44,390.77,220)
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1467.29,389.96,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1467.29,389.96,220)
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1390.54,388.61,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1390.54,388.61,220)
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1308.54,388.57,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1308.54,388.57,220)
	Pod.HidePlayer = true	
	
	local Pod = self:AddPassengerSeat( Vector(1308.54,388.57,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1308.54,388.57,220)
	Pod.HidePlayer = true	
	
	local Pod = self:AddPassengerSeat( Vector(1139.78,390.06,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1139.78,390.06,220)
	Pod.HidePlayer = true	
	
	local Pod = self:AddPassengerSeat( Vector(1067.53,388.98,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1067.53,388.98,220)
	Pod.HidePlayer = true	
	
	local Pod = self:AddPassengerSeat( Vector(989.68,386.33,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(989.68,386.33,220)
	Pod.HidePlayer = true	
	
	local Pod = self:AddPassengerSeat( Vector(909.41,386.29,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(909.41,386.29,220)
	Pod.HidePlayer = true	
	
	local Pod = self:AddPassengerSeat( Vector(848.31,385.48,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(848.31,385.48,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(770.05,384.43,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(770.05,384.43,220)	
	Pod.HidePlayer = true

	local Pod = self:AddPassengerSeat( Vector(704.58,383.04,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(704.58,383.04,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(624.58,382.52,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(624.58,382.52,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(553.85,383.82,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(553.85,383.82,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(454.61,386.01,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(454.61,386.01,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(406.73,385.29,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(406.73,385.29,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(344.99,386.62,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(344.99,386.62,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(276.72,386.48,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(276.72,386.48,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(203.98,387.21,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(203.98,387.21,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(129.09,387.95,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(129.09,387.95,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(75.09,386.2,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(75.09,386.2,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(0.6,387.92,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(0.6,387.92,220)	
	Pod.HidePlayer = true
	
	-- Right Side 
	local Pod = self:AddPassengerSeat( Vector(1790.83,-392.41,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1790.83,-392.41,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1713.34,-390.64,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1713.34,-390.64,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1640.54,-393.17,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1640.54,-393.17,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1545.44,-390.77,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1545.44,-390.77,220)
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1467.29,-389.96,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1467.29,-389.96,220)
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1390.54,-388.61,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1390.54,-388.61,220)
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1308.54,-388.57,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1308.54,-388.57,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1308.54,-388.57,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1308.54,-388.57,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1139.78,-390.06,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1139.78,-390.06,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(1067.53,-388.98,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(1067.53,-388.98,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(989.68,-386.33,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(989.68,-386.33,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(909.41,-386.29,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(909.41,-386.29,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(848.31,-385.48,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(848.31,-385.48,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(770.05,-384.43,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(770.05,-384.43,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(704.58,-383.04,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(704.58,-383.04,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(624.58,-382.52,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(624.58,-382.52,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(553.85,-383.82,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(553.85,-383.82,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(454.61,-386.01,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(454.61,-386.01,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(406.73,-385.29,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(406.73,-385.29,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(344.99,-386.62,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(344.99,-386.62,220)	
	Pod.HidePlayer = true

	local Pod = self:AddPassengerSeat( Vector(276.72,-386.48,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(276.72,-426.48,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(203.98,-387.21,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(203.98,-387.21,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(129.09,-387.95,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(129.09,-387.95,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(75.09,-386.2,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(75.09,-386.2,220)	
	Pod.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(0.6,-387.92,24.09), Angle(0,-92.62,-0.03) )
	Pod.ExitPos = Vector(0.6,-387.92,220)	
	Pod.HidePlayer = true
	
	
	self:AddEngine( Vector(-2900,0,-30) )
	self:AddEngine( Vector(-2900,0,-30) )
	self:AddEngine( Vector(-2900,-864,-30) )
	self:AddEngine( Vector(-2900,864,-30) )
	self:AddEngineSound( Vector(-2900,0,-30) )

	self.PrimarySND = self:AddSoundEmitter( Vector(887.61,-0.5,444.9), "lvs/vehicles/atte/fire_turret.mp3", "lvs/vehicles/atte/fire_turret.mp3" )
	self.PrimarySND:SetSoundLevel( 150 )
	
	self.SNDTail = self:AddSoundEmitter( Vector(200,0,150), "lvs/vehicles/atte/fire.mp3", "lvs/vehicles/atte/fire.mp3" )
	self.SNDTail:SetSoundLevel( 110 )
end

function ENT:OnLandingGearToggled( bOn )
	self:EmitSound( "lvs/vehicles/frigates/landing_gear.wav" )
end

function ENT:OnTick()
	local speed = self:GetThrottle()

	if speed <= 0 then
		self:AnimLandingGear()
		else
		self:BackAnimLandingGear()
	end
end
	--local ID = self:LookupAttachment( "4" )
	--local Attachment = self:GetAttachment( ID )
	
	--if not Attachment then return end

	--self.StartPos = Attachment.Pos
	--self.AimDir = Attachment.Ang
	--self.MuzzleID = ID
	
	--if self:GetAI() then
		--local Target = self:AIGetTarget()
		
		--if IsValid( Target ) then
			--local Aimang = (Target:GetPos() - Attachment.Pos):Angle()
			--local Angles = self:WorldToLocalAngles( Aimang )
			--Angles:Normalize()
	
			--self:SetPoseParameter("turret_yaw", Angles.y-180 )
			--self:SetPoseParameter("turret_pitch", -Angles.p )
		--end
		
		--return
	--end

	--local startpos =  self:GetRotorPos()
	--local tr = util.TraceHull( {
		--start = startpos,
		--endpos = (startpos + Pod:WorldToLocalAngles( Driver:EyeAngles() ):Forward() * 50000),
		--mins = Vector( -40, -40, -40 ),
		--maxs = Vector( 40, 40, 40 ),
		--filter = self
	--} )

	--local Aimang = (tr.HitPos - Attachment.Pos):Angle()
	--local Angles = self:WorldToLocalAngles( Aimang )
	--Angles:Normalize()
	
	--local Rate = 3
	--self.sm_pp_yaw = self.sm_pp_yaw and (self.sm_pp_yaw + math.Clamp(Angles.y - self.sm_pp_yaw,-Rate,Rate) ) or 0
	--self.sm_pp_pitch = self.sm_pp_pitch and ( self.sm_pp_pitch + math.Clamp(Angles.p - self.sm_pp_pitch,-Rate,Rate) ) or 0
	
	--self:SetPoseParameter("turret_yaw", self.sm_pp_yaw+179 )
	--self:SetPoseParameter("turret_pitch", -self.sm_pp_pitch-1 )--


function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/startup1.wav" )

	else
		self:EmitSound( "lvs/vehicles/frigates/shutoff1.wav" )
	end
end
