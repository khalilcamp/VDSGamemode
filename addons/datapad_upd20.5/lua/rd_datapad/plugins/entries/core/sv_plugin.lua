local OBJ = NCS_DATAPAD.GetPlugin()

local function UseData(ply, data)
	NCS_DATAPAD.E_DATA[ply] = {}
	
    if not data or data[1] == nil then 
		return 
	end

    for k, v in ipairs(data) do
		NCS_DATAPAD.E_DATA[ply][tonumber(v.CONTENT_ID)] = {
            TITLE = v.TITLE,
            GIVER = v.GIVER,
			CONTENT = v.ENTRY,
        }
    end
end

local function SelectData(ply, slot)
	if not IsValid(ply) or not ply.SteamID64 then
		return
	end

	local q = RDV_DP_Mysql:Select("RDV_DATAPAD_ENTRIES")
		q:Select("CONTENT_ID")
		q:Select("TITLE")
		q:Select("ENTRY")
		q:Select("GIVER")
		q:Select("PCHARACTER")
		q:Where("PLAYER", ply:SteamID64())
		q:Where("PCHARACTER", slot)
		q:Callback(function(data)
			UseData(ply, data)
		end)
	q:Execute()
end

timer.Simple(0, function()
	local q = RDV_DP_Mysql:Create("RDV_DATAPAD_ENTRIES")
		q:Create("CONTENT_ID", "INTEGER NOT NULL AUTO_INCREMENT")
		q:Create("PLAYER", "VARCHAR(255)")
		q:Create("PCHARACTER", "INT")
		q:Create("TITLE", "VARCHAR(255)")
		q:Create("ENTRY", "VARCHAR(8000)")
		q:Create("GIVER", "VARCHAR(255)")
		q:PrimaryKey("CONTENT_ID")
	q:Execute()

	local q = RDV_DP_Mysql:Create("RDV_DATAPAD_ARCHIVE")
		q:Create("CONTENT_ID", "INTEGER NOT NULL AUTO_INCREMENT")
		q:Create("CREATOR", "VARCHAR(255)")
		q:Create("ARCHIVER", "VARCHAR(255)")
		q:Create("TITLE", "VARCHAR(255)")
		q:Create("ENTRY", "TEXT")
		q:Create("TIME", "TEXT")
		q:PrimaryKey("CONTENT_ID")
	q:Execute()
end )


NCS_DATAPAD.OnCharacterDeleted(nil, function(ply, slot)
	if !NCS_DATAPAD.GetCharacterEnabled() then return end

	local SID64 = ply:SteamID64()

	local q = RDV_DP_Mysql:Delete("RDV_DATAPAD_ENTRIES")
		q:Where("PLAYER", SID64)
		q:Where("PCHARACTER", slot)
	q:Execute()
end)

NCS_DATAPAD.OnCharacterLoaded(nil, function(ply, slot)
	if !NCS_DATAPAD.GetCharacterEnabled() then return end

	SelectData(ply, slot)
end)

hook.Add("NCS_DATAPAD_PlayerReadyForNetworking", "NCS_DATAPAD.ENTRIES.NETWORKING", function(ply)
	if NCS_DATAPAD.GetCharacterEnabled() then return end

	SelectData(ply, 1)
end)

--]]------------------------------------------------]]--
--	Network Strings
--]]------------------------------------------------]]--

util.AddNetworkString("RDV_DATAPAD_OpenConsoleMenu")
util.AddNetworkString("RDV_DATAPAD_StartConsoleHack")
util.AddNetworkString("RDV_DATAPAD_ConsoleEdited")

util.AddNetworkString("RDV_DATAPAD_GetDescription")
util.AddNetworkString("RDV_DATAPAD_CreateEntry")
util.AddNetworkString("RDV_DATAPAD_GetEntry")
util.AddNetworkString("RDV_DATAPAD_DeleteEntry")
util.AddNetworkString("RDV_DATAPAD_SendEntry")

--]]------------------------------------------------]]--
--	Local Values
--]]------------------------------------------------]]--

