RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local robberyBusy = false
local timeOut = false
local blackoutActive = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 10)
        if blackoutActive then
            TriggerEvent("rs-weathersync:server:toggleBlackout")
            TriggerClientEvent("police:client:EnableAllCameras", -1)
            TriggerClientEvent("rs-bankrobbery:client:enableAllBankSecurity", -1)
            blackoutActive = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 45)
        TriggerClientEvent("rs-bankrobbery:client:enableAllBankSecurity", -1)
        TriggerClientEvent("police:client:EnableAllCameras", -1)
    end
end)

RegisterServerEvent('rs-bankrobbery:server:setBankState')
AddEventHandler('rs-bankrobbery:server:setBankState', function(bankId, state)
    if bankId == "paleto" then
        if not robberyBusy then
            Config.BigBanks["paleto"]["isOpened"] = state
            TriggerClientEvent('rs-bankrobbery:client:setBankState', -1, bankId, state)
            TriggerEvent('rs-scoreboard:server:SetActivityBusy', "bankrobbery", true)
            TriggerEvent('rs-bankrobbery:server:setTimeout')
        end
    elseif bankId == "pacific" then
        if not robberyBusy then
            Config.BigBanks["pacific"]["isOpened"] = state
            TriggerClientEvent('rs-bankrobbery:client:setBankState', -1, bankId, state)
            TriggerEvent('rs-scoreboard:server:SetActivityBusy', "pacific", true)
            TriggerEvent('rs-bankrobbery:server:setTimeout')
        end
    elseif bankId == "maze" then
        if not robberyBusy then
            Config.BigBanks["maze"]["isOpened"] = state
            TriggerClientEvent('rs-bankrobbery:client:setBankState', -1, bankId, state)
            TriggerEvent('rs-scoreboard:server:SetActivityBusy', "bankrobbery", true)
            TriggerEvent('rs-bankrobbery:server:setTimeout')
        end
    else
        if not robberyBusy then
            Config.SmallBanks[bankId]["isOpened"] = state
            TriggerClientEvent('rs-bankrobbery:client:setBankState', -1, bankId, state)
            TriggerEvent('rs-banking:server:SetBankClosed', bankId, true)
            TriggerEvent('rs-scoreboard:server:SetActivityBusy', "bankrobbery", true)
            TriggerEvent('rs-bankrobbery:server:SetSmallbankTimeout', bankId)
        end
    end
    robberyBusy = true
end)

RegisterServerEvent('rs-bankrobbery:server:setLockerState')
AddEventHandler('rs-bankrobbery:server:setLockerState', function(bankId, lockerId, state, bool)
    if bankId == "paleto" then
        Config.BigBanks["paleto"]["lockers"][lockerId][state] = bool
    elseif bankId == "pacific" then
        Config.BigBanks["pacific"]["lockers"][lockerId][state] = bool
    elseif bankId == "maze" then
        Config.BigBanks["maze"]["lockers"][lockerId][state] = bool
    else
        Config.SmallBanks[bankId]["lockers"][lockerId][state] = bool
    end

    TriggerClientEvent('rs-bankrobbery:client:setLockerState', -1, bankId, lockerId, state, bool)
end)

RegisterServerEvent('rs-bankrobbery:server:recieveItem')
AddEventHandler('rs-bankrobbery:server:recieveItem', function()
    RSCore.Functions.BanInjection(source, 'rs-bankrobbery (recieveItem)')
end)


RegisterServerEvent('rs-bankrobbery:server:setCabinetState')
AddEventHandler('rs-bankrobbery:server:setCabinetState', function(bankId, cabinetId, state, bool)
    if bankId == "maze" then
        Config.BigBanks["maze"]["cabinets"][cabinetId][state] = bool
    end

    TriggerClientEvent('rs-bankrobbery:client:setCabinetState', -1, bankId, cabinetId, state, bool)
end)

