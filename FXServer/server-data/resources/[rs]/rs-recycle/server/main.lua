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
    for i = 1, math.random(1, 5), 1 do
        local randItem = ItemTable[math.random(1, #ItemTable)]
        
        local amount = math.random(2, 6)
        if randItem == "metalscrap" or randItem == "steel" or randItem == "copper" then
            local r1 = math.random(1, 100)
            if r1 > 95 then
                amount = amount + 10
            end
        end
        
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[randItem], 'add')
        Citizen.Wait(500)
    end  
    
    local Luck = math.random(1, 8)
    local Odd = math.random(1, 8)
    if Luck == Odd then
        local random = math.random(1, 3)
        Player.Functions.AddItem("rubber", random)
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["rubber"], 'add')
    end
end)