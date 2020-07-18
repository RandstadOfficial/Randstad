-- AFK Kick Time Limit (in seconds)
secondsUntilKick = 900

-- Load RSCore
RSCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if RSCore == nil then
            TriggerEvent("RSCore:GetObject", function(obj) RSCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local group = "user"
local isLoggedIn = false

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
    RSCore.Functions.TriggerCallback('rs-afkkick:server:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
    isLoggedIn = true
end)

RegisterNetEvent('RSCore:Client:OnPermissionUpdate')
AddEventHandler('RSCore:Client:OnPermissionUpdate', function(UserGroup)
    group = UserGroup
end)

-- Code
Citizen.CreateThread(function()
	while true do
		Wait(1000)
        playerPed = GetPlayerPed(-1)
        if isLoggedIn then
            if group == "user" then
                currentPos = GetEntityCoords(playerPed, true)
                if prevPos ~= nil then
                    if currentPos == prevPos then
                        if time ~= nil then
                            if time > 0 then
                                if time == (900) then
                                    RSCore.Functions.Notify('Je bent AFK en wordt over ' .. math.ceil(time / 60) .. ' minuten gekickt!', 'error', 10000)
                                elseif time == (600) then
                                    RSCore.Functions.Notify('Je bent AFK en wordt over ' .. math.ceil(time / 60) .. ' minuten gekickt!', 'error', 10000)
                                elseif time == (300) then
                                    RSCore.Functions.Notify('Je bent AFK en wordt over ' .. math.ceil(time / 60) .. ' minuten gekickt!', 'error', 10000)
                                elseif time == (150) then
                                    RSCore.Functions.Notify('Je bent AFK en wordt over ' .. math.ceil(time / 60) .. ' minuten gekickt!', 'error', 10000)   
                                elseif time == (60) then
                                    RSCore.Functions.Notify('Je bent AFK en wordt over ' .. math.ceil(time / 60) .. ' minuut gekickt!', 'error', 10000) 
                                elseif time == (30) then
                                    RSCore.Functions.Notify('Je bent AFK en wordt over ' .. time .. ' seconden gekickt!', 'error', 10000)  
                                elseif time == (20) then
                                    RSCore.Functions.Notify('Je bent AFK en wordt over ' .. time .. ' seconden gekickt!', 'error', 10000)    
                                elseif time == (10) then
                                    RSCore.Functions.Notify('Je bent AFK en wordt over ' .. time .. ' seconden gekickt!', 'error', 10000)                                                                                                            
                                end
                                time = time - 1
                            else
                                TriggerServerEvent("KickForAFK")
                            end
                        else
                            time = secondsUntilKick
                        end
                    else
                        time = secondsUntilKick
                    end
                end
                prevPos = currentPos
            end
        end
    end
end)