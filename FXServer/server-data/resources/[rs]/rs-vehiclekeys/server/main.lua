RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local VehicleList = {}

RSCore.Functions.CreateCallback('vehiclekeys:CheckHasKey', function(source, cb, plate)
    local Player = RSCore.Functions.GetPlayer(source)
    cb(CheckOwner(plate, Player.PlayerData.citizenid))
end)

RegisterServerEvent('vehiclekeys:server:SetVehicleOwner')
AddEventHandler('vehiclekeys:server:SetVehicleOwner', function()
    RSCore.Functions.BanInjection(source)
end)

RSCore.Functions.CreateCallback('vehiclekeys:SetVehicleOwner', function(source, cb, plate)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if VehicleList ~= nil then
        if DoesPlateExist(plate) then
            for k, val in pairs(VehicleList) do
                if val.plate == plate then
                    table.insert(VehicleList[k].owners, Player.PlayerData.citizenid)
                end
            end
        else
            local vehicleId = #VehicleList+1
            VehicleList[vehicleId] = {
                plate = plate, 
                owners = {},
            }
            VehicleList[vehicleId].owners[1] = Player.PlayerData.citizenid
        end
    else
        local vehicleId = #VehicleList+1
        VehicleList[vehicleId] = {
            plate = plate, 
            owners = {},
        }
        VehicleList[vehicleId].owners[1] = Player.PlayerData.citizenid
    end
end)


RegisterServerEvent('vehiclekeys:server:GiveVehicleKeys')
AddEventHandler('vehiclekeys:server:GiveVehicleKeys', function(plate, target)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if CheckOwner(plate, Player.PlayerData.citizenid) then
        if RSCore.Functions.GetPlayer(target) ~= nil then
            TriggerClientEvent('vehiclekeys:client:SetOwner', target, plate)
            TriggerClientEvent('RSCore:Notify', src, "Je hebt je sleutels gegeven!")
            TriggerClientEvent('RSCore:Notify', target, "Je hebt je sleutels ontvangen!")
        else
            TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Speler is niet online!")
        end
    else
        TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Je hebt geen sleutels van dit voertuig!")
    end
end)

RSCore.Commands.Add("motor", "Toggle motor aan/uit van het voertuig", {}, false, function(source, args)
	TriggerClientEvent('vehiclekeys:client:ToggleEngine', source)
end)

RSCore.Commands.Add("geefsleutels", "Geef sleutels van een voertuig", {{name = "id", help = "Speler id"}}, true, function(source, args)
	local src = source
    local target = tonumber(args[1])
    TriggerClientEvent('vehiclekeys:client:GiveKeys', src, target)
end)

function DoesPlateExist(plate)
    if VehicleList ~= nil then
        for k, val in pairs(VehicleList) do
            if val.plate == plate then
                return true
            end
        end
    end
    return false
end

function CheckOwner(plate, identifier)
    local retval = false
    if VehicleList ~= nil then
        for k, val in pairs(VehicleList) do
            if val.plate == plate then
                for key, owner in pairs(VehicleList[k].owners) do
                    if owner == identifier then
                        retval = true
                    end
                end
            end
        end
    end
    return retval
end

RSCore.Functions.CreateUseableItem("lockpick", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, false)
end)

RSCore.Functions.CreateUseableItem("advancedlockpick", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, true)
end)