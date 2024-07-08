local CAT = "BF2 Turret"

RDV.LIBRARY.AddConfigOption("BF2Turret_rotationSpeed", { 
    TYPE = RDV.LIBRARY.TYPE.NM, 
    CATEGORY = CAT, 
    DESCRIPTION = "Rotation Speed of Turret", 
    DEFAULT = 50, 
    SECTION = "Core",
    MIN = 1,
    MAX = 500,
})
