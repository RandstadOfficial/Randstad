--- FluidAntiCheat By !Vapor#4180: Server Configuration ---

--- CONFIGURATION ---

-- register some fake events (set to "" to disable)
local eventname1 = "antilynx8:anticheat"
local eventname2 = "DiscordBot:playerDied"
local eventname3 = "mellotrainer:adminKick"

-- discord webhook (set to "" to disable)
local webhookurl = "https://discordapp.com/api/webhooks/719170190796914718/g8vMMn9DWknjiIwWZ22DvyKfcWPy1-Bdj9fedtTCcRMEG4oS2IVug1OTnSCAEJ_5j0HK" 

-- Check if command- and resource-count is correct
local checkComsEveRes = true

-- kill detection (only if enabled in client.lua)
local minKills = 7 -- minimal kills to send a sorry

-- detect a manipulated game timer
local gameTimer = false

-- prevent fake chat messages
local checkChatMessage = false -- (might be incompatible with other scripts)

--- CONFIGURATION ---

if(checkChatMessage) then
	RegisterServerEvent("_chat:messageEntered")
	RegisterServerEvent("chat:addMessage")
	AddEventHandler('_chat:messageEntered', function(author, color, message)
		if(GetPlayerName(source)) then
			if(GetPlayerName(source):find(author)) then
				CancelEvent()
				if(IsPlayerAceAllowed(source, "fluidanticheat.bypass")) then
					print("FluidAntiCheat: " .. GetPlayerName(source) .. " [" .. source .. "] should have been kicked, but he is allowed to bypass.")
				else
					TriggerClientEvent("chatMessage", -1, "FluidAntiCheat", {180, 0, 0}, GetPlayerName(source) .. " has been kicked.")
					if(not webhookurl == "") then
						PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = "FluidAntiCheat", content = GetPlayerName(source) .. " [" .. source .. "] has been kicked."}), { ['Content-Type'] = 'application/json' })
					end
					if(reson == "resources") then
						print()
						print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because he sent a fake-chat-message. Identifiers:")
						for id in pairs(GetPlayerIdentifiers(source)) do
							print(GetPlayerIdentifiers(source)[id])
						end
						print()		
						DropPlayer(source, "FluidAntiCheat: This chat-message does not seem to be normal!")
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
					print("FluidAntiCheat: " .. GetPlayerName(source) .. " [" .. source .. "] should have been kicked, but he is allowed to bypass.")
				else
					TriggerClientEvent("chatMessage", -1, "fluidanticheat", {180, 0, 0}, GetPlayerName(source) .. " has been kicked.")
					if(not webhookurl == "") then
						PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = "FluidAntiCheat", content = GetPlayerName(source) .. " [" .. source .. "] has been kicked."}), { ['Content-Type'] = 'application/json' })
					end
					if(reson == "resources") then
						print()
						print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because he sent a fake-chat-message. Identifiers:")
						for id in pairs(GetPlayerIdentifiers(source)) do
							print(GetPlayerIdentifiers(source)[id])
						end
						print()		
						DropPlayer(source, "FluidAntiCheat: This chat-message does not seem to be normal!")
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
	else
		if(GetPlayerName(source)) then
			TriggerClientEvent("chatMessage", -1, "FluidAntiCheat", {180, 0, 0}, GetPlayerName(source) .. " has been kicked.")
		end
		if(not webhookurl == "") then
			PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = "FluidAntiCheat", content = GetPlayerName(source) .. " [" .. source .. "] has been kicked."}), { ['Content-Type'] = 'application/json' })
		end
		if(reson == "resources") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because his resources were manipulated. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()		
			DropPlayer(source, "FluidAntiCheat: Your resources seem to be manipulated!")
		elseif(reson == "commands") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because his commands were manipulated. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: Your commands seem to be manipulated!")
		elseif(reson == "god") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because of using god-mode. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: Seems like you are using god-mode!")
		elseif(reson == "forbiddenkeys") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because of pressing forbidden keys. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: You pressed forbidden keys!")
		elseif(reson == "invisiblevehicle") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because his vehicle was invisible. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: Your vehicle seems to be invisible!")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: Seems like your game-time was manipulated!")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: Your events seem to be manipulated!")
		elseif(reson == "handling") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because his handling was manipulated. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: Your handling seems to be manipulated!")
		elseif(reson == "visible") then
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because he was invisible. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: You seem to be invisible!")
		else
			print()
			print(GetPlayerName(source) .. " [" .. source .. "] has been kicked. Identifiers:")
			for id in pairs(GetPlayerIdentifiers(source)) do
				print(GetPlayerIdentifiers(source)[id])
			end
			print()
			DropPlayer(source, "FluidAntiCheat: You have been kicked, the reason is unknown yet.")
		end
	end
end)

deadplayers = {}
Citizen.CreateThread(function()
	while true do
		if(checkComsEveRes) then
			TriggerClientEvent("hereyourDATAcheat", -1, GetNumResources(), #GetRegisteredCommands())
		end
		if(gameTimer) then
			TriggerClientEvent("gameTimerChack", -1)
		end
		if(#deadplayers > 0) then
			if(#deadplayers >= minKills) then
				for pID in pairs(deadplayers) do
					TriggerClientEvent("chatMessage", deadplayers[pID], "FluidAntiCheat", {180, 0, 0}, "This did not go as planned. Sorry!")
				end
			end
		end
		while(#deadplayers > 0) do
			table.remove(deadplayers, 1)
		end
		Wait(30000)
	end
end)

RegisterServerEvent("deadcheat")
AddEventHandler("deadcheat", function()
	table.insert(deadplayers, source)
end)

if(not eventname1 == "antilynx8") then
	RegisterServerEvent(eventname)
	AddEventHandler(eventname, function()
		print()
		print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because he triggered the wrong event. Identifiers:")
		for id in pairs(GetPlayerIdentifiers(source)) do
			print(GetPlayerIdentifiers(source)[id])
		end
		print()		
		DropPlayer(source, "FluidAntiCheat: You triggered the wrong event!")
	end)
end
if(not eventname2 == "DiscordBot") then
	RegisterServerEvent(eventname)
	AddEventHandler(eventname, function()
		print()
		print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because he triggered the wrong event. Identifiers:")
		for id in pairs(GetPlayerIdentifiers(source)) do
			print(GetPlayerIdentifiers(source)[id])
		end
		print()		
		DropPlayer(source, "FluidAntiCheat: You triggered the wrong event!")
	end)
end
if(not eventname3 == "mellotrainer") then
	RegisterServerEvent(eventname)
	AddEventHandler(eventname, function()
		print()
		print(GetPlayerName(source) .. " [" .. source .. "] has been kicked, because he triggered the wrong event. Identifiers:")
		for id in pairs(GetPlayerIdentifiers(source)) do
			print(GetPlayerIdentifiers(source)[id])
		end
		print()		
		DropPlayer(source, "FluidAntiCheat: You triggered the wrong event!")
	end)
end