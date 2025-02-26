RSCore = nil
atms = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
-- Bank ID = 43, 48, 60, 67, 69 is enabled for plofkraak
-- Code

local BankStatus = {}

RegisterServerEvent('rs-banking:server:SetBankClosed')
AddEventHandler('rs-banking:server:SetBankClosed', function(BankId, bool)
  BankStatus[BankId] = bool
  TriggerClientEvent('rs-banking:client:SetBankClosed', -1, BankId, bool)
end)


RegisterServerEvent('rs-banking:server:UpdateATM')
AddEventHandler('rs-banking:server:UpdateATM', function(id, data) --LLG
  local sql = "UPDATE `banking` SET "
  if data.cashInside ~= nil then
    sql = sql .. "`cashInside` = '".. data.cashInside .."', "
  end
  
  if data.hijackable ~= nil then
    sql = sql .. "`hijackable` = '".. data.hijackable .."', "
  end
  
  if data.isHijacked ~= nil then
    sql = sql .. "`isHijacked` = '".. data.isHijacked .."', "
  end
  
  if data.inUse ~= nil then
    sql = sql .. "`inUse` = '".. data.inUse .."', "
  end

  if data.isUsedBy ~= nil then
    sql = sql .. "`isUsedBy` = '".. data.isUsedBy .."', "
  end

  if data.blocked ~= nil then
    sql = sql .. "`blocked` = '".. data.blocked .."', "
  end

  sql = sql:sub(1, #sql - 2)
  sql = sql .. " WHERE `id` = '".. id .."'"
  RSCore.Functions.ExecuteSql(false, sql, function()
    updateClient()
  end)
end)

RegisterServerEvent('rs-banking:server:GetAtms')
AddEventHandler('rs-banking:server:GetAtms', function() --LLG
  updateClient()
end)

RSCore.Functions.CreateCallback("rs-banking:server:HijackTimer", function(source, cb, id) --LLG 
  HijackTimer(id)
end)


RegisterServerEvent('rs-banking:server:HijackTimer')
AddEventHandler('rs-banking:server:HijackTimer', function(id) 
  RSCore.Functions.BanInjection(source, "rs-banking (HijackTimer)")
end)

Citizen.CreateThread(function() --LLG
  RSCore.Functions.ExecuteSql(false, "SELECT * FROM `banking` WHERE `blocked` = '1' OR `isUsedBy` != '0' OR `inUse` = '1' OR `isHijacked` = '1'", function(result)
    for k, v in pairs(result) do
      RSCore.Functions.ExecuteSql(false, "UPDATE `banking` SET `blocked` = '0', `isUsedBy`= '0', `inUse`= '0', `isHijacked`= '0' WHERE `id` = '".. v.id .."'", function()
      end)
    end
  end)
end)

function HijackTimer(id) --LLG
  Citizen.CreateThread(function()
    Citizen.Wait(60000 * 60)
    RSCore.Functions.ExecuteSql(false, "UPDATE `banking` SET `blocked` = '0', `isUsedBy` = '0'  WHERE `id` = '".. id .."'", function()
      print('ATM ' .. id .. ' Unblocked')
      updateClient()
    end)
  end)
end

function updateClient() --LLG
  RSCore.Functions.ExecuteSql(false, "SELECT * FROM `banking`", function(result)
    TriggerClientEvent('rs-banking:client:GetAtms', -1, result)
    atms = result
  end)
end

function GetDistanceBetweenCoords(posA, posB) --LLG
  return math.abs(posA.x - posB.x) + math.abs(posA.y - posB.y) + math.abs(posA.z - posB.z)
end

function GetAtmFromDB(pos) --LLG
  if atms == nil or pos == nil then
    return nil
  end
  for _,atm in pairs(atms) do
    local dist = GetDistanceBetweenCoords(pos, atm)
    if dist <= 7.5 then
      return atm.id
    end
  end
end


RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)
    local bankamount = ply.PlayerData.money["bank"]
    local amount = tonumber(amount)

    local pos = GetEntityCoords(GetPlayerPed(src)) -- LLG
    local atmId = GetAtmFromDB(pos)

    if bankamount >= amount and amount > 0 then
      if atmId ~= nil then
        if amount > atms[atmId].cashInside then
          TriggerClientEvent('RSCore:Notify', src, 'Niet voldoende geld in de atm. ('.. atms[atmId].cashInside ..') euro beschikbaar..', 'error')
        else
          local data = {}
          data.cashInside = atms[atmId].cashInside - amount
          TriggerEvent('rs-banking:server:UpdateATM', atmId, data)

          ply.Functions.RemoveMoney('bank', amount, "Bank withdraw")
          TriggerEvent("rs-log:server:CreateLog", "banking", "Withdraw", "red", "**"..GetPlayerName(src) .. "** heeft €"..amount.." opgenomen van zijn bank.")
          ply.Functions.AddMoney('cash', amount, "Bank withdraw")
        end
      else
        ply.Functions.RemoveMoney('bank', amount, "Bank withdraw")
        TriggerEvent("rs-log:server:CreateLog", "banking", "Withdraw", "red", "**"..GetPlayerName(src) .. "** heeft €"..amount.." opgenomen van zijn bank.")
        ply.Functions.AddMoney('cash', amount, "Bank withdraw")
      end
    else
    TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet voldoende geld op je bank..', 'error')
    end
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)
    local cashamount = ply.PlayerData.money["cash"]
    local amount = tonumber(amount)

    local pos = GetEntityCoords(GetPlayerPed(src)) -- LLG
    local atmId = GetAtmFromDB(pos)

    if cashamount >= amount and amount > 0 then
      if atmId ~= nil then
        local data = {}
        data.cashInside = atms[atmId].cashInside + amount
        TriggerEvent('rs-banking:server:UpdateATM', atmId, data)
      end
      ply.Functions.RemoveMoney('cash', amount, "Bank depost")
      TriggerEvent("rs-log:server:CreateLog", "banking", "Deposit", "green", "**"..GetPlayerName(src) .. "** heeft €"..amount.." op zijn bank gezet.")
      ply.Functions.AddMoney('bank', amount, "Bank depost")
    else
      TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet voldoende geld op zak..', 'error')
    end
