local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

inside = false
closesthouse = nil
hasKey = false
isOwned = false

isLoggedIn = true
local contractOpen = false

local cam = nil
local viewCam = false

local FrontCam = false

stashLocation = nil
outfitLocation = nil
logoutLocation = nil

local OwnedHouseBlips = {}

local CurrentDoorBell = 0
local rangDoorbell = nil

local houseObj = {}
local POIOffsets = nil
local entering = false
local data = nil

local CurrentHouse = nil

RSCore = nil

local inHoldersMenu = false

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if RSCore == nil then
            TriggerEvent("RSCore:GetObject", function(obj) RSCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('rs-houses:client:sellHouse')
AddEventHandler('rs-houses:client:sellHouse', function()
    if closesthouse ~= nil and hasKey then
        TriggerServerEvent('rs-houses:server:viewHouse', closesthouse)
    end
end)

--------------------------------------------------------------


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)

        if isLoggedIn then
            if not inside then
            SetClosestHouse()
            end
        end
    end
end)

RegisterNetEvent('rs-houses:client:EnterHouse')
AddEventHandler('rs-houses:client:EnterHouse', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if closesthouse ~= nil then
        local dist = GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true)
        if dist < 1.5 then
            if hasKey then
                enterOwnedHouse(closesthouse)
            else
                if not Config.Houses[closesthouse].locked then
                    enterNonOwnedHouse(closesthouse)
                end
            end
        end
    end
end)

RegisterNetEvent('rs-houses:client:RequestRing')
AddEventHandler('rs-houses:client:RequestRing', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if closesthouse ~= nil then
        TriggerServerEvent('rs-houses:server:RingDoor', closesthouse)
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    
    TriggerServerEvent('rs-houses:client:setHouses')
    isLoggedIn = true
    SetClosestHouse()
    TriggerEvent('rs-houses:client:setupHouseBlips')
    Citizen.Wait(100)
    TriggerEvent('rs-garages:client:setHouseGarage', closesthouse, hasKey)
    TriggerServerEvent("rs-houses:server:setHouses")
end)

function doorText(x, y, z, text)
    SetTextScale(0.325, 0.325)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.011, -0.025+ factor, 0.03, 0, 0, 0, 68)
    ClearDrawOrigin()
end

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('rs-houses:client:setHouses')
    isLoggedIn = true
    SetClosestHouse()
    TriggerEvent('rs-houses:client:setupHouseBlips')
    Citizen.Wait(100)
    TriggerEvent('rs-garages:client:setHouseGarage', closesthouse, hasKey)
    TriggerServerEvent("rs-houses:server:setHouses")
end)

RegisterNetEvent('RSCore:Client:OnPlayerUnload')
AddEventHandler('RSCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    inside = false
    closesthouse = nil
    hasKey = false
    isOwned = false
    for k, v in pairs(OwnedHouseBlips) do
        RemoveBlip(v)
    end
end)

RegisterNetEvent('rs-houses:client:setHouseConfig')
AddEventHandler('rs-houses:client:setHouseConfig', function(houseConfig)
    Config.Houses = houseConfig
    --TriggerEvent("rs-houses:client:refreshHouse")
end)

RegisterNetEvent('rs-houses:client:lockHouse')
AddEventHandler('rs-houses:client:lockHouse', function(bool, house)
    Config.Houses[house].locked = bool
end)

RegisterNetEvent('rs-houses:client:createHouses')
AddEventHandler('rs-houses:client:createHouses', function(price, tier)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local heading = GetEntityHeading(GetPlayerPed(-1))
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street = GetStreetNameFromHashKey(s1)
    local coords = {
        enter 	= { x = pos.x, y = pos.y, z = pos.z, h = heading},
        cam 	= { x = pos.x, y = pos.y, z = pos.z, h = heading, yaw = -10.00},
    }
    street = street:gsub("%-", " ")
    TriggerServerEvent('rs-houses:server:addNewHouse', street, coords, price, tier)
end)

RegisterNetEvent('rs-houses:client:addGarage')
AddEventHandler('rs-houses:client:addGarage', function()
    if closesthouse ~= nil then 
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local heading = GetEntityHeading(GetPlayerPed(-1))
        local coords = {
            x = pos.x,
            y = pos.y,
            z = pos.z,
            h = heading,
        }
        TriggerServerEvent('rs-houses:server:addGarage', closesthouse, coords)
    else
        RSCore.Functions.Notify("Geen huis in de buurt..", "error")
    end
end)