RegisterServerEvent('rs-bankrobbery:server:cabinetItem')
AddEventHandler('rs-bankrobbery:server:cabinetItem', function(type)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)

    if type == "maze" then
        
        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 25 then tier = 1 elseif tierChance >= 25 and tierChance < 50 then tier = 2 elseif tierChance >= 50 and tierChance < 75 then tier = 3 elseif tierChance >=75 and tierChance <85 then tier = 4 elseif tierChance >=85 and tierChance < 88 then tier = 5 elseif tierChance >= 88 and tierChance < 92 then tier = 6 elseif tierChance >= 92 and tierChance < 95 then tier = 7 else tier = 8 end
            if tier ~= 8 then
                local item = Config.CabinetRewards["tier"..tier][math.random(#Config.CabinetRewards["tier"..tier])]
                local itemAmount = math.random(item.maxAmount)

                ply.Functions.AddItem(item.item, itemAmount)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], "add")
            else
                ply.Functions.AddItem('rifle_ammo', 2)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['rifle_ammo'], "add")
            end
        end    
    end)

RSCore.Functions.CreateCallback('rs-bankrobbery:recieveItem', function(source, cb, type)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)

    if type == "small" then
        local itemType = math.random(#Config.RewardTypes) -- 50% chance on money, 50% chance on item
        local WeaponChance = math.random(1, 50)
        local odd1 = math.random(1, 50)
        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 50 then 
            tier = 1 
        elseif tierChance >= 50 and tierChance < 80 then 
            tier = 2 
        elseif tierChance >= 80 and tierChance < 95 then 
            tier = 3 
        else 
            tier = 4 
        end

        if WeaponChance ~= odd1 then
        if tier ~= 4 then
            if Config.RewardTypes[itemType].type == "item" then
                local item = Config.LockerRewards["tier"..tier][math.random(#Config.LockerRewards["tier"..tier])]            
                local itemAmount = math.random(item.minAmount, item.maxAmount)

                ply.Functions.AddItem(item.item, itemAmount)
                TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[item.item], "add")
            elseif Config.RewardTypes[itemType].type == "money" then
                local info = {
                    worth = math.random(4000, 6000)
                }
                ply.Functions.AddItem('markedbills', 1, false, info)
                TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['markedbills'], "add")
            end
        else
            ply.Functions.AddItem('security_card_01', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['security_card_01'], "add")
        end
    else
        ply.Functions.AddItem('weapon_stungun', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['weapon_stungun'], "add")
    end
    elseif type == "paleto" then
        local itemType = math.random(#Config.RewardTypes)  -- 50% chance on money, 50% chance on item
        local tierChance = math.random(1, 100)
        local WeaponChance = math.random(1, 100)
        local odd1 = math.random(1, 100)
        local tier = 1
        if tierChance < 25 then 
            tier = 1 
        elseif tierChance >= 25 and tierChance < 70 then 
            tier = 2 
        elseif tierChance >= 70 and tierChance < 95 then 
            tier = 3 
        else 
            tier = 4 
        end
        if WeaponChance ~= odd1 then
            
            if tier ~= 4 then
                if Config.RewardTypes[itemType].type == "item" then
                    local item = Config.LockerRewardsPaleto["tier"..tier][math.random(#Config.LockerRewardsPaleto["tier"..tier])]
                    local itemAmount = math.random(item.minAmount, item.maxAmount)

                    ply.Functions.AddItem(item.item, itemAmount)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[item.item], "add")
                elseif Config.RewardTypes[itemType].type == "money" then
                    local info = {
                        worth = math.random(11000, 13000)
                    }
                    ply.Functions.AddItem('markedbills', 1, false, info)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['markedbills'], "add")
                end
            else
                ply.Functions.AddItem('security_card_02', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['security_card_02'], "add")
            end
        else
            ply.Functions.AddItem('weapon_vintagepistol', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['weapon_vintagepistol'], "add")
        end
    elseif type == "maze" then
        local itemType = math.random(#Config.RewardTypes)
        local tierChance = math.random(1, 100)
        local WeaponChance = math.random(1, 10)
        local odd1 = math.random(1, 10)
        local tier = 1
        if tierChance < 25 then tier = 1 elseif tierChance >= 25 and tierChance < 70 then tier = 2 elseif tierChance >= 70 and tierChance < 95 then tier = 3 else tier = 4 end
        if WeaponChance ~= odd1 then
            if tier ~= 4 then
                if Config.RewardTypes[itemType].type == "item" then
                    local item = Config.LockerRewardsMaze["tier"..tier][math.random(#Config.LockerRewardsMaze["tier"..tier])]
                    local itemAmount = math.random(item.maxAmount)

                    ply.Functions.AddItem(item.item, itemAmount)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], "add")
                elseif Config.RewardTypes[itemType].type == "money" then
                    local info = {
                        worth = math.random(15000, 20000)
                    }
                    ply.Functions.AddItem('markedbills', 1, false, info)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
                end
            else
                ply.Functions.AddItem('smg_ammo', 2)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['smg_ammo'], "add")
            end
        else
            ply.Functions.AddItem('weapon_bat', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weapon_bat'], "add")
        end
    elseif type == "pacific" then
        local itemType = math.random(#Config.RewardTypes)
        local WeaponChance = math.random(1, 100)
        local odd1 = math.random(1, 100)
        local odd2 = math.random(1, 100)
        local tierChance = math.random(1, 100)
        local tier = 1
        if tierChance < 10 then 
            tier = 1 
        elseif tierChance >= 25 and tierChance < 50 then 
            tier = 2 
        elseif tierChance >= 50 and tierChance < 95 then 
            tier = 3 
        else 
            tier = 4 
        end
        if WeaponChance ~= odd1 or WeaponChance ~= odd2 then
            if tier ~= 4 then
                if Config.RewardTypes[itemType].type == "item" then
                    local item = Config.LockerRewardsPacific["tier"..tier][math.random(#Config.LockerRewardsPacific["tier"..tier])]
                    local itemAmount = math.random(item.minAmount, item.maxAmount)

                    ply.Functions.AddItem(item.item, itemAmount)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[item.item], "add")
                elseif Config.RewardTypes[itemType].type == "money" then
                    local info = {
                        worth = math.random(30000, 40000)
                    }
                    ply.Functions.AddItem('markedbills', 1, false, info)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['markedbills'], "add")
                end
            else
                local info = {
                    crypto = math.random(3, 6)
                }
                ply.Functions.AddItem("cryptostick", 1, false, info)
                TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['cryptostick'], "add")
            end
        else
            local chance = math.random(1, 100)
            local odd = math.random(1, 100)
            if chance == odd then
                ply.Functions.AddItem('weapon_microsmg', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['weapon_microsmg'], "add")
            else
                ply.Functions.AddItem('weapon_minismg', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['weapon_minismg'], "add")
            end
        end
    end
end)

RSCore.Functions.CreateCallback('rs-bankrobbery:server:isRobberyActive', function(source, cb)
    cb(robberyBusy)
end)

RSCore.Functions.CreateCallback('rs-bankrobbery:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('rs-bankrobbery:server:setTimeout')
AddEventHandler('rs-bankrobbery:server:setTimeout', function()
    if not robberyBusy then
        if not timeOut then
            timeOut = true
            Citizen.CreateThread(function()
                Citizen.Wait(45 * (60 * 1000))
                timeOut = false
                robberyBusy = false
                TriggerEvent('rs-scoreboard:server:SetActivityBusy', "bankrobbery", false)
                TriggerEvent('rs-scoreboard:server:SetActivityBusy', "pacific", false)
                TriggerEvent('rs-scoreboard:server:SetActivityBusy', "maze", false)

                for k, v in pairs(Config.BigBanks["pacific"]["lockers"]) do
                    Config.BigBanks["pacific"]["lockers"][k]["isBusy"] = false
                    Config.BigBanks["pacific"]["lockers"][k]["isOpened"] = false
                end

                for k, v in pairs(Config.BigBanks["paleto"]["lockers"]) do
                    Config.BigBanks["paleto"]["lockers"][k]["isBusy"] = false
                    Config.BigBanks["paleto"]["lockers"][k]["isOpened"] = false
                end

                for k, v in pairs(Config.BigBanks["maze"]["lockers"]) do
                    Config.BigBanks["maze"]["lockers"][k]["isBusy"] = false
                    Config.BigBanks["maze"]["lockers"][k]["isOpened"] = false
                end

                for k, v in pairs(Config.BigBanks["maze"]["cabinets"]) do
                    Config.BigBanks["maze"]["cabinets"][k]["isBusy"] = false
                    Config.BigBanks["maze"]["cabinets"][k]["isOpened"] = false
                end

                TriggerClientEvent('rs-bankrobbery:client:ClearTimeoutDoors', -1)
                Config.BigBanks["paleto"]["isOpened"] = false
                Config.BigBanks["pacific"]["isOpened"] = false
                Config.BigBanks["maze"]["isOpened"] = false
            end)
        end
    end
end)

RegisterServerEvent('rs-bankrobbery:server:SetSmallbankTimeout')
AddEventHandler('rs-bankrobbery:server:SetSmallbankTimeout', function(BankId)
    if not robberyBusy then
        SetTimeout(45 * (60 * 1000), function()
            Config.SmallBanks[BankId]["isOpened"] = false
            for k, v in pairs(Config.SmallBanks[BankId]["lockers"]) do
                Config.SmallBanks[BankId]["lockers"][k]["isOpened"] = false
                Config.SmallBanks[BankId]["lockers"][k]["isBusy"] = false
            end
            timeOut = false
            robberyBusy = false
            TriggerClientEvent('rs-bankrobbery:client:ResetFleecaLockers', -1, BankId)
            TriggerEvent('rs-banking:server:SetBankClosed', BankId, false)
            TriggerEvent('rs-scoreboard:server:SetActivityBusy', "bankrobbery", false)
        end)
    end
end)

RegisterServerEvent('rs-bankrobbery:server:callCops')
AddEventHandler('rs-bankrobbery:server:callCops', function(type, bank, streetLabel, coords)
    local cameraId = 4
    local bankLabel = "Fleeca"
    local msg = ""
    if type == "small" then
        cameraId = Config.SmallBanks[bank]["camId"]
        bankLabel = "Fleeca"
        msg = "Poging bankoverval bij "..bankLabel.. " " ..streetLabel.." (CAMERA ID: "..cameraId..")"
    elseif type == "paleto" then
        cameraId = Config.BigBanks["paleto"]["camId"]
        bankLabel = "Blaine County Savings"
        msg = "Groot alarm! Poging bankoverval bij "..bankLabel.. " Paleto Bay (CAMERA ID: "..cameraId..")"
    elseif type == "maze" then
        bankLabel = "Maze Bank"
        msg = "Groot alarm! Poging bankoverval bij de "..bankLabel.. "(CAMERA ID: 35/36/37/38)"
    elseif type == "pacific" then
        bankLabel = "Pacific Standard Bank"
        msg = "Groot alarm! Poging bankoverval bij "..bankLabel.. " Alta St (CAMERA ID: 1/2/3)"
    end
    local alertData = {
        title = "Bankoverval",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("rs-bankrobbery:client:robberyCall", -1, type, bank, streetLabel, coords)
    TriggerClientEvent("rs-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('rs-bankrobbery:server:SetStationStatus')
AddEventHandler('rs-bankrobbery:server:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
    TriggerClientEvent("rs-bankrobbery:client:SetStationStatus", -1, key, isHit)
    if AllStationsHit() then
        TriggerEvent("rs-weathersync:server:toggleBlackout")
        TriggerClientEvent("police:client:DisableAllCameras", -1)
        TriggerClientEvent("rs-bankrobbery:client:disableAllBankSecurity", -1)
        blackoutActive = true
    else
        CheckStationHits()
    end
end)

RegisterServerEvent('thermite:StartServerFire')
AddEventHandler('thermite:StartServerFire', function(coords, maxChildren, isGasFire)
    TriggerClientEvent("thermite:StartFire", -1, coords, maxChildren, isGasFire)
end)

RegisterServerEvent('thermite:StopFires')
AddEventHandler('thermite:StopFires', function(coords, maxChildren, isGasFire)
    TriggerClientEvent("thermite:StopFires", -1)
end)

function CheckStationHits()
    if Config.PowerStations[1].hit and Config.PowerStations[2].hit and Config.PowerStations[3].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 19, false)
    end
    if Config.PowerStations[3].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 18, false)
        TriggerClientEvent("police:client:SetCamera", -1, 7, false)
    end
    if Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 4, false)
        TriggerClientEvent("police:client:SetCamera", -1, 8, false)
        TriggerClientEvent("police:client:SetCamera", -1, 5, false)
        TriggerClientEvent("police:client:SetCamera", -1, 6, false)
    end
    if Config.PowerStations[1].hit and Config.PowerStations[2].hit and Config.PowerStations[3].hit and Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 1, false)
        TriggerClientEvent("police:client:SetCamera", -1, 2, false)
        TriggerClientEvent("police:client:SetCamera", -1, 3, false)
    end
    if Config.PowerStations[7].hit and Config.PowerStations[8].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 9, false)
        TriggerClientEvent("police:client:SetCamera", -1, 10, false)
    end
    if Config.PowerStations[9].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 11, false)
        TriggerClientEvent("police:client:SetCamera", -1, 12, false)
        TriggerClientEvent("police:client:SetCamera", -1, 13, false)
    end
    if Config.PowerStations[9].hit and Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 14, false)
        TriggerClientEvent("police:client:SetCamera", -1, 17, false)
        TriggerClientEvent("police:client:SetCamera", -1, 19, false)
    end
    if Config.PowerStations[7].hit and Config.PowerStations[9].hit and Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 15, false)
        TriggerClientEvent("police:client:SetCamera", -1, 16, false)
    end
    if Config.PowerStations[10].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 20, false)
    end
    if Config.PowerStations[11].hit and Config.PowerStations[1].hit and Config.PowerStations[2].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 21, false)
        TriggerClientEvent("rs-bankrobbery:client:BankSecurity", 1, false)
        TriggerClientEvent("police:client:SetCamera", -1, 22, false)
        TriggerClientEvent("rs-bankrobbery:client:BankSecurity", 2, false)
    end
    if Config.PowerStations[8].hit and Config.PowerStations[4].hit and Config.PowerStations[5].hit and Config.PowerStations[6].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 23, false)
        TriggerClientEvent("rs-bankrobbery:client:BankSecurity", 3, false)
    end
    if Config.PowerStations[12].hit and Config.PowerStations[13].hit then
        TriggerClientEvent("police:client:SetCamera", -1, 24, false)
        TriggerClientEvent("rs-bankrobbery:client:BankSecurity", 4, false)
        TriggerClientEvent("police:client:SetCamera", -1, 25, false)
        TriggerClientEvent("rs-bankrobbery:client:BankSecurity", 5, false)
    end
