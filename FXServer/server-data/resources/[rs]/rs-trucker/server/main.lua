RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local PaymentTax = 15

local Bail = {}

RegisterServerEvent('rs-trucker:server:DoBail')
AddEventHandler('rs-trucker:server:DoBail', function(bool, vehInfo)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    if bool then
        if Player.PlayerData.money.cash >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('cash', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt de borg van 1000,- betaald (Cash)', 'success')
            TriggerClientEvent('rs-trucker:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('bank', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt de borg van 1000,- betaald (Bank)', 'success')
            TriggerClientEvent('rs-trucker:client:SpawnVehicle', src, vehInfo)
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet genoeg contant, de borg is 1000,-', 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('cash', Bail[Player.PlayerData.citizenid], "trucker-bail-paid")
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt de borg van 1000,- terug gekregen', 'success')
        end
    end
end)

RegisterNetEvent('rs-trucker:server:01101110')
AddEventHandler('rs-trucker:server:01101110', function()
    RSCore.Functions.BanInjection(source, 'rs-trucker (01101110)')
end)

RSCore.Functions.CreateCallback('rs-trucker:01101110', function(source, cb, drops)
    local src = source 
    local Player = RSCore.Functions.GetPlayer(src)
    local drops = tonumber(drops)
    local bonus = 0
    local DropPrice = math.random(300, 500)
    if drops > 5 then 
        bonus = math.ceil((DropPrice / 100) * 5) + 100
    elseif drops > 10 then
        bonus = math.ceil((DropPrice / 100) * 7) + 300
    elseif drops > 15 then
        bonus = math.ceil((DropPrice / 100) * 10) + 400
    elseif drops > 20 then
        bonus = math.ceil((DropPrice / 100) * 12) + 500
    end
    local price = (DropPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount
    Player.Functions.AddJobReputation(1)
    Player.Functions.AddMoney("bank", payment, "trucker-salary")
    TriggerClientEvent('chatMessage', source, "BAAN", "warning", "Je hebt je salaris ontvangen van: €"..payment..", bruto: €"..price.." (waarvan €"..bonus.." bonus) en €"..taxAmount.." belasting ("..PaymentTax.."%)")
end)

