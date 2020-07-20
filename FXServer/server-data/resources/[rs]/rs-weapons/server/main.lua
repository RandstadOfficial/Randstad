RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local WeaponAmmo = {}

RSCore.Functions.CreateCallback("weapons:server:GetConfig", function(source, cb)
    cb(Config.WeaponRepairPoints)
end)

-- RegisterServerEvent("weapons:server:LoadWeaponAmmo")
-- AddEventHandler('weapons:server:LoadWeaponAmmo', function()
-- 	local src = source
--     local Player = RSCore.Functions.GetPlayer(src)
--     WeaponAmmo[Player.PlayerData.citizenid] = {}
--     RSCore.Functions.ExecuteSql(false, "SELECT * FROM `playerammo` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
--         if result[1] ~= nil then
--             local ammo = json.decode(result[1].ammo)
--             if ammo ~= nil then
--                 for ammotype, amount in pairs(ammo) do 
--                     WeaponAmmo[Player.PlayerData.citizenid][ammotype] = amount
--                 end
--             end
--         end
-- 	end)
-- end)

RegisterServerEvent("weapons:server:AddWeaponAmmo")
AddEventHandler('weapons:server:AddWeaponAmmo', function(CurrentWeaponData, amount)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local amount = tonumber(amount)

    if CurrentWeaponData ~= nil then
        if Player.PlayerData.items[CurrentWeaponData.slot] ~= nil then
            Player.PlayerData.items[CurrentWeaponData.slot].info.ammo = amount
        end
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RegisterServerEvent("weapons:server:UpdateWeaponAmmo")
AddEventHandler('weapons:server:UpdateWeaponAmmo', function(CurrentWeaponData, amount)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local amount = tonumber(amount)
    if CurrentWeaponData ~= nil then
        if Player.PlayerData.items[CurrentWeaponData.slot] ~= nil then
            Player.PlayerData.items[CurrentWeaponData.slot].info.ammo = amount
        end
        Player.Functions.SetInventory(Player.PlayerData.items)
    end
end)

RSCore.Functions.CreateCallback("weapon:server:GetWeaponAmmo", function(source, cb, WeaponData)
    local Player = RSCore.Functions.GetPlayer(source)
    local retval = 0
    if WeaponData ~= nil then
        if Player ~= nil then
            local ItemData = Player.Functions.GetItemBySlot(WeaponData.slot)
            if ItemData ~= nil then
                retval = ItemData.info.ammo ~= nil and ItemData.info.ammo or 0
            end
        end
    end
    cb(retval)
end)

RSCore.Functions.CreateUseableItem("pistol_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_PISTOL", 12, item)
end)

RSCore.Functions.CreateUseableItem("rifle_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_RIFLE", 30, item)
end)

RSCore.Functions.CreateUseableItem("smg_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SMG", 20, item)
end)

RSCore.Functions.CreateUseableItem("shotgun_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SHOTGUN", 10, item)
end)

RSCore.Functions.CreateUseableItem("mg_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_MG", 30, item)
end)

function IsWeaponBlocked(WeaponName)
    local retval = false
    for _, name in pairs(Config.DurabilityBlockedWeapons) do
        if name == WeaponName then
            retval = true
            break
        end 
    end
    return retval
end

-- RegisterServerEvent('weapons:server:UpdateWeaponQuality')
-- AddEventHandler('weapons:server:UpdateWeaponQuality', function(data)
--     local src = source
--     local Player = RSCore.Functions.GetPlayer(src)
--     local WeaponData = RSCore.Shared.Weapons[GetHashKey(data.name)]
--     local WeaponSlot = Player.PlayerData.items[data.slot]
--     local DecreaseAmount = Config.DurabilityMultiplier[data.name]
    
--     if not IsWeaponBlocked(WeaponData.name) then
--         if WeaponSlot.info.quality ~= nil then
--             if WeaponSlot.info.quality - DecreaseAmount > 0 then
--                 WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
--             else
--                 WeaponSlot.info.quality = 0
--                 TriggerClientEvent('inventory:client:UseWeapon', src, data)
--                 TriggerClientEvent('RSCore:Notify', src, "Jouw wapen is gebroken, je moet dit wapen repareren voordat je hem weer kunt gebruiken.", "error")
--             end
--         else
--             WeaponSlot.info.quality = 100
--             if WeaponSlot.info.quality - DecreaseAmount > 0 then
--                 WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
--             else
--                 WeaponSlot.info.quality = 0
--                 TriggerClientEvent('inventory:client:UseWeapon', src, data)
--                 TriggerClientEvent('RSCore:Notify', src, "Jouw wapen is gebroken, je moet dit wapen repareren voordat je hem weer kunt gebruiken.", "error")
--             end
--         end
--         Player.Functions.SetInventory(Player.PlayerData.items)
--     end
-- end)

