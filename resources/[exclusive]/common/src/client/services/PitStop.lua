-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local timeSeconds = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICES
-----------------------------------------------------------------------------------------------------------------------------------------
local coordVehicle = {
	{ -828.06,-1264.12,5.0 },
	{ -745.3,-1468.23,5.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyPoliceVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(coordVehicle) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 30 then
					timeDistance = 1
					DrawMarker(23,v[1],v[2],v[3] - 0.95,0.0,0.0,0.0,0.0,0.0,0.0,10.0,10.0,0.0,42,137,255,100,0,0,0,0)

					if IsControlJustPressed(1,38) and timeSeconds <= 0 and distance <= 5 then
						timeSeconds = 2
						server.vehicleRepair()
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMESECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if timeSeconds > 0 then
			timeSeconds = timeSeconds - 1
		end

		Citizen.Wait(1000)
	end
end)