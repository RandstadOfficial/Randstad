local alcoholCount = 0
local onWeed = false

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(10)
        if alcoholCount > 0 then
            Citizen.Wait(1000 * 60 * 15)
            alcoholCount = alcoholCount - 1
        else
            Citizen.Wait(2000)
        end
    end
end)

function IsInVehicle()
    local Player = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(Player) then
      return true
    else
      return false
    end
end

RegisterNetEvent("consumables:client:UseJoint")
AddEventHandler("consumables:client:UseJoint", function()
    if (IsInVehicle()) then
        RSCore.Functions.Notify("Actie niet mogelijk!", "error")
    else
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
        Citizen.Wait(1000)
        RSCore.Functions.Progressbar("smoke_joint", "Joint opsteken..", 3000, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["joint"], "remove")
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                TriggerEvent('animations:client:EmoteCommandStart', {"smoke3"})
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"smokeweed"})
            end
            TriggerEvent("evidence:client:SetStatus", "weedsmell", 300)
            TriggerEvent('animations:client:SmokeWeed')
        end)
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function EquipParachuteAnim()
    loadAnimDict("clothingshirt")        
    TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

local ParachuteEquiped = false

RegisterNetEvent("consumables:client:UseParachute")
AddEventHandler("consumables:client:UseParachute", function()
    EquipParachuteAnim()
    RSCore.Functions.Progressbar("use_parachute", "Parachute omhangen..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local ped = GetPlayerPed(-1)
        TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["parachute"], "remove")
        GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), 1, false)
        local ParachuteData = {
            outfitData = {
                ["bag"]   = { item = 7, texture = 0},  -- Nek / Das
            }
        }
        TriggerEvent('rs-clothing:client:loadOutfit', ParachuteData)
        ParachuteEquiped = true
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    end)
end)

RegisterNetEvent("consumables:client:ResetParachute")
AddEventHandler("consumables:client:ResetParachute", function()
    if ParachuteEquiped then 
        EquipParachuteAnim()
        RSCore.Functions.Progressbar("reset_parachute", "Parachute inpakken..", 40000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            local ped = GetPlayerPed(-1)
            TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["parachute"], "add")
            local ParachuteRemoveData = { 
                outfitData = { 
                    ["bag"] = { item = 0, texture = 0} -- Nek / Das
                }
            }
            TriggerEvent('rs-clothing:client:loadOutfit', ParachuteRemoveData)
            TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            TriggerServerEvent("rs-smallpenis:server:AddParachute")
            ParachuteEquiped = false
        end)
    else
        RSCore.Functions.Notify("Je hebt geen parachute om!", "error")
    end
end)

-- RegisterNetEvent("consumables:client:UseRedSmoke")
-- AddEventHandler("consumables:client:UseRedSmoke", function()
--     if ParachuteEquiped then
--         local ped = GetPlayerPed(-1)
--         SetPlayerParachuteSmokeTrailColor(ped, 255, 0, 0)
--         SetPlayerCanLeaveParachuteSmokeTrail(ped, true)
--         TriggerEvent("inventory:client:Itembox", RSCore.Shared.Items["smoketrailred"], "remove")
--     else
--         RSCore.Functions.Notify("Je moet een parachute om hebben om rook te activeren!", "error")    
--     end
-- end)


RegisterNetEvent("consumables:client:UseArmorBasic")
AddEventHandler("consumables:client:UseArmorBasic", function()
    RSCore.Functions.Progressbar("use_armor", "Vest aantrekken..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["basic_armor"], "remove")
        TriggerServerEvent('hospital:server:SetArmor', 50)
        TriggerServerEvent("RSCore:Server:RemoveItem", "basic_armor", 1)
        SetPedArmour(GetPlayerPed(-1), 50)
    end)
end)

RegisterNetEvent("consumables:client:UseArmor")
AddEventHandler("consumables:client:UseArmor", function()
    RSCore.Functions.Progressbar("use_armor", "Vest aantrekken..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["armor"], "remove")
        TriggerServerEvent('hospital:server:SetArmor', 75)
        TriggerServerEvent("RSCore:Server:RemoveItem", "armor", 1)
        SetPedArmour(GetPlayerPed(-1), 75)
    end)
end)

local currentVest = nil
local currentVestTexture = nil
RegisterNetEvent("consumables:client:UseHeavyArmor")
AddEventHandler("consumables:client:UseHeavyArmor", function()
    local ped = GetPlayerPed(-1)
    local PlayerData = RSCore.Functions.GetPlayerData()
    RSCore.Functions.Progressbar("use_heavyarmor", "Vest aantrekken..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        if PlayerData.charinfo.gender == 0 then
            currentVest = GetPedDrawableVariation(ped, 9)
            currentVestTexture = GetPedTextureVariation(ped, 9)
            if GetPedDrawableVariation(ped, 9) == 7 then
                SetPedComponentVariation(ped, 9, 19, GetPedTextureVariation(ped, 9), 2)
            else
                SetPedComponentVariation(ped, 9, 5, 2, 2) -- blauw
            end
        else
            currentVest = GetPedDrawableVariation(ped, 30)
            currentVestTexture = GetPedTextureVariation(ped, 30)
            SetPedComponentVariation(ped, 9, 30, 9, 2)
        end
        TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["heavyarmor"], "remove")
        TriggerServerEvent("RSCore:Server:RemoveItem", "heavyarmor", 1)
        SetPedArmour(ped, 100)
    end)
end)

