RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RSCore.Commands.Add("shuff", "Van stoel schuiven", {}, false, function(source, args)
    TriggerClientEvent('rs-seatshuff:client:Shuff', source)
end)