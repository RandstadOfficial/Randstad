local stage = 0
local movingForward = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        if not IsPedSittingInAnyVehicle(ped) and IsPedOnFoot(ped) and not IsPedFalling(ped) then
            if IsControlJustReleased(0, Keys["LEFTCTRL"]) then
                if not isPedDoingAnimations() then
                    stage = stage + 1
                    if stage == 2 then
                        -- Crouch stuff
                        ClearPedTasks(GetPlayerPed(-1))
                        RequestAnimSet("move_ped_crouched")
                        while not HasAnimSetLoaded("move_ped_crouched") do
                            Citizen.Wait(0)
                        end

                        SetPedMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)    
                        SetPedWeaponMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)
                        SetPedStrafeClipset(GetPlayerPed(-1), "move_ped_crouched_strafing",1.0)
                    elseif stage == 3 then
                        ClearPedTasks(GetPlayerPed(-1))
                        RequestAnimSet("move_crawl")
                        while not HasAnimSetLoaded("move_crawl") do
                            Citizen.Wait(0)
                        end
                    elseif stage > 3 then
                        stage = 0
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                        ResetAnimSet()
                        SetPedStealthMovement(GetPlayerPed(-1),0,0)
                    end
                end
            end

            if stage == 2 then
                if GetEntitySpeed(GetPlayerPed(-1)) > 1.0 then
                    SetPedWeaponMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)
                    SetPedStrafeClipset(GetPlayerPed(-1), "move_ped_crouched_strafing",1.0)
                elseif GetEntitySpeed(GetPlayerPed(-1)) < 1.0 and (GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4) then
                    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
                    ResetPedStrafeClipset(GetPlayerPed(-1))
                end
            elseif stage == 3 then
                DisableControlAction( 0, 21, true ) -- sprint
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)

                if (IsControlPressed(0, Keys["W"]) and not movingForward) then
                    movingForward = true
                    SetPedMoveAnimsBlendOut(GetPlayerPed(-1))
                    local pronepos = GetEntityCoords(GetPlayerPed(-1))
                    TaskPlayAnimAdvanced(GetPlayerPed(-1), "move_crawl", "onfront_fwd", pronepos.x, pronepos.y, pronepos.z+0.1, 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)), 100.0, 0.4, 1.0, 7, 2.0, 1, 1) 
                    Citizen.Wait(500)
                elseif (not IsControlPressed(0, Keys["W"]) and movingForward) then
                    local pronepos = GetEntityCoords(GetPlayerPed(-1))
                    TaskPlayAnimAdvanced(GetPlayerPed(-1), "move_crawl", "onfront_fwd", pronepos.x, pronepos.y, pronepos.z+0.1, 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)), 100.0, 0.4, 1.0, 6, 2.0, 1, 1)
                    Citizen.Wait(500)
                    movingForward = false
                end

                if IsControlPressed(0, Keys["A"]) then
                    SetEntityHeading(GetPlayerPed(-1),GetEntityHeading(GetPlayerPed(-1)) + 1)
                end     

                if IsControlPressed(0, Keys["D"]) then
                    SetEntityHeading(GetPlayerPed(-1),GetEntityHeading(GetPlayerPed(-1)) - 1)
                end 
            end
        else
            stage = 0
            ped = PlayerPedId()
            Citizen.Wait(1000)
        end
    end
end)

local walkSet = "default"
RegisterNetEvent("crouchprone:client:SetWalkSet")
AddEventHandler("crouchprone:client:SetWalkSet", function(clipset)
    walkSet = clipset
end)

--Not in table because lazy
function isPedDoingAnimations()
    print("Checking for anim")
    local ped = GetPlayerPed(-1)

    if IsPedUsingAnyScenario(ped) then
        print("am doing scenario")
        return true
    end
    if IsEntityPlayingAnim(ped, "mp_car_bomb", "car_bomb_mechanic", 3) then
        print("am doing mechanic anim")
        return true
    end
    if IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle", 3) then
        print("am doing idle anim")
        return true
    end
    if IsEntityPlayingAnim(ped, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle', 3) then
        print("am doing drilling anim")
        return true
    end
    if IsEntityPlayingAnim(ped, "mini@safe_cracking", "dial_turn_anti_fast_1", 3) then
        print("am doing safe cracking anim")
        return true
    end
    if IsEntityPlayingAnim(ped, "anim@gangops@facility@servers@", "hotwire", 3) then
        print("am doing hotwire anim")
        return true
    end
    print("Was not doing anim")
    return false;
end


function ResetAnimSet()
    if walkSet == "default" then
        ResetPedMovementClipset(GetPlayerPed(-1))
        ResetPedWeaponMovementClipset(GetPlayerPed(-1))
        ResetPedStrafeClipset(GetPlayerPed(-1))
    else
        ResetPedMovementClipset(GetPlayerPed(-1))
        ResetPedWeaponMovementClipset(GetPlayerPed(-1))
        ResetPedStrafeClipset(GetPlayerPed(-1))
        Citizen.Wait(100)
        RequestWalking(walkSet)
        SetPedMovementClipset(PlayerPedId(), walkSet, 1)
        RemoveAnimSet(walkSet)
    end
end

function RequestWalking(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do
        Citizen.Wait(1)
    end 
end