RSCore = nil
Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

local isLoggedIn = false
local InApartment = false
local ClosestHouse = nil
local CurrentApartment = nil
local IsOwned = false

local CurrentDoorBell = 0

local CurrentOffset = 0

local houseObj = {}
local POIOffsets = nil

local rangDoorbell = nil

Citizen.CreateThread(function()
	while RSCore == nil do
		TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn and not InApartment then
            SetClosestApartment()
        end
        Citizen.Wait(10000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isLoggedIn and ClosestHouse ~= nil then
            if InApartment then
                local pos = GetEntityCoords(GetPlayerPed(-1))

                if CurrentDoorBell ~= 0 then
                    if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.exit.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.exit.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.exit.z, true) < 1.2)then
                        RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.exit.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.exit.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.exit.z + 0.1, '~g~G~w~ - Open deur')
                        if IsControlJustPressed(0, Keys["G"]) then
                            TriggerServerEvent("apartments:server:OpenDoor", CurrentDoorBell, CurrentApartment, ClosestHouse)
                            CurrentDoorBell = 0
                        end
                    end
                end
                --exit
                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.exit.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.exit.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.exit.z, true) < 3)then
                    RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.exit.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.exit.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.exit.z, '~g~E~w~ - Ga uit appartement')
                    if IsControlJustPressed(0, Keys["E"]) then
                        LeaveApartment(ClosestHouse)
                    end
                end
                --stash
                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.stash.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.stash.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.stash.z, true) < 1.2)then
                    RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.stash.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.stash.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.stash.z, '~g~E~w~ - Stash')
                    if IsControlJustPressed(0, Keys["E"]) then
                        if CurrentApartment ~= nil then
                            TriggerServerEvent("inventory:server:OpenInventory", "stash", CurrentApartment)
                            TriggerEvent("inventory:client:SetCurrentStash", CurrentApartment)
                        end
                    end
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.stash.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.stash.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.stash.z, true) < 3)then
                    RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.stash.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.stash.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.stash.z, 'Stash')
                end
                --outfits
                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.clothes.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.clothes.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.clothes.z, true) < 1.2)then
                    RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.clothes.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.clothes.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.clothes.z, '~g~E~w~ - Outfits')
                    if IsControlJustPressed(0, Keys["E"]) then
                        TriggerEvent('rs-clothing:client:openOutfitMenu')
                    end
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.clothes.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.clothes.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.clothes.z, true) < 3)then
                    RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.clothes.x, Apartments.Locations[ClosestHouse].coords.enter.y - POIOffsets.clothes.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.clothes.z, 'Outfits')
                end
                --logout
                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.logout.x, Apartments.Locations[ClosestHouse].coords.enter.y + POIOffsets.logout.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.logout.z, true) < 1.5)then
                    RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.logout.x, Apartments.Locations[ClosestHouse].coords.enter.y + POIOffsets.logout.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.logout.z, '~g~E~w~ - Uitloggen')
                    if IsControlJustPressed(0, Keys["E"]) then
                        TriggerServerEvent('rs-houses:server:LogoutLocation')
                    end
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.logout.x, Apartments.Locations[ClosestHouse].coords.enter.y + POIOffsets.logout.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.logout.z, true) < 3)then
                    RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x - POIOffsets.logout.x, Apartments.Locations[ClosestHouse].coords.enter.y + POIOffsets.logout.y, Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset + POIOffsets.logout.z, 'Uitloggen')
                end
            else
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.doorbell.x, Apartments.Locations[ClosestHouse].coords.doorbell.y,Apartments.Locations[ClosestHouse].coords.doorbell.z, true) < 1.2)then
                    RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.doorbell.x, Apartments.Locations[ClosestHouse].coords.doorbell.y, Apartments.Locations[ClosestHouse].coords.doorbell.z, '~g~G~w~ - Aanbellen')
                    if IsControlJustPressed(0, Keys["G"]) then
                        MenuOwners()
                        Menu.hidden = not Menu.hidden
                    end
                    Menu.renderGUI()
                end

                if IsOwned then
                    local pos = GetEntityCoords(GetPlayerPed(-1))
                    if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y,Apartments.Locations[ClosestHouse].coords.enter.z, true) < 1.2)then
                        RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y, Apartments.Locations[ClosestHouse].coords.enter.z, '~g~E~w~ - Ga in appartement')
                        if IsControlJustPressed(0, Keys["E"]) then
                            RSCore.Functions.TriggerCallback('apartments:GetOwnedApartment', function(result)
                                if result ~= nil then
                                    EnterApartment(ClosestHouse, result.name)
                                end
                            end)
                        end
                    end
                elseif not IsOwned then
                    --[[local pos = GetEntityCoords(GetPlayerPed(-1))
                    if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y,Apartments.Locations[ClosestHouse].coords.enter.z, true) < 1.2)then
                        RSCore.Functions.DrawText3D(Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y, Apartments.Locations[ClosestHouse].coords.enter.z, '~g~G~w~ - Verander van appartement')
                        if IsControlJustPressed(0, Keys["G"]) then
                            TriggerServerEvent("apartments:server:UpdateApartment", ClosestHouse)
                            IsOwned = true
                        end
                    end]]--
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if houseObj ~= nil then
            exports['rs-interior']:DespawnInterior(houseObj, function()
                CurrentApartment = nil
                TriggerEvent('rs-weathersync:client:EnableSync')
                DoScreenFadeIn(500)
                while not IsScreenFadedOut() do
                    Citizen.Wait(10)
                end
                SetEntityCoords(GetPlayerPed(-1), Apartments.Locations[ClosestHouse].coords.enter.x, Apartments.Locations[ClosestHouse].coords.enter.y,Apartments.Locations[ClosestHouse].coords.enter.z)
                SetEntityHeading(GetPlayerPed(-1), Apartments.Locations[ClosestHouse].coords.enter.h)
                Citizen.Wait(1000)
                InApartment = false
                DoScreenFadeIn(1000)
            end)
        end
    end