local function SendNotification(ply, msg)
	local CFG = {
		Appension = NCS_DATAPAD.CONFIG.PREFIX,
		Color = NCS_DATAPAD.CONFIG.PREFIX_C,
	}

	NCS_DATAPAD.AddText(ply, CFG.Color, "["..CFG.Appension.."] ", color_white, msg)
end

--]]------------------------------------------------]]--
--	Networking
--]]------------------------------------------------]]--

local C_DELAY = {}

util.AddNetworkString("RDV_DATAPAD_ENTRIES_EDIT")

net.Receive("RDV_DATAPAD_ENTRIES_EDIT", function(len, P)
	if C_DELAY[P] and C_DELAY[P] > CurTime() then return end
	
	local UID = net.ReadUInt(16)
	local TITL = net.ReadString()
	local DESC = net.ReadString()

    local ABLE, MSG = OBJ:IsDatapadEntrySafe(TITL, DESC)

    if not ABLE then
        P:ChatPrint(MSG)
        return
    end

	if !NCS_DATAPAD.HasEntry(P, UID) then
		return
	end

	local TAB = P:GetDatapadEntries()[UID]

	local CHARACTER =  ( NCS_DATAPAD.GetCharacterEnabled() and NCS_DATAPAD.GetCharacterID(P, nil) or 1 )

	TAB.TITLE = TITL
	TAB.CONTENT = DESC

	local q = RDV_DP_Mysql:Update("RDV_DATAPAD_ENTRIES")
		q:Update("TITLE", TITL)
		q:Update("ENTRY", DESC)
		q:Where("CONTENT_ID", UID)
	q:Execute()

	net.Start("RDV_DATAPAD_ENTRIES_EDIT")
		net.WriteUInt(UID, 16)
	net.Send(P)

	C_DELAY[P] = CurTime() + 5
end )

net.Receive("RDV_DATAPAD_CreateEntry", function(len, ply)
	if C_DELAY[ply] and C_DELAY[ply] > CurTime() then return end

    local TITL = net.ReadString()
    local DESC = net.ReadString()

    local ABLE, MSG = OBJ:IsDatapadEntrySafe(TITL, DESC)

    if not ABLE then
        ply:ChatPrint(MSG)
        return
    end

	ply:GiveDatapadEntry(TITL, DESC, ply:SteamID64(), function(entry)
		net.Start("RDV_DATAPAD_CreateEntry")
			net.WriteUInt(entry, 16)
		net.Send(ply)
	end)

	C_DELAY[ply] = CurTime() + 5
end)

local NS_DELAY = {}

net.Receive("RDV_DATAPAD_SendEntry", function(len, ply)
	if !NCS_DATAPAD.CONFIG.SendEnabled then return end
	
	if NS_DELAY[ply] and NS_DELAY[ply] > CurTime() then
		SendNotification(ply, NCS_DATAPAD.GetLang(nil, "DAP_sendCooldown"))

		return
	end

	local KEY = net.ReadUInt(16)
	local PLAYER = net.ReadPlayer()

	NS_DELAY[ply] = CurTime() + ( NCS_DATAPAD.CONFIG.SendDelay or 30 )

	local DATA = ply:GetDatapadEntries()[tonumber(KEY)]

	if not DATA then
		return
	end

	local DESC = DATA.CONTENT
	local TITL = DATA.TITLE

	local ABLE, MSG = OBJ:IsDatapadEntrySafe(TITL, DESC)

    if not ABLE then
        ply:ChatPrint(MSG)
        return
    end

	SendNotification(PLAYER, NCS_DATAPAD.GetLang(nil, "DAP_receivedEntry", {TITL, ply:Name()}))

	PLAYER:GiveDatapadEntry(TITL, DESC, ply:SteamID64())
end)

