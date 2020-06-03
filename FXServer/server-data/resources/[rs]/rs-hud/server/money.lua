RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Commands.Add("cash", "Kijk hoeveel geld je bij je hebt", {}, false, function(source, args)
	TriggerClientEvent('hud:client:ShowMoney', source, "cash")
end)

RSCore.Commands.Add("bank", "Kijk hoeveel geld je op je bank hebt", {}, false, function(source, args)
	TriggerClientEvent('hud:client:ShowMoney', source, "bank")
end)