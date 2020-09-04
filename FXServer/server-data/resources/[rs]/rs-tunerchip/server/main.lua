RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

local tunedVehicles = {}
local VehicleNitrous = {}

RSCore.Functions.CreateUseableItem("tunerlaptop", function(source, item)
    local src = source

    TriggerClientEvent('rs-tunerchip:client:openChip', src)
end)

RSCore.Functions.CreateCallback('rs-tunerchip:server:TuneStatus', function(source, cb, plate, bool)
    if bool then
        tunedVehicles[plate] = bool
    else
        tunedVehicles[plate] = nil
    end
end)

RegisterServerEvent('rs-tunerchip:server:TuneStatus')
AddEventHandler('rs-tunerchip:server:TuneStatus', function(plate, bool)
    if bool then
        tunedVehicles[plate] = bool
    else
        tunedVehicles[plate] = nil
    end
end)

RSCore.Functions.CreateCallback('rs-tunerchip:server:HasChip', function(source, cb)
    local src = source
    local Ply = RSCore.Functions.GetPlayer(src)
    local Chip = Ply.Functions.GetItemByName('tunerlaptop')

    if Chip ~= nil then
        cb(true)
    else
        DropPlayer(src, 'Dit is niet de bedoeling he...')
        cb(true)
    end
end)

RSCore.Functions.CreateCallback('rs-tunerchip:server:GetStatus', function(source, cb, plate)
    cb(tunedVehicles[plate])
end)

RSCore.Functions.CreateUseableItem("nitrous", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)

    TriggerClientEvent('smallresource:client:LoadNitrous', source)
end)


RSCore.Functions.CreateCallback('nitrous:server:LoadNitrous', function(source, cb, plate)
    VehicleNitrous[Plate] = {
        hasnitro = true,
        level = 100,
    }
    TriggerClientEvent('nitrous:client:LoadNitrous', -1, Plate)
end)

RSCore.Functions.CreateCallback('nitrous:server:SyncFlames', function(source, cb, netId)
    TriggerClientEvent('nitrous:client:SyncFlames', -1, netId, source)
end)

RSCore.Functions.CreateCallback('nitrous:server:UnloadNitrous', function(source, cb, plate)
    VehicleNitrous[Plate] = nil
    TriggerClientEvent('nitrous:client:UnloadNitrous', -1, Plate)
end)

RSCore.Functions.CreateCallback('nitrous:server:UpdateNitroLevel', function(source, cb, plate, level)
    VehicleNitrous[Plate].level = level
    TriggerClientEvent('nitrous:client:UpdateNitroLevel', -1, Plate, level)
end)

RSCore.Functions.CreateCallback('nitrous:server:StopSync', function(source, cb, plate)
    TriggerClientEvent('nitrous:client:StopSync', -1, plate)
end)




RegisterServerEvent('nitrous:server:LoadNitrous')
AddEventHandler('nitrous:server:LoadNitrous', function(Plate)
	RSCore.Functions.BanInjection(source, 'rs-tunerchip (LoadNitrous)')
end)

RegisterServerEvent('nitrous:server:SyncFlames')
AddEventHandler('nitrous:server:SyncFlames', function(netId)
    RSCore.Functions.BanInjection(source, 'rs-tunerchip (SyncFlames)')
end)

RegisterServerEvent('nitrous:server:UnloadNitrous')
AddEventHandler('nitrous:server:UnloadNitrous', function(Plate)
    RSCore.Functions.BanInjection(source, 'rs-tunerchip (UnloadNitrous)')
end)
RegisterServerEvent('nitrous:server:UpdateNitroLevel')
AddEventHandler('nitrous:server:UpdateNitroLevel', function(Plate, level)
    RSCore.Functions.BanInjection(source, 'rs-tunerchip (UpdateNitroLevel)')
end)

RegisterServerEvent('nitrous:server:StopSync')
AddEventHandler('nitrous:server:StopSync', function(plate)
    RSCore.Functions.BanInjection(source, 'rs-tunerchip (StopSync)')
end)