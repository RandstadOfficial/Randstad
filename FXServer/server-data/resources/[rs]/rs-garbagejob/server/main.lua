RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local Bail = {}

RSCore.Functions.CreateCallback('rs-garbagejob:server:HasMoney', function(source, cb)
    local Player = RSCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Player.PlayerData.money.cash >= Config.BailPrice then
        Bail[CitizenId] = "cash"
        Player.Functions.RemoveMoney('cash', Config.BailPrice)
        cb(true)
    elseif Player.PlayerData.money.bank >= Config.BailPrice then
        Bail[CitizenId] = "bank"
        Player.Functions.RemoveMoney('bank', Config.BailPrice)
        cb(true)
    else
        cb(false)
    end
end)

RSCore.Functions.CreateCallback('rs-garbagejob:server:CheckBail', function(source, cb)
    local Player = RSCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Bail[CitizenId] ~= nil then
        Player.Functions.AddMoney(Bail[CitizenId], Config.BailPrice)
        Bail[CitizenId] = nil
        cb(true)
    else
        cb(false)
    end
end)

local Materials = {
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
}

RegisterServerEvent('rs-garbagejob:server:PayShit')
AddEventHandler('rs-garbagejob:server:PayShit', function(amount, location)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    if amount > 0 then
        Player.Functions.AddMoney('bank', amount)

        if location == #Config.Locations["vuilnisbakken"] then
            for i = 1, math.random(3, 5), 1 do
                local item = Materials[math.random(1, #Materials)]
                Player.Functions.AddItem(item, math.random(40, 70))
                TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[item], 'add')
                Citizen.Wait(500)
            end
            
            local Luck = math.random(1, 10)
            local Odd = math.random(1, 10)
            if Luck == Odd then
                local random = math.random(1, 3)
                Player.Functions.AddItem("rubber", random)
                TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["rubber"], 'add')
            end
        end

        TriggerClientEvent('RSCore:Notify', src, "Je hebt €"..amount..",- uitbetaald gekregen op je bank!", "success")
    else
        TriggerClientEvent('RSCore:Notify', src, "Je hebt niks verdiend..", "error")
    end
end)