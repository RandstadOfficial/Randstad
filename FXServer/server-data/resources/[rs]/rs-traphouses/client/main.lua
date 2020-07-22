RSCore = nil
isLoggedIn = false
PlayerData = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if RSCore == nil then
            TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

local ClosestTraphouse = nil
local InsideTraphouse = false
local CurrentTraphouse = nil
local TraphouseObj = {}
local POIOffsets = nil
local IsKeyHolder = false
local IsHouseOwner = false
local InTraphouseRange = false
local CodeNPC = nil
local IsRobbingNPC = false


-- Code

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            SetClosestTraphouse()
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    if RSCore.Functions.GetPlayerData() ~= nil then
        isLoggedIn = true
        PlayerData = RSCore.Functions.GetPlayerData()
        RSCore.Functions.TriggerCallback('rs-traphouses:server:GetTraphousesData', function(trappies)
            Config.TrapHouses = trappies
        end)
    end
end)

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = RSCore.Functions.GetPlayerData()
    RSCore.Functions.TriggerCallback('rs-traphouses:server:GetTraphousesData', function(trappies)
        Config.TrapHouses = trappies
    end)
end)

function SetClosestTraphouse()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    for id, traphouse in pairs(Config.TrapHouses) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, Config.TrapHouses[id].coords.enter.x, Config.TrapHouses[id].coords.enter.y, Config.TrapHouses[id].coords.enter.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, Config.TrapHouses[id].coords.enter.x, Config.TrapHouses[id].coords.enter.y, Config.TrapHouses[id].coords.enter.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, Config.TrapHouses[id].coords.enter.x, Config.TrapHouses[id].coords.enter.y, Config.TrapHouses[id].coords.enter.z, true)
            current = id
        end
    end
    ClosestTraphouse = current
    IsKeyHolder = HasKey(PlayerData.citizenid)
    IsHouseOwner = IsOwner(PlayerData.citizenid)
end

function HasKey(CitizenId)
    local haskey = false
    if ClosestTraphouse ~= nil then
        if Config.TrapHouses[ClosestTraphouse].keyholders ~= nil and next(Config.TrapHouses[ClosestTraphouse].keyholders) ~= nil then
            for _, data in pairs(Config.TrapHouses[ClosestTraphouse].keyholders) do
                if data.citizenid == CitizenId then
                    haskey = true
                end
            end
        end
    end
    return haskey
end

function IsOwner(CitizenId)
    local retval = false
    if ClosestTraphouse ~= nil then
        if Config.TrapHouses[ClosestTraphouse].keyholders ~= nil and next(Config.TrapHouses[ClosestTraphouse].keyholders) ~= nil then
            for _, data in pairs(Config.TrapHouses[ClosestTraphouse].keyholders) do
                if data.citizenid == CitizenId then
                    if data.owner then
                        retval = true
                    else
                        retval = false
                    end
                end
            end
        end
    end
    return retval
end

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

RegisterNetEvent('rs-traphouses:client:EnterTraphouse')
AddEventHandler('rs-traphouses:client:EnterTraphouse', function(code)
    if ClosestTraphouse ~= nil then
        if InTraphouseRange then
            local data = Config.TrapHouses[ClosestTraphouse]
            if not IsKeyHolder then
                print("Geen sleutel eigenaar")
                SendNUIMessage({
                    action = "open"
                })
                SetNuiFocus(true, true)
            else
                print("Wel sleutel eigenaar")
                EnterTraphouse(data)
            end
        end
    end
end)

RegisterNUICallback('PinpadClose', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ErrorMessage', function(data)
    RSCore.Functions.Notify(data.message, 'error')
end)

RegisterNUICallback('EnterPincode', function(d)
    local data = Config.TrapHouses[ClosestTraphouse]
    if tonumber(d.pin) == data.pincode then
        print("Command triggerd")
        EnterTraphouse(data)
    else
        RSCore.Functions.Notify('Deze code is incorrect..', 'error')
    end
end)

local CanRob = true

function RobTimeout(timeout)
    SetTimeout(timeout, function()
        CanRob = true
    end)
end

local RobbingTime = 3

function IsInVehicle()
    local ply = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(ply) then
      return true
    else
      return false
    end
  end

