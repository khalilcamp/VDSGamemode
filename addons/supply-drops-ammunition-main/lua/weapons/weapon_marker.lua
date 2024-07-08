if (CLIENT) then
    SWEP.PrintName = "Flare Marker"
    SWEP.Slot                       = 4
    SWEP.SlotPos                    = 1
    SWEP.SwayScale                  = 4
    SWEP.UseHands                   = true
    SWEP.DrawAmmo                   = true
end

SWEP.Author = "Luiggi33"
SWEP.Contact = "Luiggi33 on Steam"
SWEP.Purpose = "Mark the Location for the Ammo Drop"
SWEP.Instructions = "Chame Suprimento usando Click esquerdo"

SWEP.Category = "AmmoDrops"

SWEP.ViewModel                  = "models/weapon/v_flaregun.mdl"
SWEP.WorldModel                 = "models/weapon/w_flaregun.mdl"
SWEP.HoldType                   = "revolver"
SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = false

SWEP.Primary.Damage             = 1
SWEP.Primary.Force              = 1
SWEP.Primary.ClipSize           = 1
SWEP.Primary.DefaultClip        = 0
SWEP.Primary.Recoil             = 2
SWEP.Primary.Delay              = 5999
SWEP.Primary.Automatic          = false
SWEP.Primary.Ammo               = "slam"
SWEP.Primary.Sound              = {"flare/fire.wav"}
SWEP.Primary.DistantSound       = {"flare/fire_dist.wav"}

SWEP.Secondary.ClipSize         = 0
SWEP.Secondary.DefaultClip      = 0
SWEP.Secondary.Automatic        = false
SWEP.Secondary.Ammo             = "slam"

SWEP.Primary.DisableBulletCode  = true
SWEP.PrimaryEffects_MuzzleAttachment = 0
SWEP.PrimaryEffects_SpawnShells = false

SWEP.DelayOnDeploy              = 3000

SWEP.HasIdleAnimation           = false

SWEP.Slot = 4
SWEP.SlotPos = 1

if CLIENT then
    net.Receive("resupplyCallingInSound", function()
        surface.PlaySound("bot/be_right_there.wav")
    end)
end

if not SERVER then return end

util.AddNetworkString("resupplyCallingInSound")

function SWEP:Initialize()
    self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()

    if ( not ply:IsValid() ) then return end
    if CLIENT then return end

    ply:LagCompensation( true )

    local proj = ents.Create("obj_flareround")
    if ( not proj:IsValid() ) then
        print("Error")
        ply:LagCompensation(false)
        return
    end

    local ply_Ang = ply:GetAimVector():Angle()
    local ply_Pos = ply:GetShootPos()
    if ply:IsPlayer() then proj:SetPos(ply_Pos) end
    if ply:IsPlayer() then proj:SetAngles(ply_Ang) end
    proj:SetOwner(ply)
    proj:Activate()
    proj:Spawn()

    local phys = proj:GetPhysicsObject()

    if IsValid(phys) and ply:IsPlayer() then
        phys:SetVelocity(ply:GetAimVector() * 500)
    end

    timer.Simple(5, function()
        if not IsValid(proj) then return end
        callSupplyDrop(proj:GetPos())
    end )
    ply:ChatPrint("[COMMS]: Um transporte está vindo para entregar os suprimentos!")
    timer.Simple(1, function()
        net.Start("resupplyCallingInSound")
        net.Send(ply)
    end)

    self:TakePrimaryAmmo(1)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    ply:LagCompensation(false)
end

function callSupplyDrop(dropPosition)
    local dropShip = ents.Create("dropshiplaat")
    if (not dropShip:IsValid()) then return end

    dropShip:SetPos(dropPosition)
    dropShip:Spawn()
end

function SWEP:SecondaryAttack()
end

