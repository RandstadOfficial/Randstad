RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local GeneratedPlates = {}

local callId = 501

local Adverts = {}

Citizen.CreateThread(function()
    RSCore.Functions.ExecuteSql(false, 'DELETE FROM `phone_tweets`')
    print('Tweets have been cleared')
end)

RegisterServerEvent('rs-phone:server:setPhoneMeta')
AddEventHandler('rs-phone:server:setPhoneMeta', function(phoneMeta)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    Player.Functions.SetMetaData("phone", phoneMeta)
end)

RegisterServerEvent('rs-phone:server:transferBank')
AddEventHandler('rs-phone:server:transferBank', function(amount, iban)
    local src = source
    local sender = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..iban.."%'", function(result)
        if result[1] ~= nil then
            local recieverSteam = RSCore.Functions.GetPlayerByCitizenId(result[1].citizenid)

            if recieverSteam ~= nil then
                recieverSteam.Functions.AddMoney('bank', amount, "phone-transfered-from-"..sender.PlayerData.citizenid)
                sender.Functions.RemoveMoney('bank', amount, "phone-transfered-money-to-"..recieverSteam.PlayerData.citizenid)
                TriggerClientEvent('rs-phone:client:RecievedBankNotify', recieverSteam.PlayerData.source, amount, sender.PlayerData.charinfo.account)
            else
                local moneyInfo = json.decode(result[1].money)
                moneyInfo.bank = round((moneyInfo.bank + amount))
                RSCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
                sender.Functions.RemoveMoney('bank', amount, "phone-transfered-money")
            end
        else
            TriggerClientEvent('RSCore:Notify', src, "Dit rekeningnummer bestaat niet!", "error")
        end
    end)
end)

function round(number)
    return number - (number % 1)
end

RSCore.Functions.CreateCallback('rs-phone:server:getUserContacts', function(source, cb)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local playerContacts = {}
    if Player ~= nil then 
        RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_contacts` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' ORDER BY `name` ASC", function(result)
            if result[1] ~= nil then
                for i = 1, (#result), 1 do
                    local status = false
                    RSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..result[i].number.."%'", function(player)
                        for i=1, (#player), 1 do
                            local ply = RSCore.Functions.GetPlayerByCitizenId(player[i].citizenid)
                            if ply then
                                status = true
                            end
                        end
                        table.insert(playerContacts, {
                            name = result[i].name,
                            number = result[i].number,
                            status = status,
                        })
                    end)
                end
            end
            cb(playerContacts)
        end)
    end
end)

RegisterServerEvent('rs-phone:server:addContact')
AddEventHandler('rs-phone:server:addContact', function(name, number)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_contacts` (`citizenid`, `name`, `number`) VALUES ('"..Player.PlayerData.citizenid.."', '"..name.."', '"..number.."')")
end)

RegisterServerEvent('rs-phone:server:editContact')
AddEventHandler('rs-phone:server:editContact', function(oName, oNum, nName, nNum)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "UPDATE `player_contacts` SET `name` = '"..nName.."', `number` = '"..nNum.."' WHERE `name` = '"..oName.."' AND `number` = '"..oNum.."'")
end)

