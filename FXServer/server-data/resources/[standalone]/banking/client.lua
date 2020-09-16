Keys = {
  ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
  ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
  ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
  ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
  ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
  ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
  ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
  ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

RSCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if RSCore == nil then
            TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

-- Settings
local depositAtATM = true -- Allows the player to deposit at an ATM rather than only in banks (Default: false)
local giveCashAnywhere = false -- Allows the player to give CASH to another player, no matter how far away they are. (Default: false)
local withdrawAnywhere = false -- Allows the player to withdraw cash from bank account anywhere (Default: false)
local depositAnywhere = false -- Allows the player to deposit cash into bank account anywhere (Default: false)
local displayBankBlips = true -- Toggles Bank Blips on the map (Default: true)
local displayAtmBlips = false -- Toggles ATM blips on the map (Default: false) // THIS IS UGLY. SOME ICONS OVERLAP BECAUSE SOME PLACES HAVE MULTIPLE ATM MACHINES. NOT RECOMMENDED
local enableBankingGui = true -- Enables the banking GUI (Default: true) // MAY HAVE SOME ISSUES

-- ATMS
local atms = nil
local CurrentCops = 0

ATMObjects = {
  -870868698,
  -1126237515,
  -1364697528,
  506770882,
}

-- Banks
local banks = {
  [1] = {name="Bank", Closed = false, id=108, x = 314.187,   y = -278.621,  z = 54.170},
  [2] = {name="Bank", Closed = false, id=108, x = 150.266,   y = -1040.203, z = 29.374},
  [3] = {name="Bank", Closed = false,  id=108, x = -351.534,  y = -49.529,   z = 49.042},
  [4] = {name="Bank", Closed = false, id=108, x = -1212.980, y = -330.841,  z = 37.787},
  [5] = {name="Bank", Closed = false, id=108, x = -2962.582, y = 482.627,   z = 15.703},
  [6] = {name="Bank", Closed = false, id=108, x = -112.202,  y = 6469.295,  z = 31.626},
  [7] = {name="Bank", Closed = false, id=108, x = 243.191,   y = 224.812,   z = 106.286},
  [8] = {name="Bank", Closed = false, id=108, x = -1310.45, y = -824.98, z = 17.14},
  [9] = {name="Bank", Closed = false, id=108, x = 1175.21,  y = 2706.517, z = 38.09},
}

AddEventHandler('onClientGameTypeStart', function()  --LLG
  TriggerServerEvent('rs-banking:server:GetAtms')
end)

RegisterNetEvent('rs-banking:client:GetAtms')
AddEventHandler('rs-banking:client:GetAtms', function(result)
  atms = nil
  atms = result
end)

RegisterNetEvent('rs-banking:client:SetBankClosed')
AddEventHandler('rs-banking:client:SetBankClosed', function(BankId, bool)
  banks[BankId].Closed = bool
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)


-- Display Map Blips
Citizen.CreateThread(function()
  TriggerServerEvent('rs-banking:server:GetAtms')
  if (displayBankBlips == true) then
    for _, item in pairs(banks) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipColour(item.blip, 0)
        SetBlipScale(item.blip, 0.6)
        SetBlipAsShortRange(item.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end
  end

  while atms == nil do --LLG
    Citizen.Wait(100)
  end

  if (displayAtmBlips == true) then
    for _, item in pairs(atms) do -- Added hardcoded name ATM and blipSprite 277
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, 277)
      SetBlipScale(item.blip, 0.65)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString('ATM')
      EndTextCommandSetBlipName(item.blip)
    end
  end
end)

-- NUI Variables
local atBank = false
local atATM = false
local bankOpen = false
local atmOpen = false

-- Open Gui and Focus NUI
function openGui()
  local ped = GetPlayerPed(-1)
  local playerPed = GetPlayerPed(-1)
  local PlayerData = RSCore.Functions.GetPlayerData()
  TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_ATM", 0, true)
  RSCore.Functions.Progressbar("use_bank", "Kaart wordt gelezen..", 2500, false, true, {}, {}, {}, {}, function() -- Done
      ClearPedTasksImmediately(ped)
      SetNuiFocus(true, true)
      SendNUIMessage({
        openBank = true,
        PlayerData = PlayerData
      })
  end, function() -- Cancel
      ClearPedTasksImmediately(ped)
      RSCore.Functions.Notify("Geannuleerd..", "error")
  end)
end

-- Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false, false)
  SendNUIMessage({openBank = false})
  bankOpen = false
  atmOpen = false
end