RegisterNetEvent('rs-houses:client:toggleDoorlock')
AddEventHandler('rs-houses:client:toggleDoorlock', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    
    if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
        if hasKey then
            if Config.Houses[closesthouse].locked then
                RSCore.Functions.TriggerCallback('rs-houses:server:lockHouse', function(result)
                end, false, closesthouse)
                -- TriggerServerEvent('rs-houses:server:lockHouse', false, closesthouse)
                RSCore.Functions.Notify("Huis is ontgrendeld!", "success", 2500)
            else
                RSCore.Functions.TriggerCallback('rs-houses:server:lockHouse', function(result)
                end, true, closesthouse)
                -- TriggerServerEvent('rs-houses:server:lockHouse', true, closesthouse)
                RSCore.Functions.Notify("Huis is vergrendeld!", "error", 2500)
            end
        else
            RSCore.Functions.Notify("Je hebt niet de sleutels van dit huis...", "error", 3500)
        end
    else
        RSCore.Functions.Notify("Er is geen deur te bekennen??", "error", 3500)
    end
end)

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do

        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        local inRange = false

        if closesthouse ~= nil then
            if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, false) < 30)then
                inRange = true
                if hasKey then
                    -- ENTER HOUSE
                    if not inside then
                        if closesthouse ~= nil then
                            if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
                                DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, '~b~/enter~w~ - Om naar binnen te gaan')
                            end
                        end
                    end

                    if CurrentDoorBell ~= 0 then
                        if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, true) < 1.5)then
                            DrawText3Ds(Config.Houses[closesthouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[closesthouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z + 0.35, '~g~G~w~ - Om deur open te doen')
                            if IsControlJustPressed(0, Keys["G"]) then
                                TriggerServerEvent("rs-houses:server:OpenDoor", CurrentDoorBell, closesthouse)
                                CurrentDoorBell = 0
                            end
                        end
                    end
                    -- EXIT HOUSE
                    if inside then
                        if not entering then
                            if POIOffsets ~= nil then
                                if POIOffsets.exit ~= nil then
                                    if(GetDistanceBetweenCoords(pos, Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, true) < 1.5)then
                                        DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, '~g~E~w~ - Om huis te verlaten')
                                        DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z - 0.1, '~g~H~w~ - Camera bekijken')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            leaveOwnedHouse(CurrentHouse)
                                        end
                                        if IsControlJustPressed(0, Keys["H"]) then
                                            FrontDoorCam(Config.Houses[CurrentHouse].coords.enter)
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if not isOwned then
                        if closesthouse ~= nil then
                            if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
                                if not viewCam and Config.Houses[closesthouse].locked then
                                    DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, '~g~E~w~ - Om het huis te bezichtigen')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        TriggerServerEvent('rs-houses:server:viewHouse', closesthouse)
                                    end
                                -- elseif not viewCam and not Config.Houses[closesthouse].locked then
                                --     DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, '[~g~E~w~] Om naar ~b~binnen~w~ te gaan')
                                --     if IsControlJustPressed(0, Keys["E"])  then
                                --         enterNonOwnedHouse(closesthouse)
                                --     end
                                end
                            end
                        end
                    elseif isOwned then
                        if closesthouse ~= nil then
                            if not inOwned then
                                -- if(GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true) < 1.5)then
                                    -- if not Config.Houses[closesthouse].locked then
                                    --     DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, '[~g~E~w~] Om naar ~b~binnen~w~ te gaan')
                                    --     if IsControlJustPressed(0, Keys["E"])  then
                                    --         enterNonOwnedHouse(closesthouse)
                                    --     end
                                    -- else
                                    --     DrawText3Ds(Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, 'De deur is ~r~vergrendeld / ~g~G~w~ - Aanbellen')
                                    --     if IsControlJustPressed(0, Keys["G"]) then
                                    --         TriggerServerEvent('rs-houses:server:RingDoor', closesthouse)
                                    --     end
                                    -- end
                                -- end
                            elseif inOwned then
                                if POIOffsets ~= nil then
                                    if POIOffsets.exit ~= nil then
                                        if(GetDistanceBetweenCoords(pos, Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, true) < 1.5)then
                                            DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, '~g~E~w~ - Om huis te verlaten')
                                            if IsControlJustPressed(0, Keys["E"]) then
                                                leaveNonOwnedHouse(CurrentHouse)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if inside and not isOwned then
                        if not entering then
                            if POIOffsets ~= nil then
                                if POIOffsets.exit ~= nil then
                                    if(GetDistanceBetweenCoords(pos, Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, true) < 1.5)then
                                        DrawText3Ds(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z, '~g~E~w~ - Om huis te verlaten')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            leaveNonOwnedHouse(CurrentHouse)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                local StashObject = nil
                -- STASH
                if inside then
                    if CurrentHouse ~= nil then
                        if stashLocation ~= nil then
                            if(GetDistanceBetweenCoords(pos, stashLocation.x, stashLocation.y, stashLocation.z, true) < 1.5)then
                                DrawText3Ds(stashLocation.x, stashLocation.y, stashLocation.z, '~g~E~w~ - Stash')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    local other = {}
                                    other.maxweight = 1000000
                                    other.slots = 50
                                    if Config.Houses[CurrentHouse].tier == 3 then -- Villa
                                        other.maxweight = 1250000
                                        other.slots = 55
                                    end
                                    if Config.Houses[CurrentHouse].tier == 8 then -- Warehouse
                                        other.maxweight = 750000
                                        other.slots = 40
                                    end
                                    if Config.Houses[CurrentHouse].tier == 5 then -- caravan
                                        other.maxweight = 500000
                                        other.slots = 30
                                    end
                                    TriggerServerEvent("inventory:server:OpenInventory", "stash", CurrentHouse, other)
                                    TriggerEvent("inventory:client:SetCurrentStash", CurrentHouse)
                                end
                            elseif(GetDistanceBetweenCoords(pos, stashLocation.x, stashLocation.y, stashLocation.z, true) < 3)then
                                DrawText3Ds(stashLocation.x, stashLocation.y, stashLocation.z, 'Stash')
                            end
                        end
                    end
                end

                if inside then
                    if CurrentHouse ~= nil then
                        if outfitLocation ~= nil then
                            if(GetDistanceBetweenCoords(pos, outfitLocation.x, outfitLocation.y, outfitLocation.z, true) < 1.5)then
                                DrawText3Ds(outfitLocation.x, outfitLocation.y, outfitLocation.z, '~g~E~w~ - Outfits')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    TriggerEvent('rs-clothing:client:openOutfitMenu')
                                end
                            elseif(GetDistanceBetweenCoords(pos, outfitLocation.x, outfitLocation.y, outfitLocation.z, true) < 3)then
                                DrawText3Ds(outfitLocation.x, outfitLocation.y, outfitLocation.z, 'Outfits')
                            end
                        end
                    end
                end

                if inside then
                    if CurrentHouse ~= nil then
                        if logoutLocation ~= nil then
                            if(GetDistanceBetweenCoords(pos, logoutLocation.x, logoutLocation.y, logoutLocation.z, true) < 1.5)then
                                DrawText3Ds(logoutLocation.x, logoutLocation.y, logoutLocation.z, '~g~E~w~ - Uitloggen')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    DoScreenFadeOut(250)
                                    while not IsScreenFadedOut() do
                                        Citizen.Wait(10)
                                    end
                                    exports['rs-interior']:DespawnInterior(houseObj, function()
                                        TriggerEvent('rs-weathersync:client:EnableSync')
                                        SetEntityCoords(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.5)
                                        SetEntityHeading(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.h)
                                        inOwned = false
                                        inside = false
                                        TriggerServerEvent('rs-houses:server:LogoutLocation')
                                    end)
                                end
                            elseif(GetDistanceBetweenCoords(pos, logoutLocation.x, logoutLocation.y, logoutLocation.z, true) < 3)then
                                DrawText3Ds(logoutLocation.x, logoutLocation.y, logoutLocation.z, 'Uitloggen')
                            end
                        end
                    end
                end
            end
        end
        if not inRange then
            Citizen.Wait(1500)
        end
    
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if inHoldersMenu then
            Menu.renderGUI()
        end
    end
