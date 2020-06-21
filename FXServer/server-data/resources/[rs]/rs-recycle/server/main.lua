RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local ItemTable = {
    "aluminum",
    "plastic",
    "copper",
    "iron",
    "metalscrap",
    "steel",
    "glass",
}

RegisterServerEvent("rs-recycle:server:getItem")
AddEventHandler("rs-recycle:server:getItem", function()
    RSCore.Functions.BanInjection(source)
end)

RSCore.Functions.CreateCallback('rs-recycle:getItem', function(source, cb)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    for i = 1, math.random(2, 4), 1 do
        local randItem = ItemTable[math.random(1, #ItemTable)]
        local amount = math.random(2, 4)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[randItem], 'add')
        Citizen.Wait(500)
    end  
end)