local PLUGIN = PLUGIN

hook.Add("CreateMenuButtons", "ixCharacterCustomizer", function(tabs)
	tabs["Customização"] = function(container)
		container:Add("ixCharacterCustomizer")
	end
end)