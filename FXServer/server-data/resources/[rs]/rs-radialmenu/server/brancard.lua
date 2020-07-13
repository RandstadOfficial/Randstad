RegisterServerEvent('rs-radialmenu:server:RemoveBrancard')
AddEventHandler('rs-radialmenu:server:RemoveBrancard', function(PlayerPos, BrancardObject)
    TriggerClientEvent('rs-radialmenu:client:RemoveBrancardFromArea', -1, PlayerPos, BrancardObject)
end)

RegisterServerEvent('rs-radialmenu:Brancard:BusyCheck')
AddEventHandler('rs-radialmenu:Brancard:BusyCheck', function(id, type)
    local MyId = source
    TriggerClientEvent('rs-radialmenu:Brancard:client:BusyCheck', id, MyId, type)
end)

RegisterServerEvent('rs-radialmenu:server:BusyResult')
AddEventHandler('rs-radialmenu:server:BusyResult', function(IsBusy, OtherId, type)
    TriggerClientEvent('rs-radialmenu:client:Result', OtherId, IsBusy, type)
end)