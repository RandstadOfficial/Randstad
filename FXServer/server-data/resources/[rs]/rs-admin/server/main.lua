RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local permissions = {
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["noclip"] = "admin",
    ["kickall"] = "admin",
}



RegisterServerEvent('rs-admin:server:togglePlayerNoclip')
AddEventHandler('rs-admin:server:togglePlayerNoclip', function(playerId, reason)
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-admin:server:killPlayer')
AddEventHandler('rs-admin:server:killPlayer', function(playerId)
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-admin:server:kickPlayer')
AddEventHandler('rs-admin:server:kickPlayer', function(playerId, reason)
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-admin:server:Freeze')
AddEventHandler('rs-admin:server:Freeze', function(playerId, toggle)
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-admin:server:serverKick')
AddEventHandler('rs-admin:server:serverKick', function(reason)
    RSCore.Functions.BanInjection(source)
end)

local suffix = {
    "- Huts",
    "- Challaz",
    "- Adios Amigos",
    "- Yeet terug naar ESX",
}

RegisterServerEvent('rs-admin:server:banPlayer')
AddEventHandler('rs-admin:server:banPlayer', function(playerId, time, reason)
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-admin:server:revivePlayer')
AddEventHandler('rs-admin:server:revivePlayer', function(target)
    RSCore.Functions.BanInjection(source)
end)

RSCore.Commands.Add("announce", "Stuur een bericht naar iedereen", {}, false, function(source, args)
    local msg = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", msg)
    end
end, "admin")

RSCore.Commands.Add("admin", "Open admin menu", {}, false, function(source, args)
    local group = RSCore.Functions.GetPermission(source)
    -- local dealers = exports['rs-drugs']:GetDealers()
    TriggerClientEvent('rs-admin:client:openMenu', source, group)
end, "admin")

RSCore.Commands.Add("report", "Stuur een report naar admins (alleen wanneer nodig, MAAK HIER GEEN MISBRUIK VAN)", {{name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('rs-admin:client:SendReport', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "REPORT VERSTUURD", "normal", msg)
    TriggerEvent("rs-log:server:CreateLog", "report", "Report", "green", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..msg, false)
    TriggerEvent("rs-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)

RSCore.Commands.Add("staffchat", "Bericht naar alle staff sturen", {{name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('rs-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

RSCore.Commands.Add("givenuifocus", "Geef nui focus", {{name="id", help="Speler id"}, {name="focus", help="Zet focus aan/uit"}, {name="mouse", help="Zet muis aan/uit"}}, true, function(source, args)
    local playerid = tonumber(args[1])
    local focus = args[2]
    local mouse = args[3]

    TriggerClientEvent('rs-admin:client:GiveNuiFocus', playerid, focus, mouse)
end, "admin")

RSCore.Commands.Add("s", "Bericht naar alle staff sturen", {{name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('rs-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

RSCore.Commands.Add("warn", "Geef een persoon een waarschuwing", {{name="ID", help="Persoon"}, {name="Reden", help="Vul een reden in"}}, true, function(source, args)
    local targetPlayer = RSCore.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = RSCore.Functions.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, " ")

    local myName = senderPlayer.PlayerData.name

    local warnId = "WARN-"..math.random(1111, 9999)

    if targetPlayer ~= nil then
        TriggerClientEvent('chatMessage', targetPlayer.PlayerData.source, "SYSTEM", "error", "Je bent gewaarschuwd door: "..GetPlayerName(source)..", Reden: "..msg)
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt "..GetPlayerName(targetPlayer.PlayerData.source).." gewaarschuwd voor: "..msg)
        RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_warns` (`senderIdentifier`, `targetIdentifier`, `reason`, `warnId`) VALUES ('"..senderPlayer.PlayerData.steam.."', '"..targetPlayer.PlayerData.steam.."', '"..msg.."', '"..warnId.."')")
    else
        TriggerClientEvent('RSCore:Notify', source, 'Dit persoon is niet in de stad #YOLO, hmm ik ben '..myName..' en ik stink loloololo', 'error')
    end 
end, "admin")

RSCore.Commands.Add("checkwarns", "Geef een persoon een waarschuwing", {{name="ID", help="Persoon"}, {name="Warning", help="Nummer van waarschuwing, (1, 2 of 3 etc..)"}}, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = RSCore.Functions.GetPlayer(tonumber(args[1]))
        RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(result)
            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." heeft "..tablelength(result).." waarschuwingen!")
        end)
    else
        local targetPlayer = RSCore.Functions.GetPlayer(tonumber(args[1]))

        RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
            local selectedWarning = tonumber(args[2])

            if warnings[selectedWarning] ~= nil then
                local sender = RSCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

                TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", targetPlayer.PlayerData.name.." is gewaarschuwd door "..sender.PlayerData.name..", Reden: "..warnings[selectedWarning].reason)
            end
        end)
    end
end, "admin")

RSCore.Commands.Add("verwijderwarn", "Verwijder waarschuwing van persoon", {{name="ID", help="Persoon"}, {name="Warning", help="Nummer van waarschuwing, (1, 2 of 3 etc..)"}}, true, function(source, args)
    local targetPlayer = RSCore.Functions.GetPlayer(tonumber(args[1]))

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
        local selectedWarning = tonumber(args[2])

        if warnings[selectedWarning] ~= nil then
            local sender = RSCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

            TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Je hebt waarschuwing ("..selectedWarning..") verwijderd, Reden: "..warnings[selectedWarning].reason)
            RSCore.Functions.ExecuteSql(false, "DELETE FROM `player_warns` WHERE `warnId` = '"..warnings[selectedWarning].warnId.."'")
        end
    end)
end, "god")

function tablelength(table)
    local count = 0
    for _ in pairs(table) do 
        count = count + 1 
    end
    return count
end

RSCore.Commands.Add("reportr", "Reply op een report", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = RSCore.Functions.GetPlayer(playerId)
    local Player = RSCore.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "warning", msg)
        TriggerClientEvent('RSCore:Notify', source, "Reactie gestuurd")
        TriggerEvent("rs-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(RSCore.Functions.GetPlayers()) do
            if RSCore.Functions.HasPermission(v, "admin") then
                if RSCore.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "warning", msg)
                    TriggerEvent("rs-log:server:CreateLog", "report", "Report Reply", "red", "**"..GetPlayerName(source).."** reageerde op: **"..OtherPlayer.PlayerData.name.. " **(ID: "..OtherPlayer.PlayerData.source..") **Bericht:** " ..msg, false)
                end
            end
        end
    else
        TriggerClientEvent('RSCore:Notify', source, "Persoon is niet online", "error")
    end
end, "admin")

RSCore.Commands.Add("setmodel", "Verander in een model naar keuze..", {{name="model", help="Naam van de model"}, {name="id", help="Id van speler (laat leeg voor jezelf)"}}, false, function(source, args)
    local model = args[1]
    local target = tonumber(args[2])

    if model ~= nil or model ~= "" then
        if target == nil then
            TriggerClientEvent('rs-admin:client:SetModel', source, tostring(model))
        else
            local Trgt = RSCore.Functions.GetPlayer(target)
            if Trgt ~= nil then
                TriggerClientEvent('rs-admin:client:SetModel', target, tostring(model))
            else
                TriggerClientEvent('RSCore:Notify', source, "Dit persoon is niet in de stad yeet..", "error")
            end
        end
    else
        TriggerClientEvent('RSCore:Notify', source, "Je hebt geen Model opgegeven..", "error")
    end
end, "god")

RSCore.Commands.Add("setspeed", "Verander ren snelheid", {}, false, function(source, args)
    local speed = args[1]

    if speed ~= nil then
        TriggerClientEvent('rs-admin:client:SetSpeed', source, tostring(speed))
    else
        TriggerClientEvent('RSCore:Notify', source, "Je hebt geen Snelheid opgegeven.. (`fast` voor super-run, `normal` voor normaal)", "error")
    end
end, "god")


RSCore.Commands.Add("admincar", "Plaats voertuig in je garage", {}, false, function(source, args)
    local ply = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('rs-admin:client:SaveCar', source)
end, "god")

RegisterServerEvent('rs-admin:server:SaveCar')
AddEventHandler('rs-admin:server:SaveCar', function(mods, vehicle, hash, plate)
    
end)

RSCore.Commands.Add("reporttoggle", "Toggle inkomende reports uit of aan", {}, false, function(source, args)
    RSCore.Functions.ToggleOptin(source)
    if RSCore.Functions.IsOptin(source) then
        TriggerClientEvent('RSCore:Notify', source, "Je krijgt WEL reports", "success")
    else
        TriggerClientEvent('RSCore:Notify', source, "Je krijgt GEEN reports", "error")
    end
end, "admin")

RSCore.Commands.Add("cleararea", "verwijder peds, voertuigen en alles in het gebied", {}, false, function(source, args)
    TriggerClientEvent('RSCore:ClearArea', -1)
end, "admin")

RegisterCommand("kickall", function(source, args, rawCommand)
    local src = source
    
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = RSCore.Functions.GetPlayer(src)

        if RSCore.Functions.HasPermission(src, "god") then
            if args[1] ~= nil then
                for k, v in pairs(RSCore.Functions.GetPlayers()) do
                    local Player = RSCore.Functions.GetPlayer(v)
                    if Player ~= nil then 
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geef een reden op..')
            end
        else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Dit kan jij niet zomaar doen kindje..')
        end
    else
        for k, v in pairs(RSCore.Functions.GetPlayers()) do
            local Player = RSCore.Functions.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "Server restart, kijk op discord voor meer informatie! (discord.gg/KeHgZcZ)")
            end
        end
    end
end, false)

RegisterServerEvent('rs-admin:server:bringTp')
AddEventHandler('rs-admin:server:bringTp', function(targetId, coords)
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-admin:server:setPermissions')
AddEventHandler('rs-admin:server:setPermissions', function()
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-admin:server:OpenSkinMenu')
AddEventHandler('rs-admin:server:OpenSkinMenu', function(targetId)
    RSCore.Functions.BanInjection(source)
end)

RegisterServerEvent('rs-admin:server:SendReport')
AddEventHandler('rs-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = RSCore.Functions.GetPlayers()

    if RSCore.Functions.HasPermission(src, "admin") then
        if RSCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterServerEvent('rs-admin:server:StaffChatMessage')
AddEventHandler('rs-admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = RSCore.Functions.GetPlayers()

    if RSCore.Functions.HasPermission(src, "admin") then
        if RSCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "error", msg)
        end
    end
end)


RSCore.Functions.CreateCallback('rs-admin:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false

    if RSCore.Functions.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)

RSCore.Functions.CreateCallback('rs-admin:server:getTargetAppartment', function(source, cb, player)
    local Target = RSCore.Functions.GetPlayer(player)
    
    local appartment = Target.PlayerData.metadata["currentapartment"]

    cb(appartment)
end)

RSCore.Functions.CreateCallback('rs-admin:server:getTargetData', function(source, cb, player)
    local Target = RSCore.Functions.GetPlayer(player)
    local bsn = Target.PlayerData.citizenid
    local fname = Target.PlayerData.charinfo.firstname
    local lname = Target.PlayerData.charinfo.lastname

    cb(bsn, fname, lname)
end)

RSCore.Functions.CreateCallback('rs-admin:setPermissions', function(source, cb, targetId, group)
    RSCore.Functions.AddPermission(targetId, group.rank)
    TriggerClientEvent('RSCore:Notify', targetId, 'Je permissie groep is gezet naar '..group.label)
end)

RSCore.Functions.CreateCallback('rs-admin:server:togglePlayerNoclip', function(source, cb, playerId, reason)
	local src = source
    if RSCore.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("rs-admin:client:toggleNoclip", playerId)
    end
end)

RSCore.Functions.CreateCallback('rs-admin:server:killPlayer', function(source, cb, playerId)
    TriggerClientEvent('hospital:client:KillPlayer', playerId)

end)

RSCore.Functions.CreateCallback('rs-admin:server:kickPlayer', function(source, cb, playerId, reason)
	local src = source
    if RSCore.Functions.HasPermission(src, permissions["kick"]) then
        DropPlayer(playerId, "Je bent gekicked uit de server:\n"..reason.."\n\n🔸 Kijk op onze discord voor meer informatie: https://discord.gg/2DRbeFy")
    end
end)

RSCore.Functions.CreateCallback('rs-admin:server:Freeze', function(source, cb, playerId, toggle)
    TriggerClientEvent('rs-admin:client:Freeze', playerId, toggle)
end)

RSCore.Functions.CreateCallback('rs-admin:server:serverKick', function(source, cb, reason)
	local src = source
    if RSCore.Functions.HasPermission(src, permissions["kickall"]) then
        for k, v in pairs(RSCore.Functions.GetPlayers()) do
            if v ~= src then 
                DropPlayer(v, "Je bent gekicked uit de server:\n"..reason.."\n\n🔸 Kijk op onze discord voor meer informatie: https://discord.gg/2DRbeFy")
            end
        end
    end
end)

RSCore.Functions.CreateCallback('rs-admin:server:banPlayer', function(source, cb, playerId, time, reason)
	local src = source
    if RSCore.Functions.HasPermission(src, permissions["ban"]) then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date("*t", banTime)
        --TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(playerId).." is verbannen voor: "..reason.." "..suffix[math.random(1, #suffix)])
        RSCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..GetPlayerIdentifiers(playerId)[3].."', '"..GetPlayerIdentifiers(playerId)[4].."', '"..reason.."', "..banTime..", '"..GetPlayerName(src).."')")
        DropPlayer(playerId, "Je bent verbannen van de server:\n"..reason.."\n\nJe ban verloopt "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Kijk op onze discord voor meer informatie")
    end
end)

RSCore.Functions.CreateCallback('rs-admin:server:revivePlayer', function(source, cb, target)
	TriggerClientEvent('hospital:client:Revive', target)
end)

RSCore.Functions.CreateCallback('rs-admin:server:bringTp', function(source, cb, targetId, coords)
    TriggerClientEvent('rs-admin:client:bringTp', targetId, coords)
end)

RSCore.Functions.CreateCallback('rs-admin:server:OpenSkinMenu', function(source, cb, targetId)
    TriggerClientEvent("rs-clothing:client:openMenu", targetId)
	
end)

RSCore.Functions.CreateCallback('rs-admin:server:SaveCar', function(source, cb, mods, vehicle, hash, plate)
	local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] == nil then
            RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicle.model.."', '"..vehicle.hash.."', '"..json.encode(mods).."', '"..plate.."', 0)")
            TriggerClientEvent('RSCore:Notify', src, 'Het voertuig staat nu op je naam!', 'success', 5000)
        else
            TriggerClientEvent('RSCore:Notify', src, 'Dit voertuig staat al in je garage..', 'error', 3000)
        end
    end)
end)