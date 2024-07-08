if NCS_DATAPAD.LoadedEnts then return end

util.AddNetworkString("RDV_DAP_SaveEntities")
net.Receive("RDV_DAP_SaveEntities", function(_, P)
	NCS_DATAPAD.IsAdmin(P, function(ACCESS)
		if !ACCESS then return end

		NCS_DATAPAD.StartEntitySave()
	end )
end )

local EDATA = {}
local L_SAVE = {}

function NCS_DATAPAD.AddEntitySave(class, data)
	L_SAVE[class] = data
end

function NCS_DATAPAD.StartEntitySave()
	file.CreateDir("rdv/datapad/")

	local DATA = {}

	for k, v in ipairs(ents.GetAll()) do
		local E = L_SAVE[v:GetClass()]

		if !E then continue end
		
		local _DATA = {}

		if E.onSave then
			E:onSave(v, function(RETURN)
				table.Merge(_DATA, RETURN)
			end )
		end

		_DATA.pos = v:GetPos()
		_DATA.ang = v:GetAngles()
		_DATA.class = v:GetClass()
		_DATA.model = v:GetModel()

		table.insert(DATA, _DATA)
	end

    EDATA = DATA
	file.Write("rdv/datapad/entities_"..game.GetMap()..".json", util.TableToJSON(DATA))
end

local function SpawnEntities()
	for k, v in ipairs(EDATA) do
		local E = L_SAVE[v.class]

		if !E then continue end

		local RE = ents.Create(v.class)
		RE:SetPos(v.pos)
		RE:SetAngles(v.ang)
		RE:SetModel(v.model)
		RE:Spawn()

		if E.onLoad then
			E:onLoad(RE, v)
		end
	end
end

local function ReadEntities()
	file.CreateDir("rdv/datapad/")

	if !file.Exists("rdv/datapad/entities_"..game.GetMap()..".json", "DATA") then return end

	local DATA = file.Read("rdv/datapad/entities_"..game.GetMap()..".json", "DATA")

	if DATA then
		DATA = util.JSONToTable(DATA)

		if !DATA then return end

		EDATA = DATA

        SpawnEntities()
	end
end
timer.Simple(0, ReadEntities)


hook.Add("PostCleanupMap", "NCS_DAP_ResetEnts", function()
    SpawnEntities()
end )

NCS_DATAPAD.AddEntitySave("st_hackable_console", {
	onSave = function(SELF, E, DATA)
		DATA({
			title = E:GetEntryTitle(),
			desc = E:GetEntryDescription(),
		})
	end,
	onLoad = function(SELF, E, DATA)
		if DATA.title and DATA.desc then
			E:SetEntryTitle(DATA.title)
			E:SetEntryDescription(DATA.desc)
		end
	end,
})

NCS_DATAPAD.AddEntitySave("dev_hackable_console_door", {
	onSave = function(SELF, E, DATA)
		local LINKED = NCS_DATAPAD.E_LINKED[E]

		if !LINKED then return end

		local IDLIST = {}

		for k, v in ipairs(LINKED) do
			table.insert(IDLIST, v.Id)
		end
	
		DATA({
			doors = IDLIST,
		})
	end,
	onLoad = function(SELF, E, DATA)
		if DATA.doors then
			for k, v in ipairs(DATA.doors) do
				local D = ents.GetMapCreatedEntity(v)

				if !IsValid(D) then continue end

				NCS_DATAPAD.E_LINKED[E] = NCS_DATAPAD.E_LINKED[E] or {}

				table.insert(NCS_DATAPAD.E_LINKED[E], {
					Id = v,
					Ent = D,
				})

				D:Fire("lock")
			end
		end
	end,
})

NCS_DATAPAD.AddEntitySave("ns_archiveconsole", {})

hook.Add("PlayerUse", "NCS_DAP_EntityUse", function(P, E)
	local LIST = {
		["st_hackable_console"] = true,
		["dev_hackable_console_door"] = true,
	}

	if LIST[E:GetClass()] then
		P:SelectWeapon("datapad_player")
	end
end )

NCS_DATAPAD.LoadedEnts = true