end)

function openHouseAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end

RegisterNetEvent('rs-houses:client:RingDoor')
AddEventHandler('rs-houses:client:RingDoor', function(player, house)
    if closesthouse == house and inside then
        CurrentDoorBell = player
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
        RSCore.Functions.Notify("Iemand belt aan de deur!")
    end
end)

function GetClosestPlayer()
    local closestPlayers = RSCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

RegisterNetEvent('rs-houses:client:giveHouseKey')
AddEventHandler('rs-houses:client:giveHouseKey', function(data)
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 and closesthouse ~= nil then
        local playerId = GetPlayerServerId(player)
        local housedist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z)
        
        if housedist < 10 then
            RSCore.Functions.TriggerCallback('rs-houses:server:giveHouseKey', function(result)
            end, playerId, closesthouse)
            -- TriggerServerEvent('rs-houses:server:giveHouseKey', playerId, closesthouse)
        else
            RSCore.Functions.Notify("Je staat niet dicht genoeg bij het huis..", "error")
        end
    elseif closesthouse == nil then
        RSCore.Functions.Notify("Er is geen huis in de buurt!", "error")
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('rs-houses:client:removeHouseKey')
AddEventHandler('rs-houses:client:removeHouseKey', function(data)
    if closesthouse ~= nil then 
        local housedist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z)
        if housedist < 5 then
            RSCore.Functions.TriggerCallback('rs-houses:server:getHouseOwner', function(result)
                if RSCore.Functions.GetPlayerData().citizenid == result then
                    inHoldersMenu = true
                    HouseKeysMenu()
                    Menu.hidden = not Menu.hidden
                else
                    RSCore.Functions.Notify("Je bent geen huiseigenaar..", "error")
                end
            end, closesthouse)
        else
            RSCore.Functions.Notify("Je staat niet dicht genoeg bij het huis..", "error")
        end
    else
        RSCore.Functions.Notify("Je staat niet dicht genoeg bij het huis..", "error")
    end
