include("shared.lua")

local CSEnt = ClientsideModel( "models/error.mdl" )
CSEnt:SetNoDraw( true )

function ENT:Draw()
	self:DrawModel()

	if self.WeaponModel == "None" then return end

	local bone = self:LookupBone( "ValveBiped.Bip01_R_Hand" )

	if bone <= 0 then return end

	local pos, ang = self:GetBonePosition( bone )
	
	pos, ang = LocalToWorld(self.WepOffsetPos, self.WepOffsetAng, pos, ang)

    CSEnt:SetModel( self.WeaponModel )
    CSEnt:SetPos( pos )
    CSEnt:SetAngles( ang )
    CSEnt:SetParent( self, 0 )
    CSEnt:SetupBones()
    CSEnt:DrawModel()
end