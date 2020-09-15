--------------
--  CONFIG  --
--------------
local ownerEmail = 'randstadofficial@gmail.com'             -- Owner Email (Required) - No account needed (Used Incase of Issues)
local kickThreshold = 0.99        -- Anything equal to or higher than this value will be kicked. (0.99 Recommended as Lowest)
local kickReason = 'Wij zien dat je gebruik maakt van een VPN of een cloudgaming service, ga naar de Randstad Discord voor een VPNBlock whitelist.'
local flags = 'm'				  -- Quickest and most accurate check. Checks IP blacklist.
local printFailed = true


------- DO NOT EDIT BELOW THIS LINE -------
function splitString(inputstr, sep)
	local t= {}; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

--Een quickfix, later naar config of db zetten--
local vpnWhitelist = {
	[1]="steam:110000133e1592c",
	[2]="steam:11000013f05c24d",
	[3]="steam:110000116062103",
	[4]="steam:11000010f2b7357",
	[5]="steam:11000011495d1d2",
	[6]="steam:1100001166ffc8b",
	[7]="steam:11000011a09febe",
	[8]="steam:1100001411da9bb",
	[9]="steam:11000010a3beefd",
	[10]="steam:1100001036ee1b7",
	[11]="steam:11000011aeeddd8",
	[12]="steam:11000013d2b0136",
	[13]="steam:11000013be4a271"
}

-- Citizen.CreateThread(function()
-- 	RSCore.Functions.ExecuteSql(true, "SELECT * FROM `vpnwhitelist`", function(result)
-- 		vpnWhitelist = result[1]
-- 	end)
-- end)

-- Player joined
RegisterServerEvent("RSCore:PlayerJoined")
AddEventHandler('RSCore:PlayerJoined', function()
	local src = source
end)

AddEventHandler('playerDropped', function(reason) 
	local src = source
	print("Dropped: "..GetPlayerName(src))
	TriggerEvent("rs-log:server:CreateLog", "joinleave", "Dropped", "red", "**".. GetPlayerName(src) .. "** ("..GetPlayerIdentifiers(src)[1]..") left..")
	TriggerEvent("rs-log:server:sendLog", GetPlayerIdentifiers(src)[1], "joined", {})
	if reason ~= "Reconnecting" and src > 60000 then return false end
	if(src==nil or (RSCore.Players[src] == nil)) then return false end
	RSCore.Players[src].Functions.Save()
	RSCore.Players[src] = nil
end)

-- Checking everything before joining
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	id = GetPlayerIdentifiers(source)[1]
	isWhitelisted = false
	print(id)
	for i, v in ipairs(vpnWhitelist) do
		if(v == id) then
			print("found one: "..id)
			isWhitelisted = true
		end
	end

	if GetNumPlayerIndices() < GetConvarInt('sv_maxclients', 64)  then
		deferrals.defer()
		deferrals.update("Checking Player Information. Please Wait.")
		playerIP = GetPlayerEP(source)

		if string.match(playerIP, ":") then
			playerIP = splitString(playerIP, ":")[1]
		end
		if IsPlayerAceAllowed(source, "blockVPN.bypass") or isWhitelisted == true then
			deferrals.done()
		else 
			PerformHttpRequest('http://check.getipintel.net/check.php?ip=' .. playerIP .. '&contact=' .. ownerEmail .. '&flags=' .. flags, function(statusCode, response, headers)
				if response then
					if tonumber(response) == -5 then
						print('[BlockVPN][ERROR] GetIPIntel seems to have blocked the connection with error code 5 (Either incorrect email, blocked email, or blocked IP. Try changing the contact email)')
					elseif tonumber(response) == -6 then
						print('[BlockVPN][ERROR] A valid contact email is required!')
					elseif tonumber(response) == -4 then
						print('[BlockVPN][ERROR] Unable to reach database. Most likely being updated.')
					else
						if tonumber(response) >= kickThreshold then
							deferrals.done(kickReason)
							if printFailed then
								print('[BlockVPN][BLOCKED] ' .. playerName .. ' has been blocked from joining with a value of ' .. tonumber(response))
							end
						else 
							deferrals.done()
						end
					end
				end
			end)
		end
	end
	
	deferrals.defer()
	local src = source
	deferrals.update("\nChecking name...")
	local name = GetPlayerName(src)
	if name == nil then 
		RSCore.Functions.Kick(src, 'Gelieve geen lege steam naam te gebruiken.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if(string.match(name, "[*%%'=`\"]")) then
        RSCore.Functions.Kick(src, 'Je hebt in je naam een teken('..string.match(name, "[*%%'=`\"]")..') zitten wat niet is toegestaan.\nGelieven deze uit je steam-naam te halen.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if (string.match(name, "drop") or string.match(name, "table") or string.match(name, "database")) then
        RSCore.Functions.Kick(src, 'Je hebt in je naam een woord (drop/table/database) zitten wat niet is toegestaan.\nGelieven je steam naam te veranderen.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	deferrals.update("\nChecking identifiers...")
    local identifiers = GetPlayerIdentifiers(src)
	local steamid = identifiers[1]
	local license = identifiers[2]
    if (RSConfig.IdentifierType == "steam" and (steamid:sub(1,6) == "steam:") == false) then
        RSCore.Functions.Kick(src, 'Je moet steam aan hebben staan om te spelen.', setKickReason, deferrals)
        CancelEvent()
		return false
	elseif (RSConfig.IdentifierType == "license" and (steamid:sub(1,6) == "license:") == false) then
		RSCore.Functions.Kick(src, 'Geen socialclub license gevonden.', setKickReason, deferrals)
        CancelEvent()
		return false
    end
	deferrals.update("\nChecking ban status...")
    local isBanned, Reason = RSCore.Functions.IsPlayerBanned(src)
    if(isBanned) then
        RSCore.Functions.Kick(src, Reason, setKickReason, deferrals)
        CancelEvent()
        return false
    end
	deferrals.update("\nChecking whitelist status...")
    if(not RSCore.Functions.IsWhitelisted(src)) then
        RSCore.Functions.Kick(src, 'Je bent helaas niet gewhitelist of de server is in onderhoud...', setKickReason, deferrals)
        CancelEvent()
        return false
    end
	deferrals.update("\nChecking server status...")
    if(RSCore.Config.Server.closed and not IsPlayerAceAllowed(src, "rsadmin.join")) then
		RSCore.Functions.Kick(_source, 'De server is gesloten:\n'..RSCore.Config.Server.closedReason, setKickReason, deferrals)
        CancelEvent()
        return false
	end
	TriggerEvent("rs-log:server:CreateLog", "joinleave", "Queue", "orange", "**"..name .. "** ("..json.encode(GetPlayerIdentifiers(src))..") in queue..")
	TriggerEvent("rs-log:server:sendLog", GetPlayerIdentifiers(src)[1], "left", {})
	TriggerEvent("connectqueue:playerConnect", src, setKickReason, deferrals)
end)