net.Receive("RDV_DATAPAD_StartConsoleHack", function(_, P)
	local CONSOLE = net.ReadEntity()

	if P:GetPos():DistToSqr(CONSOLE:GetPos()) > 15000 then print("eyo") return end
	
	if CONSOLE:GetEntryTitle() == "" || CONSOLE:GetEntryDescription() == "" then
		SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_noContent"))
		return false
	end

	local T_ENGINEERS = NCS_DATAPAD.GetEngineers()

	if ( T_ENGINEERS and table.Count(T_ENGINEERS) > 0 ) and not NCS_DATAPAD.IsEngineer(P) then
		local BOOL_ENGINEER = false

		for k, v in ipairs(player.GetAll()) do
			if T_ENGINEERS[team.GetName(v:Team())] then
				BOOL_ENGINEER = true

				break
			end
		end
	
		if not BOOL_ENGINEER then
			SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_noEngineersOnline"))
		else
			SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_engineersOnline"))

			return false
		end
	end

	CONSOLE:SetHacker(P)

	if ( !CONSOLE:GetHackConsoleTiming() or CONSOLE:GetHackConsoleTiming() == 0 ) then
		if !BOOL_ENGINEER then
			CONSOLE:SetHackTimeRemaining( NCS_DATAPAD.CONFIG.HackTime + (NCS_DATAPAD.CONFIG.HackTime * 0.5) )

		else
			CONSOLE:SetHackTimeRemaining( NCS_DATAPAD.CONFIG.HackTime )
		end
	else 
		CONSOLE:SetHackTimeRemaining(CONSOLE:GetHackConsoleTiming())
	end

	CONSOLE:SetIsHacking(true)
end)

net.Receive("RDV_DATAPAD_ConsoleEdited", function(len, P)
	NCS_DATAPAD.IsAdmin(P, function(ACCESS)
		local CONSOLE = net.ReadEntity()
		local TEXT_CONTENT = net.ReadString()
		local TEXT_TITLE = net.ReadString()

		CONSOLE:SetEntryTitle(TEXT_TITLE)
		CONSOLE:SetEntryDescription(TEXT_CONTENT)

		NCS_DATAPAD.PlaySound(P, "reality_development/ui/ui_accept.ogg")
	end )
end)

net.Receive("RDV_DATAPAD_GetDescription", function(len, P)
	local KEY = net.ReadUInt(16)

	if !NCS_DATAPAD.HasEntry(P, KEY) then
		return
	end

	local DESC = P:GetDatapadEntries()[tonumber(KEY)].CONTENT

	if not DESC or DESC == "" then
		return
	end

	net.Start("RDV_DATAPAD_GetDescription")
		net.WriteString(DESC)
	net.Send(P)
end)

net.Receive("RDV_DATAPAD_DeleteEntry", function(len, P)
	local KEY = net.ReadUInt(16)

	if !NCS_DATAPAD.HasEntry(P, KEY) then
		return
	end

	local q = RDV_DP_Mysql:Delete("RDV_DATAPAD_ENTRIES")
		q:Where("CONTENT_ID", KEY)
	q:Execute()
	
	P:GetDatapadEntries()[KEY] = nil
end)

net.Receive("RDV_DATAPAD_GetEntry", function(len, ply)
	local TAB = ply:GetDatapadEntries()
	
	net.Start("RDV_DATAPAD_GetEntry")
		net.WriteTable( (TAB or {}) )
	net.Send(ply)
end)

local plyMeta = FindMetaTable("Player")

function plyMeta:GiveDatapadEntry(TITLE, CONTENT, GIVER, CALLBACK)
	if !TITLE || !CONTENT then
		return
	end

	if !GIVER then
		GIVER = "N/A"
	end

	if IsValid(GIVER) then
		GIVER = GIVER:SteamID64()
	end

	local CHARACTER =  ( NCS_DATAPAD.GetCharacterEnabled() and NCS_DATAPAD.GetCharacterID(self, nil) or 1 )

	NCS_DATAPAD.E_DATA[self] = NCS_DATAPAD.E_DATA[self] or {}

	local q = RDV_DP_Mysql:Insert("RDV_DATAPAD_ENTRIES")
		q:Insert("PLAYER", self:SteamID64())
		q:Insert("PCHARACTER", CHARACTER)
		q:Insert("TITLE", TITLE)
		q:Insert("ENTRY", CONTENT)
		q:Insert("GIVER", GIVER)
		q:Callback(function(data, idk, last)
			local entry = last

			NCS_DATAPAD.E_DATA[self][tonumber(entry)] = {
				TITLE = TITLE,
				CONTENT = CONTENT,
				GIVER = GIVER
			}

			if CALLBACK then
				CALLBACK(entry)
			end
		end)
	q:Execute()
end

local NS_ArchiveDelay = {}

