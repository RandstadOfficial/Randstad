RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

local RSPhone = {}
local Tweets = {}
local AppAlerts = {}
local MentionedTweets = {}
local Hashtags = {}
local Calls = {}

function GetOnlineStatus(number)
    local Target = RSCore.Functions.GetPlayerByPhone(number)
    local retval = false
    if Target ~= nil then retval = true end
    return retval
end

RSCore.Functions.CreateCallback('rs-phone_new:server:GetPhoneData', function(source, cb)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local PhoneData = {
        Applications = {},
        PlayerContacts = {},
        MentionedTweets = {},
        Chats = {},
        Hashtags = {},
        Invoices = {},
        Garage = {},
    }

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM player_contacts WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' ORDER BY `name` ASC", function(result)
        local Contacts = {}
        if result[1] ~= nil then
            for k, v in pairs(result) do
                v.status = GetOnlineStatus(v.number)
            end
            
            PhoneData.PlayerContacts = result
        end

        RSCore.Functions.ExecuteSql(false, "SELECT * FROM phone_invoices WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(invoices)
            if invoices[1] ~= nil then
                for k, v in pairs(invoices) do
                    local Ply = RSCore.Functions.GetPlayerByCitizenId(v.sender)
                    if Ply ~= nil then
                        v.number = Ply.PlayerData.charinfo.phone
                    else
                        RSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..v.sender.."'", function(res)
                            if res[1] ~= nil then
                                res[1].charinfo = json.decode(res[1].charinfo)
                                v.number = res[1].charinfo.phone
                            else
                                v.number = nil
                            end
                        end)
                    end
                end
                PhoneData.Invoices = invoices
            end
            
            RSCore.Functions.ExecuteSql(false, "SELECT * FROM player_vehicles WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(garageresult)
                if garageresult[1] ~= nil then
                    -- for k, v in pairs(garageresult) do
                    --     if (RSCore.Shared.Vehicles[v.vehicle] ~= nil) and (Garages[v.garage] ~= nil) then
                    --         v.garage = Garages[v.garage].label
                    --         v.vehicle = RSCore.Shared.Vehicles[v.vehicle].name
                    --         v.brand = RSCore.Shared.Vehicles[v.vehicle].brand
                    --     end
                    -- end

                    PhoneData.Garage = garageresult
                end
                
                RSCore.Functions.ExecuteSql(false, "SELECT * FROM phone_messages WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(messages)
                    if messages ~= nil and next(messages) ~= nil then 
                        PhoneData.Chats = messages
                    end

                    if AppAlerts[Player.PlayerData.citizenid] ~= nil then 
                        PhoneData.Applications = AppAlerts[Player.PlayerData.citizenid]
                    end

                    if MentionedTweets[Player.PlayerData.citizenid] ~= nil then 
                        PhoneData.MentionedTweets = MentionedTweets[Player.PlayerData.citizenid]
                    end

                    if Hashtags ~= nil and next(Hashtags) ~= nil then
                        PhoneData.Hashtags = Hashtags
                    end

                    cb(PhoneData)
                end)
            end)
        end)
    end)
end)

RSCore.Functions.CreateCallback('rs-phone_new:server:GetCallState', function(source, cb, ContactData)
    local Target = RSCore.Functions.GetPlayerByPhone(ContactData.number)

    if Target ~= nil then
        if Calls[Target.PlayerData.citizenid] ~= nil then
            if Calls[Target.PlayerData.citizenid].inCall then
                cb(false, true)
            else
                cb(true, true)
            end
        else
            cb(true, true)
        end
    else
        cb(false, false)
    end
end)

RegisterServerEvent('rs-phone_new:server:SetCallState')
AddEventHandler('rs-phone_new:server:SetCallState', function(bool)
    local src = source
    local Ply = RSCore.Functions.GetPlayer(src)

    if Calls[Ply.PlayerData.citizenid] ~= nil then
        Calls[Ply.PlayerData.citizenid].inCall = bool
    else
        Calls[Ply.PlayerData.citizenid] = {}
        Calls[Ply.PlayerData.citizenid].inCall = bool
    end
end)