RegisterServerEvent("RSCore:server:CloseServer")
AddEventHandler('RSCore:server:CloseServer', function(reason)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    if RSCore.Functions.HasPermission(source, "admin") or RSCore.Functions.HasPermission(source, "god") then 
        local reason = reason ~= nil and reason or "Geen reden opgegeven..."
        RSCore.Config.Server.closed = true
        RSCore.Config.Server.closedReason = reason
        TriggerClientEvent("rsadmin:client:SetServerStatus", -1, true)
	else
		RSCore.Functions.Kick(src, "Je hebt hier geen permissie voor loser..", nil, nil)
    end
end)

RegisterServerEvent("RSCore:server:OpenServer")
AddEventHandler('RSCore:server:OpenServer', function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if RSCore.Functions.HasPermission(source, "admin") or RSCore.Functions.HasPermission(source, "god") then
        RSCore.Config.Server.closed = false
        TriggerClientEvent("rsadmin:client:SetServerStatus", -1, false)
    else
        RSCore.Functions.Kick(src, "Je hebt hier geen permissie voor loser..", nil, nil)
    end
end)

RegisterServerEvent("RSCore:UpdatePlayer")
AddEventHandler('RSCore:UpdatePlayer', function(data)
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)

	if Player ~= nil then
		Player.PlayerData.position = data.position

		local newHunger = Player.PlayerData.metadata["hunger"] - 4.2
		local newThirst = Player.PlayerData.metadata["thirst"] - 3.8
		if newHunger <= 0 then newHunger = 0 end
		if newThirst <= 0 then newThirst = 0 end
		Player.Functions.SetMetaData("thirst", newThirst)
		Player.Functions.SetMetaData("hunger", newHunger)

		Player.Functions.AddMoney("bank", Player.PlayerData.job.payment)
		TriggerClientEvent('RSCore:Notify', src, "Je hebt je salaris ontvangen van €"..Player.PlayerData.job.payment)
		TriggerClientEvent("hud:client:UpdateNeeds", src, newHunger, newThirst)

		Player.Functions.Save()
	end
end)

RegisterServerEvent("RSCore:UpdatePlayerPosition")
AddEventHandler("RSCore:UpdatePlayerPosition", function(position)
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.PlayerData.position = position
	end
end)

RegisterServerEvent("RSCore:Server:TriggerCallback")
AddEventHandler('RSCore:Server:TriggerCallback', function(name, ...)
	local src = source
	RSCore.Functions.TriggerCallback(name, src, function(...)
		TriggerClientEvent("RSCore:Client:TriggerCallback", src, name, ...)
	end, ...)
end)

RegisterServerEvent("RSCore:Server:UseItem")
AddEventHandler('RSCore:Server:UseItem', function(item)
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	if item ~= nil and item.amount > 0 then
		if RSCore.Functions.CanUseItem(item.name) then
			RSCore.Functions.UseItem(src, item)
		end
	end
end)

RegisterServerEvent("RSCore:Server:RemoveItem")
AddEventHandler('RSCore:Server:RemoveItem', function(itemName, amount, slot)
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	Player.Functions.RemoveItem(itemName, amount, slot)
end)

