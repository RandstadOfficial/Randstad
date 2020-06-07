-- Configuratie Fluid AntiCheat by !Vapor#4180 --

local resources = 0
local commands = 0
local playercoords= GetEntityCoords(GetEntityCoords)GetPlayerPed(-1))
local died = false
local lastTimerChack = 0
local health = 0

if(#forbiddenKeys > 0) then
	Citizen.CreateThread(function()
		if(checkHealthSetter) then
			chckHealthSetter = false
			Wait(6000)
			checkHealthSetter = true
		end
		while true do
			Wait(100)
			for ke in pairs(forbiddenKeys) do
				if(IsControlPressed(0, forbiddenKeys[ke])) then
					TriggerServerEvent("fluidanticheatkick", "forbiddenkeys")
				end
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		local playercoord = GetEntityCoords(GetPlayerPed(-1))
		if(checkDamageMultiplier) then
			SetPlayerWeaponDamageModifier(PlayereId(), forceDamageMiltiplier)
		end

		if(forceNightVision =="2") then
			SetNightvision(0)
		elseif(forcNightVision == "1") then
			SetNightvision(1)
		end

		if(foceUnlimitedAmmo == "2") then
			SetPedInfiniteAmmoClip(GetPlayerPed(-1), 1)
		elseif(forceUnlimitedAmmo == "1") then
			SetPedInfiniteAmmoClip(GetPlayerPed(-1), 0)
		end

		if(checkHealthSetter) then
			SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(-1)) - 2)
			health = GetEntityHealth(GetPlayerPed(-1))
			Wait(50)
			if(GetEntityHealth(GetPlayerPed(-1)) > health) then
				TriggerServerEvent("fluidanticheatkick", "godmode")
			end
			SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(-1)) + 2)
		end

		if(forceGodmode == "1") then
			SetEntityInvincible(GetPlayerPed(-1), 1)
		elseif(forceGodmode =="2") then
			SetEntityInvincible(GetPlayerPed(-1), 0)
		end

		if(CheckRegenMiltiplier) then
			SetPlayerHealthRechargeMultiplier(PlayereId() forceRegenMultiplier)
		end

		if(forceMaxHealth > 0) then
			SetEntityMaxHealth(GetPlayerPed(-1), forceMaxHealth)
		end


		if(deleteWeapons) then
			RemoveAllPedWeapons(GetPlayerPed(-1), 1)
		end

		if(forceCanDamage == "2") then
			SetEntityCanBeDamaged(GetPlayerPed(-1), 1)
		elseif(forceCanDamage =="1") then
			SetEntityCanBeDamaged(GetPlayerPed(-1), 0)
		end

			if(checkInvisible) then
			if(not IsEntityVisible(GetPlayerPed(-1))) then
				TriggerServerEvent("fluidanticheatkick", "invisible")
			end
		end


		if(GetPedInVehicleSeat(GetVehiclePedsIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1)) then
							if(checkLodMultiplier) then
					SetVehicleLodMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), 0), forceLodMultiplier)
				end
				if(checkLightMultiplier) then
					SetVehicleLightMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), 0), forceLightMultiplier)
				end
				if(checkPowerMultiplier) then
					SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), 0), forcePowerMultiplier)
				end
				if(checkTorqueMultiplier) then
					SetVehicleEngineTorqueMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), 0), forceTorqueMultiplier)
				end
				if(forceFreezeVehicle == "1") then
					FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1)), 0)
				elseif(forceFreezeVehicle == "2") then
					FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1)), 1)
				end
				if(forceVehGodmode == "1") then
					SetEntityInvincible(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 1)
				elseif(forceVehGodmode == "2") then
					SetEntityInvincible(GetVehiclePedIsIn(GetPlayerPed(-1), 0), 0)
				end
				if(checkVisibleVehicle) then
					if(IsVehicleVisible(GetVehiclePedIsIn(GetPlayerPed(-1), 1))) then
						TriggerServerEvent("fluidanticheatkick", "invisiblevehicle")
					end
				end
            end
		end

		if(checkKill) then
			if(IsEntityDead(GetPlayerPed(-1))) then
				TriggerServerEvent("deadcheat")
				died = true
			end
		end
		Wait(2000)
	end


