RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code
Citizen.CreateThread(function()
	RSCore.Functions.ExecuteSql(false, "SELECT * FROM `traphouses`", function(result)
		if result[1] ~= nil then
            for k, v in pairs(result) do
                local openeds = false
				if tonumber(v.opened) == 1 then
					openeds = true
                end
                local takingovers = false
                if tonumber(v.takingover) == 1 then
					takingovers = true
                end
				Config.TrapHouses[v.id] = {
					coords = json.decode(v.coords),
					keyholders = json.decode(v.keyholders),
					pincode = v.pincode,
					inventory = json.decode(v.inventory),
					opened = openeds,
					takingover = takingovers,
					money = v.money,
				}
            end
		end
	end)
end)

RegisterServerEvent('rs-traphouses:server:TakeoverHouse')
AddEventHandler('rs-traphouses:server:TakeoverHouse', function(Traphouse)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    if not HasCitizenIdHasKey(CitizenId, Traphouse) then
        if Player.Functions.RemoveMoney('cash', Config.TakeoverPrice) then
            TriggerClientEvent('rs-traphouses:client:TakeoverHouse', src, Traphouse)
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet genoeg contant geld..', 'error')
        end
    end
end)

RegisterServerEvent('rs-traphouses:server:AddHouseKeyHolder')
AddEventHandler('rs-traphouses:server:AddHouseKeyHolder', function(CitizenId, TraphouseId, IsOwner)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    if Config.TrapHouses[TraphouseId] ~= nil then
        if IsOwner then
            Config.TrapHouses[TraphouseId].keyholders = {}
            Config.TrapHouses[TraphouseId].pincode = math.random(11111, 55555) 
        end

        if Config.TrapHouses[TraphouseId].keyholders == nil then
            table.insert(Config.TrapHouses[TraphouseId].keyholders, {
                citizenid = CitizenId,
                owner = IsOwner,
            })
            SaveTrapHouseConfig(TraphouseId)
            TriggerClientEvent('rs-traphouses:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
        else
            if #Config.TrapHouses[TraphouseId].keyholders + 1 <= 6 then
                if not HasCitizenIdHasKey(CitizenId, TraphouseId) then
                    table.insert(Config.TrapHouses[TraphouseId].keyholders, {
                        citizenid = CitizenId,
                        owner = IsOwner,
                    })
                    SaveTrapHouseConfig(TraphouseId)
                    TriggerClientEvent('rs-traphouses:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
                end
            else
                TriggerClientEvent('RSCore:Notify', src, 'Er zijn geen slots meer over..')
            end
        end
    else
        TriggerClientEvent('RSCore:Notify', src, 'Foutje opgetreden..')
    end
end)

function SaveTrapHouseConfig(TraphouseId)
    local openeds = 0
    if openeds == true then
        openeds = 1
    end
    local takingovers = 0
    if takingovers == true then
        takingovers = 1
    end
    RSCore.Functions.ExecuteSql(true, "UPDATE `traphouses` SET coords='"..json.encode(Config.TrapHouses[TraphouseId].coords).."',keyholders='"..json.encode(Config.TrapHouses[TraphouseId].keyholders).."',pincode='"..Config.TrapHouses[TraphouseId].pincode.."',inventory='"..json.encode(Config.TrapHouses[TraphouseId].inventory).."',opened='"..openeds.."',takingover='"..takingovers.."',money='"..Config.TrapHouses[TraphouseId].money.."' WHERE `id` = '"..TraphouseId.."'")
end

function HasCitizenIdHasKey(CitizenId, Traphouse)
    local retval = false
    if Config.TrapHouses[Traphouse].keyholders ~= nil and next(Config.TrapHouses[Traphouse].keyholders) ~= nil then
        for _, data in pairs(Config.TrapHouses[Traphouse].keyholders) do
            if data.citizenid == CitizenId then
                retval = true
                break
            end
        end
    end
    return retval
end

function AddKeyHolder(CitizenId, Traphouse, IsOwner)
    if IsOwner then
        Config.TrapHouses[Traphouse].keyholders = {}
    end
    if #Config.TrapHouses[Traphouse].keyholders <= 6 then
        if not HasCitizenIdHasKey(CitizenId, Traphouse) then
            table.insert(Config.TrapHouses[Traphouse].keyholders, {
                citizenid = CitizenId,
                owner = IsOwner,
            })
        end
    end
end

function HasTraphouseAndOwner(CitizenId)
    local retval = nil
    for Traphouse,_ in pairs(Config.TrapHouses) do
        for k, v in pairs(Config.TrapHouses[Traphouse].keyholders) do
            if v.citizenid == CitizenId then
                if v.owner then
                    retval = Traphouse
                end
            end
        end
    end
    return retval
end

RSCore.Commands.Add("entertraphouse", "Betreed traphouse", {}, false, function(source, args)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)

    TriggerClientEvent('rs-traphouses:client:EnterTraphouse', src)
end)

RSCore.Commands.Add("geeftrapsleutels", "Geef sleutels van het traphouse", {{name = "id", help = "Speler id"}}, true, function(source, args)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local TargetId = tonumber(args[1])
    local TargetData = RSCore.Functions.GetPlayer(TargetId)
    local IsOwner = false
    local Traphouse = HasTraphouseAndOwner(Player.PlayerData.citizenid)

    if TargetData ~= nil then
        if Traphouse ~= nil then
            if not HasCitizenIdHasKey(TargetData.PlayerData.citizenid, Traphouse) then
                if Config.TrapHouses[Traphouse] ~= nil then
                    if IsOwner then
                        Config.TrapHouses[Traphouse].keyholders = {}
                        Config.TrapHouses[Traphouse].pincode = math.random(1111, 4444) 
                    end
            
                    if Config.TrapHouses[Traphouse].keyholders == nil then
                        table.insert(Config.TrapHouses[Traphouse].keyholders, {
                            citizenid = TargetData.PlayerData.citizenid,
                            owner = IsOwner,
                        })
                        SaveTrapHouseConfig(Traphouse)
                        TriggerClientEvent('rs-traphouses:client:SyncData', -1, Traphouse, Config.TrapHouses[Traphouse])
                    else
                        if #Config.TrapHouses[Traphouse].keyholders + 1 <= 6 then
                            if not HasCitizenIdHasKey(TargetData.PlayerData.citizenid, Traphouse) then
                                table.insert(Config.TrapHouses[Traphouse].keyholders, {
                                    citizenid = TargetData.PlayerData.citizenid,
                                    owner = IsOwner,
                                })
                                SaveTrapHouseConfig(Traphouse)
                                TriggerClientEvent('rs-traphouses:client:SyncData', -1, Traphouse, Config.TrapHouses[Traphouse])
                                TriggerClientEvent('RSCore:Notify', TargetData.PlayerData.source, 'Je hebt de sleutel gekregen')
                            end
                        else
                            TriggerClientEvent('RSCore:Notify', src, 'Er zijn geen slots meer over..')
                        end
                    end
                else
                    TriggerClientEvent('RSCore:Notify', src, 'Foutje opgetreden..')
                end
            else
                TriggerClientEvent('RSCore:Notify', src, 'Deze persoon heeft al de sleutels..', 'error')
            end
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je bent niet in bezit van een Traphouse of bent niet de eigenaar..', 'error')
        end
    else
        TriggerClientEvent('RSCore:Notify', src, 'Deze persoon is niet in de stad..', 'error')
    end
end)

RegisterServerEvent('rs-traphouses:server:TakeMoney')
AddEventHandler('rs-traphouses:server:TakeMoney', function(TraphouseId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if Config.TrapHouses[TraphouseId].money ~= 0 then
        Player.Functions.AddMoney('cash', Config.TrapHouses[TraphouseId].money)
        Config.TrapHouses[TraphouseId].money = 0
        SaveTrapHouseConfig(TraphouseId)
        TriggerClientEvent('rs-traphouses:client:SyncData', -1, TraphouseId, Config.TrapHouses[TraphouseId])
    else
        TriggerClientEvent('RSCore:Notify', src, 'Er zit geen geld in de kas', 'error')
    end
end)

function SellTimeout(traphouseId, slot, itemName, amount, info)
    Citizen.CreateThread(function()
        if itemName == "markedbills" then
            SetTimeout(math.random(1000, 5000), function()
                if Config.TrapHouses[traphouseId].inventory[slot] ~= nil then
                    RemoveHouseItem(traphouseId, slot, itemName, 1)
                    Config.TrapHouses[traphouseId].money = Config.TrapHouses[traphouseId].money + math.ceil(info.worth / 100 * 80)
                    SaveTrapHouseConfig(traphouseId)
                    TriggerClientEvent('rs-traphouses:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
                end
            end)
        else
            for i = 1, amount, 1 do
                local SellData = Config.AllowedItems[itemName]
                SetTimeout(SellData.wait, function()
                    if Config.TrapHouses[traphouseId].inventory[slot] ~= nil then
                        RemoveHouseItem(traphouseId, slot, itemName, 1)
                        Config.TrapHouses[traphouseId].money = Config.TrapHouses[traphouseId].money + SellData.reward
                        SaveTrapHouseConfig(traphouseId)
                        TriggerClientEvent('rs-traphouses:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
                    end
                end)
                if amount > 1 then
                    Citizen.Wait(SellData.wait)
                end
            end
        end
    end)
end

function AddHouseItem(traphouseId, slot, itemName, amount, info, source)
    local amount = tonumber(amount)
    traphouseId = tonumber(traphouseId)
    if Config.TrapHouses[traphouseId].inventory[slot] ~= nil and Config.TrapHouses[traphouseId].inventory[slot].name == itemName then
        Config.TrapHouses[traphouseId].inventory[slot].amount = Config.TrapHouses[traphouseId].inventory[slot].amount + amount
    else
        local itemInfo = RSCore.Shared.Items[itemName:lower()]
        Config.TrapHouses[traphouseId].inventory[slot] = {
            name = itemInfo["name"],
            amount = amount,
            info = info ~= nil and info or "",
            label = itemInfo["label"],
            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
            weight = itemInfo["weight"], 
            type = itemInfo["type"], 
            unique = itemInfo["unique"], 
            useable = itemInfo["useable"], 
            image = itemInfo["image"],
            slot = slot,
        }
    end
    SellTimeout(traphouseId, slot, itemName, amount, info)
    SaveTrapHouseConfig(traphouseId)
    TriggerClientEvent('rs-traphouses:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
end

function RemoveHouseItem(traphouseId, slot, itemName, amount)
	local amount = tonumber(amount)
    traphouseId = tonumber(traphouseId)
	if Config.TrapHouses[traphouseId].inventory[slot] ~= nil and Config.TrapHouses[traphouseId].inventory[slot].name == itemName then
		if Config.TrapHouses[traphouseId].inventory[slot].amount > amount then
			Config.TrapHouses[traphouseId].inventory[slot].amount = Config.TrapHouses[traphouseId].inventory[slot].amount - amount
		else
			Config.TrapHouses[traphouseId].inventory[slot] = nil
			if next(Config.TrapHouses[traphouseId].inventory) == nil then
				Config.TrapHouses[traphouseId].inventory = {}
			end
		end
	else
		Config.TrapHouses[traphouseId].inventory[slot] = nil
		if Config.TrapHouses[traphouseId].inventory == nil then
			Config.TrapHouses[traphouseId].inventory[slot] = nil
		end
    end
    SaveTrapHouseConfig(traphouseId)
    TriggerClientEvent('rs-traphouses:client:SyncData', -1, traphouseId, Config.TrapHouses[traphouseId])
end

function GetInventoryData(traphouse, slot)
    traphouse = tonumber(traphouse)
    if Config.TrapHouses[traphouse].inventory[slot] ~= nil then
        return Config.TrapHouses[traphouse].inventory[slot]
    else
        return nil
    end
end

function CanItemBeSaled(item)
    local retval = false
    if Config.AllowedItems[item] ~= nil then
        retval = true
    elseif item == "markedbills" then
        retval = true
    end
    return retval
end

RegisterServerEvent('rs-traphouses:server:RobNpc')
AddEventHandler('rs-traphouses:server:RobNpc', function(Traphouse)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local Chance = math.random(1, 500)
    print(Chance)
    if Chance == 17 then
        local info = {
            label = "Traphouse Pincode: "..Config.TrapHouses[Traphouse].pincode
        }
        Player.Functions.AddItem("stickynote", 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["stickynote"], "add")
    else
        local amount = math.random(3, 15)
        Player.Functions.AddMoney('cash', amount)
    end
end)

RSCore.Functions.CreateCallback('rs-traphouses:server:GetTraphousesData', function(source, cb)
    cb(Config.TrapHouses)
end)