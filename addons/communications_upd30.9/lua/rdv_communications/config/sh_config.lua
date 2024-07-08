local COMMS = RDV.COMMUNICATIONS

COMMS:RegisterChannel("Comunicações Gerais da Republica", {
    Color = Color(100, 181, 232),
    Factions = {
        "SPEC OPS",
        "|Legião 212st|",
        "|Legião 501st|",
        "Clone Trooper",
        "Ordem Jedi",
        "Marinha Republicana",
        "Chanceler",
        "|ShockTrooper| Força de Segurança",
        "|Divisão de Fuzileiros Galaticos|",
        "|Legião 101st|",
    },
    CustomCheck = function(ply)

    end,
})

COMMS:RegisterChannel("Comunicações SPEC OPs", {
    Color = Color(88, 181, 22),
    Factions = {
        "SPEC OPS",
        "Ordem Jedi",
        "Marinha Republicana",
        "Chanceler",
    },
    CustomCheck = function(ply)

    end,
})

COMMS:RegisterChannel("REP-COMMS 4", {
    Color = Color(100, 181, 232),
    Factions = {
        "ARC Trooper",
        "|Legião 212st|",
        "|Legião 501st|",
        "SPEC OPS",
        "Clone Trooper",
        "Ordem Jedi",
        "Marinha Republicana",
        "Chanceler",
         "|Legião 101st|",
        "|ShockTrooper| Força de Segurança",
        "|Divisão de Fuzileiros Galaticos|"
    },
    CustomCheck = function(ply)

    end,
})

COMMS:RegisterChannel("REP-COMMS 1", {
    Color = Color(100, 181, 232),
    Factions = {
        "SPEC OPS",
        "|Legião 212st|",
        "|Legião 501st|",
        "Clone Trooper",
        "Ordem Jedi",
        "Marinha Republicana",
        "Chanceler",
         "|Legião 101st|",
        "|ShockTrooper| Força de Segurança",
        "|Divisão de Fuzileiros Galaticos|"
    },
    CustomCheck = function(ply)

    end,
})

COMMS:RegisterChannel("REP-COMMS 3", {
    Color = Color(100, 181, 232),
    Factions = {
        "SPEC OPS",
        "|Legião 212st|",
        "|Legião 501st|",
        "Clone Trooper",
        "Ordem Jedi",
        "Marinha Republicana",
        "Chanceler",
         "|Legião 101st|",
         "SPEC OPS",
        "|ShockTrooper| Força de Segurança",
        "|Divisão de Fuzileiros Galaticos|"
    },
    CustomCheck = function(ply)

    end,
})

COMMS:RegisterChannel("REP-COMMS 2", {
    Color = Color(100, 181, 232),
    Factions = {
        "SPEC OPS",
        "|Legião 212st|",
        "Clone Trooper",
        "|Legião 501st|",
        "Ordem Jedi",
        "Marinha Republicana",
        "Chanceler",
        "|Legião 101st|",
        "|Divisão de Fuzileiros Galaticos|",
        "|ShockTrooper| Força de Segurança"
    },
    CustomCheck = function(ply)

    end,
})

COMMS:RegisterChannel("Comunicações Gerais Dos Jedi", {
    Color = Color(235, 55, 52),
    Factions = {
        "Ordem Jedi"
    },
    CustomCheck = function(ply)

    end,
})

COMMS:RegisterChannel("COMMS-ST", {
    Color = Color(235, 55, 52),
    Factions = {
        "SPEC OPS",
        "Ordem Jedi",
        "Marinha Republicana",
        "Chanceler",
        "|ShockTrooper| Força de Segurança"
    },
    CustomCheck = function(ply)

    end,
})

COMMS:RegisterChannel("COMMS-212", {
    Color = Color(235, 55, 52),
    Factions = {
        "ARC Trooper",
        "|Legião 212st|",
        "Ordem Jedi",
        "Marinha Republicana",
        "Chanceler",
    },
    CustomCheck = function(ply)

    end,
})

COMMS:RegisterChannel("COMMS-501", {
    Color = Color(235, 55, 52),
    Factions = {
        "SPEC OPS",
        "|Legião 501st|",
        "Ordem Jedi",
        "Marinha Republicana",
        "Chanceler",
    },
    CustomCheck = function(ply)

    end,
})