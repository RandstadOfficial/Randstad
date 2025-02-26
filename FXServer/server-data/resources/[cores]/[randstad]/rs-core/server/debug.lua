RegisterServerEvent('RSCore:DebugSomething')
AddEventHandler('RSCore:DebugSomething', function(resource, obj, depth)
    print("\x1b[4m\x1b[36m["..resource..":DEBUG]\x1b[0m")
    if type(obj) == "string" then
        print(string.format("%q", obj))
    elseif type(obj) == "table" then
        local str = "{"
        for k, v in pairs(obj) do
            if type(v) == "table" then
                for ik, iv in pairs(v) do
                    str = str.."\n["..k.."] -> ["..ik.."] -> "..tostring(iv)
                end
            else
                str = str.."\n["..k.."] -> "..tostring(v)
            end
        end
        
        print(str.."\n}")
    else
        local success, value = pcall(function() return tostring(obj) end)
        print((success and value or "<!!error in __tostring metamethod!!>"))
    end
    print("\x1b[4m\x1b[36mEND OF DEBUG\x1b[0m")
end)

RSCore.Debug = function(resource, obj, depth)
    TriggerEvent('RSCore:DebugSomething', resource, obj, depth)
end

RSCore.ShowError = function(resource, msg)
    print("\x1b[31m["..resource..":ERROR]\x1b[0m "..msg)
end

RSCore.ShowSuccess = function(resource, msg)
    print("\x1b[32m["..resource..":LOG]\x1b[0m "..msg)
end
