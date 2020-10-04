local closestStation = 0
local currentStation = 0
CurrentCops = 0
local currentFires = {}
local currentGate = 0

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dist

        if RSCore ~= nil then
            local inRange = false
            for k, v in pairs(Config.PowerStations) do
                dist = GetDistanceBetweenCoords(pos, Config.PowerStations[k].coords.x, Config.PowerStations[k].coords.y, Config.PowerStations[k].coords.z)
                if dist < 5 then
                    closestStation = k
                    inRange = true
                end
            end

            if not inRange then
                Citizen.Wait(1000)
                closestStation = 0
            end
        end
        Citizen.Wait(3)
    end
end)
local requiredItemsShowed = false
local requiredItems = {}
Citizen.CreateThread(function()
    Citizen.Wait(2000)
    requiredItems = {
        [1] = {name = RSCore.Shared.Items["thermite"]["name"], image = RSCore.Shared.Items["thermite"]["image"]},
    }
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        if RSCore ~= nil then
            if closestStation ~= 0 then
                if not Config.PowerStations[closestStation].hit then
                    DrawMarker(2, Config.PowerStations[closestStation].coords.x, Config.PowerStations[closestStation].coords.y, Config.PowerStations[closestStation].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
                    local dist = GetDistanceBetweenCoords(pos, Config.PowerStations[closestStation].coords.x, Config.PowerStations[closestStation].coords.y, Config.PowerStations[closestStation].coords.z)
                    if dist < 1 then
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    else
                        if requiredItemsShowed then
                            requiredItemsShowed = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
            else
                Citizen.Wait(1500)
            end
        end

        Citizen.Wait(1)
    end
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent("thermite:StartFire")
AddEventHandler("thermite:StartFire", function(coords, maxChildren, isGasFire)
    if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, GetEntityCoords(GetPlayerPed(-1))) < 100 then
        local pos = {
            x = coords.x, 
            y = coords.y,
            z = coords.z,
        }
        pos.z = pos.z - 0.9
        local fire = StartScriptFire(pos.x, pos.y, pos.z, maxChildren, isGasFire)
        table.insert(currentFires, fire)
    end
end)

RegisterNetEvent("thermite:StopFires")
AddEventHandler("thermite:StopFires", function()
    for k, v in ipairs(currentFires) do
        RemoveScriptFire(v)
    end
end)

RegisterNetEvent('explosive:UseExplosive')
AddEventHandler('explosive:UseExplosive', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    if currentExplosiveGate ~= 0 then
        if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        end
        if CurrentCops >= Config.MinimumThermitePolice then
            currentGate = currentExplosiveGate
           -- loadAnimDict("missfbi_s4mop")
           -- TaskPlayAnim(GetPlayerPed(-1), "missfbi_s4mop", "plant_bomb_b", 3.0, 3.9, -1, 49, 0, 0, 0, 0)
            GiveWeaponToPed(ped, GetHashKey("weapon_stickybomb"), 1, false, true)
            Citizen.Wait(1000)
            TaskPlantBomb(ped, pos.x, pos.y, pos.z, 218.5)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
            Citizen.Wait(2700)
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "openThermite",
                amount = math.random(5, 10),
            })
            TriggerServerEvent('rs-doorlock:server:updateState', 116, false)
        else
            RSCore.Functions.Notify("Niet genoeg politie.. (2 nodig)", "error")
        end
    end
end)



