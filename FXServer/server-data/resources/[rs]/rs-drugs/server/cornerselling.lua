RSCore.Functions.CreateCallback('rs-drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    local AvailableDrugs = {}
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = RSCore.Shared.Items[item.name]["label"]
            })
        end
    end

    if next(AvailableDrugs) ~= nil then
        cb(AvailableDrugs)
    else
        cb(nil)
    end
end)

RegisterServerEvent('rs-drugs:server:sellCornerDrugs')
AddEventHandler('rs-drugs:server:sellCornerDrugs', function(item, amount, price)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)
    Player.Functions.AddMoney('cash', price, "sold-cornerdrugs")

    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = RSCore.Shared.Items[item.name]["label"]
            })
        end
    end

    TriggerClientEvent('rs-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)

RegisterServerEvent('rs-drugs:server:robCornerDrugs')
AddEventHandler('rs-drugs:server:robCornerDrugs', function(item, amount, price)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)

    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = RSCore.Shared.Items[item.name]["label"]
            })
        end
    end

    TriggerClientEvent('rs-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)