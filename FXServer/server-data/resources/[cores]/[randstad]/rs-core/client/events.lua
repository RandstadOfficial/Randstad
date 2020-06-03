-- RSCore Command Events
RegisterNetEvent('RSCore:Command:TeleportToPlayer')
AddEventHandler('RSCore:Command:TeleportToPlayer', function(othersource)
	local coords = RSCore.Functions.GetCoords(GetPlayerPed(GetPlayerFromServerId(othersource)))
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(Entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, coords.x, coords.y, coords.z)
	SetEntityHeading(entity, coords.a)
end)

RegisterNetEvent('RSCore:Command:TeleportToCoords')
AddEventHandler('RSCore:Command:TeleportToCoords', function(x, y, z)
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(Entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, x, y, z)
end)

RegisterNetEvent('RSCore:Command:SpawnVehicle')
AddEventHandler('RSCore:Command:SpawnVehicle', function(model)
	RSCore.Functions.SpawnVehicle(model, function(vehicle)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
		TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
	end)
end)

RegisterNetEvent('RSCore:Command:DeleteVehicle')
AddEventHandler('RSCore:Command:DeleteVehicle', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		RSCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	else
		local vehicle = RSCore.Functions.GetClosestVehicle()
		RSCore.Functions.DeleteVehicle(vehicle)
	end
end)

RegisterNetEvent('RSCore:Command:Revive')
AddEventHandler('RSCore:Command:Revive', function()
	local coords = RSCore.Functions.GetCoords(GetPlayerPed(-1))
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z+0.2, coords.a, true, false)
	SetPlayerInvincible(GetPlayerPed(-1), false)
	ClearPedBloodDamage(GetPlayerPed(-1))
end)

RegisterNetEvent('RSCore:Command:GoToMarker')
AddEventHandler('RSCore:Command:GoToMarker', function()
	Citizen.CreateThread(function()
		local entity = PlayerPedId()
		if IsPedInAnyVehicle(entity, false) then
			entity = GetVehiclePedIsUsing(entity)
		end
		local success = false
		local blipFound = false
		local blipIterator = GetBlipInfoIdIterator()
		local blip = GetFirstBlipInfoId(8)

		while DoesBlipExist(blip) do
			if GetBlipInfoIdType(blip) == 4 then
				cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
				blipFound = true
				break
			end
			blip = GetNextBlipInfoId(blipIterator)
		end

		if blipFound then
			DoScreenFadeOut(250)
			while IsScreenFadedOut() do
				Citizen.Wait(250)
			end
			local groundFound = false
			local yaw = GetEntityHeading(entity)
			
			for i = 0, 1000, 1 do
				SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
				SetEntityRotation(entity, 0, 0, 0, 0 ,0)
				SetEntityHeading(entity, yaw)
				SetGameplayCamRelativeHeading(0)
				Citizen.Wait(0)
				--groundFound = true
				if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
					cz = ToFloat(i)
					groundFound = true
					break
				end
			end
			if not groundFound then
				cz = -300.0
			end
			success = true
		else
			TriggerEvent('esx:showNotification', "~w~Zet een locatie neer waar ~y~ik ~w~heen moet toveren!")
		end

		if success then
			SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
			SetGameplayCamRelativeHeading(0)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
					SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
				end
			end
			--HideLoadingPromt()
			DoScreenFadeIn(250)
		end
	end)
end)

-- Other stuff
RegisterNetEvent('RSCore:Player:SetPlayerData')
AddEventHandler('RSCore:Player:SetPlayerData', function(val)
	RSCore.PlayerData = val
end)

RegisterNetEvent('RSCore:Player:UpdatePlayerData')
AddEventHandler('RSCore:Player:UpdatePlayerData', function()
	local data = {}
	data.position = RSCore.Functions.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('RSCore:UpdatePlayer', data)
end)

RegisterNetEvent('RSCore:Player:UpdatePlayerPosition')
AddEventHandler('RSCore:Player:UpdatePlayerPosition', function()
	local position = RSCore.Functions.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('RSCore:UpdatePlayerPosition', position)
end)

RegisterNetEvent('RSCore:Client:LocalOutOfCharacter')
AddEventHandler('RSCore:Client:LocalOutOfCharacter', function(playerId, playerName, message)
	local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 20.0) then
		TriggerEvent("chatMessage", "OOC | " .. playerName, "normal", message)
    end
end)

RegisterNetEvent('RSCore:Notify')
AddEventHandler('RSCore:Notify', function(text, type, length)
	RSCore.Functions.Notify(text, type, length)
end)

RegisterNetEvent('RSCore:Client:TriggerCallback')
AddEventHandler('RSCore:Client:TriggerCallback', function(name, ...)
	if RSCore.ServerCallbacks[name] ~= nil then
		RSCore.ServerCallbacks[name](...)
		RSCore.ServerCallbacks[name] = nil
	end
end)

RegisterNetEvent("RSCore:Client:UseItem")
AddEventHandler('RSCore:Client:UseItem', function(item)
	TriggerServerEvent("RSCore:Server:UseItem", item)
end)