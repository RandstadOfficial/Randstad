RSCore = nil
local isLoggedIn = false
PlayerData = {}
PlayerJob = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if RSCore == nil then
            TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local HotdogBlip = nil
local IsWorking = false
local StandObject = nil
local IsPushing = false
local IsSelling = false
local IsUIActive = false
local PreparingFood = false
local SpatelObject = nil
local SellingData = {
    Enabled = false,
    Target = nil,
    HasTarget = false,
    RecentPeds = {},
    Hotdog = nil,
}
local OffsetData = {
    x = 0.0,
    y = -0.8,
    z = 1.0,
    Distance = 0.5
}
local LastStandPos = nil

local AnimationData = {
    lib = "missfinale_c2ig_11",
    anim = "pushcar_offcliff_f",
}

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = RSCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    UpdateLevel()
    UpdateBlip()
end)

RegisterNetEvent('RSCore:Client:OnJobUpdate')
AddEventHandler('RSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    UpdateBlip()
end)

-- Citizen.CreateThread(function()
--     while RSCore == nil do
--         Citizen.Wait(100)
--     end
--     isLoggedIn = true
--     PlayerData = RSCore.Functions.GetPlayerData()
--     PlayerJob = PlayerData.job
--     UpdateLevel()
--     UpdateBlip()
-- end)

function UpdateBlip()
    Citizen.CreateThread(function()
        local coords = Config.Locations["take"].coords

        if HotdogBlip ~= nil then
            RemoveBlip(HotdogBlip)
        end

        HotdogBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        
        SetBlipSprite(HotdogBlip, 93)
        SetBlipDisplay(HotdogBlip, 4)
        SetBlipScale(HotdogBlip, 0.6)
        SetBlipAsShortRange(HotdogBlip, true)
        SetBlipColour(HotdogBlip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Chihuahua Hotdogs")
        EndTextCommandSetBlipName(HotdogBlip)
    end)
end

function UpdateLevel()
    local MyRep = PlayerData.metadata["jobrep"]["hotdog"]

    if MyRep ~= nil then
        if MyRep >= 1 and MyRep < 50 then
            Config.MyLevel = 1
        elseif MyRep >= 50 and MyRep < 100 then
            Config.MyLevel = 2
        elseif MyRep >= 100 and MyRep < 200 then
            Config.MyLevel = 3
        elseif MyRep >= 100 and MyRep < 200 then
            Config.MyLevel = 3
        elseif MyRep >= 200 then
            Config.MyLevel = 4
        end
    else
        Config.MyLevel = 1
    end

    local ReturnData = {
        lvl = Config.MyLevel,
        rep = MyRep
    }

    return ReturnData
end

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
        local inRange = false
        if isLoggedIn then
            if Config ~= nil then
                local PlayerPed = GetPlayerPed(-1)
                local PlayerPos = GetEntityCoords(PlayerPed)
                local v = Config.Locations["take"]
                local distance = GetDistanceBetweenCoords(PlayerPos, v.coords.x, v.coords.y, v.coords.z, true)
                if distance < 10 then
                    inRange = true
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, 0, 0, 0, 1, 0, 0, 0)
                    if not IsWorking then
                        if distance < OffsetData.Distance then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "[E] Begin met werken")
                            if IsControlJustPressed(0, Keys["E"]) then
                                StartWorking()
                            end
                        elseif distance < 3 then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "Begin met werken")
                        end
                    else
                        if distance < OffsetData.Distance then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "[E] Stop met werken")
                            if IsControlJustPressed(0, Keys["E"]) then
                                StopWorking()
                            end
                        elseif distance < 3 then
                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "Stop met werken")
                        end
                    end
                end
            end
        end
        if not inRange then
            Citizen.Wait(1000)
        end
        Citizen.Wait(3)
    end
end)

function StartWorking()
    RSCore.Functions.TriggerCallback('rs-hotdogjob:server:HasMoney', function(HasMoney)
        if HasMoney then
            local PlayerPed = GetPlayerPed(-1)
            local SpawnCoords = Config.Locations["spawn"].coords
            IsWorking = true
        
            LoadModel("prop_hotdogstand_01")
            StandObject = CreateObject(GetHashKey('prop_hotdogstand_01'), SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, true)
            PlaceObjectOnGroundProperly(StandObject)
            SetEntityHeading(StandObject, SpawnCoords.h - 90)
            FreezeEntityPosition(StandObject, true)
            HotdogLoop()
            UpdateUI()
            CheckLoop()
            RSCore.Functions.Notify('Je hebt €1000,- borg betaald!..', 'success')
        else
            RSCore.Functions.Notify('Je hebt geen geld voor de borg..', 'error')
        end
    end)
