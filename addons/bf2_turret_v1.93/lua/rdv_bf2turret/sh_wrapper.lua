local LIST = {}
local CLASSES = {}

local TURRET_META = {
    SetEnemyTeams = function(self, tab)
        self.TEAMS = {}

        if ( tab == true ) then
            for k, v in ipairs(team.GetAllTeams()) do
                self.TEAMS[k] = true
            end

            return
        end

        for k, v in ipairs(tab) do
            self.TEAMS[v] = true
        end
    end,
    SetEnemyVehicles = function(self, tab)
        self.VEHICLES = {}

        for k, v in ipairs(tab) do
            self.VEHICLES[v] = true
        end
    end,
    SetEnemyNPCs = function(self, tab)
        self.NPCS = {}

        for k, v in ipairs(tab) do
            self.NPCS[v] = true
        end
    end,
    SetDestructTime = function(self, time)
        self.DESTRUCT = time
    end,
    SetAttackDamage = function(self, dam)
        self.ATTDAMAGE = dam
    end,
    Register = function(self, bl)
        if bl == false then return end

        local TAB = scripted_ents.Get("rdv_bf2turret")
        TAB.E_TEAMS = ( self.TEAMS or {} )
        TAB.E_VEHIC = ( self.VEHICLES or {} )
        TAB.E_NPC = ( self.NPCS or {} )
        TAB.ATTDAMAGE = (self.ATTDAMAGE or 5)
        TAB.ClassName = "rdv_bf2turret_"..self.NAME

        if self.DESTRUCT then
            TAB.O_DESTRUCT = self.DESTRUCT
        end

        TAB.Spawnable = true
        TAB.PrintName = TAB.PrintName.." ("..self.NAME..")"

        scripted_ents.Register( TAB, "rdv_bf2turret_"..self.NAME )

        local TAB_SWEP = weapons.Get("turret_placer")
        TAB_SWEP.ClassName = "turret_placer"..self.NAME
        TAB_SWEP.turretSpawnClass = "rdv_bf2turret_"..self.NAME
        TAB_SWEP.PrintName = TAB.PrintName.." ("..self.NAME..")"
        TAB_SWEP.Spawnable = true

        weapons.Register( TAB_SWEP, "turret_placer"..self.NAME )

        CLASSES["rdv_bf2turret_"..self.NAME] = true
    end,
}

TURRET_META.__index = TURRET_META

function RDV.BF2_TURRET.GetVariants()
    return CLASSES
end

function RDV.BF2_TURRET.AddVariant(name)
    name = string.lower(name)

    LIST[name] = {
        NAME = name,
    }

    setmetatable( LIST[name], TURRET_META ) -- Setting up the metatable.

    return LIST[name]
end

