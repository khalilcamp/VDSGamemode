local PLUGIN = PLUGIN

PLUGIN.name = "Apply Command"
PLUGIN.author = "Candyexin"
PLUGIN.description = "Allows citizens to apply."

ix.command.Add("apply", {
    description = "Shows your Name and current Job to people in-range.",

    OnRun = function(_, client)
        if (client:Team() == FACTION_CADETE or FACTION_ST or FACTION_JEDI or FACTION_501ST or FACTION_212ST or FACTION_MARINHA or FACTION_ARC) then
            ix.chat.Send(client, "me", string.format("aplica, mostrando sua ID contendo: NOME: %s.", client:Name(), team.GetName(client:Team())))
        else
            return "@notNow"
        end
    end
})