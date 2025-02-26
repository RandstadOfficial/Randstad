function DoublePressed()
    Tackle()
end

Citizen.CreateThread(function()
    while true do 
        if RSCore ~= nil then
            if not IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetEntitySpeed(GetPlayerPed(-1)) > 2.5 then
                if (IsControlJustReleased(0, 38)) then
                    local pressedAgain = false
                    local timer = GetGameTimer()
                    while true do
                        Citizen.Wait(0)
                        if (IsControlJustPressed(0, 38)) then
                            pressedAgain = true
                            break
                        end
                        if (GetGameTimer() - timer >= 100) then
                            break
                        end
                    end
                    if (pressedAgain) then
                        DoublePressed()
                    end
                end
            else
                Citizen.Wait(250)
            end
        end

        Citizen.Wait(1)
    end
end)

RegisterNetEvent('tackle:client:GetTackled')
AddEventHandler('tackle:client:GetTackled', function()
	SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 6000), math.random(1000, 6000), 0, 0, 0, 0) 
	TimerEnabled = true
	Citizen.Wait(1500)
	TimerEnabled = false
end)

function Tackle()
    closestPlayer, distance = RSCore.Functions.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if(distance ~= -1 and distance < 2) then
        TriggerServerEvent("tackle:server:TacklePlayer", GetPlayerServerId(closestPlayer))
        TackleAnim()
    end
end

function TackleAnim()
    if not RSCore.Functions.GetPlayerData().metadata["ishandcuffed"] and not IsPedRagdoll(GetPlayerPed(-1)) then
        RequestAnimDict("swimming@first_person@diving")
        while not HasAnimDictLoaded("swimming@first_person@diving") do
            Citizen.Wait(1)
        end
        if IsEntityPlayingAnim(GetPlayerPed(-1), "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
            ClearPedTasksImmediately(GetPlayerPed(-1))
        else
            TaskPlayAnim(GetPlayerPed(-1), "swimming@first_person@diving", "dive_run_fwd_-45_loop" ,3.0, 3.0, -1, 49, 0, false, false, false)
            Citizen.Wait(250)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            SetPedToRagdoll(GetPlayerPed(-1), 150, 150, 0, 0, 0, 0)
        end
    end
end