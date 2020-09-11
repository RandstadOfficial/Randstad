RSCore = nil

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Functions.CreateCallback('rs-dumpsearch:getItem', function(source, cb)
	local src = source
    local ply = RSCore.Functions.GetPlayer(src)
    local luck = math.random(1, 3)
print(luck)
    if luck == 2 then
        local luck2 = math.random(1, 4)
        local luck3 = math.random(1, 1000)
        local luck4 = math.random(1, 10000)
        
        local src = source
        local Player = RSCore.Functions.GetPlayer(src)
        local Amount = math.random(2,6)
        local ItemData = RSCore.Shared.Items["plastic"]

        if luck4 == 100 then	   
            ply.Functions.AddItem('weapon_snspistol', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['weapon_snspistol'], "add")  
        elseif luck3 == 1 then   
            ply.Functions.AddItem('weapon_stungun', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items['weapon_stungun'], "add")
            Player.Functions.AddItem(RSCore.Shared.Items["plastic"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["plastic"], "add")
            Player.Functions.AddItem(RSCore.Shared.Items["steel"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["steel"], "add")         
        elseif luck2 == 1 then
            Player.Functions.AddItem(RSCore.Shared.Items["plastic"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["plastic"], "add")
            Player.Functions.AddItem(RSCore.Shared.Items["steel"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["steel"], "add")
        else
            Player.Functions.AddItem(RSCore.Shared.Items["plastic"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["plastic"], "add")
        end		
        TriggerClientEvent('RSCore:Notify', src, 'Sterk, je hebt iets gevonden zwimpie', 'success', 2000)
    else
        TriggerClientEvent('RSCore:Notify', src, 'Je hebt niks gevonden zwimpie', 'error', 2000)
    end
end)

RegisterServerEvent('rs-dumpsearch:getItem')
AddEventHandler('rs-dumpsearch:getItem', function()
    RSCore.Functions.BanInjection(source, 'rs-dumpsearch (getItem)')
end)