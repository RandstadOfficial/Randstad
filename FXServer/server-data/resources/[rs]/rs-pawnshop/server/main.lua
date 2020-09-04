RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local ItemList = {
    ["goldchain"] = math.random(100, 250),
    ["diamond_ring"] = math.random(200, 350),
    ["rolex"] = math.random(300, 500),
}

local ItemListHardware = {
    ["tablet"] = math.random(400, 500),
    ["iphone"] = math.random(300, 500),
    ["samsungphone"] = math.random(300, 500),
    ["laptop"] = math.random(300, 500),
}

local MeltItems = {
    ["rolex"] = 16,
    ["goldchain"] = 32,
}

local GoldBarsAmount = 0

RegisterServerEvent("rs-pawnshop:server:sellPawnItems")
AddEventHandler("rs-pawnshop:server:sellPawnItems", function()
    local src = source
    local price = 0
    local Player = RSCore.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-pawn-items")
        TriggerClientEvent('RSCore:Notify', src, "Je hebt je items verkocht")
    end
end)

RegisterServerEvent("rs-pawnshop:server:sellHardwarePawnItems")
AddEventHandler("rs-pawnshop:server:sellHardwarePawnItems", function()
    local src = source
    local price = 0
    local totalAmount = 0
    local Player = RSCore.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemListHardware[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemListHardware[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    totalAmount = totalAmount + Player.PlayerData.items[k].amount
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.RemoveItem("certificate", totalAmount)
        Player.Functions.AddMoney("cash", price, "sold-hardware-pawn-items")
        TriggerClientEvent('RSCore:Notify', src, "Je hebt je items verkocht")
    end
end)

RegisterServerEvent("rs-pawnshop:server:getGoldBars")
AddEventHandler("rs-pawnshop:server:getGoldBars", function()
    RSCore.Functions.BanInjection(source, 'rs-pawnshop (getGoldBars)')
end)

RSCore.Functions.CreateCallback('rs-pawnshop:getGoldBars', function(source, cb)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if GoldBarsAmount > 0 then
        if Player.Functions.AddItem("goldbar", GoldBarsAmount) then
            GoldBarsAmount = 0
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["goldbar"], "add")
            Config.IsMelting = false
            Config.CanTake = false
            Config.MeltTime = 300
            TriggerClientEvent("rs-pawnshop:client:SetTakeState", -1, false)
        else
            TriggerClientEvent('RSCore:Notify', src, "Je hebt geen ruimte in je inventory", "error")
        end
    end
end)

RegisterServerEvent("rs-pawnshop:server:sellGold")
AddEventHandler("rs-pawnshop:server:sellGold", function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "goldbar" then 
                    price = price + (math.random(3000, 6000) * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-gold")
        TriggerClientEvent('RSCore:Notify', src, "Je hebt je items verkocht")
    end
end)

RegisterServerEvent("rs-pawnshop:server:meltItems")
AddEventHandler("rs-pawnshop:server:meltItems", function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local goldbars = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if MeltItems[Player.PlayerData.items[k].name] ~= nil then 
                    local amount = (Player.PlayerData.items[k].amount / MeltItems[Player.PlayerData.items[k].name])
                    if amount < 1 then
                        TriggerClientEvent('RSCore:Notify', src, "Je hebt niet genoeg " .. Player.PlayerData.items[k].label, "error")
                    else
                        amount = math.ceil(Player.PlayerData.items[k].amount / MeltItems[Player.PlayerData.items[k].name])
                        if amount > 0 then
                            if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
                                goldbars = goldbars + amount
                            end
                        end
                    end
                end
            end
        end
        if goldbars > 0 then
            GoldBarsAmount = goldbars
            TriggerClientEvent('rs-pawnshop:client:startMelting', -1)
            Config.IsMelting = true
            Config.MeltTime = 300
            Citizen.CreateThread(function()
                while Config.IsMelting do
                    Config.MeltTime = Config.MeltTime - 1
                    if Config.MeltTime <= 0 then
                        Config.IsMelting = false
                        Config.CanTake = true
                        Config.MeltTime = 300
                        TriggerClientEvent('rs-pawnshop:client:SetTakeState', -1, true)
                    end
                    Citizen.Wait(1000)
                end
            end)
        end
    end
end)

RSCore.Functions.CreateCallback('rs-pawnshop:server:getSellPrice', function(source, cb)
    local retval = 0
    local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    retval = retval + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                end
            end
        end
    end
    cb(retval)
end)

RSCore.Functions.CreateCallback('rs-pawnshop:melting:server:GetConfig', function(source, cb)
    cb(Config.IsMelting, Config.MeltTime, Config.CanTake)
end)

RSCore.Functions.CreateCallback('rs-pawnshop:server:getSellHardwarePrice', function(source, cb)
    local retval = 0
    local amount = 0
    local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemListHardware[Player.PlayerData.items[k].name] ~= nil then 
                    retval = retval + (ItemListHardware[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    amount = amount + Player.PlayerData.items[k].amount
                end
            end
        end
        local certificates = Player.Functions.GetItemByName("certificate")
        if certificates ~= nil then
            if certificates.amount < amount then 
                retval = 0
            end
        else
            retval = 0
        end
    end
    cb(retval)
end)

RSCore.Functions.CreateCallback('rs-pawnshop:server:hasGold', function(source, cb)
	local retval = false
    local Player = RSCore.Functions.GetPlayer(source)
    local gold = Player.Functions.GetItemByName('goldbar')
    if gold ~= nil and gold.amount > 0 then
        retval = true
    end
    cb(retval)
end)