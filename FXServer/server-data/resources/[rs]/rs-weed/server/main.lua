RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

--CODE

RSCore.Functions.CreateCallback('rs-weed:server:getBuildingPlants', function(source, cb, building)
    local buildingPlants = {}

    exports['ghmattimysql']:execute('SELECT * FROM house_plants WHERE building = @building', {['@building'] = building}, function(plants)
        for i = 1, #plants, 1 do
            table.insert(buildingPlants, plants[i])
        end

        if buildingPlants ~= nil then
            cb(buildingPlants)
        else    
            cb(nil)
        end
    end)
end)

RSCore.Commands.Add("plaatsplant", "", {}, false, function(source, args)
    local src           = source
    local player        = RSCore.Functions.GetPlayer(src)
    local type          = args[1]

    if RSWeed.Plants[type] ~= nil then
        TriggerClientEvent('rs-weed:client:placePlant', src, type)
    end
end)

RegisterServerEvent('rs-weed:server:placePlant')
AddEventHandler('rs-weed:server:placePlant', function(currentHouse, coords, sort)
    local random = math.random(1, 2)
    local gender
    if random == 1 then gender = "man" else gender = "woman" end

    RSCore.Functions.ExecuteSql(true, "INSERT INTO `house_plants` (`building`, `coords`, `gender`, `sort`, `plantid`) VALUES ('"..currentHouse.."', '"..coords.."', '"..gender.."', '"..sort.."', '"..math.random(111111,999999).."')")
    TriggerClientEvent('rs-weed:client:refreshHousePlants', -1, currentHouse)
end)

RegisterServerEvent('rs-weed:server:removeDeathPlant')
AddEventHandler('rs-weed:server:removeDeathPlant', function(building, plantId)
    RSCore.Functions.ExecuteSql(true, "DELETE FROM `house_plants` WHERE plantid = '"..plantId.."' AND building = '"..building.."'")
    TriggerClientEvent('rs-weed:client:refreshHousePlants', -1, building)
end)

Citizen.CreateThread(function()
    while true do
        RSCore.Functions.ExecuteSql(false, "SELECT * FROM `house_plants`", function(housePlants)
            for k, v in pairs(housePlants) do
                if housePlants[k].food >= 50 then
                    RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `food` = '"..(housePlants[k].food - 1).."' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                    if housePlants[k].health + 1 < 100 then
                        RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `health` = '"..(housePlants[k].health + 1).."' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                    end
                end

                if housePlants[k].food < 50 then
                    if housePlants[k].food - 1 >= 0 then
                        RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `food` = '"..(housePlants[k].food - 1).."' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                    end
                    if housePlants[k].health - 1 >= 0 then
                        RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `health` = '"..(housePlants[k].health - 1).."' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                    end
                end
            end

            TriggerClientEvent('rs-weed:client:refreshPlantStats', -1)
        end)

        Citizen.Wait((60 * 1000) * 19.2)
    end
end)

Citizen.CreateThread(function()
    while true do
        RSCore.Functions.ExecuteSql(false, "SELECT * FROM `house_plants`", function(housePlants)
            for k, v in pairs(housePlants) do
                if housePlants[k].health > 50 then
                    local Grow = math.random(1, 3)
                    if housePlants[k].progress + Grow < 100 then
                        RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `progress` = '"..(housePlants[k].progress + 1).."' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                    elseif housePlants[k].progress + Grow >= 100 then
                        if housePlants[k].stage ~= RSWeed.Plants[housePlants[k].sort]["highestStage"] then
                            if housePlants[k].stage == "stage-a" then
                                RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-b' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            elseif housePlants[k].stage == "stage-b" then
                                RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-c' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            elseif housePlants[k].stage == "stage-c" then
                                RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-d' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            elseif housePlants[k].stage == "stage-d" then
                                RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-e' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            elseif housePlants[k].stage == "stage-e" then
                                RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-f' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            elseif housePlants[k].stage == "stage-f" then
                                RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `stage` = 'stage-g' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                            end
                            RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `progress` = '0' WHERE `plantid` = '"..housePlants[k].plantid.."'")
                        end
                    end
                end
            end

            TriggerClientEvent('rs-weed:client:refreshPlantStats', -1)
        end)

        Citizen.Wait((60 * 1000) * 9.6)
    end
end)

