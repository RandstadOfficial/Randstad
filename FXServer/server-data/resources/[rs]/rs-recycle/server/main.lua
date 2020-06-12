RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local ItemTable = {
    "aluminum",
    "plastic",
    "copper",
    "iron",
    "metalscrap",
    "steel",
    "glass",
}

RegisterServerEvent("rs-recycle:server:getItem")
AddEventHandler("rs-recycle:server:getItem", function()
    local reason = "Doei doei hackertje"
    local banTime = 2147483647
    local timeTable = os.date("*t", banTime)
    TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(source).." is verbannen voor: "..reason.."")
    RSCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..GetPlayerIdentifiers(source)[3].."', '"..GetPlayerIdentifiers(source)[4].."', '"..reason.."', "..banTime..")")
    DropPlayer(source, "Hé sukkel, je bent verbannen van de server:\n"..reason.."\n\nJe ban verloopt "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Kijk op onze discord voor meer informatie")
end)

RSCore.Functions.CreateCallback('rs-recycle:getItem', function(source, cb)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    for i = 1, math.random(2, 4), 1 do
        local randItem = ItemTable[math.random(1, #ItemTable)]
        local amount = math.random(2, 4)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items[randItem], 'add')
        Citizen.Wait(500)
    end  
end)