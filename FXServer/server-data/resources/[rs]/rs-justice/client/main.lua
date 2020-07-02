RSCore = nil

Citizen.CreateThread(function()
    while RSCore == nil do
        TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
        Citizen.Wait(200)
    end
end)

isLoggedIn = true
local PlayerJob = {}

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = RSCore.Functions.GetPlayerData().job

    if PlayerJob.name == "lawyer" then
        local blip = AddBlipForCoord(Config.Locations["advocaat1"]["voertuigopslag"].coords.x, Config.Locations["advocaat1"]["voertuigopslag"].coords.y, Config.Locations["advocaat1"]["voertuigopslag"].coords.z)
        SetBlipSprite(blip, 225)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["advocaat1"]["voertuigopslag"].label)
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('RSCore:Client:OnPlayerUnload')
AddEventHandler('RSCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('RSCore:Client:OnJobUpdate')
AddEventHandler('RSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo

    if PlayerJob.name == "lawyer" then
        local blip = AddBlipForCoord(Config.Locations["advocaat1"]["voertuigopslag"].coords.x, Config.Locations["advocaat1"]["voertuigopslag"].coords.y, Config.Locations["advocaat1"]["voertuigopslag"].coords.z)
        SetBlipSprite(blip, 225)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["advocaat1"]["voertuigopslag"].label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- vehicle door threads + blip
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.Locations["advocaat1"]["ingangvoor"].coords.x, Config.Locations["advocaat1"]["ingangvoor"].coords.y, Config.Locations["advocaat1"]["ingangvoor"].coords.z)
    SetBlipSprite(blip, 351)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations["advocaat1"].label)
    EndTextCommandSetBlipName(blip)
    while true do 
        Citizen.Wait(1)
        local inRange = false
        if isLoggedIn and RSCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["ingangvoor"].coords.x, Config.Locations["advocaat1"]["ingangvoor"].coords.y, Config.Locations["advocaat1"]["ingangvoor"].coords.z, true) < 1.5 or GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["uitgangvoor"].coords.x, Config.Locations["advocaat1"]["uitgangvoor"].coords.y, Config.Locations["advocaat1"]["uitgangvoor"].coords.z, true) < 1.5 or GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["ingangachter"].coords.x, Config.Locations["advocaat1"]["ingangachter"].coords.y, Config.Locations["advocaat1"]["ingangachter"].coords.z, true) < 1.5 or GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["uitgangachter"].coords.x, Config.Locations["advocaat1"]["uitgangachter"].coords.y, Config.Locations["advocaat1"]["uitgangachter"].coords.z, true) < 1.5 then
                inRange = true
                -- Vooringang naar binnen
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["ingangvoor"].coords.x, Config.Locations["advocaat1"]["ingangvoor"].coords.y, Config.Locations["advocaat1"]["ingangvoor"].coords.z, true) < 1.5) then
                    DrawText3D(Config.Locations["advocaat1"]["ingangvoor"].coords.x, Config.Locations["advocaat1"]["ingangvoor"].coords.y, Config.Locations["advocaat1"]["ingangvoor"].coords.z, "~g~E~w~ - Om naar binnen te gaan")
                    if IsControlJustReleased(0, Config.Keys["E"]) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end
    
                        SetEntityCoords(PlayerPedId(), Config.Locations["advocaat1"]["uitgangvoor"].coords.x, Config.Locations["advocaat1"]["uitgangvoor"].coords.y, Config.Locations["advocaat1"]["uitgangvoor"].coords.z, 0, 0, 0, false)
                        SetEntityHeading(PlayerPedId(), Config.Locations["advocaat1"]["uitgangvoor"].coords.h)
    
                        Citizen.Wait(100)
    
                        DoScreenFadeIn(1000)
                    end
                -- Van binnen naar vooringang
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["uitgangvoor"].coords.x, Config.Locations["advocaat1"]["uitgangvoor"].coords.y, Config.Locations["advocaat1"]["uitgangvoor"].coords.z, true) < 1.5) then
                    DrawText3D(Config.Locations["advocaat1"]["uitgangvoor"].coords.x, Config.Locations["advocaat1"]["uitgangvoor"].coords.y, Config.Locations["advocaat1"]["uitgangvoor"].coords.z, "~g~E~w~ - Om naar buiten te gaan")
                    if IsControlJustReleased(0, Config.Keys["E"]) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end
    
                        SetEntityCoords(PlayerPedId(), Config.Locations["advocaat1"]["ingangvoor"].coords.x, Config.Locations["advocaat1"]["ingangvoor"].coords.y, Config.Locations["advocaat1"]["ingangvoor"].coords.z, 0, 0, 0, false)
                        SetEntityHeading(PlayerPedId(), Config.Locations["advocaat1"]["ingangvoor"].coords.h)
    
                        Citizen.Wait(100)
    
                        DoScreenFadeIn(1000)
                    end
                -- Achteringang naar binnen
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["ingangachter"].coords.x, Config.Locations["advocaat1"]["ingangachter"].coords.y, Config.Locations["advocaat1"]["ingangachter"].coords.z, true) < 1.5) then
                    DrawText3D(Config.Locations["advocaat1"]["ingangachter"].coords.x, Config.Locations["advocaat1"]["ingangachter"].coords.y, Config.Locations["advocaat1"]["ingangachter"].coords.z, "~g~E~w~ - Om naar binnen te gaan")
                    if IsControlJustReleased(0, Config.Keys["E"]) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end

                        SetEntityCoords(PlayerPedId(), Config.Locations["advocaat1"]["uitgangachter"].coords.x, Config.Locations["advocaat1"]["uitgangachter"].coords.y, Config.Locations["advocaat1"]["uitgangachter"].coords.z, 0, 0, 0, false)
                        SetEntityHeading(PlayerPedId(), Config.Locations["advocaat1"]["uitgangachter"].coords.h)

                        Citizen.Wait(100)

                        DoScreenFadeIn(1000)
                    end
                -- Van binnen naar achteringang
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["uitgangachter"].coords.x, Config.Locations["advocaat1"]["uitgangachter"].coords.y, Config.Locations["advocaat1"]["uitgangachter"].coords.z, true) < 1.5) then
                    DrawText3D(Config.Locations["advocaat1"]["uitgangachter"].coords.x, Config.Locations["advocaat1"]["uitgangachter"].coords.y, Config.Locations["advocaat1"]["uitgangachter"].coords.z, "~g~E~w~ - Om naar binnen te gaan")
                    if IsControlJustReleased(0, Config.Keys["E"]) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end

                        SetEntityCoords(PlayerPedId(), Config.Locations["advocaat1"]["ingangachter"].coords.x, Config.Locations["advocaat1"]["ingangachter"].coords.y, Config.Locations["advocaat1"]["ingangachter"].coords.z, 0, 0, 0, false)
                        SetEntityHeading(PlayerPedId(), Config.Locations["advocaat1"]["ingangachter"].coords.h)

                        Citizen.Wait(100)

                        DoScreenFadeIn(1000)
                    end
                end
            end
        end
        if not inRange then
            Citizen.Wait(2500)
        end
    end
