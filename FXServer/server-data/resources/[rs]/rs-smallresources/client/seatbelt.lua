local seatbeltOn = false
local harnessOn = false
local harnessHp = 20
harnessData = {}
local SpeedBuffer = {}
local vehVelocity = {x = 0.0, y = 0.0, z = 0.0}
local vehHealth = 0.0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            seatbeltOn = false
            TriggerEvent("seatbelt:client:ToggleSeatbelt", false)
        end
        
        if IsControlJustReleased(0, Keys["G"]) then 
            if not harnessOn then
                if IsPedInAnyVehicle(GetPlayerPed(-1)) and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 8 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 13 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 14 then
                    if seatbeltOn then
                        TriggerServerEvent("InteractSound_SV:PlayOnSource", "carunbuckle", 0.25)
                    else
                        TriggerServerEvent("InteractSound_SV:PlayOnSource", "carbuckle", 0.25)
                    end
                    TriggerEvent("seatbelt:client:ToggleSeatbelt")
                end
            else
                RSCore.Functions.Progressbar("harness_equip", "Race harnas af doen..", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    ToggleHarness(false)
                end)
            end
        end

        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            if harnessOn then
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
            end
        end
    end
end)

local handbrake = 0
RegisterNetEvent('resethandbrake')
AddEventHandler('resethandbrake', function()
    while handbrake > 0 do
        handbrake = handbrake - 1
        Citizen.Wait(30)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local newvehicleBodyHealth = 0
    local newvehicleEngineHealth = 0
    local currentvehicleEngineHealth = 0
    local currentvehicleBodyHealth = 0
    local frameBodyChange = 0
    local frameEngineChange = 0
    local lastFrameVehiclespeed = 0
    local lastFrameVehiclespeed2 = 0
    local thisFrameVehicleSpeed = 0
    local tick = 0
    local damagedone = false
    local modifierDensity = true
    while true do
        Citizen.Wait(5)
        local playerPed = GetPlayerPed(-1)
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
        if currentVehicle ~= nil and currentVehicle ~= false and currentVehicle ~= 0 then
            SetPedHelmet(playerPed, false)
            lastVehicle = GetVehiclePedIsIn(playerPed, false)
            if GetVehicleEngineHealth(currentVehicle) < 0.0 then
                SetVehicleEngineHealth(currentVehicle,0.0)
            end
            if (GetVehicleHandbrake(currentVehicle) or (GetVehicleSteeringAngle(currentVehicle)) > 25.0 or (GetVehicleSteeringAngle(currentVehicle)) < -25.0) then
                if handbrake == 0 then
                    handbrake = 100
                    TriggerEvent("resethandbrake")
                else
                    handbrake = 100
                end
            end

            thisFrameVehicleSpeed = GetEntitySpeed(currentVehicle) * 3.6
            currentvehicleBodyHealth = GetVehicleBodyHealth(currentVehicle)
            if currentvehicleBodyHealth == 1000 and frameBodyChange ~= 0 then
                frameBodyChange = 0
            end
            if frameBodyChange ~= 0 then
                if lastFrameVehiclespeed > 110 and thisFrameVehicleSpeed < (lastFrameVehiclespeed * 0.75) and not damagedone then
                    if frameBodyChange > 18.0 then
                        if not seatbeltOn and not IsThisModelABike(currentVehicle) then
                            if math.random(math.ceil(lastFrameVehiclespeed)) > 60 then
                                if not harnessOn then
                                    EjectFromVehicle()
                                else
                                    harnessHp = harnessHp - 1
                                    TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                end
                            end
                        elseif (seatbeltOn or harnessOn) and not IsThisModelABike(currentVehicle) then
                            if lastFrameVehiclespeed > 150 then
                                if math.random(math.ceil(lastFrameVehiclespeed)) > 150 then
                                    if not harnessOn then
                                        EjectFromVehicle()
                                    else
                                        harnessHp = harnessHp - 1
                                        TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                    end                     
                                end 
                            end
                        end
                    else
                        if not seatbeltOn and not IsThisModelABike(currentVehicle) then
                            if math.random(math.ceil(lastFrameVehiclespeed)) > 60 then
                                if not harnessOn then
                                    EjectFromVehicle()
                                else
                                    harnessHp = harnessHp - 1
                                    TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                end                        
                            end
                        elseif (seatbeltOn or harnessOn) and not IsThisModelABike(currentVehicle) then
                            if lastFrameVehiclespeed > 120 then
                                if math.random(math.ceil(lastFrameVehiclespeed)) > 200 then
                                    if not harnessOn then
                                        EjectFromVehicle()
                                    else
                                        harnessHp = harnessHp - 1
                                        TriggerServerEvent('seatbelt:DoHarnessDamage', harnessHp, harnessData)
                                    end                     
                                end
                            end
                        end
                    end
                    damagedone = true
                    SetVehicleEngineHealth(currentVehicle, 0)
                    SetVehicleEngineOn(currentVehicle, false, true, true)
                end
                if currentvehicleBodyHealth < 350.0 and not damagedone then
                    damagedone = true
                    SetVehicleBodyHealth(targetVehicle, 945.0)
                    SetVehicleEngineHealth(currentVehicle, 0)
                    SetVehicleEngineOn(currentVehicle, false, true, true)
                    Citizen.Wait(1000)
                end
            end
            if lastFrameVehiclespeed < 100 then
                Wait(100)
                tick = 0
            end
            frameBodyChange = newvehicleBodyHealth - currentvehicleBodyHealth
            if tick > 0 then 
                tick = tick - 1
                if tick == 1 then
                    lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 3.6
                end
            else
                if damagedone then
                    damagedone = false
                    frameBodyChange = 0
                    lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 3.6
                end
                lastFrameVehiclespeed2 = GetEntitySpeed(currentVehicle) * 3.6
                if lastFrameVehiclespeed2 > lastFrameVehiclespeed then
                    lastFrameVehiclespeed = GetEntitySpeed(currentVehicle) * 3.6
                end
                if lastFrameVehiclespeed2 < lastFrameVehiclespeed then
                    tick = 25
                end

            end
            vels = GetEntityVelocity(currentVehicle)
            if tick < 0 then 
                tick = 0
            end     
            newvehicleBodyHealth = GetVehicleBodyHealth(currentVehicle)
            if not modifierDensity then
                modifierDensity = true
            end
            veloc = GetEntityVelocity(currentVehicle)
        else
            if lastVehicle ~= nil then
                SetPedHelmet(playerPed, true)
                Citizen.Wait(200)
                newvehicleBodyHealth = GetVehicleBodyHealth(lastVehicle)
                if not damagedone and newvehicleBodyHealth < currentvehicleBodyHealth then
                    damagedone = true
                    SetVehicleEngineHealth(lastVehicle, 0)
                    SetVehicleEngineOn(lastVehicle, false, true, true)
                    Citizen.Wait(1000)
                end
                lastVehicle = nil
            end
            lastFrameVehiclespeed2 = 0
            lastFrameVehiclespeed = 0
            newvehicleBodyHealth = 0
            currentvehicleBodyHealth = 0
            frameBodyChange = 0
            Citizen.Wait(2000)
        end
    end
end)