end

function UpdateUI()
    IsUIActive = true
    Citizen.CreateThread(function()
        while true do
            SendNUIMessage({
                action = "UpdateUI",
                IsActive = IsUIActive,
                Stock = Config.Stock,
                Level = UpdateLevel()
            })
            if not IsUIActive then
                break
            end
            Citizen.Wait(1000)
        end
    end)
end

function HotdogLoop()
    Citizen.CreateThread(function()
        while true do
            local PlayerPed = GetPlayerPed(-1)
            local PlayerPos = GetEntityCoords(PlayerPed)
            local ClosestObject = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 3.0, GetHashKey("prop_hotdogstand_01"), 0, 0, 0)

            if StandObject ~= nil then
                if ClosestObject ~= nil and ClosestObject == StandObject then
                    local ObjectOffset = GetOffsetFromEntityInWorldCoords(ClosestObject, 1.0, 0.0, 1.0)
                    local ObjectDistance = GetDistanceBetweenCoords(PlayerPos, ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, true)

                    if ObjectDistance < 1.0 then
                        if not IsPushing then
                            DrawText3Ds(ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, '[E] Kraam vastpakken')
                            if IsControlJustPressed(0, Keys["E"]) then
                                TakeHotdogStand()
                            end
                        else
                            DrawText3Ds(ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, '[E] Kraam loslaten')
                            if IsControlJustPressed(0, Keys["E"]) then
                                LetKraamLose()
                            end
                        end
                    elseif ObjectDistance < 3.0 then
                        DrawText3Ds(ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, 'Kraam vastpakken')
                    end
                end
            else
                break
            end

            Citizen.Wait(3)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            local PlayerPed = GetPlayerPed(-1)
            local PlayerPos = GetEntityCoords(PlayerPed)
            local ClosestObject = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 3.0, GetHashKey("prop_hotdogstand_01"), 0, 0, 0)

            if StandObject ~= nil then
                if ClosestObject ~= nil and ClosestObject == StandObject then
                    local ObjectOffset = GetOffsetFromEntityInWorldCoords(StandObject, 0.0, 0.0, 1.0)
                    local ObjectDistance = GetDistanceBetweenCoords(PlayerPos, ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, true)

                    if ObjectDistance < 1.0 then
                        if SellingData.Enabled then
                            DrawText3Ds(ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, '[E] Hotdog bereiden [Verkoop: ~g~AAN~w~]')
                        else
                            DrawText3Ds(ObjectOffset.x, ObjectOffset.y, ObjectOffset.z, '[E] Hotdog bereiden [Verkoop: ~r~UIT~w~]')
                        end
                        if IsControlJustPressed(0, Keys["E"]) then
                            StartHotdogMinigame()
                        end
                    end
                end
            else
                break
            end

            Citizen.Wait(3)
        end
    end)
end

RegisterNetEvent('rs-hotdogjob:client:UpdateReputation')
AddEventHandler('rs-hotdogjob:client:UpdateReputation', function(JobRep)
    PlayerData.metadata["jobrep"] = JobRep
    UpdateLevel()
end)

RegisterNetEvent('rs-hotdogjob:client:ToggleSell')
AddEventHandler('rs-hotdogjob:client:ToggleSell', function(data)
    if not SellingData.Enabled then
        SellingData.Enabled = true
        ToggleSell()
    else
        if SellingData.Target ~= nil then
            SetPedKeepTask(SellingData.Target, false)
            SetEntityAsNoLongerNeeded(SellingData.Target)
            ClearPedTasksImmediately(SellingData.Target)
        end
        SellingData.Enabled = false
        SellingData.Target = nil
        SellingData.HasTarget = false
    end
end)

