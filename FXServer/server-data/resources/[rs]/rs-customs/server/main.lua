RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code


RSCore.Functions.CreateCallback('rs-customs:server:UpdateBusyState', function(source, cb, k, bool)
	RSCustoms.Locations[k]["busy"] = bool
    TriggerClientEvent('rs-customs:client:UpdateBusyState', -1, k, bool)
end)

RegisterServerEvent('rs-customs:server:UpdateBusyState')
AddEventHandler('rs-customs:server:UpdateBusyState', function(k, bool)
    RSCore.Functions.BanInjection(source, 'rs-customs (UpdateBusyState)')
end)

RegisterServerEvent('rs-customs:print')
AddEventHandler('rs-customs:print', function(data)
    print(data)
end)

RSCore.Functions.CreateCallback('rs-customs:server:CanPurchase', function(source, cb, price)
    local Player = RSCore.Functions.GetPlayer(source)
    local CanBuy = false

    if Player.PlayerData.money.cash >= price then
        Player.Functions.RemoveMoney('cash', price)
        CanBuy = true
    elseif Player.PlayerData.money.bank >= price then
        Player.Functions.RemoveMoney('bank', price)
        CanBuy = true
    else
        CanBuy = false
    end

    cb(CanBuy)
end)

RSCore.Functions.CreateCallback('rs-customs:server:SaveVehicleProps', function(source, cb, vehicleProps)
	local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        RSCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)

RegisterServerEvent("rs-customs:server:SaveVehicleProps")
AddEventHandler("rs-customs:server:SaveVehicleProps", function(vehicleProps)
	RSCore.Functions.BanInjection(source, 'rs-customs (SaveVehicleProps)')
end)


function IsVehicleOwned(plate)
    local retval = false
    RSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end