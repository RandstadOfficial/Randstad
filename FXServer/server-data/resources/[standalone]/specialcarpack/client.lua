-- Configuratie Fluid AntiCheat by !Vapor#4180 --

--- CONFIGURATION ---

--- PLAYER
-- force godmode
local forceGodmode = "2" -- "0" = disable | "1" = force godmode | "2" = force no godmode
-- check regeneration multiplier
local checkRegenMultiplier = true
-- force regeneration multiplier
local forceRegenMultiplier = 1.0
-- force max health (0 to disable | default: 200)
local forceMaxHealth = 200
-- force can be damaged
local forceCanDamage = "1" -- "0" = disable | "1" = force can be damaged | "2" = force can not be damaged
-- check for health setter
local checkHealthSetter = false -- does not seem to work, needs update
-- check if player is invisible
local checkInvisible = true  -- not tested
-- kill detection: detect when someone killed alot of players (can not undo it, but send a sorry to affected players), more configurations in server.lua
local checkKill = true
-- check if player teleported / used no-clip
local forceNightVision = "2" -- "0" = disable | "1" = force night vision on | "2" = force night vision off
-- force thermal vision
local forceThermalVision = "2" -- "0" = disable | "1" = force thermal vision on | "2" = force thermal vision off

--- VEHICLE
-- check torque multiplier
local checkTorqueMultiplier = true
-- force torque multiplier to
local forceTorqueMultiplier = 1.0
-- check power multiplier
local checkPowerMultiplier = true
--- force power multiplier
local forcePowerMultiplier = 1.0
-- check light multiplier
local checkLightMultiplier = true
-- force light multiplier
local forceLightMultiplier = 1.0
-- check lod multiplier
local checkLodMultiplier = true
-- force lod multiplier
local forceLodMultiplier = 1.0
-- un-/freeze vehicle
local forceFreezeVehicle = "1" -- "0" = disable | "1" = force unfreeze | "2" = force freeze
-- force vehicle godmode
local forceVehGodmode = "2" -- "0" = disable | "1" = force godmode | "2" = force no godmode
-- check vehicle is visible
local checkVisibleVehicle = true  -- not tested

--- WEAPON
-- remove all weapons from player
local deleteWeapons = true
-- force unlimited ammonation
local forceUnlimitedAmmo = "1" -- "0" = disable | "1" = force limited | "2" = force unlimited
-- check damage multiplier
local checkDamageMultiplier = true
-- force damage multipier
local forceDamageMultiplier = 1.0

-- forbidden keys (https://docs.fivem.net/game-references/controls/), remove all to disable
forbiddenKeys = {
}

--- CONFIGURATION ---

local resources = 0
local commands = 0
local playercoords = GetEntityCoords(GetPlayerPed(-1))
local died = false
local lastTimerChack = 0
local health = 0

if(#forbiddenKeys > 0) then
	Citizen.CreateThread(function()
		if(checkHealthSetter) then
			checkHealthSetter = false
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
		local playercoords = GetEntityCoords(GetPlayerPed(-1))
		if(checkDamageMultiplier) then
			SetPlayerWeaponDamageModifier(PlayerId(), forceDamageMultiplier)
			SetPlayerMeleeWeaponDamageModifier(PlayerId(), forceDamageMultiplier)
		end

		if(forceNightVision == "2") then
			SetNightvision(0)
		elseif(forceNightVision == "1") then
			SetNightvision(1)
		end

		if(forceThermalVision == "2") then
			SetSeethrough(0)
		elseif(forceThermalVision == "1") then
			SetSeethrough(1)
		end

		if(forceUnlimitedAmmo == "2") then
			SetPedInfiniteAmmoClip(GetPlayerPed(-1), 1)
		elseif(forceUnlimitedAmmo == "1") then
			SetPedInfiniteAmmoClip(GetPlayerPed(-1), 0)
		end

		if(forceCanDamage == "2") then
			SetEntityCanBeDamaged(GetPlayerPed(-1), 1)
		elseif(forceCanDamage == "1") then
			SetEntityCanBeDamaged(GetPlayerPed(-1), 0)
		end

		if(checkHealthSetter) then
			SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - 2)
			health = GetEntityHealth(GetPlayerPed(-1))
			Wait(50)
			if(GetEntityHealth(GetPlayerPed(-1)) > health) then
				TriggerServerEvent("fluidanticheatkick", "god")
			end
			SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) + 2)
		end

		if(deleteWeapons) then
			RemoveAllPedWeapons(GetPlayerPed(-1), 1)
		end

		if(forceGodmode == "1") then
			SetEntityInvincible(GetPlayerPed(-1), 1)
		elseif(forceGodmode == "2") then
			SetEntityInvincible(GetPlayerPed(-1), 0)
		end

		if(checkRegenMultiplier) then
			SetPlayerHealthRechargeMultiplier(PlayerId(), forceRegenMultiplier)
		end

		if(forceMaxHealth > 0) then
			SetEntityMaxHealth(GetPlayerPed(-1), forceMaxHealth)
		end

		if(checkInvisible) then
			if(not IsEntityVisible(GetPlayerPed(-1))) then
				TriggerServerEvent("fluidanticheatkick", "visible")
			end
		end

		if(not resources == 0 and not GetNumResources() == resources) then
			TriggerServerEvent("fluidanticheatkick", "resources")
		elseif(not commands == 0 and not #GetRegisteredCommands() == commands) then
			TriggerServerEvent("fluidanticheatkick", "commands")
		end
			if(GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1)) then
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
						TriggerServerEvent("anticheatkick", "invisiblevehicle")
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
end)

RegisterNetEvent("hereyourDATAcheat")
AddEventHandler("hereyourDATAcheat", function(res, com)
	resources = res
	commands = com
end)

RegisterNetEvent("gameTimerChack")
AddEventHandler("gameTimerChack", function()
	if(lastTimerChack == 0) then
		lastTimerChack = GetGameTimer()
	else
		if(lastTimerChack - GetGameTimer > 31000 or lastTimerChack - GetGameTimer < 30000) then
			TriggerServerEvent("fluidanticheatkick", "gametimer")
		end
		lastTimerChack = GetGameTimer()
	end
end)