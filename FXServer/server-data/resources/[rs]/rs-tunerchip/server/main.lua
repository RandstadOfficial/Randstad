RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

local tunedVehicles = {}

RSCore.Functions.CreateUseableItem("tunerlaptop", function(source, item)
    local src = source

    TriggerClientEvent('rs-tunerchip:client:openChip', src)
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

RSCore.Commands.Add("stamina100", "", {{name="id", help="ID van de speler"}}, true, function(source, args)
	TriggerClientEvent('infiniteStamina', source)	
end, "god")


RSCore.Commands.Add("instapick", "", {{name="id", help="ID van de speler"}}, true, function(source, args)
	TriggerClientEvent('lockpick:instapick', source)	
end, "god")