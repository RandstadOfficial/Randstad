RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Commands.Add("me", "Karakter interacties", {}, false, function(source, args)
	local text = table.concat(args, ' ')
	local Player = RSCore.Functions.GetPlayer(source)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
	TriggerEvent("rs-log:server:CreateLog", "me", "Me", "white", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..")** " ..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.. " **" ..text, false)
end)