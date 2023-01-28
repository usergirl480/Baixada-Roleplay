-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("dealership",cRP)
vCLIENT = Tunnel.getInterface("dealership")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKS
-----------------------------------------------------------------------------------------------------------------------------------------
local locks = {}

function Lock(key, ms)
	while locks[key] and locks[key] > GetGameTimer() do Wait(100) end
	locks[key] = GetGameTimer() + ms
	return function()
	locks[key] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local typeCars = {}
local typeBikes = {}
local typeWorks = {}
local typeRental = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkShares()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"negado","Multas pendentes encontradas.",10000,"bottom")
			return false
		end

		if exports["wanted"]:checkWanted(user_id) then
			return true
		end

		if vRP.reposeReturn(user_id) then
			return false
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNCFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local vehicles = vehicleGlobal()
	for k,v in pairs(vehicles) do
		if v[4] == "cars" then
			table.insert(typeCars,{ k = k, name = v[1], price = v[3], chest = parseInt(v[2]), tax = parseInt(v[3] * 0.025) })
		elseif v[4] == "bikes" then
			table.insert(typeBikes,{ k = k, name = v[1], price = v[3], chest = parseInt(v[2]), tax = parseInt(v[3] * 0.025) })
		elseif v[4] == "work" then
			table.insert(typeWorks,{ k = k, name = v[1], price = v[3], chest = parseInt(v[2]), tax = parseInt(v[3] * 0.025) })
		elseif v[4] == "rental" then
			table.insert(typeRental,{ k = k, name = v[1], price = v[5], chest = parseInt(v[2]), tax = parseInt(v[3] * 0.025) })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPOSSUIDOS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPossuidos()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehList = {}
		local vehicles = vRP.query("vehicles/getVehicles",{ user_id = parseInt(user_id) })
		for k,v in pairs(vehicles) do
			local vehicleTax = "Atrasado"
			if os.time() < parseInt(v["tax"] + 24 * 7 * 60 * 60) then
				vehicleTax = minimalTimers(parseInt(86400 * 7 - (os.time() - v["tax"])))
			end

			table.insert(vehList,{ k = v["vehicle"], name = vehicleName(v["vehicle"]), price = parseInt(vehiclePrice(v["vehicle"]) * 0.7), chest = vehicleChest(v["vehicle"]), tax = vehicleTax })
		end

		return vehList
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTAX
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestTax(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
		if vehicle[1] then
			if os.time() >= parseInt(vehicle[1]["tax"] + 24 * 7 * 60 * 60) then
				local vehiclePrice = parseInt(vehiclePrice(vehName) * 0.025)

				if vRP.paymentFull(user_id,vehiclePrice) then
					vRP.execute("vehicles/updateVehiclesTax",{ user_id = parseInt(user_id), vehicle = vehName, tax = os.time() })
					TriggerClientEvent("dealership:Update",source,"requestPossuidos")
				else
					TriggerClientEvent("Notify",source,"default","Dólares insuficientes.",10000,"normal","atenção")
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTRENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestRental(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"default","Multas pendentes encontradas.",10000,"normal","atenção")
				actived[user_id] = nil
				return
			end

			local vehPrice = vehicleCryptos(vehName)
			if vRP.request(source,"Comprar o veículo <b>"..vehicleName(vehName).."</b> pagando <b>"..parseFormat(vehPrice).." Cryptos</b>?",30) then
				if exports["store"]:Crypto().remove(user_id,vehPrice) then
					local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
					if vehicle[1] then
						if parseInt(os.time()) >= (vehicle[1]["rental"] + 24 * vehicle[1]["rendays"] * 60 * 60) then
							vRP.execute("vehicles/rentalVehiclesUpdate",{ user_id = parseInt(user_id), vehicle = vehName, days = 30, rental = parseInt(os.time()) })
							TriggerClientEvent("Notify",source,"default","Aluguel do veículo <b>"..vehicleName(vehName).."</b> atualizado.",10000,"normal","atenção")
						else
							vRP.execute("vehicles/rentalVehiclesDays",{ user_id = parseInt(user_id), vehicle = vehName, days = 30 })
							TriggerClientEvent("Notify",source,"default","Adicionado <b>30 Dias</b> de aluguel no veículo <b>"..vehicleName(vehName).."</b>.",10000,"normal","atenção")
						end
					else
						vRP.execute("vehicles/rentalVehicles",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlate(), work = tostring(false), rental = parseInt(os.time()), rendays = 30 })
						TriggerClientEvent("Notify",source,"default","Aluguel do veículo <b>"..vehicleName(vehName).."</b> concluído.",10000,"normal","atenção")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Cryptos insuficientes.",10000,"normal","atenção")
				end
			end

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTALMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.rentalMoney(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"negado","Multas pendentes encontradas.",10000,"bottom")
				actived[user_id] = nil
				return
			end

			local vehicle = exports.oxmysql:query_async("SELECT vehicle FROM characters_vehicles WHERE user_id = ? AND vehicle = ?",{ user_id,vehName })
			if not vehicle[1] then 
				local more_vehicles = exports.oxmysql:single_async("SELECT vehicles FROM accounts WHERE steam = @steam",{ steam = vRP.getSteam(user_id) })
				if more_vehicles and more_vehicles.vehicles > 0 then 
					if vRP.request(source,"Comprar o veículo <b>"..vehicleName(vehName).."</b> utilizando seu benefício VIP?",30) then
						local maxVehs = vRP.query("vehicles/countVehicles",{ user_id = parseInt(user_id), work = "false" })
						local myGarages = vRP.getInformation(user_id)
						local amountVehs = myGarages[1]["garage"]

						if exports["store"]:Appointments().isVipById(user_id) then
							amountVehs = amountVehs + 2
						end

						if parseInt(maxVehs[1]["qtd"]) >= parseInt(amountVehs) then
							TriggerClientEvent("Notify",source,"importante","Atingiu o máximo de veículos.",10000)
							actived[user_id] = nil
							return
						end

						exports["oxmysql"]:query("UPDATE accounts SET vehicles = vehicles - 1 WHERE steam = @steam",{ steam = vRP.getSteam(user_id) })
						vRP.execute("vehicles/addVehicles",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlate(), work = tostring(false) })
						TriggerClientEvent("Notify",source,"default","Compra concluída.",10000,"normal","atenção")
					end
				else
					TriggerClientEvent("Notify",source,"default","Você não possuí benefício VIP.",10000,"normal","atenção")
				end
			else
				TriggerClientEvent("Notify",source,"default","Você já possuí esse veículo.",10000,"normal","atenção")
			end

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestBuy(vehName)
	local source = source
	local free = Lock(source,5000)
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"importante","Multas pendentes encontradas.",10000)
				actived[user_id] = nil
				return
			end

			local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
			if vehicle[1] then
				TriggerClientEvent("Notify",source,"importante","Já possui um <b>"..vehicleName(vehName).."</b>.",10000)
				actived[user_id] = nil
				return
			end

			if vehicleType(vehName) == "work" then
				if vRP.paymentFull(user_id,vehiclePrice(vehName)) then
					vRP.execute("vehicles/addVehicles",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlate(), work = tostring(true) })
					TriggerClientEvent("Notify",source,"default","Compra concluída.",10000,"normal","atenção")
				else
					TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",10000,"normal","atenção")
				end
			else
				local vehPrice = vehiclePrice(vehName)
				local more_vehicles = exports.oxmysql:single_async("SELECT vehicles FROM accounts WHERE steam = @steam",{ steam = vRP.getSteam(user_id) })
				local requestStatus = more_vehicles.vehicles > 0 and parseInt(vehPrice) < 300000 or false 
				local requestMessage = requestStatus and "Deseja adquirir o veículo <b>"..vehicleName(vehName).."</b> utilizando seu benefício?" or "Comprar o veículo <b>"..vehicleName(vehName).."</b> pagando <b>$"..parseFormat(vehPrice).."</b>?"

				if vRP.request(source,requestMessage,30) then
					local maxVehs = vRP.query("vehicles/countVehicles",{ user_id = parseInt(user_id), work = "false" })
					local myGarages = vRP.getInformation(user_id)
					local amountVehs = myGarages[1]["garage"]

					if exports["store"]:Appointments().isVipById(user_id) then
						amountVehs = amountVehs + 2
					end

					if parseInt(maxVehs[1]["qtd"]) >= parseInt(amountVehs) then
						TriggerClientEvent("Notify",source,"importante","Atingiu o máximo de veículos.",3000)
						actived[user_id] = nil
						return
					end

					if requestStatus then 
						exports["oxmysql"]:query("UPDATE accounts SET vehicles = vehicles - 1 WHERE steam = @steam",{ steam = vRP.getSteam(user_id) })
						vRP.execute("vehicles/addVehicles",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlate(), work = tostring(false) })
						TriggerClientEvent("Notify",source,"default","Compra concluída.",10000,"normal","atenção")
					else
						if vRP.paymentFull(user_id,vehPrice) then
							vRP.execute("vehicles/addVehicles",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlate(), work = tostring(false) })
							TriggerClientEvent("Notify",source,"default","Compra concluída.",10000,"normal","atenção")
						else
							TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",10000,"normal","atenção")
						end
					end
				end
			end

			actived[user_id] = nil
		end
	end
	free()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSELL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestSell(vehName)
	local source = source
	local free = Lock(source,5000)
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehType = vehicleType(vehName)
		if vehType == "work" then
			return false
		end

		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"negado","Multas pendentes encontradas.",10000,"bottom")
				actived[user_id] = nil
				return false
			end

			local vehPrices = vehiclePrice(vehName) * 0.7
			local sellText = "Vender o veículo <b>"..vehicleName(vehName).."</b> por <b>$"..parseFormat(vehPrices).."</b>?"

			if vehType == "rental" then
				sellText = "Remover o veículo de sua lista de possuídos?"
			end

			if vRP.request(source,sellText,30) then
				local vehicles = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
				if vehicles[1] then
					vRP.remSrvdata("custom:"..user_id..":"..vehName)
					vRP.remSrvdata("vehChest:"..user_id..":"..vehName)
					vRP.remSrvdata("vehGloves:"..user_id..":"..vehName)
					vRP.execute("vehicles/removeVehicles",{ user_id = parseInt(user_id), vehicle = vehName })
					TriggerClientEvent("dealership:Update",source,"requestPossuidos")

					if vehType ~= "rental" then
						vRP.addBank(user_id,vehPrices)
						TriggerClientEvent("itensNotify",source,{ "recebeu","dollars",parseFormat(vehPrices),"Dólares" })
					end
				end
			end

			actived[user_id] = nil
		end
	end
	free()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
