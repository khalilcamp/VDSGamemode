AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(NCS_TRANSPORT.CONFIG.vendormodel)
    
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_BBOX)
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE)
    self:CapabilitiesAdd(CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()

    if not self.notInitialSpawn then
        self.vendorUID = os.time()
    end

    local TRIES = 0

    local function Randomize()
        if TRIES >= 50 then return end
        TRIES = TRIES + 1

        timer.Simple(0, function()
            if NCS_TRANSPORT and IsValid(self) then
                self:ResetSequence(table.Random(NCS_TRANSPORT.CONFIG.stances))

                if NCS_TRANSPORT.CONFIG.randomize then
                    local COUNT = self:SkinCount()
                    local SKIN = math.random(1, COUNT)

                    self:SetSkin(SKIN)

                    for k, v in ipairs(self:GetBodyGroups()) do
                        local STACK = v.submodels
                        local _, key = table.Random(STACK)

                        self:SetBodygroup(k, key)
                    end
                end
            else
                Randomize()
            end
        end)
    end

    Randomize()

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end
end

function ENT:Use(activator)
    if !self.vendorUID then
        self.vendorUID = table.maxn(NCS_TRANSPORT.VENDORS) + 1
    end
    
    net.Start("NCS_TRANSPORT_OpenMenu")
        net.WriteUInt(self.vendorUID, 32)
        net.WriteTable( ( self.locations or {} ) )
    net.Send(activator)
end