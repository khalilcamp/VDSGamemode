NCS_PERMAWEAPONS.CFG = {
    charsysselected = false,
    currency = "darkrp",
    onecat = false,
    camienabled = false,
    admins = {["superadmin"] = "World"},
    prefix = "PermaWeapons",
    prefixcolor = Color(255,0,0),
    model = "models/odessa.mdl",
    stances = {	
        "pose_standing_02", 
        "idle_all_01",
        "idle_all_02",
    },
    randomize = true,
    accent = Color(30,150,220),
    savevendorcommand = "!pmwvendorsave",
}

NCS_PERMAWEAPONS.WEP_TEMPLATE = {
    NAME = "Undetermined",
    CLASS = "weapon_class",
    PRICE = 200,
    MODEL = "models/error.mdl",
    TEAMS = {},
    RANKS = {},
    CATEGORY = "Undetermined",
    BUYABLE = true,
    LEVEL = 0,
}