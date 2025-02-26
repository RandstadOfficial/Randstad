local openingDoor = false

RegisterNetEvent("RSCore:Client:OnPlayerLoaded")
AddEventHandler("RSCore:Client:OnPlayerLoaded", function()
    RSCore.Functions.TriggerCallback('rs-pawnshop:melting:server:GetConfig', function(IsMelting, MeltTime, CanTake)
        Config.IsMelting = IsMelting
        Config.MeltTime = MeltTime
        Config.CanTake = CanTake
        isLoggedIn = true

        if Config.IsMelting then
            Citizen.CreateThread(function()
                while Config.IsMelting do
                    if isLoggedIn then
                        Config.MeltTime = Config.MeltTime - 1
                        if Config.MeltTime <= 0 then
                            Config.CanTake = true
                            Config.IsMelting = false
                        end
                    else
                        break
                    end
                    Citizen.Wait(1000)
                end
            end)
        end
    end)
end)

RegisterNetEvent("RSCore:Client:OnPlayerUnload")
AddEventHandler("RSCore:Client:OnPlayerUnload", function()
    Config.IsMelting = false
    Config.MeltTime = 300
    Config.CanTake = false
    isLoggedIn = false
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local inRange = false
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, true) < 3.0 then
			inRange = true
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, true) < 1.5 then
                if not Config.IsMelting then
                    if Config.CanTake then
                        DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "~g~E~w~ - Pak goudstaven")
                        if IsControlJustReleased(0, Keys["E"]) then
                            RSCore.Functions.TriggerCallback('rs-pawnshop:getGoldBars', function()
                            end)
                        end
                    else
                        DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "~g~E~w~ - Gouden items smelten")
                            if IsControlJustReleased(0, Keys["E"]) then 
                                local waitTime = math.random(10000, 15000)
                                ScrapAnim(1000)
                                RSCore.Functions.Progressbar("drop_golden_stuff", "Items plaatsen..", 1000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                if not Config.IsMelting then
                                    StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                    TriggerServerEvent("rs-pawnshop:server:meltItems")
                                end
                            end)
                        end
                    end
                elseif Config.IsMelting and Config.MeltTime > 0 then
                    DrawText3D(Config.MeltLocation.x, Config.MeltLocation.y, Config.MeltLocation.z, "Bezig met smelten: " .. Config.MeltTime..'s')
                end
			end
		end
		if not inRange then
			Citizen.Wait(2500)
		end
	end
end)
local sellItemsSet = false
local hasGold = false
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local inRange = false
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, true) < 3.0 then
			inRange = true
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, true) < 1.5 then
                if GetClockHours() >= 9 and GetClockHours() <= 18 then
                    if not sellItemsSet then 
						hasGold = HasPlayerGold()
						sellItemsSet = true
                    elseif sellItemsSet and hasGold then
                        DrawText3D(Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, "~g~E~w~ - Verkoop goudstaven")
                        if IsControlJustReleased(0, Keys["E"]) then
                            local lockpickTime = 20000
                            ScrapAnim(lockpickTime)
                            RSCore.Functions.Progressbar("sell_gold", "Goud verkopen..", lockpickTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "veh@break_in@0h@p_m_one@",
                                anim = "low_force_entry_ds",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                openingDoor = false
                                ClearPedTasks(GetPlayerPed(-1))
                                TriggerServerEvent('rs-pawnshop:server:sellGold')
                                RSCore.Functions.Notify("Check ook Traphouse bro, daar verkoop je voor meer..", "primary")
                            end, function() -- Cancel
                                openingDoor = false
                                ClearPedTasks(GetPlayerPed(-1))
                                RSCore.Functions.Notify("Proces geannuleerd..", "error")
                            end)
                        end
                    else
                        DrawText3D(Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, "Je hebt geen goud bij je..")
                    end
                    
                else
                    DrawText3D(Config.SellGold.x, Config.SellGold.y, Config.SellGold.z, "Pawnshop gesloten..")
                end
			end
		end
        if not inRange then
            sellItemsSet = false
			Citizen.Wait(2500)
		end
	end
end)

function ScrapAnim(time)
    local time = time / 1000
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
            time = time - 2
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

RegisterNetEvent('rs-pawnshop:client:executeEvents')
AddEventHandler('rs-pawnshop:client:executeEvents', function()
    TriggerServerEvent("rs-pawnshop:server:getGoldBars")
end)

function HasPlayerGold()
	local retval = false
	RSCore.Functions.TriggerCallback('rs-pawnshop:server:hasGold', function(result)
		retval = result
	end)
    Citizen.Wait(500)
	return retval
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent('rs-pawnshop:client:startMelting')
AddEventHandler('rs-pawnshop:client:startMelting', function()
    if not Config.IsMelting then
        Config.IsMelting = true
        Config.MeltTime = 300
        Citizen.CreateThread(function()
            while Config.IsMelting do
                if isLoggedIn then
                    Config.MeltTime = Config.MeltTime - 1
                    if Config.MeltTime <= 0 then
                        Config.CanTake = true
                        Config.IsMelting = false
                    end
                else
                    break
                end
                Citizen.Wait(1000)
            end
        end)
    end
end)

RegisterNetEvent('rs-pawnshop:client:SetTakeState')
AddEventHandler('rs-pawnshop:client:SetTakeState', function(state)
    Config.CanTake = state
    Config.IsMelting = state
    if not state then
        Config.MeltTime = 300
    end

    RSCore.Functions.TriggerCallback('rs-pawnshop:melting:server:GetConfig', function(IsMelting, MeltTime, CanTake)
        Config.IsMelting = IsMelting
        Config.MeltTime = MeltTime
        Config.CanTake = CanTake
        isLoggedIn = true

        if Config.IsMelting then
            Citizen.CreateThread(function()
                while Config.IsMelting do
                    if isLoggedIn then
                        Config.MeltTime = Config.MeltTime - 1
                        if Config.MeltTime <= 0 then
                            Config.CanTake = true
                            Config.IsMelting = false
                        end
                    else
                        break
                    end
                    Citizen.Wait(1000)
                end
            end)
        end
    end)
end)