RegisterNetEvent('thermite:UseThermite')
AddEventHandler('thermite:UseThermite', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    if closestStation ~= 0 then
        if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        end
        local dist = GetDistanceBetweenCoords(pos, Config.PowerStations[closestStation].coords.x, Config.PowerStations[closestStation].coords.y, Config.PowerStations[closestStation].coords.z)
        if dist < 1.5 then
            if CurrentCops >= Config.MinimumThermitePolice then
                if not Config.PowerStations[closestStation].hit then
                    loadAnimDict("weapon@w_sp_jerrycan")
                    TaskPlayAnim(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.9, 180, 49, 0, 0, 0, 0)
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = "openThermite",
                        amount = math.random(5, 10),
                    })
                    currentStation = closestStation
                else
                    RSCore.Functions.Notify("Het lijkt erop dat de zekeringen zijn doorgebrand..", "error")
                end
            else
                RSCore.Functions.Notify("Niet genoeg politie.. (2 nodig)", "error")
            end
        end
    elseif currentThermiteGate ~= 0 then 
        if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        end
        if CurrentCops >= Config.MinimumThermitePolice then
            currentGate = currentThermiteGate
            loadAnimDict("weapon@w_sp_jerrycan")
            TaskPlayAnim(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.9, -1, 49, 0, 0, 0, 0)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "openThermite",
                amount = math.random(5, 10),
            })
        else
            RSCore.Functions.Notify("Niet genoeg politie.. (2 nodig)", "error")
        end
    end
end)

RegisterNetEvent('rs-bankrobbery:client:SetStationStatus')
AddEventHandler('rs-bankrobbery:client:SetStationStatus', function(key, isHit)
    Config.PowerStations[key].hit = isHit
end)

RegisterNUICallback('thermiteclick', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

local SmokeAlpha = 1.0
local SmokePfx = nil

RegisterNUICallback('thermitefailed', function()
    local InRangePacific = false
    local InRangeMaze = false
    SmokeAlpha = 1.0
    if currentGate == currentThermiteGate then
        PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
        TriggerServerEvent("RSCore:Server:RemoveItem", "thermite", 1)
        TriggerEvent('inventory:client:ItemBox', RSCore.Shared.Items["thermite"], "remove")
        ClearPedTasks(GetPlayerPed(-1))
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local randTime = math.random(10000, 15000)
        CreateFire(coords, randTime)
    elseif currentGate == currentExplosiveGate then
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        if GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["thermite"][1]["x"], Config.BigBanks["pacific"]["thermite"][1]["y"], Config.BigBanks["pacific"]["thermite"][1]["z"], true) < 5.0 then
            PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
            TriggerServerEvent("RSCore:Server:RemoveItem", "explosive", 1)
            TriggerEvent('inventory:client:ItemBox', RSCore.Shared.Items["explosive"], "remove")
            ClearPedTasks(GetPlayerPed(-1))
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local randTime = math.random(10000, 15000)
            ClearAreaOfProjectiles(Config.BigBanks["pacific"]["thermite"][1]["x"], Config.BigBanks["pacific"]["thermite"][1]["y"], Config.BigBanks["pacific"]["thermite"][1]["z"], 5.0, false)
            loadParticleDict("des_vaultdoor")
            UseParticleFxAssetNextCall("des_vaultdoor")
            StartParticleFxLoopedOnEntity("ent_ray_pro1_residual_smoke", GetClosestObjectOfType(Config.BigBanks["pacific"]["thermite"][1]["x"], Config.BigBanks["pacific"]["thermite"][1]["y"], Config.BigBanks["pacific"]["thermite"][1]["z"], 2.0, GetHashKey('hei_v_ilev_bk_safegate_pris'), false, false, false), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, false, false, false)
            Citizen.Wait(30000)
            RemoveParticleFxFromEntity(GetClosestObjectOfType(Config.BigBanks["pacific"]["thermite"][1]["x"], Config.BigBanks["pacific"]["thermite"][1]["y"], Config.BigBanks["pacific"]["thermite"][1]["z"], 2.0, GetHashKey('hei_v_ilev_bk_safegate_pris'), false, false, false))
        elseif GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["thermite"][2]["x"], Config.BigBanks["pacific"]["thermite"][2]["y"], Config.BigBanks["pacific"]["thermite"][2]["z"], true) < 5.0 then
            PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
            TriggerServerEvent("RSCore:Server:RemoveItem", "explosive", 1)
            TriggerEvent('inventory:client:ItemBox', RSCore.Shared.Items["explosive"], "remove")
            ClearPedTasks(GetPlayerPed(-1))
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local randTime = math.random(10000, 15000)
            ClearAreaOfProjectiles(Config.BigBanks["pacific"]["thermite"][2]["x"], Config.BigBanks["pacific"]["thermite"][2]["y"], Config.BigBanks["pacific"]["thermite"][2]["z"], 5.0, false)
            loadParticleDict("des_vaultdoor")
            UseParticleFxAssetNextCall("des_vaultdoor")
            StartParticleFxLoopedOnEntity("ent_ray_pro1_residual_smoke", GetClosestObjectOfType(Config.BigBanks["pacific"]["thermite"][2]["x"], Config.BigBanks["pacific"]["thermite"][2]["y"], Config.BigBanks["pacific"]["thermite"][2]["z"], 2.0, GetHashKey('hei_v_ilev_bk_safegate_pris'), false, false, false), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, false, false, false)
            Citizen.Wait(30000)
            RemoveParticleFxFromEntity(GetClosestObjectOfType(Config.BigBanks["pacific"]["thermite"][2]["x"], Config.BigBanks["pacific"]["thermite"][2]["y"], Config.BigBanks["pacific"]["thermite"][2]["z"], 2.0, GetHashKey('hei_v_ilev_bk_safegate_pris'), false, false, false))
        elseif GetDistanceBetweenCoords(pos, Config.BigBanks["maze"]["explosive"]["x"], Config.BigBanks["maze"]["explosive"]["y"], Config.BigBanks["maze"]["explosive"]["z"], true) < 5.0 then    
            PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
            TriggerServerEvent("RSCore:Server:RemoveItem", "explosive", 1)
            TriggerEvent('inventory:client:ItemBox', RSCore.Shared.Items["explosive"], "remove")
            ClearPedTasks(GetPlayerPed(-1))
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local randTime = math.random(10000, 15000)
            ClearAreaOfProjectiles(Config.BigBanks["maze"]["explosive"]["x"], Config.BigBanks["maze"]["explosive"]["y"], Config.BigBanks["maze"]["explosive"]["z"], 5.0, false)
            TriggerServerEvent('sy-bankrobbery:maze:server:DoSmokePfx')
        end
    end
