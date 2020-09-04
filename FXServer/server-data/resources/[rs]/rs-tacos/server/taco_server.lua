RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RegisterServerEvent('rs-taco:server:start:black')
AddEventHandler('rs-taco:server:start:black', function()
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-taco:server:reward:money')
AddEventHandler('rs-taco:server:reward:money', function()
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-taco:server:reward:laundrymoney')
AddEventHandler('rs-taco:server:reward:laundrymoney', function()
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-tacos:server:get:stuff')
AddEventHandler('rs-tacos:server:get:stuff', function()
    RSCore.Functions.BanInjection(source)
end)

RSCore.Functions.CreateCallback('rs-tacos:server:GetConfig', function(source, cb)
    cb(Config)
end)


RSCore.Functions.CreateCallback('rs-taco:server:start:black', function(source, cb)
	local src = source
    
    TriggerClientEvent('rs-taco:start:black:job', src)
end)

RSCore.Functions.CreateCallback('rs-taco:server:reward:money', function(source, cb)
	local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    
    Player.Functions.AddMoney("cash", Config.PaymentTaco, "taco-reward-money")
    TriggerClientEvent('RSCore:Notify', src, "Taco geleverd! Ga terug naar de Taco shop voor een nieuwe levering")
end)

RSCore.Functions.CreateCallback('rs-taco:server:reward:laundrymoney', function(source, cb)
	local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    
    Player.Functions.AddMoney("cash", Config.PaymentLaundry, "taco-laundry-money")
    TriggerClientEvent('RSCore:Notify', src, "Taco geleverd! Doekoe ontvangen voor rol met geld")
end)


RSCore.Functions.CreateCallback('rs-tacos:server:get:stuff', function(source, cb)
	local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    
    if Player ~= nil then
        Player.Functions.AddItem("taco-box", 1)
        TriggerClientEvent('inventory:client:ItemBox', source, RSCore.Shared.Items['taco-box'], "add")
    end
end)

RSCore.Functions.CreateCallback('rs-taco:server:get:ingredient', function(source, cb)
    local src = source
    local Ply = RSCore.Functions.GetPlayer(src)
    local lettuce = Ply.Functions.GetItemByName("lettuce")
    local meat = Ply.Functions.GetItemByName("meat")
    if lettuce ~= nil and meat ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

RSCore.Functions.CreateCallback('rs-taco:server:get:tacobox', function(source, cb)
    local src = source
    local Ply = RSCore.Functions.GetPlayer(src)
    local box = Ply.Functions.GetItemByName("taco-box")
    if box ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

RSCore.Functions.CreateCallback('rs-taco:server:get:tacos', function(source, cb)
    local src = source
    local Ply = RSCore.Functions.GetPlayer(src)
    local taco = Ply.Functions.GetItemByName('taco')
    if taco ~= nil then
        cb(true)
    else
        cb(false)
    end
end)