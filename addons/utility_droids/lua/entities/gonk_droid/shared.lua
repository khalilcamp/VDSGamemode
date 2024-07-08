AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "GNK Droid"
ENT.Spawnable = true
ENT.Category = "Nexus: Utility"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props/starwars/tech/gonk_droid.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetModelScale(self:GetModelScale())
        self:SetUseType(SIMPLE_USE)
        self:SetHealth(100)
        self:SetMaxHealth(100)
        self.AmmoDelay = 0  -- Inicialização correta
        local phys = self:GetPhysicsObject()

        if phys:IsValid() then
            phys:Wake()
            phys:EnableMotion(false)
        end
    end

    local ammoAmounts = {
        ["Pistol"] = 80,
        ["SMG1"] = 120,
        ["AR2"] = 60,
    	["SniperRound"] = 20,
    	["Grenade"] = 2,
    	["357"] = 200,
    	["XBowBolt"] = 2,
    	["rpg_round"] = 2,
    	["slam"] = 1,
    	["buckshot"] = 30,
    	
        -- Adicione mais tipos de munição e quantidades conforme necessário
    }

    function ENT:Think()
        if self:Health() == 0 then
            local effectdata = EffectData()
            self.NextSpark = self.NextSpark or 0
            if self.NextSpark < CurTime() then
                self.NextSpark = CurTime() + 0.1
                effectdata:SetOrigin(self:GetPos() + Vector(0, 0, 25))
                util.Effect("StunstickImpact", effectdata)
            end
            return
        end

        if CurTime() < self.AmmoDelay then return end

        for _, v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
            if v:IsPlayer() and v:GetActiveWeapon():Clip1() ~= -1 then
                local ammoType = v:GetActiveWeapon():GetPrimaryAmmoType()
                local ammoName = game.GetAmmoName(ammoType)
                local ammoAmount = ammoAmounts[ammoName] or 30  -- Quantidade padrão

                self:EmitSound("weapons/gonkdroid/lc_gonk.mp3")
                v:GiveAmmo(ammoAmount, ammoType, true)
            end
        end

        self.AmmoDelay = CurTime() + 2
    end

    repairDatabase["gonk_droid"] = function(fusionCutter, ent, trace)
        local hp = ent:Health()

        if hp < ent:GetMaxHealth() then
            ent:SetHealth(math.Clamp(hp + 10, 0, ent:GetMaxHealth()))
            return true
        else
            return false
        end
    end

    function ENT:OnTakeDamage(dmg)
        self:TakePhysicsDamage(dmg)
        if (self:Health() <= 0) then return end
        local effectdata = EffectData()
        effectdata:SetOrigin(dmg:GetDamagePosition())
        effectdata:SetEntity(self)
        util.Effect("ElectricSpark", effectdata)
        self:SetHealth(math.Clamp(self:Health() - dmg:GetDamage(), 0, self:GetMaxHealth()))
        if self:Health() <= 0 then
            self:Ignite(20, 250)
        end
    end
end

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
    function ENT:Draw()
        cam.Start3D2D(self:GetPos(), Angle(0, RenderAngles().y - 90, 90), 0.25)
            draw.SimpleTextOutlined("Gonk Droid", "ON_Droids24", 0, -270, Color(0, 191, 255), TEXT_ALIGN_CENTER, 0, 2, Color(0, 0, 0, 0))
            draw.SimpleTextOutlined("Tibanna Supply", "ON_Droids12", 0, -250, Color(0, 191, 255), TEXT_ALIGN_CENTER, 0, 2, Color(0, 0, 0, 0))
        cam.End3D2D()
        cam.Start3D2D(self:GetPos(), Angle(0, 0, 0), 0.25)
            surface.DrawCircle(0, 0, math.floor(math.sin(CurTime() * 5) * 5) + 450, 0, 191, 255, 255)
        cam.End3D2D()
        self:DrawModel()
    end

    function ENT:DrawTranslucent(flags)
        self:Draw(flags)
    end
end