end)

RegisterNetEvent('rs-bankrobbery:maze:client:DoSmokePfx')
AddEventHandler('rs-bankrobbery:maze:client:DoSmokePfx', function()
    if SmokePfx == nil then
        loadParticleDict("des_vaultdoor")
        UseParticleFxAssetNextCall("des_vaultdoor")
        SmokePfx = StartParticleFxLoopedOnEntity("ent_ray_pro1_residual_smoke", GetClosestObjectOfType(Config.BigBanks["maze"]["explosive"]["x"], Config.BigBanks["maze"]["explosive"]["y"], Config.BigBanks["maze"]["explosive"]["z"], 2.0, GetHashKey('maze_hei_v_ilev_bk_safegate_pris'), false, false, false), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, false, false, false)
        SetTimeout(30000, function()
            for i = 1, 1000, 1 do
                SetParticleFxLoopedAlpha(SmokePfx, SmokeAlpha)
                SmokeAlpha = SmokeAlpha - 0.005

                if SmokeAlpha - 0.005 < 0 then
                    RemoveParticleFx(SmokePfx, 0)
                    RemoveParticleFxFromEntity(GetClosestObjectOfType(Config.BigBanks["maze"]["explosive"]["x"], Config.BigBanks["maze"]["explosive"]["y"], Config.BigBanks["maze"]["explosive"]["z"], 2.0, GetHashKey('maze_hei_v_ilev_bk_safegate_pris'), false, false, false))
                    SmokeAlpha = 1.0
                    SmokePfx = nil
                    break
                end
                Wait(25)
            end
        end)
    end
end)

