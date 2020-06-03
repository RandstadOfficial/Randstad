local CurrentDivingArea = math.random(1, #RSDiving.Locations)

RSCore.Functions.CreateCallback('rs-diving:server:GetDivingConfig', function(source, cb)
    cb(RSDiving.Locations, CurrentDivingArea)
end)

RegisterServerEvent('rs-diving:server:TakeCoral')
AddEventHandler('rs-diving:server:TakeCoral', function(Area, Coral, Bool)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local CoralType = math.random(1, #RSDiving.CoralTypes)
    local Amount = math.random(1, RSDiving.CoralTypes[CoralType].maxAmount)
    local ItemData = RSCore.Shared.Items[RSDiving.CoralTypes[CoralType].item]

    if Amount > 1 then
        for i = 1, Amount, 1 do
            Player.Functions.AddItem(ItemData["name"], 1)
            TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
            Citizen.Wait(250)
        end
    else
        Player.Functions.AddItem(ItemData["name"], Amount)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
    end

    if (RSDiving.Locations[Area].TotalCoral - 1) == 0 then
        for k, v in pairs(RSDiving.Locations[CurrentDivingArea].coords.Coral) do
            v.PickedUp = false
        end
        RSDiving.Locations[CurrentDivingArea].TotalCoral = RSDiving.Locations[CurrentDivingArea].DefaultCoral

        local newLocation = math.random(1, #RSDiving.Locations)
        while (newLocation == CurrentDivingArea) do
            Citizen.Wait(3)
            newLocation = math.random(1, #RSDiving.Locations)
        end
        CurrentDivingArea = newLocation
        
        TriggerClientEvent('rs-diving:client:NewLocations', -1)
    else
        RSDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
        RSDiving.Locations[Area].TotalCoral = RSDiving.Locations[Area].TotalCoral - 1
    end

    TriggerClientEvent('rs-diving:server:UpdateCoral', -1, Area, Coral, Bool)
end)

RegisterServerEvent('rs-diving:server:RemoveGear')
AddEventHandler('rs-diving:server:RemoveGear', function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["diving_gear"], "remove")
end)

RegisterServerEvent('rs-diving:server:GiveBackGear')
AddEventHandler('rs-diving:server:GiveBackGear', function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    
    Player.Functions.AddItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["diving_gear"], "add")
end)