RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RegisterServerEvent("KickForAFK")
AddEventHandler("KickForAFK", function()
	DropPlayer(source, "Je bent gekickt, je was te lang AFK.")
end)

RSCore.Functions.CreateCallback('rs-afkkick:server:GetPermissions', function(source, cb)
    local group = RSCore.Functions.GetPermission(source)
    cb(group)
end)