end)

RegisterNetEvent('apartments:client:setupSpawnUI')
AddEventHandler('apartments:client:setupSpawnUI', function(cData)
    RSCore.Functions.TriggerCallback('apartments:GetOwnedApartment', function(result)
        if result ~= nil then
            TriggerEvent('rs-spawn:client:setupSpawns', cData, false, nil)
            TriggerEvent('rs-spawn:client:openUI', true)
            TriggerEvent("apartments:client:SetHomeBlip", result.type)
        else
            TriggerEvent('rs-spawn:client:setupSpawns', cData, true, Apartments.Locations)
            TriggerEvent('rs-spawn:client:openUI', true)
        end
    end, cData.citizenid)
end)

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('RSCore:Client:OnPlayerUnload')
AddEventHandler('RSCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    CurrentApartment = nil
    InApartment = false
    CurrentOffset = 0
end)

RegisterNetEvent('apartments:client:SpawnInApartment')
AddEventHandler('apartments:client:SpawnInApartment', function(apartmentId, apartment)
    --TriggerEvent('instances:client:JoinInstance', apartmentId, apartment)
    if rangDoorbell ~= nil then
        if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Apartments.Locations[rangDoorbell].coords.enter.x, Apartments.Locations[rangDoorbell].coords.enter.y,Apartments.Locations[rangDoorbell].coords.enter.z, true) > 5)then
            return
        end
    end
    ClosestHouse = apartment
    EnterApartment(apartment, apartmentId, true)
    IsOwned = true
end)

RegisterNetEvent('rs-apartments:client:LastLocationHouse')
AddEventHandler('rs-apartments:client:LastLocationHouse', function(apartmentType, apartmentId)
    ClosestHouse = apartmentType
    EnterApartment(apartmentType, apartmentId, false)
end)

RegisterNetEvent('apartments:client:SetHomeBlip')
AddEventHandler('apartments:client:SetHomeBlip', function(home)
    Citizen.CreateThread(function()
        SetClosestApartment()
        for name, apartment in pairs(Apartments.Locations) do
            RemoveBlip(Apartments.Locations[name].blip)

            Apartments.Locations[name].blip = AddBlipForCoord(Apartments.Locations[name].coords.enter.x, Apartments.Locations[name].coords.enter.y, Apartments.Locations[name].coords.enter.z)
            if (name == home) then
                SetBlipSprite(Apartments.Locations[name].blip, 475)
            else
                SetBlipSprite(Apartments.Locations[name].blip, 476)
            end
            SetBlipDisplay(Apartments.Locations[name].blip, 4)
            SetBlipScale(Apartments.Locations[name].blip, 0.65)
            SetBlipAsShortRange(Apartments.Locations[name].blip, true)
            SetBlipColour(Apartments.Locations[name].blip, 3)
    
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Apartments.Locations[name].label)
            EndTextCommandSetBlipName(Apartments.Locations[name].blip)
        end
    end)
