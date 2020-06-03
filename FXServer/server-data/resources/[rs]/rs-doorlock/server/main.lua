RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local doorInfo = {}

RegisterServerEvent('rs-doorlock:server:setupDoors')
AddEventHandler('rs-doorlock:server:setupDoors', function()
	local src = source
	TriggerClientEvent("rs-doorlock:client:setDoors", RS.Doors)
end)

RegisterServerEvent('rs-doorlock:server:updateState')
AddEventHandler('rs-doorlock:server:updateState', function(doorID, state)
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	
	RS.Doors[doorID].locked = state

	TriggerClientEvent('rs-doorlock:client:setState', -1, doorID, state)
end)