RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Commands.Add("fix", "Repareer een voertuig", {}, false, function(source, args)
    TriggerClientEvent('iens:repaira', source)
    TriggerClientEvent('vehiclemod:client:fixEverything', source)
end, "admin")

RSCore.Functions.CreateUseableItem("repairkit", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:RepairVehicle", source)
    end
end)

RSCore.Functions.CreateUseableItem("cleaningkit", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:CleanVehicle", source)
    end
end)

RSCore.Functions.CreateUseableItem("advancedrepairkit", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("vehiclefailure:client:RepairVehicleFull", source)
    end
end)

RegisterServerEvent('rs-vehiclefailure:removeItem')
AddEventHandler('rs-vehiclefailure:removeItem', function(item)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)
    ply.Functions.RemoveItem(item, 1)
end)

RegisterServerEvent('vehiclefailure:server:removewashingkit')
AddEventHandler('vehiclefailure:server:removewashingkit', function(item)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)
    ply.Functions.RemoveItem("cleaningkit", 1)
end)

