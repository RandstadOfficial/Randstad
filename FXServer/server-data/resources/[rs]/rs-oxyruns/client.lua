RSCore = nil

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if RSCore == nil then
            TriggerEvent("RSCore:GetObject", function(obj) RSCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local tasking = false
local drugStorePed = 0
local oxyVehicle = 0

CurrentCops = 0

local OxyDropOffs = {
	[1] =  { ['x'] = 74.5,['y'] = -762.17,['z'] = 31.68,['h'] = 160.98, ['info'] = ' 1' },
	[2] =  { ['x'] = 100.58,['y'] = -644.11,['z'] = 44.23,['h'] = 69.11, ['info'] = ' 2' },
	[3] =  { ['x'] = 175.45,['y'] = -445.95,['z'] = 41.1,['h'] = 92.72, ['info'] = ' 3' },
	[4] =  { ['x'] = 130.3,['y'] = -246.26,['z'] = 51.45,['h'] = 219.63, ['info'] = ' 4' },
	[5] =  { ['x'] = 198.1,['y'] = -162.11,['z'] = 56.35,['h'] = 340.09, ['info'] = ' 5' },
	[6] =  { ['x'] = 341.0,['y'] = -184.71,['z'] = 58.07,['h'] = 159.33, ['info'] = ' 6' },
	[7] =  { ['x'] = -26.96,['y'] = -368.45,['z'] = 39.69,['h'] = 251.12, ['info'] = ' 7' },
	[8] =  { ['x'] = -155.88,['y'] = -751.76,['z'] = 33.76,['h'] = 251.82, ['info'] = ' 8' },

	[9] =  { ['x'] = -305.02,['y'] = -226.17,['z'] = 36.29,['h'] = 306.04, ['info'] = ' chewy1' },
	[10] =  { ['x'] = -347.19,['y'] = -791.04,['z'] = 33.97,['h'] = 3.06, ['info'] = ' biscuts2' },
	[11] =  { ['x'] = -703.75,['y'] = -932.93,['z'] = 19.22,['h'] = 87.86, ['info'] = ' are3' },
	[12] =  { ['x'] = -659.35,['y'] = -256.83,['z'] = 36.23,['h'] = 118.92, ['info'] = ' only4' },
	[13] =  { ['x'] = -934.18,['y'] = -124.28,['z'] = 37.77,['h'] = 205.79, ['info'] = ' nice5' },
	[14] =  { ['x'] = -1214.3,['y'] = -317.57,['z'] = 37.75,['h'] = 18.39, ['info'] = ' ifthey6' },
	[15] =  { ['x'] = -822.83,['y'] = -636.97,['z'] = 27.9,['h'] = 160.23, ['info'] = ' contain7' },
	[16] =  { ['x'] = 308.04,['y'] = -1386.09,['z'] = 31.79,['h'] = 47.23, ['info'] = ' chocolate' },

}

local carspawns = {
	[1] =  { ['x'] = 79.85,['y'] = -1544.99,['z'] = 29.47,['h'] = 51.55, ['info'] = ' car 8' },
	[2] =  { ['x'] = 66.93,['y'] = -1561.73,['z'] = 29.47,['h'] = 45.73, ['info'] = ' car 1' },
	[3] =  { ['x'] = 68.57,['y'] = -1559.53,['z'] = 29.47,['h'] = 50.6, ['info'] = ' car 2' },
	[4] =  { ['x'] = 70.4,['y'] = -1557.12,['z'] = 29.47,['h'] = 51.18, ['info'] = ' car 3' },
	[5] =  { ['x'] = 72.22,['y'] = -1554.63,['z'] = 29.47,['h'] = 50.32, ['info'] = ' car 4' },
	[6] =  { ['x'] = 73.99,['y'] = -1552.22,['z'] = 29.47,['h'] = 52.47, ['info'] = ' car 5' },
	[7] =  { ['x'] = 76.06,['y'] = -1549.87,['z'] = 29.47,['h'] = 51.53, ['info'] = ' car 6' },
	[8] =  { ['x'] = 77.9,['y'] = -1547.45,['z'] = 29.47,['h'] = 53.24, ['info'] = ' car 7' },
}

local pillWorker = { ['x'] = 68.7,['y'] = -1569.87,['z'] = 29.6,['h'] = 230.65, ['info'] = 'boop bap' }

local rnd = 0
local blip = 0
local deliveryPed = 0

local oxyPeds = {
	'a_m_y_stwhi_02',
	'a_m_y_stwhi_01'
}


local drugLocs = {
	[1] =  { ['x'] = 131.94,['y'] = -1937.95,['z'] = 20.61,['h'] = 118.59, ['info'] = ' Grove Stash' },
	[2] =  { ['x'] = 1390.84,['y'] = -1507.94,['z'] = 58.44,['h'] = 29.6, ['info'] = ' East Side' },
	[3] =  { ['x'] = -676.81,['y'] = -877.94,['z'] = 24.48,['h'] = 324.9, ['info'] = ' Wei Cheng' },
}

local carpick = {
    [1] = "felon",
    [2] = "kuruma",
    [3] = "sultan",
    [4] = "granger",
    [5] = "tailgater",
}

function CreateOxyVehicle()

	if DoesEntityExist(oxyVehicle) then

	    SetVehicleHasBeenOwnedByPlayer(oxyVehicle,false)
		SetEntityAsNoLongerNeeded(oxyVehicle)
		DeleteEntity(oxyVehicle)
	end

    local car = GetHashKey(carpick[math.random(#carpick)])
    RequestModel(car)
    while not HasModelLoaded(car) do
        Citizen.Wait(0)
    end

    local spawnpoint = 1
    for i = 1, #carspawns do
	    local caisseo = GetClosestVehicle(carspawns[i]["x"], carspawns[i]["y"], carspawns[i]["z"], 3.500, 0, 70)
		if not DoesEntityExist(caisseo) then
			spawnpoint = i
		end
    end

    oxyVehicle = CreateVehicle(car, carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"], carspawns[spawnpoint]["h"], true, false)
    local plt = GetVehicleNumberPlateText(oxyVehicle)
	TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(oxyVehicle))
	
	while true do
    	Citizen.Wait(1)
    	 DrawText3Ds(carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"], "Jouw bezorg auto (Gestolen).")
    	 if #(GetEntityCoords(PlayerPedId()) - vector3(carspawns[spawnpoint]["x"], carspawns[spawnpoint]["y"], carspawns[spawnpoint]["z"])) < 8.0 then
    	 	return
    	 end
    end

end

function CreateOxyPed()

    local hashKey = `a_m_y_stwhi_01`

    local pedType = 5

    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end


	deliveryPed = CreatePed(pedType, hashKey, OxyDropOffs[rnd]["x"],OxyDropOffs[rnd]["y"],OxyDropOffs[rnd]["z"], OxyDropOffs[rnd]["h"], 0, 0)
	

    ClearPedTasks(deliveryPed)
    ClearPedSecondaryTask(deliveryPed)
    TaskSetBlockingOfNonTemporaryEvents(deliveryPed, true)
    SetPedFleeAttributes(deliveryPed, 0, 0)
    SetPedCombatAttributes(deliveryPed, 17, 1)

    SetPedSeeingRange(deliveryPed, 0.0)
    SetPedHearingRange(deliveryPed, 0.0)
    SetPedAlertness(deliveryPed, 0)
    SetPedKeepTask(deliveryPed, true)

end

function DeleteCreatedPed()
	print("Deleting Ped?")
	if DoesEntityExist(deliveryPed) then 
		SetPedKeepTask(deliveryPed, false)
		TaskSetBlockingOfNonTemporaryEvents(deliveryPed, false)
		ClearPedTasks(deliveryPed)
		TaskWanderStandard(deliveryPed, 10.0, 10)
		SetPedAsNoLongerNeeded(deliveryPed)

		Citizen.Wait(20000)
		DeletePed(deliveryPed)
	end
end

function DeleteBlip()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

function CreateBlip()
	DeleteBlip()
	if OxyRun then
		blip = AddBlipForCoord(OxyDropOffs[rnd]["x"],OxyDropOffs[rnd]["y"],OxyDropOffs[rnd]["z"])
	end
    
    SetBlipSprite(blip, 514)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Afleveren")
    EndTextCommandSetBlipName(blip)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function playerAnim()
	loadAnimDict( "mp_safehouselost@" )
    TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end

function giveAnim()
    if ( DoesEntityExist( deliveryPed ) and not IsEntityDead( deliveryPed ) ) then 
        loadAnimDict( "mp_safehouselost@" )
        if ( IsEntityPlayingAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 3 ) ) then 
            TaskPlayAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        else
            TaskPlayAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        end     
    end
end

function DoDropOff()
	local success = true
	local OxyChance = math.random(1,1000)

	Citizen.Wait(1000)
	playerAnim()
	Citizen.Wait(800)
	
	PlayAmbientSpeech1(deliveryPed, "Chat_State", "Speech_Params_Force")

	if DoesEntityExist(deliveryPed) and not IsEntityDead(deliveryPed) then

		local counter = math.random(50,200)
		while counter > 0 do
			local crds = GetEntityCoords(deliveryPed)
			counter = counter - 1
			Citizen.Wait(1)
		end
	
		if success then
			local counter = math.random(100,300)
			while counter > 0 do
				local crds = GetEntityCoords(deliveryPed)
				counter = counter - 1
				Citizen.Wait(1)
			end
			giveAnim()
		end
	
		local crds = GetEntityCoords(deliveryPed)
		local crds2 = GetEntityCoords(PlayerPedId())
	
		if #(crds - crds2) > 3.0 or not DoesEntityExist(deliveryPed) or IsEntityDead(deliveryPed) then
			success = false
		end
		
		DeleteBlip()
		if success then

			if OxyChance <= Config.OxyChance then
				RSCore.Functions.TriggerCallback('oxydelivery:server:receiveOxey', function()
				end)
			else
				RSCore.Functions.TriggerCallback('oxydelivery:server:receiveMoney', function()
				end)
			end

			Citizen.Wait(2000)
			RSCore.Functions.Notify("De levering was goed, je pager wordt bijgewerkt met de volgende drop-off", "success", 3000)
		else
			RSCore.Functions.Notify("De levering is gefaald", "error", 3000)
		end
	
		DeleteCreatedPed()
	end
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent("oxydelivery:client")
AddEventHandler("oxydelivery:client", function()

	if tasking then
		return
	end
	
	rnd = math.random(1,#OxyDropOffs)

	CreateBlip()

	local pedCreated = false

	tasking = true
	local toolong = 600000
	while tasking do

		Citizen.Wait(1)
		local plycoords = GetEntityCoords(PlayerPedId())
		local dstcheck = #(plycoords - vector3(OxyDropOffs[rnd]["x"],OxyDropOffs[rnd]["y"],OxyDropOffs[rnd]["z"])) 
		local oxyVehCoords = GetEntityCoords(oxyVehicle)
		local dstcheck2 = #(plycoords - oxyVehCoords) 
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)
		if dstcheck < 40.0 and not pedCreated and (oxyVehicle == veh or dstcheck2 < 15.0) then
			pedCreated = true
			DeleteCreatedPed()
			CreateOxyPed()
			RSCore.Functions.Notify("Je bent dicht bij de drop-off", "success", 3000)
		end
		toolong = toolong - 1
		if toolong < 0 then
		    SetVehicleHasBeenOwnedByPlayer(oxyVehicle,false)
			SetEntityAsNoLongerNeeded(oxyVehicle)
			tasking = false
			OxyRun = false
			RSCore.Functions.Notify("Je bent klaar met rondbrengen, het duurt te lang!", "error", 3000)
			--TriggerClientEvent('RSCore:Notify', source, "Je verkoopt geen oxy meer omdat het lang duurt", "error")
		end
		if dstcheck < 2.0 and pedCreated then
			local crds = GetEntityCoords(deliveryPed)
			DrawText3Ds(crds["x"],crds["y"],crds["z"], "[E] Dealen")  

			if not IsPedInAnyVehicle(PlayerPedId()) and IsControlJustReleased(0,38) then
				checkPedDistance()
				TaskTurnPedToFaceEntity(deliveryPed, PlayerPedId(), 1.0)
				Citizen.Wait(1500)
				PlayAmbientSpeech1(deliveryPed, "Generic_Hi", "Speech_Params_Force")
				DoDropOff()
				tasking = false
			end
		end
	end
	DeleteCreatedPed()
	DeleteBlip()
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if RSCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
			if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["job"].x, Config.Locations["job"].y, Config.Locations["job"].z, true) < 1.5) then
				local hours = GetClockHours()
            	if hours >= Config.MinimumTime and hours <= Config.MaximumTime then
					RSCore.Functions.DrawText3D(Config.Locations["job"].x, Config.Locations["job"].y, Config.Locations["job"].z, "~g~[E]~w~ €1500 - Bezorg Job (Beloning Cash + Oxy)")
					if IsControlJustReleased(0, Keys["E"]) then
						if CurrentCops >= Config.MinimumOxyPolice then
							TriggerServerEvent("oxydelivery:server")
							Citizen.Wait(1000)
						else
							RSCore.Functions.Notify('Niet genoeg agenten..', 'error', 3500)
						end
					end
				else
					RSCore.Functions.DrawText3D(Config.Locations["job"].x, Config.Locations["job"].y, Config.Locations["job"].z, "Apotheek is gesloten (08:00 tot 19:00)")
				end	
			end
		else
            Citizen.Wait(1000)
        end
	end
end)

local firstdeal = false
Citizen.CreateThread(function()
    while true do
        if drugdealer then
	        Citizen.Wait(1000)
	        if firstdeal then
	        	Citizen.Wait(10000)
	        end
	        TriggerEvent("drugdelivery:client")  
		    salecount = salecount + 1
		    if salecount == 12 then
		    	Citizen.Wait(600000)
		    	drugdealer = false
		    end
		    Citizen.Wait(150000)
		    firstdeal = false
		elseif OxyRun then
			if not DoesEntityExist(oxyVehicle) or GetVehicleEngineHealth(oxyVehicle) < 200.0 or GetVehicleBodyHealth(oxyVehicle) < 200.0 then
				OxyRun = false
				tasking = false
				RSCore.Functions.Notify("De dealer geeft je geen locatie meer omdat je auto beschadigd is", "error", 3000)
			else
				if tasking then
			        Citizen.Wait(20000)
			    else
			        TriggerEvent("oxydelivery:client")  
				    salecount = salecount + 1
				    if salecount == Config.RunAmount then
				    	Citizen.Wait(30000)
						OxyRun = false
						RSCore.Functions.Notify("Je bent klaar met rondbrengen, ga terug naar de apotheek!", "success", 3000)
				    end
				end
			end
	    else
			if not close then
				Citizen.Wait(2000)
			end
	    end
    end
end)

RegisterNetEvent("oxydelivery:startDealing")
AddEventHandler("oxydelivery:startDealing", function()
    local NearNPC = GetClosestPed()

	PlayAmbientSpeech1(NearNPC, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
	salecount = 0
	OxyRun = true
	firstdeal = true
	CreateOxyVehicle()
end)


RegisterNetEvent('rs-client:client:executeOxyEvents')
AddEventHandler('rs-client:client:executeOxyEvents', function()
	TriggerServerEvent("oxydelivery:receiveoxy")
	TriggerServerEvent("oxydelivery:receiveBigRewarditem")
	TriggerServerEvent("oxydelivery:receivemoneyyy")
end)


function checkPedDistance()
    local PlayerPeds = {}
    if next(PlayerPeds) == nil then
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            table.insert(PlayerPeds, ped)
        end
    end
    
    local closestPed, closestDistance = RSCore.Functions.GetClosestPed(coords, PlayerPeds)

    if closestDistance < 40 and closestPed ~= 0 then
        local callChance = math.random(1, 100)

        if callChance < 40 then
            doPoliceAlert()
        end
    end
end


function doPoliceAlert()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then 
        streetLabel = streetLabel .. " " .. street2
    end

    TriggerServerEvent('rs-oxyruns:server:callCops', streetLabel, pos)
end

RegisterNetEvent('rs-oxyruns:client:robberyCall')
AddEventHandler('rs-oxyruns:client:robberyCall', function(msg, streetLabel, coords)
	PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
	TriggerEvent('rs-policealerts:client:AddPoliceAlert', {
		timeOut = 5000,
		alertTitle = "Illegaal Drugs Handel",
		coords = {
			x = coords.x,
			y = coords.y,
			z = coords.z,
		},
		details = {
			[1] = {
				icon = '<i class="fas fa-pills"></i>',
				detail = "Illegaal Drugs Handel",
			},
			[2] = {
				icon = '<i class="fas fa-globe-europe"></i>',
				detail = streetLabel,
			},
		},
		callSign = RSCore.Functions.GetPlayerData().metadata["callsign"],
	})
    local transG = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 458)
    SetBlipColour(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipAlpha(blip, transG)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Oxyhandel")
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)


Citizen.CreateThread(function()
    local oldCarPos = nil
    local strike = 0
    while true do
        while oxyVehicle ~= 0 do
            local carPos = GetEntityCoords(oxyVehicle)
            if oldCarPos == math.floor(carPos) then
                strike = strike + 1
            else
                oldCarPos = math.floor(carPos)
                strike = 0
            end
            if strike >= Config.MaxiumStrikes then
                DeleteEntity(oxyVehicle)
                oxyVehicle = 0
            end
            Citizen.Wait(10000)
        end
        Citizen.Wait(5000)
    end
end)

-- Citizen.CreateThread(function()
-- 	local blip = AddBlipForCoord(68.7, -1569.87, 29.6)
-- 	SetBlipSprite(blip, 403)
-- 	SetBlipScale(blip, 0.7)
-- 	SetBlipColour(blip, 38)  
--     SetBlipAsShortRange(blip, true)
--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString("Oxy runs")
--     EndTextCommandSetBlipName(blip)
-- end)