DrawText3Ds = function(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  local factor = (string.len(text)) / 370
  DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
  ClearDrawOrigin()
end

function SpawnMoney(pos) --LLG
  local prop = "prop_anim_cash_pile_02"
  Citizen.CreateThread(function()
    RequestModel(prop)
    while not HasModelLoaded(prop) do
      Citizen.Wait(100)
    end
    local amount = math.random(5, 15)
    while amount >= 0 do
      local object = CreateObject(prop, pos.x, pos.y, pos.z, true, true, true)
      PlaceObjectOnGroundProperly(object)
      amount = amount - 1
    end
  end)
end

-- function StopFire(pos)
--   Citizen.CreateThread(function()
--     Citizen.Wait(math.random(0, 5000))
--     StopFireInRange( pos.x, pos.y, pos.z, 10)
--   end)
-- end

function PlaceExplosive(pos, atmId) --LLG
  Citizen.CreateThread(function()
    local time = math.random(15000, 20000)
    if math.random(1, 20) == 5 then
      time = 1000
    end

    Citizen.Wait(time)
    AddExplosion(pos.x, pos.y, pos.z, EXPLOSION_GAS_TANK, 1.0, true, false, 1.0)
    -- StartScriptFire(pos.x, pos.y, pos.z, 5, true)
    -- StopFire(pos)
    SpawnMoney(pos)

    local data = {}
    data.inUse = 0
    TriggerServerEvent('rs-banking:server:UpdateATM', atmId, data)
  end)
end

function GetAtmFromDB(pos)  --LLG
  if atms == nil or pos == nil then
    return nil
  end
  for _,atm in pairs(atms) do
    local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, atm.x, atm.y, atm.z, true)
    if dist <= 7.5 then
      return atm.id
    end
  end
end

function removeCash()
  Citizen.CreateThread(function()
    local prop = "prop_anim_cash_pile_02"
    local strike = 0
    local amount = 0
    while true and strike < 10 do
      local pedCoords = GetEntityCoords(PlayerPedId())
      local objectId = GetClosestObjectOfType(pedCoords, 5.0, GetHashKey(prop), false)
      if objectId ~= 0 then
        DeleteEntity(objectId)
        DeleteObject(objectId)
        amount = amount + 1
      else
        strike = strike + 1
      end
      Citizen.Wait(250)
    end
  end)
end

function PoliceAlert()
  local ped = GetPlayerPed(-1)
  local pos = GetEntityCoords(ped)
  local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
  local street1 = GetStreetNameFromHashKey(s1)
  local street2 = GetStreetNameFromHashKey(s2)
  local streetLabel = street1
  if street2 ~= nil then 
      streetLabel = streetLabel .. " " .. street2
  end

  TriggerServerEvent('banking:server:callCops', streetLabel, pos)
end

