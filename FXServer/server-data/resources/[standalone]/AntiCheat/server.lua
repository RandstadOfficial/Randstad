--- FluidAntiCheat By !Vapor#4180: Server Configuration ---

--- Fake Events (set to "" to disable) ----
local eventname1 = "chocohax:anticheat"
local eventname2 = "antibot:playerDied"
local eventname3 = "adminmenu:adminKick"

local webhookurl = ""

local checkComsEveRes = true --- Check if resource is correct ---

local minKills = 7 --- Minimal kills to detect ---

local checkChatMessage = true --- Testing Phase ---

if(checkChatMessage) then
	RegisterServerEvent("_chat:messageEntered")
	RegisterServerEvent("chat:addMessage")
	AddEventHandler('_chat:messageEntered', function(author, color, message)
		if(GetPlayerName(source)) then
			if(GetPlayerName(source):find(author)) then
				CancelEvent()
				if(IsPlayerAceAllowed(source, "fluidanticheat.bypass")) then
					print("FluidAntiCheat: " .. GetPlayerName(source) .. " [" .. source .. "] Has permissions to use.")
				else
					TriggerClientEvent("chatMessage", -1, "FluidAntiCheat", {180, 0, 0}, GetPlayerName(source) .. " has been kicked.")
					if(not webhookurl == "") then
						PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = "FluidAntiCheat", content = GetPlayerName(source) .. " [" .. source .. "] Has been kicked."}), { ['Content-Type'] = 'application/json' })
					end
					if(reson == "resources") then
						print()
						print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked for a fake message. Identifiers:")
						for id in pairs(GetPlayerIdentifiers(source)) do
							print(GetPlayerIdentifiers(source)[id])
						end
						print()		
						DropPlayer(source, "FluidAntiCheat: Unusual message!")
					end
				end
			end
		end
	end)

	AddEventHandler('chat:addMessage', function(author, color, message)
		if(GetPlayerName(source)) then
			if(GetPlayerName(source):find(author)) then
				CancelEvent()
				if(IsPlayerAceAllowed(source, "fluidanticheat.bypass")) then
					print("FluidAntiCheat: " .. GetPlayerName(source) .. " [" .. source .. "] Has Permissions to use.")
				else
					TriggerClientEvent("chatMessage", -1, "FluidAntiCheat", {180, 0, 0}, GetPlayerName(source) .. " Has been Kicked.")
					if(not webhookurl == "") then
						PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = "FluidAntiCheat", content = GetPlayerName(source) .. " [" .. source .. "] Has been kicked."}), { ['Content-Type'] = 'application/json' })
					end
					if(reson == "resources") then
						print()
						print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked for a fake message. Identifiers:")
						for id in pairs(GetPlayerIdentifiers(source)) do
							print(GetPlayerIdentifiers(source)[id])
						end
						print()		
						DropPlayer(source, "FluidAntiCheat: Unusual message!")
					end
				end
			end
		end
	end)
end

RegisterServerEvent("fluidanticheatkick")
AddEventHandler("fluidanticheatkick", function(reson)
	if(IsPlayerAceAllowed(source, "fluidanticheat.bypass")) then
		if(not reson == "keys") then
			print("FluidAntiCheat: " .. GetPlayerName(source) .. " [" .. source .. "] should have been kicked, but he is allowed to bypass.")
		end
	
		if(GetPlayerName(source)) then
			TriggerClientEvent("chatMessage", -1, "AppleCheat", {180, 0, 0}, GetPlayerName(source) .. " has been kicked.")
		end
		if(not webhookurl == "") then
			PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = "FluidAntiCheat", content = GetPlayerName(source) .. " [" .. source .. "] Has been kicked."}), { ['Content-Type'] = 'application/json' })
		end
			print()
			DropPlayer(source, "FluidAntiCheat: Your commands has changed!")
		elseif(reson == "godmode") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked for godmode. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: Godmode detected!")
		elseif(reson == "forbiddenkeys") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked for forbiddenkeys. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: You used forbiddenkeys!")
		elseif(reson == "invisiblevehicle") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked because vehicle is invisible. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: Your vehicle is invisible!")
		elseif(reson == "tp") then
			print()
			DropPlayer(source, "FluidAntiCheat: Server events has been changed!")
		elseif(reson == "handling") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked for changing vehicle handling. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: Your handling has been changed!")
		elseif(reson == "invisible") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked for being invisible. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: You are invisible!")
		else
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: Player has been kicked.")
		end
	
end)

--- Fake TriggerEvents ---

RegisterServerEvent("deadcheat")
AddEventHandler("deadcheat", function()
	table.insert(deadplayers, source)
end)

if(not eventname1 == "") then
	RegisterServerEvent(eventname)
	AddEventHandler(eventname, function()
		print()
		print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked for disabling a triggerevent. Identifiers:")
		for id in pairs(GetPlayerIdentifiers(source)) do
			print(GetPlayerIdentifiers(source)[id])
		end
		print()		
		DropPlayer(source, "FluidAntiCheat: You disabled a triggerevent!")
	end)
end
if(not eventname2 == "") then
	RegisterServerEvent(eventname)
	AddEventHandler(eventname, function()
		print()
		print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked for disabling a triggerevent. Identifiers:")
		for id in pairs(GetPlayerIdentifiers(source)) do
			print(GetPlayerIdentifiers(source)[id])
		end
		print()		
		DropPlayer(source, "FluidAntiCheat: You disabled a triggerevent!")
	end)
end
if(not eventname3 == "") then
	RegisterServerEvent(eventname)
	AddEventHandler(eventname, function()
		print()
		print(GetPlayerName(source) .. " [" .. source .. "] Has been kicked for disabling a triggerevent. Identifiers:")
		for id in pairs(GetPlayerIdentifiers(source)) do
			print(GetPlayerIdentifiers(source)[id])
		end
		print()		
		DropPlayer(source, "FluidAntiCheat: You disabled a triggerevent!")
	end)
end