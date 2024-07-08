AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/blu/laat.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
        phys:EnableGravity(false)
    end

    self.ShadowParams = {}
    self:StartMotionController()

    self:SetPos(self:GetPos() + Vector(2000, 0, 2000)) -- Inicializa a nave no céu
    self:SetAngles(Angle(0, 180, 0))
    self.TargetPos = self:GetPos() + Vector(-2000, 0, -1910) -- Posição de descida para ficar flutuando a 50 unidades acima do solo
    self.Deployed = false
    self.Arrived = false
    self.Landing = false
    self.Floating = false
    self.SoundLoop = CreateSound(self, "lvs/vehicles/laat/loop.wav") -- Som contínuo
    self.SoundLoop:Play()

    self.FloatAmplitude = 40 -- Amplitude da flutuação
    self.FloatFrequency = 6 -- Frequência da flutuação
    self.BaseHeight = self.TargetPos.z
end

function ENT:PhysicsSimulate(phys, deltatime)
    phys:Wake()

    -- Se a nave estiver próxima da posição alvo e não estiver subindo, ela mantém essa posição
    if self:GetPos():DistToSqr(self.TargetPos) < 10*10 and not self.Floating then
        self.TargetPos = self:GetPos() -- Manter a posição atual

        if not self.Deployed then
            self:Deploy()
        end
        self.Deployed = true
    end

    self.ShadowParams.secondstoarrive = 1
    self.ShadowParams.pos = self.TargetPos
    self.ShadowParams.angle = self:GetAngles()
    self.ShadowParams.maxangular = 5000
    self.ShadowParams.maxangulardamp = 10000
    self.ShadowParams.maxspeed = 1000000
    self.ShadowParams.maxspeeddamp = 10000
    self.ShadowParams.dampfactor = 0.8
    self.ShadowParams.teleportdistance = 0
    self.ShadowParams.deltatime = deltatime

    phys:ComputeShadowControl(self.ShadowParams)
end

function ENT:Think()
    if self.Deployed and not self.Floating then
        self:FloatAnimation()
    end
    self:NextThink(CurTime())
    return true
end

function ENT:FloatAnimation()
    local time = CurTime()
    local floatOffset = math.sin(time * self.FloatFrequency) * self.FloatAmplitude
    self.TargetPos.z = self.BaseHeight + floatOffset
end

function ENT:Deploy()
    -- Toca o som de pouso
    self:EmitSound("lvs/vehicles/laat/landing.wav")

    -- Verifica se as portas já estão abertas, se não estiverem, abre-as
    if not self.Deployed then
        self:PlayAnimation("doors_open")
    end

    -- Para o som contínuo ao pousar
    self.SoundLoop:Stop()

    timer.Simple(5, function()
        if not IsValid(self) then return end
        self:SpawnNPCs()
        -- Executa a animação de fechamento das portas após spawnar os NPCs
        self:PlayAnimation("doors_close")
    end)

    -- Sobe e some após spawnar os NPCs
    timer.Simple(8, function()
        if not IsValid(self) then return end
        self.Floating = true -- Impede a animação de flutuação durante a subida
        self.TargetPos = self:GetPos() + Vector(0, 0, 1000)
        self:EmitSound("lvs/vehicles/laat/boost_2.wav") -- Toca o som de subida
        self.SoundLoop:Play() -- Retoma o som contínuo ao subir

        timer.Simple(3, function()
            if not IsValid(self) then return end
            self:FlyForward()
        end)
    end)
end

function ENT:FlyForward()
    self.TargetPos = self:GetPos() + self:GetForward() * 4000 -- Define um alvo de voo para frente
    self:EmitSound("lvs/vehicles/vulturedroid/flyby.wav") -- Toca o som de voo para frente

    timer.Simple(2, function()
        if IsValid(self) then
            self:Remove()
        end
    end)
end

function ENT:SpawnNPCs()
    local positions = {
        Vector(-200, 100, 0), Vector(-200, 0, 0), Vector(-200, -100, 0), Vector(-200, -200, 0),
        Vector(-200, -300, 0), Vector(200, -300, 0), Vector(200, -200, 0), Vector(200, -100, 0),
        Vector(200, 0, 0), Vector(200, 100, 0)
    }

    -- Ajuste as posições dos NPCs com base na orientação da nave
    local forward = self:GetForward()
    local right = self:GetRight()
    local up = self:GetUp()

    for i, offset in ipairs(positions) do
        local spawnPos = self:GetPos() + offset.x * right + offset.y * forward + offset.z * up
        local spawnAng = Angle(0, 0, 0)

        local ent = ents.Create("dane_ct")
        ent:SetPos(spawnPos)
        ent:SetAngles(spawnAng)
        ent:Spawn()
    end
end

function ENT:FindEnemy()
    local bestEnt
    local bestDist = 5000*5000
    for _, ply in ipairs(ents.FindInCone(self:GetPos(), self:GetAngles():Forward(), 5000, 0.9)) do
        if not IsValid(ply) or not ply:IsPlayer() or ply:IsFlagSet(FL_NOTARGET) then continue end

        if self:GetPos():DistToSqr(ply:GetPos()) < bestDist then
            bestEnt = ply
            bestDist = self:GetPos():DistToSqr(ply:GetPos())
        end
    end
    return bestEnt
end

function ENT:PlayAnimation(animation, playbackrate)
    playbackrate = playbackrate or 1

    local sequence = self:LookupSequence(animation)
    if sequence == -1 then
        -- A sequência de animação especificada não foi encontrada
        print("A sequência de animação '" .. animation .. "' não foi encontrada.")
        return
    end

    -- Verifica se a animação é de abertura de portas
    if animation == "doors_open" then
        -- Ajusta o tempo de início da animação para que as portas se abram quando o avião tocar o solo
        self:SetCycle(0)
        -- Toca o som de abertura das portas
        self:EmitSound("lvs/vehicles/laat/door_open.wav")
    elseif animation == "doors_close" then
        -- Toca o som de fechamento das portas
        self:EmitSound("lvs/vehicles/laat/door_close.wav")
    end

    self:SetSequence(sequence)
    self:SetPlaybackRate(playbackrate)
    self:ResetSequence(sequence)
    self:ResetSequenceInfo()
end

function ENT:OnRemove()
    self.SoundLoop:Stop()
end
