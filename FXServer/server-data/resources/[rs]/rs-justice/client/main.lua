RSCore = nil

Citizen.CreateThread(function()
    while RSCore == nil do
        TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(416.61, -1084.57, 30.05)
	SetBlipSprite(blip, 304)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.6)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Gerechtshof")
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent("rs-justice:client:showLawyerLicense")
AddEventHandler("rs-justice:client:showLawyerLicense", function(sourceId, data)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Pas-ID:</strong> {1} <br><strong>Voornaam:</strong> {2} <br><strong>Achternaam:</strong> {3} <br><strong>BSN:</strong> {4} </div></div>',
            args = {'Advocatenpas', data.id, data.firstname, data.lastname, data.citizenid}
        })
    end
end)

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}
  
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end
  
function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end
  
function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end
  
function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
  
function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function GetAllPeds()
    local peds = {}
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) then
            table.insert(peds, ped)
            print("Ped: "..ped)
            print(GetCurrentPedWeapon(ped))
            print("Networkid: "..NetworkGetEntityOwner(ped))
        end
    end
    return peds
end

function GetAllVehicles()
    local vehicles = {}
    for vehicle in EnumerateVehicles() do
        if DoesEntityExist(vehicle) then
            table.insert(vehicles, vehicle)
        end
    end
    return vehicles
end

local j = nil

local teams = {
    {name = "allies", model = "s_m_y_swat_01", weapon = "WEAPON_CARBINERIFLE"} --[[ -- bodyguards, 'friendly' ]],
    {name = "enemies", model = "g_m_m_chicold_01", weapon = "WEAPON_ASSAULTRIFLE"}, 
    
}
for i=1, #teams, 1 do 
    AddRelationshipGroup(teams[i].name)
end

RegisterCommand("getped", function(source)
   --ped = GetClosestPed(x, y, z, radius, p4, p5, p7, p8, pedType)
   ped = FindFirstPed()
   print(ped)
end)

RegisterCommand("getnextped", function(source)
    --ped = GetClosestPed(x, y, z, radius, p4, p5, p7, p8, pedType)
    ped = FindNextPed(1)
    print(nextPed)
 end)

RegisterCommand("getpeds", function(source)
    GetAllPeds()
end)

RegisterCommand("getclosest", function(source)
    local player = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(player)
    print(playerCoords['x'])
    print(playerCoords['y'])
    print(playerCoords['z'])
    ped = GetClosestPed(playerCoords['x'], playerCoords['y'], playerCoords['z'], 1000, 1, 0, 1, 1, -1)
    print(ped)
end)

RegisterCommand("war", function(source, args)
    local totalPeople = tonumber(args[1])
    for i=1,totalPeople, 1 do --[[ this loop will create two peds, one being an enemy and the other being an ally ]]
        j = math.random(1,#teams) --[[ this is just a lazy way to alternate between spawning an enemy or ally ]]
        local ped = GetHashKey(teams[j].model)
        -- preload the model
        RequestModel(ped)
        while not HasModelLoaded(ped) do 
            Citizen.Wait(1)
        end
        -- get the source's coords
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
        -- refer to ped types here under "PedTypes" -> https://runtime.fivem.net/doc/natives/#_0xD49F9B0955C367DE
        newPed = CreatePed(4 --[[refer above (4 only works for male peds and 5 is for female peds)]], ped, x+math.random(-totalPeople,totalPeople),y+math.random(-totalPeople,totalPeople) --[[ This random number will space them out more ]],z , 0.0 --[[float (int) Heading]], false, true)
        --- now lets give the ped some attributes -> https://runtime.fivem.net/doc/natives/#_0x9F7794730795E019
        SetPedCombatAttributes(newPed, 0, true) --[[ BF_CanUseCover ]]
        SetPedCombatAttributes(newPed, 5, true) --[[ BF_CanFightArmedPedsWhenNotArmed ]]
        SetPedCombatAttributes(newPed, 46, true) --[[ BF_AlwaysFight ]]
        SetPedFleeAttributes(newPed, 0, true) --[[ allows/disallows the ped to flee from a threat i think]]
        -- [[ find more groups here https://github.com/jorjic/fivem-docs/wiki/Ped-Types-&-Relationships#default-relationship-groups ]]
        SetPedRelationshipGroupHash(newPed, GetHashKey(teams[j].name)) --[[ when i did army, the peds fought eachother and it was pretty funny - https://runtime.fivem.net/doc/natives/#_0xC80A74AC829DDD92 ]]
        SetRelationshipBetweenGroups(5, GetHashKey(teams[1].name), GetHashKey(teams[2].name)) --[[ 
            More types (int) here https://github.com/jorjic/fivem-docs/wiki/Ped-Types-&-Relationships#relationship-types 
            Above, this will make enemies and allies hate eachother
        ]]
        if teams[j].name == "allies" then
            SetRelationshipBetweenGroups(0, GetHashKey(teams[j].name), GetHashKey("PLAYER"))
            SetPedAccuracy(newPed, 100) --[[ Allies will have 100 percent accuracy ]]
        else 
            SetRelationshipBetweenGroups(5, GetHashKey(teams[j].name), GetHashKey("PLAYER")) --[[ this is really janky sorry  ]]
        end
        TaskStartScenarioInPlace(newPed, "WORLD_HUMAN_SMOKING", 0, true)
        GiveWeaponToPed(newPed, GetHashKey(teams[j].weapon), 2000, true--[[ weapon is hidden or not (bool)]], false) --[[ https://runtime.fivem.net/doc/natives/#_0xBF0FD6E56C964FCB]]
        SetPedArmour(newPed, 100)
        SetPedMaxHealth(newPed, 100)
    end
end)

AddEventHandler('entityCreated', function ()
    print('entityCreated')
  end)
  

function DrawText3D(x, y, z, text)
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