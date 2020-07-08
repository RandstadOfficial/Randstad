RSCore = nil

Citizen.CreateThread(function()
	while RSCore == nil do
		TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
		Citizen.Wait(0)
	end
end)

-- Code

local inside = false
local currentHouse = nil
local closestHouse

local inRange

local lockpicking = false

local houseObj = {}
local POIOffsets = nil
local usingAdvanced = false

local requiredItemsShowed = false

local requiredItems = {}

CurrentCops = 0

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
    RSCore.Functions.TriggerCallback('rs-houserobbery:server:GetHouseConfig', function(HouseConfig)
        Config.Houses = HouseConfig
    end)
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

Citizen.CreateThread(function()
    Citizen.Wait(500)
    requiredItems = {
        [1] = {name = RSCore.Shared.Items["lockpick"]["name"], image = RSCore.Shared.Items["lockpick"]["image"]},
        [2] = {name = RSCore.Shared.Items["screwdriverset"]["name"], image = RSCore.Shared.Items["screwdriverset"]["image"]},
    }
    while true do
        inRange = false
        local PlayerPed = GetPlayerPed(-1)
        local PlayerPos = GetEntityCoords(PlayerPed)
        closestHouse = nil

        if RSCore ~= nil then
            local hours = GetClockHours()
            if hours >= Config.MinimumTime or hours <= Config.MaximumTime then
            if not inside then
                for k, v in pairs(Config.Houses) do
                    local dist = GetDistanceBetweenCoords(PlayerPos, Config.Houses[k]["coords"]["x"], Config.Houses[k]["coords"]["y"], Config.Houses[k]["coords"]["z"], true)

                    if dist <= 1.5 then
                        closestHouse = k
                        inRange = true
                        
                        if CurrentCops >= Config.MinimumHouseRobberyPolice then
                            if Config.Houses[k]["opened"] then
                                DrawText3Ds(Config.Houses[k]["coords"]["x"], Config.Houses[k]["coords"]["y"], Config.Houses[k]["coords"]["z"], '~g~E~w~ - Om naar binnen te gaan')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    enterRobberyHouse(k)
                                end
                            else
                                if not requiredItemsShowed then
                                    requiredItemsShowed = true
                                    TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                                end
                            end
                        end
                    end
                end
            end
        end

            if inside then
                Citizen.Wait(1000)
            end

            if not inRange then
                if requiredItemsShowed then
                    requiredItemsShowed = false
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end
                Citizen.Wait(1000)
            end
        end

        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    while true do

        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        if inside then
            if(GetDistanceBetweenCoords(pos, Config.Houses[currentHouse]["coords"]["x"] + POIOffsets.exit.x, Config.Houses[currentHouse]["coords"]["y"] + POIOffsets.exit.y, Config.Houses[currentHouse]["coords"]["z"] - Config.MinZOffset + POIOffsets.exit.z, true) < 1.5)then
                DrawText3Ds(Config.Houses[currentHouse]["coords"]["x"] + POIOffsets.exit.x, Config.Houses[currentHouse]["coords"]["y"] + POIOffsets.exit.y, Config.Houses[currentHouse]["coords"]["z"] - Config.MinZOffset + POIOffsets.exit.z, '~g~E~w~ - Om huis te verlaten')
                if IsControlJustPressed(0, Keys["E"]) then
                    leaveRobberyHouse(currentHouse)
                end
            end

            for k, v in pairs(Config.Houses[currentHouse]["furniture"]) do
                if (GetDistanceBetweenCoords(pos, Config.Houses[currentHouse]["coords"]["x"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["x"], Config.Houses[currentHouse]["coords"]["y"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["y"], Config.Houses[currentHouse]["coords"]["z"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["z"] - Config.MinZOffset, true) < 1) then
                    if not Config.Houses[currentHouse]["furniture"][k]["searched"] then
                        if not Config.Houses[currentHouse]["furniture"][k]["isBusy"] then
                            DrawText3Ds(Config.Houses[currentHouse]["coords"]["x"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["x"], Config.Houses[currentHouse]["coords"]["y"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["y"], Config.Houses[currentHouse]["coords"]["z"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["z"] - Config.MinZOffset, '~g~E~w~ - '..Config.Houses[currentHouse]["furniture"][k]["text"])
                            if not IsLockpicking then
                                if IsControlJustReleased(0, Keys["E"]) then
                                    searchCabin(k)
                                end
                            end
                        else
                            DrawText3Ds(Config.Houses[currentHouse]["coords"]["x"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["x"], Config.Houses[currentHouse]["coords"]["y"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["y"], Config.Houses[currentHouse]["coords"]["z"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["z"] - Config.MinZOffset, 'Bezig met lockpicken..')
                        end
                    else
                        DrawText3Ds(Config.Houses[currentHouse]["coords"]["x"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["x"], Config.Houses[currentHouse]["coords"]["y"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["y"], Config.Houses[currentHouse]["coords"]["z"] + Config.Houses[currentHouse]["furniture"][k]["coords"]["z"] - Config.MinZOffset, 'Kastje is leeg..')
                    end
                end
            end
        end

        if not inside then 
            Citizen.Wait(5000)
        end

        Citizen.Wait(3)
    end
end)

function enterRobberyHouse(house)
    TriggerServerEvent('rs-houserobbery:server:clearAnimsAllPedsInsideRobberyHouses')
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    Citizen.Wait(250)
    local coords = { x = Config.Houses[house]["coords"]["x"], y = Config.Houses[house]["coords"]["y"], z= Config.Houses[house]["coords"]["z"] - Config.MinZOffset}
    if Config.Houses[house]["tier"] == 1 then
        data = exports['rs-interior']:CreateTier1HouseFurnished(coords)
    elseif Config.Houses[house]["tier"] == 2 then
        data = exports['rs-interior']:CreateHotelFurnished(coords)
    elseif Config.Houses[house]["tier"] == 3 then
        data = exports['rs-interior']:CreateTier3HouseFurnished(coords)
    end
    Citizen.Wait(100)
    houseObj = data[1]
    POIOffsets = data[2]
    inside = true
    currentHouse = house
    Citizen.Wait(500)
    SetRainFxIntensity(0.0)
    TriggerEvent('rs-weathersync:client:DisableSync')
    Citizen.Wait(100)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(23, 0, 0)
end

function leaveRobberyHouse(house)
    local ped = GetPlayerPed(-1)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    Citizen.Wait(250)
    DoScreenFadeOut(250)
    Citizen.Wait(500)
    exports['rs-interior']:DespawnInterior(houseObj, function()
        TriggerEvent('rs-weathersync:client:EnableSync')
        Citizen.Wait(250)
        DoScreenFadeIn(250)
        SetEntityCoords(ped, Config.Houses[house]["coords"]["x"], Config.Houses[house]["coords"]["y"], Config.Houses[house]["coords"]["z"] + 0.5)
        SetEntityHeading(ped, Config.Houses[house]["coords"]["h"])
        inside = false
        currentHouse = nil
    end)
end

RegisterNetEvent('rs-houserobbery:client:ResetHouseState')
AddEventHandler('rs-houserobbery:client:ResetHouseState', function(house)
    Config.Houses[house]["opened"] = false
    for k, v in pairs(Config.Houses[house]["furniture"]) do
        v["searched"] = false
    end
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('rs-houserobbery:client:enterHouse')
AddEventHandler('rs-houserobbery:client:enterHouse', function(house)
    enterRobberyHouse(house) 
end)

function openHouseAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(isAdvanced)
    local hours = GetClockHours()
    if hours >= Config.MinimumTime or hours <= Config.MaximumTime then
    usingAdvanced = isAdvanced
    if usingAdvanced then
        if closestHouse ~= nil then
            if CurrentCops >= Config.MinimumHouseRobberyPolice then
                if not Config.Houses[closestHouse]["opened"] then
                    PoliceCall()
                    TriggerEvent('rs-lockpick:client:openLockpick', lockpickFinish)
                    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
                        local pos = GetEntityCoords(GetPlayerPed(-1))
                        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                    end
                else
                    RSCore.Functions.Notify('De deur is al open..', 'error', 3500)
                end
            else
                RSCore.Functions.Notify('Niet genoeg agenten..', 'error', 3500)
            end
        end
    else
        RSCore.Functions.TriggerCallback('RSCore:HasItem', function(result)
            if closestHouse ~= nil then
                if result then
                    if CurrentCops >= Config.MinimumHouseRobberyPolice then
                        if not Config.Houses[closestHouse]["opened"] then
                            PoliceCall()
                            TriggerEvent('rs-lockpick:client:openLockpick', lockpickFinish)
                            if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
                                local pos = GetEntityCoords(GetPlayerPed(-1))
                                TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                            end
                        else
                            RSCore.Functions.Notify('De deur is al open..', 'error', 3500)
                        end
                    else
                        RSCore.Functions.Notify('Niet genoeg agenten..', 'error', 3500)
                    end
                else
                    RSCore.Functions.Notify('Het lijkt erop dat je iets mist...', 'error', 3500)
                end
            end
        end, "screwdriverset")
    end
end
end)

function PoliceCall()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local chance = 75
    if GetClockHours() >= 1 and GetClockHours() <= 6 then
        chance = 25
    end
    if math.random(1, 100) <= chance then
        local closestPed = GetNearbyPed()
        if closestPed ~= nil then
            local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
            local streetLabel = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            if street2 ~= nil and street2 ~= "" then 
                streetLabel = streetLabel .. " " .. street2
            end
            local gender = "Man"
            if RSCore.Functions.GetPlayerData().charinfo.gender == 1 then
                gender = "Vrouw"
            end
            local msg = "Poging inbraak in een huis door een " .. gender .." bij " .. streetLabel
            TriggerServerEvent("police:server:HouseRobberyCall", pos, msg, gender, streetLabel)
        end
    end
end

function GetNearbyPed()
	local retval = nil
	local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
	local closestPed, closestDistance = RSCore.Functions.GetClosestPed(coords, PlayerPeds)
	if not IsEntityDead(closestPed) and closestDistance < 50.0 then
		retval = closestPed
	end
	return retval
end

function lockpickFinish(success)
    if success then
        TriggerServerEvent('rs-houserobbery:server:enterHouse', closestHouse)
        RSCore.Functions.Notify('Het is gelukt!', 'success', 2500)
    else
        if usingAdvanced then
            local itemInfo = RSCore.Shared.Items["advancedlockpick"]
            if math.random(1, 100) < 20 then
                TriggerServerEvent("RSCore:Server:RemoveItem", "advancedlockpick", 1)
                TriggerEvent('inventory:client:ItemBox', itemInfo, "remove")
            end
        else
            local itemInfo = RSCore.Shared.Items["lockpick"]
            if math.random(1, 100) < 40 then
                TriggerServerEvent("RSCore:Server:RemoveItem", "lockpick", 1)
                TriggerEvent('inventory:client:ItemBox', itemInfo, "remove")
            end
        end
        
        RSCore.Functions.Notify('Het is niet gelukt..', 'error', 2500)
    end
end

RegisterNetEvent('rs-houserobbery:client:setHouseState')
AddEventHandler('rs-houserobbery:client:setHouseState', function(house, state)
    Config.Houses[house]["opened"] = state
end)

local openingDoor = false
local SucceededAttempts = 0
local NeededAttempts = 4

function searchCabin(cabin)
    local ped = GetPlayerPed(-1)

    local Skillbar = exports['rs-skillbar']:GetSkillbarObject()
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        local pos = GetEntityCoords(GetPlayerPed(-1))
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    LockpickDoorAnim(lockpickTime)
    TriggerServerEvent('rs-houserobbery:server:SetBusyState', cabin, currentHouse, true)

    FreezeEntityPosition(ped, true)

    IsLockpicking = true

    Skillbar.Start({
        duration = math.random(7500, 15000),
        pos = math.random(10, 30),
        width = math.random(10, 20),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            -- Finish
            openingDoor = false
            ClearPedTasks(GetPlayerPed(-1))
            TriggerServerEvent('rs-houserobbery:server:searchCabin', cabin, currentHouse)
            Config.Houses[currentHouse]["furniture"][cabin]["searched"] = true
            TriggerServerEvent('rs-houserobbery:server:SetBusyState', cabin, currentHouse, false)
            SucceededAttempts = 0
            FreezeEntityPosition(ped, false)
            SetTimeout(500, function()
                IsLockpicking = false
            end)
        else
            -- Repeat
            Skillbar.Repeat({
                duration = math.random(500, 1250),
                pos = math.random(10, 40),
                width = math.random(5, 13),
            })
            SucceededAttempts = SucceededAttempts + 1
        end
    end, function()
        -- Fail
        openingDoor = false
        ClearPedTasks(GetPlayerPed(-1))
        TriggerServerEvent('rs-houserobbery:server:SetBusyState', cabin, currentHouse, false)
        RSCore.Functions.Notify("Proces geannuleerd..", "error")
        SucceededAttempts = 0
        FreezeEntityPosition(ped, false)
        SetTimeout(500, function()
            IsLockpicking = false
        end)
    end)
end

function LockpickDoorAnim(time)
    -- time = time / 1000
    -- loadAnimDict("veh@break_in@0h@p_m_one@")
    -- TaskPlayAnim(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while true do
            if openingDoor then
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            else
                StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                break
            end
            Citizen.Wait(1000)
        end
    end)
end

RegisterNetEvent('rs-houserobbery:client:setCabinState')
AddEventHandler('rs-houserobbery:client:setCabinState', function(house, cabin, state)
    Config.Houses[house]["furniture"][cabin]["searched"] = state
end)

RegisterNetEvent('rs-houserobbery:client:SetBusyState')
AddEventHandler('rs-houserobbery:client:SetBusyState', function(cabin, house, bool)
    Config.Houses[house]["furniture"][cabin]["isBusy"] = bool
end)

RegisterNetEvent('rs-houserobbery:client:ClearPedAnims')
AddEventHandler('rs-houserobbery:client:ClearPedAnims', function()
    print("Animation bug abuse fix inside robbery house triggered") -- If triggered, player sees this. Animation gets canceled because of bug abuse, player is invisible for other player if animation is happening
    if inside then
        local ped = GetPlayerPed(-1)
        ClearPedTasks(ped)
        ClearPedTasksImmediately(ped)
    end
end)

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
