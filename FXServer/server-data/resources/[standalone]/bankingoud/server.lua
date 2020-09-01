RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

local BankStatus = {}

RegisterServerEvent('rs-banking:server:SetBankClosed')
AddEventHandler('rs-banking:server:SetBankClosed', function(BankId, bool)
  print(BankId)
  BankStatus[BankId] = bool
  TriggerClientEvent('rs-banking:client:SetBankClosed', -1, BankId, bool)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local src = source
    local ply = RSCore.Functions.GetPlayer(src)
    local bankamount = ply.PlayerData.money["bank"]
    local amount = tonumber(amount)
    if bankamount >= amount and amount > 0 then
      ply.Functions.RemoveMoney('bank', amount, "Bank withdraw")
      TriggerEvent("rs-log:server:CreateLog", "banking", "Withdraw", "red", "**"..GetPlayerName(src) .. "** heeft €"..amount.." opgenomen van zijn bank.")
      ply.Functions.AddMoney('cash', amount, "Bank withdraw")
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
    if cashamount >= amount and amount > 0 then
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

RegisterServerEvent('banking:server:giveCash')
AddEventHandler('banking:server:giveCash', function()
  RSCore.Functions.BanInjection(source)
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
