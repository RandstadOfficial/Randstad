local RobbedPlayers = {}

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isEscorted then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
            EnableControlAction(0, Keys['T'], true)
            EnableControlAction(0, Keys['E'], true)
            EnableControlAction(0, Keys['ESC'], true)
        end

        if isHandcuffed then
            DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, Keys['R'], true) -- Reload
			DisableControlAction(0, Keys['SPACE'], true) -- Jump
			DisableControlAction(0, Keys['Q'], true) -- Cover
			DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(0, Keys['F'], true) -- Also 'enter'?

			DisableControlAction(0, Keys['F1'], true) -- Disable phone
			DisableControlAction(0, Keys['F2'], true) -- Inventory
			DisableControlAction(0, Keys['F3'], true) -- Animations
			DisableControlAction(0, Keys['F6'], true) -- Job

			DisableControlAction(0, Keys['C'], true) -- Disable looking behind
			DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

            if (not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arrest_paired", "crook_p2_back_right", 3)) and not RSCore.Functions.GetPlayerData().metadata["isdead"] then
                loadAnimDict("mp_arresting")
                TaskPlayAnim(GetPlayerPed(-1), "mp_arresting", "idle", 8.0, -8, -1, cuffType, 0, 0, 0, 0)
            end
        end
        if not isHandcuffed and not isEscorted then
            Citizen.Wait(2000)
        end
    end
end)

RegisterNetEvent('police:client:SetOutVehicle')
AddEventHandler('police:client:SetOutVehicle', function()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        TaskLeaveVehicle(GetPlayerPed(-1), vehicle, 16)
    end
end)

RegisterNetEvent('police:client:PutInVehicle')
AddEventHandler('police:client:PutInVehicle', function()
    if isHandcuffed or isEscorted then
        local vehicle = RSCore.Functions.GetClosestVehicle()
        if DoesEntityExist(vehicle) then
			for i = GetVehicleMaxNumberOfPassengers(vehicle), 1, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    isEscorted = false
                    TriggerEvent('hospital:client:isEscorted', isEscorted)
                    ClearPedTasks(GetPlayerPed(-1))
                    DetachEntity(GetPlayerPed(-1), true, false)

                    Citizen.Wait(100)
                    SetPedIntoVehicle(GetPlayerPed(-1), vehicle, i)
                    return
                end
            end
		end
    end
end)

