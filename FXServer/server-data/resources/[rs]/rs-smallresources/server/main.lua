RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local VehicleNitrous = {}

RegisterServerEvent('tackle:server:TacklePlayer')
AddEventHandler('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent("tackle:client:GetTackled", playerId)
end)

RSCore.Functions.CreateCallback('nos:GetNosLoadedVehs', function(source, cb)
    cb(VehicleNitrous)
end)

RSCore.Commands.Add("id", "Wat is mijn id?", {}, false, function(source, args)
    TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "ID: "..source)
end)

RSCore.Commands.Add("rep", "Wat is mijn Reputatie?", {}, false, function(source, args)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    local DealerRep = Player.PlayerData.metadata["dealerrep"]
    local JobRep = Player.PlayerData.metadata["jobrep"]
    TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Dealer Reputatie: "..DealerRep)
end)

RSCore.Commands.Add("xp", "Wat is mijn Ervaring?", {}, false, function(source, args)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    local CraftingRep = Player.PlayerData.metadata["craftingrep"]
    local AttachmentRep = Player.PlayerData.metadata["attachmentcraftingrep"]
    TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Crafting Ervaring: "..CraftingRep)
    TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Attachments Ervaring: "..AttachmentRep)
end)

RSCore.Functions.CreateUseableItem("harness", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
end)

RegisterServerEvent('equip:harness')
AddEventHandler('equip:harness', function(item)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if Player.PlayerData.items[item.slot].info.uses - 1 == 0 then
        TriggerClientEvent("inventory:client:ItemBox", source, RSCore.Shared.Items['harness'], "remove")
        Player.Functions.RemoveItem('harness', 1)
    else
        Player.PlayerData.items[item.slot].info.uses = Player.PlayerData.items[item.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterServerEvent('seatbelt:DoHarnessDamage')
AddEventHandler('seatbelt:DoHarnessDamage', function(hp, data)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    if hp == 0 then
        Player.Functions.RemoveItem('harness', 1, data.slot)
    else
        Player.PlayerData.items[data.slot].info.uses = Player.PlayerData.items[data.slot].info.uses - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)