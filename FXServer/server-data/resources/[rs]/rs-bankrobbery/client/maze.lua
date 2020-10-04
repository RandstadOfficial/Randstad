local requiredItemsShowed = false
local requiredItemsShowed2 = false


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
Citizen.CreateThread(function()
    Citizen.Wait(2000)
    local requiredItems = {
        [1] = {name = RSCore.Shared.Items["electronickit"]["name"], image = RSCore.Shared.Items["electronickit"]["image"]},
        [2] = {name = RSCore.Shared.Items["trojan_usb"]["name"], image = RSCore.Shared.Items["trojan_usb"]["image"]},
    }

    local requiredItems2 = {
        [1] = {name = RSCore.Shared.Items["explosive"]["name"], image = RSCore.Shared.Items["explosive"]["image"]},
    }
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inRange = false
        if RSCore ~= nil then
            if GetDistanceBetweenCoords(pos, Config.BigBanks["maze"]["coords"]["x"], Config.BigBanks["maze"]["coords"]["y"], Config.BigBanks["maze"]["coords"]["z"]) < 20.0 then
                inRange = true
                if not Config.BigBanks["maze"]["isOpened"] then
                    local dist = GetDistanceBetweenCoords(pos, Config.BigBanks["maze"]["coords"]["x"], Config.BigBanks["maze"]["coords"]["y"], Config.BigBanks["maze"]["coords"]["z"])
                    if dist < 1 then
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    else
                        if requiredItemsShowed then
                            requiredItemsShowed = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
                if Config.BigBanks["maze"]["isOpened"] then
                    for k, v in pairs(Config.BigBanks["maze"]["lockers"]) do
                        local lockerDist = GetDistanceBetweenCoords(pos, Config.BigBanks["maze"]["lockers"][k].x, Config.BigBanks["maze"]["lockers"][k].y, Config.BigBanks["maze"]["lockers"][k].z)
                        if not Config.BigBanks["maze"]["lockers"][k]["isBusy"] then
                            if not Config.BigBanks["maze"]["lockers"][k]["isOpened"] then
                                if lockerDist < 5 then
                                    DrawMarker(2, Config.BigBanks["maze"]["lockers"][k].x, Config.BigBanks["maze"]["lockers"][k].y, Config.BigBanks["maze"]["lockers"][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                    if lockerDist < 0.5 then
                                        DrawText3Ds(Config.BigBanks["maze"]["lockers"][k].x, Config.BigBanks["maze"]["lockers"][k].y, Config.BigBanks["maze"]["lockers"][k].z + 0.3, '[E] Kluis openbreken')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            if CurrentCops >= Config.MinimumMazePolice then
                                                openLocker("maze", k)
                                            else
                                                RSCore.Functions.Notify("Niet genoeg politie.. (5 nodig)", "error")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if Config.BigBanks["maze"]["isOpened"] then
                    for k, v in pairs(Config.BigBanks["maze"]["cabinets"]) do
                        local lockerDist = GetDistanceBetweenCoords(pos, Config.BigBanks["maze"]["cabinets"][k].x, Config.BigBanks["maze"]["cabinets"][k].y, Config.BigBanks["maze"]["cabinets"][k].z)
                        if not Config.BigBanks["maze"]["cabinets"][k]["isBusy"] then
                            if not Config.BigBanks["maze"]["cabinets"][k]["isOpened"] then
                                if lockerDist < 5 then
                                    DrawMarker(2, Config.BigBanks["maze"]["cabinets"][k].x, Config.BigBanks["maze"]["cabinets"][k].y, Config.BigBanks["maze"]["cabinets"][k].z -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                    if lockerDist < 0.5 then
                                        DrawText3Ds(Config.BigBanks["maze"]["cabinets"][k].x, Config.BigBanks["maze"]["cabinets"][k].y, Config.BigBanks["maze"]["cabinets"][k].z -0.2, '[E] Kastje openbreken')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            if CurrentCops >= Config.MinimumMazePolice then
                                                openCabinet("maze", k)
                                            else
                                                RSCore.Functions.Notify("Niet genoeg politie.. (5 nodig)", "error")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if GetDistanceBetweenCoords(pos, Config.BigBanks["maze"]["explosive"]["x"], Config.BigBanks["maze"]["explosive"]["y"], Config.BigBanks["maze"]["explosive"]["z"], true) < 10.0 then
                inRange = true
                if not Config.BigBanks["maze"]["explosive"]["isOpened"] then
                    local dist = GetDistanceBetweenCoords(pos, Config.BigBanks["maze"]["explosive"]["x"], Config.BigBanks["maze"]["explosive"]["y"], Config.BigBanks["maze"]["explosive"]["z"], true)
                    if dist < 1 then
                        currentExplosiveGate = Config.BigBanks["maze"]["explosive"]["doorId"]
                        if not requiredItemsShowed2 then
                            requiredItemsShowed2 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems2, true)
                        end
                    else
                        currentExplosiveGate = 0
                        if requiredItemsShowed2 then
                            requiredItemsShowed2 = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems2, false)
                        end
                    end
                end
            end
            if not inRange then
                Citizen.Wait(2500)
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local dist = GetDistanceBetweenCoords(pos, Config.BigBanks["maze"]["coords"]["x"], Config.BigBanks["maze"]["coords"]["y"], Config.BigBanks["maze"]["coords"]["z"])
    if dist < 1.5 then
        RSCore.Functions.TriggerCallback('rs-bankrobbery:server:isRobberyActive', function(isBusy)
            if not isBusy then
                local dist = GetDistanceBetweenCoords(pos, Config.BigBanks["maze"]["coords"]["x"], Config.BigBanks["maze"]["coords"]["y"], Config.BigBanks["maze"]["coords"]["z"])
                if dist < 1.5 then
                    if CurrentCops >= Config.MinimumMazePolice then
                        if not Config.BigBanks["maze"]["isOpened"] then 
                            RSCore.Functions.TriggerCallback('RSCore:HasItem', function(result)
                                if result then 
                                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                    RSCore.Functions.Progressbar("hack_gate", "Electronic kit aansluiten..", math.random(5000, 10000), false, true, {
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
                                        TriggerEvent("mhacking:show")
                                        TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 15), OnHackMazeDone)
                                        if not copsCalled then
                                            local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                                            local street1 = GetStreetNameFromHashKey(s1)
                                            local street2 = GetStreetNameFromHashKey(s2)
                                            local streetLabel = street1
                                            if street2 ~= nil then 
                                                streetLabel = streetLabel .. " " .. street2
                                            end
                                            if Config.BigBanks["maze"]["alarm"] then
                                                TriggerServerEvent("rs-bankrobbery:server:callCops", "maze", 0, streetLabel, pos)
                                                copsCalled = true
                                            end
                                        end
                                    end, function() -- Cancel
                                        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                        RSCore.Functions.Notify("Geannuleerd..", "error")
                                    end)
                                else
                                    RSCore.Functions.Notify("Je mist een item..", "error")
                                end
                            end, "trojan_usb")
                        else
                            RSCore.Functions.Notify("Het lijkt erop dat de bank al open is..", "error")
                        end
                    else
                        RSCore.Functions.Notify("Niet genoeg politie.. (6 nodig)", "error")
                    end
                end
            else
                RSCore.Functions.Notify("Het beveiligingsslot is actief, het openen van de deur is momenteel niet mogelijk..", "error", 5500)
            end
        end)
    end
end)

function OnHackMazeDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('rs-bankrobbery:server:setBankState', "maze", true)
    else
		TriggerEvent('mhacking:hide')
	end
end

function OpenMazeDoor()
    local object = GetClosestObjectOfType(Config.BigBanks["maze"]["coords"]["x"], Config.BigBanks["maze"]["coords"]["y"], Config.BigBanks["maze"]["coords"]["z"], 20.0, Config.BigBanks["maze"]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.BigBanks["maze"]["heading"].closed

    if object ~= 0 then
        Citizen.CreateThread(function()
            while true do

                if entHeading > Config.BigBanks["maze"]["heading"].open then
                    SetEntityHeading(object, entHeading - 10)
                    entHeading = entHeading - 0.5
                else
                    break
                end

                Citizen.Wait(10)
            end
        end)
    end
end