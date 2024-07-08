AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local DOOR = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_movelinear"] = true,
    ["prop_dynamic"] = true
}

local T_VISIBLE = {}

function ENT:Initialize()
    local function CheckLoaded()
        if NCS_DATAPAD.CONFIG.MODEL then
            self:SetModel(NCS_DATAPAD.CONFIG.MODEL)
        else
            timer.Simple(0, CheckLoaded)
        end
    end
	
    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)

	T_VISIBLE[self] = true

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

	CheckLoaded()
end

--]]------------------------------------------------]]--
--	Local Values
--]]------------------------------------------------]]--

local function SendNotification(ply, msg)
	local CFG = {
		Appension = NCS_DATAPAD.CONFIG.PREFIX,
		Color = NCS_DATAPAD.CONFIG.PREFIX_C,
	}

	NCS_DATAPAD.AddText(ply, CFG.Color, "["..CFG.Appension.."] ", color_white, msg)
end

--]]------------------------------------------------]]--
--	Activate
--]]------------------------------------------------]]--

function ENT:Use(P)
	local OBJ = NCS_DATAPAD.GetPlugin("Entries")

	if not IsValid(P:GetActiveWeapon()) or P:GetActiveWeapon():GetClass() ~= "datapad_player" then
		SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_pleaseEquipDatapad"))

		return
	end

	if not self:GetIsHacking() then
		local TIMING = (self:GetHackConsoleTiming() ~= 0 and self:GetHackConsoleTiming() or NCS_DATAPAD.CONFIG.HackTime)
		local T_ENGINEERS = NCS_DATAPAD.GetEngineers()

		if ( T_ENGINEERS and table.Count(T_ENGINEERS) > 0 ) and not NCS_DATAPAD.IsEngineer(P) then
			local BOOL_ENGINEER = false
	
			for k, v in ipairs(player.GetAll()) do
				if T_ENGINEERS[team.GetName(v:Team())] then
					BOOL_ENGINEER = true
	
					break
				end
			end

			if BOOL_ENGINEER then
				SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_engineersOnline"))
				return false
			else
				SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_noEngineersOnline"))
			end
		
			self:SetHacker(P)
			self:SetHackTimeRemaining( TIMING + (TIMING * 0.5 ) )
			self:SetIsHacking(true)
		else
			self:SetHacker(P)
			self:SetHackTimeRemaining(TIMING)
			self:SetIsHacking(true)

			local TAB = NCS_DATAPAD.E_LINKED[self]

			local LANG = NCS_DATAPAD.GetLang(nil, "DAP_hackInitiatedDoors", {
				(TAB and #TAB or 0)
			})

			SendNotification(P, LANG)
		end

		return false
	end

	local TIME_REMAINING = self:GetHackTimeRemaining()
	local VISIBLE = T_VISIBLE[self]

	if self:GetIsHacking() && TIME_REMAINING <= 0 then
		if NCS_DATAPAD.E_LINKED[self] and #NCS_DATAPAD.E_LINKED[self] > 0 then
			local LANG = NCS_DATAPAD.GetLang(nil, "DAP_hackCompletedDoors", {
				#NCS_DATAPAD.E_LINKED[self]
			})

			SendNotification(P, LANG)

			for k, v in ipairs(NCS_DATAPAD.E_LINKED[self]) do
				if not IsValid(v.Ent) then
					continue
				end

				local vPoint = v.Ent:GetPos()
				local effectdata = EffectData()
				effectdata:SetOrigin( vPoint )
				util.Effect( "ManhackSparks", effectdata )

				v.Ent:EmitSound("buttons/combine_button2.wav")

				if not DOOR[v.Ent:GetClass()] then
					if VISIBLE then

						v.Ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
						v.Ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
						v.Ent:SetColor(Color(255,255,255,0))
					else
						v.Ent:SetCollisionGroup(COLLISION_GROUP_NONE)
						v.Ent:SetRenderMode(RENDERMODE_NORMAL)
						v.Ent:SetColor(Color(255,255,255,255))
					end
				else
					local save = v.Ent:GetSaveTable()

					if save and save.m_bLocked then
						v.Ent:Fire("unlock")
						v.Ent:Fire("open")
					else
						v.Ent:Fire("close")
						v.Ent:Fire("lock")
					end
				end
			end

			T_VISIBLE[self] = !T_VISIBLE[self]
		end
	
		self:SetIsHacking(false)

		return false
	end
end

function ENT:Think()
	local HACKING = self:GetIsHacking()

	if not HACKING then
		return false
	end

	local TIME_REMAINING = self:GetHackTimeRemaining()

	if not TIME_REMAINING || TIME_REMAINING == 0 || TIME_REMAINING <= 0 then
		return false
	end

	self:SetHackTimeRemaining(TIME_REMAINING - 1)

    self:NextThink( CurTime() + 1 )
    return true
end