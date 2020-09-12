RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

local Plates = {}
cuffedPlayers = {}
PlayerStatus = {}
Casings = {}
BloodDrops = {}
FingerDrops = {}
local RobbedPlayers = {}
local Objects = {}


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000 * 60 * 10)
        local curCops = GetCurrentCops()
        TriggerClientEvent("police:SetCopCount", -1, curCops)
    end
end)


RegisterServerEvent('police:server:ShareRobbedPlayers')
AddEventHandler('police:server:ShareRobbedPlayers', function(id, bool) 
    RobbedPlayers[id] = bool
    TriggerClientEvent('police:client:ShareRobbedPlayers', -1, RobbedPlayers)
end)

RegisterServerEvent('police:server:CheckBills')
AddEventHandler('police:server:CheckBills', function()
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `bills` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `type` = 'police'", function(result)
        if result[1] ~= nil then
            local totalAmount = 0
			for k, v in pairs(result) do
				totalAmount = totalAmount + tonumber(v.amount)
            end
            Player.Functions.RemoveMoney("bank", totalAmount, "paid-all-bills")
            RSCore.Functions.ExecuteSql(false, "DELETE FROM `bills` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `type` = 'police'")
            TriggerClientEvent('police:client:sendBillingMail', src, totalAmount)
		end
	end)
end)