RegisterNUICallback('thermitesuccess', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    if currentGate == currentThermiteGate then
        ClearPedTasks(GetPlayerPed(-1))
        local time = 3
        local coords = GetEntityCoords(GetPlayerPed(-1))
        while time > 0 do 
            RSCore.Functions.Notify("Branden over " .. time .. "..")
            Citizen.Wait(1000)
            time = time - 1
        end
        local randTime = math.random(10000, 15000)
        CreateFire(coords, randTime)
        if currentStation ~= 0 then
            RSCore.Functions.Notify("De zekeringen zijn kapot", "success")
            TriggerServerEvent("sy-bankrobbery:server:SetStationStatus", currentStation, true)
        elseif currentGate ~= 0 then
            RSCore.Functions.Notify("De deur is open gebrand", "success")
            TriggerServerEvent('sy-doorlock:server:updateState', currentGate, false)
            currentGate = 0
        end
    elseif currentGate == currentExplosiveGate then
        if GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["thermite"][1]["x"], Config.BigBanks["pacific"]["thermite"][1]["y"], Config.BigBanks["pacific"]["thermite"][1]["z"], true) < 5.0 then
            ClearPedTasks(GetPlayerPed(-1))
            local time = 5
            local coords = GetEntityCoords(GetPlayerPed(-1))
            while time > 0 do 
                RSCore.Functions.Notify("Ontploffing over " .. time .. "..")
                Citizen.Wait(1000)
                time = time - 1
            end
            local randTime = math.random(10000, 15000)
            AddExplosion(Config.BigBanks["pacific"]["thermite"][1]["x"], Config.BigBanks["pacific"]["thermite"][1]["y"], Config.BigBanks["pacific"]["thermite"][1]["z"], EXPLOSION_STICKYBOMB, 4.0, true, false, 20.0)
            if currentGate ~= 0 then
                RSCore.Functions.Notify("De deur is open geknald", "success")
                TriggerServerEvent('sy-doorlock:server:updateState', currentGate, false)
                currentGate = 0
            end 
        elseif GetDistanceBetweenCoords(pos, Config.BigBanks["pacific"]["thermite"][2]["x"], Config.BigBanks["pacific"]["thermite"][2]["y"], Config.BigBanks["pacific"]["thermite"][2]["z"], true) < 5.0 then
            ClearPedTasks(GetPlayerPed(-1))
            local time = 5
            local coords = GetEntityCoords(GetPlayerPed(-1))
            while time > 0 do 
                RSCore.Functions.Notify("Ontploffing over " .. time .. "..")
                Citizen.Wait(1000)
                time = time - 1
            end
            local randTime = math.random(10000, 15000)
            AddExplosion(Config.BigBanks["pacific"]["thermite"][2]["x"], Config.BigBanks["pacific"]["thermite"][2]["y"], Config.BigBanks["pacific"]["thermite"][2]["z"], EXPLOSION_STICKYBOMB, 4.0, true, false, 20.0)
            if currentGate ~= 0 then
                RSCore.Functions.Notify("De deur is open geknald", "success")
                TriggerServerEvent('sy-doorlock:server:updateState', currentGate, false)
                currentGate = 0
            end
        else    
            ClearPedTasks(GetPlayerPed(-1))
            local time = 5
            local coords = GetEntityCoords(GetPlayerPed(-1))
            while time > 0 do 
                RSCore.Functions.Notify("Ontploffing over " .. time .. "..")
                Citizen.Wait(1000)
                time = time - 1
            end
            local randTime = math.random(10000, 15000)
            AddExplosion(Config.BigBanks["maze"]["explosive"]["x"], Config.BigBanks["maze"]["explosive"]["y"], Config.BigBanks["maze"]["explosive"]["z"], EXPLOSION_STICKYBOMB, 4.0, true, false, 20.0)
            if currentGate ~= 0 then
                RSCore.Functions.Notify("De deur is open geknald", "success")
                TriggerServerEvent('sy-doorlock:server:updateState', currentGate, false)
                currentGate = 0
            end
        end
    end
end)


RegisterNUICallback('closethermite', function()
    SetNuiFocus(false, false)
end)


function CreateFire(coords, time)
    for i = 1, math.random(1, 7), 1 do
        TriggerServerEvent("thermite:StartServerFire", coords, 24, false)
    end
    Citizen.Wait(time)
    TriggerServerEvent("thermite:StopFires")
end

function loadParticleDict(ParticleDict)
    -- Request the particle dictionary.
    RequestNamedPtfxAsset("des_vaultdoor")
    -- Wait for the particle dictionary to load.
    while not HasNamedPtfxAssetLoaded("des_vaultdoor") do
        Citizen.Wait(0)
    end
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 