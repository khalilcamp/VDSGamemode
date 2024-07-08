local OBJ = RDV.COMMAND_POSTS.AddFaction("Republica")

OBJ:SetColor(Color(0,0,255))

OBJ:SetModel("models/jellyton/bf2/misc/props/command_post.mdl")

OBJ:AddTeam("|Legião 212st|")
OBJ:AddTeam("|Legião 501st|")
OBJ:AddTeam("ARC Trooper")
OBJ:AddTeam("Clone Trooper")
OBJ:AddTeam("Ordem Jedi")
OBJ:AddTeam("|Divisão de Fuzileiros Galaticos|")
OBJ:AddTeam("|ShockTrooper| Força de Segurança")
OBJ:AddTeam("Frota Republicana")

OBJ:AddCaptureLines({
    "commandpost/republic/claimpost1.wav", 
    "commandpost/republic/claimpost2.wav", 
    "commandpost/republic/claimpost3.wav"
})

OBJ:AddLostLines({
    "commandpost/republic/lostclaimpost1.wav", 
    "commandpost/republic/lostclaimpost2.wav"
})
