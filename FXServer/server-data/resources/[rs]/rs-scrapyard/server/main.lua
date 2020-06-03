RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        GenerateVehicleList()
        Citizen.Wait((1000 * 60) * 60)
    end
end)

RegisterServerEvent('rs-scrapyard:server:LoadVehicleList')
AddEventHandler('rs-scrapyard:server:LoadVehicleList', function()
    local src = source
    TriggerClientEvent("rs-scapyard:client:setNewVehicles", src, Config.CurrentVehicles)
end)


RegisterServerEvent('rs-scrapyard:server:ScrapVehicle')
AddEventHandler('rs-scrapyard:server:ScrapVehicle', function(listKey)
    local src = source 
    local Player = RSCore.Functions.GetPlayer(src)
    if Config.CurrentVehicles[listKey] ~= nil then 
        for i = 1, math.random(4, 8), 1 do
            local item = Config.Items[math.random(1, #Config.Items)]
            Player.Functions.AddItem(item, math.random(23, 35))
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[item], 'add')
            Citizen.Wait(500)
        end
        Config.CurrentVehicles[listKey] = nil
        TriggerClientEvent("rs-scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
    end
end)

function GenerateVehicleList()
    Config.CurrentVehicles = {}
    for i = 1, 20, 1 do
        local randVehicle = Config.Vehicles[math.random(1, #Config.Vehicles)]
        if not IsInList(randVehicle) then
            Config.CurrentVehicles[i] = randVehicle
        end
    end
    TriggerClientEvent("rs-scapyard:client:setNewVehicles", -1, Config.CurrentVehicles)
end

function IsInList(name)
    local retval = false
    if Config.CurrentVehicles ~= nil and next(Config.CurrentVehicles) ~= nil then 
        for k, v in pairs(Config.CurrentVehicles) do
            if Config.CurrentVehicles[k] == name then 
                retval = true
            end
        end
    end
    return retval
end
