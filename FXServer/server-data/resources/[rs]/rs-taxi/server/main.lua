RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code


RSCore.Functions.CreateCallback('rs-taxi:server:NpcPay', function(source, cb, Payment)
	local fooi = math.random(1, 5)
    local r1, r2 = math.random(1, 5), math.random(1, 5)

    if fooi == r1 or fooi == r2 then
        Payment = Payment + math.random(5, 10)
    end

    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', Payment)
end)

RegisterServerEvent('rs-taxi:server:NpcPay')
AddEventHandler('rs-taxi:server:NpcPay', function(Payment)
    RSCore.Functions.BanInjection(source)
end)