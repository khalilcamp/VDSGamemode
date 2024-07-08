TOOL.Category = "[RDV] Datapad"
TOOL.Name = "Hackable Door"

if CLIENT then
    language.Add("tool.dev_doors_tool.name", "Hackable Door Tool")
    language.Add("tool.dev_doors_tool.desc", "Hackable Door Tool made by Nicolas.")
    language.Add("tool.dev_doors_tool.left", "Create Doors")
    language.Add("tool.dev_doors_tool.right", "Create Console")

    language.Add("hackableDoorTool", "Hackable Door Tool")
end

local DOOR = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_movelinear"] = true,
    ["prop_dynamic"] = true
}

local T_CREATED = {}

if SERVER then
    function TOOL:LeftClick(t)
		T_CREATED[self] = T_CREATED[self] or {}

		if IsValid(t.Entity) and not t.Entity:IsPlayer() and t.Entity ~= game.GetWorld() then
			table.insert(T_CREATED[self], {
				Ent = t.Entity,
				Id = t.Entity:MapCreationID(),
			})
		end

    	return true
    end

    function TOOL:RightClick(t)
    	if T_CREATED[self] and #T_CREATED[self] > 0 then
			local console = ents.Create("dev_hackable_console_door")
			console:SetPos(t.HitPos)
			console:SetAngles(Angle(0, self:GetOwner():GetAngles().y + 180, 0))
			console:Spawn()
			console:SetMoveType(MOVETYPE_NONE)

			if not IsValid(console) then return end

			NCS_DATAPAD.E_LINKED[console] = T_CREATED[self]

			undo.Create("Hackable Door Console")
				undo.AddEntity(console)
				undo.SetPlayer(self:GetOwner())
			undo.Finish()

			for k, v in ipairs(T_CREATED[self]) do
				if IsValid(v.Ent) and DOOR[v.Ent:GetClass()] then
					v.Ent:Fire("lock")
				end
			end

			T_CREATED[self] = {}
    	end

    	return true
    end

	function TOOL:Reload()

	end
else
    function TOOL:LeftClick(t)

    	return true
    end

    function TOOL:RightClick(t)


    	return true
    end
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(CPanel)
    CPanel:SetName("hackableDoorTool")

    CPanel:Help("Left click to select entities to act as doors, Right click to place a console attached to these doors.")
end

function TOOL:Holster()
    T_CREATED[self] = {}
end

