RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RegisterServerEvent('tackle:server:TacklePlayer')
AddEventHandler('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent("tackle:client:GetTackled", playerId)
end)

RSCore.Commands.Add("id", "Wat is mijn id?", {}, false, function(source, args)
    TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "ID: "..source)
end)