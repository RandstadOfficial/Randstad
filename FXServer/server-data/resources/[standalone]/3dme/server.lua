RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Commands.Add("me", "Karakter interacties", {}, false, function(source, args)
	local text = table.concat(args, ' ')
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
end)