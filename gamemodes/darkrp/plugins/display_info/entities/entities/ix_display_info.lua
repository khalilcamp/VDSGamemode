ENT.Type = "anim"
ENT.PrintName = "Display Info NPC"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Model = "models/starlight/republic_heroes/misc/st_holoconsole.mdl"

function ENT:Initialize()
	if (CLIENT) then
		timer.Simple(1, function()
			if (not IsValid(self)) then return end
			self:setAnim()
		end)
		return
	end

	self:SetModel(self.Model)
	self:SetUseType(SIMPLE_USE)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(true)
	self:SetSolid(SOLID_BBOX)
	self:PhysicsInit(SOLID_BBOX)

	local physObj = self:GetPhysicsObject()

	if (IsValid(physObj)) then
		physObj:EnableMotion(false)
		physObj:Sleep()
	end
end

if SERVER then
    function ENT:Use(client)
        if not IsValid(client) then return end

        -- netstream.Start(client, "ixDisplayConfig")
		net.Start("ixDisplayConfig")
		net.Send(client)
    end

	function ENT:SpawnFunction(client, trace)
		local angles = (trace.HitPos - client:GetPos()):Angle()
		angles.r = 0
		angles.p = 0
		angles.y = angles.y + 180

		local entity = ents.Create("ix_display_info")
		entity:SetPos(trace.HitPos)
		entity:SetAngles(angles)
		entity:Spawn()

		return entity
	end
end

function ENT:setAnim()
	for k, v in ipairs(self:GetSequenceList()) do
		if (v:lower():find("idle") and v ~= "idlenoise") then
			return self:ResetSequence(k)
		end
	end

	self:ResetSequence(4)
end