RSCore.Functions.CreateUseableItem("weed_white-widow_seed", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('rs-weed:client:placePlant', source, 'white-widow', item)
end)

RSCore.Functions.CreateUseableItem("weed_skunk_seed", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('rs-weed:client:placePlant', source, 'skunk', item)
end)

RSCore.Functions.CreateUseableItem("weed_purple-haze_seed", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('rs-weed:client:placePlant', source, 'purple-haze', item)
end)

RSCore.Functions.CreateUseableItem("weed_og-kush_seed", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('rs-weed:client:placePlant', source, 'og-kush', item)
end)

RSCore.Functions.CreateUseableItem("weed_amnesia_seed", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('rs-weed:client:placePlant', source, 'amnesia', item)
end)

RSCore.Functions.CreateUseableItem("weed_ak47_seed", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('rs-weed:client:placePlant', source, 'ak47', item)
end)

RSCore.Functions.CreateUseableItem("weed_nutrition", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('rs-weed:client:foodPlant', source, item)
end)

RegisterServerEvent('rs-weed:server:removeSeed')
AddEventHandler('rs-weed:server:removeSeed', function(itemslot, seed)
    local Player = RSCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(seed, 1, itemslot)
end)

RegisterServerEvent('rs-weed:server:harvestPlant')
AddEventHandler('rs-weed:server:harvestPlant', function(house, amount, plantName, plantId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local weedBag = Player.Functions.GetItemByName('empty_weed_bag')
    local sndAmount = math.random(8, 12)

    if weedBag ~= nil then
        if weedBag.amount >= sndAmount then
            if house ~= nil then 
                RSCore.Functions.ExecuteSql(false, "SELECT * FROM `house_plants` WHERE plantid = '"..plantId.."' AND building = '"..house.."'", function(result)
                    if result[1] ~= nil then
                        Player.Functions.AddItem('weed_'..plantName..'_seed', amount)
                        Player.Functions.AddItem('weed_'..plantName, sndAmount)
                        Player.Functions.RemoveItem('empty_weed_bag', 1)
                        RSCore.Functions.ExecuteSql(true, "DELETE FROM `house_plants` WHERE plantid = '"..plantId.."' AND building = '"..house.."'")
                        TriggerClientEvent('RSCore:Notify', src, 'De plant is geoogst', 'success', 3500)
                        TriggerClientEvent('rs-weed:client:refreshHousePlants', -1, house)
                    else
                        TriggerClientEvent('RSCore:Notify', src, 'Deze plant bestaat niet meer?', 'error', 3500)
                    end
                end)
            else
                TriggerClientEvent('RSCore:Notify', src, 'Huis niet gevonden', 'error', 3500)
            end
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet genoeg hersluitbare zakjes', 'error', 3500)
        end
    else
        TriggerClientEvent('RSCore:Notify', src, 'Je hebt geen hersluitbare zakjes', 'error', 3500)
    end
end)

RegisterServerEvent('rs-weed:server:foodPlant')
AddEventHandler('rs-weed:server:foodPlant', function(house, amount, plantName, plantId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `house_plants` WHERE `building` = "'..house..'" AND `sort` = "'..plantName..'" AND `plantid` = "'..tostring(plantId)..'"', function(plantStats)
        TriggerClientEvent('RSCore:Notify', src, RSWeed.Plants[plantName]["label"]..' | Voeding: '..plantStats[1].food..'% + '..amount..'% ('..(plantStats[1].food + amount)..'%)', 'success', 3500)
        if plantStats[1].food + amount > 100 then
            RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `food` = '100' WHERE `building` = '"..house.."' AND `plantid` = '"..plantId.."'")
        else
            RSCore.Functions.ExecuteSql(true, "UPDATE `house_plants` SET `food` = '"..(plantStats[1].food + amount).."' WHERE `building` = '"..house.."' AND `plantid` = '"..plantId.."'")
        end
        Player.Functions.RemoveItem('weed_nutrition', 1)
        TriggerClientEvent('rs-weed:client:refreshHousePlants', -1, house)
    end)
end)