function ToggleSell()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local objpos = GetEntityCoords(StandObject)
    local dist = GetDistanceBetweenCoords(pos, objpos.x, objpos.y, objpos.z, true)

    if StandObject ~= nil then
        if dist < 5.0 then
            Citizen.CreateThread(function()
                while true do
                    if SellingData.Enabled then
                        local player = GetPlayerPed(-1)
                        local coords = GetOffsetFromEntityInWorldCoords(StandObject, OffsetData.x, OffsetData.y, OffsetData.z)

                        if not SellingData.HasTarget then
                            local PlayerPeds = {}
                            if next(PlayerPeds) == nil then
                                for _, player in ipairs(GetActivePlayers()) do
                                    local ped = GetPlayerPed(player)
                                    table.insert(PlayerPeds, ped)
                                end
                            end
                            
                            local closestPed, closestDistance = RSCore.Functions.GetClosestPed(coords, PlayerPeds)

                            if closestDistance < 15.0 and closestPed ~= 0 then
                                SellToPed(closestPed)
                            end
                        end
                    else
                        break
                    end
                    Citizen.Wait(100)
                end
            end)
        else
            RSCore.Functions.Notify('Je bent te-ver van je Hotdogkraam af..', 'error')
        end
    else
        RSCore.Functions.Notify('Je hebt geen Hotdogkraam', 'error')
    end
end