RegisterServerEvent('weapons:server:UpdateWeaponQuality')
AddEventHandler('weapons:server:UpdateWeaponQuality', function(data, RepeatAmount)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local WeaponData = RSCore.Shared.Weapons[GetHashKey(data.name)]
    local WeaponSlot = Player.PlayerData.items[data.slot]
    local DecreaseAmount = Config.DurabilityMultiplier[data.name]

    if WeaponSlot ~= nil then
        if not IsWeaponBlocked(WeaponData.name) then
            if WeaponSlot.info.quality ~= nil then
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('inventory:client:UseWeapon', src, data)
                        TriggerClientEvent('RSCore:Notify', src, "Jouw wapen is gebroken, je moet dit wapen repareren voordat je hem weer kunt gebruiken.", "error")
                        break
                    end
                end
            else
                WeaponSlot.info.quality = 100
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('inventory:client:UseWeapon', src, data)
                        TriggerClientEvent('RSCore:Notify', src, "Jouw wapen is gebroken, je moet dit wapen repareren voordat je hem weer kunt gebruiken.", "error")
                        break
                    end
                end
            end
        end
    end

    Player.Functions.SetInventory(Player.PlayerData.items)
end)

RSCore.Commands.Add("repairweapon", "Repareer wapen command voor staff", {{name="hp", help="HP van je wapen"}}, true, function(source, args)
    TriggerClientEvent('weapons:client:SetWeaponQuality', source, tonumber(args[1]))
end, "god")

RegisterServerEvent("weapons:server:SetWeaponQuality")
AddEventHandler("weapons:server:SetWeaponQuality", function(data, hp)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local WeaponData = RSCore.Shared.Weapons[GetHashKey(data.name)]
    local WeaponSlot = Player.PlayerData.items[data.slot]
    local DecreaseAmount = Config.DurabilityMultiplier[data.name]
    WeaponSlot.info.quality = hp
    Player.Functions.SetInventory(Player.PlayerData.items)
end)

RSCore.Functions.CreateCallback("weapons:server:RepairWeapon", function(source, cb, RepairPoint, data)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local minute = 60 * 1000
    local Timeout = math.random(5 * minute, 10 * minute)
    local WeaponData = RSCore.Shared.Weapons[GetHashKey(data.name)]
    local WeaponClass = (RSCore.Shared.SplitStr(WeaponData.ammotype, "_")[2]):lower()

    if Player.PlayerData.items[data.slot] ~= nil then
        if Player.PlayerData.items[data.slot].info.quality ~= nil then
            if Player.PlayerData.items[data.slot].info.quality ~= 100 then
                if Player.Functions.RemoveMoney('cash', Config.WeaponRepairCotsts[WeaponClass]) then
                    Config.WeaponRepairPoints[RepairPoint].IsRepairing = true
                    Config.WeaponRepairPoints[RepairPoint].RepairingData = {
                        CitizenId = Player.PlayerData.citizenid,
                        WeaponData = Player.PlayerData.items[data.slot],
                        Ready = false,
                    }
                    Player.Functions.RemoveItem(data.name, 1, data.slot)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[data.name], "remove")
                    TriggerClientEvent("inventory:client:CheckWeapon", src, data.name)
                    TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[RepairPoint], RepairPoint)

                    SetTimeout(Timeout, function()
                        Config.WeaponRepairPoints[RepairPoint].IsRepairing = false
                        Config.WeaponRepairPoints[RepairPoint].RepairingData.Ready = true
                        TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[RepairPoint], RepairPoint)
                        TriggerEvent('rs-phone:server:sendNewMailToOffline', Player.PlayerData.citizenid, {
                            sender = "Tyrone",
                            subject = "Reperatie",
                            message = "Je "..WeaponData.label.." is gerepareerd! Je kunt hem komen halen op de vaste locatie. <br><br> Peace out madafaka"
                        })
                        SetTimeout(7 * 60000, function()
                            if Config.WeaponRepairPoints[RepairPoint].RepairingData.Ready then
                                Config.WeaponRepairPoints[RepairPoint].IsRepairing = false
                                Config.WeaponRepairPoints[RepairPoint].RepairingData = {}
                                TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[RepairPoint], RepairPoint)
                            end
                        end)
                    end)
                    cb(true)
                else
                    cb(false)
                end
            else
                TriggerClientEvent("RSCore:Notify", src, "Dit wapen is niet beschadigd..", "error")
                cb(false)
            end
        else
            TriggerClientEvent("RSCore:Notify", src, "Dit wapen is niet beschadigd..", "error")
            cb(false)
        end
    else
        TriggerClientEvent('RSCore:Notify', src, "Je had geen wapen in je hand..", "error")
        TriggerClientEvent('weapons:client:SetCurrentWeapon', src, {}, false)
        cb(false)
    end
end)

RegisterServerEvent("weapons:server:TakeBackWeapon")
AddEventHandler("weapons:server:TakeBackWeapon", function(k, data)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local itemdata = Config.WeaponRepairPoints[k].RepairingData.WeaponData

    itemdata.info.quality = 100
    Player.Functions.AddItem(itemdata.name, 1, false, itemdata.info)
    TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[itemdata.name], "add")
    Config.WeaponRepairPoints[k].IsRepairing = false
    Config.WeaponRepairPoints[k].RepairingData = {}
    TriggerClientEvent('weapons:client:SyncRepairShops', -1, Config.WeaponRepairPoints[k], k)
