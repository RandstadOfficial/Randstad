prisonBreak = false
currentGate = 0

local requiredItemsShowed = false
local requiredItems = {}
local inRange = false
local securityLockdown = false

local Gates = {
    [1] = {
        gatekey = 38,
        coords = {x = 1845.99, y = 2604.7, z = 45.58, h = 94.5},  
        hit = false,
    },
    [2] = {
        gatekey = 39,
        coords = {x = 1819.47, y = 2604.67, z = 45.56, h = 98.5},
        hit = false,
    },
    [3] = {
        gatekey = 40,
        coords = {x = 1804.74, y = 2616.311, z = 45.61, h = 335.5},
        hit = false,
    }
}

Citizen.CreateThread(function()
    Citizen.Wait(500)
    requiredItems = {
        [1] = {name = RSCore.Shared.Items["electronickit"]["name"], image = RSCore.Shared.Items["electronickit"]["image"]},
        [2] = {name = RSCore.Shared.Items["gatecrack"]["name"], image = RSCore.Shared.Items["gatecrack"]["image"]},
    }
    while true do 
        Citizen.Wait(5)
        inRange = false
        currentGate = 0
        if isLoggedIn and RSCore ~= nil then
            if RSCore.Functions.GetPlayerData().job.name ~= "police" then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                for k, v in pairs(Gates) do
                    local dist = GetDistanceBetweenCoords(pos, Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, true)
                    if (dist < 1.5) then
                        currentGate = k
                        inRange = true
                        if securityLockdown then
                            RSCore.Functions.DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "~r~SYSTEM LOCKDOWN")
                        elseif Gates[k].hit then
                            RSCore.Functions.DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "SYSTEM BREACH")
                        elseif not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    end
                end

                if not inRange then
                    if requiredItemsShowed then
                        requiredItemsShowed = false
                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    end
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(5000)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z, false) > 200.0 and inJail) then
			inJail = false
            jailTime = 0
            RemoveBlip(currentBlip)
            RemoveBlip(CellsBlip)
            CellsBlip = nil
            RemoveBlip(TimeBlip)
            TimeBlip = nil
            RemoveBlip(ShopBlip)
            ShopBlip = nil
            TriggerServerEvent("prison:server:SecurityLockdown")
            TriggerEvent('prison:client:PrisonBreakAlert')
            TriggerServerEvent("prison:server:SetJailStatus", 0)
            RSCore.Functions.Notify("Je bent ontsnapt.. Maak dat je weg komt!", "error")
		end
	end
end)

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function()
    if currentGate ~= 0 and not securityLockdown and not Gates[currentGate].hit then 
        RSCore.Functions.TriggerCallback('RSCore:HasItem', function(result)
            if result then 
                TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                RSCore.Functions.Progressbar("hack_gate", "Electronic kit aansluiten..", math.random(5000, 10000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "anim@gangops@facility@servers@",
                    anim = "hotwire",
                    flags = 16,
                }, {}, {}, function() -- Done
                    StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    TriggerEvent("mhacking:show")
                    TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 18), OnHackDone)
                end, function() -- Cancel
                    StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    RSCore.Functions.Notify("Geannuleerd..", "error")
                end)
            else
                RSCore.Functions.Notify("Je mist een item..", "error")
            end
        end, "gatecrack")
    end
end)

RegisterNetEvent('prison:client:SetLockDown')
AddEventHandler('prison:client:SetLockDown', function(isLockdown)
    securityLockdown = isLockdown
    if securityLockDown and inJail then
        TriggerEvent("chatMessage", "GEVANGENIS", "error", "Hoogste beveiligingsniveau is actief, blijf bij de cellenblokken!")
    end
end)

RegisterNetEvent('prison:client:PrisonBreakAlert')
AddEventHandler('prison:client:PrisonBreakAlert', function()
    --TriggerEvent("chatMessage", "ALERT", "error", "Attentie alle eenheden! Poging tot uitbraak in de gevangenis!")
    TriggerEvent('rs-policealerts:client:AddPoliceAlert', {
        timeOut = 10000,
        alertTitle = "Gevangenis uitbraak",
        details = {
            [1] = {
                icon = '<i class="fas fa-lock"></i>',
                detail = "Boilingbroke Penitentiary",
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = "Route 68",
            },
        },
        callSign = RSCore.Functions.GetPlayerData().metadata["callsign"],
    })

    local BreakBlip = AddBlipForCoord(Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z)
    TriggerServerEvent('prison:server:JailAlarm')
	SetBlipSprite(BreakBlip , 161)
	SetBlipScale(BreakBlip , 3.0)
	SetBlipColour(BreakBlip, 3)
	PulseBlip(BreakBlip)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait((1000 * 60 * 5))   
    RemoveBlip(BreakBlip)
end)

RegisterNetEvent('prison:client:SetGateHit')
AddEventHandler('prison:client:SetGateHit', function(key, isHit)
    Gates[key].hit = isHit
end)

function OnHackDone(success, timeremaining)
    if success then
        TriggerServerEvent("prison:server:SetGateHit", currentGate)
		TriggerServerEvent('rs-doorlock:server:updateState', Gates[currentGate].gatekey, false)
		TriggerEvent('mhacking:hide')
    else
        TriggerServerEvent("prison:server:SecurityLockdown")
		TriggerEvent('mhacking:hide')
	end
end