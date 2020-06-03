RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RegisterServerEvent('rs-diving:server:SetBerthVehicle')
AddEventHandler('rs-diving:server:SetBerthVehicle', function(BerthId, vehicleModel)
    TriggerClientEvent('rs-diving:client:SetBerthVehicle', -1, BerthId, vehicleModel)
    
    RSBoatshop.Locations["berths"][BerthId]["boatModel"] = boatModel
end)

RegisterServerEvent('rs-diving:server:SetDockInUse')
AddEventHandler('rs-diving:server:SetDockInUse', function(BerthId, InUse)
    RSBoatshop.Locations["berths"][BerthId]["inUse"] = InUse
    TriggerClientEvent('rs-diving:client:SetDockInUse', -1, BerthId, InUse)
end)

RSCore.Functions.CreateCallback('rs-diving:server:GetBusyDocks', function(source, cb)
    cb(RSBoatshop.Locations["berths"])
end)

RegisterServerEvent('rs-diving:server:BuyBoat')
AddEventHandler('rs-diving:server:BuyBoat', function(boatModel, BerthId)
    local BoatPrice = RSBoatshop.ShopBoats[boatModel]["price"]
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local PlayerMoney = {
        cash = Player.PlayerData.money.cash,
        bank = Player.PlayerData.money.bank,
    }
    local missingMoney = 0
    local plate = "RANDSTAD"..math.random(1111, 9999)

    if PlayerMoney.cash >= BoatPrice then
        Player.Functions.RemoveMoney('cash', BoatPrice, "bought-boat")
        TriggerClientEvent('rs-diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    elseif PlayerMoney.bank >= BoatPrice then
        Player.Functions.RemoveMoney('bank', BoatPrice, "bought-boat")
        TriggerClientEvent('rs-diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    else
        if PlayerMoney.bank > PlayerMoney.cash then
            missingMoney = (BoatPrice - PlayerMoney.bank)
        else
            missingMoney = (BoatPrice - PlayerMoney.cash)
        end
        TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet voldoende geld, je mist €'..missingMoney, 'error', 4000)
    end
end)

function InsertBoat(boatModel, Player, plate)
    RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_boats` (`citizenid`, `model`, `plate`) VALUES ('"..Player.PlayerData.citizenid.."', '"..boatModel.."', '"..plate.."')")
end

RSCore.Functions.CreateUseableItem("jerry_can", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)

    TriggerClientEvent("rs-diving:client:UseJerrycan", source)
end)

RSCore.Functions.CreateUseableItem("diving_gear", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)

    TriggerClientEvent("rs-diving:client:UseGear", source, true)
end)

RegisterServerEvent('rs-diving:server:RemoveItem')
AddEventHandler('rs-diving:server:RemoveItem', function(item, amount)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(item, amount)
end)

RSCore.Functions.CreateCallback('rs-diving:server:GetMyBoats', function(source, cb, dock)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_boats` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `boathouse` = '"..dock.."'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RSCore.Functions.CreateCallback('rs-diving:server:GetDepotBoats', function(source, cb, dock)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_boats` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `state` = '0'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('rs-diving:server:SetBoatState')
AddEventHandler('rs-diving:server:SetBoatState', function(plate, state, boathouse)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_boats` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            RSCore.Functions.ExecuteSql(false, "UPDATE `player_boats` SET `state` = '"..state.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
    
            if state == 1 then
                RSCore.Functions.ExecuteSql(false, "UPDATE `player_boats` SET `boathouse` = '"..boathouse.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
            end
        end
    end)
end)

RegisterServerEvent('rs-diving:server:CallCops')
AddEventHandler('rs-diving:server:CallCops', function(Coords)
    local src = source
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                local msg = "Er word mogelijk koraal gestolen!"
                TriggerClientEvent('rs-diving:client:CallCops', Player.PlayerData.source, Coords, msg)
                local alertData = {
                    title = "Illegaalduiken",
                    coords = {x = Coords.x, y = Coords.y, z = Coords.z},
                    description = msg,
                }
                TriggerClientEvent("rs-phone:client:addPoliceAlert", -1, alertData)
            end
        end
	end
end)

local AvailableCoral = {}

RSCore.Commands.Add("duikpak", "Trek je duikpak uit", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("rs-diving:client:UseGear", source, false)
end)

RegisterServerEvent('rs-diving:server:SellCoral')
AddEventHandler('rs-diving:server:SellCoral', function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    if HasCoral(src) then
        for k, v in pairs(AvailableCoral) do
            local Item = Player.Functions.GetItemByName(v.item)
            local price = (Item.amount * v.price)
            local Reward = math.ceil(GetItemPrice(Item, price))

            if Item.amount > 1 then
                for i = 1, Item.amount, 1 do
                    Player.Functions.RemoveItem(Item.name, 1)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[Item.name], "remove")
                    Player.Functions.AddMoney('cash', math.ceil((Reward / Item.amount)), "sold-coral")
                    Citizen.Wait(250)
                end
            else
                Player.Functions.RemoveItem(Item.name, 1)
                Player.Functions.AddMoney('cash', Reward, "sold-coral")
                TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[Item.name], "remove")
            end
        end
    else
        TriggerClientEvent('RSCore:Notify', src, 'Je hebt geen koraal om te verkopen..', 'error')
    end
end)

function GetItemPrice(Item, price)
    if Item.amount > 5 then
        price = price / 100 * 80
    elseif Item.amount > 10 then
        price = price / 100 * 70
    elseif Item.amount > 15 then
        price = price / 100 * 50
    end
    return price
end

function HasCoral(src)
    local Player = RSCore.Functions.GetPlayer(src)
    local retval = false
    AvailableCoral = {}

    for k, v in pairs(RSDiving.CoralTypes) do
        local Item = Player.Functions.GetItemByName(v.item)
        if Item ~= nil then
            table.insert(AvailableCoral, v)
            retval = true
        end
    end
    return retval
end