end)

RegisterNetEvent('apartments:client:RingDoor')
AddEventHandler('apartments:client:RingDoor', function(player, house)
    CurrentDoorBell = player
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
    RSCore.Functions.Notify("Iemand belt aan de deur!")
end)

function EnterApartment(house, apartmentId, new)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.1)
    openHouseAnim()
    Citizen.Wait(250)
    RSCore.Functions.TriggerCallback('apartments:GetApartmentOffset', function(offset)
        if offset == nil or offset == 0 then
            RSCore.Functions.TriggerCallback('apartments:GetApartmentOffsetNewOffset', function(newoffset)
                if newoffset > 230 then
                    newoffset = 210
                end
                CurrentOffset = newoffset
                TriggerServerEvent("apartments:server:AddObject", apartmentId, house, CurrentOffset)
                
                local coords = { x = Apartments.Locations[house].coords.enter.x, y = Apartments.Locations[house].coords.enter.y, z = Apartments.Locations[house].coords.enter.z - CurrentOffset}
                data = exports['rs-interior']:CreateApartmentFurnished(coords)
                Citizen.Wait(100)
                houseObj = data[1]
                POIOffsets = data[2]

                InApartment = true
                CurrentApartment = apartmentId
                ClosestHouse = house
                rangDoorbell = nil
                
                Citizen.Wait(500)
                SetRainFxIntensity(0.0)
                TriggerEvent('rs-weathersync:client:DisableSync')
                -- TriggerEvent('tb-weed:client:getHousePlants', house)
                Citizen.Wait(100)
                SetWeatherTypePersist('EXTRASUNNY')
                SetWeatherTypeNow('EXTRASUNNY')
                SetWeatherTypeNowPersist('EXTRASUNNY')
                NetworkOverrideClockTime(23, 0, 0)
                --TriggerEvent('instances:client:JoinInstance', apartmentId, house)
                TriggerServerEvent('rs-apartments:server:SetInsideMeta', house, apartmentId, true)
                

                TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
                TriggerServerEvent("RSCore:Server:SetMetaData", "currentapartment", CurrentApartment)
            end, house)
        else
            if offset > 230 then
                offset = 210
            end
            CurrentOffset = offset
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.1)
            TriggerServerEvent("apartments:server:AddObject", apartmentId, house, CurrentOffset)
            local coords = { x = Apartments.Locations[ClosestHouse].coords.enter.x, y = Apartments.Locations[ClosestHouse].coords.enter.y, z = Apartments.Locations[ClosestHouse].coords.enter.z - CurrentOffset}
            data = exports['rs-interior']:CreateApartmentFurnished(coords)
            
            Citizen.Wait(100)
            houseObj = data[1]
            POIOffsets = data[2]

            InApartment = true
            CurrentApartment = apartmentId
            
            Citizen.Wait(500)
            SetRainFxIntensity(0.0)
            TriggerEvent('rs-weathersync:client:DisableSync')
            Citizen.Wait(100)
            SetWeatherTypePersist('EXTRASUNNY')
            SetWeatherTypeNow('EXTRASUNNY')
            SetWeatherTypeNowPersist('EXTRASUNNY')
            NetworkOverrideClockTime(23, 0, 0)
           
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
            TriggerServerEvent("RSCore:Server:SetMetaData", "currentapartment", CurrentApartment)
        end
        if new ~= nil then
            if new then
                TriggerEvent('rs-interior:client:SetNewState', true)
            else
                TriggerEvent('rs-interior:client:SetNewState', false)
            end
        else
            TriggerEvent('rs-interior:client:SetNewState', false)
        end
    end, apartmentId)
end

