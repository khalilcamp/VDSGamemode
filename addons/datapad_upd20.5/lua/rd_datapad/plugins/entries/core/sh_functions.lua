local OBJ = NCS_DATAPAD.GetPlugin()

function OBJ:IsDatapadEntrySafe(TITLE, DESCRIPTION)
    if #TITLE <= 0 or #DESCRIPTION <= 0 then
        return false, NCS_DATAPAD.GetLang(nil, "DAP_fillOutFully")
    end

    local MAX_DESC = (NCS_DATAPAD.CONFIG.DescLimit or 0)
    local MAX_TITL = (NCS_DATAPAD.CONFIG.TitleLimit or 0)
    
    if #TITLE > MAX_TITL or #DESCRIPTION > MAX_DESC then
        return false, NCS_DATAPAD.GetLang(nil, "DAP_entryExceedsLimit")
    end

    return true
end

local plyMeta = FindMetaTable("Player")

function plyMeta:GetDatapadEntries()
	return ( NCS_DATAPAD.E_DATA[self] or {} )
end

function NCS_DATAPAD.HasEntry(P, KEY)
    if !IsValid(P) then return end

    local ENTRIES = P:GetDatapadEntries()

	if not ENTRIES[tonumber(KEY)] then
		return false
	end

    return true
end

function NCS_DATAPAD.IsEngineer(T)
    if IsValid(T) and T:IsPlayer() then T = team.GetName(T:Team()) end

    if NCS_DATAPAD.CONFIG.ENGINEERS[T] then
        return true
    end

    return false
end

function NCS_DATAPAD.GetEngineers()
    return ( NCS_DATAPAD.CONFIG.ENGINEERS or {} )
end
