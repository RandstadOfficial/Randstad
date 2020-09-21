RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Oxy Run
RegisterServerEvent('oxydelivery:server')
AddEventHandler('oxydelivery:server', function()
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	
	if Player.Functions.RemoveMoney('cash', Config.StartOxyPayment, "pay-job") then
		TriggerClientEvent("oxydelivery:startDealing", source)
		TriggerClientEvent('chatMessage', source, "Dealer", "normal", "Er staat een auto voor u buiten. Uw pager wordt binnenkort bijgewerkt met locaties")
		TriggerClientEvent('RSCore:Notify', src, 'Je hebt 1500,- betaald', 'success')
	else
		TriggerClientEvent('RSCore:Notify', src, "Je hebt niet genoeg cash op zak!", 'error')   
    end
end)

-- RegisterServerEvent('oxydelivery:receiveBigRewarditem')
-- AddEventHandler('oxydelivery:receiveBigRewarditem', function()
-- 	RSCore.Functions.BanInjection(source, 'rs-oxyruns (receiveBigRewarditem)')
-- end)

RegisterServerEvent('oxydelivery:receiveoxy')
AddEventHandler('oxydelivery:receiveoxy', function()
    RSCore.Functions.BanInjection(source, 'rs-oxyruns (receiveoxy)')
end)

RegisterServerEvent('oxydelivery:receivemoneyyy')
AddEventHandler('oxydelivery:receivemoneyyy', function()
	RSCore.Functions.BanInjection(source, 'rs-oxyruns (receivemoneyyy)')
end)

-- RSCore.Functions.CreateCallback('oxydelivery:server:receiveBigRewarditem', function(source, cb)
--     local src = source
--     local Player = RSCore.Functions.GetPlayer(src)
 
-- 	Player.Functions.AddItem('security_card_03', 1)
--     TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['security_card_03'], "add")
-- end)
 
RSCore.Functions.CreateCallback('oxydelivery:server:receiveOxey', function(source, cb)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local PurpleCardOxy = math.random(1, 1000)
 
    local price = math.random(250, 300)
	Player.Functions.AddMoney("cash", price, "oxy-money")

    Player.Functions.AddItem('painkillers', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['painkillers'], "add")

    if PurpleCardOxy <= 50 then
        Player.Functions.AddItem('security_card_03', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['security_card_03'], "add")
    end
end)
 
RSCore.Functions.CreateCallback('oxydelivery:server:receiveMoney', function(source, cb)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local PurpleCardMoney = math.random(1, 1000)
    
    local price = math.random(300, 350)
    Player.Functions.AddMoney("cash", price, "oxy-money")

    if PurpleCardMoney <= 50 then
        Player.Functions.AddItem('security_card_03', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['security_card_03'], "add")
    end
end)

RegisterServerEvent('rs-oxyruns:server:callCops')
AddEventHandler('rs-oxyruns:server:callCops', function(streetLabel, coords)
    local msg = "Er is een verdachte situatie op "..streetLabel..", mogelijk Oxy handel."
    local alertData = {
        title = "Oxyhandel",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg
    }
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("rs-oxyruns:client:robberyCall", Player.PlayerData.source, msg, streetLabel, coords)
                TriggerClientEvent("rs-phone:client:addPoliceAlert", Player.PlayerData.source, alertData)
            end
        end
	end
end)