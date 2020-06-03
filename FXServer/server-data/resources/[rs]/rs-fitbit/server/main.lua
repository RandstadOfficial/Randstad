RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RSCore.Functions.CreateUseableItem("fitbit", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent('rs-fitbit:use', source)
  end)

RegisterServerEvent('rs-fitbit:server:setValue')
AddEventHandler('rs-fitbit:server:setValue', function(type, value)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)
    local fitbitData = {}

    if type == "thirst" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = value,
            food = currentMeta.food
        }
    elseif type == "food" then
        local currentMeta = ply.PlayerData.metadata["fitbit"]
        fitbitData = {
            thirst = currentMeta.thirst,
            food = value
        }
    end

    ply.Functions.SetMetaData('fitbit', fitbitData)
end)

RSCore.Functions.CreateCallback('rs-fitbit:server:HasFitbit', function(source, cb)
    local Ply = RSCore.Functions.GetPlayer(source)
    local Fitbit = Ply.Functions.GetItemByName("fitbit")

    if Fitbit ~= nil then
        cb(true)
    else
        cb(false)
    end
end)