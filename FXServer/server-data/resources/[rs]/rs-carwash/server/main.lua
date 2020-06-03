RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RegisterServerEvent('rs-carwash:server:washCar')
AddEventHandler('rs-carwash:server:washCar', function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('rs-carwash:client:washCar', src)
    elseif Player.Functions.RemoveMoney('bank', Config.DefaultPrice, "car-washed") then
        TriggerClientEvent('rs-carwash:client:washCar', src)
    else
        TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet genoeg geld..', 'error')
    end
end)