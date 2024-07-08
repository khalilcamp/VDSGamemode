NCS_DATAPAD.CONFIG = {
    MODEL = "models/lordtrilobite/starwars/isd/imp_console_medium02.mdl",
    HackTime = 30,
    PREFIX = "Datapad",
    PREFIX_C = Color(255,0,0),
    ENGINEERS = {},
    COMMAND = "!dapconfig",
    CAMI = false,
    USERGROUPS = { ["superadmin"] = "World" },
    SendDelay = 30,
    SendEnabled = true,
    LANG = "en",
    CharSystemSelected = false,
    CurrencySystemSelected = "darkrp",
    AMMOLIST = {},
    ArchiveAccess = {},
    giveDatapad = true,
}

NCS_DATAPAD.C_DERMA = {}

function NCS_DATAPAD.CreatePlugin(name)
    local TAB = string.Explode("/", debug.getinfo( 2 ).short_src)

    NCS_DATAPAD.PFolders[TAB[6]] = name

    NCS_DATAPAD.Plugins[name] = NCS_DATAPAD.Plugins[name] or {}

    NCS_DATAPAD.Plugins[name] = {
        AddedConfigDerma = {},
        DoClick = function()

        end,
        AddConfigurationDerma = function(s, callback)
            table.insert(NCS_DATAPAD.C_DERMA, callback)
        end,
    }

    return NCS_DATAPAD.Plugins[name]
end

function NCS_DATAPAD.GetPlugin(NAME)
    if !NAME then
        local TAB = string.Explode("/", debug.getinfo( 2 ).short_src)

        NAME = NCS_DATAPAD.PFolders[TAB[6]]
    end

    if !NAME then
        return
    end
    
    return NCS_DATAPAD.Plugins[NAME]
end

function NCS_DATAPAD.IsAdmin(P, CB)
    if NCS_DATAPAD.CONFIG.CAMI then
        CAMI.PlayerHasAccess(P, "[NCS] Datapad", function(ACCESS)
            CB(ACCESS)
        end )
    else
        if NCS_DATAPAD.CONFIG.USERGROUPS[P:GetUserGroup()] then
            CB(true)
        else
            CB(false)
        end
    end
end