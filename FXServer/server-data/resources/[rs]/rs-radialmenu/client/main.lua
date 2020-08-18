RSCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if RSCore == nil then
            TriggerEvent("RSCore:GetObject", function(obj) RSCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local inRadialMenu = false

function setupSubItems()
    RSCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] then
            if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
                Config.MenuItems[4].items = {
                    [1] = {
                        id = 'emergencybutton2',
                        title = 'Noodknop',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:SendPoliceEmergencyAlert',
                        shouldClose = true,
                    },
                }
            end
        else
            if Config.JobInteractions[PlayerData.job.name] ~= nil and next(Config.JobInteractions[PlayerData.job.name]) ~= nil then
                Config.MenuItems[4].items = Config.JobInteractions[PlayerData.job.name]
            else 
                Config.MenuItems[4].items = {}
            end
        end
    end)

    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))

    if Vehicle ~= nil or Vehicle ~= 0 then
        local AmountOfSeats = GetVehicleModelNumberOfSeats(GetEntityModel(Vehicle))

        if AmountOfSeats == 2 then
            Config.MenuItems[3].items[3].items = {
                [1] = {
                    id    = -1,
                    title = 'Bestuurder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'rs-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [2] = {
                    id    = 0,
                    title = 'Bijrijder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'rs-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        elseif AmountOfSeats == 3 then
            Config.MenuItems[3].items[3].items = {
                [4] = {
                    id    = -1,
                    title = 'Bestuurder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'rs-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [1] = {
                    id    = 0,
                    title = 'Bijrijder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'rs-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [3] = {
                    id    = 1,
                    title = 'Overige',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'rs-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        elseif AmountOfSeats == 4 then
            Config.MenuItems[3].items[3].items = {
                [4] = {
                    id    = -1,
                    title = 'Bestuurder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'rs-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [1] = {
                    id    = 0,
                    title = 'Bijrijder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'rs-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [3] = {
                    id    = 1,
                    title = 'Achterbank Links',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'rs-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [2] = {
                    id    = 2,
                    title = 'Achterbank Rechts',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'rs-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        end
    end
end

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function openRadial(bool)    
    setupSubItems()

    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        radial = bool,
        items = Config.MenuItems
    })
    inRadialMenu = bool
end

function closeRadial(bool)    
    SetNuiFocus(false, false)
    inRadialMenu = bool
end

function getNearestVeh()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)

        if IsControlJustPressed(0, Keys["F1"]) then
            openRadial(true)
            SetCursorLocation(0.5, 0.5)
        end
    end
end)

RegisterNUICallback('closeRadial', function()
    closeRadial(false)
end)

RegisterNUICallback('selectItem', function(data)
    local itemData = data.itemData

    if itemData.type == 'client' then
        TriggerEvent(itemData.event, itemData)
    elseif itemData.type == 'server' then
        TriggerServerEvent(itemData.event, itemData)
    end
end)

RegisterNetEvent('rs-radialmenu:client:noPlayers')
AddEventHandler('rs-radialmenu:client:noPlayers', function(data)
    RSCore.Functions.Notify('Er zijn geen personen in de buurt', 'error', 2500)
end)

RegisterNetEvent('rs-radialmenu:client:giveidkaart')
AddEventHandler('rs-radialmenu:client:giveidkaart', function(data)
    print('Ik ben een getriggered event :)')
end)

RegisterNetEvent('rs-radialmenu:client:openDoor')
AddEventHandler('rs-radialmenu:client:openDoor', function(data)
    local string = data.id
    local replace = string:gsub("door", "")
    local door = tonumber(replace)
    local ped = GetPlayerPed(-1)
    local closestVehicle = nil

    if IsPedInAnyVehicle(ped, false) then
        closestVehicle = GetVehiclePedIsIn(ped)
    else
        closestVehicle = getNearestVeh()
    end

    if closestVehicle ~= 0 then
        if closestVehicle ~= GetVehiclePedIsIn(ped) then
            local plate = GetVehicleNumberPlateText(closestVehicle)
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('rs-radialmenu:trunk:server:Door', false, plate, door)
                else
                    SetVehicleDoorShut(closestVehicle, door, false)
                end
            else
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('rs-radialmenu:trunk:server:Door', true, plate, door)
                else
                    SetVehicleDoorOpen(closestVehicle, door, false, false)
                end
            end
        else
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                SetVehicleDoorShut(closestVehicle, door, false)
            else
                SetVehicleDoorOpen(closestVehicle, door, false, false)
            end
        end
    else
        RSCore.Functions.Notify('Er is geen voertuig te bekennen...', 'error', 2500)
    end
end)

RegisterNetEvent('rs-radialmenu:client:setExtra')
AddEventHandler('rs-radialmenu:client:setExtra', function(data)
    local string = data.id
    local replace = string:gsub("extra", "")
    local extra = tonumber(replace)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)
    local enginehealth = 1000.0
    local bodydamage = 1000.0

    if veh ~= nil then
        local plate = GetVehicleNumberPlateText(closestVehicle)
    
        if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
            if DoesExtraExist(veh, extra) then 
                if IsVehicleExtraTurnedOn(veh, extra) then
                    enginehealth = GetVehicleEngineHealth(veh)
                    bodydamage = GetVehicleBodyHealth(veh)
                    SetVehicleExtra(veh, extra, 1)
                    SetVehicleEngineHealth(veh, enginehealth)
                    SetVehicleBodyHealth(veh, bodydamage)
                    RSCore.Functions.Notify('Extra ' .. extra .. ' uitgeschakeld', 'error', 2500)
                else
                    enginehealth = GetVehicleEngineHealth(veh)
                    bodydamage = GetVehicleBodyHealth(veh)
                    SetVehicleExtra(veh, extra, 0)
                    SetVehicleEngineHealth(veh, enginehealth)
                    SetVehicleBodyHealth(veh, bodydamage)
                    RSCore.Functions.Notify('Extra ' .. extra .. ' geactiveerd', 'success', 2500)
                end    
            else
                RSCore.Functions.Notify('Extra ' .. extra .. ' is niet aanwezig op dit voertuig', 'error', 2500)
            end
        else
            RSCore.Functions.Notify('Je bent geen bestuurder van een voertuig!', 'error', 2500)
        end
    end
end)

RegisterNetEvent('rs-radialmenu:trunk:client:Door')
AddEventHandler('rs-radialmenu:trunk:client:Door', function(plate, door, open)
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))

    if veh ~= 0 then
        local pl = GetVehicleNumberPlateText(veh)

        if pl == plate then
            if open then
                SetVehicleDoorOpen(veh, door, false, false)
            else
                SetVehicleDoorShut(veh, door, false)
            end
        end
    end
end)

local Seats = {
    ["-1"] = "Bestuurder's stoel",
    ["0"] = "Bijrijder's stoel",
    ["1"] = "Achterbank Links",
    ["2"] = "Achterbank Rechts",
}


RegisterNetEvent('FlipVehicle')
AddEventHandler('FlipVehicle', function()
    local closestVehicle = getNearestVeh()
    if closestVehicle ~= 0 then 
        RSCore.Functions.Progressbar("vehicle_flip", "Voertuig flippen..", 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "missheistfbi3b_ig7",
            anim = "lift_fibagent_loop",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "missheistfbi3b_ig7", "lift_fibagent_loop", 1.0)
            local playerped = PlayerPedId()
            local coordFrom = GetEntityCoords(playerped, 1)
            local coordTo = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
            local targetVehicle = getVehicleInDirection(coordFrom, coordTo)
            SetVehicleOnGroundProperly(targetVehicle)
            --print(targetVehicle)
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "missheistfbi3b_ig7", "lift_fibagent_loop", 1.0)
            RSCore.Functions.Notify('Flippen geannuleerd!', 'error')
        end)
    else
        RSCore.Functions.Notify('Er is geen voertuig te bekennen...', 'error', 2500)
    end
end)

RegisterNetEvent('rs-radialmenu:client:ChangeSeat')
AddEventHandler('rs-radialmenu:client:ChangeSeat', function(data)
    local Veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    local IsSeatFree = IsVehicleSeatFree(Veh, data.id)
    local speed = GetEntitySpeed(Veh)
    --local HasHarnass = exports['rs-smallresources']:HasHarness()
    if not HasHarnass then
        local kmh = (speed * 3.6);  

        if IsSeatFree then
            if kmh <= 100.0 then
                SetPedIntoVehicle(GetPlayerPed(-1), Veh, data.id)
                RSCore.Functions.Notify('Je zit nu op de '..data.title..'!')
            else
                RSCore.Functions.Notify('Het voertuig gaat te snel..')
            end
        else
            RSCore.Functions.Notify('Deze stoel is bezet..')
        end
    else
        RSCore.Functions.Notify('Je hebt een race harnas om, je kunt niet switchen..', 'error')
    end
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