end)

-- Vehicle spawner
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn and RSCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerJob.name == "lawyer" then
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["voertuigopslag"].coords.x, Config.Locations["advocaat1"]["voertuigopslag"].coords.y, Config.Locations["advocaat1"]["voertuigopslag"].coords.z, true) < 10.0) then
                    DrawMarker(2, Config.Locations["advocaat1"]["voertuigopslag"].coords.x, Config.Locations["advocaat1"]["voertuigopslag"].coords.y, Config.Locations["advocaat1"]["voertuigopslag"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["voertuigopslag"].coords.x, Config.Locations["advocaat1"]["voertuigopslag"].coords.y, Config.Locations["advocaat1"]["voertuigopslag"].coords.z, true) < 1.5) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                            DrawText3D(Config.Locations["advocaat1"]["voertuigopslag"].coords.x, Config.Locations["advocaat1"]["voertuigopslag"].coords.y, Config.Locations["advocaat1"]["voertuigopslag"].coords.z, "~g~E~w~ - Voertuig opbergen")
                        else
                            DrawText3D(Config.Locations["advocaat1"]["voertuigopslag"].coords.x, Config.Locations["advocaat1"]["voertuigopslag"].coords.y, Config.Locations["advocaat1"]["voertuigopslag"].coords.z, "~g~E~w~ - Voertuigen")
                        end
                        if IsControlJustReleased(0, Config.Keys["E"]) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            else
                                MenuGarage()
                                Menu.hidden = not Menu.hidden
                            end
                        end
                        Menu.renderGUI()
                    end 
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["advocaat1"]["kledingkast"].coords.x, Config.Locations["advocaat1"]["kledingkast"].coords.y, Config.Locations["advocaat1"]["kledingkast"].coords.z, true) < 1.5) then
                    DrawText3D(Config.Locations["advocaat1"]["kledingkast"].coords.x, Config.Locations["advocaat1"]["kledingkast"].coords.y, Config.Locations["advocaat1"]["kledingkast"].coords.z, "~g~E~w~ - Outfits")
                    if IsControlJustReleased(0, Config.Keys["E"]) then
                        TriggerEvent('rs-clothing:client:openOutfitMenu')
                    end
                end
            else
                Citizen.Wait(2500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

-- Rechtbank blip
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(416.61, -1084.57, 30.05)
	SetBlipSprite(blip, 304)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.6)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Gerechtshof")
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent("rs-justice:client:showLawyerLicense")
AddEventHandler("rs-justice:client:showLawyerLicense", function(sourceId, data)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pas-ID:</strong> {1} <br><strong>Voornaam:</strong> {2} <br><strong>Achternaam:</strong> {3} <br><strong>BSN:</strong> {4} </div></div>',
            args = {'Advocatenpas', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)

function MenuGarage()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Voertuigen", "VehicleList", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Voertuigen:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicle", k, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Terug", "MenuGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["advocaat1"]["voertuigopslag"].coords
    RSCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "ADVC"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function DrawText3D(x, y, z, text)
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