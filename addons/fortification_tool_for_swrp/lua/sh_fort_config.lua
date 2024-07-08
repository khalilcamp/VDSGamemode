-- Change to true to disable the default structures
JoeFort.configoverride = true  
-- Determines the standard size of the Ressource Pool
JoeFort.Ressources = 400


JoeFort:AddEnt("Tela pequena","Telas",{
  classname = "",
  model = "models/props_c17/fence02b.mdl",
  health = 100,
  buildtime = 3,
  neededresources = 3,
})

JoeFort:AddEnt("Tela","Telas",{
  classname = "",
  model = "models/props_c17/fence02a.mdl",
  health = 100,
  buildtime = 3,
  neededresources = 3,
})

JoeFort:AddEnt("Tela Reforçada","Telas",{
  classname = "",
  model = "models/fortifications/metal_barrier.mdl",
  health = 1000,
  buildtime = 5,
  neededresources = 150,
})

JoeFort:AddEnt("Tela Larga","Telas",{
  classname = "",
  model = "models/props_c17/fence03a.mdl",
  health = 300,
  buildtime = 5,
  neededresources = 30,
})

JoeFort:AddEnt("Porta","Telas",{
  classname = "",
  model = "models/props_wasteland/interior_fence002e.mdl",
  health = 75,
  buildtime = 5,
  neededresources = 10,
})

JoeFort:AddEnt("Barricada de Concreto","Barricadas",{
  classname = "",
  model = "models/fortifications/concrete_barrier_01.mdl",
  health = 350,
  buildtime = 5,
  neededresources = 30,
})

JoeFort:AddEnt("Barricada Pequena","Barricadas",{
  classname = "",
  model = "models/fortifications/concrete_barrier_02.mdl",
  health = 500,
  buildtime = 5,
  neededresources = 15,
})

JoeFort:AddEnt("Barricada de Disparo","Barricadas",{
  classname = "",
  model = "models/fortifications/metal_barrier_02.mdl",
  health = 800,
  buildtime = 5,
  neededresources = 30,
})

JoeFort:AddEnt("Barricada de Disparo Grande","Barricadas",{
  classname = "",
  model = "models/fortifications/metal_barrier_04.mdl",
  health = 1300,
  buildtime = 5,
  neededresources = 50,
})

JoeFort:AddEnt("Gonk","Droides Suporte",{
  classname = "gonk_droid",
  model = "models/props/starwars/tech/gonk_droid.mdl",
  health = 500,
  buildtime = 5,
  neededresources = 30,
})

JoeFort:AddEnt("Medico","Droides Suporte",{
  classname = "medical_droid",
  model = "models/props/starwars/medical/health_droid.mdl",
  health = 500,
  buildtime = 5,
  neededresources = 30,
})

JoeFort:AddEnt("Cabana Pequena","Cabanas",{
  classname = "",
  model = "models/starwars/syphadias/props/sw_tor/bioware_ea/props/republic/rep_tent_leanto.mdl",
  health = 1500,
  buildtime = 5,
  neededresources = 45,
})

JoeFort:AddEnt("Cabana Media","Cabanas",{
  classname = "",
  model = "models/starwars/syphadias/props/sw_tor/bioware_ea/props/republic/rep_tent_medium.mdl",
  health = 2200,
  buildtime = 5,
  neededresources = 60,
})

JoeFort:AddEnt("Cabana Grande","Cabanas",{
  classname = "",
  model = "models/starwars/syphadias/props/sw_tor/bioware_ea/props/republic/rep_tent_large.mdl",
  health = 3500,
  buildtime = 100,
  neededresources = 100,
})

JoeFort:AddEnt("Cabana Reforçada","Cabanas",{
  classname = "",
  model = "models/starwars/syphadias/props/sw_tor/bioware_ea/props/neutral/neu_bunker.mdl",
  health = 6000,
  buildtime = 100,
  neededresources = 180,
})