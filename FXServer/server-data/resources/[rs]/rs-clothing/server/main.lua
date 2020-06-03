RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RSCore.Commands.Add("skin", "Ooohja toch", {}, false, function(source, args)
	TriggerClientEvent("rs-clothing:client:openMenu", source)
end, "admin")

RegisterServerEvent("rs-clothing:saveSkin")
AddEventHandler('rs-clothing:saveSkin', function(model, skin)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    if model ~= nil and skin ~= nil then 
        RSCore.Functions.ExecuteSql(false, "DELETE FROM `playerskins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function()
            RSCore.Functions.ExecuteSql(false, "INSERT INTO `playerskins` (`citizenid`, `model`, `skin`, `active`) VALUES ('"..Player.PlayerData.citizenid.."', '"..model.."', '"..skin.."', 1)")
        end)
    end
end)

RegisterServerEvent("rs-clothes:loadPlayerSkin")
AddEventHandler('rs-clothes:loadPlayerSkin', function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `playerskins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `active` = 1", function(result)
        if result[1] ~= nil then
            TriggerClientEvent("rs-clothes:loadSkin", src, false, result[1].model, result[1].skin)
        else
            TriggerClientEvent("rs-clothes:loadSkin", src, true)
        end
    end)
end)

RegisterServerEvent("rs-clothes:saveOutfit")
AddEventHandler("rs-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_outfits` (`citizenid`, `outfitname`, `model`, `skin`, `outfitId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..outfitName.."', '"..model.."', '"..json.encode(skinData).."', '"..outfitId.."')", function()
            RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
                if result[1] ~= nil then
                    TriggerClientEvent('rs-clothing:client:reloadOutfits', src, result)
                else
                    TriggerClientEvent('rs-clothing:client:reloadOutfits', src, nil)
                end
            end)
        end)
    end
end)

RegisterServerEvent("rs-clothing:server:removeOutfit")
AddEventHandler("rs-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    RSCore.Functions.ExecuteSql(false, "DELETE FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `outfitname` = '"..outfitName.."' AND `outfitId` = '"..outfitId.."'", function()
        RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
            if result[1] ~= nil then
                TriggerClientEvent('rs-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('rs-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end)
end)

RSCore.Functions.CreateCallback('rs-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local anusVal = {}

    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                result[k].skin = json.decode(result[k].skin)
                anusVal[k] = v
            end
            cb(anusVal)
        end
        cb(anusVal)
    end)
end)

RegisterServerEvent('rs-clothing:print')
AddEventHandler('rs-clothing:print', function(data)
    print(data)
end)

RSCore.Commands.Add("helm", "Zet je helm/pet/hoed op of af..", {}, false, function(source, args)
    TriggerClientEvent("rs-clothing:client:adjustfacewear", source, 1) -- Hat
end)

RSCore.Commands.Add("bril", "Zet je bril op of af..", {}, false, function(source, args)
	TriggerClientEvent("rs-clothing:client:adjustfacewear", source, 2)
end)

RSCore.Commands.Add("masker", "Zet je masker op of af..", {}, false, function(source, args)
	TriggerClientEvent("rs-clothing:client:adjustfacewear", source, 4)
end)