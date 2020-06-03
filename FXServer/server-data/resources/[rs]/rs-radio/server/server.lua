RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

-- Code

RSCore.Functions.CreateUseableItem("radio", function(source, item)
  local Player = RSCore.Functions.GetPlayer(source)
  TriggerClientEvent('rs-radio:use', source)
end)

RSCore.Functions.CreateCallback('rs-radio:server:GetItem', function(source, cb, item)
  local src = source
  local Player = RSCore.Functions.GetPlayer(src)
  if Player ~= nil then 
    local RadioItem = Player.Functions.GetItemByName(item)
    if RadioItem ~= nil then
      cb(true)
    else
      cb(false)
    end
  else
    cb(false)
  end
end)