RSCore.Functions.CreateCallback("rs-phone:server:GetAllUserVehicles", function(source, cb, garage)
    local src = source
    local pData = RSCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE citizenid = @citizenid', {['@citizenid'] = pData.PlayerData.citizenid}, function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RSCore.Functions.CreateCallback("rs-phone:server:GetUserMails", function(source, cb)
    local src = source
    local pData = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..pData.PlayerData.citizenid..'" ORDER BY `date` DESC', function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                if result[k].button ~= nil then
                    result[k].button = json.decode(result[k].button)
                end
            end
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RSCore.Functions.CreateCallback("rs-phone:server:getPhoneAds", function(source, cb)
    local src = source
    local pData = RSCore.Functions.GetPlayer(src)

    if Adverts ~= nil and next(Adverts) then
        cb(Adverts)
    else
        cb(nil)
    end
end)

RSCore.Functions.CreateCallback("rs-phone:server:getPhoneTweets", function(source, cb)
    local src = source
    local pData = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `phone_tweets` ORDER BY `date` DESC', function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('rs-phone:server:setEmailRead')
AddEventHandler('rs-phone:server:setEmailRead', function(mailId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    print(mailId)

    RSCore.Functions.ExecuteSql(false, 'UPDATE `player_mails` SET `read` = "1" WHERE `mailid` = "'..mailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
end)

RegisterServerEvent('rs-phone:server:clearButtonData')
AddEventHandler('rs-phone:server:clearButtonData', function(mailId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, 'UPDATE `player_mails` SET `button` = "" WHERE `mailid` = "'..mailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
end)

RegisterServerEvent('rs-phone:server:removeMail')
AddEventHandler('rs-phone:server:removeMail', function(mailId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, 'DELETE FROM `player_mails` WHERE `mailid` = "'..mailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
end)

RegisterServerEvent('rs-phone:server:sendNewMail')
AddEventHandler('rs-phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    if mailData.button == nil then
        RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
        TriggerClientEvent('rs-phone:client:newMailNotify', src, mailData)
    else
        RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
        TriggerClientEvent('rs-phone:client:newMailNotify', src, mailData)
    end
end)

RegisterServerEvent('rs-phone:server:sendNewMailToOffline')
AddEventHandler('rs-phone:server:sendNewMailToOffline', function(citizenid, mailData)
    local Player = RSCore.Functions.GetPlayerByCitizenId(citizenid)

    if Player ~= nil then
        local src = Player.PlayerData.source

        if mailData.button == nil then
            RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
            TriggerClientEvent('rs-phone:client:newMailNotify', src, mailData)
        else
            RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
            TriggerClientEvent('rs-phone:client:newMailNotify', src, mailData)
        end
    else
        if mailData.button == nil then
            RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
        else
            RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
        end
    end
end)

RegisterServerEvent('rs-phone:server:sendNewEventMail')
AddEventHandler('rs-phone:server:sendNewEventMail', function(citizenid, mailData)
    if mailData.button == nil then
        RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
        --TriggerClientEvent('rs-phone:client:newMailNotify', src, mailData)
    else
        RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
        --TriggerClientEvent('rs-phone:client:newMailNotify', src, mailData)
    end
end)

RegisterServerEvent('rs-phone:server:postTweet')
AddEventHandler('rs-phone:server:postTweet', function(message)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    
    RSCore.Functions.ExecuteSql(false, "INSERT INTO `phone_tweets` (`citizenid`, `sender`, `message`) VALUES ('"..Player.PlayerData.citizenid.."', '"..Player.PlayerData.charinfo.firstname.." "..string.sub(Player.PlayerData.charinfo.lastname, 1, 1):upper()..".', '"..message.."')")
    TriggerClientEvent('rs-phone:client:newTweet', -1, Player.PlayerData.charinfo.firstname.." "..string.sub(Player.PlayerData.charinfo.lastname, 1, 1):upper()..".", message)
end)

RegisterServerEvent('rs-phone:server:postAdvert')
AddEventHandler('rs-phone:server:postAdvert', function(message)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    Adverts[Player.PlayerData.citizenid] = {
        message = message,
        phone = Player.PlayerData.charinfo.phone,
        name = Player.PlayerData.charinfo.firstname .." "..Player.PlayerData.charinfo.lastname,
    }
    TriggerClientEvent('rs-phone:client:newAd', -1, Player.PlayerData.charinfo.firstname .." "..Player.PlayerData.charinfo.lastname, message)
end)

function GenerateMailId()
    return math.random(111111, 999999)
end

function convertDate(vardate)
    local y,m,d,h,i,s = string.match(vardate, '(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)')
    return string.format('%s/%s/%s %s:%s:%s', d,m,y,h,i,s)
end

RSCore.Functions.CreateCallback('rs-phone:server:getContactName', function(source, cb, number)
    local src = source
    local plyCid = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, 'SELECT `name` FROM `player_contacts` WHERE `citizenid` = "'..plyCid.PlayerData.citizenid..'" AND `number` = "'..number..'"', function(result)
        if result[1] ~= nil then
            cb(result[1].name)
        else
            cb(nil)
        end
    end)
end)

RSCore.Functions.CreateCallback('rs-phone:server:getSearchData', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `players` WHERE `citizenid` = "'..search..'" OR `charinfo` LIKE "%'..search..'%"', function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local charinfo = json.decode(v.charinfo)
                local metadata = json.decode(v.metadata)
                table.insert(searchData, {
                    citizenid = v.citizenid,
                    firstname = charinfo.firstname,
                    lastname = charinfo.lastname,
                    birthdate = charinfo.birthdate,
                    phone = charinfo.phone,
                    nationality = charinfo.nationality,
                    gender = charinfo.gender,
                    warrant = false,
                    driverlicense = metadata["licences"]["driver"]
                })
            end
            cb(searchData)
        else
            cb(nil)
        end
    end)
end)

RSCore.Functions.CreateCallback('rs-phone:server:getVehicleSearch', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_vehicles` WHERE `plate` LIKE "%'..search..'%" OR `citizenid` = "'..search..'"', function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                RSCore.Functions.ExecuteSql(true, 'SELECT * FROM `players` WHERE `citizenid` = "'..result[k].citizenid..'"', function(player)
                    if player[1] ~= nil then 
                        local charinfo = json.decode(player[1].charinfo)
                        local vehicleInfo = RSCore.Shared.VehicleModels[GetHashKey(result[k].vehicle)]
                        if vehicleInfo ~= nil then 
                            table.insert(searchData, {
                                plate = result[k].plate,
                                status = true,
                                owner = charinfo.firstname .. " " .. charinfo.lastname,
                                citizenid = result[k].citizenid,
                                label = vehicleInfo["brand"] .. " " .. vehicleInfo["name"]
                            })
                        else
                            table.insert(searchData, {
                                plate = result[k].plate,
                                status = true,
                                owner = charinfo.firstname .. " " .. charinfo.lastname,
                                citizenid = result[k].citizenid,
                                label = "Naam niet gevonden.."
                            })
                        end
                    end
                end)
            end
        else
            if GeneratedPlates[search] ~= nil then
                table.insert(searchData, {
                    plate = GeneratedPlates[search].plate,
                    status = GeneratedPlates[search].status,
                    owner = GeneratedPlates[search].owner,
                    citizenid = GeneratedPlates[search].citizenid,
                    label = "Merk niet bekend.."
                })
            else
                local ownerInfo = GenerateOwnerName()
                GeneratedPlates[search] = {
                    plate = search,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
                table.insert(searchData, {
                    plate = search,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                    label = "Merk niet bekend.."
                })
            end
        end
        cb(searchData)
    end)
end)

RSCore.Functions.CreateCallback('rs-phone:server:getVehicleData', function(source, cb, plate)
    local src = source
    local vehicleData = {}
    if plate ~= nil then 
        RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_vehicles` WHERE `plate` = "'..plate..'"', function(result)
            if result[1] ~= nil then
                RSCore.Functions.ExecuteSql(true, 'SELECT * FROM `players` WHERE `citizenid` = "'..result[1].citizenid..'"', function(player)
                    local charinfo = json.decode(player[1].charinfo)
                    vehicleData = {
                        plate = plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[1].citizenid,
                    }
                end)
            elseif GeneratedPlates ~= nil and GeneratedPlates[plate] ~= nil then 
                vehicleData = GeneratedPlates[plate]
            else
                local ownerInfo = GenerateOwnerName()
                GeneratedPlates[plate] = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
                vehicleData = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
            end
            cb(vehicleData)
        end)
    else
        TriggerClientEvent('RSCore:Notify', src, "Geen voertuig in de buurt..", "error")
        cb(nil)
    end
end)

function GenerateOwnerName()
    local names = {
        [1] = { name = "Jan Bloksteen", citizenid = "DSH091G93" },
        [2] = { name = "Jay Dendam", citizenid = "AVH09M193" },
        [3] = { name = "Ben Klaariskees", citizenid = "DVH091T93" },
        [4] = { name = "Karel Bakker", citizenid = "GZP091G93" },
        [5] = { name = "Klaas Adriaan", citizenid = "DRH09Z193" },
        [6] = { name = "Nico Wolters", citizenid = "KGV091J93" },
        [7] = { name = "Mark Hendrickx", citizenid = "ODF09S193" },
        [8] = { name = "Bert Johannes", citizenid = "KSD0919H3" },
        [9] = { name = "Karel de Grote", citizenid = "NDX091D93" },
        [10] = { name = "Jan Pieter", citizenid = "ZAL0919X3" },
        [11] = { name = "Huig Roelink", citizenid = "ZAK09D193" },
        [12] = { name = "Corneel Boerselman", citizenid = "POL09F193" },
        [13] = { name = "Hermen Klein Overmeen", citizenid = "TEW0J9193" },
        [14] = { name = "Bart Rielink", citizenid = "YOO09H193" },
        [15] = { name = "Antoon Henselijn", citizenid = "ELC091H93" },
        [16] = { name = "Aad Keizer", citizenid = "YDN091H93" },
        [17] = { name = "Thijn Kiel", citizenid = "PJD09D193" },
        [18] = { name = "Henkie Krikhaar", citizenid = "RND091D93" },
        [19] = { name = "Teun Blaauwkamp", citizenid = "QWE091A93" },
        [20] = { name = "Dries Stielstra", citizenid = "KJH0919M3" },
        [21] = { name = "Karlijn Hensbergen", citizenid = "ZXC09D193" },
        [22] = { name = "Aafke van Daalen", citizenid = "XYZ0919C3" },
        [23] = { name = "Door Leeferds", citizenid = "ZYX0919F3" },
        [24] = { name = "Nelleke Broedersen", citizenid = "IOP091O93" },
        [25] = { name = "Renske de Raaf", citizenid = "PIO091R93" },
        [26] = { name = "Krisje Moltman", citizenid = "LEK091X93" },
        [27] = { name = "Mirre Steevens", citizenid = "ALG091Y93" },
        [28] = { name = "Joosje Kalvenhaar", citizenid = "YUR09E193" },
        [29] = { name = "Mirte Ellenbroek", citizenid = "SOM091W93" },
        [30] = { name = "Marlieke Meilink", citizenid = "KAS09193" },
    }
    return names[math.random(1, #names)]
end

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end

RSCore.Functions.CreateCallback('rs-phone:server:getContactStatus', function(source, cb, number)
    local src = source
    local plyCid = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `players` WHERE `charinfo` LIKE "%'..number..'%"', function(result)
        local target = result[1]

        if target ~= nil then
            local trgt = RSCore.Functions.GetPlayerByCitizenId(target.citizenid)
            if trgt ~= nil then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('rs-phone:server:createChat')
AddEventHandler('rs-phone:server:createChat', function(messages)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(true, "INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..ply.PlayerData.citizenid.."', '"..messages.number.."', '"..json.encode(messages.messages).."')")

    if messages.number ~= ply.PlayerData.charinfo.phone then
        RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..messages.number.."%'", function(target)
            local targetPly = RSCore.Functions.GetPlayerByCitizenId(target[1].citizenid)

            if targetPly ~= nil then
                TriggerClientEvent('rs-phone:client:createChatOther', targetPly.PlayerData.source, messages, ply.PlayerData.charinfo.phone)
            else
                RSCore.Functions.ExecuteSql(true, "INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..target[1].citizenid.."', '"..ply.PlayerData.charinfo.phone.."', '"..json.encode(messages.messages).."')")
            end
        end)
    end
end)


RegisterServerEvent('rs-phone:server:giveNumber')
AddEventHandler('rs-phone:server:giveNumber', function(targetId, playerData)
    TriggerClientEvent('rs-phone:server:newContactNotify', targetId, playerData.charinfo.phone)
end)

RegisterServerEvent('rs-phone:server:giveBankAccount')
AddEventHandler('rs-phone:server:giveBankAccount', function(targetId, playerData)
    TriggerClientEvent('rs-phone:server:newBankNotify', targetId, playerData.charinfo.account)
end)

RegisterServerEvent('rs-phone:server:createChatOther')
AddEventHandler('rs-phone:server:createChatOther', function(chatData, senderPhone)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..ply.PlayerData.citizenid.."', '"..senderPhone.."', '"..json.encode(chatData.messages).."')")
    
    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_contacts` WHERE `citizenid` = '"..ply.PlayerData.citizenid.."' AND `number` = '"..senderPhone.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent('rs-phone:client:msgNotify', src, 'Je hebt een bericht ontvangen van '..result[1].name, result[1].name)
        else
            TriggerClientEvent('rs-phone:client:msgNotify', src, 'Je hebt een bericht ontvangen van '..senderPhone, senderPhone)
        end
    end)
end)

RegisterServerEvent('rs-phone:server:sendMessage')
AddEventHandler('rs-phone:server:sendMessage', function(chatData)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)
    RSCore.Functions.ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = '"..json.encode(chatData.messages).."' WHERE `citizenid` = '"..ply.PlayerData.citizenid.."' AND `number` = '"..chatData.number.."'")
    
    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..chatData.number.."%'", function(target)
        local targetPly = RSCore.Functions.GetPlayerByCitizenId(target[1].citizenid)

        if targetPly ~= nil then
            TriggerClientEvent('rs-phone:client:recieveMessage', targetPly.PlayerData.source, chatData, ply.PlayerData.charinfo.phone)
        else
            RSCore.Functions.ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = '"..json.encode(chatData.messages).."' WHERE `citizenid` = '"..target[1].citizenid.."' AND `number` = '"..ply.PlayerData.charinfo.phone.."'")
        end
    end)
end)

RegisterServerEvent('rs-phone:server:recieveMessage')
AddEventHandler('rs-phone:server:recieveMessage', function(chatData, senderPhone)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = '"..json.encode(chatData.messages).."' WHERE `citizenid` = '"..ply.PlayerData.citizenid.."' AND `number` = '"..senderPhone.."'")

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_contacts` WHERE `citizenid` = '"..ply.PlayerData.citizenid.."' AND `number` = '"..senderPhone.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent('rs-phone:client:msgNotify', src, 'Je hebt een bericht ontvangen van '..result[1].name, result[1].name)
        else
            TriggerClientEvent('rs-phone:client:msgNotify', src, 'Je hebt een bericht ontvangen van '..senderPhone, senderPhone)
        end
    end)
end)

RegisterServerEvent('rs-phone:server:removeContact')
AddEventHandler('rs-phone:server:removeContact', function(name, number)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "DELETE FROM `player_contacts` WHERE `name` = '"..name.."' AND `number` = '"..number.."'")
end)

RSCore.Functions.CreateCallback('rs-phone:server:getPlayerMessages', function(source, cb)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_messages` WHERE `citizenid` = '"..ply.PlayerData.citizenid.."'", function(result)
        for k, v in pairs(result) do
            result[k].messages = json.decode(result[k].messages)
        end
        cb(result)
    end)
end)

RegisterServerEvent('rs-phone:server:CallContact')
AddEventHandler('rs-phone:server:CallContact', function(callData, caller, anonymous)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..callData.number.."%'", function(result)
        if result[1] ~= nil then
            local target = result[1]
            local targetPlayer = RSCore.Functions.GetPlayerByCitizenId(target.citizenid)

            if targetPlayer ~= nil then
                if anonymous then
                    TriggerClientEvent('rs-phone:client:IncomingCall', targetPlayer.PlayerData.source, callData, "Anoniem")
                else
                    TriggerClientEvent('rs-phone:client:IncomingCall', targetPlayer.PlayerData.source, callData, caller)
                end
            end
        end
    end)
end)

RegisterServerEvent('rs-phone:server:addPoliceAlert')
AddEventHandler('rs-phone:server:addPoliceAlert', function(alertData)
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("rs-phone:client:addPoliceAlert", Player.PlayerData.source, alertData)
            end
        end
	end
end)

RSCore.Commands.Add("opnemen", "Inkomend oproep beantwoorden", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
	TriggerClientEvent('rs-phone:client:AnswerCall', source)
end)


RegisterServerEvent('rs-phone:server:AnswerCall')
AddEventHandler('rs-phone:server:AnswerCall', function(callData)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..callData.number.."%'", function(result)
        if result[1] ~= nil then
            local target = result[1]
            local targetPlayer = RSCore.Functions.GetPlayerByCitizenId(target.citizenid)

            print(targetPlayer.PlayerData.source)

            if targetPlayer ~= nil then
                TriggerClientEvent('rs-phone:client:AnswerCallOther', targetPlayer.PlayerData.source)
            end
        end
    end)
end)

RegisterServerEvent('rs-phone:server:HangupCall')
AddEventHandler('rs-phone:server:HangupCall', function(callData)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)
    if callData ~= nil and callData.number ~= nil then 
        RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..callData.number.."%'", function(result)
            if result[1] ~= nil then
                local target = result[1]
                local targetPlayer = RSCore.Functions.GetPlayerByCitizenId(target.citizenid)
    
                if targetPlayer ~= nil then
                    TriggerClientEvent('rs-phone:client:HangupCallOther', targetPlayer.PlayerData.source, callData)
                end
            end
        end)
    end
end)

RSCore.Functions.CreateCallback('rs-phone:server:doesChatExists', function(source, cb, number)
    local ply = RSCore.Functions.GetPlayer(source)
    RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `phone_messages` WHERE `citizenid` = "'..ply.PlayerData.citizenid..'" AND `number` = "'..number..'"', function(result)
        if result[1] ~= nil then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

RSCore.Commands.Add("ophangen", "Oproep beeindigen", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
	TriggerClientEvent('rs-phone:client:HangupCall', source)
end)

RSCore.Commands.Add("bel", "Oproep starten", {}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if args[1] ~= nil then
        TriggerClientEvent('rs-phone:client:CallNumber', source, args[1])
    end
end)

RSCore.Commands.Add("payphone", "Oproep starten", {}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if args[1] ~= nil then
        TriggerClientEvent('rs-phone:client:CallPayPhone', source, args[1])
    end
end)

RegisterServerEvent('rs-phone:server:PayPayPhone')
AddEventHandler('rs-phone:server:PayPayPhone', function(amount, number)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    if Player ~= nil then
        if Player.Functions.RemoveMoney('cash', amount) then
            TriggerClientEvent('rs-phone:client:CallPayPhoneYes', src, number)
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet voldoende cash op zak..', 'error')
        end
    end
end)