RegisterServerEvent('rs-phone_new:server:MentionedPlayer')
AddEventHandler('rs-phone_new:server:MentionedPlayer', function(firstName, lastName, TweetMessage)
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            print(firstName)
            print(lastName)
            if (Player.PlayerData.charinfo.firstname == firstName and Player.PlayerData.charinfo.lastname == lastName) then
                RSPhone.SetPhoneAlerts(Player.PlayerData.citizenid, "twitter")
                RSPhone.AddMentionedTweet(Player.PlayerData.citizenid, TweetMessage)
                TriggerClientEvent('rs-phone_new:client:GetMentioned', Player.PlayerData.source, TweetMessage, AppAlerts[Player.PlayerData.citizenid]["twitter"])
            else
                RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..firstName.."%' AND `charinfo` LIKE '%"..lastName.."%'", function(result)
                    if result[1] ~= nil then
                        local MentionedTarget = result[1].citizenid
                        RSPhone.SetPhoneAlerts(MentionedTarget, "twitter")
                        RSPhone.AddMentionedTweet(MentionedTarget, TweetMessage)
                        print(AppAlerts[MentionedTarget]["twitter"])
                    end
                end)
            end
        end
	end
end)

RegisterServerEvent('rs-phone_new:server:CallContact')
AddEventHandler('rs-phone_new:server:CallContact', function(TargetData, CallId)
    local src = source
    local Ply = RSCore.Functions.GetPlayer(src)
    local Target = RSCore.Functions.GetPlayerByPhone(TargetData.number)

    if Target ~= nil then
        TriggerClientEvent('rs-phone_new:client:GetCalled', Target.PlayerData.source, Ply.PlayerData.charinfo.phone, CallId)
    end
end)

RSCore.Functions.CreateCallback('rs-phone_new:server:PayInvoice', function(source, cb, sender, amount, invoiceId)
    local src = source
    local Ply = RSCore.Functions.GetPlayer(src)
    local Trgt = RSCore.Functions.GetPlayerByCitizenId(sender)
    local Invoices = {}

    if Trgt ~= nil then
        if Ply.PlayerData.money.bank >= amount then
            Ply.Functions.RemoveMoney('bank', amount, "paid-invoice")
            Trgt.Functions.AddMoney('bank', amount, "paid-invoice")

            RSCore.Functions.ExecuteSql(true, "DELETE FROM `phone_invoices` WHERE `invoiceid` = '"..invoiceId.."'")
            RSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_invoices` WHERE `citizenid` = '"..Ply.PlayerData.citizenid.."'", function(invoices)
                if invoices[1] ~= nil then
                    for k, v in pairs(invoices) do
                        local Target = RSCore.Functions.GetPlayerByCitizenId(v.sender)
                        if Target ~= nil then
                            v.number = Target.PlayerData.charinfo.phone
                        else
                            RSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..v.sender.."'", function(res)
                                if res[1] ~= nil then
                                    res[1].charinfo = json.decode(res[1].charinfo)
                                    v.number = res[1].charinfo.phone
                                else
                                    v.number = nil
                                end
                            end)
                        end
                    end
                    Invoices = invoices
                end
                cb(true, Invoices)
            end)
        else
            cb(false)
        end
    else
        RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..sender.."'", function(result)
            if result[1] ~= nil then
                local moneyInfo = json.decode(result[1].money)
                moneyInfo.bank = math.ceil((moneyInfo.bank + amount))
                RSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..sender.."'")
                Ply.Functions.RemoveMoney('bank', amount, "paid-invoice")
                RSCore.Functions.ExecuteSql(true, "DELETE FROM `phone_invoices` WHERE `invoiceid` = '"..invoiceId.."'")
                RSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_invoices` WHERE `citizenid` = '"..Ply.PlayerData.citizenid.."'", function(invoices)
                    if invoices[1] ~= nil then
                        for k, v in pairs(invoices) do
                            local Target = RSCore.Functions.GetPlayerByCitizenId(v.sender)
                            if Target ~= nil then
                                v.number = Target.PlayerData.charinfo.phone
                            else
                                RSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..v.sender.."'", function(res)
                                    if res[1] ~= nil then
                                        res[1].charinfo = json.decode(res[1].charinfo)
                                        v.number = res[1].charinfo.phone
                                    else
                                        v.number = nil
                                    end
                                end)
                            end
                        end
                        Invoices = invoices
                    end
                    cb(true, Invoices)
                end)
            else
                cb(false)
            end
        end)
    end
end)

