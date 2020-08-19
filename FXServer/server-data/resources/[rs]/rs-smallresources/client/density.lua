Citizen.CreateThread(function()
	while true do
		SetVehicleDensityMultiplierThisFrame(0.05)
	    SetPedDensityMultiplierThisFrame(1.0)
	    SetParkedVehicleDensityMultiplierThisFrame(1.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

		Citizen.Wait(3)
	end
end)

-- DensityMultiplier = 0.45
-- Citizen.CreateThread(function()
-- 	while true do
-- 	Citizen.Wait(0)
-- 	SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
-- 	SetPedDensityMultiplierThisFrame(DensityMultiplier)
-- 	SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
-- 	SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
-- 	SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
-- 	end
-- end)