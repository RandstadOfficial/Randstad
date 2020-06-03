RegisterServerEvent('json:dataStructure')
AddEventHandler('json:dataStructure', function(data)
    print(json.encode(data))
end)

RegisterServerEvent('rs-radialmenu:trunk:server:Door')
AddEventHandler('rs-radialmenu:trunk:server:Door', function(open, plate, door)
    TriggerClientEvent('rs-radialmenu:trunk:client:Door', -1, plate, door, open)
end)