RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local SafeCodes = {}

Citizen.CreateThread(function()
    while true do 
        SafeCodes = {
            [1] = math.random(1000, 9999),
            [2] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [3] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [4] = math.random(1000, 9999),
            [5] = math.random(1000, 9999),
            [6] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [7] = math.random(1000, 9999),
            [8] = math.random(1000, 9999),
            [9] = math.random(1000, 9999),
            [10] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [11] = math.random(1000, 9999),
            [12] = math.random(1000, 9999),
            [13] = math.random(1000, 9999),
            [14] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [15] = math.random(1000, 9999),
            [16] = math.random(1000, 9999),
            [17] = math.random(1000, 9999),
            [18] = {math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149), math.random(150.0, 359.0), math.random(1, 149)},
            [19] = math.random(1000, 9999),
        }
        Citizen.Wait((1000 * 60) * 40)
    end
end)

RegisterServerEvent('rs-storerobbery:server:takeMoney')
AddEventHandler('rs-storerobbery:server:takeMoney', function(register, isDone)
    RSCore.Functions.BanInjection(source)
end)

RSCore.Functions.CreateCallback('rs-storerobbery:takeMoney', function(source, cb, register, isDone)
    local src   = source
    local Player = RSCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', math.random(25, 50), "robbery-store")
    if isDone then
        if math.random(1, 100) <= 17 then
            local code = SafeCodes[Config.Registers[register].safeKey]
            local info = {}
            if Config.Safes[Config.Registers[register].safeKey].type == "keypad" then
                info = {
                    label = "Kluis code: "..tostring(code)
                }
            else
                info = {
                    label = "Kluis code: "..tostring(math.floor((code[1] % 360) / 3.60)).."-"..tostring(math.floor((code[2] % 360) / 3.60)).."-"..tostring(math.floor((code[3] % 360) / 3.60)).."-"..tostring(math.floor((code[4] % 360) / 3.60)).."-"..tostring(math.floor((code[5] % 360) / 3.60))
                }
            end
            Player.Functions.AddItem("stickynote", 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["stickynote"], "add")
        end
    end
end)


RegisterServerEvent('rs-storerobbery:server:setRegisterStatus')
AddEventHandler('rs-storerobbery:server:setRegisterStatus', function(register)
    TriggerClientEvent('rs-storerobbery:client:setRegisterStatus', -1, register, true)
    Config.Registers[register].robbed   = true
    Config.Registers[register].time     = Config.resetTime
end)

RegisterServerEvent('rs-storerobbery:server:setSafeStatus')
AddEventHandler('rs-storerobbery:server:setSafeStatus', function(safe)
    TriggerClientEvent('rs-storerobbery:client:setSafeStatus', -1, safe, true)
    Config.Safes[safe].robbed = true
end)

RegisterServerEvent('rs-storerobbery:server:SafeReward')
AddEventHandler('rs-storerobbery:server:SafeReward', function()
    RSCore.Functions.BanInjection(source)
end)

RSCore.Functions.CreateCallback('rs-storerobbery:SafeReward', function(source, cb, amount)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', math.random(1500, 5000), "robbery-safe-reward")
    local luck = math.random(1, 100)
    if luck <= 10 then
        Player.Functions.AddItem("rolex", math.random(5, 10))
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["rolex"], "add")
        if luck == 1 then
            Citizen.Wait(500)
            Player.Functions.AddItem("goldbar", math.random(1, 2))
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["goldbar"], "add")
        end
    end
end)

RegisterServerEvent('rs-storerobbery:server:callCops')
AddEventHandler('rs-storerobbery:server:callCops', function(type, safe, streetLabel, coords)
    local cameraId = 4
    if type == "safe" then
        cameraId = Config.Safes[safe].camId
    else
        cameraId = Config.Registers[safe].camId
    end
    local alertData = {
        title = "Winkeloverval",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Iemand probeert een winkel te overvallen bij "..streetLabel.." (CAMERA ID: "..cameraId..")"
    }
    TriggerClientEvent("rs-storerobbery:client:robberyCall", -1, type, safe, streetLabel, coords)
    TriggerClientEvent("rs-phone:client:addPoliceAlert", -1, alertData)
end)

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(Config.Registers) do
            if Config.Registers[k].time > 0 and (Config.Registers[k].time - Config.tickInterval) >= 0 then
                Config.Registers[k].time = Config.Registers[k].time - Config.tickInterval
            else
                Config.Registers[k].time = 0
                Config.Registers[k].robbed = false
                TriggerClientEvent('rs-storerobbery:client:setRegisterStatus', -1, k, false)
            end
        end
        Citizen.Wait(Config.tickInterval)
    end
end)

RSCore.Functions.CreateCallback('rs-storerobbery:server:isCombinationRight', function(source, cb, safe)
    cb(SafeCodes[safe])
end)

RSCore.Functions.CreateCallback('rs-storerobbery:server:getPadlockCombination', function(source, cb, safe)
    cb(SafeCodes[safe])
end)

RSCore.Functions.CreateCallback('rs-storerobbery:server:getRegisterStatus', function(source, cb)
    cb(Config.Registers)
end)

RSCore.Functions.CreateCallback('rs-storerobbery:server:getSafeStatus', function(source, cb)
    cb(Config.Safes)
end)