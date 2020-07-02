RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Commands.Add("setlawyer", "Schrijf iemand in als advocaat", {{name="id", help="Id van de speler"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = RSCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "judge" then
        if OtherPlayer ~= nil then 
            local lawyerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
            }
            OtherPlayer.Functions.SetJob("lawyer", 1)
            OtherPlayer.Functions.AddItem("lawyerpass", 1, false, lawyerInfo)
            TriggerClientEvent("RSCore:Notify", source, "Je hebt " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. " aangenomen als advocaat")
            TriggerClientEvent("RSCore:Notify", OtherPlayer.PlayerData.source, "Je bent nu advocaat")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, RSCore.Shared.Items["lawyerpass"], "add")
        else
            TriggerClientEvent("RSCore:Notify", source, "Persoon is niet aanwezig..", "error")
        end
    else
        TriggerClientEvent("RSCore:Notify", source, "Je bent geen rechter..", "error")
    end
end)

RSCore.Commands.Add("removelawyer", "Verwijder iemand in als advocaat", {{name="id", help="Id van de speler"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = RSCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "judge" then
        if OtherPlayer ~= nil then 
            OtherPlayer.Functions.SetJob("unemployed", 1)
            TriggerClientEvent("RSCore:Notify", OtherPlayer.PlayerData.source, "Je bent nu werkloos")
            TriggerClientEvent("RSCore:Notify", source, "Je hebt " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. " onstlagen als advocaat")
        else
            TriggerClientEvent("RSCore:Notify", source, "Persoon is niet aanwezig..", "error")
        end
    else
        TriggerClientEvent("RSCore:Notify", source, "Je bent geen rechter..", "error")
    end
end)

RSCore.Commands.Add("advocatenpas", "Krijg een advocaten pas (je oude vervalt)", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "lawyer" or Player.PlayerData.job.name == "judge" then
        local lawyerInfo = {
            id = math.random(100000, 999999),
            firstname = Player.PlayerData.charinfo.firstname,
            lastname = Player.PlayerData.charinfo.lastname,
            citizenid = Player.PlayerData.citizenid,
        }
        Player.Functions.AddItem("lawyerpass", 1, false, lawyerInfo)
        TriggerClientEvent('inventory:client:ItemBox', source, RSCore.Shared.Items["lawyerpass"], "add")
        TriggerClientEvent("RSCore:Notify", source, "Je hebt een advocaten pas ontvangen")
    else
        TriggerClientEvent("RSCore:Notify", source, "Je hebt hier geen rechten voor..", "error")
    end
end)

RSCore.Functions.CreateUseableItem("lawyerpass", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("rs-justice:client:showLawyerLicense", -1, source, item.info)
    end
end)