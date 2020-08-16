RSCore                             = nil
local PlayerData                = {}
local isLoggedIn = false
percent    = false
searching  = false
cachedBins = {}
closestBin = {
    'prop_dumpster_01a',
    'prop_dumpster_02a',
    'prop_dumpster_02b'
}


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if RSCore == nil then
            TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
            Citizen.Wait(200)
        end
    end
end)
--[[
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

		TriggerEvent("mrpx:getSharedObject", function(library)
			ESX = library
		end)
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent("mrpx:playerLoaded")
AddEventHandler("mrpx:playerLoaded", function(response)
	ESX.PlayerData = response
end)
]]--


RegisterNetEvent("RSCore:Client:OnPlayerLoaded")
AddEventHandler("RSCore:Client:OnPlayerLoaded", function()
    PlayerJob = RSCore.Functions.GetPlayerData().job
    isLoggedIn = true
end)


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.007+ factor, 0.022, 39, 11, 41, 68)
end

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for i = 1, #closestBin do
            local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestBin[i]), false, false, false)
            local entity = nil
            if DoesEntityExist(x) then
                sleep  = 5
                entity = x
                bin    = GetEntityCoords(entity)
                DrawText3Ds(bin.x, bin.y, bin.z + 2.0, '[~g~E~w~] om dumpster te doorzoeken')  
                if IsControlJustReleased(0, 38) then
                    if not cachedBins[entity] then
                        openBin(entity)
                    else
						
                        RSCore.Functions.Notify('Je hebt deze dumpster al doorzocht pikkebaas',"error", 3500)
                    end
                end
                break
            else
                sleep = 1000
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do

        local sleep = 1000

        if percent then

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for i = 1, #closestBin do

                local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestBin[i]), false, false, false)
                local entity = nil
                
                if DoesEntityExist(x) then
                    sleep  = 5
                    entity = x
                    bin    = GetEntityCoords(entity)
                    DrawText3Ds(bin.x, bin.y, bin.z + 1.5, TimeLeft .. '~g~%~s~')
                    break
                end
            end
        end
        Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if searching then
            DisableControlAction(0, 73) 
        end
    end
end)