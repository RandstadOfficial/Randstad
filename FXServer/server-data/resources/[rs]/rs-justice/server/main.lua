RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

AddEventHandler('entityCreated', function(entity)
    print('entityCreated')
    local entity = entity
    --for i, v in ipairs(entity) do print(v) end
    print(entity)
    -- if not DoesEntityExist(entity) then
    --     return
    -- end

    local src = NetworkGetEntityOwner(entity)
    local entID = NetworkGetNetworkIdFromEntity(entity)

    local ownerID = GetPlayerIdentifiers(src)[1]

    print("Entity ID: "..entID)
    print("Owner ID: "..ownerID)
    local model = GetEntityModel(entity)
    print(model)

    -- if GetEntityType(entity) ~= 0 then
    --     local model = GetEntityModel(entity)

    --     for i, objName in ipairs(BlacklistedThings) do
    --         if model == GetHashKey(objName) then
    --             TriggerClientEvent('DespawnObj', src, entity)
    --             --DropPlayer(src, 'new cheat detection lol.')
    --         end
    --     end
    -- end
end)
  

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

RSCore.Functions.CreateUseableItem("lawyerpass", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("rs-justice:client:showLawyerLicense", -1, source, item.info)
    end
end)