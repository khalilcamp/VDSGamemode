AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "Ammo Box"
ENT.Author 			= "Luiggi33"
ENT.Contact 		= "Luiggi33"
ENT.Information		= "Ammo Box to be dropped"
ENT.Category		= "AmmoDrops"

ENT.Spawnable = false
ENT.AdminOnly = false

ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()

    self:NetworkVar( "Int", 1, "Amount" )

    if SERVER then
        self:SetAmount(4)
    end

end

if CLIENT then
    function ENT:Draw() self:DrawModel() end
end

if not SERVER then return end

function ENT:Initialize()
    self:SetModel("models/niksacokica/containers/crate_weapon_02.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    local phyis = self:GetPhysicsObject()
    if (phyis:IsValid()) then
        phyis:Sleep()
    end
    ControllFall(self)
    self.use = true
end

function ControllFall(entity)
    if not IsValid(entity) then return end
    landed = false
    entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
    timer.Create("controlledFalling", FrameTime(), 0, function()
        local mins = entity:OBBMins() + Vector(0,0,-10)
        local maxs = entity:OBBMaxs() + Vector(0,0,-10)
        local startpos = entity:GetPos()

        local tr = {
            start = startpos,
            endpos = startpos,
            mins = mins,
            maxs = maxs
        }

        local hullTrace = util.TraceHull( tr )
        if (hullTrace.HitWorld) then
            landed = true
            timer.Remove( "controlledFalling" )
            entity:SetCollisionGroup(COLLISION_GROUP_NONE)
            entity:SetMoveType(MOVETYPE_VPHYSICS)
        else
            entity:GetPhysicsObject():SetVelocity(Vector(0,0,-1000))
        end
    end)
end

-- Lista de armas permitidas
local allowedWeapons = {
    ["rsw_ab_dc15a"] = true,
["sw_ab_dc15a"] = true,
["sw_cb1smg"] = true,
["sw_dc15sa"] = true,
["sw_dc15a"] = true,
["sw_dc15d"] = true,
["sw_dc15le"] = true,
["sw_dc15s"] = true,
["sw_dc15se"] = true,
["sw_dc17"] = true,
["sw_dc17auto"] = true,
["sw_dc17ext"] = true,
["sw_dc17mrifle"] = true,
["sw_dc17s"] = true,
["sw_dc19"] = true,
["sw_dc19le"] = true,
["sw_dual_dc17"] = true,
["sw_dual_dc17stealth"] = true,
["sw_dual_dc17ext"] = true,
["sw_dual_dc17s"] = true,
["sw_dual_westar35_pistols"] = true,
["sw_westar12"] = true,
["sw_westar11"] = true,
["sw_w11smg"] = true,
["sw_stun_dc15a"] = true,
["sw_stun_dc15s"] = true,
["sw_stun_dc17"] = true,
["sw_westar34"] = true,
["sw_westar35_pistol"] = true,
["sw_westarm5a"] = true,
["sw_westarm5s"] = true,
["sw_x42"] = true,
["sw_x42_2"] = true,
["sw_z6"] = true,
["sw_z6adv"] = true,
["sw_z6chain"] = true,
["sw_a34_westarm5s"] = true,
["sw_b10"] = true,
["sw_cb1_sa"] = true,
["sw_cb1rifle"] = true,
["sw_charut_dual_westar35_pistols"] = true,
["sw_dc17c"] = true,
["sw_dc20"] = true,
["sw_dlt16"] = true,
["sw_dp23"] = true,
["sw_dp24"] = true,
["sw_dr18"] = true,
["sw_dr20"] = true,
["sw_dual_dc17auto"] = true,
["sw_e11nsc"] = true,
["sw_e11sc"] = true,
["sw_e5"] = true,
["sw_e5e"] = true,
["sw_e5c"] = true,
["sw_e5lr"] = true,
["sw_westar14"] = true,
["sw_westar13"] = true,
["sw_jaspers_westar12"] = true,
["sw_jasper_dual_westar35s"] = true,
["sw_t19"] = true,
["rw_sw_cj9"] = true,
["rw_sw_cr2"] = true,
["rw_sw_cr2c"] = true,
["rw_sw_d"] = true,
["rw_sw_defender"] = true,
["rw_sw_dl18"] = true,
["rw_sw_dl44"] = true,
["rw_sw_dt12"] = true,
["rw_sw_dual_d"] = true,
["rw_sw_dual_defender"] = true,
["rw_sw_dual_dl44"] = true,
["rw_sw_dual_dt12"] = true,
["rw_sw_dual_ib94"] = true,
["rw_sw_dual_ll30"] = true,
["rw_sw_dual_westar34"] = true,
["rw_sw_dual_westar35"] = true,
["rw_sw_ee3"] = true,
["rw_sw_ee3a"] = true, 
["rw_sw_huntershotgun"] = true,
["rw_sw_ib94"] = true,
["rw_sw_ib94s"] = true,
["rw_sw_k16"] = true,
["rw_sw_ll30"] = true,
["rw_sw_m57"] = true,
["rw_sw_nn14"] = true,
["rw_sw_relbyk23"] = true,
["rw_sw_relbyv10"] = true,
["rw_sw_s5"] = true,
["rw_sw_scattershotgun"] = true,
["rw_sw_s5c"] = true,
["rw_sw_umb1"] = true,
["rw_sw_westar11"] = true,
["rw_sw_westar34"] = true,
["rw_sw_westar35"] = true,
["rw_sw_x8"] = true,
["rw_sw_z2"] = true,
["astw2_swbf_rep_boltcaster"] = true,
["astw2_swbf_rep_chaingun"] = true,
["astw2_swbf_cis_wrist_blaster"] = true,
["astw2_swbf_cis_pistol_westar34"] = true,
["astw2_swbf_cis_pistol_westar25"] = true,
["astw2_swbf_cis_droideka_blaster"] = true,
["astw2_swbf_rep_pistol_commando"] = true,
["astw2_swbf_rep_pistol"] = true,
["astw2_swbf_rep_rifle"] = true,
["astw2_swbf_rep_rifle_dc17"] = true,
["astw2_swbf_rep_carbine"] = true,
["astw2_swbf_rep_pistol_dc17"] = true,
["astw2_swbf_cis_dual_westar34"] = true,
["astw2_swbf_cis_rifle"] = true,
["astw2_swbf_nym_rifle"] = true,
["astw2_swbf_tor_carbine"] = true,
["astw2_swbf_tor_chaingun"] = true,
["astw2_swbf_tor_pistol"] = true,
["astw2_swbf_tor_heavy_blaster"] = true,
["astw2_swbf_tor_rifle"] = true,
["astw2_swbf_mrc_defender"] = true,
["astw2_swbf_sth_pistol"] = true,
["astw2_swbf_cis_pistol"] = true,
["astw2_swbf_sth_blaster"] = true,
["astw2_swbf_sth_rifle"] = true,
["astw2_swbf_mrc_underslung"] = true,
    -- Adicione mais armas conforme necessário
}

function ENT:Use(activator)
    if (self.use) then
        if self:GetAmount() > 0 then
            local weapon = activator:GetActiveWeapon()
            local weaponClass = weapon:GetClass()

            if allowedWeapons[weaponClass] then
                local curAmmoType = weapon:GetPrimaryAmmoType()
                activator:GiveAmmo(450, curAmmoType)

                self:SetAmount(math.Clamp(self:GetAmount() - 1, 0, 4))

                self.use = false
                timer.Create("InUseAmmoCrate", 0.3, 1, function() self.use = true end)
            else
                activator:ChatPrint("Esta arma não pode receber munição desta caixa.")
            end
        elseif self:GetAmount() <= 0 then
            self:Remove()
        end
    end
end


function usereply(self)
    self.use = true
end