end)

RegisterNetEvent('rs-houses:client:refreshHouse')
AddEventHandler('rs-houses:client:refreshHouse', function(data)
    Citizen.Wait(100)
    SetClosestHouse()
    --TriggerEvent('rs-garages:client:setHouseGarage', closesthouse, hasKey)
end)

RegisterNetEvent('rs-houses:client:SpawnInApartment')
AddEventHandler('rs-houses:client:SpawnInApartment', function(house)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if rangDoorbell ~= nil then
        if(GetDistanceBetweenCoords(pos, Config.Houses[house].coords.enter.x, Config.Houses[house].coords.enter.y, Config.Houses[house].coords.enter.z, true) > 5)then
            return
        end
    end
    closesthouse = house
    enterNonOwnedHouse(house)
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end 

function HouseKeysMenu()
    ped = GetPlayerPed(-1);
    MenuTitle = "Sleutels"
    ClearMenu()
    RSCore.Functions.TriggerCallback('rs-houses:server:getHouseKeyHolders', function(holders)
        ped = GetPlayerPed(-1);
        MenuTitle = "Sleutelhouders:"
        ClearMenu()
        if holders == nil or next(holders) == nil then
            RSCore.Functions.Notify("Geen sleutel houders gevonden..", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(holders) do
                Menu.addButton(holders[k].firstname .. " " .. holders[k].lastname, "optionMenu", holders[k]) 
            end
        end
        Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
    end, closesthouse)
end

function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function optionMenu(citizenData)
    ped = GetPlayerPed(-1);
    MenuTitle = "What now?"
    ClearMenu()
    Menu.addButton("Verwijder sleutel", "removeHouseKey", citizenData) 
    Menu.addButton("Terug", "HouseKeysMenu",nil)
end

function removeHouseKey(citizenData)
    TriggerServerEvent('rs-houses:server:removeHouseKey', closesthouse, citizenData)
    closeMenuFull()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    RSCore.Functions.Notify(oData.outfitname.." is verwijderd", "success", 2500)
    closeMenuFull()
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    inHoldersMenu = false
    ClearMenu()
end

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function openContract(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "toggle",
        status = bool,
    })
    contractOpen = bool
end

function enterOwnedHouse(house)
    CurrentHouse = house
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    inside = true
    Citizen.Wait(250)
    local coords = { x = Config.Houses[house].coords.enter.x, y = Config.Houses[house].coords.enter.y, z= Config.Houses[house].coords.enter.z - Config.MinZOffset}
    LoadDecorations(house)

    if Config.Houses[house].tier == 1 then
        data = exports['rs-interior']:CreateTier1House(coords)
    -- elseif Config.Houses[house].tier == 2 then
    --     data = exports['rs-interior']:CreateTrevorsShell(coords)
    elseif Config.Houses[house].tier == 3 then
        data = exports['rs-interior']:CreateMichaelShell(coords)
    elseif Config.Houses[house].tier == 4 then
        data = exports['rs-interior']:CreateApartmentShell(coords)
    elseif Config.Houses[house].tier == 5 then
        data = exports['rs-interior']:CreateCaravanShell(coords)
    elseif Config.Houses[house].tier == 6 then
        data = exports['rs-interior']:CreateFranklinShell(coords)
    elseif Config.Houses[house].tier == 7 then
        data = exports['rs-interior']:CreateFranklinAuntShell(coords)
    elseif Config.Houses[house].tier == 8 then
        data = exports['rs-interior']:CreateWarehouse(coords)
    end

    Citizen.Wait(100)
    houseObj = data[1]
    POIOffsets = data[2]
    print(POIOffsets)
    print(data[2])
    print(POIOffsets.exit.x)
    entering = true
    TriggerServerEvent('rs-houses:server:SetInsideMeta', house, true)
    Citizen.Wait(500)
    SetRainFxIntensity(0.0)
    TriggerEvent('rs-weathersync:client:DisableSync')
    TriggerEvent('rs-weed:client:getHousePlants', house)
    Citizen.Wait(100)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(23, 0, 0)
    entering = false
    setHouseLocations()
end

RegisterNetEvent('rs-houses:client:enterOwnedHouse')
AddEventHandler('rs-houses:client:enterOwnedHouse', function(house)
    RSCore.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] == 0 then
			enterOwnedHouse(house)
		end
	end)