RegisterServerEvent('police:server:CuffPlayer')
AddEventHandler('police:server:CuffPlayer', function(playerId, isSoftcuff)
    local src = source
    local Player = RSCore.Functions.GetPlayer(source)
    local CuffedPlayer = RSCore.Functions.GetPlayer(playerId)
    if CuffedPlayer ~= nil then
        if Player.Functions.GetItemByName("handcuffs") ~= nil or Player.PlayerData.job.name == "police" then
            TriggerClientEvent("police:client:GetCuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)
        end
    end
end)

RegisterServerEvent('police:server:EscortPlayer')
AddEventHandler('police:server:EscortPlayer', function(playerId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(source)
    local EscortPlayer = RSCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if (Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") or (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] or EscortPlayer.PlayerData.metadata["inlaststand"]) then
            TriggerClientEvent("police:client:GetEscorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('police:server:KidnapPlayer')
AddEventHandler('police:server:KidnapPlayer', function(playerId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(source)
    local EscortPlayer = RSCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] or EscortPlayer.PlayerData.metadata["inlaststand"] then
            TriggerClientEvent("police:client:GetKidnappedTarget", EscortPlayer.PlayerData.source, Player.PlayerData.source)
            TriggerClientEvent("police:client:GetKidnappedDragger", Player.PlayerData.source, EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('police:server:SetPlayerOutVehicle')
AddEventHandler('police:server:SetPlayerOutVehicle', function(playerId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(source)
    local EscortPlayer = RSCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("police:client:SetOutVehicle", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('police:server:PutPlayerInVehicle')
AddEventHandler('police:server:PutPlayerInVehicle', function(playerId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(source)
    local EscortPlayer = RSCore.Functions.GetPlayer(playerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("police:client:PutInVehicle", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('police:server:BillPlayer')
AddEventHandler('police:server:BillPlayer', function(playerId, price)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local OtherPlayer = RSCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            OtherPlayer.Functions.RemoveMoney("bank", price, "paid-bills")
            TriggerClientEvent('RSCore:Notify', OtherPlayer.PlayerData.source, "Je hebt een boete ontvangen van €"..price)
        end
    end
end)

RegisterServerEvent('police:server:JailPlayer')
AddEventHandler('police:server:JailPlayer', function(playerId, time)
    RSCore.Functions.BanInjection(source, 'rs-police (JailPlayer)')
end)

RSCore.Functions.CreateCallback('police:JailPlayer', function(source, cb, playerId, time)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local OtherPlayer = RSCore.Functions.GetPlayer(playerId)
    local currentDate = os.date("*t")
    if currentDate.day == 31 then currentDate.day = 30 end

    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            OtherPlayer.Functions.SetMetaData("injail", time)
            OtherPlayer.Functions.SetMetaData("criminalrecord", {
                ["hasRecord"] = true,
                ["date"] = currentDate
            })
            TriggerClientEvent("police:client:SendToJail", OtherPlayer.PlayerData.source, time)
            TriggerClientEvent('RSCore:Notify', src, "Je hebt "..OtherPlayer.PlayerData.charinfo.firstname.." "..OtherPlayer.PlayerData.charinfo.lastname.." naar de gevangenis gestuurd voor "..time.." maanden")
        end
    end
end)

RegisterServerEvent('police:server:UnJailPlayer')
AddEventHandler('police:server:UnJailPlayer', function(playerId, time)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local OtherPlayer = RSCore.Functions.GetPlayer(playerId)
    local currentDate = os.date("*t")
    if currentDate.day == 31 then currentDate.day = 30 end

    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            OtherPlayer.Functions.SetMetaData("injail", 0)

            TriggerClientEvent("police:client:SendToUnJail", OtherPlayer.PlayerData.source, time)
            TriggerClientEvent('RSCore:Notify', src, "Je hebt "..OtherPlayer.PlayerData.charinfo.firstname.." "..OtherPlayer.PlayerData.charinfo.lastname.." vrijgelaten")
        end
    end
end)

RegisterServerEvent('police:server:SetHandcuffStatus')
AddEventHandler('police:server:SetHandcuffStatus', function(isHandcuffed)
	local src = source
	local Player = RSCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData("ishandcuffed", isHandcuffed)
	end
end)

RegisterServerEvent('heli:spotlight')
AddEventHandler('heli:spotlight', function(state)
	local serverID = source
	TriggerClientEvent('heli:spotlight', -1, serverID, state)
end)

RegisterServerEvent('police:server:FlaggedPlateTriggered')
AddEventHandler('police:server:FlaggedPlateTriggered', function(camId, plate, street1, street2, blipSettings)
    local src = source
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if street2 ~= nil then
                    TriggerClientEvent("112:client:SendPoliceAlert", v, "flagged", {
                        camId = camId,
                        plate = plate,
                        streetLabel = street1.. " "..street2,
                    }, blipSettings)
                else
                    TriggerClientEvent("112:client:SendPoliceAlert", v, "flagged", {
                        camId = camId,
                        plate = plate,
                        streetLabel = street1
                    }, blipSettings)
                end
            end
        end
	end
end)

RegisterServerEvent('police:server:PoliceAlertMessage')
AddEventHandler('police:server:PoliceAlertMessage', function(title, streetLabel, coords)
    local src = source

    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("police:client:PoliceAlertMessage", v, title, streetLabel, coords)
            elseif Player.Functions.GetItemByName("radioscanner") ~= nil and math.random(1, 100) <= 50 then
                TriggerClientEvent("police:client:PoliceAlertMessage", v, title, streetLabel, coords)
            end
        end
    end
end)

RegisterServerEvent('police:server:GunshotAlert')
AddEventHandler('police:server:GunshotAlert', function(streetLabel, fromVehicle, coords, vehicleInfo)
    local src = source

    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("police:client:GunShotAlert", Player.PlayerData.source, streetLabel, fromVehicle, coords, vehicleInfo)
            elseif Player.Functions.GetItemByName("radioscanner") ~= nil and math.random(1, 100) <= 50 then
                TriggerClientEvent("police:client:GunShotAlert", Player.PlayerData.source, streetLabel, fromVehicle, coords, vehicleInfo)
            end
        end
    end
end)

RegisterServerEvent('police:server:VehicleCall')
AddEventHandler('police:server:VehicleCall', function(pos, msg, alertTitle, streetLabel, modelPlate, modelName)
    local src = source
    local alertData = {
        title = "Voertuigdiefstal",
        coords = {x = pos.x, y = pos.y, z = pos.z},
        description = msg,
    }
    TriggerClientEvent("police:client:VehicleCall", -1, pos, alertTitle, streetLabel, modelPlate, modelName)
    TriggerClientEvent("rs-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('police:server:HouseRobberyCall')
AddEventHandler('police:server:HouseRobberyCall', function(coords, message, gender, streetLabel)
    local src = source
    local alertData = {
        title = "Huisinbraak",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
    TriggerClientEvent("police:client:HouseRobberyCall", -1, coords, message, gender, streetLabel)
    TriggerClientEvent("rs-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('police:server:SendEmergencyMessage')
AddEventHandler('police:server:SendEmergencyMessage', function(coords, message)
    local src = source
    local MainPlayer = RSCore.Functions.GetPlayer(src)
    local alertData = {
        title = "112 Melding - "..MainPlayer.PlayerData.charinfo.firstname .. " " .. MainPlayer.PlayerData.charinfo.lastname .. " ("..src..")",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
    TriggerClientEvent("rs-phone:client:addPoliceAlert", -1, alertData)
    TriggerClientEvent('police:server:SendEmergencyMessageCheck', -1, MainPlayer, message, coords)
end)

RegisterServerEvent('police:server:SearchPlayer')
AddEventHandler('police:server:SearchPlayer', function(playerId)
    RSCore.Functions.BanInjection(source, 'rs-police (SearchPlayer)')
end)

RSCore.Functions.CreateCallback('police:SearchPlayer', function(source, cb, playerId)
    local src = source
    local SearchedPlayer = RSCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Persoon heeft €"..SearchedPlayer.PlayerData.money["cash"]..",- op zak..")
        TriggerClientEvent('RSCore:Notify', SearchedPlayer.PlayerData.source, "Je wordt gefouilleerd..")
    end
end)

RegisterServerEvent('police:server:SeizeCash')
AddEventHandler('police:server:SeizeCash', function(playerId)
    RSCore.Functions.BanInjection(source, 'rs-police (SeizeCash)')
end)

RSCore.Functions.CreateCallback('police:SeizeCash', function(source, cb, playerId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local SearchedPlayer = RSCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local moneyAmount = SearchedPlayer.PlayerData.money["cash"]
        local info = {
            cash = moneyAmount,
        }
        SearchedPlayer.Functions.RemoveMoney("cash", moneyAmount, "police-cash-seized")
        Player.Functions.AddItem("moneybag", 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, RSCore.Shared.Items["moneybag"], "add")
        TriggerClientEvent('RSCore:Notify', SearchedPlayer.PlayerData.source, "Jouw cash in beslag genomen..")
    end
end)

RegisterServerEvent('police:server:SeizeDriverLicense')
AddEventHandler('police:server:SeizeDriverLicense', function(playerId)
    RSCore.Functions.BanInjection(source, 'rs-police (SeizeDriverLicense)')
end)

RSCore.Functions.CreateCallback('police:SeizeDriverLicense', function(source, cb, playerId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local SearchedPlayer = RSCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then
        local driverLicense = SearchedPlayer.PlayerData.metadata["licences"]["driver"]
        if driverLicense then
            local licenses = {
                ["driver"] = false,
                ["business"] = SearchedPlayer.PlayerData.metadata["licences"]["business"]
            }
            SearchedPlayer.Functions.SetMetaData("licences", licenses)
            TriggerClientEvent('RSCore:Notify', SearchedPlayer.PlayerData.source, "Jouw rijbewijs in beslag genomen..")
        else
            TriggerClientEvent('RSCore:Notify', src, "Kan rijbewijs niet afnemen..", "error")
        end
    end
end)

RegisterServerEvent('police:server:RobPlayer')
AddEventHandler('police:server:RobPlayer', function(playerId)
    RSCore.Functions.BanInjection(source, 'rs-police (RobPlayer)')
end)

RSCore.Functions.CreateCallback('police:RobPlayer', function(source, cb, playerId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local SearchedPlayer = RSCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local money = SearchedPlayer.PlayerData.money["cash"]
        Player.Functions.AddMoney("cash", money, "police-player-robbed")
        SearchedPlayer.Functions.RemoveMoney("cash", money, "police-player-robbed")
        TriggerClientEvent('RSCore:Notify', SearchedPlayer.PlayerData.source, "Je bent van €"..money.." beroofd")
        RobbedPlayerDelay(playerId)     
    end
end)

function RobbedPlayerDelay(id)
    Citizen.CreateThread(function()
        Citizen.Wait(15000)
        RobbedPlayers[id] = false
        TriggerClientEvent('police:client:ShareRobbedPlayers', -1, RobbedPlayers)
    end)
end

RegisterServerEvent('police:server:UpdateBlips')
AddEventHandler('police:server:UpdateBlips', function()
    --print("I was in updateblips server side") 
    --local src = source --onnodig
    local dutyPlayers = {}
    local i = 1
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            -- Nico: Ik heb alles veranderd naar een numeric table en loop dan ook op die manier erdoor, i.v.m. dit probleem: https://riptutorial.com/lua/example/2258/iterating-tables
            -- TLDR: Gebruik maken van indexen i.p.v. datarijen, als een datarij nil is, dan stopt de for each daar. data.size of data.length = #data
            -- Het onstaan van een lege datarij kan dus spontaan gebeuren (als ik het goed begrijp) door table.insert.
            -- if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
            --     table.insert(dutyPlayers, {
            --         source = Player.PlayerData.source,
            --         label = Player.PlayerData.metadata["callsign"],
            --         job = Player.PlayerData.job.name,
            --     })
            -- end
            if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
                dutyPlayers[i] = {
                    source = Player.PlayerData.source,
                    label = Player.PlayerData.metadata["callsign"],
                    job = Player.PlayerData.job.name,
                }
                i = i + 1
            end
        end
    end
    TriggerClientEvent("police:client:UpdateBlips", -1, dutyPlayers)
    -- for k, v in ipairs(dutyPlayers) do --for each label in dutyPlayers print value
    --     print(v)
    --     print("Label: "..dutyPlayers.label)
    -- end
    -- for j=1, #dutyPlayers, 1 do
    --     print(dutyPlayers[j].label)
    -- end
end)

--Blip debug, returnt alle players met job ambu of popo om de seconde. De lijst die meegegeven wordt aan de clients via updateblips is deze lijst, maar dan wel onduty.
-- Citizen.CreateThread(function()
--     while true do 
--         Citizen.Wait(1000)
--         for k, v in pairs(RSCore.Functions.GetPlayers()) do
--             local Player = RSCore.Functions.GetPlayer(v)
--             if (Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") then
--                 print("Player callsign: "..Player.PlayerData.metadata["callsign"].." is onduty true/false: "..tostring(Player.PlayerData.job.onduty))
--             end
--         end
--     end
-- end)

Citizen.CreateThread(function()
    --Voor het geval er toch nog iets verkeerd mocht gaan, elke 20 seconden wordt de nieuwe spelerlijst doorgegeven aan elke client die in dienst is.
    while true do
        Citizen.Wait(20000)
        TriggerEvent('police:server:UpdateBlips')
    end
end)

RegisterServerEvent('police:server:spawnObject')
AddEventHandler('police:server:spawnObject', function(type)
    local src = source
    local objectId = CreateObjectId()
    Objects[objectId] = type
    TriggerClientEvent("police:client:spawnObject", -1, objectId, type, src)
end)

RegisterServerEvent('police:server:deleteObject')
AddEventHandler('police:server:deleteObject', function(objectId)
    local src = source
    TriggerClientEvent('police:client:removeObject', -1, objectId)
end)

RegisterServerEvent('police:server:Impound')
AddEventHandler('police:server:Impound', function(plate, fullImpound, price)
    local src = source
    local price = price ~= nil and price or 0
    if IsVehicleOwned(plate) then
        if not fullImpound then
            exports['ghmattimysql']:execute('UPDATE player_vehicles SET state = @state, depotprice = @depotprice WHERE plate = @plate', {['@state'] = 0, ['@depotprice'] = price, ['@plate'] = plate})
            TriggerClientEvent('RSCore:Notify', src, "Voertuig opgenomen in depot voor €"..price.."!")
        else
            exports['ghmattimysql']:execute('UPDATE player_vehicles SET state = @state WHERE plate = @plate', {['@state'] = 2, ['@plate'] = plate})
            TriggerClientEvent('RSCore:Notify', src, "Voertuig volledig in beslag genomen!")
        end
    end
end)

RegisterServerEvent('evidence:server:UpdateStatus')
AddEventHandler('evidence:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

RegisterServerEvent('evidence:server:CreateBloodDrop')
AddEventHandler('evidence:server:CreateBloodDrop', function(citizenid, bloodtype, coords)
    local src = source
    local bloodId = CreateBloodId()
    BloodDrops[bloodId] = {dna = citizenid, bloodtype = bloodtype}
    TriggerClientEvent("evidence:client:AddBlooddrop", -1, bloodId, citizenid, bloodtype, coords)
end)

RegisterServerEvent('evidence:server:CreateFingerDrop')
AddEventHandler('evidence:server:CreateFingerDrop', function(coords)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local fingerId = CreateFingerId()
    FingerDrops[fingerId] = Player.PlayerData.metadata["fingerprint"]
    TriggerClientEvent("evidence:client:AddFingerPrint", -1, fingerId, Player.PlayerData.metadata["fingerprint"], coords)
end)

RegisterServerEvent('evidence:server:ClearBlooddrops')
AddEventHandler('evidence:server:ClearBlooddrops', function(blooddropList)
    if blooddropList ~= nil and next(blooddropList) ~= nil then 
        for k, v in pairs(blooddropList) do
            TriggerClientEvent("evidence:client:RemoveBlooddrop", -1, v)
            BloodDrops[v] = nil
        end
    end
end)

RegisterServerEvent('evidence:server:AddBlooddropToInventory')
AddEventHandler('evidence:server:AddBlooddropToInventory', function(bloodId, bloodInfo)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, bloodInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, RSCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveBlooddrop", -1, bloodId)
            BloodDrops[bloodId] = nil
        end
    else
        TriggerClientEvent('RSCore:Notify', src, "Je moet een leeg bewijszakje bij je hebben", "error")
    end
end)

RegisterServerEvent('evidence:server:AddFingerprintToInventory')
AddEventHandler('evidence:server:AddFingerprintToInventory', function(fingerId, fingerInfo)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, fingerInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, RSCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveFingerprint", -1, fingerId)
            FingerDrops[fingerId] = nil
        end
    else
        TriggerClientEvent('RSCore:Notify', src, "Je moet een leeg bewijszakje bij je hebben", "error")
    end
end)

RegisterServerEvent('evidence:server:CreateCasing')
AddEventHandler('evidence:server:CreateCasing', function(weapon, coords)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local casingId = CreateCasingId()
    local weaponInfo = RSCore.Shared.Weapons[weapon]
    local serieNumber = nil
    if weaponInfo ~= nil then 
        local weaponItem = Player.Functions.GetItemByName(weaponInfo["name"])
        if weaponItem ~= nil then
            if weaponItem.info ~= nil and  weaponItem.info ~= "" then 
                serieNumber = weaponItem.info.serie
            end
        end
    end
    TriggerClientEvent("evidence:client:AddCasing", -1, casingId, weapon, coords, serieNumber)
end)


RegisterServerEvent('police:server:UpdateCurrentCops')
AddEventHandler('police:server:UpdateCurrentCops', function()
    local amount = 0
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    TriggerClientEvent("police:SetCopCount", -1, amount)
end)

RegisterServerEvent('evidence:server:ClearCasings')
AddEventHandler('evidence:server:ClearCasings', function(casingList)
    if casingList ~= nil and next(casingList) ~= nil then 
        for k, v in pairs(casingList) do
            TriggerClientEvent("evidence:client:RemoveCasing", -1, v)
            Casings[v] = nil
        end
    end
end)

RegisterServerEvent('evidence:server:AddCasingToInventory')
AddEventHandler('evidence:server:AddCasingToInventory', function(casingId, casingInfo)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
        if Player.Functions.AddItem("filled_evidence_bag", 1, false, casingInfo) then
            TriggerClientEvent("inventory:client:ItemBox", src, RSCore.Shared.Items["filled_evidence_bag"], "add")
            TriggerClientEvent("evidence:client:RemoveCasing", -1, casingId)
            Casings[casingId] = nil
        end
    else
        TriggerClientEvent('RSCore:Notify', src, "Je moet een leeg bewijszakje bij je hebben", "error")
    end
end)

RegisterServerEvent('police:server:showFingerprint')
AddEventHandler('police:server:showFingerprint', function(playerId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(playerId)

    TriggerClientEvent('police:client:showFingerprint', playerId, src)
    TriggerClientEvent('police:client:showFingerprint', src, playerId)
end)

RegisterServerEvent('police:server:showFingerprintId')
AddEventHandler('police:server:showFingerprintId', function(sessionId)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local fid = Player.PlayerData.metadata["fingerprint"]

    TriggerClientEvent('police:client:showFingerprintId', sessionId, fid)
    TriggerClientEvent('police:client:showFingerprintId', src, fid)
end)

RegisterServerEvent('police:server:SetTracker')
AddEventHandler('police:server:SetTracker', function(targetId)
    local Target = RSCore.Functions.GetPlayer(targetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]

    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('RSCore:Notify', targetId, 'Je enkelband is afgedaan.', 'error', 5000)
        TriggerClientEvent('RSCore:Notify', source, 'Je hebt een enkelband afgedaan van '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('police:client:SetTracker', targetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('RSCore:Notify', targetId, 'Je hebt een enkelband omgekregen.', 'error', 5000)
        TriggerClientEvent('RSCore:Notify', source, 'Je hebt een enkelband omgedaan bij '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('police:client:SetTracker', targetId, true)
    end
end)

RegisterServerEvent('police:server:SendTrackerLocation')
AddEventHandler('police:server:SendTrackerLocation', function(coords, requestId)
    local Target = RSCore.Functions.GetPlayer(source)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]

    local msg = "De locatie van "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname.." staat aangegeven op uw kaart."

    local alertData = {
        title = "Enkelband Locatie",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg
    }

    TriggerClientEvent("police:client:TrackerMessage", requestId, msg, coords)
    TriggerClientEvent("rs-phone:client:addPoliceAlert", requestId, alertData)
end)

RegisterServerEvent('police:server:SendPoliceEmergencyAlert')
AddEventHandler('police:server:SendPoliceEmergencyAlert', function(streetLabel, coords, callsign)
    local alertData = {
        title = "Assistentie collega",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Noodknop ingedrukt door ".. callsign .. " bij "..streetLabel,
    }
    TriggerClientEvent("police:client:PoliceEmergencyAlert", -1, callsign, streetLabel, coords)
    TriggerClientEvent("rs-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('police:server:SendPoliceLocationAlert')
AddEventHandler('police:server:SendPoliceLocationAlert', function(streetLabel, coords, callsign)
    local alertData = {
        title = "Locatie collega",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Locatie gestuurd door ".. callsign .. " bij "..streetLabel,
    }
    TriggerClientEvent("police:client:PoliceLocationAlert", -1, callsign, streetLabel, coords)
    TriggerClientEvent("rs-phone:client:addPoliceAlert", -1, alertData)
end)

RSCore.Functions.CreateCallback('police:server:isPlayerDead', function(source, cb, playerId)
    local Player = RSCore.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

RSCore.Functions.CreateCallback('police:GetPlayerStatus', function(source, cb, playerId)
    local Player = RSCore.Functions.GetPlayer(playerId)
    local statList = {}
	if Player ~= nil then
        if PlayerStatus[Player.PlayerData.source] ~= nil and next(PlayerStatus[Player.PlayerData.source]) ~= nil then
            for k, v in pairs(PlayerStatus[Player.PlayerData.source]) do
                table.insert(statList, PlayerStatus[Player.PlayerData.source][k].text)
            end
        end
	end
    cb(statList)
end)

RSCore.Functions.CreateCallback('police:IsSilencedWeapon', function(source, cb, weapon)
    local Player = RSCore.Functions.GetPlayer(source)
    local itemInfo = Player.Functions.GetItemByName(RSCore.Shared.Weapons[weapon]["name"])
    local retval = false
    if itemInfo ~= nil then 
        if itemInfo.info ~= nil and itemInfo.info.attachments ~= nil then 
            for k, v in pairs(itemInfo.info.attachments) do
                if itemInfo.info.attachments[k].component == "COMPONENT_AT_AR_SUPP_02" or itemInfo.info.attachments[k].component == "COMPONENT_AT_AR_SUPP" or itemInfo.info.attachments[k].component == "COMPONENT_AT_PI_SUPP_02" or itemInfo.info.attachments[k].component == "COMPONENT_AT_PI_SUPP" then
                    retval = true
                end
            end
        end
    end
    cb(retval)
end)

RSCore.Functions.CreateCallback('police:GetDutyPlayers', function(source, cb)
    local dutyPlayers = {}
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
                table.insert(dutyPlayers, {
                    source = Player.PlayerData.source,
                    label = Player.PlayerData.metadata["callsign"],
                    job = Player.PlayerData.job.name,
                })
            end
        end
    end
    cb(dutyPlayers)
end)

function CreateBloodId()
    if BloodDrops ~= nil then
		local bloodId = math.random(10000, 99999)
		while BloodDrops[caseId] ~= nil do
			bloodId = math.random(10000, 99999)
		end
		return bloodId
	else
		local bloodId = math.random(10000, 99999)
		return bloodId
	end
end

function CreateFingerId()
    if FingerDrops ~= nil then
		local fingerId = math.random(10000, 99999)
		while FingerDrops[caseId] ~= nil do
			fingerId = math.random(10000, 99999)
		end
		return fingerId
	else
		local fingerId = math.random(10000, 99999)
		return fingerId
	end
end

function CreateCasingId()
    if Casings ~= nil then
		local caseId = math.random(10000, 99999)
		while Casings[caseId] ~= nil do
			caseId = math.random(10000, 99999)
		end
		return caseId
	else
		local caseId = math.random(10000, 99999)
		return caseId
	end
end

function CreateObjectId()
    if Objects ~= nil then
		local objectId = math.random(10000, 99999)
		while Objects[caseId] ~= nil do
			objectId = math.random(10000, 99999)
		end
		return objectId
	else
		local objectId = math.random(10000, 99999)
		return objectId
	end
end

function IsVehicleOwned(plate)
    local val = false
	RSCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
		if (result[1] ~= nil) then
			val = true
		else
			val = false
		end
	end)
	return val
end

RSCore.Functions.CreateCallback('police:GetImpoundedVehicles', function(source, cb)
    local vehicles = {}
    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE state = @state', {['@state'] = 2}, function(result)
        if result[1] ~= nil then
            vehicles = result
        end
        cb(vehicles)
    end)
end)

RSCore.Functions.CreateCallback('police:IsPlateFlagged', function(source, cb, plate)
    local retval = false
    if Plates ~= nil and Plates[plate] ~= nil then
        if Plates[plate].isflagged then
            retval = true
        end
    end
    cb(retval)
end)

RSCore.Functions.CreateCallback('police:GetCops', function(source, cb)
    local amount = 0
    
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
	cb(amount)
end)

RSCore.Commands.Add("setpolice", "Geef de politie baan aan iemand ", {{name="id", help="Speler ID"}, {name="grade", help="rang"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(tonumber(args[1]))
    local Myself = RSCore.Functions.GetPlayer(source)
    if Player ~= nil then 
        if Myself.PlayerData.job.name == "police" and Myself.PlayerData.job.gradelabel == "Hoofdcommissaris" then
            Player.Functions.SetJob("police", tonumber(args[2]))
        else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt hier geen rechten voor")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end)

RSCore.Commands.Add("spikestrip", "Leg een spikestrip neer", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if Player ~= nil then 
        if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
            TriggerClientEvent('police:client:SpawnSpikeStrip', source)
        end
    end
end)

RSCore.Commands.Add("firepolice", "Ontsla een politieagent!", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(tonumber(args[1]))
    local Myself = RSCore.Functions.GetPlayer(source)
    if Player ~= nil then 
        if Myself.PlayerData.job.name == "police" and Myself.PlayerData.job.gradelabel == "Hoofdcommissaris" then
            Player.Functions.SetJob("unemployed", 1)
        else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt hier geen rechten voor")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end)

function IsHighCommand(citizenid)
    local retval = false
    for k, v in pairs(Config.ArmoryWhitelist) do
        if v == citizenid then
            retval = true
        end
    end
    return retval
end

RSCore.Commands.Add("pobject", "Plaats/Verwijder een object", {{name="type", help="Type object dat je wilt of 'delete' om te verwijderen"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    local type = args[1]:lower()
    if Player.PlayerData.job.name == "police" then
        if type == "pion" then
            TriggerClientEvent("police:client:spawnCone", source)
        elseif type == "barier" then
            TriggerClientEvent("police:client:spawnBarier", source)
        elseif type == "schotten" then
            TriggerClientEvent("police:client:spawnSchotten", source)
        elseif type == "tent" then
            TriggerClientEvent("police:client:spawnTent", source)
        elseif type == "light" then
            TriggerClientEvent("police:client:spawnLight", source)
        elseif type == "delete" then
            TriggerClientEvent("police:client:deleteObject", source)
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("cuff", "Boei een speler", {}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:CuffPlayer", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("pmelding", "Politie melding maken", {{name="bericht", help="Het Politie bericht"}}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    
    if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
        if args[1] ~= nil then
            local msg = table.concat(args, " ")
            TriggerClientEvent("chatMessage", -1, "POLITIE MELDING", "error", msg)
            TriggerEvent("rs-log:server:CreateLog", "pmelding", "Politie Melding", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Bericht:** " ..msg, false)
            TriggerClientEvent('police:PlaySound', -1)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je moet bericht invullen!")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("escort", "Escort een speler", {}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    TriggerClientEvent("police:client:EscortPlayer", source)
end)

RSCore.Commands.Add("databank", "Toggle politie databank", {}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:toggleDatabank", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("callsign", "Zet de naam van je callsign (roepnummer)", {{name="name", help="Naam van je callsign"}}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    Player.Functions.SetMetaData("callsign", table.concat(args, " "))
end)

RSCore.Commands.Add("clearcasings", "Haal kogelhulsen in de buurt weg (zorg ervoor dat je wel wat heb opgepakt)", {}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("evidence:client:ClearCasingsInArea", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("jail", "Stuur een persoon naar de gevangenis", {{name="id", help="Speler ID"},{name="tijd", help="Tijd hoelang hij moet rotten >:)"}}, true, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        local playerId = tonumber(args[1])
        local time = tonumber(args[2])
        if time > 0 then
            TriggerClientEvent("police:client:JailCommand", source, playerId, time)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Tijd moet hoger zijn dan 0")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("unjail", "Stuur een persoon naar de gevangenis", {{name="id", help="Speler ID"}}, true, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        local playerId = tonumber(args[1])
        TriggerClientEvent("police:client:UnJailCommand", source, playerId, 0)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("gimme", ":)", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    local info = {
        serie = "K"..math.random(10,99).."SH"..math.random(100,999).."HJ"..math.random(1,9),
        attachments = {
            {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
            {component = "COMPONENT_AT_AR_SUPP_02", label = "Supressor"},
            {component = "COMPONENT_AT_AR_AFGRIP", label = "Grip"},
            {component = "COMPONENT_AT_SCOPE_MACRO", label = "1x Scope"},
            {component = "COMPONENT_ASSAULTRIFLE_CLIP_02", label = "Extended Clip"},
        }
    }
    Player.Functions.AddItem("weapon_assaultrifle", 1, false, info)

end, "god")

RSCore.Commands.Add("gimme2", ":)", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    local info = {
        serie = "K"..math.random(10,99).."SH"..math.random(100,999).."HJ"..math.random(1,9),
        attachments = {
            {component = "COMPONENT_AT_AR_SUPP_02", label = "Supressor"},
        }
    }
    Player.Functions.AddItem("weapon_appistol", 1, false, info)

end, "god")

RSCore.Commands.Add("clearblood", "Haal bloed in de buurt weg (zorg ervoor dat je wel wat heb opgepakt)", {}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("evidence:client:ClearBlooddropsInArea", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("seizecash", "Pak contant geld af van de dichtsbijzijnde persoon", {}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        TriggerClientEvent("police:client:SeizeCash", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("sc", "Boei iemand maar laat hem wel lopen", {}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:CuffPlayerSoft", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("cam", "Bekijk beveiligings camera", {{name="camid", help="Camera ID"}}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:ActiveCamera", source, tonumber(args[1]))
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("flagplate", "Markeer een voertuig", {{name="plate", help="Kenteken"}, {name="reden", help="Reden voor markeren"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    
    if Player.PlayerData.job.name == "police" then
        local reason = {}
        for i = 2, #args, 1 do
            table.insert(reason, args[i])
        end
        Plates[args[1]:upper()] = {
            isflagged = true,
            reason = table.concat(reason, " ")
        }
        TriggerClientEvent('RSCore:Notify', source, "Voertuig ("..args[1]:upper()..") is gemarkeerd voor: "..table.concat(reason, " "))
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("unflagplate", "Zet een voertuig ongemarkeerd", {{name="plate", help="Kenteken"}}, true, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if Plates ~= nil and Plates[args[1]:upper()] ~= nil then
            if Plates[args[1]:upper()].isflagged then
                Plates[args[1]:upper()].isflagged = false
                TriggerClientEvent('RSCore:Notify', source, "Voertuig ("..args[1]:upper()..") is niet meer gemarkeerd")
            else
                TriggerClientEvent('chatMessage', source, "MELDKAMER", "error", "Voertuig is niet gemarkeerd!")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Voertuig is niet gemarkeerd!")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("plateinfo", "Markeer een voertuig", {{name="plate", help="Kenteken"}}, true, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if Plates ~= nil and Plates[args[1]:upper()] ~= nil then
            if Plates[args[1]:upper()].isflagged then
                TriggerClientEvent('chatMessage', source, "MELDKAMER", "normal", "Voertuig ("..args[1]:upper()..") is gemarkeerd voor: "..Plates[args[1]:upper()].reason)
            else
                TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Voertuig is niet gemarkeerd!")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Voertuig is niet gemarkeerd!")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("depot", "Stuur een voertuig naar het depot", {{name="prijs", help="Prijs voor hoeveel degene moet betalen (mag leeg zijn)"}}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:ImpoundVehicle", source, false, tonumber(args[1]))
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("beslag", "Neem een voertuig in beslag", {}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:ImpoundVehicle", source, true)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("paytow", "Betaal een bergnet medewerker", {{name="id", help="ID van een speler"}}, true, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance" then
        local playerId = tonumber(args[1])
        local OtherPlayer = RSCore.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "tow" then
                OtherPlayer.Functions.AddMoney("bank", 500, "police-tow-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEM", "warning", "Je hebt €500,- ontvangen voor je dienst!")
                TriggerClientEvent('RSCore:Notify', source, 'Je hebt een bergnet medewerker betaald')
            else
                TriggerClientEvent('RSCore:Notify', source, 'Persoon is geen bergnet medewerker', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("paylaw", "Betaal een advocaat", {{name="id", help="ID van een speler"}}, true, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local OtherPlayer = RSCore.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "lawyer" then
                OtherPlayer.Functions.AddMoney("bank", 500, "police-lawyer-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEM", "warning", "Je hebt €500,- ontvangen voor je pro-deo zaak!")
                TriggerClientEvent('RSCore:Notify', source, 'Je hebt een advocaat betaald')
            else
                TriggerClientEvent('RSCore:Notify', source, 'Persoon is geen advocaat', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("radar", "Toggle snelheidsradar :)", {}, false, function(source, args)
	local Player = RSCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("wk:toggleRadar", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Functions.CreateUseableItem("handcuffs", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("police:client:CuffPlayerSoft", source)
    end
end)

RSCore.Commands.Add("112", "Stuur een melding naar hulpdiensten", {{name="bericht", help="Bericht die je wilt sturen naar de hulpdiensten"}}, true, function(source, args)
    local message = table.concat(args, " ")
    local Player = RSCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent("police:client:SendEmergencyMessage", source, message)
        TriggerEvent("rs-log:server:CreateLog", "112", "112 Melding", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Melding:** " ..message, false)
    else
        TriggerClientEvent('RSCore:Notify', source, 'Je hebt geen telefoon', 'error')
    end
end)

RSCore.Commands.Add("112a", "Stuur een anonieme melding naar hulpdiensten (geeft geen locatie)", {{name="bericht", help="Bericht die je wilt sturen naar de hulpdiensten"}}, true, function(source, args)
    local message = table.concat(args, " ")
    local Player = RSCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent("police:client:CallAnim", source)
        TriggerClientEvent('police:client:Send112AMessage', -1, message)
    else
        TriggerClientEvent('RSCore:Notify', source, 'Je hebt geen telefoon', 'error')
    end
end)

RSCore.Commands.Add("112r", "Stuur een bericht terug naar een melding", {{name="id", help="ID van de melding"}, {name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    local OtherPlayer = RSCore.Functions.GetPlayer(tonumber(args[1]))
    table.remove(args, 1)
    local message = table.concat(args, " ")
    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "(POLITIE) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
            TriggerClientEvent("police:client:EmergencySound", OtherPlayer.PlayerData.source)
            TriggerClientEvent("police:client:CallAnim", source)
        end
    elseif Player.PlayerData.job.name == "ambulance" then
        if OtherPlayer ~= nil then 
            TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "(AMBULANCE) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
            TriggerClientEvent("police:client:EmergencySound", OtherPlayer.PlayerData.source)
            TriggerClientEvent("police:client:CallAnim", source)
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("enkelband", "Doe een enkelband om bij het dichtsbijzijnde persoon.", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)

    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("police:client:CheckDistance", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("enkelbandlocatie", "Haal locatie van persoon met enkelband", {{"bsn", "BSN van persoon"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    
    if Player.PlayerData.job.name == "police" then
        if args[1] ~= nil then
            local citizenid = args[1]
            local Target = RSCore.Functions.GetPlayerByCitizenId(citizenid)

            if Target ~= nil then
                if Target.PlayerData.metadata["tracker"] then
                    TriggerClientEvent("police:client:SendTrackerLocation", Target.PlayerData.source, source)
                else
                    TriggerClientEvent('RSCore:Notify', source, 'Dit persoon heeft geen enkelband.', 'error')
                end
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

RSCore.Commands.Add("noodknop", "Stuur een noodknop naar de polite en ambulance", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
        TriggerClientEvent("police:client:SendPoliceEmergencyAlert", source)
    end
end)

RSCore.Commands.Add("locatie", "Stuur een locatie naar alle eenheden", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
        TriggerClientEvent("police:client:SendPoliceLocation", source)
    end
end)

RSCore.Commands.Add("neemrijbewijs", "Neem een rijbewijs af van iemand", {}, false, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
        TriggerClientEvent("police:client:SeizeDriverLicense", source)
    end
end)

RSCore.Commands.Add("neemdna", "Neem een DNA exemplaar af van een persoon (leeg bewijszakje nodig)", {{"id", "ID van persoon"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    local OtherPlayer = RSCore.Functions.GetPlayer(tonumber(args[1]))
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) and OtherPlayer ~= nil then
        if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
            local info = {
                label = "DNA-Monster",
                type = "dna",
                dnalabel = DnaHash(OtherPlayer.PlayerData.citizenid),
            }
            if Player.Functions.AddItem("filled_evidence_bag", 1, false, info) then
                TriggerClientEvent("inventory:client:ItemBox", source, RSCore.Shared.Items["filled_evidence_bag"], "add")
            end
        else
            TriggerClientEvent('RSCore:Notify', source, "Je moet een leeg bewijszakje bij je hebben", "error")
        end
    end
end)

RSCore.Functions.CreateUseableItem("moneybag", function(source, item)
    local Player = RSCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        if item.info ~= nil and item.info ~= "" then
            if Player.PlayerData.job.name ~= "police" then
                if Player.Functions.RemoveItem("moneybag", 1, item.slot) then
                    Player.Functions.AddMoney("cash", tonumber(item.info.cash), "used-moneybag")
                end
            end
        end
    end
end)

function GetCurrentCops()
    local amount = 0
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end

RSCore.Functions.CreateCallback('police:server:IsPoliceForcePresent', function(source, cb)
    local retval = false
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            for _, citizenid in pairs(Config.ArmoryWhitelist) do
                if citizenid == Player.PlayerData.citizenid then
                    retval = true
                    break
                end
            end
        end
    end
    cb(retval)
end)

function DnaHash(s)
    local h = string.gsub(s, ".", function(c)
		return string.format("%02x", string.byte(c))
	end)
    return h
end

RegisterServerEvent('police:server:SyncSpikes')
AddEventHandler('police:server:SyncSpikes', function(table)
    TriggerClientEvent('police:client:SyncSpikes', -1, table)
end)