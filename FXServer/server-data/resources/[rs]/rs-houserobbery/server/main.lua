RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RSCore.Functions.CreateCallback('rs-houserobbery:server:GetHouseConfig', function(source, cb)
    cb(Config.Houses)
end)

RegisterServerEvent('rs-houserobbery:server:enterHouse')
AddEventHandler('rs-houserobbery:server:enterHouse', function(house)
    local src = source
    local itemInfo = RSCore.Shared.Items["lockpick"]
    local Player = RSCore.Functions.GetPlayer(src)
    
    if not Config.Houses[house]["opened"] then
        ResetHouseStateTimer(house)
        TriggerClientEvent('rs-houserobbery:client:setHouseState', -1, house, true)
    end
    TriggerClientEvent('rs-houserobbery:client:enterHouse', src, house)
    Config.Houses[house]["opened"] = true
end)

function ResetHouseStateTimer(house)
    -- Cannot parse math.random "directly" inside the tonumber function
    local num = math.random(3333333, 11111111)
    local time = tonumber(num)
    Citizen.SetTimeout(time, function()
        Config.Houses[house]["opened"] = false
        for k, v in pairs(Config.Houses[house]["furniture"]) do
            v["searched"] = false
        end
        TriggerClientEvent('rs-houserobbery:client:ResetHouseState', -1, house)
    end)
end

local rareLoot = {
    "weapon_bat",
    "painkiller",
    "rubber"
}

function pickSpecialReward()
    return rareLoot[math.random(1, #rareLoot)]
end

RegisterServerEvent('rs-houserobbery:server:searchCabin')
AddEventHandler('rs-houserobbery:server:searchCabin', function(cabin, house)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local luck = math.random(1, 10)
    local itemFound = math.random(1, 4) -- Chance of items should be 75%, 25% failure. If it is 4, failure.
    local itemCount = 1

    if itemFound < 4 then
        if luck == 10 then -- 10% chance on 3 items, want more? buff below
            itemCount = 3 
        elseif luck >= 6 and luck <= 8 then -- 30% chance on 2 items, want more? buff below
            itemCount = 2
        end
        -- So theres 60% chance you only get 1 item, because itemCount is 1 by default.

        for i = 1, itemCount, 1 do

            -- Retrieve items from kind of furniture
            local randomizedItems = Config.Rewards[Config.Houses[house]["tier"]][Config.Houses[house]["furniture"][cabin]["type"]]
            -- Retrieve random item from furniture
            local randomItem = randomizedItems[math.random(#randomizedItems)]

            local itemInfo = RSCore.Shared.Items[randomItem]
            -- print(itemInfo)
            if math.random(1, 100) == 69 then -- 1% chance to get rare item as item per itemcount
                randomItem = pickSpecialReward()
                itemInfo = RSCore.Shared.Items[randomItem]
                local amountSpecialItem = 1
                if randomItem == "rubber" then
                    amountSpecialItem = 10
                end
                Player.Functions.AddItem(randomItem, amountSpecialItem)   
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            else
                if not itemInfo["unqiue"] then
                    local itemAmount = math.random(2, 5) -- 3 to 6 diamond rings, rolex, tosti, sandwich
                    if randomItem == "plastic" then
                        itemAmount = math.random(10, 15) -- 10 to 15 pieces of plastic
                    elseif randomItem == "goldchain" then
                        itemAmount = math.random(4, 8) -- 3 to 6 pieces of goldchain
                    elseif randomItem == "goldbar" then
                        itemAmount = 1 -- 1 pieces of goldbar
                    end
                    Player.Functions.AddItem(randomItem, itemAmount)
                    --TriggerClientEvent('RSCore:Notify', src, '+'..itemAmount..' '..itemInfo["label"], 'success', 3500)
                else
                    Player.Functions.AddItem(randomItem, 1)
                end
                TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "add")
            end
            -- Add pistol_ammo chance
            if math.random(1,100) > 95 then
                local pistol_ammo = RSCore.Shared.Items["pistol_ammo"]
                Player.Functions.AddItem(pistol_ammo, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, pistol_ammo, "add")
            end
            Citizen.Wait(500)
        end
    else
        TriggerClientEvent('RSCore:Notify', src, 'Het kastje is leeg broooo', 'error', 3500)
    end

    Config.Houses[house]["furniture"][cabin]["searched"] = true
    TriggerClientEvent('rs-houserobbery:client:setCabinState', -1, house, cabin, true)
end)

RegisterServerEvent('rs-houserobbery:server:SetBusyState')
AddEventHandler('rs-houserobbery:server:SetBusyState', function(cabin, house, bool)
    Config.Houses[house]["furniture"][cabin]["isBusy"] = bool
    TriggerClientEvent('rs-houserobbery:client:SetBusyState', -1, cabin, house, bool)
end)

RegisterServerEvent('rs-houserobbery:server:clearAnimsAllPedsInsideRobberyHouses')
AddEventHandler('rs-houserobbery:server:clearAnimsAllPedsInsideRobberyHouses', function()
    TriggerClientEvent('rs-houserobbery:client:ClearPedAnims', -1)
end)

RegisterServerEvent('rs-houserobbery:server:SetHouseLocked')
AddEventHandler('rs-houserobbery:server:SetHouseLocked', function(house)
    Config.Houses[house]["opened"] = false
    TriggerClientEvent('rs-houserobbery:client:SetHouseLockStatus', -1, house, false)
end)