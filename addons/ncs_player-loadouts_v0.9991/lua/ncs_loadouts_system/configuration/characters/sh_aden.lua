local OBJ = NCS_LOADOUTS.RegisterCharacter("aden")

if SERVER then
    local DELETE = {}
    local LOAD = {}
    local CHANGE = {}

    hook.Add("Tick", "NCS_LOADOUTS_ADEN_LOAD", function()

        if Aden_DC and Aden_DC.Support and Aden_DC.Support.List then
            print("We've Found Aden's Character System...")

            hook.Remove("Tick", "NCS_LOADOUTS_ADEN_LOAD")

            function OBJ:GetCharacterID(p)
                if not p.adcInformation.selectedCharacter then
                    return
                end
            
                return (p.adcInformation.selectedCharacter or 1)
            end
        
            Aden_DC.Support.List["NCS_LOADOUTS"] = {
                preChangeCharacter = function(ply, OCHAR, char)
                    if OCHAR and ( char ~= OCHAR ) then
                        for k, v in ipairs(CHANGE) do
                            v(ply, char, OCHAR)
                        end
                    end
                end,
                deleteCharacter = function(ply, char)
                    for k, v in ipairs(DELETE) do
                        v(ply, char)
                    end
                end,
                loadCharacter = function(ply, char)
                    for k, v in ipairs(LOAD) do
                        v(ply, char)
                    end
                end,
            }
        end
    end )

    function OBJ:OnCharacterDeleted(CALLBACK)
        table.insert(DELETE, CALLBACK)
    end
        
    function OBJ:OnCharacterLoaded(CALLBACK)
        table.insert(LOAD, CALLBACK)
    end
        
    function OBJ:OnCharacterChanged(CALLBACK)
        table.insert(CHANGE, CALLBACK)
    end
end