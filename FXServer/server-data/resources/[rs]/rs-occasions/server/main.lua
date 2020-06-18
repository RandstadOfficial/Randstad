RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RSCore.Functions.CreateCallback('rs-occasions:server:getVehicles', function(source, cb)
    RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `occasion_vehicles`', function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RSCore.Functions.CreateCallback("rs-occasions:server:getSellerInformation", function(source, cb, citizenid)
    local src = source

    exports['ghmattimysql']:execute('SELECT * FROM players WHERE citizenid = @citizenid', {['@citizenid'] = citizenid}, function(result)
        if result[1] ~= nil then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('rs-occasions:server:ReturnVehicle')
AddEventHandler('rs-occasions:server:ReturnVehicle', function(vehicleData)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."' AND `occasionId` = '"..vehicleData["oid"].."'", function(result)
        if result[1] ~= nil then 
            if result[1].seller == Player.PlayerData.citizenid then
                RSCore.Functions.ExecuteSql(true, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicleData["model"].."', '"..GetHashKey(vehicleData["model"]).."', '"..vehicleData["mods"].."', '"..vehicleData["plate"].."', '0')")
                RSCore.Functions.ExecuteSql(true, "DELETE FROM `occasion_vehicles` WHERE `occasionId` = '"..vehicleData["oid"].."'")
                TriggerClientEvent("rs-occasions:client:ReturnOwnedVehicle", src, result[1].mods)
                TriggerClientEvent('rs-occasion:client:refreshVehicles', -1)
            else
                TriggerClientEvent('RSCore:Notify', src, 'Dit is niet jouw voertuig...', 'error', 3500)
            end
        else
            TriggerClientEvent('RSCore:Notify', src, 'Voertuig bestaat niet...', 'error', 3500)
        end
    end)
end)

RegisterServerEvent('rs-occasions:server:sellVehicle')
AddEventHandler('rs-occasions:server:sellVehicle', function(vehiclePrice, vehicleData)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    RSCore.Functions.ExecuteSql(true, "DELETE FROM `player_vehicles` WHERE `plate` = '"..vehicleData.plate.."' AND `vehicle` = '"..vehicleData.model.."'")
    RSCore.Functions.ExecuteSql(true, "INSERT INTO `occasion_vehicles` (`seller`, `price`, `description`, `plate`, `model`, `mods`, `occasionId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..vehiclePrice.."', '"..escapeSqli(vehicleData.desc).."', '"..vehicleData.plate.."', '"..vehicleData.model.."', '"..json.encode(vehicleData.mods).."', '"..generateOID().."')")
    
    TriggerEvent("rs-log:server:sendLog", Player.PlayerData.citizenid, "vehiclesold", {model=vehicleData.model, vehiclePrice=vehiclePrice})
    TriggerEvent("rs-log:server:CreateLog", "vehicleshop", "Voertuig te koop", "red", "**"..GetPlayerName(src) .. "** heeft een " .. vehicleData.model .. " te koop gezet voor "..vehiclePrice)

    TriggerClientEvent('rs-occasion:client:refreshVehicles', -1)
end)

RegisterServerEvent('rs-occasions:server:buyVehicle')
AddEventHandler('rs-occasions:server:buyVehicle', function(vehicleData)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    local ownerCid = vehicleData['owner']

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."' AND `occasionId` = '"..vehicleData["oid"].."'", function(result)
        local bankAmount = Player.PlayerData.money["bank"]
        local cashAmount = Player.PlayerData.money["cash"]
        if result[1] ~= nil then 
            if cashAmount >= result[1].price then
                RSCore.Functions.ExecuteSql(true, "DELETE FROM `occasion_vehicles` WHERE `occasionId` = '"..vehicleData["oid"].."'")
                print("gaat nog goed")
                TriggerClientEvent('rs-occasions:client:DeleteVehicle', src)
                RSCore.Functions.ExecuteSql(true, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicleData["model"].."', '"..GetHashKey(vehicleData["model"]).."', '"..vehicleData["mods"].."', '"..vehicleData["plate"].."', '0')")               
                Player.Functions.RemoveMoney('cash', result[1].price)
                TriggerClientEvent('rs-occasions:client:BuyFinished', src, result[1].mods)
                RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE citizenid = '"..result[1].seller.."'", function(player)
                    print("player citizenid: "..player[1].citizenid)
                    local recieverSteam = RSCore.Functions.GetPlayerByCitizenId(player[1].citizenid)
                    --player1.citizenid is wrs leeg.
            
                    if recieverSteam ~= nil then
                        recieverSteam.Functions.AddMoney('bank', math.ceil((result[1].price / 100) * 77))
                        TriggerClientEvent('rs-phone:client:newMailNotify', recieverSteam.PlayerData.source, {
                            sender = "Mosleys Occasions",
                            subject = "Uw voertuig is verkocht!",
                            message = "Je "..RSCore.Shared.Vehicles[vehicleData["model"]].name.." is verkocht voor €"..result[1].price..",-!"
                        })
                    else
                        local moneyInfo = json.decode(player[1].money)
                        moneyInfo.bank = math.ceil((moneyInfo.bank + (result[1].price / 100) * 77))
                        RSCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..player[1].citizenid.."'")
                    end
                    TriggerEvent('rs-phone:server:sendNewMailToOffline', player[1].citizenid, {
                        sender = "Mosleys Occasions",
                        subject = "U heeft een voertuig verkocht!",
                        message = "Je "..RSCore.Shared.Vehicles[vehicleData["model"]].name.." is verkocht voor €"..result[1].price..",-!"
                    })
                    TriggerEvent("rs-log:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model=vehicleData["model"], from=result[1].citizenid, moneyType="cash", vehiclePrice=result[1].price, plate=result[1].plate})
                    TriggerEvent("rs-log:server:CreateLog", "vehicleshop", "Occasion gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een occasian gekocht voor "..result[1].price .. " (" .. result[1].plate .. ") van **"..player[1].citizenid.."**")
                    TriggerClientEvent('rs-occasion:client:refreshVehicles', -1)
                end)
            elseif bankAmount >= result[1].price then
                Player.Functions.RemoveMoney('bank', result[1].price, "occasions-bought-vehicle")
                RSCore.Functions.ExecuteSql(true, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicleData["model"].."', '"..GetHashKey(vehicleData["model"]).."', '"..vehicleData["mods"].."', '"..vehicleData["plate"].."', '0')")
                RSCore.Functions.ExecuteSql(true, "DELETE FROM `occasion_vehicles` WHERE `occasionId` = '"..vehicleData["oid"].."'")
                TriggerClientEvent('rs-occasions:client:BuyFinished', src, result[1].model, result[1].plate, result[1].mods)
        
                RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE citizenid = '"..ownerCid.."'", function(player)
                    local recieverSteam = RSCore.Functions.GetPlayerByCitizenId(player[1].citizenid)
            
                    if recieverSteam ~= nil then
                        recieverSteam.Functions.AddMoney('bank', math.ceil((result[1].price / 100) * 77))
                        TriggerClientEvent('rs-phone:client:newMailNotify', recieverSteam.PlayerData.source, {
                            sender = "Mosleys Occasions",
                            subject = "Uw voertuig is verkocht!",
                            message = "Je "..RSCore.Shared.Vehicles[vehicleData["model"]].name.." is verkocht voor €"..result[1].price..",-!"
                        })
                    else
                        local moneyInfo = json.decode(player[1].money)
                        moneyInfo.bank = math.ceil((moneyInfo.bank + (result[1].price / 100) * 77))
                        RSCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..player[1].citizenid.."'")
                    end
                    TriggerEvent('rs-phone:server:sendNewMailToOffline', player[1].citizenid, {
                        sender = "Mosleys Occasions",
                        subject = "U heeft een voertuig verkocht!",
                        message = "Je "..RSCore.Shared.Vehicles[vehicleData["model"]].name.." is verkocht voor €"..result[1].price..",-!"
                    })
                    TriggerEvent("rs-log:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model=vehicleData["model"], from=player[1].citizenid, moneyType="bank", vehiclePrice=result[1].price, plate=result[1].plate})
                    TriggerEvent("rs-log:server:CreateLog", "vehicleshop", "Occasion gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een occasian gekocht voor "..result[1].price .. " (" .. result[1].plate .. ") van **"..player[1].citizenid.."**")
                    TriggerClientEvent('rs-occasion:client:refreshVehicles', -1)
                end)
            else
                TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet voldoende geld...', 'error', 3500)
            end
        else
            TriggerClientEvent('RSCore:Notify', src, 'Voertuig bestaat niet...', 'error', 3500)
        end
    end)
end)

function generateOID()
    local num = math.random(1, 10)..math.random(111, 999)

    return "OC"..num
end

function round(number)
    return number - (number % 1)
end

function escapeSqli(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end