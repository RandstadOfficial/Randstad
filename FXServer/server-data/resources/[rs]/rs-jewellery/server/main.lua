RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

local timeOut = false

local alarmTriggered = false

RegisterServerEvent('rs-jewellery:server:setVitrineState')
AddEventHandler('rs-jewellery:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('rs-jewellery:client:setVitrineState', -1, stateType, state, k)
end)

RegisterServerEvent('rs-jewellery:server:vitrineReward')
AddEventHandler('rs-jewellery:server:vitrineReward', function()
    print("Event Triggered")
    print(source)
    -- local src = source
    -- local Player = RSCore.Functions.GetPlayer(src)

    -- local item = math.random(1, #Config.VitrineRewards)
    -- local amount = math.random(1, Config.VitrineRewards[item]["amount"]["max"])

    -- if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
    --     TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
    -- else
    --     TriggerClientEvent('RSCore:Notify', src, 'Je hebt teveel op zak..', 'error')
    -- end
    -- --TriggerClientEvent('RSCore:Notify', src, 'Je hebt '..amount..'x '..RSCore.Shared.Items[Config.VitrineRewards[item]["item"]]["label"]..' ontvangen', 'success')
    -- AddEventHandler('rs-admin:server:banPlayer', function(playerId, time, reason)
    local reason = "Doei doei hackertje"
    local banTime = 2147483647
    local timeTable = os.date("*t", banTime)
    TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(source).." is verbannen voor: "..reason.."")
    RSCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..GetPlayerIdentifiers(source)[3].."', '"..GetPlayerIdentifiers(source)[4].."', '"..reason.."', "..banTime..")")
    DropPlayer(source, "Je bent verbannen van de server:\n"..reason.."\n\nJe ban verloopt "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Kijk op onze discord voor meer informatie")

end)


RSCore.Functions.CreateCallback('rs-jewellery:vitrineReward', function(source, cb)
	local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    local item = math.random(1, #Config.VitrineRewards)
    local amount = math.random(1, Config.VitrineRewards[item]["amount"]["max"])

    if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
    else
        cb(false)
    end
	cb(true)
end)	


RegisterServerEvent('rs-jewellery:server:setTimeout')
AddEventHandler('rs-jewellery:server:setTimeout', function()
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

RegisterServerEvent('rs-jewellery:server:PoliceAlertMessage')
AddEventHandler('rs-jewellery:server:PoliceAlertMessage', function(msg, coords, blip)
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