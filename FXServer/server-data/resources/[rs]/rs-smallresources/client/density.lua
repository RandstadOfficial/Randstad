Citizen.CreateThread(function()
	while true do
		SetVehicleDensityMultiplierThisFrame(0.45)
	    SetPedDensityMultiplierThisFrame(1.0)
	    SetParkedVehicleDensityMultiplierThisFrame(1.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
		
		Citizen.Wait(3)
	end
end)

-- -- Density values from 0.0 to 1.0.
-- DensityMultiplier = 0.5
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
-- 		SetPedDensityMultiplierThisFrame(DensityMultiplier)
-- 		SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
-- 		SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
-- 		SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
-- 	end
-- end)