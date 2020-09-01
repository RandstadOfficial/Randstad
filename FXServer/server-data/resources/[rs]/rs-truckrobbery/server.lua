RSCore = nil
local moneytruck = false
local CurrentCops = 0


RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RegisterNetEvent('RS7x:Itemcheck')
AddEventHandler('RS7x:Itemcheck', function(amount)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local isRobbing = true

    --local item = Player.getInventoryItem(Config.Item)
    if not moneytruck then
        if isRobbing then
            moneytruck = true
            TriggerClientEvent('RS7x:startHacking',source,true)
            TriggerClientEvent('animation:hack', source)
        else
            isRobbing = false
            TriggerClientEvent('RSCore:Notify', src, "Je hebt geen items..", "error")
        end
    else
    TriggerClientEvent('RSCore:Notify', src, "Iemand is al bezig met overval", "error")
end    
end)


RSCore.Functions.CreateUseableItem("security_card_03", function(source, item)
	TriggerClientEvent('rs-truckrobbery:rob', source)
end)

RegisterNetEvent('RS7x:NotifyPolice')
AddEventHandler('RS7x:NotifyPolice', function(street1, street2, pos)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local isRobbing = true

    if isRobbing == true then
		for i=1, #Player, 1 do
			local Player = ESX.GetPlayerFromId(Player[i])
            if Player.job.name == 'police' then
                TriggerClientEvent('RS7x:Blip', Player[i], pos.x, pos.y, pos.z)
                TriggerClientEvent('RS7x:NotifyPolice', Player[i], 'Robbery In Progress : Security Truck | ' .. street1 .. " | " .. street2 .. ' ')
			end
		end
	end
end)

RobbedPlates = {}

RegisterNetEvent('RS7x:UpdatePlates')
AddEventHandler('RS7x:UpdatePlates', function(UpdatedTable, Plate)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    RobbedPlates = UpdatedTable
    for i=1, #Player, 1 do
        local Player = ESX.GetPlayerFromId(Player[i])
        if Player ~= nil then
            UpdatedTable[Plate] = true
            TriggerClientEvent('RS7x:newTable', Player[i], UpdatedTable)
        end
    end
    print('Updated Plates To server')
end)

function RandomItem()
	return Config.Items[math.random(#Config.Items)]
end

function RandomNumber()
	return math.random(1,10)
end

RegisterNetEvent('RS7x:Payout')
AddEventHandler('RS7x:Payout', function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local Robbing = false
    local timer = 0

    Robbing = true

    while Robbing == true do
        timer = timer + 3.5
        Citizen.Wait(3500)  --// Delay between receiving Items/Cash might need to play around with this if you decide to change the default timer (Config.Timer)
        if math.random(1,100) <= 50 then
            Player.addMoney(math.random(300,2500))
        else
            Player.addInventoryItem(RandomItem(), RandomNumber())
        end
        if timer >= Config.Timer then
            Robbing = false
            break
            TriggerClientEvent('np-truckrobbery:unfreeze', source)
        end
    end
end)

RegisterNetEvent('RS7x:moneytruck_false')
AddEventHandler('RS7x:moneytruck_false', function()
    if moneytruck then
        moneytruck = false
    end
end)