RegisterNetEvent('banking:client:robberyCall')
AddEventHandler('banking:client:robberyCall', function(msg, streetLabel, coords)
PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
  TriggerEvent('rs-policealerts:client:AddPoliceAlert', {
    timeOut = 5000,
    alertTitle = "Plofkraak",
    coords = {
      x = coords.x,
      y = coords.y,
      z = coords.z,
    },
    details = {
      [1] = {
        icon = '<i class="far fa-credit-card"></i>',
        detail = " Geldautomaat",
      },
      [2] = {
        icon = '<i class="fas fa-globe-europe"></i>',
        detail = streetLabel,
      },
    },
    callSign = RSCore.Functions.GetPlayerData().metadata["callsign"],
    })
    local transG = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 458)
    SetBlipColour(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipAlpha(blip, transG)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Plofkraak")
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(3)

    inRange = false

    local pos = GetEntityCoords(GetPlayerPed(-1))
    local nearbank, bankkey = IsNearBank()
    local atmId = GetAtmFromDB(pos)
    local playerId = GetPlayerServerId(PlayerId())
    local Health = GetEntityHealth(GetPlayerPed(-1))
    local isAlive = true
    if Health == 0 or Health == 150 then
      isAlive = false
    end

    if nearbank then
      atBank = true
      inRange = true
      if not banks[bankkey].Closed then
        DrawMarker(2, banks[bankkey].x, banks[bankkey].y, banks[bankkey].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 55, 255, 55, 255, 0, 0, 0, 1, 0, 0, 0)
        DrawText3Ds(banks[bankkey].x, banks[bankkey].y, banks[bankkey].z + 0.3, '[E] Kaart valideren')
        if IsControlJustPressed(1, Keys["E"])  then
          if (not IsInVehicle()) then
            if bankOpen then
              closeGui()
              bankOpen = false
            else
              openGui()
              bankOpen = true
            end
          end
        end
      else
        DrawText3Ds(banks[bankkey].x, banks[bankkey].y, banks[bankkey].z + 0.3, 'De bank is gesloten')
        DrawMarker(2, banks[bankkey].x, banks[bankkey].y, banks[bankkey].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 255, 55, 55, 255, 0, 0, 0, 1, 0, 0, 0)
      end
    elseif IsNearATM() then
      atBank = true
      inRange = true
      if atms ~= nil then
        --print(atmId) -- dit is om ATM id te zien
        if atms[atmId] ~= nil then
          if atms[atmId].blocked == 0 and atms[atmId].cashInside > 0 then
            if atms[atmId].inUse == 0 then
              if atms[atmId].isHijacked == 0 and isAlive then
                DrawText3Ds(pos.x, pos.y, pos.z, '[E] Kaart valideren')
                if atms[atmId].hijackable == 1 then
                DrawText3Ds(pos.x, pos.y, pos.z-0.15, '[R] Om een plofkraak te plegen')
                end
              else
                if atms[atmId].hijackable == 1  and isAlive then
                  DrawText3Ds(pos.x, pos.y, pos.z, '[R] Om geld op te pakken')
                end
              end
            end

            DisableControlAction(0, 140, true) --LLG

            if IsDisabledControlJustPressed(0, 140) and atms[atmId].hijackable == 1 and atms[atmId].inUse == 0 and isAlive then
              if atms[atmId].isHijacked == 0 then
                if CurrentCops >= 3 or true then
                  RSCore.Functions.TriggerCallback('RSCore:HasItem', function(result)
                    if result or true then 
                      local data = {}
                      data.inUse = 1
                      data.isUsedBy = playerId
                      TriggerServerEvent('rs-banking:server:UpdateATM', atmId, data)
                      RSCore.Functions.Progressbar("", "Gasbom plaatsen...", 15000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                      }, {
                        animDict = "anim@gangops@facility@servers@",
                        anim = "hotwire",
                        flags = 50,
                      }, {}, {}, function() -- Done
                        if data.isUsedBy == 0 or data.isUsedBy == playerId then
                          PlaceExplosive(pos, atmId)
                          PoliceAlert()
                          ClearPedTasksImmediately(ped)
                          StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                          local data = {}
                          data.isHijacked = 1
                          TriggerServerEvent('rs-banking:server:UpdateATM', atmId, data)
                          TriggerServerEvent("RSCore:Server:RemoveItem", "gasbomb", 1)
                          TriggerEvent("inventory:client:ItemBox", RSCore.Shared.Items["gasbomb"], "remove")
                          RSCore.Functions.Notify("Gasbom geplaatst, wacht tot die afgaat...", "success")
                        else
                          RSCore.Functions.Notify("Geldautomaat word al gebruikt..", "error")
                        end
                      end, function() -- Cancel
                        local data = {}
                        data.inUse = 0
                        data.isUsedBy = 0
                        TriggerServerEvent('rs-banking:server:UpdateATM', atmId, data)
                        ClearPedTasksImmediately(ped)
                        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                        RSCore.Functions.Notify("Geannuleerd..", "error")
                      end)
                    else
                        RSCore.Functions.Notify("Je mist een item..", "error")
                    end
                  end, "gasbomb")
                  Citizen.Wait(1000)
                else
                  RSCore.Functions.Notify('Niet genoeg agenten..', 'error', 3500)
                end
              else
                if atms[atmId].isUsedBy == 0 or atms[atmId].isUsedBy == playerId then
                  local data = {}
                  data.inUse = 1
                  TriggerServerEvent('rs-banking:server:UpdateATM', atmId, data)
                  removeCash()
                  local earning = math.random(5000, 8000)
                  RSCore.Functions.Progressbar("take_atm_money", "Geld Pakken...", 15000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                  }, {
                    animDict = "mp_take_money_mg",
                    anim = "stand_cash_in_bag_loop",
                    flags = 49,
                  }, {}, {}, function() -- Done
                      local data = {}
                      data.isHijacked = 0
                      data.blocked = 1 -- Set to 1
                      data.inUse = 0
                      if atms[atmId].cashInside < earning then
                        earning = atms[atmId].cashInside
                      end
                      data.cashInside = atms[atmId].cashInside - earning
                      RSCore.Functions.TriggerCallback("banking:server:GiveHijackCash", function(result)
                      end, earning)
                      TriggerServerEvent('rs-banking:server:UpdateATM', atmId, data)
                      RSCore.Functions.TriggerCallback("rs-banking:server:HijackTimer", function(result)
                      end, atmId)
                      StopAnimTask(GetPlayerPed(-1), "mp_take_money_mg", "stand_cash_in_bag_loop", 1.0)
                  end, function() -- Cancel
                    local data = {}
                    data.inUse = 0
                    TriggerServerEvent('rs-banking:server:UpdateATM', atmId, data)
                    ClearPedTasksImmediately(ped)
                    StopAnimTask(GetPlayerPed(-1), "mp_take_money_mg", "stand_cash_in_bag_loop", 1.0)
                    RSCore.Functions.Notify("Geannuleerd..", "error")
                  end)
                else
                  RSCore.Functions.Notify("Geldautomaat word al gebruikt..", "error")
                end
              end
            end
            
            if IsControlJustPressed(1, Keys["E"]) and atms[atmId].isHijacked == 0 and atms[atmId].inUse == 0 then
              if (not IsInVehicle()) then
                if bankOpen then
                closeGui()
                bankOpen = false
                else
                openGui()
                bankOpen = true
                end
              end
            end
          else
            if atms[atmId].cashInside > 0 then
                DrawText3Ds(pos.x, pos.y, pos.z, 'Geldautomaat is stuk')
            else
                DrawText3Ds(pos.x, pos.y, pos.z, 'Geldautomaat is leeg')
            end
          end
        end
      end
    end
    
    if not inRange then
      Citizen.Wait(1500)
    end
  end
