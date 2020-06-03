local isLoggedIn = true
local housePlants = {}
local insideHouse = false
local currentHouse = nil

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

RSWeed.DrawText3Ds = function(x, y, z, text)
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

RegisterNetEvent('rs-weed:client:getHousePlants')
AddEventHandler('rs-weed:client:getHousePlants', function(house)    
    RSCore.Functions.TriggerCallback('rs-weed:server:getBuildingPlants', function(plants)
        currentHouse = house
        housePlants[currentHouse] = plants
        insideHouse = true
        spawnHousePlants()
    end, house)
end)

function spawnHousePlants()
    Citizen.CreateThread(function()
        if not plantSpawned then
            for k, v in pairs(housePlants[currentHouse]) do
                local plantData = {
                    ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                    ["plantProp"] = GetHashKey(RSWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                }

                plantProp = CreateObject(plantData["plantProp"], plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false, false, false)
                FreezeEntityPosition(plantProp, true)
                SetEntityAsMissionEntity(plantProp, false, false)
                PlaceObjectOnGroundProperly(plantProp)
                Citizen.Wait(20)
                PlaceObjectOnGroundProperly(plantProp)
            end
            plantSpawned = true
        end
    end)
end

function despawnHousePlants()
    Citizen.CreateThread(function()
        if plantSpawned then
            for k, v in pairs(housePlants[currentHouse]) do
                local plantData = {
                    ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                }

                for _, stage in pairs(RSWeed.Plants[housePlants[currentHouse][k].sort]["stages"]) do
                    local closestPlant = GetClosestObjectOfType(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 3.5, GetHashKey(stage), false, false, false)
                    if closestPlant ~= 0 then                    
                        DeleteObject(closestPlant)
                    end
                end
            end
            plantSpawned = false
        end
    end)
end

local ClosestTarget = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if insideHouse then
            if plantSpawned then
                local ped = GetPlayerPed(-1)
                for k, v in pairs(housePlants[currentHouse]) do
                    local gender = "M"
                    if housePlants[currentHouse][k].gender == "woman" then gender = "V" end

                    local plantData = {
                        ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                        ["plantStage"] = housePlants[currentHouse][k].stage,
                        ["plantProp"] = GetHashKey(RSWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                        ["plantSort"] = {
                            ["name"] = housePlants[currentHouse][k].sort,
                            ["label"] = RSWeed.Plants[housePlants[currentHouse][k].sort]["label"],
                        },
                        ["plantStats"] = {
                            ["food"] = housePlants[currentHouse][k].food,
                            ["health"] = housePlants[currentHouse][k].health,
                            ["progress"] = housePlants[currentHouse][k].progress,
                            ["stage"] = housePlants[currentHouse][k].stage,
                            ["highestStage"] = RSWeed.Plants[housePlants[currentHouse][k].sort]["highestStage"],
                            ["gender"] = gender,
                            ["plantId"] = housePlants[currentHouse][k].plantid,
                        }
                    }

                    local plyDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false)

                    if plyDistance < 0.8 then

                        ClosestTarget = k
                        if plantData["plantStats"]["health"] > 0 then
                            if plantData["plantStage"] ~= plantData["plantStats"]["highestStage"] then
                                RSWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'Soort: '..plantData["plantSort"]["label"]..'~w~ ['..plantData["plantStats"]["gender"]..'] | Voeding: ~b~'..plantData["plantStats"]["food"]..'% ~w~ | Gezondheid: ~b~'..plantData["plantStats"]["health"]..'%')
                            else
                                RSWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"] + 0.2, 'De plant is volgroeid ~g~E~w~ om te oogsten..')
                                RSWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'Soort: ~g~'..plantData["plantSort"]["label"]..'~w~ ['..plantData["plantStats"]["gender"]..'] | Voeding: ~b~'..plantData["plantStats"]["food"]..'% ~w~ | Gezondheid: ~b~'..plantData["plantStats"]["health"]..'%')
                                if IsControlJustPressed(0, RSWeed.Keys["E"]) then
                                    RSCore.Functions.Progressbar("remove_weed_plant", "Plant aan het oogsten..", 8000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {
                                        animDict = "amb@world_human_gardener_plant@male@base",
                                        anim = "base",
                                        flags = 16,
                                    }, {}, {}, function() -- Done
                                        ClearPedTasks(ped)
                                        if plantData["plantStats"]["gender"] == "M" then
                                            amount = math.random(1, 5)
                                        else
                                            amount = math.random(3, 8)
                                        end
                                        TriggerServerEvent('rs-weed:server:harvestPlant', currentHouse, amount, plantData["plantSort"]["name"], plantData["plantStats"]["plantId"])
                                    end, function() -- Cancel
                                        ClearPedTasks(ped)
                                        RSCore.Functions.Notify("Proces geannuleerd..", "error")
                                    end)
                                end
                            end
                        elseif plantData["plantStats"]["health"] == 0 then
                            RSWeed.DrawText3Ds(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 'De plant is dood, ~r~E~w~ - Om plant weg te halen..')
                            if IsControlJustPressed(0, RSWeed.Keys["E"]) then
                                RSCore.Functions.Progressbar("remove_weed_plant", "Plant aan het weghalen..", 8000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "amb@world_human_gardener_plant@male@base",
                                    anim = "base",
                                    flags = 16,
                                }, {}, {}, function() -- Done
                                    ClearPedTasks(ped)
                                    TriggerServerEvent('rs-weed:server:removeDeathPlant', currentHouse, plantData["plantStats"]["plantId"])
                                end, function() -- Cancel
                                    ClearPedTasks(ped)
                                    RSCore.Functions.Notify("Proces geannuleerd..", "error")
                                end)
                            end
                        end
                    end
                end
            end
        end

        if not insideHouse then
            Citizen.Wait(5000)
        end
    end