Citizen.CreateThread(function()
    while true do
        local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))

        if targetPed ~= 0 and not IsPedAPlayer(targetPed) then
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            if ClosestTraphouse ~= nil then
                local data = Config.TrapHouses[ClosestTraphouse]
                local dist = GetDistanceBetweenCoords(pos, data.coords["enter"].x, data.coords["enter"].y, data.coords["enter"].z, true)
                if dist < 100 then
                    if (IsInVehicle()) then
                        return
                    else
                        if aiming then
                            local pcoords = GetEntityCoords(targetPed)
                            local peddist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pcoords.x, pcoords.y, pcoords.z, true)
                            if peddist < 4 then
                                InDistance = true
                                if not IsRobbingNPC and CanRob then
                                    if IsPedInAnyVehicle(targetPed) then
                                        TaskLeaveVehicle(targetPed, GetVehiclePedIsIn(targetPed), 1)
                                    end
                                    Citizen.Wait(500)
                                    InDistance = true
    
                                    local dict = 'random@mugging3'
                                    RequestAnimDict(dict)
                                    while not HasAnimDictLoaded(dict) do
                                        Citizen.Wait(10)
                                    end
                            
                                    SetEveryoneIgnorePlayer(PlayerId(), true)
                                    TaskStandStill(targetPed, RobbingTime * 1000)
                                    FreezeEntityPosition(targetPed, true)
                                    SetBlockingOfNonTemporaryEvents(targetPed, true)
                                    TaskPlayAnim(targetPed, dict, 'handsup_standing_base', 2.0, -2, 15.0, 1, 0, 0, 0, 0)
                                    for i = 1, RobbingTime / 2, 1 do
                                        PlayAmbientSpeech1(targetPed, "GUN_BEG", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                                        Citizen.Wait(2000)
                                    end
                                    FreezeEntityPosition(targetPed, true)
                                    IsRobbingNPC = true
                                    SetTimeout(RobbingTime, function()
                                        IsRobbingNPC = false
                                        RobTimeout(math.random(30000, 60000))
                                        if not IsEntityDead(targetPed) then
                                            if CanRob then
                                                if InDistance then
                                                    SetEveryoneIgnorePlayer(PlayerId(), false)
                                                    SetBlockingOfNonTemporaryEvents(targetPed, false)
                                                    FreezeEntityPosition(targetPed, false)
                                                    ClearPedTasks(targetPed)
                                                    AddShockingEventAtPosition(99, GetEntityCoords(targetPed), 0.5)
                                                    TriggerServerEvent('rs-traphouses:server:RobNpc', ClosestTraphouse)
                                                    CanRob = false
                                                end
                                            end
                                        end
                                    end)
                                end
                            else
                                if InDistance then
                                    InDistance = false
                                end
                            end
                        end
                    end  
                end
            else
                Citizen.Wait(1000)
            end
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do

        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inRange = false

        if ClosestTraphouse ~= nil then
            local data = Config.TrapHouses[ClosestTraphouse]
            if InsideTraphouse then
                local ExitDistance = GetDistanceBetweenCoords(pos, data.coords["enter"].x + POIOffsets.exit.x, data.coords["enter"].y + POIOffsets.exit.y, data.coords["enter"].z - Config.MinZOffset + POIOffsets.exit.z, true)
                if ExitDistance < 20 then
                    inRange = true
                    if ExitDistance < 1 then
                        DrawText3Ds(data.coords["enter"].x + POIOffsets.exit.x, data.coords["enter"].y + POIOffsets.exit.y, data.coords["enter"].z - Config.MinZOffset + POIOffsets.exit.z, '~b~E~w~ - Verlaten')
                        if IsControlJustPressed(0, Keys["E"]) then
                            LeaveTraphouse(data)
                        end
                    end
                end

                local InteractDistance = GetDistanceBetweenCoords(pos, data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z, true)
                if InteractDistance < 20 then
                    inRange = true
                    if InteractDistance < 1 then
                        if not IsKeyHolder then
                            DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z + 0.2, '~b~H~w~ - Inventaris bekijken')
                            DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z, '~b~E~w~ - Traphouse overnemen (~g~€20000~w~)')
                            if IsControlJustPressed(0, Keys["E"]) then
                                TriggerServerEvent('rs-traphouses:server:TakeoverHouse', CurrentTraphouse)
                            end
                            if IsControlJustPressed(0, Keys["H"]) then
                                local TraphouseInventory = {}
                                TraphouseInventory.label = "traphouse_"..CurrentTraphouse
                                TraphouseInventory.items = data.inventory
                                TraphouseInventory.slots = 2
                                TriggerServerEvent("inventory:server:OpenInventory", "traphouse", CurrentTraphouse, TraphouseInventory)
                            end
                        else
                            DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z + 0.2, '~b~H~w~ - Inventaris bekijken')
                            DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z, '~b~E~w~ - Neem contant geld (~g~€'..data.money..'~w~)')
                            if IsHouseOwner then
                                DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z - 0.2, '~b~/geeftrapsleutels~w~ [id] - Om sleutels te geven')
                                DrawText3Ds(data.coords["interaction"].x, data.coords["interaction"].y, data.coords["interaction"].z - 0.4, '~b~G~w~ - Pincode zien')
                                if IsControlJustPressed(0, Keys["G"]) then
                                    RSCore.Functions.Notify('Pincode: '..data.pincode)
                                end
                            end
                            if IsControlJustPressed(0, Keys["H"]) then
                                local TraphouseInventory = {}
                                TraphouseInventory.label = "traphouse_"..CurrentTraphouse
                                TraphouseInventory.items = data.inventory
                                TraphouseInventory.slots = 2
                                TriggerServerEvent("inventory:server:OpenInventory", "traphouse", CurrentTraphouse, TraphouseInventory)
                            end
                            if IsControlJustPressed(0, Keys["E"]) then
                                TriggerServerEvent("rs-traphouses:server:TakeMoney", CurrentTraphouse)
                            end
                        end
                    end
                end
            else
                local EnterDistance = GetDistanceBetweenCoords(pos, data.coords["enter"].x, data.coords["enter"].y, data.coords["enter"].z, true)
                if EnterDistance < 20 then
                    inRange = true
                    if EnterDistance < 1 then
                        InTraphouseRange = true
                    else
                        if InTraphouseRange then
                            InTraphouseRange = false
                        end
                    end
                end
            end
        else
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