end

function AllStationsHit()
    local retval = true
    for k, v in pairs(Config.PowerStations) do
        if not Config.PowerStations[k].hit then
            retval = false
        end
    end
    return retval
end

RSCore.Functions.CreateUseableItem("thermite", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('lighter') ~= nil then
        TriggerClientEvent("thermite:UseThermite", source)
    else
        TriggerClientEvent('RSCore:Notify', source, "Je mist iets om het mee te vlammen..", "error")
    end
end)

RSCore.Functions.CreateUseableItem("explosive", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('lighter') ~= nil then
        TriggerClientEvent("explosive:UseExplosive", source)
    else
        TriggerClientEvent('RSCore:Notify', source, "Je mist iets om het mee te vlammen..", "error")
    end
end)

RSCore.Functions.CreateUseableItem("security_card_01", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('security_card_01') ~= nil then
        TriggerClientEvent("rs-bankrobbery:UseBankcardA", source)
    end
end)

RSCore.Functions.CreateUseableItem("security_card_02", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemByName('security_card_02') ~= nil then
        TriggerClientEvent("rs-bankrobbery:UseBankcardB", source)
    end
end)

RegisterServerEvent('rs-bankrobbery:maze:server:DoSmokePfx')
AddEventHandler('rs-bankrobbery:maze:server:DoSmokePfx', function()
    TriggerClientEvent('rs-bankrobbery:maze:client:DoSmokePfx', -1)
end)