RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RSCore.Functions.CreateCallback('rs-scoreboard:server:GetActiveCops', function(source, cb)
    local retval = 0
    
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                retval = retval + 1
            end
        end
    end

    cb(retval)
end)

RSCore.Functions.CreateCallback('rs-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

RegisterServerEvent('rs-scoreboard:server:SetActivityBusy')
AddEventHandler('rs-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('rs-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)