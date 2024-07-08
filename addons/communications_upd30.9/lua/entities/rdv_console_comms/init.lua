AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    local CFG = RDV.COMMUNICATIONS.S_CFG

    self:SetModel(CFG.consoleModel)
    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)

    if CFG.consoleHealthEnabled then
        local HP = CFG.consoleHealthValue

        self:SetHealth(HP)
        self:SetMaxHealth(HP)
    end

    self.SoundDelay = 0

    local phys = self:GetPhysicsObject()
    phys:EnableMotion(false)
end

local function SendNotification(ply, msg)
    local CFG = RDV.COMMUNICATIONS.S_CFG

    local COL = CFG.chatColor
    local PRE = CFG.chatPrefix
	
    RDV.LIBRARY.AddText(ply, COL, "["..PRE.."] ", color_white, msg)
end

function ENT:ToggleRelay(VAL, DAM)
    local DATA = RDV.COMMUNICATIONS.RELAYS[self:GetRelayName()]
    DATA.ENABLED = VAL

    hook.Run("RDV_COMMUNICATIONS_RelayDisabled", self, self:GetRelayName())

    self:SetRelayEnabled(VAL)

    local F = RecipientFilter()

    for k, v in ipairs(player.GetHumans()) do
        if DATA.TEAMS and DATA.TEAMS[team.GetName(v:Team())] then
            if !DATA.ENABLED and RDV.COMMUNICATIONS.GetCommsEnabled(v) then continue end

            F:AddPlayer(v)
        end
    end

    net.Start("RDV_COMMUNICATIONS_ToggleComms")
        net.WriteBool(VAL)
    net.Send(F)

    if !DAM then
        SendNotification(player.GetHumans(), RDV.LIBRARY.GetLang(nil, "COMMS_arrayChange", {
            self:GetRelayName(),
            (VAL and RDV.LIBRARY.GetLang(nil, "COMMS_enabledText") or RDV.LIBRARY.GetLang(nil, "COMMS_disabledText")),
        }))
    else
        SendNotification(player.GetHumans(), RDV.LIBRARY.GetLang(nil, "COMMS_arrayChange", {
            self:GetRelayName(),
            RDV.LIBRARY.GetLang(nil, "COMMS_destroyedLabel"),
        }))
    end
end

function ENT:Use(activator)
    local CFG = RDV.COMMUNICATIONS.S_CFG
        
    if CFG.consoleHealthEnabled and self:Health() <= 0 then
        SendNotification(activator, RDV.LIBRARY.GetLang(nil, "COMMS_commsRelayDamaged"))
        return
    end

    local VAL

    if RDV.COMMUNICATIONS.RELAYS[self:GetRelayName()].ENABLED then
        VAL = false
    else
        VAL = true
    end

    self:ToggleRelay(VAL)
end


function ENT:OnTakeDamage(dmginfo)
    if !RDV or !RDV.COMMUNICATIONS then return end

    if self:Health() <= 0 then
        return
    end

    local NH = math.Clamp( ( self:Health() - dmginfo:GetDamage() ), 0, self:GetMaxHealth() )

    self:SetHealth(NH)

    if NH <= 0 then
        self:ToggleRelay(false, true)
    end
end

function ENT:Think()
    if !RDV or !RDV.COMMUNICATIONS then return end

    local CFG = RDV.COMMUNICATIONS.S_CFG
    local DATA = RDV.COMMUNICATIONS.RELAYS[self:GetRelayName()]

    if DATA and !DATA.ENABLED then
        if CFG.consoleHealthEnabled and self:Health() <= 0 then
            self:Ignite(1, 30)
        else
            self:Extinguish()
        end

        return
    end

    if self.SoundDelay and self.SoundDelay > CurTime() then
        return
    end

    if DATA and DATA.SOUNDS then
        local LEN = #DATA.SOUNDS

        local PLAY = DATA.SOUNDS[math.random(1, LEN)]

        if PLAY then
            self:EmitSound(PLAY)
        end

        self.SoundDelay = CurTime() + math.random(10, 17)
    end
end