function GetFwd(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 5.73, y = math.sin(hr) * 5.73 }
end

function EjectFromVehicle()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
    local coords = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, 1.0)
    SetEntityCoords(GetPlayerPed(-1),coords)
    Citizen.Wait(1)
    SetPedToRagdoll(GetPlayerPed(-1), 5511, 5511, 0, 0, 0, 0)
    SetEntityVelocity(GetPlayerPed(-1), veloc.x*4,veloc.y*4,veloc.z*4)
    local ejectspeed = math.ceil(GetEntitySpeed(GetPlayerPed(-1)) * 8)
    SetEntityHealth( GetPlayerPed(-1), (GetEntityHealth(GetPlayerPed(-1)) - ejectspeed) )
end

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        seatbeltOn = not seatbeltOn
    else
        seatbeltOn = toggle
    end
end)

function ToggleHarness(toggle)
    harnessOn = toggle
    seatbeltOn = false
    if not toggle then
        harnessHp = 10
        TriggerEvent("seatbelt:client:ToggleSeatbelt", true)
    else
        TriggerEvent("seatbelt:client:ToggleSeatbelt", false)
    end
    TriggerEvent('rs-hud:client:ToggleHarness', toggle)
end

RegisterNetEvent('seatbelt:client:UseHarness')
AddEventHandler('seatbelt:client:UseHarness', function(ItemData)
    local ped = GetPlayerPed(-1)
    local inveh = IsPedInAnyVehicle(GetPlayerPed(-1))
    if inveh and not IsThisModelABike(GetEntityModel(GetVehiclePedIsIn(ped))) then
        if not harnessOn then
            RSCore.Functions.Progressbar("harness_equip", "Race harnas om doen..", 5000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                ToggleHarness(true)
                TriggerServerEvent('equip:harness', ItemData)
            end)
            harnessHp = ItemData.info.uses
            harnessData = ItemData
        end
    else
        RSCore.Functions.Notify('Je zit niet in een auto.', 'error', 3500)
    end
end)

function HasHarness()
    return harnessOn
end