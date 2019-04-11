
local density = {
	peds = 0.40,--0.3,
	vehicles = 0.10--0.1
}

Citizen.CreateThread(function()
    while true do
		-- These natives has to be called every frame.
		SetPedDensityMultiplierThisFrame(density.peds)
		SetScenarioPedDensityMultiplierThisFrame(density.peds, density.peds)
		SetVehicleDensityMultiplierThisFrame(density.vehicles)
		SetRandomVehicleDensityMultiplierThisFrame(density.vehicles)
		SetParkedVehicleDensityMultiplierThisFrame(density.vehicles)

		SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
		SetRandomBoats(false) -- Stop random boats from spawning in the water.
		SetCreateRandomCops(false) -- disable random cops walking/driving around.
		SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
		SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
		SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)

        --local pos = GetEntityCoords(PlayerPedId())
        --RemoveVehiclesFromGeneratorsInArea(pos.x-2000.0,pos.y-2000.0,pos.z-2000.0,pos.x+2000.0,pos.y+2000.0,pos.z+2000.0); -- Remove veículos estacionados.

		Citizen.Wait(0)
    end
end)