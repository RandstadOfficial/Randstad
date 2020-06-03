RSCore = nil

local isLoggedIn = true

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if RSCore == nil then
            TriggerEvent("RSCore:GetObject", function(obj) RSCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        if isLoggedIn then
            TriggerServerEvent("weapons:server:SaveWeaponAmmo")
        end
        Citizen.Wait(((1000 * 60) * 5))
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if IsPedShooting(GetPlayerPed(-1)) then
            local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
            local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon)
            if RSCore.Shared.Weapons[weapon]["name"] == "weapon_snowball" then
                TriggerServerEvent('RSCore:Server:RemoveItem', "snowball", 1)
            else
                TriggerServerEvent("weapons:server:UpdateWeaponAmmo", RSCore.Shared.Weapons[weapon]["ammotype"], tonumber(ammo))
            end
        end
    end 
end)

RegisterNetEvent('weapon:client:AddAmmo')
AddEventHandler('weapon:client:AddAmmo', function(type, amount)
    local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    if RSCore.Shared.Weapons[weapon] ~= nil and RSCore.Shared.Weapons[weapon]["ammotype"] == type:upper() then
        local total = (GetAmmoInPedWeapon(GetPlayerPed(-1), weapon) + amount)
        SetPedAmmo(GetPlayerPed(-1), weapon, total)
    end
    TriggerServerEvent("weapons:server:AddWeaponAmmo", type, amount)
    TriggerServerEvent("weapons:server:SaveWeaponAmmo")
end)

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("weapons:server:LoadWeaponAmmo")
    isLoggedIn = true
end)

RegisterNetEvent('RSCore:Client:OnPlayerUnload')
AddEventHandler('RSCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

