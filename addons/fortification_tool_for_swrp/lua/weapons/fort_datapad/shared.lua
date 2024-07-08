SWEP.PrintName = "Fortification Datapad"
SWEP.Author =	"Joe"
SWEP.Contact = "Workshop"
SWEP.Slot = 5
SWEP.SlotPos = -1
SWEP.Instructions = [[
R - Opens up the Menu
E - rotates prop
LMB - spawns prop
RMB - rotates through structures in selected category
]]
SWEP.Spawnable =	true
SWEP.Adminspawnable =	false
SWEP.Category = "Datapads"
SWEP.ShowWorldModel = false

SWEP.Primary.Clipsize =	-1
SWEP.Primary.DefaultClip =	-1
SWEP.Primary.Automatic =	false
SWEP.Primary.Ammo =	"none"

SWEP.Secondary.Clipsize =	-1
SWEP.Secondary.DefaultClip =	-1
SWEP.Secondary.Automatic =	false
SWEP.Secondary.Ammo =	"none"
SWEP.UseHands = true

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/joes/c_datapad.mdl"
SWEP.WorldModel = "models/joes/w_datapad.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.DrawCrosshair = false

SWEP.selectcat = ""
SWEP.selectnum = 1
SWEP.selectmdl = ""
SWEP.rotation = 0

SWEP.secondarycooldown = 0
SWEP.cld = 0

SWEP.Range = 300

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
end

function SWEP:GetViewModelPosition(pos, ang)
	pos = pos - Vector(0,0,3.5)
	return pos,ang
end

function SWEP:PrimaryAttack()
	if not SERVER then return end
	if not self.selectmdl or self.selectmdl == "" then return end
	local ply = self.Owner
	local trace = ply:GetEyeTrace()
	if trace.HitPos:DistToSqr(self.Owner:GetPos()) > self.Range ^ 2 then return end

	local ent = ents.Create("prop_physics")
	ent:SetModel(self.selectmdl)
	local min = ent:OBBMins()
	ent:SetPos(trace.HitPos - trace.HitNormal * min.z)
	ent:SetAngles(Angle(0,ply:GetAngles().y - 180 + self.rotation,0))
	local tr = util.TraceLine( {
		start =  ent:LocalToWorld(min),
		endpos = ent:LocalToWorld(ent:OBBMaxs()),
		filter = {},
	} )
	ent:Remove()
	if tr.Hit then return end
	
	if JoeFort.Ressources - JoeFort.structs[self.selectcat][self.selectnum].neededresources < 0 then return end

	if JoeFort.structs[self.selectcat][self.selectnum].CanSpawn != nil then
		if JoeFort.structs[self.selectcat][self.selectnum].CanSpawn(self.Owner, self) == false then return end
	end
	
	JoeFort:SpawnEnt(self.Owner, self)
	self.Owner:EmitSound("physics/concrete/rock_impact_hard6.wav")
	self:SetNextPrimaryFire(CurTime() + 2)
end

function SWEP:SecondaryAttack()
	if self.secondarycooldown > CurTime() then return end
	if not self.selectcat or self.selectcat == "" then return end

	local tbl = JoeFort.structs[self.selectcat]

	if self.selectnum + 1 <= table.Count(tbl) then 
		self.selectnum = self.selectnum + 1
	else
		self.selectnum = 1
	end

	self.selectmdl = tbl[self.selectnum].model
	if CLIENT then self:MakeGhostEntity() surface.PlaySound("buttons/combine_button7.wav") end

	self.secondarycooldown = CurTime() + 1
end


function SWEP:Reload()
	self.selectcat = ""
	self.selectnum = 1
	self.selectmdl = ""
	if not CLIENT then return end
	JoeFort:OpenFortMenu(self)
end

