RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local ItemTable = {
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
}

RegisterServerEvent("rs-recycle:server:getItem")
AddEventHandler("rs-recycle:server:getItem", function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    for i = 1, math.random(1, 5), 1 do
        local randItem = ItemTable[math.random(1, #ItemTable)]
        local amount = math.random(5, 12)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[randItem], 'add')
        Citizen.Wait(500)
    end
    
end)