end)

RegisterNUICallback('HasEnoughMoney', function(data, cb)
    RSCore.Functions.TriggerCallback('rs-houses:server:HasEnoughMoney', function(hasEnough)
        
    end, data.objectData)
end)

RegisterNetEvent('rs-houses:client:LastLocationHouse')
AddEventHandler('rs-houses:client:LastLocationHouse', function(houseId)
    RSCore.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] == 0 then
			enterOwnedHouse(houseId)
		end
	end)
end)

function leaveOwnedHouse(house)
    if not FrontCam then
        inside = false
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
        openHouseAnim()
        Citizen.Wait(250)
        DoScreenFadeOut(250)
        Citizen.Wait(500)
        exports['rs-interior']:DespawnInterior(houseObj, function()
            UnloadDecorations()
            TriggerEvent('rs-weathersync:client:EnableSync')
            Citizen.Wait(250)
            DoScreenFadeIn(250)
            SetEntityCoords(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.2)
            SetEntityHeading(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.h)
            TriggerEvent('rs-weed:client:leaveHouse')
            TriggerServerEvent('rs-houses:server:SetInsideMeta', house, false)
            CurrentHouse = nil
        end)
    end
end

function enterNonOwnedHouse(house)
    CurrentHouse = house
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    inside = true
    Citizen.Wait(250)
    local coords = { x = Config.Houses[closesthouse].coords.enter.x, y = Config.Houses[closesthouse].coords.enter.y, z= Config.Houses[closesthouse].coords.enter.z - Config.MinZOffset}
    LoadDecorations(house)

    if Config.Houses[house].tier == 1 then
        data = exports['rs-interior']:CreateTier1House(coords)
    -- elseif Config.Houses[house].tier == 2 then
    --     data = exports['rs-interior']:CreateTrevorsShell(coords)
    elseif Config.Houses[house].tier == 3 then
        data = exports['rs-interior']:CreateMichaelShell(coords)
    elseif Config.Houses[house].tier == 4 then
        data = exports['rs-interior']:CreateApartmentShell(coords)
    elseif Config.Houses[house].tier == 5 then
        data = exports['rs-interior']:CreateCaravanShell(coords)
    elseif Config.Houses[house].tier == 6 then
        data = exports['rs-interior']:CreateFranklinShell(coords)
    elseif Config.Houses[house].tier == 7 then
        data = exports['rs-interior']:CreateFranklinAuntShell(coords)
    elseif Config.Houses[house].tier == 8 then
        data = exports['rs-interior']:CreateWarehouse(coords)
    end

    houseObj = data[1]
    POIOffsets = data[2]
    entering = true
    Citizen.Wait(500)
    SetRainFxIntensity(0.0)
    TriggerServerEvent('rs-houses:server:SetInsideMeta', house, true)
    TriggerEvent('rs-weathersync:client:DisableSync')
    TriggerEvent('rs-weed:client:getHousePlants', house)
    Citizen.Wait(100)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(23, 0, 0)
    entering = false
    inOwned = true
    setHouseLocations()
end