function EnterTraphouse(data)
    print("Triggered")
    local coords = { x = data.coords["enter"].x, y = data.coords["enter"].y, z= data.coords["enter"].z - Config.MinZOffset}
    print("Triggered1")

    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    print("Triggered2")

    data = exports['rs-interior']:CreateTrapHouseShell(coords)
    print("Triggered3")

    TraphouseObj = data[1]
    POIOffsets = data[2]
    CurrentTraphouse = ClosestTraphouse
    InsideTraphouse = true
    SetRainFxIntensity(0.0)
    TriggerEvent('rs-weathersync:client:DisableSync')
    print('Entered')
    FreezeEntityPosition(TraphouseObj, true)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(23, 0, 0)
end

function LeaveTraphouse(data)
    local ped = GetPlayerPed(-1)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    exports['rs-interior']:DespawnInterior(TraphouseObj, function()
        TriggerEvent('rs-weathersync:client:EnableSync')
        DoScreenFadeIn(250)
        SetEntityCoords(ped, data.coords["enter"].x, data.coords["enter"].y, data.coords["enter"].z + 0.5)
        SetEntityHeading(ped, data.coords["enter"].h)
        TraphouseObj = nil
        POIOffsets = nil
        CurrentTraphouse = nil
        InsideTraphouse = false
    end)
end

RegisterNetEvent('rs-traphouses:client:TakeoverHouse')
AddEventHandler('rs-traphouses:client:TakeoverHouse', function(TraphouseId)
    local ped = GetPlayerPed(-1)

    RSCore.Functions.Progressbar("takeover_traphouse", "Traphouse aan het overnemen", math.random(180000, 300000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('rs-traphouses:server:AddHouseKeyHolder', PlayerData.citizenid, TraphouseId, true)
    end, function()
        RSCore.Functions.Notify("Overnamen geannuleerd..", "error")
    end)
end)

function HasCitizenIdHasKey(CitizenId, Traphouse)
    local retval = false
    for _, data in pairs(Config.TrapHouses[Traphouse].keyholders) do
        if data.citizenid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end

function AddKeyHolder(CitizenId, Traphouse)
    if #Config.TrapHouses[Traphouse].keyholders <= 6 then
        if not HasCitizenIdHasKey(CitizenId, Traphouse) then
            if #Config.TrapHouses[Traphouse].keyholders == 0 then
                table.insert(Config.TrapHouses[Traphouse].keyholders, {
                    citizenid = CitizenId,
                    owner = true,
                })
            else
                table.insert(Config.TrapHouses[Traphouse].keyholders, {
                    citizenid = CitizenId,
                    owner = false,
                })
            end
            RSCore.Functions.Notify(CitizenId..' is toegevoegd aan de traphouse!')
        else
            RSCore.Functions.Notify(CitizenId..' dit persoon heeft al sleutels!')
        end
    else
        RSCore.Functions.Notify('Je kan max 6 andere toegang geven tot de traphouse!')
    end
    IsKeyHolder = HasKey(CitizenId)
    IsHouseOwner = IsOwner(CitizenId)
end

RegisterNetEvent('rs-traphouses:client:SyncData')
AddEventHandler('rs-traphouses:client:SyncData', function(k, data)
    Config.TrapHouses[k] = data
    IsKeyHolder = HasKey(PlayerData.citizenid)
    IsHouseOwner = IsOwner(PlayerData.citizenid)
end)