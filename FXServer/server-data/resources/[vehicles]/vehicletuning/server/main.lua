RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RegisterServerEvent('vehicletuning:server:SaveVehicleProps')
AddEventHandler('vehicletuning:server:SaveVehicleProps', function(vehicleProps)
    local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        RSCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)

RegisterServerEvent('vehicletuning:server:BuyUpgrade')
AddEventHandler('vehicletuning:server:BuyUpgrade', function(costs)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local bankBalance = Player.PlayerData.money["bank"]
    if Player.Functions.RemoveMoney("cash", costs, "vehicle-tuning-bought-upgrade") then
        -- :)
    elseif bankBalance >= costs then
        Player.Functions.RemoveMoney("bank", costs, "vehicle-tuning-bought-upgrade")
    else
        TriggerClientEvent('RSCore:Notify', src, "Je hebt niet genoeg geld!", "error")
    end
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