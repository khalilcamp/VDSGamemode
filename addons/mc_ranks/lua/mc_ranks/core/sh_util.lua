-- ╔═╗╔═╦═══╦═══╗───────────────────────
-- ║║╚╝║║╔═╗║╔═╗║───────────────────────
-- ║╔╗╔╗║╚═╝║╚══╗──By MacTavish <3──────
-- ║║║║║║╔╗╔╩══╗║───────────────────────
-- ║║║║║║║║╚╣╚═╝║───────────────────────
-- ╚╝╚╝╚╩╝╚═╩═══╝───────────────────────

function MRS.TableCompress(data)
	local json_data = util.TableToJSON(data, false)
	local compressed_data = util.Compress(json_data)
	local bytes_number = string.len(compressed_data)

	return compressed_data, bytes_number
end

-- Thx wiki
function MRS.StringFormat( fmt, ... )
	local arg = { ... }
	return fmt:gsub( "{(%d+)}", function( i ) return arg[ tostring( i ) + 1 ] end )
end

function MRS.TableDecompress(compressed_data)
	local json_data = util.Decompress(compressed_data)
	local data = util.JSONToTable(json_data)

	return data
end

function MRS.CheckID(id)
	if tonumber(id) then return false end
	return id
end

function MRS.PlayerID(ply, id)
	if ix then return ply:AccountID() .. "IX" .. (ply:GetCharacter() and ply:GetCharacter():GetID() or 0) end
	if Aden_DC then return ply:AccountID() .. "AC" .. (id or (ply.adcInformation and ply.adcInformation.selectedCharacter or 0)) end
	if VoidChar then return ply:AccountID() .. "VC" .. (ply:GetCharacterID() or 0) end
	if ACC2 then return ply:AccountID() .. "ACC2" .. (id or (ACC2.GetNWVariables("characterId", ply) or 0)) end

	return ply:SteamID()
end

function MRS.IsCharSystemOn()
	return VoidChar or ix or Aden_DC
end

function MRS.FindPlayer(info)
	if not info or info == "" then return nil end
	local pls = player.GetAll()

	for k = 1, #pls do -- Proven to be faster than pairs loop.
		local v = pls[k]
		if tonumber(info) == v:UserID() then
			return v
		end

		if info == v:SteamID() then
			return v
		end

		if string.find(string.lower(v:Nick()), string.lower(tostring(info)), 1, true) ~= nil then
			return v
		end

		if string.find(string.lower(v:SteamName()), string.lower(tostring(info)), 1, true) ~= nil then
			return v
		end
	end
	return nil
end

concommand.Add("mrs_export", function(ply, cmd, args)
	if not MRS.IsAdministrator(ply) then return end

	if not file.Exists("mrs_savedranks", "DATA") then
		file.CreateDir("mrs_savedranks")
		MsgC(Color(0, 255, 0), "[MRS] mrs_savedranks dir created \n")
	end

	for k, v in pairs(MRS.Ranks) do
		local json = util.TableToJSON(v, true)
		file.Write("mrs_savedranks/" .. k .. ".txt", json)

		print("File saved to DATA folder as " .. k .. ".txt")
	end
end)