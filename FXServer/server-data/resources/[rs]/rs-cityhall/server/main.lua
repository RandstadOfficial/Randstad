RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local DrivingSchools = {
    "YND19022", -- Maestro (Mahmut)
    "FTL45116", -- Maestro (Admin)
    "YMK83288", -- Souvereign King
    "SWX15921", -- MaBo
}

RegisterServerEvent('rs-cityhall:server:requestId')
AddEventHandler('rs-cityhall:server:requestId', function(identityData)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    local licenses = {
        ["driver"] = true,
        ["business"] = false
    }

    local info = {}
    if identityData.item == "id_card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif identityData.item == "driver_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "A1-A2-A | AM-B | C1-C-CE"
    end

    Player.Functions.AddItem(identityData.item, 1, nil, info)

    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[identityData.item], 'add')
end)

RegisterServerEvent('rs-cityhall:server:sendDriverTest')
AddEventHandler('rs-cityhall:server:sendDriverTest', function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    for k, v in pairs(DrivingSchools) do 
        local SchoolPlayer = RSCore.Functions.GetPlayerByCitizenId(v)
        if SchoolPlayer ~= nil then 
            TriggerClientEvent("rs-cityhall:client:sendDriverEmail", SchoolPlayer.PlayerData.source, SchoolPlayer.PlayerData.charinfo)
        else
            local mailData = {
                sender = "Gemeente",
                subject = "Aanvraag Rijles",
                message = "Beste,<br /><br />Wij hebben zojuist een bericht gehad dat er iemand rijles wilt volgen.<br />Mocht u bereid zijn om les te geven kunt u contact opnemen:<br />Naam: <strong>".. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. "<br />Telefoonnummer: <strong>"..Player.PlayerData.charinfo.phone.."</strong><br/><br/>Met vriendelijke groet,<br />Gemeente Randstad",
                button = {}
            }
            TriggerEvent("rs-phone:server:sendNewEventMail", v, mailData)
        end
    end
    TriggerClientEvent('RSCore:Notify', src, 'Er is een mail verstuurd naar rijscholen, er wordt vanzelf contact met je opgenomen', "success", 5000)
end)

RegisterServerEvent('rs-cityhall:server:ApplyJob')
AddEventHandler('rs-cityhall:server:ApplyJob', function(job)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local JobInfo = RSCore.Shared.Jobs[job]

    Player.Functions.SetJob(job, 1)

    TriggerClientEvent('RSCore:Notify', src, 'Gefeliciteerd met je nieuwe baan! ('..JobInfo.label..')')
end)

RSCore.Commands.Add("geefrijbewijs", "Geef een rijbewijs aan iemand", {{"id", "ID van een persoon"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if IsWhitelistedSchool(Player.PlayerData.citizenid) then
        local SearchedPlayer = RSCore.Functions.GetPlayer(tonumber(args[1]))
        if SearchedPlayer ~= nil then
            local driverLicense = SearchedPlayer.PlayerData.metadata["licences"]["driver"]
            if not driverLicense then
                local licenses = {
                    ["driver"] = true,
                    ["business"] = SearchedPlayer.PlayerData.metadata["licences"]["business"]
                }
                SearchedPlayer.Functions.SetMetaData("licences", licenses)
                TriggerClientEvent('RSCore:Notify', SearchedPlayer.PlayerData.source, "Je bent geslaagd! Haal je rijbewijs op bij het gemeentehuis", "success", 5000)
            else
                TriggerClientEvent('RSCore:Notify', src, "Kan rijbewijs niet geven..", "error")
            end
        end
    end
end)

function IsWhitelistedSchool(citizenid)
    local retval = false
    for k, v in pairs(DrivingSchools) do 
        if v == citizenid then
            retval = true
        end
    end
    return retval
end

RegisterServerEvent('rs-cityhall:server:banPlayer')
AddEventHandler('rs-cityhall:server:banPlayer', function()
    local src = source
    TriggerClientEvent('chatMessage', -1, "RS Anti-Cheat", "error", GetPlayerName(src).." is verbannen voor het versturen van POST Request's ")
    RSCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(src).."', '"..GetPlayerIdentifiers(src)[1].."', '"..GetPlayerIdentifiers(src)[2].."', '"..GetPlayerIdentifiers(src)[3].."', '"..GetPlayerIdentifiers(src)[4].."', 'Abuse localhost:13172 voor POST requests', 2145913200, '"..GetPlayerName(src).."')")
    DropPlayer(src, "Jij wel tijger..")
end)