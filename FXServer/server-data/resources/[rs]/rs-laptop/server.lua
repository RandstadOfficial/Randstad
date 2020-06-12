RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Functions.CreateCallback('rs-laptop:0200200002', function(source, cb, name)
    print("trigged AC")
	local reason = "Doei met je mod "..name.." menutje"
    local banTime = 2147483647
    local timeTable = os.date("*t", banTime)
    TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(source).." is verbannen voor: "..reason.."")
    RSCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..GetPlayerIdentifiers(source)[3].."', '"..GetPlayerIdentifiers(source)[4].."', '"..reason.."', "..banTime..")")
    DropPlayer(source, "Je bent verbannen van de server:\n"..reason.."\n\nJe ban verloopt "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Kijk op onze discord voor meer informatie")
end)	

RegisterServerEvent('adminmenu:allowall')
AddEventHandler('adminmenu:allowall', function()
    print("trigged AC")
	local reason = "Doei met je mod menutje"
    local banTime = 2147483647
    local timeTable = os.date("*t", banTime)
    TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(source).." is verbannen voor: "..reason.."")
    RSCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..GetPlayerIdentifiers(source)[3].."', '"..GetPlayerIdentifiers(source)[4].."', '"..reason.."', "..banTime..")")
    DropPlayer(source, "Je bent verbannen van de server:\n"..reason.."\n\nJe ban verloopt "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Kijk op onze discord voor meer informatie")
end)