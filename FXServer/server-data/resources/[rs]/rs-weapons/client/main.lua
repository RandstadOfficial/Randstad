RSCore = nil

local isLoggedIn = true
local CurrentWeaponData = {}
local PlayerData = {}
local CanShoot = true

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

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
        Citizen.Wait(60000)
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    if RSCore.Functions.GetPlayerData() ~= nil then
        TriggerServerEvent("weapons:server:LoadWeaponAmmo")
        isLoggedIn = true
        PlayerData = RSCore.Functions.GetPlayerData()

        RSCore.Functions.TriggerCallback("weapons:server:GetConfig", function(RepairPoints)
            for k, data in pairs(RepairPoints) do
                Config.WeaponRepairPoints[k].IsRepairing = data.IsRepairing
                Config.WeaponRepairPoints[k].RepairingData = data.RepairingData
            end
        end)
    end
end)

local MultiplierAmount = 0

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
                if IsPedShooting(GetPlayerPed(-1)) or IsControlJustPressed(0, 24) then
                    if CanShoot then
                        local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
                        local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon)
                        if RSCore.Shared.Weapons[weapon]["name"] == "weapon_snowball" then
                            TriggerServerEvent('RSCore:Server:RemoveItem', "snowball", 1)
                        elseif RSCore.Shared.Weapons[weapon]["name"] == "weapon_pipebomb" then
                            TriggerServerEvent('RSCore:Server:RemoveItem', "weapon_pipebomb", 1)
                        elseif RSCore.Shared.Weapons[weapon]["name"] == "weapon_molotov" then
                            TriggerServerEvent('RSCore:Server:RemoveItem', "weapon_molotov", 1)
                        elseif RSCore.Shared.Weapons[weapon]["name"] == "weapon_stickybomb" then
                            TriggerServerEvent('RSCore:Server:RemoveItem', "weapon_stickybomb", 1)
                        else
                            if ammo > 0 then
                                MultiplierAmount = MultiplierAmount + 1
                            end
                        end
                    else
                        TriggerEvent('inventory:client:CheckWeapon')
                        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
                        RSCore.Functions.Notify("Dit wapen is gebroken en kan niet gebruikt worden..", "error")
                        MultiplierAmount = 0
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
        local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon)
        if weapon ~= 911657153 and weapon ~= -1169823560 and weapon ~= 615608432 and weapon ~= 741814745 then
            if ammo == 1 then
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                    SetPlayerCanDoDriveBy(PlayerId(), false)
                end
            elseif ammo > 1 then 
                EnableControlAction(0, 24, true) -- Attack
                EnableControlAction(0, 257, true) -- Attack 2
                if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                    SetPlayerCanDoDriveBy(PlayerId(), true)
                end
            end
            if IsPedShooting(GetPlayerPed(-1)) then
                --print('schiet')
                if ammo - 1 < 1 then
                    --print('reset')
                    SetAmmoInClip(GetPlayerPed(-1), GetHashKey(RSCore.Shared.Weapons[weapon]["name"]), 1)
                end
            end
        end
    end
end)

local AmmoTypes = {
    'AMMO_PISTOL',
    'AMMO_SMG',
    'AMMO_RIFLE',
    'AMMO_MG',
    'AMMO_SHOTGUN',
    'AMMO_WATER',
}

Citizen.CreateThread(function()
    while true do
        if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) then
            local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
            local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon)
            for k,v in pairs(AmmoTypes) do
                if RSCore.Shared.Weapons[weapon]["ammotype"] == v then
                    if ammo > 0 then
                        TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
                    else
                        TriggerEvent('inventory:client:CheckWeapon')
                        TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, 0)
                    end

                    if MultiplierAmount > 0 then
                        TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, MultiplierAmount)
                        MultiplierAmount = 0
                    end
                end
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('weapon:client:AddAmmo')
AddEventHandler('weapon:client:AddAmmo', function(type, amount, itemData)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    if CurrentWeaponData ~= nil then
        if RSCore.Shared.Weapons[weapon]["name"] ~= "weapon_unarmed" and RSCore.Shared.Weapons[weapon]["ammotype"] == type:upper() then
            local total = (GetAmmoInPedWeapon(GetPlayerPed(-1), weapon))
            --local Skillbar = exports['rs-skillbar']:GetSkillbarObject()
            local retval = GetMaxAmmoInClip(ped, weapon, 1)
            retval = tonumber(retval)

            -- local WeaponData = RSCore.Shared.Weapons[GetHashKey(CurrentWeaponData.name)]
            -- local WeaponClass = (RSCore.Shared.SplitStr(WeaponData.ammotype, "_")[2]):lower()

            if (total + retval) <= (retval + 1) then
                RSCore.Functions.Progressbar("taking_bullets", "Kogels inladen..", math.random(3000, 5000), false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    if RSCore.Shared.Weapons[weapon] ~= nil then
                        SetAmmoInClip(ped, weapon, 0)
                        SetPedAmmo(ped, weapon, retval+retval)
                        TriggerServerEvent("weapons:server:AddWeaponAmmo", CurrentWeaponData, retval+retval)
                        TriggerServerEvent('RSCore:Server:RemoveItem', itemData.name, 1, itemData.slot)
                        TriggerEvent('inventory:client:ItemBox', RSCore.Shared.Items[itemData.name], "remove")
                        TriggerEvent('RSCore:Notify', retval + retval.." kogels ingeladen!", "success")
                    end
                end, function()
                    RSCore.Functions.Notify("Geannuleerd..", "error")
                end)
            else
                RSCore.Functions.Notify("Je wapen is al geladen..", "error")
            end
        else
            RSCore.Functions.Notify("Je hebt geen wapen vast..", "error")
        end
    else
        RSCore.Functions.Notify("Je hebt geen wapen vast..", "error")
    end
end)

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("weapons:server:LoadWeaponAmmo")
    isLoggedIn = true
    PlayerData = RSCore.Functions.GetPlayerData()

    RSCore.Functions.TriggerCallback("weapons:server:GetConfig", function(RepairPoints)
        for k, data in pairs(RepairPoints) do
            Config.WeaponRepairPoints[k].IsRepairing = data.IsRepairing
            Config.WeaponRepairPoints[k].RepairingData = data.RepairingData
        end
    end)
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
    CanShoot = bool