end)

-- Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if bankOpen or atmOpen then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisableControlAction(0, 24, active) -- Attack
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('balance', function(data, cb)
  SendNUIMessage({openSection = "balance"})
  cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
  SendNUIMessage({openSection = "withdraw"})
  cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
  SendNUIMessage({openSection = "deposit"})
  cb('ok')
end)

RegisterNUICallback('depositSubmit', function(data, cb)
  TriggerEvent('bank:deposit', data.amount)
  cb('ok')
end)

RegisterNUICallback('withdrawSubmit', function(data, cb)
  TriggerServerEvent('bank:withdraw', data.amount)
  SetTimeout(500, function()
    local PlayerData = RSCore.Functions.GetPlayerData()
    SendNUIMessage({
      updateBalance = true,
      PlayerData = PlayerData
    })
  end)
  cb('ok')
end)

RegisterNUICallback('depositSubmit', function(data, cb)
  --TriggerServerEvent('bank:deposit', data.amount)
  SetTimeout(500, function()
    local PlayerData = RSCore.Functions.GetPlayerData()
    SendNUIMessage({
      updateBalance = true,
      PlayerData = PlayerData
    })
  end)
  cb('ok')
end)

RegisterNUICallback('transferSubmit', function(data, cb)
  local fromPlayer = GetPlayerServerId();
  TriggerEvent('bank:transfer', tonumber(fromPlayer), tonumber(data.toPlayer), tonumber(data.amount))
  cb('ok')
end)

-- Check if player is near an atm
function IsNearATM()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  for k, v in pairs(ATMObjects) do
    local closestObj = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 3.0, v, false, 0, 0)
    local objCoords = GetEntityCoords(closestObj)
    if closestObj ~= 0 then
      local dist = GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, objCoords.x, objCoords.y, objCoords.z, true)
      if dist <= 2 then
        return true
      end
    end
  end
  return false
end

-- Check if player is in a vehicle
function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-- Check if player is near a bank
function IsNearBank()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  for key, item in pairs(banks) do
    local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if(distance <= 2) then
      return true, key
    end
  end
end

RegisterNetEvent('banking:client:executeEvents')
AddEventHandler('banking:client:executeEvents', function()
  TriggerServerEvent('banking:server:giveCash', playerId, amount)
end)

-- Process deposit if conditions met
RegisterNetEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
  if(IsNearBank() == true or depositAtATM == true and IsNearATM() == true) then
    TriggerServerEvent("bank:deposit", tonumber(amount))
  else
    RSCore.Functions.Notify("ERROR, deze geldautomaat is kaduuk!", "error")
  end
end)

-- Check if player is near another player
function IsNearPlayer(player)
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
  local ply2Coords = GetEntityCoords(ply2, 0)
  local distance = GetDistanceBetweenCoords(ply2Coords["x"], ply2Coords["y"], ply2Coords["z"],  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
  if(distance <= 5) then
    return true
  end
end

function GetClosestPlayer()
  local closestPlayers = RSCore.Functions.GetPlayersFromCoords()
  local closestDistance = -1
  local closestPlayer = -1
  local coords = GetEntityCoords(GetPlayerPed(-1))

  for i=1, #closestPlayers, 1 do
      if closestPlayers[i] ~= PlayerId() then
          local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
          local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

          if closestDistance == -1 or closestDistance > distance then
              closestPlayer = closestPlayers[i]
              closestDistance = distance
          end
      end
end

return closestPlayer, closestDistance
end

RegisterNetEvent('banking:client:CheckDistance')
AddEventHandler('banking:client:CheckDistance', function(targetId, amount)
  local player, distance = GetClosestPlayer()
  if player ~= -1 and distance < 2.5 then
    local playerId = GetPlayerServerId(player)
    if targetId == playerId then
      RSCore.Functions.TriggerCallback('banking:giveCash', function()
      end, playerId, amount)
    end
  else
    RSCore.Functions.Notify('Je bent niet bij het persoon in de buurt..', 'error')
  end
end)