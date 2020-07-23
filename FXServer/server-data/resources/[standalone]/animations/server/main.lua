RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Commands.Add("am", "Toggle animatie menu", {}, false, function(source, args)
	TriggerClientEvent('animations:client:ToggleMenu', source)
end)

RSCore.Commands.Add("a", "Gebruik een animatie, voor animatie lijst doe /em", {{name = "naam", help = "Emote naam"}}, true, function(source, args)
	TriggerClientEvent('animations:client:EmoteCommandStart', source, args)
end)

RSCore.Functions.CreateUseableItem("walkstick", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("animations:UseWandelStok", source)
end)