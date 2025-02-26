RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
local loggingApi = ""

RegisterServerEvent('rs-log:server:CreateLog')
AddEventHandler('rs-log:server:CreateLog', function(name, title, color, message, tagEveryone)
    local tag = tagEveryone ~= nil and tagEveryone or false
    local webHook = Config.Webhooks[name] ~= nil and Config.Webhooks[name] or Config.Webhooks["default"]
    local embedData = {
        {
            ["title"] = title,
            ["color"] = Config.Colors[color] ~= nil and Config.Colors[color] or Config.Colors["default"],
            ["footer"] = {
                ["text"] = os.date("%c"),
            },
            ["description"] = message,
        }
    }
    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Randstad Logs",embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Citizen.Wait(100)
    if tag then
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = "Randstad Logs", content = "@everyone"}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('rs-log:server:sendLog')
AddEventHandler('rs-log:server:sendLog', function(citizenid, logtype, data)
    local dataString = ""
    data = data ~= nil and data or {}
    for key,value in pairs(data) do 
        if dataString ~= "" then
            dataString = dataString .. "&"
        end
        dataString = dataString .. key .."="..value
    end
    local requestUrl = string.format("%s?citizenid=%s&logtype=%s&%s", loggingApi, citizenid, logtype, dataString)
    requestUrl = string.gsub(requestUrl, ' ', "%%20")
    PerformHttpRequest(requestUrl, function(err, text, headers) end, 'GET', '')
end)

RSCore.Commands.Add("testwebhook", ":)", {}, false, function(source, args)
    TriggerEvent("rs-log:server:CreateLog", "default", "TestWebhook", "default", "Triggered **een** test webhook :)")
end, "god")



-- https://qbus.onno204.nl/qbus-management/backend/fivem/log -->