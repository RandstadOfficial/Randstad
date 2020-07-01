local isInRagdoll = false

Citizen.CreateThread(function()
 while true do
    Citizen.Wait(10)
    if isInRagdoll then
      SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
    end
  end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
    if IsControlJustPressed(2, Config.RagdollKeybind) and Config.RagdollEnabled and IsPedOnFoot(PlayerPedId()) then
        if isInRagdoll then
            isInRagdoll = false
        else
            isInRagdoll = true
            Wait(500)
        end
    end
  end
end)

--
local maxJumps = 3
local counter = 0
local msPassed = 0
local timestampFirstJump = 0
local timestampMaxJump
local thresholdMsPerJump = 1400
--Takes roughly 2400 ms to do 3 jumps.

Citizen.CreateThread(function()
  while true do
    local ped = GetPlayerPed(-1)
    Citizen.Wait(600)
    msPassed = msPassed + 600

    if IsPedJumping(ped) and not IsPedSwimming(ped) then
      counter = counter + 1
    end
    if counter == 1 then
      timestampFirstJump = msPassed
    end
    if counter == maxJumps then
      timestampMaxJump = msPassed
    end
    if counter == maxJumps and (timestampMaxJump - timestampFirstJump) < (maxJumps * thresholdMsPerJump) then
      ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
      SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0) 
    elseif counter >= maxJumps then
      counter = 0
      msPassed = 0
    end
  end
end)
