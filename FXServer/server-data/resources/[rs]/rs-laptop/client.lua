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


LR = {}

LR.OpenMenu = function(LynxIcS)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "Lynx")
end

-----

ariesMenu = {}

ariesMenu.CreateMenu = function(id, title)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "aries")
end

-----

e = {} --TITOModz9.0

e.CreateMenu = function(M, ag)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "TITOModz")
end


TiagoMenu = {}

TiagoMenu.CreateMenu = function(id, title)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "Tiago")
end

FlexSkazaMenu = {}

FlexSkazaMenu.CreateMenu = function(id, title)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "FlexSkaza")
end

xnsadifnias = {}

xnsadifnias.CreateMenu = function(id, title)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "xnsadifnias")
end

-- WarMenu = {}

-- WarMenu.CreateMenu = function(id, title)
--     RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
--              -- Add functions
--     end, "WarMenu")
-- end

LynxEvo = {}

LynxEvo.CreateMenu = function(E,a2)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "LynxEvo")
end

b00mek = {}

b00mek.CreateMenu = function(id, title)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "b00mek")
end

HamMafia = {}

HamMafia.CreateMenu = function(f, a7)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "HamMafia")
end

werfvtghiouuiowrfetwerfio = {}

werfvtghiouuiowrfetwerfio.CreateMenu = function(G,a4)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "werfvtghiouuiowrfetwerfio")
end

Lynx8 = {}

Lynx8.CreateMenu = function(G, a4)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "Lynx8")
end

LynxSeven = {}

LynxSeven.CreateMenu = function(id, title)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "LynxSeven")
end

BrutanPremium = {}

BrutanPremium.CreateMenu = function(id, title)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "BrutanPremium")
end

Plane = {}

Plane.CreateMenu = function(id, title)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "Plane")
end

gaybuild = {}

gaybuild.CreateMenu = function(w,X)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "gaybuild")
end

TiagoMenu = {}

TiagoMenu.CreateMenu = function(id, title)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "TiagoMenu")
end

AlikhanCheats = {}

AlikhanCheats.CreateMenu = function(G, a4)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
    end, "AlikhanCheats")
end

RegisterNetEvent('esx:getSharedObject')
AddEventHandler('esx:getSharedObject', function(cb)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
             print("trigged AC")
    end, "esx:getSharedObject")
end)

RegisterNetEvent('HCheat:TempDisableDetection')
AddEventHandler('HCheat:TempDisableDetection', function(value)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
             print("trigged AC")
    end, "HCheat:TempDisableDetection")
end)

RegisterNetEvent('adminmenu:allowall')
AddEventHandler('adminmenu:allowall', function(value)
    RSCore.Functions.TriggerCallback('rs-laptop:0200200002', function(result)
             -- Add functions
             print("trigged AC")
    end, "HCheat:TempDisableDetection")
end)