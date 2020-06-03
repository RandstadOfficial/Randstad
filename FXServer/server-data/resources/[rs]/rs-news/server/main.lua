RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Commands.Add("newscam", "Pak een nieuws camera", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Cam:ToggleCam", source)
    end
end)

RSCore.Commands.Add("newsmic", "Pak een nieuws microfoon", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleMic", source)
    end
end)

