
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

local houseowneridentifier = {}
local houseownercid = {}
local housekeyholders = {}

RegisterServerEvent('rs-houses:server:setHouses')
AddEventHandler('rs-houses:server:setHouses', function()
	local src = source
	TriggerClientEvent("rs-houses:client:setHouseConfig", src, Config.Houses)
end)

RegisterServerEvent('rs-houses:server:addNewHouse')
AddEventHandler('rs-houses:server:addNewHouse', function(street, coords, price, tier)
	local src = source
	local street = street:gsub("%'", "")
	local price = tonumber(price)
	local tier = tonumber(tier)
	local houseCount = GetHouseStreetCount(street)
	local name = street:lower() .. tostring(houseCount)
	local label = street .. " " .. tostring(houseCount)
	RSCore.Functions.ExecuteSql(false, "INSERT INTO `houselocations` (`name`, `label`, `coords`, `owned`, `price`, `tier`) VALUES ('"..name.."', '"..label.."', '"..json.encode(coords).."', 0,"..price..", "..tier..")")
	Config.Houses[name] = {
		coords = coords,
		owned = false,
		price = price,
		locked = true,
		adress = label, 
		tier = tier,
		garage = {},
		decorations = {},
	}
	TriggerClientEvent("rs-houses:client:setHouseConfig", -1, Config.Houses)
	TriggerClientEvent('RSCore:Notify', src, "Je hebt een huis toegevoegd: "..label)
end)

RegisterServerEvent('rs-houses:server:addGarage')
AddEventHandler('rs-houses:server:addGarage', function(house, coords)
	local src = source
	RSCore.Functions.ExecuteSql(false, "UPDATE `houselocations` SET `garage` = '"..json.encode(coords).."' WHERE `name` = '"..house.."'")
	local garageInfo = {
		label = Config.Houses[house].adress,
		takeVehicle = coords,
	}
	TriggerClientEvent("rs-garages:client:addHouseGarage", -1, house, garageInfo)
	TriggerClientEvent('RSCore:Notify', src, "Je hebt een garage toegevoegd bij: "..garageInfo.label)
end)

RegisterServerEvent('rs-houses:server:viewHouse')
AddEventHandler('rs-houses:server:viewHouse', function(house)
	local src     		= source
	local pData 		= RSCore.Functions.GetPlayer(src)

	local houseprice   	= Config.Houses[house].price
	local brokerfee 	= (houseprice / 100 * 5)
	local bankfee 		= (houseprice / 100 * 10) 
	local taxes 		= (houseprice / 100 * 6)

	TriggerClientEvent('rs-houses:client:viewHouse', src, houseprice, brokerfee, bankfee, taxes, pData.PlayerData.charinfo.firstname, pData.PlayerData.charinfo.lastname)
end)

RegisterServerEvent('rs-houses:server:buyHouse')
AddEventHandler('rs-houses:server:buyHouse', function(house)
	local src     	= source
	local pData 	= RSCore.Functions.GetPlayer(src)
	local price   	= Config.Houses[house].price
	local HousePrice = math.ceil(price * 1.21)
	local bankBalance = pData.PlayerData.money["bank"]

	if (bankBalance >= HousePrice) then
		RSCore.Functions.ExecuteSql(false, "INSERT INTO `player_houses` (`house`, `identifier`, `citizenid`, `keyholders`) VALUES ('"..house.."', '"..pData.PlayerData.steam.."', '"..pData.PlayerData.citizenid.."', '"..json.encode(keyyeet).."')")
		houseowneridentifier[house] = pData.PlayerData.steam
		houseownercid[house] = pData.PlayerData.citizenid
		housekeyholders[house] = {
			[1] = pData.PlayerData.citizenid
		}
		RSCore.Functions.ExecuteSql(true, "UPDATE `houselocations` SET `owned` = 1 WHERE `name` = '"..house.."'")
		TriggerClientEvent('rs-houses:client:SetClosestHouse', src)
		pData.Functions.RemoveMoney('bank', HousePrice, "bought-house") -- 21% Extra house costs
	else
		TriggerClientEvent('RSCore:Notify', source, "Je hebt niet genoeg geld..", "error")
	end
end)

RegisterServerEvent('rs-houses:server:lockHouse')
AddEventHandler('rs-houses:server:lockHouse', function(bool, house)
	TriggerClientEvent('rs-houses:client:lockHouse', -1, bool, house)
end)

RegisterServerEvent('rs-houses:server:SetRamState')
AddEventHandler('rs-houses:server:SetRamState', function(bool, house)
	Config.Houses[house].IsRaming = bool
	TriggerClientEvent('rs-houses:server:SetRamState', -1, bool, house)
end)

--------------------------------------------------------------

--------------------------------------------------------------