function GetAvailableHotdog()
    local retval = nil
    local AvailableHotdogs = {}
    for k, v in pairs(Config.Stock) do
        if v.Current > 0 then
            table.insert(AvailableHotdogs, {
                key = k,
                value = v,
            })
        end
    end
    if next(AvailableHotdogs) ~= nil then
        local Random = math.random(1, #AvailableHotdogs)
        retval = AvailableHotdogs[Random].key
    end
    return retval
end

function SellToPed(ped)
    SellingData.HasTarget = true
    for i = 1, #SellingData.RecentPeds, 1 do
        if SellingData.RecentPeds[i] == ped then
            SellingData.HasTarget = false
            return
        end
    end

    SetEntityAsNoLongerNeeded(ped)
    ClearPedTasks(ped)

    local SellingPrice = 0
    local HotdogsForSale = 0

    local Selling = false
    local HotdogObject = nil
    local HotdogObject2 = nil
    local AnimPlayed = false

    SellingData.Hotdog = GetAvailableHotdog()

    if SellingData.Hotdog ~= nil then
        if Config.Stock[SellingData.Hotdog].Current > 1 then
            if Config.Stock[SellingData.Hotdog].Current >= 3 then
                HotdogsForSale = math.random(1, 3)
            else
                HotdogsForSale = math.random(1, Config.Stock[SellingData.Hotdog].Current)
            end
        elseif Config.Stock[SellingData.Hotdog].Current == 1 then
            HotdogsForSale = 1
        end

        if SellingData.Hotdog ~= nil then
            SellingPrice = math.random(Config.Stock[SellingData.Hotdog].Price[Config.MyLevel].min, Config.Stock[SellingData.Hotdog].Price[Config.MyLevel].max)
        end
    end

    local coords = GetOffsetFromEntityInWorldCoords(StandObject, OffsetData.x, OffsetData.y, OffsetData.z)
    local pedCoords = GetEntityCoords(ped)
    local pedDist = GetDistanceBetweenCoords(coords, pedCoords)
    local PlayerDist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coords.x, coords.y, coords.z)

    TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)

    while pedDist > OffsetData.Distance do
        coords = GetOffsetFromEntityInWorldCoords(StandObject, OffsetData.x, OffsetData.y, OffsetData.z)
        PlayerDist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coords.x, coords.y, coords.z)
        pedCoords = GetEntityCoords(ped)    
        TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)
        pedDist = GetDistanceBetweenCoords(coords, pedCoords)
        if PlayerDist > 15.0 then
            SellingData.HasTarget = false
            SetPedKeepTask(ped, false)
            SetEntityAsNoLongerNeeded(ped)
            ClearPedTasksImmediately(ped)
            table.insert(SellingData.RecentPeds, ped)
            SellingData = {
                Enabled = false,
                Target = nil,
                HasTarget = false,
                Hotdog = nil,
            }
            RSCore.Functions.Notify('Je bent te-ver van je kraam..', 'error')
            break
        end
        Citizen.Wait(100)
    end

    FreezeEntityPosition(ped, true)
    TaskLookAtEntity(ped, GetPlayerPed(-1), 5500.0, 2048, 3)
    TaskTurnPedToFaceEntity(ped, GetPlayerPed(-1), 5500)
    local heading = (GetEntityHeading(GetPlayerPed(-1)) + 180)
    SetEntityHeading(ped, heading)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, false)
    SellingData.Target = ped

    while pedDist < OffsetData.Distance and SellingData.HasTarget do
        coords = GetOffsetFromEntityInWorldCoords(StandObject, OffsetData.x, OffsetData.y, OffsetData.z)
        PlayerDist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coords.x, coords.y, coords.z)
        pedCoords = GetEntityCoords(ped)
        pedDist = GetDistanceBetweenCoords(coords, pedCoords)

        if PlayerDist < 7.5 then
            if SellingData.Hotdog ~= nil then
                if HotdogsForSale == 0 and SellingPrice == 0 then
                    if Config.Stock[SellingData.Hotdog].Current > 1 then
                        if Config.Stock[SellingData.Hotdog].Current >= 3 then
                            HotdogsForSale = math.random(1, 3)
                        else
                            HotdogsForSale = math.random(1, Config.Stock[SellingData.Hotdog].Current)
                        end
                    elseif Config.Stock[SellingData.Hotdog].Current == 1 then
                        HotdogsForSale = 1
                    end
            
                    if SellingData.Hotdog ~= nil then
                        SellingPrice = math.random(Config.Stock[SellingData.Hotdog].Price.min, Config.Stock[SellingData.Hotdog].Price.max)
                    end
                end
                RSCore.Functions.DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, '[7] Verkoop '..HotdogsForSale..'x voor €'..(HotdogsForSale * SellingPrice)..',- / [8] Afwijzen')
                if IsControlJustPressed(0, Keys["7"]) or IsDisabledControlJustPressed(0, Keys["7"]) then
                    RSCore.Functions.Notify(HotdogsForSale..'x Hotdog(\'s) verkocht voor €'..(HotdogsForSale * SellingPrice)..',-', 'success')
                   
                    RSCore.Functions.TriggerCallback('rs-hotdogjob:server:Sell', function(result)
                    end, HotdogsForSale, SellingPrice)

                    -- TriggerServerEvent('rs-hotdogjob:server:Sell', HotdogsForSale, SellingPrice)
                    SellingData.HasTarget = false
                    local Myped = GetPlayerPed(-1)

                    Selling = true

                    while Selling do
                        if not IsEntityPlayingAnim(Myped, 'mp_common', 'givetake1_b', 3) then
                            LoadAnim('mp_common')
                            if not AnimPlayed then
                                TaskPlayAnim(Myped, 'mp_common', 'givetake1_b', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
                                AnimPlayed = true
                            end
                            if HotdogObject == nil then
                                HotdogObject = CreateObject(GetHashKey("prop_cs_hotdog_01"), 0, 0, 0, true, true, true)
                            end
                            AttachEntityToEntity(HotdogObject, Myped, GetPedBoneIndex(Myped, 57005), 0.12, 0.0, -0.05, 220.0, 120.0, 0.0, true, true, false, true, 1, true)
                            SetTimeout(1250, function()
                                Selling = false
                            end)
                        end

                        Citizen.Wait(0)
                    end

                    if HotdogObject ~= nil then
                        DetachEntity(HotdogObject, 1, 1)
                        DeleteEntity(HotdogObject)
                        AnimPlayed = false
                        HotdogObject = nil
                    end

                    FreezeEntityPosition(ped, false)
                    SetPedKeepTask(ped, false)
                    SetEntityAsNoLongerNeeded(ped)
                    ClearPedTasksImmediately(ped)
                    table.insert(SellingData.RecentPeds, ped)
                    Config.Stock[SellingData.Hotdog].Current = Config.Stock[SellingData.Hotdog].Current - HotdogsForSale
                    SellingData.Hotdog = nil
                    SellingPrice = 0
                    HotdogsForSale = 0
                    break
                end

                if IsControlJustPressed(0, Keys["8"]) or IsDisabledControlJustPressed(0, Keys["8"]) then
                    RSCore.Functions.Notify('Klant geweigerd!', 'error')
                    SellingData.HasTarget = false

                    FreezeEntityPosition(ped, false)
                    SetPedKeepTask(ped, false)
                    SetEntityAsNoLongerNeeded(ped)
                    ClearPedTasksImmediately(ped)
                    table.insert(SellingData.RecentPeds, ped)
                    SellingData.Hotdog = nil
                    SellingPrice = 0
                    HotdogsForSale = 0
                    break
                end
            else
                SellingData.Hotdog = GetAvailableHotdog()
                RSCore.Functions.DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, 'Je hebt geen voorraad.. / [8] Klant weigeren')

                if IsControlJustPressed(0, Keys["8"]) or IsDisabledControlJustPressed(0, Keys["8"]) then
                    RSCore.Functions.Notify('Klant geweigerd!', 'error')
                    SellingData.HasTarget = false

                    FreezeEntityPosition(ped, false)
                    SetPedKeepTask(ped, false)
                    SetEntityAsNoLongerNeeded(ped)
                    ClearPedTasksImmediately(ped)
                    table.insert(SellingData.RecentPeds, ped)
                    SellingData.Hotdog = nil
                    break
                end
            end
        else
            SellingData.HasTarget = false
            FreezeEntityPosition(ped, false)
            SetPedKeepTask(ped, false)
            SetEntityAsNoLongerNeeded(ped)
            ClearPedTasksImmediately(ped)
            table.insert(SellingData.RecentPeds, ped)
            SellingData = {
                Enabled = false,
                Target = nil,
                HasTarget = false,
                Hotdog = nil,
            }
            RSCore.Functions.Notify('Je bent te-ver van je kraam..', 'error')
            break
        end
        
        Citizen.Wait(3)
    end
