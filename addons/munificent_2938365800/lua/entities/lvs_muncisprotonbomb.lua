AddCSLuaFile()

ENT.Base = "lvs_missile"

ENT.Type = "anim"

ENT.PrintName = "Munificent Proton Bomb"
ENT.Author = "Luna"
ENT.Information = "geht ab wie'n z�pfchen"
ENT.Category = "[LVS]"

ENT.Spawnable		= true
ENT.AdminOnly		= true

ENT.ExplosionEffect = "lvs_bomb_muncisexplosion"
ENT.GlowColor = Color( 255, 40, 100, 255 )

if SERVER then
	function ENT:GetDamage() return
		(self._dmg or 2500)
	end

	function ENT:GetRadius() 
		return (self._radius or 1500)
	end

	return
end

ENT.GlowMat = Material( "sprites/light_glow02_add" )

function ENT:Enable()	
	if self.IsEnabled then return end

	self.IsEnabled = true

	self.snd = CreateSound(self, "npc/combine_gunship/gunship_crashing1.wav")
	self.snd:SetSoundLevel( 80 )
	self.snd:Play()

	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetEntity( self )
	util.Effect( "lvs_concussion_trail", effectdata )
end

function ENT:Draw()
	if not self:GetActive() then return end

	self:DrawModel()

	render.SetMaterial( self.GlowMat )

	local pos = self:GetPos()
	local dir = self:GetForward()

	for i = 0, 30 do
		local Size = ((45 - i) / 30) ^ 2 * 1488

		render.DrawSprite( pos - dir * i * 7, Size, Size, self.GlowColor )
	end
end