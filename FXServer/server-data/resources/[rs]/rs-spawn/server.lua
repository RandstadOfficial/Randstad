RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
Citizen.CreateThread(function()
	local HouseGarages = {}
	RSCore.Functions.ExecuteSql(false, "SELECT * FROM `houselocations`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				local owned = false
				if tonumber(v.owned) == 1 then
					owned = true
				end
				local garage = v.garage ~= nil and json.decode(v.garage) or {}
				Config.Houses[v.name] = {
					coords = json.decode(v.coords),
					owned = v.owned,
					price = v.price,
					locked = true,
					adress = v.label, 
					tier = v.tier,
					garage = garage,
					decorations = {},
				}
				HouseGarages[v.name] = {
					label = v.label,
					takeVehicle = garage,
				}
			end
		end
		TriggerClientEvent("rs-garages:client:houseGarageConfig", -1, HouseGarages)
		TriggerClientEvent("rs-houses:client:setHouseConfig", -1, Config.Houses)
	end)
end)

RSCore.Functions.CreateCallback('rs-spawn:server:getOwnedHouses', function(source, cb, cid)
	if cid ~= nil then
		RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_houses` WHERE `citizenid` = "'..cid..'"', function(houses)
			if houses[1] ~= nil then
				cb(houses)
			else
				cb(nil)
			end
		end)
	else
		cb(nil)
	end
end)