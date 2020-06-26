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

-- Ragdoll when sprint jumping.
local ragdoll_chance = 0.5 -- edit this decimal value for chance of falling (e.g. 80% = 0.8    75% = 0.75    32% = 0.32)

-- code, not recommended to edit below this point
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100) -- check every 100 ticks, performance matters
		local ped = PlayerPedId()
		if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
			local chance_result = math.random()
			if chance_result < ragdoll_chance then 
				Citizen.Wait(600) -- roughly when the ped loses grip
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
				SetPedToRagdoll(ped, 5000, 1, 2)
			else
				Citizen.Wait(2000) -- cooldown before continuing
			end
		end
	end
end)

