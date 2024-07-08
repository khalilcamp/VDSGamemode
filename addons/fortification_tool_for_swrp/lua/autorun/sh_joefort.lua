JoeFort = JoeFort or {}
/*

JoeFort:AddEnt("Barrier","Barriers",{
    classname = string,
    model = string,
    health = int,
    buildtime = int,
    neededresources = int,
    CanSpawn = function(ply, wep)

    end,
    OnSpawn = function(ply,ent)

    end,
    OnDamaged = function(ent, spawner, attacker)

    end,
    OnDestroyed = function(ent, spawner, attacker)

    end,
    OnRepaired = function(spawner, repairer, ent)

    end,
    OnRemoved = function(spawner, remover, ent)

    end,
    OnBuildEntitySpawned = function(spawner, ent)
    
    end,
})

*/

JoeFort.structs = {}
function JoeFort:AddEnt(name,category,data)
    if not name or not category or not data then return end
    if not data.classname or not data.model then return end
    JoeFort.structs[category] = JoeFort.structs[category] or {}

    data.name = name
    data.health = data.health or 100
    data.buildtime = data.buildtime or 10
    data.neededresources = data.neededresources or 25

    table.insert(JoeFort.structs[category], data)
end

function JoeFort:GetRessourcePool()
    return JoeFort.Ressources or 0
end

if file.Exists("sh_fort_config.lua", "LUA") then
    if SERVER then
        include("sh_fort_config.lua")
        AddCSLuaFile("sh_fort_config.lua")
    elseif CLIENT then
        include("sh_fort_config.lua")
    end
end

JoeFort.Ressources = JoeFort.Ressources or 250
if JoeFort.configoverride then return end

JoeFort:AddEnt("Small Fence","Fence",{
    classname = "",
    model = "models/props_c17/fence02b.mdl",
    health = 100,
    buildtime = 10,
    neededresources = 15,
})

JoeFort:AddEnt("Fence","Fence",{
    classname = "",
    model = "models/props_c17/fence02a.mdl",
    health = 150,
    buildtime = 15,
    neededresources = 20,
})

JoeFort:AddEnt("Reinforced Fence","Fence",{
    classname = "",
    model = "models/fortifications/metal_barrier.mdl",
    health = 1000,
    buildtime = 30,
    neededresources = 50,
})

JoeFort:AddEnt("Long Fence","Fence",{
    classname = "",
    model = "models/props_c17/fence03a.mdl",
    health = 300,
    buildtime = 25,
    neededresources = 40,
})

JoeFort:AddEnt("Fence Door","Fence",{
    classname = "",
    model = "models/props_wasteland/interior_fence002e.mdl",
    health = 75,
    buildtime = 5,
    neededresources = 10,
})

JoeFort:AddEnt("Concrete Barrier","Barriers",{
    classname = "",
    model = "models/fortifications/concrete_barrier_01.mdl",
    health = 350,
    buildtime = 15,
    neededresources = 30,
})

JoeFort:AddEnt("Small Concrete Barrier","Barriers",{
    classname = "",
    model = "models/fortifications/concrete_barrier_02.mdl",
    health = 150,
    buildtime = 10,
    neededresources = 15,
})

JoeFort:AddEnt("Combine Barrier","Barriers",{
    classname = "",
    model = "models/props_combine/combine_barricade_short02a.mdl",
    health = 250,
    buildtime = 15,
    neededresources = 20,
})

JoeFort:AddEnt("Small Shooting Barrier","Barriers",{
    classname = "",
    model = "models/fortifications/metal_barrier_02.mdl",
    health = 300,
    buildtime = 15,
    neededresources = 30,
})

JoeFort:AddEnt("Big Shooting Barrier","Barriers",{
    classname = "",
    model = "models/fortifications/metal_barrier_04.mdl",
    health = 500,
    buildtime = 20,
    neededresources = 45,
})

JoeFort:AddEnt("Mine","Traps",{
    classname = "combine_mine",
    model = "models/props_combine/combine_mine01.mdl",
    health = 25,
    buildtime = 5,
    neededresources = 25,
})