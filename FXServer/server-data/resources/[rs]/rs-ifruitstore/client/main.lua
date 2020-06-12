Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

RSCore = nil
local isLoggedIn = false
local CurrentCops = 0

Citizen.CreateThread(function() 
    while RSCore == nil do
        TriggerEvent("RSCore:GetObject", function(obj) RSCore = obj end)    
        Citizen.Wait(200)
    end
end)

local requiredItemsShowed = false
local requiredItemsShowed2 = false
local requiredItems = {}
local currentSpot = 0
local usingSafe = false

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z, true) < 3.0 and not Config.Locations["thermite"].isDone then
                DrawMarker(2, Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.1, 255, 255, 255, 100, 0, 0, 0, 1, 0, 0, 0)
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z, true) < 1.0 then
                    if not Config.Locations["thermite"].isDone then 
                        if not requiredItemsShowed then
                            requiredItems = {
                                [1] = {name = RSCore.Shared.Items["thermite"]["name"], image = RSCore.Shared.Items["thermite"]["image"]},
                            }
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    end
                end
            else
                if requiredItemsShowed then
                    requiredItems = {
                        [1] = {name = RSCore.Shared.Items["thermite"]["name"], image = RSCore.Shared.Items["thermite"]["image"]},
                    }
                    requiredItemsShowed = false
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end
            end
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["safe"].x, Config.Locations["safe"].y,Config.Locations["safe"].z, true) < 1.0 then
                if not Config.Locations["safe"].isDone then 
                    DrawText3Ds(Config.Locations["safe"].x, Config.Locations["safe"].y,Config.Locations["safe"].z, '~g~E~w~ Om kluis te kraken')
                    if IsControlJustPressed(0, Keys["E"]) then
                        RSCore.Functions.TriggerCallback('rs-storerobbery:server:getPadlockCombination', function(combination)
                            TriggerServerEvent("rs-ifruitstore:server:SetSafeStatus", "isBusy", true)
                            TriggerEvent("SafeCracker:StartMinigame", combination)
                            usingSafe = true
                        end, 2)
                    end
                end
            end
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    local inRange = false
    while true do
        Citizen.Wait(1)
        if isLoggedIn then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            for spot, location in pairs(Config.Locations["takeables"]) do
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["takeables"][spot].x, Config.Locations["takeables"][spot].y,Config.Locations["takeables"][spot].z, true)
                if dist < 1.0 then
                    inRange = true
                    if dist < 0.6 then
                        if not requiredItemsShowed2 then
                            requiredItems = {
                                [1] = {name = RSCore.Shared.Items["advancedlockpick"]["name"], image = RSCore.Shared.Items["advancedlockpick"]["image"]},
                            }
                            requiredItemsShowed2 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                        if not Config.Locations["takeables"][spot].isBusy and not Config.Locations["takeables"][spot].isDone then
                            DrawText3Ds(Config.Locations["takeables"][spot].x, Config.Locations["takeables"][spot].y,Config.Locations["takeables"][spot].z, '~g~E~w~ Om item te pakken')
                            if IsControlJustPressed(0, Keys["E"]) then
                                if CurrentCops >= 0 then
                                    if Config.Locations["thermite"].isDone then 
                                        RSCore.Functions.TriggerCallback('rs-radio:server:GetItem', function(hasItem)
                                            if hasItem then
                                                currentSpot = spot
                                                if requiredItemsShowed2 then
                                                    requiredItems = {
                                                        [1] = {name = RSCore.Shared.Items["advancedlockpick"]["name"], image = RSCore.Shared.Items["advancedlockpick"]["image"]},
                                                    }
                                                    requiredItemsShowed2 = false
                                                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                                end
                                                TriggerEvent("rs-lockpick:client:openLockpick", lockpickDone)
                                            else
                                                RSCore.Functions.Notify("Je mist een grote lockpick..", "error")
                                            end
                                        end, "advancedlockpick")
                                    else
                                        RSCore.Functions.Notify("Beveiliging is nog actief..", "error")
                                    end
                                else
                                    RSCore.Functions.Notify("Niet genoeg politie..", "error")
                                end
                            end
                        end
                    end
                end
            end
            if not inRange then
                if requiredItemsShowed2 then
                    requiredItems = {
                        [1] = {name = RSCore.Shared.Items["advancedlockpick"]["name"], image = RSCore.Shared.Items["advancedlockpick"]["image"]},
                    }
                    requiredItemsShowed2 = false
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end
                Citizen.Wait(2000)
            end
        end
    end
end)

function lockpickDone(success)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if success then
        GrabItem(currentSpot)
    else
        if math.random(1, 100) <= 40 and IsWearingHandshoes() then
            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
            RSCore.Functions.Notify("Je hebt je handschoen gescheurd..")
        end
        if math.random(1, 100) <= 10 then
            TriggerServerEvent("RSCore:Server:RemoveItem", "advancedlockpick", 1)
            TriggerEvent('inventory:client:ItemBox', RSCore.Shared.Items["advancedlockpick"], "remove")
        end
    end
end