util.AddNetworkString("NS_DATAPAD_ArchiveConsole")

net.Receive("NS_DATAPAD_ArchiveConsole", function(_, P)
	if NS_ArchiveDelay[P] and NS_ArchiveDelay[P] > CurTime() then return end

	NCS_DATAPAD.IsAdmin(P, function(ACCESS)
		if ACCESS or NCS_DATAPAD.CONFIG.ArchiveAccess[team.GetName(P:Team())] then
			local KEY = net.ReadUInt(16)

			local TAB = P:GetDatapadEntries()

			if !TAB[KEY] then return end

			local CONTENT = TAB[KEY].CONTENT
			local TITLE = TAB[KEY].TITLE
			local GIVER = TAB[KEY].GIVER

			local q = RDV_DP_Mysql:Insert("RDV_DATAPAD_ARCHIVE")
				q:Insert("ARCHIVER", P:SteamID64())
				q:Insert("CREATOR", P:SteamID64())
				q:Insert("TITLE", TITLE)
				q:Insert("ENTRY", CONTENT)
				q:Insert("TIME", os.time())
				q:Callback(function(data, idk, last)
					local entry = last

					table.insert(NCS_DATAPAD.E_ARCHIVED, {
						UID = entry,
						TITLE = TITLE,
						TIME = os.time(),
						CONTENT = CONTENT,
						GIVER = GIVER,
						ARCHIVER = P:SteamID64(),
					})

					SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_archivedSuccess", {TITLE}))
				end)
			q:Execute()
		else
			SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_noArchiveAccess"))
		end
	end )

	NS_ArchiveDelay[P] = CurTime() + 5
end )

util.AddNetworkString("NS_DATAPAD_DeleteArchived")
net.Receive("NS_DATAPAD_DeleteArchived", function(_, P)
	local EUID = net.ReadUInt(32)

	if NS_ArchiveDelay[P] and NS_ArchiveDelay[P] > CurTime() then return end

	NCS_DATAPAD.IsAdmin(P, function(ACCESS)
		if ACCESS or NCS_DATAPAD.CONFIG.ArchiveAccess[team.GetName(P:Team())] then
			local q = RDV_DP_Mysql:Delete("RDV_DATAPAD_ARCHIVE")
				q:Where("CONTENT_ID", EUID)
				q:Callback(function(data, idk, last)
					for k, v in pairs(NCS_DATAPAD.E_ARCHIVED) do
						if tonumber(v.UID) == tonumber(EUID) then
							NCS_DATAPAD.E_ARCHIVED[k] = nil
						end
					end
				end )
			q:Execute()
		else
			SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_noArchiveAccess"))
		end
	end )
end )

util.AddNetworkString("NS_DATAPAD_GetArchived")
net.Receive("NS_DATAPAD_GetArchived", function(_, P)
	if NS_ArchiveDelay[P] and NS_ArchiveDelay[P] > CurTime() then return end

	NCS_DATAPAD.IsAdmin(P, function(ACCESS)
		if ACCESS or NCS_DATAPAD.CONFIG.ArchiveAccess[team.GetName(P:Team())] then
			local PAGE = net.ReadUInt(8)
			local SEARCH = net.ReadString()

			local QUERY 

			if SEARCH and SEARCH ~= "" then
				QUERY = "SELECT * FROM RDV_DATAPAD_ARCHIVE WHERE TITLE LIKE '%"..SEARCH.."%' ORDER BY CONTENT_ID DESC LIMIT 4 OFFSET "..(PAGE * 4)..""
			else
				QUERY = "SELECT * FROM RDV_DATAPAD_ARCHIVE ORDER BY CONTENT_ID DESC LIMIT 4 OFFSET "..(PAGE * 4)..""
			end

			local TEST = RDV_DP_Mysql:RawQuery(QUERY, function(data)
				net.Start("NS_DATAPAD_GetArchived")
					if !data or data[1] == nil then
						net.WriteBool(false)
					else
						net.WriteBool(true)
						net.WriteTable(data)
					end
				net.Send(P)
			end )
		else
			SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_noArchiveAccess"))
		end
	end )

	NS_ArchiveDelay[P] = CurTime() + 1
end )