end)

RSCore.Functions.CreateUseableItem("pistol_suppressor", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "suppressor")
end)

RSCore.Functions.CreateUseableItem("smg_suppressor", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "suppressor")
end)

RSCore.Functions.CreateUseableItem("rifle_suppressor", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "suppressor")
end)

RSCore.Functions.CreateUseableItem("pistol_extendedclip", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "extendedclip")
end)

RSCore.Functions.CreateUseableItem("smg_extendedclip", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "extendedclip")
end)

RSCore.Functions.CreateUseableItem("smg_flashlight", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "flashlight")
end)

RSCore.Functions.CreateUseableItem("smg_scope", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "scope")
end)

RSCore.Functions.CreateUseableItem("smg_scope", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "scope")
end)

RSCore.Functions.CreateUseableItem("rifle_extendedclip", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "extendedclip")
end)

RSCore.Functions.CreateUseableItem("rifle_drummag", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("weapons:client:EquipAttachment", source, item, "drummag")
end)

function HasAttachment(component, attachments)
    local retval = false
    local key = nil
    for k, v in pairs(attachments) do
        if v.component == component then
            key = k
            retval = true
        end
    end
    return retval, key
end

function GetAttachmentItem(weapon, component)
    local retval = nil
    for k, v in pairs(Config.WeaponAttachments[weapon]) do
        if v.component == component then
            retval = v.item
        end
    end
    return retval
end

RegisterServerEvent("weapons:server:EquipAttachment")
AddEventHandler("weapons:server:EquipAttachment", function(ItemData, CurrentWeaponData, AttachmentData)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local GiveBackItem = nil
    if Inventory[CurrentWeaponData.slot] ~= nil then
        if Inventory[CurrentWeaponData.slot].info.attachments ~= nil and next(Inventory[CurrentWeaponData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentData.component, Inventory[CurrentWeaponData.slot].info.attachments)
            if not HasAttach then
                if CurrentWeaponData.name == "weapon_compactrifle" then
                    local component = "COMPONENT_COMPACTRIFLE_CLIP_03"
                    if AttachmentData.component == "COMPONENT_COMPACTRIFLE_CLIP_03" then
                        component = "COMPONENT_COMPACTRIFLE_CLIP_02"
                    end
                    for k, v in pairs(Inventory[CurrentWeaponData.slot].info.attachments) do
                        if v.component == component then
                            local has, key = HasAttachment(component, Inventory[CurrentWeaponData.slot].info.attachments)
                            local item = GetAttachmentItem(CurrentWeaponData.name:upper(), component)
                            GiveBackItem = tostring(item):lower()
                            table.remove(Inventory[CurrentWeaponData.slot].info.attachments, key)
                            TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[item], "add")
                        end
                    end
                end
                table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                    component = AttachmentData.component,
                    label = AttachmentData.label,
                })
                TriggerClientEvent("addAttachment", src, AttachmentData.component)
                Player.Functions.SetInventory(Player.PlayerData.items)
                Player.Functions.RemoveItem(ItemData.name, 1)
                SetTimeout(1000, function()
                    TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "remove")
                end)
            else
                TriggerClientEvent("RSCore:Notify", src, "Je hebt al een "..AttachmentData.label:lower().." op jouw wapen zitten.", "error", 3500)
            end
        else
            Inventory[CurrentWeaponData.slot].info.attachments = {}
            table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                component = AttachmentData.component,
                label = AttachmentData.label,
            })
            TriggerClientEvent("addAttachment", src, AttachmentData.component)
            Player.Functions.SetInventory(Player.PlayerData.items)
            Player.Functions.RemoveItem(ItemData.name, 1)
            SetTimeout(1000, function()
                TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "remove")
            end)
        end
    end

    if GiveBackItem ~= nil then
        Player.Functions.AddItem(GiveBackItem, 1, false)
        GiveBackItem = nil
    end
end)

RSCore.Functions.CreateCallback('weapons:server:RemoveAttachment', function(source, cb, AttachmentData, ItemData)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local AttachmentComponent = Config.WeaponAttachments[ItemData.name:upper()][AttachmentData.attachment]

    if Inventory[ItemData.slot] ~= nil then
        if Inventory[ItemData.slot].info.attachments ~= nil and next(Inventory[ItemData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentComponent.component, Inventory[ItemData.slot].info.attachments)
            if HasAttach then
                table.remove(Inventory[ItemData.slot].info.attachments, key)
                Player.Functions.SetInventory(Player.PlayerData.items)
                Player.Functions.AddItem(AttachmentComponent.item, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[AttachmentComponent.item], "add")
                TriggerClientEvent("RSCore:Notify", src, "Je hebt de "..AttachmentComponent.label.." van je wapen verwijderd!", "error")
                cb(Inventory[ItemData.slot].info.attachments)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)