RegisterNetEvent("consumables:client:ResetArmor")
AddEventHandler("consumables:client:ResetArmor", function()
    local ped = GetPlayerPed(-1)
    if currentVest ~= nil and currentVestTexture ~= nil then 
        RSCore.Functions.Progressbar("remove_armor", "Vest uittrekken..", 2500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(ped, 9, currentVest, currentVestTexture, 2)
            SetPedArmour(ped, 0)
            TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["heavyarmor"], "add")
            RSCore.Functions.TriggerCallback('RSCore:AddItem', function()                        
            end, "heavyarmor", 1)
        end)
    else
        RSCore.Functions.Notify("Je hebt geen vest aan..", "error")
    end
end)

RegisterNetEvent("consumables:client:DrinkAlcohol")
AddEventHandler("consumables:client:DrinkAlcohol", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
    RSCore.Functions.Progressbar("snort_coke", "Lekker zuipe..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items[itemName], "remove")
        TriggerServerEvent("RSCore:Server:RemoveItem", itemName, 1)
        TriggerServerEvent("RSCore:Server:SetMetaData", "thirst", RSCore.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
        end
        
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        RSCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNetEvent("consumables:client:Cokebaggy")
AddEventHandler("consumables:client:Cokebaggy", function()
    RSCore.Functions.Progressbar("snort_coke", "Snelle snuivie..", math.random(5000, 8000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerServerEvent("RSCore:Server:RemoveItem", "cokebaggy", 1)
        TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["cokebaggy"], "remove")
        TriggerEvent("evidence:client:SetStatus", "widepupils", 200)
        CokeBaggyEffect()
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        RSCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNetEvent("consumables:client:Crackbaggy")
AddEventHandler("consumables:client:Crackbaggy", function()
    RSCore.Functions.Progressbar("snort_coke", "Crackie roken..", math.random(7000, 10000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerServerEvent("RSCore:Server:RemoveItem", "crack_baggy", 1)
        TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["crack_baggy"], "remove")
        TriggerEvent("evidence:client:SetStatus", "widepupils", 300)
        CrackBaggyEffect()
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        RSCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNetEvent('consumables:client:EcstasyBaggy')
AddEventHandler('consumables:client:EcstasyBaggy', function()
    RSCore.Functions.Progressbar("use_ecstasy", "Pillen poppen", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
        TriggerServerEvent("RSCore:Server:RemoveItem", "xtcbaggy", 1)
        TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["xtcbaggy"], "remove")
        EcstasyEffect()
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
        RSCore.Functions.Notify("Mislukt", "error")
    end)
end)

RegisterNetEvent("consumables:client:Eat")
AddEventHandler("consumables:client:Eat", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
    RSCore.Functions.Progressbar("eat_something", "Eten..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("RSCore:Server:SetMetaData", "hunger", RSCore.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
        TriggerServerEvent('rs-hud:Server:RelieveStress', math.random(2, 4))
    end)
end)

RegisterNetEvent("consumables:client:Drink")
AddEventHandler("consumables:client:Drink", function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
    RSCore.Functions.Progressbar("drink_something", "Drinken..", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("RSCore:Server:SetMetaData", "thirst", RSCore.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
    end)
end)

function EcstasyEffect()
    local startStamina = 30
    SetFlash(0, 0, 500, 7000, 500)
    while startStamina > 0 do 
        Citizen.Wait(1000)
        startStamina = startStamina - 1
        RestorePlayerStamina(PlayerId(), 1.0)
        if math.random(1, 100) < 51 then
            SetFlash(0, 0, 500, 7000, 500)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
        end
    end
    if IsPedRunning(GetPlayerPed(-1)) then
        SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
    end

    startStamina = 0
end

function JointEffect()
    -- if not onWeed then
    --     local RelieveOdd = math.random(35, 45)
    --     onWeed = true
    --     local weedTime = Config.JointEffectTime
    --     Citizen.CreateThread(function()
    --         while onWeed do 
    --             SetPlayerHealthRechargeMultiplier(PlayerId(), 1.8)
    --             Citizen.Wait(1000)
    --             weedTime = weedTime - 1
    --             if weedTime == RelieveOdd then
    --                 TriggerServerEvent('qb-hud:Server:RelieveStress', math.random(14, 18))
    --             end
    --             if weedTime <= 0 then
    --                 onWeed = false
    --             end
    --         end
    --     end)
    -- end
end

function CrackBaggyEffect()
    local startStamina = 8
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)
    while startStamina > 0 do 
        Citizen.Wait(1000)
        if math.random(1, 100) < 10 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina = startStamina - 1
        if math.random(1, 100) < 60 and IsPedRunning(GetPlayerPed(-1)) then
            SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 2000), math.random(1000, 2000), 3, 0, 0, 0)
        end
        if math.random(1, 100) < 51 then
            AlienEffect()
        end
    end
    if IsPedRunning(GetPlayerPed(-1)) then
        SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
    end

    startStamina = 0
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function CokeBaggyEffect()
    local startStamina = 20
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.1)
    while startStamina > 0 do 
        Citizen.Wait(1000)
        if math.random(1, 100) < 20 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina = startStamina - 1
        if math.random(1, 100) < 10 and IsPedRunning(GetPlayerPed(-1)) then
            SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
        end
        if math.random(1, 300) < 10 then
            AlienEffect()
            Citizen.Wait(math.random(3000, 6000))
        end
    end
    if IsPedRunning(GetPlayerPed(-1)) then
        SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
    end

    startStamina = 0
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function AlienEffect()
    StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
    Citizen.Wait(math.random(5000, 8000))
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
    Citizen.Wait(math.random(5000, 8000))    
    StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
    StopScreenEffect("DrugsMichaelAliensFightIn")
    StopScreenEffect("DrugsMichaelAliensFight")
    StopScreenEffect("DrugsMichaelAliensFightOut")
end