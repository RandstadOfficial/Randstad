RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

local trunkBusy = {}

RegisterServerEvent('rs-trunk:server:setTrunkBusy')
AddEventHandler('rs-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

RSCore.Functions.CreateCallback('rs-trunk:server:getTrunkBusy', function(source, cb, plate)
    if trunkBusy[plate] then
        cb(true)
    end
    cb(false)
end)

RegisterServerEvent('rs-trunk:server:KidnapTrunk')
AddEventHandler('rs-trunk:server:KidnapTrunk', function(targetId, closestVehicle)
    TriggerClientEvent('rs-trunk:client:KidnapGetIn', targetId, closestVehicle)
end)

RSCore.Commands.Add("getintrunk", "Stap in kofferbak", {}, false, function(source, args)
    TriggerClientEvent('rs-trunk:client:GetIn', source)
end)

RSCore.Commands.Add("kidnaptrunk", "Stap in kofferbak", {}, false, function(source, args)
    TriggerClientEvent('rs-trunk:server:KidnapTrunk', source)
end)