function leaveNonOwnedHouse(house)
    if not FrontCam then
        inside = false
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
        openHouseAnim()
        Citizen.Wait(250)
        DoScreenFadeOut(250)
        Citizen.Wait(500)
        exports['rs-interior']:DespawnInterior(houseObj, function()
            UnloadDecorations()
            TriggerEvent('rs-weathersync:client:EnableSync')
            Citizen.Wait(250)
            DoScreenFadeIn(250)
            SetEntityCoords(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z + 0.2)
            SetEntityHeading(GetPlayerPed(-1), Config.Houses[CurrentHouse].coords.enter.h)
            inOwned = false
            TriggerEvent('rs-weed:client:leaveHouse')
            TriggerServerEvent('rs-houses:server:SetInsideMeta', house, false)
            CurrentHouse = nil
        end)
    end
end

RegisterNetEvent('rs-houses:client:setupHouseBlips')
AddEventHandler('rs-houses:client:setupHouseBlips', function()
    Citizen.CreateThread(function()
        Citizen.Wait(2000)
        if isLoggedIn then
            RSCore.Functions.TriggerCallback('rs-houses:server:getOwnedHouses', function(ownedHouses)
                if ownedHouses ~= nil then
                    for k, v in pairs(ownedHouses) do
                        local house = Config.Houses[ownedHouses[k]]
                        HouseBlip = AddBlipForCoord(house.coords.enter.x, house.coords.enter.y, house.coords.enter.z)

                        SetBlipSprite (HouseBlip, 40)
                        SetBlipDisplay(HouseBlip, 4)
                        SetBlipScale  (HouseBlip, 0.65)
                        SetBlipAsShortRange(HouseBlip, true)
                        SetBlipColour(HouseBlip, 3)

                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentSubstringPlayerName(house.adress)
                        EndTextCommandSetBlipName(HouseBlip)

                        table.insert(OwnedHouseBlips, HouseBlip)
                    end
                end
            end)
        end
    end)
end)

RegisterNetEvent('rs-houses:client:SetClosestHouse')
AddEventHandler('rs-houses:client:SetClosestHouse', function()
    SetClosestHouse()
end)

function setViewCam(coords, h, yaw)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z, yaw, 0.00, h, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    viewCam = true
end

