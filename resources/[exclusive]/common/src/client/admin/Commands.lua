RegisterNetEvent("admin:setInVehicle")
AddEventHandler("admin:setInVehicle",function(targetSource)
	local targerPlayer = GetPlayerFromServerId(targetSource)
	local targetPed = GetPlayerPed(targerPlayer)
	local vehicle = GetVehiclePedIsUsing(targetPed)
	local ped = PlayerPedId()
	if vehicle then
		SetPedIntoVehicle(ped,vehicle,-2)
	end
end)

RegisterNetEvent("admin:setInVehiclePlayer")
AddEventHandler("admin:setInVehiclePlayer",function()
	local ped = PlayerPedId()
	local vehicle = vRP.nearVehicle(15)
	if IsVehicleSeatFree(vehicle,-1) then
		SetPedIntoVehicle(ped,vehicle,-1)
	else
		SetPedIntoVehicle(ped,vehicle, -2)
	end
end)