RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local alarmTriggered = false
local certificateAmount = 43

RegisterServerEvent('rs-ifruitstore:server:LoadLocationList')
AddEventHandler('rs-ifruitstore:server:LoadLocationList', function()
    local src = source 
    TriggerClientEvent("rs-ifruitstore:server:LoadLocationList", src, Config.Locations)
end)

RegisterServerEvent('rs-ifruitstore:server:setSpotState')
AddEventHandler('rs-ifruitstore:server:setSpotState', function(stateType, state, spot)
    if stateType == "isBusy" then
        Config.Locations["takeables"][spot].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["takeables"][spot].isDone = state
    end
    TriggerClientEvent('rs-ifruitstore:client:setSpotState', -1, stateType, state, spot)
end)

RegisterServerEvent('rs-ifruitstore:server:SetThermiteStatus')
AddEventHandler('rs-ifruitstore:server:SetThermiteStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["thermite"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["thermite"].isDone = state
    end
    TriggerClientEvent('rs-ifruitstore:client:SetThermiteStatus', -1, stateType, state)
end)

RegisterServerEvent('rs-ifruitstore:server:SafeReward')
AddEventHandler('rs-ifruitstore:server:SafeReward', function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', math.random(1500, 2000), "robbery-ifruit")
    Player.Functions.AddItem("certificate", certificateAmount)
    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["certificate"], "add")
    Citizen.Wait(500)
    local luck = math.random(1, 100)
    if luck <= 10 then
        Player.Functions.AddItem("goldbar", math.random(1, 2))
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["goldbar"], "add")
    end
end)

RegisterServerEvent('rs-ifruitstore:server:SetSafeStatus')
AddEventHandler('rs-ifruitstore:server:SetSafeStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["safe"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["safe"].isDone = state
    end
    TriggerClientEvent('rs-ifruitstore:client:SetSafeStatus', -1, stateType, state)
end)

RegisterServerEvent('rs-ifruitstore:server:itemReward')
AddEventHandler('rs-ifruitstore:server:itemReward', function(spot)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local item = Config.Locations["takeables"][spot].reward

    if Player.Functions.AddItem(item.name, item.amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[item.name], 'add')
    else
        TriggerClientEvent('RSCore:Notify', src, 'Je hebt teveel op zak..', 'error')
    end    
end)

RegisterServerEvent('rs-ifruitstore:server:PoliceAlertMessage')
AddEventHandler('rs-ifruitstore:server:PoliceAlertMessage', function(msg, coords, blip)
    local src = source
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("rs-jewellery:client:PoliceAlertMessage", v, msg, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("rs-jewellery:client:PoliceAlertMessage", v, msg, coords, blip)
                end
            end
        end
    end
end)