AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( isstring(self.Models) and self.Models or self.Models[math.random(1, #self.Models)] )
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	self:SetHealth(self.MaxHealth + self.MaxHealth*0.25 * (player.GetCount()-1) )
	self:SetMaxHealth(self.MaxHealth + self.MaxHealth*0.25 * (player.GetCount()-1) )
	self:SetBloodColor( self.BloodColour )

	if isvector(self.CollisionBounds) then
		self:SetCollisionBounds(
		  Vector(self.CollisionBounds.x, self.CollisionBounds.y, self.CollisionBounds.z),
		  Vector(-self.CollisionBounds.x, -self.CollisionBounds.y, 0)
		)
	else
		self:SetCollisionBounds(self:GetModelBounds())
	end

	self:OnInitialize()
end

function ENT:OnInitialize()

end

function ENT:OnKilled( dmginfo )
	
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	
	local body = ents.Create( "prop_ragdoll" )
	body:SetPos( self:GetPos() )
	body:SetModel( self:GetModel() )
	body:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )
	body:Spawn()

	self:Remove()
	timer.Simple( 5, function()
	
		body:Remove()
		
	end )
end

local CanSeeOffset = Vector(0, 0, 70)
function ENT:CanSee( otherEnt )
	if not IsValid( otherEnt ) then return false end
	if otherEnt:IsFlagSet(FL_NOTARGET) then return false end

	local tr = util.TraceLine({
		start = self:GetPos() + CanSeeOffset,
		endpos = otherEnt:GetPos() + CanSeeOffset,
		mask = MASK_BLOCKLOS,
	})
	return !tr.Hit
end

local function GetAllFactions()
	local factions = {}
	for _, tbl in ipairs(scripted_ents.GetList()) do
		if tbl.t.DaneNextbot then
			factions[tbl.t.Faction] = true
		end
	end
	return factions
end

function ENT:FindEnemy()
	local MyPos = self:GetPos()

	local ClosestTarget = NULL
	local TargetDistance = self.SightRange*self.SightRange

	for k, v in ipairs(ents.GetAll()) do
		if v.DaneNextbot then
			if v.Faction == self.Faction then continue end
		elseif v:IsPlayer() then
			if self.Faction == "Republic" then continue end
		else
			continue
		end

		if self:CanSee(v) then
			if v:IsPlayer() and not v:Alive() then continue end
			local Dist = (v:GetPos() - MyPos):LengthSqr()

			if Dist < TargetDistance then
				ClosestTarget = v
				TargetDistance = Dist
			end
		end
	end

	return ClosestTarget
end

function ENT:GetEnemy()

	self.NextAICheck = self.NextAICheck or 0

	if (self.NextAICheck > CurTime()) then
		return self.LastTarget
	end

	self.NextAICheck = CurTime() + 1

	self.LastTarget = self:FindEnemy()
	return enemy
end

function ENT:Think()
	self:DoShoot()
	self:NextThink(CurTime())
	return true
end

function ENT:RunBehaviour()
	while true do

		self:StartActivity(self.WalkAnim or ACT_HL2MP_WALK_AR2)
		local enemy = self:GetEnemy()
		if IsValid(enemy) then
			if self:CanSee(enemy) then
				local Dist = math.random(self.DistMin, self.DistMax)
				local Leeway = 200
				while true do
					local enemy = self:GetEnemy()
					if not IsValid(enemy) then break end
					if not self:CanSee(enemy) then break end

					self.loco:FaceTowards(enemy:GetPos())
					local distance = self:GetRangeSquaredTo(enemy:GetPos())
					if distance >= (Dist*Dist + Leeway*Leeway) or (distance <= Dist*Dist) then
						self.loco:SetDesiredSpeed(self.WalkSpeed or 50)
						self.loco:Approach(enemy:GetPos() + (self:GetPos() - enemy:GetPos()):GetNormalized() * Dist, 1)
					end
					coroutine.yield()
				end
			end
		else
			coroutine.wait(1)
		end

		coroutine.yield()
	end
end

function ENT:BodyUpdate()
	self:BodyMoveXY()
end

//Shoot

local shootoffset = Vector(0, 0, 25)
function ENT:CanShoot()
	self.MultishotInt = self.MultishotInt or 0
	self.MultishotDelayInt = self.MultishotDelayInt or 0
	self.NextShoot = self.NextShoot or CurTime()

	if self.NextShoot <= CurTime() then

		local Scr = Vector(0, 0, 0)
		if self:LookupBone( self.ShootBone ) then
			Scr = self:GetBonePosition( self:LookupBone( self.ShootBone ) )
		else
			Scr = GetPos() + shootoffset
		end

		local tr = util.TraceLine({
			start = Scr,
			endpos = self:GetEnemy():EyePos() or (self:GetEnemy():GetPos() + Vector(0, 0, 70)),
			filter = self,
		})

		if tr.Entity != self:GetEnemy() then return false end

		self.MultishotInt = 0
		return true
	end

	if self.MultishotInt < self.Multishot then
		if self.MultishotDelayInt > CurTime() then return false end

		self.MultishotInt = self.MultishotInt + 1
		self.MultishotDelayInt = CurTime() + self.MultishotDelay
		return true
	end

	return false
end

local shootoffset = Vector(0, 0, 25)
function ENT:Shoot()
	if self.ShootAnim and not table.IsEmpty(self.ShootAnim) then
		self:BeginAnimation( self.ShootAnim[math.random(1,#self.ShootAnim)], self.ShootAnimSpeed )
		self.CantMove = CurTime()+1
	end

	local pos = Vector(0, 0, 0)
	if self:LookupBone( self.ShootBone ) then
		pos = self:GetBonePosition( self:LookupBone( self.ShootBone ) )
	else
		pos = self:GetPos() + shootoffset
	end

	local bullet = table.Copy(self.BulletTable)
	bullet.Src = pos
	bullet.Dir 	= ((self:GetEnemy():LocalToWorld( self:GetEnemy():OBBCenter() )) - bullet.Src)
	bullet.Attacker = self
	self:FireBullets( bullet )
	self:EmitSound(self.WeaponSound, 75, 100, 1, CHAN_WEAPON)
end

function ENT:DoShoot()
	local enemy = self:GetEnemy()
	if IsValid(enemy) and self:CanShoot() then
		if self:GetRangeSquaredTo( enemy ) > self.ShootRange*self.ShootRange then return end

		self.NextShoot = CurTime() + math.Rand(self.minShootTime, self.maxShootTime)
		self:Shoot()
	end
end