local plateVehs = {}
local numberName = 1000
function cRP.startDrive()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if not exports["wanted"]:checkWanted(user_id) then
				local request = vRP.request(source,"Deseja iniciar o teste pagando <b>$50</b>?",60)
				if request then
					if vRP.paymentFull(user_id,50) then
						numberName = numberName + 1
						plateVehs[user_id] = "PDMS"..numberName

						SetPlayerRoutingBucket(source,parseInt(user_id))
						Player(source).state.session = parseInt(user_id)
						TriggerEvent("plateEveryone",plateVehs[user_id])
						actived[user_id] = nil

						return true,plateVehs[user_id]
					else
						TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",10000,"normal","atenção")
					end
				end
			end

			actived[user_id] = nil
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeDrive()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.userIdentity(user_id)
		if identity then
			TriggerEvent("plateReveryone",plateVehs[user_id])
			SetPlayerRoutingBucket(source,0)
			Player(source).state.session = 0
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	vCLIENT.updateVehicles(source,typeCars,typeBikes,typeWorks,typeRental)
end)

-- Citizen.CreateThread(function()
-- 	Citizen.Wait(1000)
-- 	vCLIENT.updateVehicles(-1,typeCars,typeBikes,typeWorks,typeRental)
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if actived[user_id] then
		actived[user_id] = nil
	end

	if plateVehs[user_id] then
		plateVehs[user_id] = nil
	end
end)