function LeaveApartment(house)
    --TriggerEvent('instances:client:LeaveInstance')
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.1)
    openHouseAnim()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['rs-interior']:DespawnInterior(houseObj, function()
        TriggerEvent('rs-weathersync:client:EnableSync')
        SetEntityCoords(GetPlayerPed(-1), Apartments.Locations[house].coords.enter.x, Apartments.Locations[house].coords.enter.y,Apartments.Locations[house].coords.enter.z)
        SetEntityHeading(GetPlayerPed(-1), Apartments.Locations[house].coords.enter.h)
        Citizen.Wait(1000)
        TriggerServerEvent("apartments:server:RemoveObject", CurrentApartment, house)
        TriggerServerEvent('rs-apartments:server:SetInsideMeta', CurrentApartment, false)
        CurrentApartment = nil
        InApartment = false
        CurrentOffset = 0
        DoScreenFadeIn(1000)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
        TriggerServerEvent("RSCore:Server:SetMetaData", "currentapartment", nil)
    end)
end

function SetClosestApartment()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, house in pairs(Apartments.Locations) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, Apartments.Locations[id].coords.enter.x, Apartments.Locations[id].coords.enter.y, Apartments.Locations[id].coords.enter.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, Apartments.Locations[id].coords.enter.x, Apartments.Locations[id].coords.enter.y, Apartments.Locations[id].coords.enter.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, Apartments.Locations[id].coords.enter.x, Apartments.Locations[id].coords.enter.y, Apartments.Locations[id].coords.enter.z, true)
            current = id
        end
    end
    if current ~= ClosestHouse and isLoggedIn and not InApartment then
        ClosestHouse = current
        RSCore.Functions.TriggerCallback('apartments:IsOwner', function(result)
            IsOwned = result
        end, ClosestHouse)
    end
end

function openHouseAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end

function MenuOwners()
    ped = GetPlayerPed(-1);
    MenuTitle = "Owners"
    ClearMenu()
    Menu.addButton("Aanbellen", "OwnerList", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function OwnerList()
    RSCore.Functions.TriggerCallback('apartments:GetAvailableApartments', function(apartments)
        ped = GetPlayerPed(-1);
        MenuTitle = "Aanbellen bij: "
        ClearMenu()

        if apartments == nil then
            RSCore.Functions.Notify("Er is niemand aanwezig..", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(apartments) do
                Menu.addButton(v, "RingDoor", k) 
            end
        end
        Menu.addButton("Terug", "MenuOwners",nil)
    end, ClosestHouse)
end

function RingDoor(apartmentId)
    rangDoorbell = ClosestHouse
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
    TriggerServerEvent("apartments:server:RingDoor", apartmentId, ClosestHouse)
end

function MenuOutfits()
    ped = GetPlayerPed(-1);
    MenuTitle = "Outfits"
    ClearMenu()
    Menu.addButton("Mijn Outfits", "OutfitsLijst", nil)
    Menu.addButton("Sluit Menu", "closeMenuFull", nil) 
end

function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function OutfitsLijst()
    RSCore.Functions.TriggerCallback('apartments:GetOutfits', function(outfits)
        ped = GetPlayerPed(-1);
        MenuTitle = "My Outfits :"
        ClearMenu()

        if outfits == nil then
            RSCore.Functions.Notify("Je hebt geen outfits opgeslagen...", "error", 3500)
            closeMenuFull()
        else
            for k, v in pairs(outfits) do
                Menu.addButton(outfits[k].outfitname, "optionMenu", outfits[k]) 
            end
        end
        Menu.addButton("Terug", "MenuOutfits",nil)
    end)
end

function optionMenu(outfitData)
    ped = GetPlayerPed(-1);
    MenuTitle = "What now?"
    ClearMenu()

    Menu.addButton("Kies Outfit", "selectOutfit", outfitData) 
    Menu.addButton("Verwijder Outfit", "removeOutfit", outfitData) 
    Menu.addButton("Terug", "OutfitsLijst",nil)
end

function selectOutfit(oData)
    TriggerServerEvent('clothes:selectOutfit', oData.model, oData.skin)
    RSCore.Functions.Notify(oData.outfitname.." gekozen", "success", 2500)
    closeMenuFull()
    changeOutfit()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    RSCore.Functions.Notify(oData.outfitname.." is verwijderd", "success", 2500)
    closeMenuFull()
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end
