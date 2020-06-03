RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RegisterServerEvent('rs-shops:server:UpdateShopItems')
AddEventHandler('rs-shops:server:UpdateShopItems', function(shop, itemData, amount)
    Config.Locations[shop]["products"][itemData.slot].amount =  Config.Locations[shop]["products"][itemData.slot].amount - amount
    if Config.Locations[shop]["products"][itemData.slot].amount <= 0 then 
        Config.Locations[shop]["products"][itemData.slot].amount = 0
    end
    TriggerClientEvent('rs-shops:client:SetShopItems', -1, shop, Config.Locations[shop]["products"])
end)

RegisterServerEvent('rs-shops:server:RestockShopItems')
AddEventHandler('rs-shops:server:RestockShopItems', function(shop)
    if Config.Locations[shop]["products"] ~= nil then 
        local randAmount = math.random(10, 50)
        for k, v in pairs(Config.Locations[shop]["products"]) do 
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + randAmount
        end
        TriggerClientEvent('rs-shops:client:RestockShopItems', -1, shop, randAmount)
    end
end)