local green = Color(0,255,0)
local red = Color(255,0,0)
function SWEP:UpdateGhostent( ent, ply )
	if not IsValid( ent ) then return end

	local trace = ply:GetEyeTrace()
	local ang = Angle(0,ply:GetAngles().y - 180,0) + Angle(0,self.rotation,0)
	local min = ent:OBBMins()
	local pos = trace.HitPos - trace.HitNormal * min.z
	ent:SetPos( pos )
	ent:SetAngles( ang )

	ent:SetNoDraw( false )
end

function SWEP:MakeGhostEntity()
	if not self.selectmdl or self.selectmdl == "" then return end

	if IsValid(self.GhostEntity) then self.GhostEntity:Remove() end

	self.GhostEntity = ents.CreateClientProp( "prop_physics" )
	self.GhostEntity:SetModel(self.selectmdl)
	self.GhostEntity:SetMaterial("ace/sw/hologram")
	self.GhostEntity:SetPos(Vector( 0, 0, 0 ))
	self.GhostEntity:SetAngles(Angle( 0, 0, 0 ))
	self.GhostEntity:SetNoDraw(true)
end

function SWEP:Think()
	if not self.selectmdl or self.selectmdl == "" then if IsValid(self.GhostEntity) then self.GhostEntity:Remove() end return end
	if not IsValid( self.GhostEntity ) or self.GhostEntity:GetModel() != string.lower(self.selectmdl) then
		if CLIENT then self:MakeGhostEntity( ) end
	end

	if CLIENT then self:UpdateGhostent( self.GhostEntity, self.Owner ) end

	if self.cld < CurTime() and self.Owner:KeyPressed(IN_USE) then
		self.rotation = self.rotation + 90 <= 360 and self.rotation + 90 or 0
		self.cld = CurTime() + 1
	end

	if CLIENT then
		local tr = util.TraceLine( {
			start =  self.GhostEntity:LocalToWorld(self.GhostEntity:OBBMins()),
			endpos = self.GhostEntity:LocalToWorld(self.GhostEntity:OBBMaxs()),
			filter = {},
		} )

		if tr.Hit or self.GhostEntity:GetPos():DistToSqr(self.Owner:GetPos()) > self.Range ^ 2 then
			self.GhostEntity:SetColor(red)
		else
			self.GhostEntity:SetColor(green)
		end
	end
end

function SWEP:Holster()
	if IsValid( self.GhostEntity ) then
		self.GhostEntity:Remove()
	end
	return true
end

local col1 = Color(134, 235, 255,255)
local col2 = Color(9, 125, 168, 100)
local mat = Material("ace/sw/hologram")

function SWEP:PostDrawViewModel(vm, wep, ply)
	if not CLIENT then return end
	if not IsValid(self.GhostEntity) then return end
	local ply = self.Owner
	if not self.selectcat or self.selectcat == "" then return end
	if not JoeFort.structs[self.selectcat] then return end
	local data = JoeFort.structs[self.selectcat][self.selectnum]
	if not data then return end
	local obb = self.GhostEntity:OBBCenter()
	local pos = self.GhostEntity:LocalToWorld(Vector(obb.x,0,obb.z))
	local ang = self.Owner:GetAngles()
	ang.r = 0
	ang.p = 0
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.1)
		surface.SetFont("JoeFort50")
		local sizex = surface.GetTextSize("Name: " .. data.name) + 30
		surface.SetDrawColor(col2)
		surface.DrawRect(sizex * -0.5, -20, sizex, 220)
		surface.DrawTexturedRect(sizex * -0.5, -20, sizex, 220)
		surface.SetDrawColor(col1)
		surface.DrawOutlinedRect(sizex * -0.5, -20, sizex, 220, 3)
		draw.SimpleText("Name: " .. data.name, "JoeFort50", 0, 10, col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Health: " .. data.health, "JoeFort50", 0, 60, col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Buildtime: " .. data.buildtime .. "s", "JoeFort50", 0, 110, col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Cost: " .. data.neededresources, "JoeFort50", 0, 160, col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()

end