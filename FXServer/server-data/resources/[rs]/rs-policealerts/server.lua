RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RegisterNetEvent('rs-policealerts:server:AddPoliceAlert')
AddEventHandler('rs-policealerts:server:AddPoliceAlert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('rs-policealerts:client:AddPoliceAlert', -1, data, forBoth)
end)