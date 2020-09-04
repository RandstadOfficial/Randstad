RSCore = nil

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

local ClosestSafe = nil
local IsAuthorized = false

local PlayerData = {}

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

function SetClosestSafe()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    for id, house in pairs(Config.Safes) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, Config.Safes[id].coords.x, Config.Safes[id].coords.y, Config.Safes[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, Config.Safes[id].coords.x, Config.Safes[id].coords.y, Config.Safes[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, Config.Safes[id].coords.x, Config.Safes[id].coords.y, Config.Safes[id].coords.z, true)
            current = id
        end
    end
    ClosestSafe = current
    if ClosestSafe ~= nil then
        if current == "police" then
            IsAuthorized = exports['police']:IsArmoryWhitelist()
        end
    end
end

RegisterNetEvent("RSCore:Client:OnPlayerLoaded")
AddEventHandler("RSCore:Client:OnPlayerLoaded", function()
    Citizen.CreateThread(function()
        PlayerData = RSCore.Functions.GetPlayerData()
        while true do
            SetClosestSafe()
            Citizen.Wait(2500)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        local inRange = false
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        if ClosestSafe ~= nil then
            if PlayerData.job.name == ClosestSafe then
                if IsAuthorized then
                    local data = Config.Safes[ClosestSafe]
                    local distance = GetDistanceBetweenCoords(pos, data.coords.x, data.coords.y, data.coords.z)
                    if distance < 20 then
                        inRange = true
                        if distance < Config.MinimumSafeDistance then
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '~g~€'..data.money)
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z - 0.1, '~b~/deposit~w~ - Stop geld in de kluis')
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z - 0.2, '~b~/withdraw~w~ - Haal geld uit de kluis')
                        end
                    end
                else
                    Citizen.Wait(1750)
                end
            else
                Citizen.Wait(1750)
            end
        else
            Citizen.Wait(1750)
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('rs-moneysafe:client:DepositMoney')
AddEventHandler('rs-moneysafe:client:DepositMoney', function(amount)
    if ClosestSafe ~= nil then
        if IsAuthorized then
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local data = Config.Safes[ClosestSafe]
            local distance = GetDistanceBetweenCoords(pos, data.coords.x, data.coords.y, data.coords.z)

            if distance < Config.MinimumSafeDistance then
                RSCore.Functions.TriggerCallback('rs-moneysafe:server:DepositMoney', function(result)
                end, ClosestSafe, amount)
            end
        end
    end
end)

RegisterNetEvent('rs-moneysafe:client:WithdrawMoney')
AddEventHandler('rs-moneysafe:client:WithdrawMoney', function(amount)
    if ClosestSafe ~= nil then
        if IsAuthorized then
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local data = Config.Safes[ClosestSafe]
            local distance = GetDistanceBetweenCoords(pos, data.coords.x, data.coords.y, data.coords.z)

            if distance < Config.MinimumSafeDistance then
                RSCore.Functions.TriggerCallback('rs-moneysafe:server:WithdrawMoney', function(result)
                end, ClosestSafe, amount)
            end
        end
    end
end)

RegisterNetEvent('rs-moneysafe:client:executeEvents')
AddEventHandler('RSCore:Client:OnJobUpdate', function(JobInfo)
    TriggerServerEvent('rs-moneysafe:server:WithdrawMoney', ClosestSafe, amount)
    TriggerServerEvent('rs-moneysafe:server:DepositMoney', ClosestSafe, amount)
end)


RegisterNetEvent('RSCore:Client:OnJobUpdate')
AddEventHandler('RSCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('rs-moneysafe:client:UpdateSafe')
AddEventHandler('rs-moneysafe:client:UpdateSafe', function(SafeData, k)
    Config.Safes[k].money = SafeData.money
    Config.Safes[k].transactions = SafeData.transactions
end) 