end)

RegisterNetEvent('RSCore:Client:OnPlayerUnload')
AddEventHandler('RSCore:Client:OnPlayerUnload', function()
    isLoggedIn = false

    for k, v in pairs(Config.WeaponRepairPoints) do
        Config.WeaponRepairPoints[k].IsRepairing = false
        Config.WeaponRepairPoints[k].RepairingData = {}
    end
end)

RegisterNetEvent('weapons:client:SetWeaponQuality')
AddEventHandler('weapons:client:SetWeaponQuality', function(amount)
    if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
        TriggerServerEvent("weapons:server:SetWeaponQuality", CurrentWeaponData, amount)
    end
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            local inRange = false
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)

            for k, data in pairs(Config.WeaponRepairPoints) do
                local distance = GetDistanceBetweenCoords(pos, data.coords.x, data.coords.y, data.coords.z, true)

                if distance < 10 then
                    inRange = true

                    if distance < 1 then
                        if data.IsRepairing then
                            if data.RepairingData.CitizenId ~= PlayerData.citizenid then
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'De repairshop is op dit moment ~r~NIET~w~ beschikbaar..')
                            else
                                if not data.RepairingData.Ready then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'Uw wapen wordt gerepareerd')
                                else
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Wapen terug nemen')
                                end
                            end
                        else
                            if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
                                if not data.RepairingData.Ready then
                                    local WeaponData = RSCore.Shared.Weapons[GetHashKey(CurrentWeaponData.name)]
                                    local WeaponClass = (RSCore.Shared.SplitStr(WeaponData.ammotype, "_")[2]):lower()
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Wapen repareren, ~g~€'..Config.WeaponRepairCotsts[WeaponClass]..'~w~')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        RSCore.Functions.TriggerCallback('weapons:server:RepairWeapon', function(HasMoney)
                                            if HasMoney then
                                                CurrentWeaponData = {}
                                            end
                                        end, k, CurrentWeaponData)
                                    end
                                else
                                    if data.RepairingData.CitizenId ~= PlayerData.citizenid then
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'De repairshop is op dit moment ~r~NIET~w~ beschikbaar..')
                                    else
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Wapen terug nemen')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            TriggerServerEvent('weapons:server:TakeBackWeapon', k, data)
                                        end
                                    end
                                end
                            else
                                if data.RepairingData.CitizenId == nil then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'Je hebt geen wapen in je hand..')
                                elseif data.RepairingData.CitizenId == PlayerData.citizenid then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Wapen terug nemen')
                                    if IsControlJustPressed(0, Keys["E"]) then
                                        TriggerServerEvent('weapons:server:TakeBackWeapon', k, data)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if not inRange then
                Citizen.Wait(1000)
            end
        end
        Citizen.Wait(3)
    end
end)

RegisterNetEvent("weapons:client:SyncRepairShops")
AddEventHandler("weapons:client:SyncRepairShops", function(NewData, key)
    Config.WeaponRepairPoints[key].IsRepairing = NewData.IsRepairing
    Config.WeaponRepairPoints[key].RepairingData = NewData.RepairingData
end)

RegisterNetEvent("weapons:client:EquipAttachment")
AddEventHandler("weapons:client:EquipAttachment", function(ItemData, attachment)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = RSCore.Shared.Weapons[weapon]
    
    if weapon ~= GetHashKey("WEAPON_UNARMED") then
        WeaponData.name = WeaponData.name:upper()
        if Config.WeaponAttachments[WeaponData.name] ~= nil then
            if Config.WeaponAttachments[WeaponData.name][attachment] ~= nil then
                TriggerServerEvent("weapons:server:EquipAttachment", ItemData, CurrentWeaponData, Config.WeaponAttachments[WeaponData.name][attachment])
            else
                RSCore.Functions.Notify("Dit wapen ondersteunt dit attachment niet..", "error")
            end
        end
    else
        RSCore.Functions.Notify("Je hebt geen wapen in je hand..", "error")
    end
end)

RegisterNetEvent("addAttachment")
AddEventHandler("addAttachment", function(component)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = RSCore.Shared.Weapons[weapon]
    GiveWeaponComponentToPed(ped, GetHashKey(WeaponData.name), GetHashKey(component))
end)

Citizen.CreateThread(function()
    while true do
        Wait(3)
        SetPedSuffersCriticalHits(PlayerPedId(), false)
    end
end) 

Citizen.CreateThread(function()
    while true do
    	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYPISTOL"), 0.46) 
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_VINTAGEPISTOL"), 0.43) 
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNSPISTOL"), 0.40) 
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHETE"), 0.25) 
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SWITCHBLADE"), 0.25) 
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIFE"), 0.25) 
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"), 0.25) 
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HATCHET"), 0.25) 
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HAMMER"), 0.25) 
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_WRENCH"), 0.25) 
    	Wait(0)
    end
end)