RegisterServerEvent('RSCore:Server:AddItem')
AddEventHandler('RSCore:Server:AddItem', function()
	RSCore.Functions.BanInjection(source, "rs-core")
end)

RSCore.Functions.CreateCallback('RSCore:AddItem', function(source, cb, itemName, amount, slot, info)
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	Player.Functions.AddItem(itemName, amount, slot, info)
end)

RegisterServerEvent('RSCore:Server:SetMetaData')
AddEventHandler('RSCore:Server:SetMetaData', function(meta, data)
    local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	if meta == "hunger" or meta == "thirst" then
		if data > 100 then
			data = 100
		end
	end
	if Player ~= nil then 
		Player.Functions.SetMetaData(meta, data)
	end
	TriggerClientEvent("hud:client:UpdateNeeds", src, Player.PlayerData.metadata["hunger"], Player.PlayerData.metadata["thirst"])
end)

AddEventHandler('chatMessage', function(source, n, message)
	if string.sub(message, 1, 1) == "/" then
		local args = RSCore.Shared.SplitStr(message, " ")
		local command = string.gsub(args[1]:lower(), "/", "")
		CancelEvent()
		if RSCore.Commands.List[command] ~= nil then
			local Player = RSCore.Functions.GetPlayer(tonumber(source))
			if Player ~= nil then
				table.remove(args, 1)
				if (RSCore.Functions.HasPermission(source, "god") or RSCore.Functions.HasPermission(source, RSCore.Commands.List[command].permission)) then
					if (RSCore.Commands.List[command].argsrequired and #RSCore.Commands.List[command].arguments ~= 0 and args[#RSCore.Commands.List[command].arguments] == nil) then
					    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alle argumenten moeten ingevuld worden!")
					    local agus = ""
					    for name, help in pairs(RSCore.Commands.List[command].arguments) do
					    	agus = agus .. " ["..help.name.."]"
					    end
				        TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
					else
						RSCore.Commands.List[command].callback(source, args)
					end
				else
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Geen toegang tot dit command!")
				end
			end
		end
	end
end)

RegisterServerEvent('RSCore:CallCommand')
AddEventHandler('RSCore:CallCommand', function(command, args)
	if RSCore.Commands.List[command] ~= nil then
		local Player = RSCore.Functions.GetPlayer(tonumber(source))
		if Player ~= nil then
			if (RSCore.Functions.HasPermission(source, "god")) or (RSCore.Functions.HasPermission(source, RSCore.Commands.List[command].permission)) or (RSCore.Commands.List[command].permission == Player.PlayerData.job.name) then
				if (RSCore.Commands.List[command].argsrequired and #RSCore.Commands.List[command].arguments ~= 0 and args[#RSCore.Commands.List[command].arguments] == nil) then
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alle argumenten moeten ingevuld worden!")
					local agus = ""
					for name, help in pairs(RSCore.Commands.List[command].arguments) do
						agus = agus .. " ["..help.name.."]"
					end
					TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
				else
					RSCore.Commands.List[command].callback(source, args)
				end
			else
				TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Geen toegang tot dit command!")
			end
		end
	end
end)

RegisterServerEvent("RSCore:AddCommand")
AddEventHandler('RSCore:AddCommand', function(name, help, arguments, argsrequired, callback, persmission)
	RSCore.Commands.Add(name, help, arguments, argsrequired, callback, persmission)
end)

RegisterServerEvent("RSCore:ToggleDuty")
AddEventHandler('RSCore:ToggleDuty', function()
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	if Player.PlayerData.job.onduty then
		Player.Functions.SetJobDuty(false)
		TriggerClientEvent('RSCore:Notify', src, "Je bent nu uit dienst!")
	else
		Player.Functions.SetJobDuty(true)
		TriggerClientEvent('RSCore:Notify', src, "Je bent nu in dienst!")
	end
	TriggerClientEvent("RSCore:Client:SetDuty", src, Player.PlayerData.job.onduty)
end)

Citizen.CreateThread(function()
	RSCore.Functions.ExecuteSql(true, "SELECT * FROM `permissions`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				RSCore.Config.Server.PermissionList[v.steam] = {
					steam = v.steam,
					license = v.license,
					permission = v.permission,
					optin = true,
				}
			end
		end
	end)
end)

RSCore.Functions.CreateCallback('RSCore:HasItem', function(source, cb, itemName)
	local retval = false
	local Player = RSCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		if Player.Functions.GetItemByName(itemName) ~= nil then
			retval = true
		end
	end
	
	cb(retval)
end)

RegisterServerEvent('RSCore:Command:CheckOwnedVehicle')
AddEventHandler('RSCore:Command:CheckOwnedVehicle', function(VehiclePlate)
	if VehiclePlate ~= nil then
		RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..VehiclePlate.."'", function(result)
			if result[1] ~= nil then
				RSCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `state` = '1' WHERE `citizenid` = '"..result[1].citizenid.."'")
				TriggerEvent('rs-garages:server:RemoveVehicle', result[1].citizenid, VehiclePlate)
			end
		end)
	end
end)