RSCore.Functions.CreateCallback('rs-phone_new:server:DeclineInvoice', function(source, cb, sender, amount, invoiceId)
    local src = source
    local Ply = RSCore.Functions.GetPlayer(src)
    local Trgt = RSCore.Functions.GetPlayerByCitizenId(sender)
    local Invoices = {}

    RSCore.Functions.ExecuteSql(true, "DELETE FROM `phone_invoices` WHERE `invoiceid` = '"..invoiceId.."'")
    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_invoices` WHERE `citizenid` = '"..Ply.PlayerData.citizenid.."'", function(invoices)
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Target = RSCore.Functions.GetPlayerByCitizenId(v.sender)
                if Target ~= nil then
                    v.number = Target.PlayerData.charinfo.phone
                else
                    RSCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..v.sender.."'", function(res)
                        if res[1] ~= nil then
                            res[1].charinfo = json.decode(res[1].charinfo)
                            v.number = res[1].charinfo.phone
                        else
                            v.number = nil
                        end
                    end)
                end
            end
            Invoices = invoices
        end
        cb(true, invoices)
    end)
end)

RegisterServerEvent('rs-phone_new:server:UpdateHashtags')
AddEventHandler('rs-phone_new:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        table.insert(Hashtags[Handle].messages, messageData)
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(Hashtags[Handle].messages, messageData)
    end
    TriggerClientEvent('rs-phone_new:client:UpdateHashtags', -1, Handle, messageData)
end)

RSPhone.AddMentionedTweet = function(citizenid, TweetData)
    if MentionedTweets[citizenid] == nil then MentionedTweets[citizenid] = {} end
    table.insert(MentionedTweets[citizenid], TweetData)
end

RSPhone.SetPhoneAlerts = function(citizenid, app, alerts)
    if citizenid ~= nil and app ~= nil then
        if AppAlerts[citizenid] == nil then
            AppAlerts[citizenid] = {}
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = alerts
                end
            end
        else
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 1
                else
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 0
                end
            end
        end
    end
end

RegisterServerEvent('rs-phone:server:SetPhoneAlerts')
AddEventHandler('rs-phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local CitizenId = RSCore.Functions.GetPlayer(src).citizenid
    RSPhone.SetPhoneAlerts(CitizenId, app, alerts)
end)

RegisterServerEvent('rs-phone_new:server:UpdateTweets')
AddEventHandler('rs-phone_new:server:UpdateTweets', function(NewTweets, TweetData)
    Tweets = NewTweets
    local TwtData = TweetData
    local src = source
    TriggerClientEvent('rs-phone_new:client:UpdateTweets', -1, src, Tweets, TwtData)
end)

RegisterServerEvent('rs-phone_new:server:TransferMoney')
AddEventHandler('rs-phone_new:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..iban.."%'", function(result)
        if result[1] ~= nil then
            local recieverSteam = RSCore.Functions.GetPlayerByCitizenId(result[1].citizenid)

            if recieverSteam then
                local PhoneItem = recieverSteam.Functions.GetItemByName("phone")
                recieverSteam.Functions.AddMoney('bank', amount, "phone-transfered-from-"..sender.PlayerData.citizenid)
                sender.Functions.RemoveMoney('bank', amount, "phone-transfered-to-"..recieverSteam.PlayerData.citizenid)

                if PhoneItem ~= nil then
                    TriggerClientEvent('rs-phone_new:server:TransferMoney', recieverSteam.PlayerData.source, amount)
                end
            else
                local moneyInfo = json.decode(result[1].money)
                moneyInfo.bank = round((moneyInfo.bank + amount))
                RSCore.Functions.ExecuteSql(false, "UPDATE `players` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
                sender.Functions.RemoveMoney('bank', amount, "phone-transfered")
            end
        else
            TriggerClientEvent('RSCore:Notify', src, "Dit rekeningnummer bestaat niet!", "error")
        end
    end)
end)

RegisterServerEvent('rs-phone_new:server:EditContact')
AddEventHandler('rs-phone_new:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, oldIban)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    RSCore.Functions.ExecuteSql(false, "UPDATE `player_contacts` SET `name` = '"..newName.."', `number` = '"..newNumber.."', `iban` = '"..newIban.."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `name` = '"..oldName.."' AND `number` = '"..oldNumber.."'")
end)

RegisterServerEvent('rs-phone_new:server:AddNewContact')
AddEventHandler('rs-phone_new:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_contacts` (`citizenid`, `name`, `number`, `iban`) VALUES ('"..Player.PlayerData.citizenid.."', '"..tostring(name).."', '"..tostring(number).."', '"..tostring(iban).."')")
end)