RSCore.Functions.CreateCallback('rs-houses:server:hasKey', function(source, cb, house)
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	local retval = false
	if Player ~= nil then 
		local identifier = Player.PlayerData.steam
		local CharId = Player.PlayerData.citizenid
		if hasKey(identifier, CharId, house) then
			retval = true
		elseif Player.PlayerData.job.name == "realestate" then
			retval = true
		else
			retval = false
		end
	end
	
	cb(retval)
end)

RSCore.Functions.CreateCallback('rs-houses:server:isOwned', function(source, cb, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		cb(true)
	else
		cb(false)
	end
end)

RSCore.Functions.CreateCallback('rs-houses:server:getHouseOwner', function(source, cb, house)
	cb(houseownercid[house])
end)

RSCore.Functions.CreateCallback('rs-houses:server:getHouseKeyHolders', function(source, cb, house)
	local retval = {}
	local Player = RSCore.Functions.GetPlayer(source)
	if housekeyholders[house] ~= nil then 
		for i = 1, #housekeyholders[house], 1 do
			if Player.PlayerData.citizenid ~= housekeyholders[house][i] then
				RSCore.Functions.ExecuteSql(false, "SELECT `charinfo` FROM `players` WHERE `citizenid` = '"..housekeyholders[house][i].."'", function(result)
					if result[1] ~= nil then 
						local charinfo = json.decode(result[1].charinfo)
						table.insert(retval, {
							firstname = charinfo.firstname,
							lastname = charinfo.lastname,
							citizenid = housekeyholders[house][i],
						})
					end
					cb(retval)
				end)
			end
		end
	else
		cb(nil)
	end
end)

function hasKey(identifier, cid, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		if houseowneridentifier[house] == identifier and houseownercid[house] == cid then
			return true
		else
			if housekeyholders[house] ~= nil then 
				for i = 1, #housekeyholders[house], 1 do
					if housekeyholders[house][i] == cid then
						return true
					end
				end
			end
		end
	end
	return false
end

function getOfflinePlayerData(citizenid)
	exports['ghmattimysql']:execute("SELECT `charinfo` FROM `players` WHERE `citizenid` = '"..citizenid.."'", function(result)
		Citizen.Wait(100)
		if result[1] ~= nil then 
			local charinfo = json.decode(result[1].charinfo)
			return charinfo
		else
			return nil
		end
	end)
end

RegisterServerEvent('rs-houses:server:giveKey')
AddEventHandler('rs-houses:server:giveKey', function(house, target)
	local pData = RSCore.Functions.GetPlayer(target)

	table.insert(housekeyholders[house], pData.PlayerData.citizenid)
	RSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
end)

RegisterServerEvent('rs-houses:server:removeHouseKey')
AddEventHandler('rs-houses:server:removeHouseKey', function(house, citizenData)
	local src = source
	local newHolders = {}
	if housekeyholders[house] ~= nil then 
		for k, v in pairs(housekeyholders[house]) do
			if housekeyholders[house][k] ~= citizenData.citizenid then
				table.insert(newHolders, housekeyholders[house][k])
			end
		end
	end
	housekeyholders[house] = newHolders
	TriggerClientEvent('RSCore:Notify', src, citizenData.firstname .. " " .. citizenData.lastname .. "'s sleutels zijn verwijderd..", 'error', 3500)
	RSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
end)

function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

local housesLoaded = false

Citizen.CreateThread(function()
	while true do
		if not housesLoaded then
			exports['ghmattimysql']:execute('SELECT * FROM player_houses', function(houses)
				if houses ~= nil then
					for _,house in pairs(houses) do
						houseowneridentifier[house.house] = house.identifier
						houseownercid[house.house] = house.citizenid
						housekeyholders[house.house] = json.decode(house.keyholders)
					end
				end
			end)
			housesLoaded = true
		end
		Citizen.Wait(7)
	end
end)

RegisterServerEvent('rs-houses:server:OpenDoor')
AddEventHandler('rs-houses:server:OpenDoor', function(target, house)
    local src = source
    local OtherPlayer = RSCore.Functions.GetPlayer(target)
    if OtherPlayer ~= nil then
        TriggerClientEvent('rs-houses:client:SpawnInApartment', OtherPlayer.PlayerData.source, house)
    end
end)

RegisterServerEvent('rs-houses:server:RingDoor')
AddEventHandler('rs-houses:server:RingDoor', function(house)
    local src = source
    TriggerClientEvent('rs-houses:client:RingDoor', -1, src, house)
end)

RegisterServerEvent('rs-houses:server:savedecorations')
AddEventHandler('rs-houses:server:savedecorations', function(house, decorations)
	local src = source
	RSCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `decorations` = '"..json.encode(decorations).."' WHERE `house` = '"..house.."'")
	TriggerClientEvent("rs-houses:server:sethousedecorations", -1, house, decorations)
end)

RSCore.Functions.CreateCallback('rs-houses:server:getHouseDecorations', function(source, cb, house)
	local retval = nil
	RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `house` = '"..house.."'", function(result)
		if result[1] ~= nil then
			if result[1].decorations ~= nil then
				retval = json.decode(result[1].decorations)
			end
		end
		cb(retval)
	end)
end)

RSCore.Functions.CreateCallback('rs-houses:server:getHouseLocations', function(source, cb, house)
	local retval = nil
	RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `house` = '"..house.."'", function(result)
		if result[1] ~= nil then
			retval = result[1]
		end
		cb(retval)
	end)
end)