function FrontDoorCam(coords)
    DoScreenFadeOut(150)
    Citizen.Wait(500)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z + 0.5, 0.0, 0.00, coords.h - 180, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    FrontCam = true
    FreezeEntityPosition(GetPlayerPed(-1), true)
    Citizen.Wait(500)
    DoScreenFadeIn(150)
    SendNUIMessage({
        type = "frontcam",
        toggle = true,
        label = Config.Houses[closesthouse].adress
    })
    Citizen.CreateThread(function()
        while FrontCam do

            local instructions = CreateInstuctionScaleform("instructional_buttons")
            DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
            SetTimecycleModifier("scanline_cam_cheap")
            SetTimecycleModifierStrength(1.0)

            if IsControlJustPressed(1, Keys["BACKSPACE"]) then
                DoScreenFadeOut(150)
                SendNUIMessage({
                    type = "frontcam",
                    toggle = false,
                })
                Citizen.Wait(500)
                RenderScriptCams(false, true, 500, true, true)
                FreezeEntityPosition(GetPlayerPed(-1), false)
                SetCamActive(cam, false)
                DestroyCam(cam, true)
                ClearTimecycleModifier("scanline_cam_cheap")
                cam = nil
                FrontCam = false
                Citizen.Wait(500)
                DoScreenFadeIn(150)
            end

            local getCameraRot = GetCamRot(cam, 2)

            -- ROTATE UP
            if IsControlPressed(0, Keys["W"]) then
                if getCameraRot.x <= 0.0 then
                    SetCamRot(cam, getCameraRot.x + 0.7, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE DOWN
            if IsControlPressed(0, Keys["S"]) then
                if getCameraRot.x >= -50.0 then
                    SetCamRot(cam, getCameraRot.x - 0.7, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE LEFT
            if IsControlPressed(0, Keys["A"]) then
                SetCamRot(cam, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
            end

            -- ROTATE RIGHT
            if IsControlPressed(0, Keys["D"]) then
                SetCamRot(cam, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
            end

            Citizen.Wait(1)
        end
    end)
end

function CreateInstuctionScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    InstructionButton(GetControlInstructionalButton(1, 194, true))
    InstructionButtonMessage("Sluit Camera")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function InstructionButton(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function disableViewCam()
    if viewCam then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        viewCam = false
    end
end

RegisterNUICallback('buy', function()
    openContract(false)
    disableViewCam()
    TriggerServerEvent('rs-houses:server:buyHouse', closesthouse)
end)

RegisterNUICallback('exit', function()
    openContract(false)
    disableViewCam()
end)

RegisterNetEvent('rs-houses:client:viewHouse')
AddEventHandler('rs-houses:client:viewHouse', function(houseprice, brokerfee, bankfee, taxes, firstname, lastname)
    setViewCam(Config.Houses[closesthouse].coords.cam, Config.Houses[closesthouse].coords.cam.h, Config.Houses[closesthouse].coords.yaw)
    Citizen.Wait(500)
    openContract(true)
    SendNUIMessage({
        type = "setupContract",
        firstname = firstname,
        lastname = lastname,
        street = Config.Houses[closesthouse].adress,
        houseprice = houseprice,
        brokerfee = brokerfee,
        bankfee = bankfee,
        taxes = taxes,
        totalprice = (houseprice + brokerfee + bankfee + taxes)
    })
end)

function SetClosestHouse()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    if not inside then
        for id, house in pairs(Config.Houses) do
            if current ~= nil then
                if(GetDistanceBetweenCoords(pos, Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z, true) < dist)then
                    current = id
                    dist = GetDistanceBetweenCoords(pos, Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z, true)
                end
            else
                dist = GetDistanceBetweenCoords(pos, Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z, true)
                current = id
            end
        end
        closesthouse = current
    
        if closesthouse ~= nil then 
            RSCore.Functions.TriggerCallback('rs-houses:server:hasKey', function(result)
                hasKey = result
            end, closesthouse)
        
            RSCore.Functions.TriggerCallback('rs-houses:server:isOwned', function(result)
                isOwned = result
            end, closesthouse)
        end
    end
    TriggerEvent('rs-garages:client:setHouseGarage', closesthouse, hasKey)
end

function setHouseLocations()
    if closesthouse ~= nil then
        RSCore.Functions.TriggerCallback('rs-houses:server:getHouseLocations', function(result)
            if result ~= nil then
                if result.stash ~= nil then
                    stashLocation = json.decode(result.stash)
                end

                if result.outfit ~= nil then
                    outfitLocation = json.decode(result.outfit)
                end

                if result.logout ~= nil then
                    logoutLocation = json.decode(result.logout)
                end
            end
        end, closesthouse)
    end
end

RegisterNetEvent('rs-houses:client:setLocation')
AddEventHandler('rs-houses:client:setLocation', function(data)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local coords = {x = pos.x, y = pos.y, z = pos.z}

    if inside then
        if hasKey then
            if data.id == 'setstash' then
                TriggerServerEvent('rs-houses:server:setLocation', coords, closesthouse, 1)
            elseif data.id == 'setoutift' then
                TriggerServerEvent('rs-houses:server:setLocation', coords, closesthouse, 2)
            elseif data.id == 'setlogout' then
                TriggerServerEvent('rs-houses:server:setLocation', coords, closesthouse, 3)
            end
        else
            RSCore.Functions.Notify('Je bent niet de eigenaar van het huis..', 'error')
        end
    else    
        RSCore.Functions.Notify('Je bent niet in een huis..', 'error')
    end
end)

RegisterNetEvent('rs-houses:client:refreshLocations')
AddEventHandler('rs-houses:client:refreshLocations', function(house, location, type)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    if closesthouse == house then
        if inside then
            if type == 1 then
                stashLocation = json.decode(location)
            elseif type == 2 then
                outfitLocation = json.decode(location)
            elseif type == 3 then
                logoutLocation = json.decode(location)
            end
        end
    end
end)

local RamsDone = 0

function DoRamAnimation(bool)
    local ped = GetPlayerPed(-1)
    local dict = "missheistfbi3b_ig7"
    local anim = "lift_fibagent_loop"

    if bool then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 1, -1, false, false, false)
    else
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
        TaskPlayAnim(ped, dict, "exit", 8.0, 8.0, -1, 1, -1, false, false, false)
    end
end

RegisterNetEvent('rs-houses:client:HomeInvasion')
AddEventHandler('rs-houses:client:HomeInvasion', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local Skillbar = exports['rs-skillbar']:GetSkillbarObject()

    if closesthouse ~= nil then
        RSCore.Functions.TriggerCallback('police:server:IsPoliceForcePresent', function(IsPresent)
            if IsPresent then
                local dist = GetDistanceBetweenCoords(pos, Config.Houses[closesthouse].coords.enter.x, Config.Houses[closesthouse].coords.enter.y, Config.Houses[closesthouse].coords.enter.z, true)
                if Config.Houses[closesthouse].IsRaming == nil then
                    Config.Houses[closesthouse].IsRaming = false
                end
        
                if dist < 1 then
                    if Config.Houses[closesthouse].locked then
                        if not Config.Houses[closesthouse].IsRaming then
                            DoRamAnimation(true)
                            Skillbar.Start({
                                duration = math.random(5000, 10000),
                                pos = math.random(10, 30),
                                width = math.random(10, 20),
                            }, function()
                                if RamsDone + 1 >= Config.RamsNeeded then
                                    RSCore.Functions.TriggerCallback("rs-houses:server:lockHouse", function(result)
                                        
                                    end, false, closesthouse)
                                    -- TriggerServerEvent('rs-houses:server:lockHouse', false, closesthouse)
                                    RSCore.Functions.Notify('Het is gelukt, de deur ligt er nu uit.', 'success')
                                    TriggerServerEvent('rs-houses:server:SetHouseRammed', true, closesthouse)
                                    DoRamAnimation(false)
                                else
                                    DoRamAnimation(true)
                                    Skillbar.Repeat({
                                        duration = math.random(500, 1000),
                                        pos = math.random(10, 30),
                                        width = math.random(5, 12),
                                    })
                                    RamsDone = RamsDone + 1
                                end
                            end, function()
                                RamsDone = 0
                                RSCore.Functions.TriggerCallback('rs-houses:server:SetRamState', function(result)
                                end, false, closesthouse)
                                -- TriggerServerEvent('rs-houses:server:SetRamState', false, closesthouse)
                                RSCore.Functions.Notify('Het is mislukt.. Probeer het nogmaals.', 'error')
                                DoRamAnimation(false)
                            end)
                            RSCore.Functions.TriggerCallback('rs-houses:server:SetRamState', function(result)
                            end, true, closesthouse)
                            -- TriggerServerEvent('rs-houses:server:SetRamState', true, closesthouse)
                        else
                            RSCore.Functions.Notify('Er is al iemand bezig met de deur..', 'error')
                        end
                    else
                        RSCore.Functions.Notify('Dit huis is al open..', 'error')
                    end
                else
                    RSCore.Functions.Notify('Je bent niet bij een huis in de buurt..', 'error')
                end
            else
                RSCore.Functions.Notify('Er is geen korpsleiding aanwezig..', 'error')
            end
        end)
    else
        RSCore.Functions.Notify('Je bent niet bij een huis in de buurt..', 'error')
    end
end)

RegisterNetEvent('rs-houses:client:SetRamState')
AddEventHandler('rs-houses:client:SetRamState', function(bool, house)
    Config.Houses[house].IsRaming = bool
end)

RegisterNetEvent('rs-houses:client:SetHouseRammed')
AddEventHandler('rs-houses:client:SetHouseRammed', function(bool, house)
    Config.Houses[house].IsRammed = bool
end)

RegisterNetEvent('rs-houses:client:ResetHouse')
AddEventHandler('rs-houses:client:ResetHouse', function()
    local ped = GetPlayerPed(-1)

    if closesthouse ~= nil then
        if Config.Houses[closesthouse].IsRammed == nil then
            Config.Houses[closesthouse].IsRammed = false
            TriggerServerEvent('rs-houses:server:SetHouseRammed', false, closesthouse)
            RSCore.Functions.TriggerCallback('rs-houses:server:SetRamState', function(result)
            end, false, closesthouse)
            -- TriggerServerEvent('rs-houses:server:SetRamState', false, closesthouse)
        end
        if Config.Houses[closesthouse].IsRammed then
            openHouseAnim()
            TriggerServerEvent('rs-houses:server:SetHouseRammed', false, closesthouse)
            RSCore.Functions.TriggerCallback('rs-houses:server:SetRamState', function(result)
            end, false, closesthouse)
            -- TriggerServerEvent('rs-houses:server:SetRamState', false, closesthouse)
            RSCore.Functions.TriggerCallback("rs-houses:server:lockHouse", function(result)                 
            end, true, closesthouse)
            -- TriggerServerEvent('rs-houses:server:lockHouse', true, closesthouse)
            RamsDone = 0
            RSCore.Functions.Notify('Je hebt het huis weer opslot gedaan..', 'success')
        else
            RSCore.Functions.Notify('Deze deur is niet open gebroken..', 'error')
        end
    end
end)