function GrabItem(spot)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if requiredItemsShowed2 then
        requiredItemsShowed2 = false
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
    RSCore.Functions.Progressbar("grab_ifruititem", "Item loskoppelen..", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
        TriggerServerEvent('rs-ifruitstore:server:setSpotState', "isDone", true, spot)
        TriggerServerEvent('rs-ifruitstore:server:setSpotState', "isBusy", false, spot)
        RSCore.Functions.TriggerCallback('rs-ifruitstore:server:itemReward', function()
        end, spot)
        TriggerServerEvent('rs-ifruitstore:server:PoliceAlertMessage', 'Personen proberen spullen te stelen bij de iFruit winkel', pos, true)
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
        TriggerServerEvent('rs-jewellery:server:setSpotState', "isBusy", false, spot)
        RSCore.Functions.Notify("Geannuleerd..", "error")
    end)
end

RegisterNetEvent('SafeCracker:EndMinigame')
AddEventHandler('SafeCracker:EndMinigame', function(won)
    if usingSafe then
        if won then
            if not Config.Locations["safe"].isDone then
                SetNuiFocus(false, false)
                                                
                RSCore.Functions.TriggerCallback('rs-ifruitstore:server:SafeReward', function()
                end, amount)
                TriggerServerEvent("rs-ifruitstore:server:SetSafeStatus", "isBusy", false)
                TriggerServerEvent("rs-ifruitstore:server:SetSafeStatus", "isDone", false)
                takeAnim()
            end
        end
    end
end)

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    TriggerServerEvent("rs-ifruitstore:server:LoadLocationList")
end)

RegisterNetEvent('RSCore:Client:OnPlayerUnload')
AddEventHandler('RSCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('rs-ifruitstore:client:LoadList')
AddEventHandler('rs-ifruitstore:client:LoadList', function(list)
    Config.Locations = list
end)

RegisterNetEvent('thermite:UseThermite')
AddEventHandler('thermite:UseThermite', function()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z, true) < 1.0 then
        if CurrentCops >= 0 then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
            end
            if requiredItemsShowed then
                requiredItems = {
                    [1] = {name = RSCore.Shared.Items["thermite"]["name"], image = RSCore.Shared.Items["thermite"]["image"]},
                }
                requiredItemsShowed = false
                TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                TriggerServerEvent("rs-ifruitstore:server:SetThermiteStatus", "isBusy", true)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "openThermite",
                    amount = math.random(5, 10),
                })
            end
        else
            RSCore.Functions.Notify("Niet genoeg politie..", "error")
        end
    end
end)

RegisterNetEvent('rs-ifruitstore:client:setSpotState')
AddEventHandler('rs-ifruitstore:client:setSpotState', function(stateType, state, spot)
    if stateType == "isBusy" then
        Config.Locations["takeables"][spot].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["takeables"][spot].isDone = state
    end
end)

RegisterNetEvent('rs-ifruitstore:client:executeEvents')
AddEventHandler('rs-ifruitstore:client:executeEvents', function()
    TriggerServerEvent("rs-ifruitstore:server:SafeReward")
    TriggerServerEvent('rs-ifruitstore:server:itemReward')
end)

RegisterNetEvent('rs-ifruitstore:client:SetSafeStatus')
AddEventHandler('rs-ifruitstore:client:SetSafeStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["safe"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["safe"].isDone = state
    end
end)

RegisterNetEvent('rs-ifruitstore:client:SetThermiteStatus')
AddEventHandler('rs-ifruitstore:client:SetThermiteStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["thermite"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["thermite"].isDone = state
    end
end)

RegisterNetEvent('rs-ifruitstore:client:PoliceAlertMessage')
AddEventHandler('rs-ifruitstore:client:PoliceAlertMessage', function(msg, coords, blip)
    if blip then
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        TriggerEvent("chatMessage", "112-MELDING", "error", msg)
        local transG = 100
        local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
        SetBlipSprite(blip, 9)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, transG)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("112 - Verdachte situatie iFruit winkel")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    else
        if not robberyAlert then
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            TriggerEvent("chatMessage", "112-MELDING", "error", msg)
            robberyAlert = true
        end
    end
end)

RegisterNUICallback('thermiteclick', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('thermitefailed', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    TriggerServerEvent("rs-ifruitstore:server:SetThermiteStatus", "isBusy", false)
    TriggerServerEvent("RSCore:Server:RemoveItem", "thermite", 1)
    TriggerEvent('inventory:client:ItemBox', RSCore.Shared.Items["thermite"], "remove")
end)

RegisterNUICallback('thermitesuccess', function()
    RSCore.Functions.Notify("De zekeringen zijn kapot", "success")
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z, true) < 1.0 then
        TriggerServerEvent("rs-ifruitstore:server:SetThermiteStatus", "isDone", true)
        TriggerServerEvent("rs-ifruitstore:server:SetThermiteStatus", "isBusy", false)
    end
end)

RegisterNUICallback('closethermite', function()
    SetNuiFocus(false, false)
end)

function DrawText3Ds(x, y, z, text)
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

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
    local model = GetEntityModel(GetPlayerPed(-1))
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function takeAnim()
    local ped = GetPlayerPed(-1)
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Citizen.Wait(2500)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end