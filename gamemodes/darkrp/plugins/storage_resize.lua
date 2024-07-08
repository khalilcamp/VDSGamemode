local PLUGIN = PLUGIN

PLUGIN.name = "Storage Container Resize"
PLUGIN.desc = "Resize storage containers."
PLUGIN.author = "Riggs.mackay"

ix.container.Register("models/props_junk/wood_crate001a.mdl", {
    name = "Caixa de madeira",
    description = "Um simples caixote de madeira.",
    width = 7,
    height = 7,
})

ix.container.Register("models/props_c17/lockers001a.mdl", {
    name = "Armário",
    description = "Um armário branco.",
    width = 8,
    height = 8,
})

ix.container.Register("models/props_wasteland/controlroom_storagecloset001a.mdl", {
    name = "Armário de metal grande",
    description = "Um gabinete de metal verde.",
    width = 9,
    height = 9,
})

ix.container.Register("models/niksacokica/containers/con_box_crate_06.mdl", {
    name = "Carregamento",
    description = "Um unidade de armário que serve para armazenar itens.",
    width = 9,
    height = 9,
})

ix.container.Register("models/niksacokica/containers/con_treasure_chest_03.mdl", {
    name = "Cofre",
    description = "Um unidade de armário que serve para armazenar itens.",
    width = 6,
    height = 6,
})

ix.container.Register("models/niksacokica/republic/rep_crate.mdl", {
    name = "Caixa de Metal",
    description = "Um unidade de armário que serve para armazenar itens.",
    width = 8,
    height = 6,
})

ix.container.Register("models/props_wasteland/controlroom_storagecloset001b.mdl", {
    name = "Armário de metal grande",
    description = "Um gabinete de metal verde.",
    width = 9,
    height = 9,
})

ix.container.Register("models/props_wasteland/controlroom_filecabinet001a.mdl", {
    name = "Armário de arquivo",
    description = "Um gabinete de arquivo de metal.",
    width = 5,
    height = 3,
})

ix.container.Register("models/props_wasteland/controlroom_filecabinet002a.mdl", {
    name = "Armário de arquivo médio",
    description = "Um gabinete de arquivo de metal.",
    width = 5,
    height = 8,
})

ix.container.Register("models/props_lab/filecabinet02.mdl", {
    name = "Armário de arquivo",
    description = "Um gabinete de arquivo de metal.",
    width = 5,
    height = 3,
})

ix.container.Register("models/props_c17/furniturefridge001a.mdl", {
    name = "Geladeira",
    description = "Uma caixa de metal para guardar alimentos.",
    width = 6,
    height = 7,
})

ix.container.Register("models/props_wasteland/kitchen_fridge001a.mdl", {
    name = "Geladeira grande",
    description = "Uma caixa metálica grande para armazenar ainda mais alimentos.",
    width = 9,
    height = 9,
})

ix.container.Register("models/props_junk/trashbin01a.mdl", {
    name = "Lixeira",
    description = "O que você espera encontrar aqui?",
    width = 7,
    height = 3,
})

ix.container.Register("models/props_junk/trashdumpster01a.mdl", {
    name = "Caçamba de lixo",
    description = "Uma lixeira destinada a armazenar lixo. Ela emana um cheiro desagradável.",
    width = 9,
    height = 9,
})

ix.container.Register("models/props_forest/footlocker01_closed.mdl", {
    name = "Footlocker",
    description = "Um pequeno baú para guardar seus pertences.",
    width = 6,
    height = 5,
})

ix.container.Register("models/items/item_item_crate.mdl", {
    name = "Caixa de itens",
    description = "Um caixote para guardar alguns pertences.",
    width = 5,
    height = 4,
})

ix.container.Register("models/props_c17/cashregister01a.mdl", {
    name = "Caixa registradora",
    description = "Um registro com alguns botões e uma gaveta.",
    width = 2,
    height = 2,
})

ix.container.Register("models/items/ammocrate_smg1.mdl", {
    name = "Caixa de munição",
    description = "Um caixote pesado que armazena munição.",
    width = 8,
    height = 6,
    OnOpen = function(entity, activator)
        local closeSeq = entity:LookupSequence("Close")
        entity:ResetSequence(closeSeq)

        timer.Simple(2, function()
            if (entity and IsValid(entity)) then
                local openSeq = entity:LookupSequence("Open")
                entity:ResetSequence(openSeq)
            end
        end)
    end,
})

ix.container.Register("models/items/ammocrate_rockets.mdl", {
    name = "Caixa de munição",
    description = "Um caixote pesado que armazena munição.",
    width = 8,
    height = 6,
    OnOpen = function(entity, activator)
        local closeSeq = entity:LookupSequence("Close")
        entity:ResetSequence(closeSeq)

        timer.Simple(2, function()
            if (entity and IsValid(entity)) then
                local openSeq = entity:LookupSequence("Open")
                entity:ResetSequence(openSeq)
            end
        end)
    end,
})

ix.container.Register("models/items/ammocrate_ar2.mdl", {
    name = "Caixa de munição",
    description = "Um caixote pesado que armazena munição.",
    width = 8,
    height = 6,
    OnOpen = function(entity, activator)
        local closeSeq = entity:LookupSequence("Close")
        entity:ResetSequence(closeSeq)

        timer.Simple(2, function()
            if (entity and IsValid(entity)) then
                local openSeq = entity:LookupSequence("Open")
                entity:ResetSequence(openSeq)
            end
        end)
    end,
})

ix.container.Register("models/items/ammocrate_grenade.mdl", {
    name = "Caixa de munição",
    description = "Um caixote pesado que armazena munição.",
    width = 8,
    height = 6,
    OnOpen = function(entity, activator)
        local closeSeq = entity:LookupSequence("Close")
        entity:ResetSequence(closeSeq)

        timer.Simple(2, function()
            if (entity and IsValid(entity)) then
                local openSeq = entity:LookupSequence("Open")
                entity:ResetSequence(openSeq)
            end
        end)
    end,
})