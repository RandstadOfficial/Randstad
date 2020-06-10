RSCore.Commands.Add("blackout", "Doe een blackout", {}, false, function(source, args)
    ToggleBlackout()
end, "god")

RSCore.Commands.Add("clock", "Vernader de clock op uren en minuten", {}, false, function(source, args)
    if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
        SetExactTime(args[1], args[2])
    end
end, "god")

RSCore.Commands.Add("time", "Stel een tijd in", {}, false, function(source, args)
    for _, v in pairs(AvailableTimeTypes) do
        if args[1]:upper() == v then
            SetTime(args[1])
            return
        end
    end
end, "god")

RSCore.Commands.Add("weather", "Verander het weer", {}, false, function(source, args)
    for _, v in pairs(AvailableWeatherTypes) do
        if args[1]:upper() == v then
            SetWeather(args[1])
            return
        end
    end
end, "god")

RSCore.Commands.Add("freeze", "Zet weer en tijd stil", {}, false, function(source, args)
    if args[1]:lower() == 'weather' or args[1]:lower() == 'time' then
        FreezeElement(args[1])
    end
end, "god")