end

function StartHotdogMinigame()
    PrepareAnim()
    TriggerEvent('rs-keyminigame:show')
    TriggerEvent('rs-keyminigame:start', FinishMinigame)
end

function PrepareAnim()
    local ped = GetPlayerPed(-1)
    LoadAnim('amb@prop_human_bbq@male@idle_a')
    TaskPlayAnim(ped, 'amb@prop_human_bbq@male@idle_a', 'idle_b', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    SpatelObject = CreateObject(GetHashKey("prop_fish_slice_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(SpatelObject, ped, GetPedBoneIndex(ped, 57005), 0.08, 0.0, -0.02, 0.0, -25.0, 130.0, true, true, false, true, 1, true)
    PreparingAnimCheck()
end

function PreparingAnimCheck()
    PreparingFood = true
    Citizen.CreateThread(function()
        while true do
            local ped = GetPlayerPed(-1)

            if PreparingFood then
                if not IsEntityPlayingAnim(ped, 'amb@prop_human_bbq@male@idle_a', 'idle_b', 3) then
                    LoadAnim('amb@prop_human_bbq@male@idle_a')
                    TaskPlayAnim(ped, 'amb@prop_human_bbq@male@idle_a', 'idle_b', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                end
            else
                DetachEntity(SpatelObject)
                DeleteEntity(SpatelObject)
                ClearPedTasksImmediately(ped)
                break
            end

            Citizen.Wait(200)
        end
    end)
end

function FinishMinigame(faults)
    local Quality = "common"
    if faults == 0 then
        Quality = "exotic"
    elseif faults == 1 then
        Quality = "rare"
    end
    if Config.Stock[Quality].Current + 1 <= Config.Stock[Quality].Max[Config.MyLevel] then
        RSCore.Functions.TriggerCallback('rs-hotdogjob:server:UpdateReputation', function(result)
        end, Quality)
        -- TriggerServerEvent('rs-hotdogjob:server:UpdateReputation', Quality)
        if Config.MyLevel == 1 then
            RSCore.Functions.Notify('Je hebt een '..Config.Stock[Quality].Label..' Hotdog gemaakt!')
            Config.Stock[Quality].Current = Config.Stock[Quality].Current + 1
        else
            local Luck = math.random(1, 2)
            local LuckyNumber = math.random(1, 2)
            local LuckyAmount = math.random(1, Config.MyLevel)
            if Luck == LuckyNumber then
                RSCore.Functions.Notify('Je hebt '..LuckyAmount..' '..Config.Stock[Quality].Label..' Hotdog\'s gemaakt!')
                Config.Stock[Quality].Current = Config.Stock[Quality].Current + LuckyAmount
            else
                RSCore.Functions.Notify('Je hebt een '..Config.Stock[Quality].Label..' Hotdog gemaakt!')
                Config.Stock[Quality].Current = Config.Stock[Quality].Current + 1
            end
        end
    else
        RSCore.Functions.Notify('Je hebt geen ('..Config.Stock[Quality].Label..') voorraad meer over..')
    end
    PreparingFood = false
end

function TakeHotdogStand()
    local PlayerPed = GetPlayerPed(-1)
    IsPushing = true
    NetworkRequestControlOfEntity(StandObject)
    LoadAnim(AnimationData.lib)
    TaskPlayAnim(PlayerPed, AnimationData.lib, AnimationData.anim, 8.0, 8.0, -1, 50, 0, false, false, false)
    SetTimeout(150, function()
        AttachEntityToEntity(StandObject, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), -0.45, -1.2, -0.82, 180.0, 180.0, 270.0, false, false, false, false, 1, true)
    end)
    FreezeEntityPosition(StandObject, false)
    AnimLoop()
end

function LetKraamLose()
    local PlayerPed = GetPlayerPed(-1)
    DetachEntity(StandObject)
    SetEntityCollision(StandObject, true, true)
    ClearPedTasks(PlayerPed)
    IsPushing = false
end

function AnimLoop()
    Citizen.CreateThread(function()
        while true do
            if IsPushing then
                local PlayerPed = GetPlayerPed(-1)
                if not IsEntityPlayingAnim(PlayerPed, AnimationData.lib, AnimationData.anim, 3) then
                    LoadAnim(AnimationData.lib)
                    TaskPlayAnim(PlayerPed, AnimationData.lib, AnimationData.anim, 8.0, 8.0, -1, 50, 0, false, false, false)
                end
            else
                break
            end
            Citizen.Wait(1000)
        end
    end)
end

function StopWorking()
    if DoesEntityExist(StandObject) then
        RSCore.Functions.TriggerCallback('rs-hotdogjob:server:BringBack', function(DidBail)
            if DidBail then
                DeleteObject(StandObject)
                ClearPedTasksImmediately(GetPlayerPed(-1))
                IsWorking = false
                StandObject = nil
                IsPushing = false
                IsSelling = false
                IsUIActive = false
        
                for _, v in pairs(Config.Stock) do
                    v.Current = 0
                end
                RSCore.Functions.Notify('Je hebt je €1000,- borg terug ontvangen!', 'success')
            else
                RSCore.Functions.Notify('Er is iets fout gegaan..', 'error')
            end
        end)
    else
        RSCore.Functions.Notify('Je hotdog kraam was nergens te bekennen, je hebt je borg NIET terug ontvangen!', 'error')
        IsWorking = false
        StandObject = nil
        IsPushing = false
        IsSelling = falsee
        IsUIActive = false

        for _, v in pairs(Config.Stock) do
            v.Current = 0
        end
    end
end

local DetachKeys = {157, 158, 160, 164, 165, 73, 36, 44}
function CheckLoop()
    Citizen.CreateThread(function()
        while true do
            if IsWorking then
                if IsPushing then
                    for _, PressedKey in pairs(DetachKeys) do
                        if IsControlJustPressed(0, PressedKey) or IsDisabledControlJustPressed(0, PressedKey) then
                            LetKraamLose()
                        end
                    end

                    if IsPedShooting(GetPlayerPed(-1)) or IsPlayerFreeAiming(PlayerId()) or IsPedInMeleeCombat(GetPlayerPed(-1)) then
                        LetKraamLose()
                    end

                    if IsPedDeadOrDying(GetPlayerPed(-1), false) then
                        LetKraamLose()
                    end

                    if IsPedRagdoll(GetPlayerPed(-1)) then
                        LetKraamLose()
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                break
            end
            Citizen.Wait(5)
        end
    end)
end

RegisterNetEvent('rs-hotdogjob:staff:DeletStand')
AddEventHandler('rs-hotdogjob:staff:DeletStand', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local Object = GetClosestObjectOfType(pos.x, pos.y, pos.z, 10.0, GetHashKey('prop_hotdogstand_01'), true, false, false)
    
    if Object ~= nil then
        local ObjectCoords = GetEntityCoords(Object)
        local ObjectDistance = GetDistanceBetweenCoords(pos, ObjectCoords.x, ObjectCoords.y, ObjectCoords.z, true)

        if ObjectDistance <= 5 then
            NetworkRegisterEntityAsNetworked(Object)
            Citizen.Wait(100)           
            NetworkRequestControlOfEntity(Object)            
            if not IsEntityAMissionEntity(Object) then
                SetEntityAsMissionEntity(Object)        
            end
            Citizen.Wait(100)            
            DeleteEntity(Object)
            RSCore.Functions.Notify('Hotdogstand verwijderd!')
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if StandObject ~= nil then
            DeleteObject(StandObject)
            ClearPedTasksImmediately(GetPlayerPed(-1))
        end
    end
end)

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end
end