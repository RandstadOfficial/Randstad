RSCore = nil
Skillbar = {}
Skillbar.Data = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if RSCore == nil then
            TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

Skillbar.Data = {
    Active = false,
    Data = {},
}
successCb = nil
failCb = nil

-- NUI Callback's

RegisterNUICallback('Check', function(data, cb)
    if successCb ~= nil then
        Skillbar.Data.Active = false
        TriggerEvent('progressbar:client:ToggleBusyness', false)
        if data.success then
            successCb()
        else
            failCb()
            SendNUIMessage({
                action = "stop"
            })
        end
    end
end)

Skillbar.Start = function(data, success, fail)
    if not Skillbar.Data.Active then
       
        Skillbar.Data.Active = true
        if success ~= nil then
            successCb = success
        end
        if fail ~= nil then
            failCb = fail
        end
        Skillbar.Data.Data = data

        SendNUIMessage({
            action = "start",
            duration = data.duration,
            pos = data.pos,
            width = data.width,
        })
        TriggerEvent('progressbar:client:ToggleBusyness', true)
    else
        RSCore.Functions.Notify('Je bent al met iets bezig..', 'error')
    end
end

Skillbar.Repeat = function(data)
    Skillbar.Data.Active = true
    Skillbar.Data.Data = data
    Citizen.CreateThread(function()
        Wait(500)
        SendNUIMessage({
            action = "start",
            duration = Skillbar.Data.Data.duration,
            pos = Skillbar.Data.Data.pos,
            width = Skillbar.Data.Data.width,
        }) 
    end)
end

Citizen.CreateThread(function()
    while true do
        if Skillbar.Data.Active then
            playerPed = GetPlayerPed(-1)
            if IsControlJustPressed(0, Keys["E"]) then
                SendNUIMessage({
                    action = "check",
                    data = Skillbar.Data.Data,
                })
            elseif IsControlJustPressed(0, 75) then
                SendNUIMessage({
                    action = "stop"
                })
            end

            if IsPedInAnyVehicle(playerPed, false) == nil then
                SendNUIMessage({
                    action = "stop"
                })
            end

            
        end
        Citizen.Wait(1)
    end
end)

function GetSkillbarObject()
    return Skillbar
end