RSCore.Functions.CreateCallback('rs-houses:server:getHouseKeys', function(source, cb)
	local src = source
	local pData = RSCore.Functions.GetPlayer(src)
	local cid = pData.PlayerData.citizenid
end)

function mysplit (inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

RSCore.Functions.CreateCallback('rs-houses:server:getOwnedHouses', function(source, cb)
	local src = source
	local pData = RSCore.Functions.GetPlayer(src)

	if pData then
		exports['ghmattimysql']:execute('SELECT * FROM player_houses WHERE identifier = @identifier AND citizenid = @citizenid', {['@identifier'] = pData.PlayerData.steam, ['@citizenid'] = pData.PlayerData.citizenid}, function(houses)
			local ownedHouses = {}

			for i=1, #houses, 1 do
				table.insert(ownedHouses, houses[i].house)
			end

			if houses ~= nil then
				cb(ownedHouses)
			else
				cb(nil)
			end
		end)
	end
end)

RSCore.Functions.CreateCallback('rs-houses:server:getSavedOutfits', function(source, cb)
	local src = source
	local pData = RSCore.Functions.GetPlayer(src)

	if pData then
		exports['ghmattimysql']:execute('SELECT * FROM player_outfits WHERE citizenid = @citizenid', {['@citizenid'] = pData.PlayerData.citizenid}, function(result)
			if result[1] ~= nil then
				cb(result)
			else
				cb(nil)
			end
		end)
	end
end)

RSCore.Commands.Add("decorate", "Decoreer je huisie :)", {}, false, function(source, args)
	TriggerClientEvent("rs-houses:client:decorate", source)
end)

function GetHouseStreetCount(street)
	local count = 1
	RSCore.Functions.ExecuteSql(true, "SELECT * FROM `houselocations` WHERE `name` LIKE '%"..street.."%'", function(result)
		if result[1] ~= nil then 
			for i = 1, #result, 1 do
				count = count + 1
			end
		end
		return count
	end)
	return count
end

RegisterServerEvent('rs-houses:server:LogoutLocation')
AddEventHandler('rs-houses:server:LogoutLocation', function()
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	local MyItems = Player.PlayerData.items
	RSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `inventory` = '"..RSCore.EscapeSqli(json.encode(MyItems)).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
	RSCore.Player.Logout(src)
    TriggerClientEvent('rs-multicharacter:client:chooseChar', src)
end)

RegisterServerEvent('rs-houses:server:giveHouseKey')
AddEventHandler('rs-houses:server:giveHouseKey', function(target, house)
	local src = source
	local tPlayer = RSCore.Functions.GetPlayer(target)
	
	if tPlayer ~= nil then
		if housekeyholders[house] ~= nil then
			for _, cid in pairs(housekeyholders[house]) do
				if cid == tPlayer.PlayerData.citizenid then
					TriggerClientEvent('RSCore:Notify', src, 'Dit persoon heeft al de sleutels van dit huis!', 'error', 3500)
					return
				end
			end		
			table.insert(housekeyholders[house], tPlayer.PlayerData.citizenid)
			RSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
			TriggerClientEvent('rs-houses:client:refreshHouse', tPlayer.PlayerData.source)
			TriggerClientEvent('RSCore:Notify', tPlayer.PlayerData.source, 'Je hebt de sleuteltjes van '..Config.Houses[house].adress..' ontvagen!', 'success', 2500)
		else
			local sourceTarget = RSCore.Functions.GetPlayer(src)
			housekeyholders[house] = {
				[1] = sourceTarget.PlayerData.citizenid
			}
			table.insert(housekeyholders[house], tPlayer.PlayerData.citizenid)
			RSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(housekeyholders[house]).."' WHERE `house` = '"..house.."'")
			TriggerClientEvent('rs-houses:client:refreshHouse', tPlayer.PlayerData.source)
			TriggerClientEvent('RSCore:Notify', tPlayer.PlayerData.source, 'Je hebt de sleuteltjes van '..Config.Houses[house].adress..' ontvagen!', 'success', 2500)
		end
	else
		TriggerClientEvent('RSCore:Notify', src, 'Er is iets mis gegaan.. Probeer het opnieuw!', 'error', 2500)
	end
end)