end)

RegisterNetEvent('rs-weed:client:leaveHouse')
AddEventHandler('rs-weed:client:leaveHouse', function()
    despawnHousePlants()
    SetTimeout(1000, function()
        if currentHouse ~= nil then
            insideHouse = false
            housePlants[currentHouse] = nil
            currentHouse = nil
        end
    end)
end)

RegisterNetEvent('rs-weed:client:refreshHousePlants')
AddEventHandler('rs-weed:client:refreshHousePlants', function(house)
    if currentHouse ~= nil and currentHouse == house then
        despawnHousePlants()
        SetTimeout(500, function()
            RSCore.Functions.TriggerCallback('rs-weed:server:getBuildingPlants', function(plants)
                currentHouse = house
                housePlants[currentHouse] = plants
                spawnHousePlants()
            end, house)
        end)
    end
end)

RegisterNetEvent('rs-weed:client:refreshPlantStats')
AddEventHandler('rs-weed:client:refreshPlantStats', function()
    if insideHouse then
        despawnHousePlants()
        SetTimeout(500, function()
            RSCore.Functions.TriggerCallback('rs-weed:server:getBuildingPlants', function(plants)
                housePlants[currentHouse] = plants
                spawnHousePlants()
            end, currentHouse)
        end)
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end

RegisterNetEvent('rs-weed:client:placePlant')
AddEventHandler('rs-weed:client:placePlant', function(type, item)
    local ped = GetPlayerPed(-1)
    local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.75, 0)
    local plantData = {
        ["plantCoords"] = {["x"] = plyCoords.x, ["y"] = plyCoords.y, ["z"] = plyCoords.z},
        ["plantModel"] = RSWeed.Plants[type]["stages"]["stage-a"],
        ["plantLabel"] = RSWeed.Plants[type]["label"]
    }
    local ClosestPlant = 0
    for k, v in pairs(RSWeed.Props) do
        if ClosestPlant == 0 then
            ClosestPlant = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 0.8, GetHashKey(v), false, false, false)
        end
    end

    if currentHouse ~= nil then
        if ClosestPlant == 0 then
            RSCore.Functions.Progressbar("plant_weed_plant", "Bezig met planten..", 8000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "amb@world_human_gardener_plant@male@base",
                anim = "base",
                flags = 16,
            }, {}, {}, function() -- Done
                ClearPedTasks(ped)
                plantObject = CreateObject(plantData["plantModel"], plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false, false, false)
                FreezeEntityPosition(plantObject, true)
                SetEntityAsMissionEntity(plantObject, false, false)
                PlaceObjectOnGroundProperly(plantObject)
            
                TriggerServerEvent('rs-weed:server:placePlant', currentHouse, json.encode(plantData["plantCoords"]), type)
                TriggerServerEvent('rs-weed:server:removeSeed', item.slot, type)
            end, function() -- Cancel
                ClearPedTasks(ped)
                RSCore.Functions.Notify("Proces geannuleerd..", "error")
            end)
        else
            RSCore.Functions.Notify('Geen plek a sah..', 'error', 3500)
        end
    else
        RSCore.Functions.Notify('Het is hier niet veilig..', 'error', 3500)
    end
end)

RegisterNetEvent('rs-weed:client:foodPlant')
AddEventHandler('rs-weed:client:foodPlant', function(item)
    local plantData = {}
    if currentHouse ~= nil then
        if ClosestTarget ~= 0 then
            local ped = GetPlayerPed(-1)
            local gender = "M"
            if housePlants[currentHouse][ClosestTarget].gender == "woman" then 
                gender = "V" 
            end

            plantData = {
                ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).x, ["y"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).y, ["z"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).z},
                ["plantStage"] = housePlants[currentHouse][ClosestTarget].stage,
                ["plantProp"] = GetHashKey(RSWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["stages"][housePlants[currentHouse][ClosestTarget].stage]),
                ["plantSort"] = {
                    ["name"] = housePlants[currentHouse][ClosestTarget].sort,
                    ["label"] = RSWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["label"],
                },
                ["plantStats"] = {
                    ["food"] = housePlants[currentHouse][ClosestTarget].food,
                    ["health"] = housePlants[currentHouse][ClosestTarget].health,
                    ["progress"] = housePlants[currentHouse][ClosestTarget].progress,
                    ["stage"] = housePlants[currentHouse][ClosestTarget].stage,
                    ["highestStage"] = RSWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["highestStage"],
                    ["gender"] = gender,
                    ["plantId"] = housePlants[currentHouse][ClosestTarget].plantid,
                }
            }
            local plyDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false)

            if plyDistance < 1.0 then
                if plantData["plantStats"]["food"] == 100 then
                    RSCore.Functions.Notify('De plant heeft geen voeding nodig..', 'error', 3500)
                else
                    RSCore.Functions.Progressbar("plant_weed_plant", "Plant aan het voeden..", math.random(4000, 8000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "timetable@gardener@filling_can",
                        anim = "gar_ig_5_filling_can",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        ClearPedTasks(ped)
                        local newFood = math.random(40, 60)
                        TriggerServerEvent('rs-weed:server:foodPlant', currentHouse, newFood, plantData["plantSort"]["name"], plantData["plantStats"]["plantId"])
                    end, function() -- Cancel
                        ClearPedTasks(ped)
                        RSCore.Functions.Notify("Proces geannuleerd..", "error")
                    end)
                end
            else
                RSCore.Functions.Notify("Geen plant a sah..", "error")
            end
        else
            RSCore.Functions.Notify("Geen plant a sah..", "error")
        end
    end
end)