RegisterNetEvent('police:client:SearchPlayer')
AddEventHandler('police:client:SearchPlayer', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
        RSCore.Functions.TriggerCallback('police:SearchPlayer', function()
        end, playerId)
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('police:client:SeizeCash')
AddEventHandler('police:client:SeizeCash', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        RSCore.Functions.TriggerCallback('police:SeizeCash', function()
        end, playerId)
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('police:client:SeizeDriverLicense')
AddEventHandler('police:client:SeizeDriverLicense', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        RSCore.Functions.TriggerCallback('police:SeizeDriverLicense', function()
        end, playerId)
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('police:client:ShareRobbedPlayers')
AddEventHandler('police:client:ShareRobbedPlayers', function(data)
    RobbedPlayers = data
end)

RegisterNetEvent('police:client:RobPlayer')
AddEventHandler('police:client:RobPlayer', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerPed = GetPlayerPed(player)
        local playerId = GetPlayerServerId(player)
        if IsEntityPlayingAnim(playerPed, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) or IsTargetDead(playerId) then
            if RobbedPlayers ~= nil and RobbedPlayers[playerId] == true then
                RSCore.Functions.Notify("Deze persoon is al berooft!", "error")
            else
                TriggerServerEvent('police:server:ShareRobbedPlayers', playerId, true)
                RSCore.Functions.Progressbar("robbing_player", "Spullen stelen..", math.random(5000, 7000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "random@shop_robbery",
                    anim = "robbery_action_b",
                    flags = 16,
                }, {}, {}, function() -- Done
                    local plyCoords = GetEntityCoords(playerPed)
                    local pos = GetEntityCoords(GetPlayerPed(-1))
                    local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
                    if dist < 2.5 then
                        StopAnimTask(GetPlayerPed(-1), "random@shop_robbery", "robbery_action_b", 1.0)
                        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", playerId)
                        RSCore.Functions.TriggerCallback('police:RobPlayer', function()
                        end, playerId)
                    else
                        RSCore.Functions.Notify("Niemand in de buurt!", "error")
                    end
                end, function() -- Cancel
                    StopAnimTask(GetPlayerPed(-1), "random@shop_robbery", "robbery_action_b", 1.0)
                    RSCore.Functions.Notify("Geannuleerd..", "error")
                end)
            end
        end
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('police:client:JailCommand')
AddEventHandler('police:client:JailCommand', function(playerId, time)
    RSCore.Functions.TriggerCallback('police:JailPlayer', function()
    end, playerId, tonumber(time))
end)

RegisterNetEvent('police:client:UnJailCommand')
AddEventHandler('police:client:UnJailCommand', function(playerId, time)
    TriggerServerEvent("police:server:UnJailPlayer", playerId, tonumber(time))
end)

RegisterNetEvent('police:client:BillCommand')
AddEventHandler('police:client:BillCommand', function(playerId, price)
    TriggerServerEvent("police:server:BillPlayer", playerId, tonumber(price))
end)

RegisterNetEvent('police:client:JailPlayer')
AddEventHandler('police:client:JailPlayer', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 20)
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Citizen.Wait(7)
        end
        local time = GetOnscreenKeyboardResult()
        if tonumber(time) > 0 then
            RSCore.Functions.TriggerCallback('police:JailPlayer', function()
            end, playerId, tonumber(time))
        else
            RSCore.Functions.Notify("Tijd moet hoger zijn dan 0..", "error")
        end
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('police:client:BillPlayer')
AddEventHandler('police:client:BillPlayer', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 20)
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Citizen.Wait(7)
        end
        local price = GetOnscreenKeyboardResult()
        if tonumber(price) > 0 then
            TriggerServerEvent("police:server:BillPlayer", playerId, tonumber(price))
        else
            RSCore.Functions.Notify("Prijs moet hoger zijn dan 0..", "error")
        end
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('police:client:PutPlayerInVehicle')
AddEventHandler('police:client:PutPlayerInVehicle', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then
            TriggerServerEvent("police:server:PutPlayerInVehicle", playerId)
        end
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('police:client:SetPlayerOutVehicle')
AddEventHandler('police:client:SetPlayerOutVehicle', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then
            TriggerServerEvent("police:server:SetPlayerOutVehicle", playerId)
        end
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('police:client:EscortPlayer')
AddEventHandler('police:client:EscortPlayer', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not isHandcuffed and not isEscorted then
            TriggerServerEvent("police:server:EscortPlayer", playerId)
        end
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

function IsHandcuffed()
    return isHandcuffed
end

RegisterNetEvent('police:client:KidnapPlayer')
AddEventHandler('police:client:KidnapPlayer', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if not IsPedInAnyVehicle(GetPlayerPed(player)) then
            if not isHandcuffed and not isEscorted then
                TriggerServerEvent("police:server:KidnapPlayer", playerId)
            end
        end
    else
        RSCore.Functions.Notify("Niemand in de buurt!", "error")
    end
end)

RegisterNetEvent('police:client:CuffPlayerSoft')
AddEventHandler('police:client:CuffPlayerSoft', function()
    if not IsPedRagdoll(GetPlayerPed(-1)) then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local cuffer = GetPlayerName(source) .. " " .. "("..GetPlayerServerId(source)..")"
            local playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(GetPlayerPed(GetPlayerPed(-1))) then
                TriggerServerEvent("police:server:CuffPlayer", playerId, true)
                HandCuffAnimation()
                TriggerServerEvent("rs-log:server:CreateLog", "cuffing", GetPlayerName(player) .. " ("..GetPlayerServerId(player)..") is geboeid", "red", "**".. cuffer .. "** heeft ".. GetPlayerName(player) .." geboeid")
            else
                RSCore.Functions.Notify("Je kunt niet boeien in een voertuig", "error")
            end
        else
            RSCore.Functions.Notify("Niemand in de buurt!", "error")
        end
    else
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('police:client:CuffPlayer')
AddEventHandler('police:client:CuffPlayer', function()
    if not IsPedRagdoll(GetPlayerPed(-1)) then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            RSCore.Functions.TriggerCallback('RSCore:HasItem', function(result)
                if result then 
                    local playerId = GetPlayerServerId(player)
                    if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(GetPlayerPed(GetPlayerPed(-1))) then
                        TriggerServerEvent("police:server:CuffPlayer", playerId, false)
                        HandCuffAnimation()
                    else
                        RSCore.Functions.Notify("Je kunt niet boeien in een voertuig", "error")
                    end
                else
                    RSCore.Functions.Notify("Je hebt geen handboeien bij je", "error")
                end
            end, "handcuffs")
        else
            RSCore.Functions.Notify("Niemand in de buurt!", "error")
        end
    else
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('police:client:executeEvents')
AddEventHandler('police:client:executeEvents', function()
    TriggerServerEvent("police:server:SearchPlayer", playerId)
    TriggerServerEvent("police:server:SeizeCash", playerId)
    TriggerServerEvent("police:server:SeizeDriverLicense", playerId)
    TriggerServerEvent("police:server:RobPlayer", playerId)
    TriggerServerEvent("police:server:JailPlayer", playerId, tonumber(time))
end)

RegisterNetEvent('police:client:GetEscorted')
AddEventHandler('police:client:GetEscorted', function(playerId)
    RSCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] or isHandcuffed or PlayerData.metadata["inlaststand"] then
            if not isEscorted then
                isEscorted = true
                draggerId = playerId
                local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
                local heading = GetEntityHeading(dragger)
                SetEntityCoords(GetPlayerPed(-1), GetOffsetFromEntityInWorldCoords(dragger, 0.0, 0.45, 0.0))
                AttachEntityToEntity(GetPlayerPed(-1), dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            else
                isEscorted = false
                DetachEntity(GetPlayerPed(-1), true, false)
            end
            TriggerEvent('hospital:client:isEscorted', isEscorted)
        end
    end)
end)

RegisterNetEvent('police:client:DeEscort')
AddEventHandler('police:client:DeEscort', function()
    isEscorted = false
    TriggerEvent('hospital:client:isEscorted', isEscorted)
    DetachEntity(GetPlayerPed(-1), true, false)
end)

RegisterNetEvent('police:client:GetKidnappedTarget')
AddEventHandler('police:client:GetKidnappedTarget', function(playerId)
    RSCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] or PlayerData.metadata["inlaststand"] or isHandcuffed then
            if not isEscorted then
                isEscorted = true
                draggerId = playerId
                local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
                local heading = GetEntityHeading(dragger)
                RequestAnimDict("nm")

                while not HasAnimDictLoaded("nm") do
                    Citizen.Wait(10)
                end
                -- AttachEntityToEntity(GetPlayerPed(-1), dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                AttachEntityToEntity(GetPlayerPed(-1), dragger, 0, 0.27, 0.15, 0.63, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
                TaskPlayAnim(GetPlayerPed(-1), "nm", "firemans_carry", 8.0, -8.0, 100000, 33, 0, false, false, false)
            else
                isEscorted = false
                DetachEntity(GetPlayerPed(-1), true, false)
                ClearPedTasksImmediately(GetPlayerPed(-1))
            end
            TriggerEvent('hospital:client:isEscorted', isEscorted)
        end
    end)
end)

local isEscorting = false

RegisterNetEvent('police:client:GetKidnappedDragger')
AddEventHandler('police:client:GetKidnappedDragger', function(playerId)
    RSCore.Functions.GetPlayerData(function(PlayerData)
        if not isEscorting then
            draggerId = playerId
            local dragger = GetPlayerPed(-1)
            RequestAnimDict("missfinale_c2mcs_1")

            while not HasAnimDictLoaded("missfinale_c2mcs_1") do
                Citizen.Wait(10)
            end
            TaskPlayAnim(dragger, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 8.0, -8.0, 100000, 49, 0, false, false, false)
            isEscorting = true
        else
            local dragger = GetPlayerPed(-1)
            ClearPedSecondaryTask(dragger)
            ClearPedTasksImmediately(dragger)
            isEscorting = false
        end
        TriggerEvent('hospital:client:SetEscortingState', isEscorting)
        TriggerEvent('rs-kidnapping:client:SetKidnapping', isEscorting)
    end)
end)

RegisterNetEvent('police:client:GetCuffed')
AddEventHandler('police:client:GetCuffed', function(playerId, isSoftcuff)
    if not isHandcuffed then
        isHandcuffed = true
        TriggerServerEvent("police:server:SetHandcuffStatus", true)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        if not isSoftcuff then
            cuffType = 16
            GetCuffedAnimation(playerId)
            RSCore.Functions.Notify("Je bent geboeid!")
        else
            cuffType = 49
            GetCuffedAnimation(playerId)
            RSCore.Functions.Notify("Je bent geboeid, maar je kan lopen")
        end
    else
        isHandcuffed = false
        isEscorted = false
        TriggerEvent('hospital:client:isEscorted', isEscorted)
        DetachEntity(GetPlayerPed(-1), true, false)
        TriggerServerEvent("police:server:SetHandcuffStatus", false)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        RSCore.Functions.Notify("Je bent ontboeid!")
    end
end)

Citizen.CreateThread(function()
    while true do
        TriggerEvent("tokovoip_script:ToggleRadioTalk", isHandcuffed)
        Citizen.Wait(2000)
    end
end)

function IsTargetDead(playerId)
    local retval = false
    RSCore.Functions.TriggerCallback('police:server:isPlayerDead', function(result)
        retval = result
    end, playerId)
    Citizen.Wait(100)
    return retval
end

function HandCuffAnimation()
    loadAnimDict("mp_arrest_paired")
	Citizen.Wait(100)
    TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
	Citizen.Wait(3500)
    TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end

function GetCuffedAnimation(playerId)
    local cuffer = GetPlayerPed(GetPlayerFromServerId(playerId))
    local heading = GetEntityHeading(cuffer)
    loadAnimDict("mp_arrest_paired")
    SetEntityCoords(GetPlayerPed(-1), GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
	Citizen.Wait(100)
	SetEntityHeading(GetPlayerPed(-1), heading)
	TaskPlayAnim(GetPlayerPed(-1), "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0)
	Citizen.Wait(2500)
end