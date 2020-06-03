RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RSCore.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
	TriggerClientEvent("rs-commandbinding:client:openUI", source)
end)

RegisterServerEvent('rs-commandbinding:server:setKeyMeta')
AddEventHandler('rs-commandbinding:server:setKeyMeta', function(keyMeta)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)

    ply.Functions.SetMetaData("commandbinds", keyMeta)
end)