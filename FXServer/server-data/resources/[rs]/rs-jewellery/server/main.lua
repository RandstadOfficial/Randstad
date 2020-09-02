RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

local timeOut = false

local alarmTriggered = false


RegisterServerEvent('rs-jewellery:server:setVitrineState')
AddEventHandler('rs-jewellery:server:setVitrineState', function(stateType, state, k)
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-jewellery:server:vitrineReward')
AddEventHandler('rs-jewellery:server:vitrineReward', function()
    RSCore.Functions.BanInjection(source)
end)


RSCore.Functions.CreateCallback('rs-jewellery:vitrineReward', function(source, cb)
	local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 4)

    if otherchance == odd then
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt teveel op zak..', 'error')
        end
    else
        local amount = math.random(2, 4)
        if Player.Functions.AddItem("10kgoldchain", amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["10kgoldchain"], 'add')
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt teveel op zak..', 'error')
        end
    end
end)	

RSCore.Functions.CreateCallback('rs-jewellery:server:setVitrineState', function(source, cb, stateType, state, k)
	Config.Locations[k][stateType] = state
    TriggerClientEvent('rs-jewellery:client:setVitrineState', -1, stateType, state, k)
end)

RSCore.Functions.CreateCallback('rs-jewellery:server:setTimeout', function(source, cb)
	if not timeOut then
        timeOut = true
        TriggerEvent('rs-scoreboard:server:SetActivityBusy', "jewellery", true)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, v in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('rs-jewellery:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('rs-jewellery:client:setAlertState', -1, false)
                TriggerEvent('rs-scoreboard:server:SetActivityBusy', "jewellery", false)
            end
            timeOut = false
            alarmTriggered = false
        end)
    end
end)

RSCore.Functions.CreateCallback('rs-jewellery:server:PoliceAlertMessage', function(source, cb, title, coords, blip)
	local src = source
    local alertData = {
        title = title,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Mogelijk overval gaande bij de Vangelico Juwelier<br>Beschikbare camera's: 31, 32, 33, 34",
    }

    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("rs-phone:client:addPoliceAlert", v, alertData)
                        TriggerClientEvent("rs-jewellery:client:PoliceAlertMessage", v, title, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("rs-phone:client:addPoliceAlert", v, alertData)
                    TriggerClientEvent("rs-jewellery:client:PoliceAlertMessage", v, title, coords, blip)
                end
            end
        end
    end
end)


RegisterServerEvent('rs-jewellery:server:setTimeout')
AddEventHandler('rs-jewellery:server:setTimeout', function()
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-jewellery:server:PoliceAlertMessage')
AddEventHandler('rs-jewellery:server:PoliceAlertMessage', function(title, coords, blip)
    RSCore.Functions.BanInjection(source)
end)

RSCore.Functions.CreateCallback('rs-jewellery:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	cb(amount)
end)