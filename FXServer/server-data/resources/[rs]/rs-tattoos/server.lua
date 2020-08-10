RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Functions.CreateCallback('rs-tattoos:GetPlayerTattoos', function(source, cb)
	local src = source
	local xPlayer = RSCore.Functions.GetPlayer(src)

	if xPlayer then

		RSCore.Functions.ExecuteSql(true, "SELECT `tattoos` FROM `players` WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'", function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

RSCore.Functions.CreateCallback('rs-tattoos:GetPlayerTattoosMC', function(source, cb, citizenid)
	local src = source
	local xPlayer = RSCore.Functions.GetPlayer(src)


	RSCore.Functions.ExecuteSql(true, "SELECT `tattoos` FROM `players` WHERE `citizenid` = '"..citizenid.."'", function(result)
		if result[1].tattoos then
			cb(json.decode(result[1].tattoos))
		else
			cb()
		end
	end)
end)

RSCore.Functions.CreateCallback('rs-tattoos:PurchaseTattoo', function(source, cb, tattooList, price, tattoo, tattooName)
	local src = source
	local xPlayer = RSCore.Functions.GetPlayer(src)

	if xPlayer.PlayerData.money.cash >= price then
		xPlayer.Functions.RemoveMoney('cash', price, "tattoo-shop")
		table.insert(tattooList, tattoo)

		RSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `tattoos` = '"..json.encode(tattooList).."' WHERE citizenid = '"..xPlayer.PlayerData.citizenid.."'", function(result)
		end)

		TriggerClientEvent('RSCore:Notify', src, "Je hebt de tattoo " .. tattooName .. " gekocht voor €" .. price, 'success', 3500)
		cb(true)
	elseif xPlayer.PlayerData.money.bank >= price then
		xPlayer.Functions.RemoveMoney('bank', price, "tattoo-shop")
		table.insert(tattooList, tattoo)

		RSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `tattoos` = '"..json.encode(tattooList).."' WHERE citizenid = '"..xPlayer.PlayerData.citizenid.."'", function(result)
		end)

		TriggerClientEvent('RSCore:Notify', src, "Je hebt de tattoo " .. tattooName .. " gekocht voor €" .. price, 'success', 3500)
		cb(true)
	else
		TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet genoeg geld voor deze tattoo.', 'error', 3500)
		cb(false)
	end
end)

RegisterServerEvent('rs-tattoos:RemoveTattoo')
AddEventHandler('rs-tattoos:RemoveTattoo', function (tattooList)
	local src = source
	local xPlayer = RSCore.Functions.GetPlayer(src)
	RSCore.Functions.ExecuteSql(true, "UPDATE `players` SET `tattoos` = '"..json.encode(tattooList).."' WHERE citizenid = '"..xPlayer.PlayerData.citizenid.."'", function(result)
	end)
end)