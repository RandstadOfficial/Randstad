RSCore.Functions = {}

RSCore.Functions.ExecuteSql = function(wait, query, cb)
	local rtndata = {}
	local waiting = true
	exports['ghmattimysql']:execute(query, {}, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
	end
	return rtndata
end

RSCore.Functions.GetIdentifier = function(source, idtype)
	local idtype = idtype ~=nil and idtype or RSConfig.IdentifierType
	for _, identifier in pairs(GetPlayerIdentifiers(source)) do
		if string.find(identifier, idtype) then
			return identifier
		end
	end
	return nil
end

RSCore.Functions.GetSource = function(identifier)
	for src, player in pairs(RSCore.Players) do
		local idens = GetPlayerIdentifiers(src)
		for _, id in pairs(idens) do
			if identifier == id then
				return src
			end
		end
	end
	return 0
end

RSCore.Functions.GetPlayer = function(source)
	if type(source) == "number" then
		return RSCore.Players[source]
	else
		return RSCore.Players[RSCore.Functions.GetSource(source)]
	end
end

RSCore.Functions.GetPlayerByCitizenId = function(citizenid)
	for src, player in pairs(RSCore.Players) do
		local cid = citizenid
		if RSCore.Players[src].PlayerData.citizenid == cid then
			return RSCore.Players[src]
		end
	end
	return nil
end

RSCore.Functions.GetPlayerByPhone = function(number)
	for src, player in pairs(RSCore.Players) do
		local cid = citizenid
		if RSCore.Players[src].PlayerData.charinfo.phone == number then
			return RSCore.Players[src]
		end
	end
	return nil
end

RSCore.Functions.GetPlayers = function()
	local sources = {}
	for k, v in pairs(RSCore.Players) do
		table.insert(sources, k)
	end
	return sources
end

RSCore.Functions.CreateCallback = function(name, cb)
	RSCore.ServerCallbacks[name] = cb
end

RSCore.Functions.TriggerCallback = function(name, source, cb, ...)
	if RSCore.ServerCallbacks[name] ~= nil then
		RSCore.ServerCallbacks[name](source, cb, ...)
	end
end

RSCore.Functions.CreateUseableItem = function(item, cb)
	RSCore.UseableItems[item] = cb
end

RSCore.Functions.CanUseItem = function(item)
	return RSCore.UseableItems[item] ~= nil
end

RSCore.Functions.UseItem = function(source, item)
	RSCore.UseableItems[item.name](source, item)
end

RSCore.Functions.Kick = function(source, reason, setKickReason, deferrals)
	local src = source
	reason = "\n"..reason.."\n🔸 Kijk op onze discord voor meer informatie: "..RSCore.Config.Server.discord
	if(setKickReason ~=nil) then
		setKickReason(reason)
	end
	Citizen.CreateThread(function()
		if(deferrals ~= nil)then
			deferrals.update(reason)
			Citizen.Wait(2500)
		end
		if src ~= nil then
			DropPlayer(src, reason)
		end
		local i = 0
		while (i <= 4) do
			i = i + 1
			while true do
				if src ~= nil then
					if(GetPlayerPing(src) >= 0) then
						break
					end
					Citizen.Wait(100)
					Citizen.CreateThread(function() 
						DropPlayer(src, reason)
					end)
				end
			end
			Citizen.Wait(5000)
		end
	end)
end

RSCore.Functions.IsWhitelisted = function(source)
	local identifiers = GetPlayerIdentifiers(source)
	local rtn = false
	if (RSCore.Config.Server.whitelist) then
		RSCore.Functions.ExecuteSql(true, "SELECT * FROM `whitelist` WHERE `"..RSCore.Config.IdentifierType.."` = '".. RSCore.Functions.GetIdentifier(source).."'", function(result)
			local data = result[1]
			if data ~= nil then
				for _, id in pairs(identifiers) do
					if data.steam == id or data.license == id then
						rtn = true
					end
				end
			end
		end)
	else
		rtn = true
	end
	return rtn
end

RSCore.Functions.AddPermission = function(source, permission)
	local Player = RSCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		RSCore.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = {
			steam = GetPlayerIdentifiers(source)[1],
			license = GetPlayerIdentifiers(source)[2],
			permission = permission:lower(),
		}
		RSCore.Functions.ExecuteSql(true, "DELETE FROM `permissions` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		RSCore.Functions.ExecuteSql(true, "INSERT INTO `permissions` (`name`, `steam`, `license`, `permission`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..permission:lower().."')")
		Player.Functions.UpdatePlayerData()
		TriggerClientEvent('RSCore:Client:OnPermissionUpdate', source, permission)
	end
end

RSCore.Functions.RemovePermission = function(source)
	local Player = RSCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		RSCore.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = nil	
		RSCore.Functions.ExecuteSql(true, "DELETE FROM `permissions` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Player.Functions.UpdatePlayerData()
	end
end

RSCore.Functions.HasPermission = function(source, permission)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	local permission = tostring(permission:lower())
	if permission == "user" then
		retval = true
	else
		if RSCore.Config.Server.PermissionList[steamid] ~= nil then 
			if RSCore.Config.Server.PermissionList[steamid].steam == steamid and RSCore.Config.Server.PermissionList[steamid].license == licenseid then
				if RSCore.Config.Server.PermissionList[steamid].permission == permission or RSCore.Config.Server.PermissionList[steamid].permission == "god" then
					retval = true
				end
			end
		end
	end
	return retval
end

RSCore.Functions.GetPermission = function(source)
	local retval = "user"
	Player = RSCore.Functions.GetPlayer(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	if Player ~= nil then
		if RSCore.Config.Server.PermissionList[Player.PlayerData.steam] ~= nil then 
			if RSCore.Config.Server.PermissionList[Player.PlayerData.steam].steam == steamid and RSCore.Config.Server.PermissionList[Player.PlayerData.steam].license == licenseid then
				retval = RSCore.Config.Server.PermissionList[Player.PlayerData.steam].permission
			end
		end
	end
	return retval
end

RSCore.Functions.IsOptin = function(source)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	if RSCore.Functions.HasPermission(source, "admin") then
		retval = RSCore.Config.Server.PermissionList[steamid].optin
	end
	return retval
end

RSCore.Functions.ToggleOptin = function(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	if RSCore.Functions.HasPermission(source, "admin") then
		RSCore.Config.Server.PermissionList[steamid].optin = not RSCore.Config.Server.PermissionList[steamid].optin
	end
end

RSCore.Functions.IsPlayerBanned = function (source)
	local retval = false
	local message = ""
	RSCore.Functions.ExecuteSql(true, "SELECT * FROM `bans` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."' OR `license` = '"..GetPlayerIdentifiers(source)[2].."' OR `ip` = '"..GetPlayerIdentifiers(source)[3].."'", function(result)
		if result[1] ~= nil then 
			if os.time() < result[1].expire then
				retval = true
				local timeTable = os.date("*t", tonumber(result[1].expire))
				message = "Je bent verbannen van de server:\n"..result[1].reason.."\nJe ban verloopt "..timeTable.day.. "/" .. timeTable.month .. "/" .. timeTable.year .. " " .. timeTable.hour.. ":" .. timeTable.min .. "\n"
			else
				RSCore.Functions.ExecuteSql(true, "DELETE FROM `bans` WHERE `id` = "..result[1].id)
			end
		end
	end)
	return retval, message
end

RSCore.Functions.BanInjection = function(source, script)
	local reason = "[AUTO BAN] Bedankt voor het uittesten hackertje!"
	local banTime = 2147483647
	local timeTable = os.date("*t", banTime)
	TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(source).." is verbannen voor: "..reason.."")
	
	TriggerEvent("rs-log:server:CreateLog", "bans", "Player Banned", "orange", "Speler: "..GetPlayerName(source).." is verbannen voor het gebruiken van ServerTriggerEvents via een externe programma (Resource: "..script..")")

	RSCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..GetPlayerIdentifiers(source)[3].."', '"..GetPlayerIdentifiers(source)[4].."', '"..reason.."', "..banTime..")")
	DropPlayer(source, "Hé sukkel, je bent verbannen van de server:\n"..reason.."\n\nJe ban verloopt "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Kijk op onze discord voor meer informatie")
	
end