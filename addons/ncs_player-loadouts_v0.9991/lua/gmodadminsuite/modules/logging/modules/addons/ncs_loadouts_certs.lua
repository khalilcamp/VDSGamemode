--[[---------------------------------------------]]--
--	Give Certifications
--[[---------------------------------------------]]--

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "[NCS] Loadouts" 
MODULE.Name = "Give Certifications" 
MODULE.Colour = Color(185, 41, 159)

MODULE:Setup(function()
	MODULE:Hook("NCS_LOADOUTS_PlayerGiveCert", "NCS_LOADOUTS_GiveCertLogs", function(RECEIVER, GIVER, CERT_INT)
		if !NCS_LOADOUTS.CERTS[CERT_INT] then return end

		local C_NAME = NCS_LOADOUTS.CERTS[CERT_INT].name

		MODULE:Log("{1} has received the ("..C_NAME..") certification from {2}.", GAS.Logging:FormatPlayer(RECEIVER), GAS.Logging:FormatPlayer(GIVER))
	end)
end)

GAS.Logging:AddModule(MODULE)


--[[---------------------------------------------]]--
--	Take Certifications
--[[---------------------------------------------]]--

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "[NCS] Loadouts" 
MODULE.Name = "Take Certifications" 
MODULE.Colour = Color(185, 41, 159)

MODULE:Setup(function()
	MODULE:Hook("NCS_LOADOUTS_PlayerTakeCert", "NCS_LOADOUTS_TakeCertLogs", function(RECEIVER, GIVER, CERT_INT)
		if !NCS_LOADOUTS.CERTS[CERT_INT] then return end

		local C_NAME = NCS_LOADOUTS.CERTS[CERT_INT].name

		MODULE:Log("{1} has taken the ("..C_NAME..") certification from {2}.", GAS.Logging:FormatPlayer(RECEIVER), GAS.Logging:FormatPlayer(GIVER))
	end)
end)

GAS.Logging:AddModule(MODULE)