RegisterServerEvent('rs-phone_new:server:UpdateMessages')
AddEventHandler('rs-phone_new:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
    local src = source
    local SenderData = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..ChatNumber.."%'", function(Player)
        if Player[1] ~= nil then
            local TargetData = RSCore.Functions.GetPlayerByCitizenId(Player[1].citizenid)

            if TargetData ~= nil then
                RSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_messages` WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..ChatNumber.."'", function(Chat)
                    if Chat[1] ~= nil then
                        -- Update for target
                        RSCore.Functions.ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..TargetData.PlayerData.citizenid.."' AND `number` = '"..SenderData.PlayerData.charinfo.phone.."'")
                                
                        -- Update for sender
                        RSCore.Functions.ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..TargetData.PlayerData.charinfo.phone.."'")
                    
                        -- Send notification & Update messages for target
                        TriggerClientEvent('rs-phone_new:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, false)
                    else
                        -- Insert for target
                        RSCore.Functions.ExecuteSql(false, "INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..TargetData.PlayerData.citizenid.."', '"..SenderData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                                            
                        -- Insert for sender
                        RSCore.Functions.ExecuteSql(false, "INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..SenderData.PlayerData.citizenid.."', '"..TargetData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")

                        -- Send notification & Update messages for target
                        TriggerClientEvent('rs-phone_new:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, true)
                    end
                end)
            else
                RSCore.Functions.ExecuteSql(false, "SELECT * FROM `phone_messages` WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..ChatNumber.."'", function(Chat)
                    if Chat[1] ~= nil then
                        -- Update for target
                        RSCore.Functions.ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..Player[1].citizenid.."' AND `number` = '"..SenderData.PlayerData.charinfo.phone.."'")
                                
                        -- Update for sender
                        Player[1].charinfo = json.decode(Player[1].charinfo)
                        RSCore.Functions.ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..Player[1].charinfo.phone.."'")
                    else
                        -- Insert for target
                        RSCore.Functions.ExecuteSql(false, "INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..Player[1].citizenid.."', '"..SenderData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                        
                        -- Insert for sender
                        Player[1].charinfo = json.decode(Player[1].charinfo)
                        RSCore.Functions.ExecuteSql(false, "INSERT INTO `phone_messages` (`citizenid`, `number`, `messages`) VALUES ('"..SenderData.PlayerData.citizenid.."', '"..Player[1].charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                    end
                end)
            end
        end
    end)
end)

RegisterServerEvent('rs-phone_new:server:AddRecentCall')
AddEventHandler('rs-phone_new:server:AddRecentCall', function(type, data)
    local src = source
    local Ply = RSCore.Functions.GetPlayer(src)

    local Trgt = RSCore.Functions.GetPlayerByPhone(data.TargetData.number)

    local Hour = os.date("%H")
    local Minute = os.date("%M")
    local Label = Hour..":"..Minute

    if Trgt ~= nil then
        TriggerClientEvent('rs-phone_new:client:AddRecentCall', Trgt.PlayerData.source, data,type, Label)
    end
    if type == "outgoing" then
        TriggerClientEvent('rs-phone_new:client:AddRecentCall', src, data, "missed", Label)
    else
        TriggerClientEvent('rs-phone_new:client:AddRecentCall', src, data, "outgoing", Label)
    end
end)

RegisterServerEvent('rs-phone_new:server:CancelCall')
AddEventHandler('rs-phone_new:server:CancelCall', function(ContactData)
    local Ply = RSCore.Functions.GetPlayerByPhone(ContactData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('rs-phone_new:client:CancelCall', Ply.PlayerData.source)
    end
end)

RegisterServerEvent('rs-phone_new:server:AnswerCall')
AddEventHandler('rs-phone_new:server:AnswerCall', function(CallData)
    local Ply = RSCore.Functions.GetPlayerByPhone(CallData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('rs-phone_new:client:AnswerCall', Ply.PlayerData.source)
    end
end)

RegisterServerEvent('rs-phone_new:server:SaveMetaData')
AddEventHandler('rs-phone_new:server:SaveMetaData', function(MetaData)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    Player.Functions.SetMetaData("phone", MetaData)
end)