RegisterServerEvent('test:test')
AddEventHandler('test:test', function(msg)
	print(msg)
end)

RegisterServerEvent('rs-houses:server:setLocation')
AddEventHandler('rs-houses:server:setLocation', function(coords, house, type)
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)

	if type == 1 then
		RSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `stash` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	elseif type == 2 then
		RSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `outfit` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	elseif type == 3 then
		RSCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `logout` = '"..json.encode(coords).."' WHERE `house` = '"..house.."'")
	end

	TriggerClientEvent('rs-houses:client:refreshLocations', -1, house, json.encode(coords), type)
end)

RSCore.Commands.Add("createhouse", "Maak een huis aan als makelaar", {{name="price", help="Prijs van het huis"},{name="tier", help="Naam van het item (geen label)"}}, true, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
	local price = tonumber(args[1])
	local tier = tonumber(args[2])
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("rs-houses:client:createHouses", source, price, tier)
	end
end)

RSCore.Commands.Add("addgarage", "Voeg garage toe bij dichtsbijzijnde huis", {}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("rs-houses:client:addGarage", source)
	end
end)

RegisterServerEvent('rs-houses:server:SetInsideMeta')
AddEventHandler('rs-houses:server:SetInsideMeta', function(insideId, bool)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local insideMeta = Player.PlayerData.metadata["inside"]

    if bool then
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = insideId

        Player.Functions.SetMetaData("inside", insideMeta)
    else
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = nil

        Player.Functions.SetMetaData("inside", insideMeta)
    end
end)

RSCore.Functions.CreateCallback('rs-phone:server:GetPlayerHouses', function(source, cb)
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	local MyHouses = {}
	local keyholders = {}

	RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				v.keyholders = json.decode(v.keyholders)
				if v.keyholders ~= nil and next(v.keyholders) then
					for f, data in pairs(v.keyholders) do
						RSCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..data.."'", function(keyholderdata)
							if keyholderdata[1] ~= nil then
								keyholders[f] = keyholderdata[1]
							end
						end)
					end
				else
					keyholders[1] = Player.PlayerData
				end

				table.insert(MyHouses, {
					name = v.house,
					keyholders = keyholders,
					owner = v.citizenid,
					price = Config.Houses[v.house].price,
					label = Config.Houses[v.house].adress,
					tier = Config.Houses[v.house].tier,
					garage = Config.Houses[v.house].garage,
				})
			end
				
			cb(MyHouses)
		end
	end)
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end

RSCore.Functions.CreateCallback('rs-phone:server:MeosGetPlayerHouses', function(source, cb, input)
	local src = source
	if input ~= nil then
		local search = escape_sqli(input)
		local searchData = {}

		RSCore.Functions.ExecuteSql(false, 'SELECT * FROM `players` WHERE `citizenid` = "'..search..'" OR `charinfo` LIKE "%'..search..'%"', function(result)
			if result[1] ~= nil then
				RSCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `citizenid` = '"..result[1].citizenid.."'", function(houses)
					if houses[1] ~= nil then
						for k, v in pairs(houses) do
							table.insert(searchData, {
								name = v.house,
								keyholders = keyholders,
								owner = v.citizenid,
								price = Config.Houses[v.house].price,
								label = Config.Houses[v.house].adress,
								tier = Config.Houses[v.house].tier,
								garage = Config.Houses[v.house].garage,
								charinfo = json.decode(result[1].charinfo),
								coords = {
									x = Config.Houses[v.house].coords.enter.x,
									y = Config.Houses[v.house].coords.enter.y,
									z = Config.Houses[v.house].coords.enter.z,
								}
							})
						end

						cb(searchData)
					end
				end)
			else
				cb(nil)
			end
		end)
	else
		cb(nil)
	end
end)

RSCore.Functions.CreateUseableItem("police_stormram", function(source, item)
	local Player = RSCore.Functions.GetPlayer(source)

	if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
		TriggerClientEvent("rs-houses:client:HomeInvasion", source)
	else
		TriggerClientEvent('RSCore:Notify', source, "Dit is alleen mogelijk voor hulpdiensten!", "error")
	end
end)

RegisterServerEvent('rs-houses:server:SetHouseRammed')
AddEventHandler('rs-houses:server:SetHouseRammed', function(bool, house)
	Config.Houses[house].IsRammed = bool
	TriggerClientEvent('rs-houses:client:SetHouseRammed', -1, bool, house)
end)

RSCore.Commands.Add("enter", "Betreed huis", {}, false, function(source, args)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
 
    TriggerClientEvent('rs-houses:client:EnterHouse', src)
end)

RSCore.Commands.Add("ring", "Aanbellen bij huis", {}, false, function(source, args)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
 
    TriggerClientEvent('rs-houses:client:RequestRing', src)
end)