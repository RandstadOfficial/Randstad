RSCore.Functions.CreateUseableItem("joint", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        Citizen.CreateThread(function()
            TriggerClientEvent("consumables:client:UseJoint", source)
        end)
    end
end)

RSCore.Functions.CreateUseableItem("armor", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseArmor", source)
end)

RSCore.Functions.CreateUseableItem("heavyarmor", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseHeavyArmor", source)
end)

-- RSCore.Functions.CreateUseableItem("smoketrailred", function(source, item)
--     local Player = RSCore.Functions.GetPlayer(source)
-- 	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent("consumables:client:UseRedSmoke", source)
--     end
-- end)

RSCore.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseParachute", source)
    end
end)

RSCore.Commands.Add("parachuteuit", "Doe je parachute uit", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
        TriggerClientEvent("consumables:client:ResetParachute", source)
end)

RegisterServerEvent("rs-smallpenis:server:AddParachute")
AddEventHandler("rs-smallpenis:server:AddParachute", function()
    local src = source
    local Ply = RSCore.Functions.GetPlayer(src)

    Ply.Functions.AddItem("parachute", 1)
end)

RSCore.Functions.CreateUseableItem("water_bottle", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end
end)

RSCore.Functions.CreateUseableItem("vodka", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)

RSCore.Functions.CreateUseableItem("beer", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)

RSCore.Functions.CreateUseableItem("corona", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)

RSCore.Functions.CreateUseableItem("whiskey", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)

RSCore.Functions.CreateUseableItem("coffee", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end
end)

RSCore.Functions.CreateUseableItem("kurkakola", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end
end)

RSCore.Functions.CreateUseableItem("sandwich", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

RSCore.Functions.CreateUseableItem("twerks_candy", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

RSCore.Functions.CreateUseableItem("snikkel_candy", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

RSCore.Functions.CreateUseableItem("tosti", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

RSCore.Functions.CreateUseableItem("binoculars", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("binoculars:Toggle", source)
end)

RSCore.Functions.CreateUseableItem("cokebaggy", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:Cokebaggy", source)
end)

RSCore.Functions.CreateUseableItem("crack_baggy", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:Crackbaggy", source)
end)

RSCore.Functions.CreateUseableItem("xtcbaggy", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:EcstasyBaggy", source)
end)

RSCore.Functions.CreateUseableItem("firework1", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework")
end)

RSCore.Functions.CreateUseableItem("firework2", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework_v2")
end)

RSCore.Functions.CreateUseableItem("firework3", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_xmas_firework")
end)

RSCore.Functions.CreateUseableItem("firework4", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "scr_indep_fireworks")
end)

RSCore.Commands.Add("vestuit", "Doe je vest uit 4head", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("consumables:client:ResetArmor", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)