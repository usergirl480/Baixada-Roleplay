-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("dismantle",cRP)
vGARAGE = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local timeList = 1
local modelListVehicles = {}
local dismantleControl = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkListVeh(vehPlate,vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and exports["common"]:Group().hasPermission(user_id,"dismantle") then
		local plateUser = vRP.userPlate(vehPlate)
		if plateUser == user_id then 
			TriggerClientEvent("Notify",source,"importante","Veículo é protegido pela seguradora.",5000)
			return false
		end
		if exports["garages"]:vehSignal(vehPlate) then
			local inVehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(plateUser), vehicle = vehName })
			if inVehicle[1] then
				if inVehicle[1]["time"] <= 0 then
					dismantleControl[user_id] = { veh = vehName, user = plateUser }
					return true
				else
					TriggerClientEvent("Notify",source,"importante","Veículo é protegido pela seguradora.",5000)
				end
			end
		else
			local coords = GetEntityCoords(GetPlayerPed(source))
			local policeResult = exports["common"]:Group().getAllByPermission("police")
			for k,v in pairs(policeResult) do
				async(function()
					TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Desmanche de Veículo", x = coords["x"], y = coords["y"], z = coords["z"], vehicle = vehicleName(vehName), time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
				end)
			end
			TriggerClientEvent("Notify",source,"importante","Você não desativou o <b>Rastreador</b> e a Polícia foi acionada.",15000)
			return false
		end
	else
		TriggerClientEvent("Notify",source,"negado","Você não tem permissão.",5000)
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod(vehicle)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not dismantleControl[user_id] then 
			vRP.kick(user_id,"Seu acesso a comunidade foi revogado permanentemente por suspeita de trapaça.")
			exports["common"]:Ban().intelligence(user_id,10,0)
			return false
		end
		local value = parseInt(vehiclePrice(dismantleControl[user_id].veh) * 0.3)
		vRP.upgradeStress(user_id,10)
		vGARAGE.deleteVehicle(source,vehicle)
		TriggerClientEvent("player:applyGsr",source)
		vRP.generateItem(user_id,"dollarsz",value,true)
		vRP.execute("vehicles/arrestVehicles",{ user_id = dismantleControl[user_id].user, vehicle = dismantleControl[user_id].veh, arrest = 0, time = parseInt(os.time()) })
		dismantleControl[user_id] = nil
	end
end