end)

RSCore.Commands.Add("geefcontant", "Geef contant geld aan een persoon", {{name="id", help="Speler ID"},{name="bedrag", help="Hoeveelheid geld"}}, true, function(source, args)
  local Player = RSCore.Functions.GetPlayer(source)
  local TargetId = tonumber(args[1])
  local Target = RSCore.Functions.GetPlayer(TargetId)
  local amount = tonumber(args[2])
  
  if Target ~= nil then
    if amount ~= nil then
      if amount > 0 then
        if Player.PlayerData.money.cash >= amount and amount > 0 then
          if TargetId ~= source then
            TriggerClientEvent('banking:client:CheckDistance', source, TargetId, amount)
          else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je kunt geen geld aan jezelf geven.")
          end
        else
          TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt niet genoeg geld.")
        end
      else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "De hoeveelheid moet hoger zijn dan 0.")
      end
    else
      TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Vul een hoeveelheid in.")
    end
  else
    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Persoon is niet in de stad.")
  end    
end)

RSCore.Functions.CreateCallback("banking:server:GiveHijackCash", function(source, cb, amount)
  local src = source
  local player = RSCore.Functions.GetPlayer(src)
  local pos = GetEntityCoords(GetPlayerPed(src)) -- LLG
  local atmId = GetAtmFromDB(pos)
  
  player.Functions.AddMoney('cash', amount, "Geld opgepakt van de kraak") -- change text
  TriggerEvent("rs-log:server:CreateLog", "banking", "ATM Robbery", "yellow", "**"..GetPlayerName(src) .. "** heeft €"..amount.." opgepakt van automaat ID: "..atmId..".")
end)

RegisterServerEvent('banking:server:GiveHijackCash')
AddEventHandler('banking:server:GiveHijackCash', function(amount)
  RSCore.Functions.BanInjection(source, "Banking (GiveHijackCash)")  
end)

RegisterServerEvent('banking:server:giveCash')
AddEventHandler('banking:server:giveCash', function()
  RSCore.Functions.BanInjection(source, "Banking (giveCash)")
end)

RSCore.Functions.CreateCallback('banking:giveCash', function(source, cb, trgetId, amount)
  local src = source
  local Player = RSCore.Functions.GetPlayer(src)
  local Target = RSCore.Functions.GetPlayer(trgetId)

  Player.Functions.RemoveMoney('cash', amount, "Cash given to "..Player.PlayerData.citizenid)
  Target.Functions.AddMoney('cash', amount, "Cash received from "..Target.PlayerData.citizenid)

  TriggerEvent("rs-log:server:CreateLog", "banking", "Geef contant", "blue", "**"..GetPlayerName(src) .. "** heeft €"..amount.." gegeven aan **" .. GetPlayerName(trgtId) .. "**")
  
  TriggerClientEvent('RSCore:Notify', trgtId, "Je hebt €"..amount.." gekregen van "..Player.PlayerData.charinfo.firstname.."!", 'success')
  TriggerClientEvent('RSCore:Notify', src, "Je hebt €"..amount.." gegeven aan "..Target.PlayerData.charinfo.firstname.."!", 'success')
end)


RegisterServerEvent('banking:server:callCops')
AddEventHandler('banking:server:callCops', function(streetLabel, coords)
    local msg = "Er is een explosie op "..streetLabel..", mogelijk plofkraak."
    local alertData = {
        title = "Plofkraak",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg
    }
    for k, v in pairs(RSCore.Functions.GetPlayers()) do
        local Player = RSCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("banking:client:robberyCall", Player.PlayerData.source, msg, streetLabel, coords)
                TriggerClientEvent("rs-phone:client:addPoliceAlert", Player.PlayerData.source, alertData)
            end
        end
	end
end)

RSCore.Commands.Add("resetatm", "Reset alle geld in geldautomaten", {}, false, function(source, args)
  RSCore.Functions.ExecuteSql(false, "UPDATE banking SET cashInside = '100000', inUse = '0', isUsedBy = '0'", function()
  TriggerClientEvent('chatMessage', source, "SYSTEM", "success", "Alle geldautomaten zijn gereset")
  updateClient()
  end)
end, "admin")
