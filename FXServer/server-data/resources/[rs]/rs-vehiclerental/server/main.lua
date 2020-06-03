RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

local RentedVehicles = {}

RegisterServerEvent('rs-vehiclerental:server:SetVehicleRented')
AddEventHandler('rs-vehiclerental:server:SetVehicleRented', function(plate, bool, vehicleData)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)
    local plyCid = ply.PlayerData.citizenid

    if bool then
        if ply.PlayerData.money.cash >= vehicleData.price then
            ply.Functions.RemoveMoney('cash', vehicleData.price, "vehicle-rentail-bail") 
            RentedVehicles[plyCid] = plate
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt de borg van €'..vehicleData.price..' cash betaald.', 'success', 3500)
            TriggerClientEvent('rs-vehiclerental:server:SpawnRentedVehicle', src, plate, vehicleData) 
        elseif ply.PlayerData.money.bank >= vehicleData.price then 
            ply.Functions.RemoveMoney('bank', vehicleData.price, "vehicle-rentail-bail") 
            RentedVehicles[plyCid] = plate
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt de borg van €'..vehicleData.price..' via de bank betaald.', 'success', 3500)
            TriggerClientEvent('rs-vehiclerental:server:SpawnRentedVehicle', src, plate, vehicleData) 
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet genoeg geld.', 'error', 3500)
        end
        return
    end
    TriggerClientEvent('RSCore:Notify', src, 'Je hebt je borg van €'..vehicleData.price..' terug gekregen.', 'success', 3500)
    ply.Functions.AddMoney('cash', vehicleData.price, "vehicle-rentail-bail")
    print(vehicleData.price)
    RentedVehicles[plyCid] = nil
end)




