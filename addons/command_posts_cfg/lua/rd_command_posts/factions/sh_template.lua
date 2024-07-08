local OBJ = RDV.COMMAND_POSTS.AddFaction("CIS")

OBJ:SetColor(Color(255,0,0))

OBJ:SetModel("models/jellyton/bf2/misc/props/command_post.mdl")

OBJ:AddTeam("Citizen")

OBJ:AddCaptureLines({
    "commandpost/cis/claimpost1.wav", 
    "commandpost/cis/claimpost2.wav", 
    "commandpost/cis/claimpost3.wav"
})

OBJ:AddLostLines({
    "commandpost/cis/lostclaimpost1.wav",
    "commandpost/cis/lostclaimpost2.wav"
})
