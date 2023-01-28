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
Tunnel.bindInterface("garages",cRP)
vPLAYER = Tunnel.getInterface("player")
vCLIENT = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehList = {}
local vehPlates = {}
local spawnTimers = {}
local vehHardness = {}
local searchTimers = {}
local vehSignal = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGELOCATES
-----------------------------------------------------------------------------------------------------------------------------------------
local garageLocates = {
	-- Garages
	["1"] = { name = "Garage", payment = true },
	["2"] = { name = "Garage", payment = true },
	["3"] = { name = "Garage", payment = true },
	["4"] = { name = "Garage", payment = true },
	["5"] = { name = "Garage", payment = true },
	["6"] = { name = "Garage", payment = true },
	["7"] = { name = "Garage", payment = true },
	["8"] = { name = "Garage", payment = true },
	["9"] = { name = "Garage", payment = false },
	["10"] = { name = "Garage", payment = true },
	["11"] = { name = "Garage", payment = true },
	["12"] = { name = "Garage", payment = true },
	["13"] = { name = "Garage", payment = true },
	["14"] = { name = "Garage", payment = true },
	["15"] = { name = "Garage", payment = true },
	["16"] = { name = "Garage", payment = true },
	["17"] = { name = "Garage", payment = true },
	["18"] = { name = "Garage", payment = true },
	["19"] = { name = "Garage", payment = true },
	["20"] = { name = "Garage", payment = true },

	-- Paramedic
	["41"] = { name = "Paramedic", payment = false, perm = "paramedic" },
	["42"] = { name = "heliParamedic", payment = false, perm = "paramedic" },

	-- ["43"] = { name = "Paramedic", payment = false, perm = "paramedic" },
	-- ["44"] = { name = "heliParamedic", payment = false, perm = "paramedic" },

	["45"] = { name = "Paramedic", payment = false, perm = "paramedic" },
	["46"] = { name = "heliParamedic", payment = false, perm = "paramedic" },

	-- Police
	["61"] = { name = "Police", payment = false, perm = "police" },
	["62"] = { name = "heliPolice", payment = false, perm = "police" },

	["63"] = { name = "Police", payment = false, perm = "police" },
	["64"] = { name = "heliPolice", payment = false, perm = "police" },

	["65"] = { name = "Police", payment = false, perm = "police" },
	["66"] = { name = "busPolice", payment = false, perm = "police" },

	["67"] = { name = "Police", payment = false, perm = "police" },
	["68"] = { name = "heliPolice", payment = false, perm = "police" },

	["69"] = { name = "Police", payment = false, perm = "police" },
	["70"] = { name = "heliPolice", payment = false, perm = "police" },

	-- Bikes
	["101"] = { name = "Bikes", payment = true },
	["102"] = { name = "Bikes", payment = true },
	["103"] = { name = "Bikes", payment = true },
	["104"] = { name = "Bikes", payment = true },
	["105"] = { name = "Bikes", payment = true },
	["106"] = { name = "Garage", payment = true },
	["107"] = { name = "Bikes", payment = true },
	["108"] = { name = "Bikes", payment = true },
	["109"] = { name = "Bikes", payment = true },
	["110"] = { name = "Bikes", payment = true },
	["111"] = { name = "Bikes", payment = true },

	-- Boats
	["121"] = { name = "Boats", payment = true },
	["122"] = { name = "Boats", payment = true },
	["123"] = { name = "Boats", payment = true },
	["124"] = { name = "Boats", payment = true },

	-- Works
	["141"] = { name = "Lumberman", payment = true },
	["142"] = { name = "Driver", payment = true },
	["143"] = { name = "Garbageman", payment = true },
	["144"] = { name = "Transporter", payment = true },
	["145"] = { name = "Taxi", payment = true },
	["146"] = { name = "TowDriver", payment = true },
	["147"] = { name = "TowDriver", payment = true },
	["148"] = { name = "TowDriver", payment = true },
	["149"] = { name = "Fisherman", payment = true },
	["150"] = { name = "Trucker", payment = true },
	["151"] = { name = "Kart", payment = true },
	["152"] = { name = "Bullguer", payment = true },
	["153"] = { name = "AirForce", payment = true, perm = "airforce" },
	
	-- Garages
	["154"] = { name = "Garage", payment = true },
	["155"] = { name = "Garage", payment = true },
	["156"] = { name = "Garage", payment = true },
	["157"] = { name = "Garage", payment = true },
	["158"] = { name = "Garage", payment = true },
	["159"] = { name = "Garage", payment = true },
	["160"] = { name = "Garage", payment = true },
	["161"] = { name = "Garage", payment = true },
	["162"] = { name = "Garage", payment = true },
	["163"] = { name = "Garage", payment = true },
	["164"] = { name = "Garage", payment = true },
	["165"] = { name = "Garage", payment = false },
	
	-- Works
	-- ["166"] = { name = "Electrician", payment = true },

	-- Garages
	["167"] = { name = "Garage", payment = false },

	["168"] = { name = "TowDriver", payment = false },

	["169"] = { name = "heliParamedic", payment = false, perm = "paramedic" },

	["170"] = { name = "Garage", payment = true },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEREVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateReveryone")
AddEventHandler("plateReveryone",function(vehPlate)
	if vehPlates[vehPlate] then
		vehPlates[vehPlate] = nil
		TriggerClientEvent("garages:syncRemlates",-1,vehPlate)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEEVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateEveryone")
AddEventHandler("plateEveryone",function(vehPlate)
	if vehPlates[vehPlate] == nil then
		vehPlates[vehPlate] = true

		TriggerClientEvent("garages:syncPlates",-1,vehPlate)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEHARDNESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateHardness")
AddEventHandler("plateHardness",function(vehPlate,vehStatus)
	vehHardness[vehPlate] = parseInt(vehStatus)
	TriggerClientEvent("hud:plateHardness",-1,vehPlate,vehStatus)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("platePlayers")
AddEventHandler("platePlayers",function(vehPlate,user_id)
	local plateId = vRP.userPlate(vehPlate)
	if not plateId then
		vehPlates[vehPlate] = user_id
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNALREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("signalRemove")
AddEventHandler("signalRemove",function(vehPlate)
	vehSignal[vehPlate] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateRobberys")
AddEventHandler("plateRobberys",function(vehPlate,vehName)
	if vehPlate ~= nil and vehName ~= nil then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if vehPlates[vehPlate] ~= user_id then
				vehPlates[vehPlate] = user_id
				TriggerClientEvent("garages:syncPlates",-1,vehPlate)
			end

			TriggerClientEvent("Notify",source,"sucesso","Chave recebida.",3000)

			if math.random(100) >= 50 then
				local ped = GetPlayerPed(source)
				local coords = GetEntityCoords(ped)

				local policeResult = exports["common"]:Group().getAllByPermission("police")
				for k,v in pairs(policeResult) do
					async(function()
						TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Roubo de Veículo", x = coords["x"], y = coords["y"], z = coords["z"], vehicle = vehicleName(vehName).." - "..vehPlate, time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
local workgarage = {
	["Paramedic"] = {
		"lguard",
		"blazer2",
		"ambulancia"
	},
	["heliParamedic"] = {
		"maverick2"
	},
	["Police"] = {
		"BXDa45",
		"BXDcla",
		"BXDx6",
		"BXDx7",
		"BXDclassx",
		"BXDgle",
		"BXDsxr",
		"BXDr8",
		"BXDgt63"
	
	},
	["heliPolice"] = {
		"bmheli",
		"B412",
		"CESTA"
	},
	["busPolice"] = {
		"pbus",
		"riot"
	},
	["Driver"] = {
		"bus"
	},
	["Electrician"] = {
		"boxville"
	},
	["Boats"] = {
		"dinghy",
		"jetmax",
		"marquis",
		"seashark",
		"speeder",
		"squalo",
		"suntrap",
		"toro",
		"tropic"
	},
	["Transporter"] = {
		"stockade"
	},
	["Lumberman"] = {
		"ratloader"
	},
	["Fisherman"] = {
		"mule3"
	},
	["Trucker"] = {
		"packer"
	},
	["Kart"] = {
		"veto",
		"veto2"
	},
	["TowDriver"] = {
		"flatbed",
		"towtruck2"
	},
	["AirForce"] = {
		"volatus",
		"supervolito",
		"cuban800",
		"luxor",
		"mammatus",
		"miljet",
		"nimbus",
		"shamal",
		"velum",
		"buzzard2",
		"frogger",
		"havok",
		"swift",
		"swift2",
		"dodo"
	},
	["Garbageman"] = {
		"trash",
		"biff"
	},
	["Taxi"] = {
		"taxi"
	},
	["Bikes"] = {
		"bmx",
		"cruiser",
		"fixter",
		"scorcher",
		"tribike",
		"tribike2",
		"tribike3"
	},
	["Bullguer"] = {
		"faggio"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.myVehicles(garageWork)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myVehicle = {}
		local garageName = garageLocates[garageWork]["name"]
		local vehicle = vRP.query("vehicles/getVehicles",{ user_id = parseInt(user_id) })

		if workgarage[garageName] then
			for k,v in pairs(workgarage[garageName]) do
				local veh = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = v })
				if veh[1] then
					table.insert(myVehicle,{ name = veh[1]["vehicle"], name2 = vehicleName(veh[1]["vehicle"]), engine = parseInt(veh[1]["engine"] * 0.1), body = parseInt(veh[1]["body"] * 0.1), fuel = parseInt(veh[1]["fuel"]) })
				else
					vRP.execute("vehicles/addVehicles",{ user_id = parseInt(user_id), vehicle = v, plate = vRP.generatePlate(), work = tostring(true) })
					local veh = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = v })
					if veh[1] then
						table.insert(myVehicle,{ name = veh[1]["vehicle"], name2 = vehicleName(veh[1]["vehicle"]), engine = parseInt(veh[1]["engine"] * 0.1), body = parseInt(veh[1]["body"] * 0.1), fuel = parseInt(veh[1]["fuel"]) })
					end
				end
			end
		else
			for k,v in ipairs(vehicle) do
				if v["work"] == "false" then
					table.insert(myVehicle,{ name = vehicle[k]["vehicle"], name2 = vehicleName(vehicle[k]["vehicle"]), engine = parseInt(vehicle[k]["engine"] * 0.1), body = parseInt(vehicle[k]["body"] * 0.1), fuel = parseInt(vehicle[k]["fuel"]) })
				end
			end
		end

		return myVehicle
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION NITRO
-----------------------------------------------------------------------------------------------------------------------------------------
local function addNitro(plate,nitroFuel)
	local Nitro = GlobalState["Nitro"]
	Nitro[plate] = nitroFuel or 0
	GlobalState["Nitro"] = Nitro
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD NITRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addnitro",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local vehicle,vehNet,vehPlate = vRPC.vehList(source,4)
	if exports["common"]:Group().hasPermission(user_id,"staff") then
		if vehicle then
			addNitro(vehPlate,100)
			TriggerClientEvent("Notify",source,"sucesso","Nitro adicionado.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD FUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addfuel",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local vehicle,vehNet,vehPlate = vRPC.vehList(source,4)
	if exports["common"]:Group().hasPermission(user_id,"staff") then
		if not vRPC.inVehicle(source) then
			if vehicle then
				TriggerClientEvent("garages:addFuel",source, vehPlate, tonumber(args[1]))
				TriggerClientEvent("Notify",source,"sucesso","Gasolina adicionada.")
			end
		else
			TriggerClientEvent("Notify",source,"negado","Ação bloqueada.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.spawnVehicles(vehName,garageName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if spawnTimers[user_id] == nil then
			spawnTimers[user_id] = true

			local vehNet = nil
			for k,v in pairs(vehList) do
				if parseInt(v[1]) == parseInt(user_id) and v[2] == vehName then
					vehNet = parseInt(k)
					break
				end
			end

			local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = vehName })

			if vehNet == nil then
				local vehPrice = vehiclePrice(vehName)

				if os.time() >= parseInt(vehicle[1]["tax"] + 24 * 7 * 60 * 60) then
					local taxPrice = parseInt(vehiclePrice(vehName) * 0.025)
					-- TriggerClientEvent("Notify",source,"default","A taxa do veículo está atrasada, efetue o pagamento através do seu tablet no sistema da motorsport.",20000,"bottom","atenção")
					local status = vRP.request(source,"A taxa do veículo está atrasada, deseja quitar pagando <b>$"..parseFormat(taxPrice).."</b> dólares?",60)
					if status then
						if vRP.paymentFull(user_id,taxPrice) then
							vRP.execute("vehicles/updateVehiclesTax",{ user_id = parseInt(user_id), vehicle = vehName, tax = os.time() })

							local mHash = GetHashKey(vehName)
							local checkSpawn,vehCoords = vCLIENT.spawnPosition(source)
							if checkSpawn then
		
								local vehMods = nil
								local custom = vRP.query("entitydata/getData",{ dkey = "custom:"..user_id..":"..vehName })
								if parseInt(#custom) > 0 then
									vehMods = custom[1]["dvalue"]
								end
		
								local vehObject = CreateVehicle(mHash,vehCoords[1],vehCoords[2],vehCoords[3],vehCoords[4],true,true)
		
								while not DoesEntityExist(vehObject) do
									Citizen.Wait(1)
								end

								local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
								vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["plate"],vehicle[1]["engine"],vehicle[1]["body"],vehicle[1]["fuel"],vehMods,vehicle[1]["windows"],vehicle[1]["doors"],vehicle[1]["tyres"],vehicle[1]["brakes"])
								TriggerEvent("engine:insertEngines",netVeh,vehicle[1]["fuel"],vehicle[1]["brakes"])
								TriggerEvent("plateHardness",vehicle[1]["plate"],vehicle[1]["hardness"])
								vehList[netVeh] = { user_id,vehName,vehicle[1]["plate"] }
								TriggerEvent("plateEveryone",vehicle[1]["plate"])
								vehPlates[vehicle[1]["plate"]] = user_id
								addNitro(vehicle[1]["plate"],vehicle[1]["nitro"])
							end
						else
							TriggerClientEvent("Notify",source,"default","Dólares insuficientes.",10000,"normal","atenção")
						end
					end

				elseif parseInt(os.time()) <= parseInt(vehicle[1]["time"] + 24 * 60 * 60) then
					local status = vRP.request(source,"Veículo detido, deseja acionar o seguro pagando <b>$"..parseFormat(vehPrice * 0.5).."</b> dólares?",60)
					if status then
						if vRP.paymentFull(user_id,vehPrice * 0.5) then
							vRP.execute("vehicles/arrestVehicles",{ user_id = parseInt(user_id), vehicle = vehName, arrest = 0, time = 0 })
						else
							TriggerClientEvent("Notify",source,"default","Dólares insuficientes.",20000,"bottom","atenção")
						end
					end
				elseif parseInt(vehicle[1]["arrest"]) >= 1 then
					local status = vRP.request(source,"Veículo detido, deseja acionar o seguro pagando <b>$"..parseFormat(vehPrice * 0.1).."</b> dólares?",60)
					if status then
						if vRP.paymentFull(user_id,vehPrice * 0.1) then
							vRP.execute("vehicles/arrestVehicles",{ user_id = parseInt(user_id), vehicle = vehName, arrest = 0, time = 0 })
						else
							TriggerClientEvent("Notify",source,"default","Dólares insuficientes.",20000,"bottom","atenção")
						end
					end
				else
					-- if parseInt(vehicle[1]["rental"]) > 0 then
					-- 	if parseInt(os.time()) >= (vehicle[1]["rental"] + 24 * vehicle[1]["rendays"] * 60 * 60) then
					-- 		TriggerClientEvent("Notify",source,"default","Validade do veículo expirou, efetue a renovação do mesmo.",20000,"bottom","atenção")
					-- 		spawnTimers[user_id] = nil

					-- 		return
					-- 	end
					-- end

					local mHash = GetHashKey(vehName)
					local checkSpawn,vehCoords = vCLIENT.spawnPosition(source)
					if checkSpawn then

						local vehMods = nil
						local custom = vRP.query("entitydata/getData",{ dkey = "custom:"..user_id..":"..vehName })
						if parseInt(#custom) > 0 then
							vehMods = custom[1]["dvalue"]
						end

						if garageLocates[garageName]["payment"] then
							if exports["store"]:Appointments().isVipById(user_id) then
								local vehObject = CreateVehicle(mHash,vehCoords[1],vehCoords[2],vehCoords[3],vehCoords[4],true,true)

								while not DoesEntityExist(vehObject) do
									Citizen.Wait(1)
								end

								local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
								vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["plate"],vehicle[1]["engine"],vehicle[1]["body"],vehicle[1]["fuel"],vehMods,vehicle[1]["windows"],vehicle[1]["doors"],vehicle[1]["tyres"],vehicle[1]["brakes"])
								TriggerEvent("engine:insertEngines",netVeh,vehicle[1]["fuel"],vehicle[1]["brakes"])
								TriggerEvent("plateHardness",vehicle[1]["plate"],vehicle[1]["hardness"])
								vehList[netVeh] = { user_id,vehName,vehicle[1]["plate"] }
								TriggerEvent("plateEveryone",vehicle[1]["plate"])
								vehPlates[vehicle[1]["plate"]] = user_id
								addNitro(vehicle[1]["plate"],vehicle[1]["nitro"])
							else
								if vRP.request(source,"Deseja retirar o veículo pagando <b>$"..parseFormat(vehPrice * 0.05).."</b> dólares?",30) then
									if vRP.getBank(user_id) >= parseInt(vehPrice * 0.05) then
										local vehObject = CreateVehicle(mHash,vehCoords[1],vehCoords[2],vehCoords[3],vehCoords[4],true,true)

										while not DoesEntityExist(vehObject) do
											Citizen.Wait(1)
										end

										local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
										vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["plate"],vehicle[1]["engine"],vehicle[1]["body"],vehicle[1]["fuel"],vehMods,vehicle[1]["windows"],vehicle[1]["doors"],vehicle[1]["tyres"],vehicle[1]["brakes"])
										TriggerEvent("engine:insertEngines",netVeh,vehicle[1]["fuel"],vehicle[1]["brakes"])
										TriggerEvent("plateHardness",vehicle[1]["plate"],vehicle[1]["hardness"])
										TriggerEvent("plateEveryone",vehicle[1]["plate"])
										vehPlates[vehicle[1]["plate"]] = user_id
										vehList[netVeh] = { user_id,vehName }
										addNitro(vehicle[1]["plate"],vehicle[1]["nitro"])
									else
										TriggerClientEvent("Notify",source,"default","Dólares insuficientes.",20000,"bottom","atenção")
									end
								end
							end
						else
							local vehObject = CreateVehicle(mHash,vehCoords[1],vehCoords[2],vehCoords[3],vehCoords[4],true,true)

							while not DoesEntityExist(vehObject) do
								Citizen.Wait(1)
							end

							local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
							vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["plate"],vehicle[1]["engine"],vehicle[1]["body"],vehicle[1]["fuel"],vehMods,vehicle[1]["windows"],vehicle[1]["doors"],vehicle[1]["tyres"],vehicle[1]["brakes"])
							TriggerEvent("engine:insertEngines",netVeh,vehicle[1]["fuel"],vehicle[1]["brakes"])
							TriggerEvent("plateHardness",vehicle[1]["plate"],vehicle[1]["hardness"])
							vehList[netVeh] = { user_id,vehName,vehicle[1]["plate"] }
							TriggerEvent("plateEveryone",vehicle[1]["plate"])
							vehPlates[vehicle[1]["plate"]] = user_id
							addNitro(vehicle[1]["plate"],vehicle[1]["nitro"])
						end
					end
				end
			else
				if not vehSignal[vehicle[1]["plate"]] then 
					if GetGameTimer() >= searchTimers[user_id] then
						searchTimers[user_id] = GetGameTimer() + 60000

						local idNetwork = NetworkGetEntityFromNetworkId(vehNet)
						if DoesEntityExist(idNetwork) and not IsPedAPlayer(idNetwork) then
							vCLIENT.searchBlip(source,GetEntityCoords(idNetwork))
							TriggerClientEvent("Notify",source,"importante","Rastreador ativado por <b>30 segundos</b>, lembrando que<br>se o mesmo estiver em movimento a localização pode ser imprecisa.",20000,"bottom","atenção")
						else
							if vehList[vehNet] then
								vehList[vehNet] = nil
							end

							if vehPlates[vehicle[1]["plate"]] then
								vehPlates[vehicle[1]["plate"]] = nil
							end

							TriggerClientEvent("Notify",source,"default","A seguradora efetuou o resgate do seu veículo e o mesmo já se encontra disponível para retirada.",20000,"bottom","atenção")
						end
					else
						TriggerClientEvent("Notify",source,"default","O rastreador só pode ser ativado a cada <b>60 segundos</b>.",20000,"bottom","atenção")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Rastreador desativado.",5000)
				end
					
			end

			spawnTimers[user_id] = nil
		else
			TriggerClientEvent("Notify",source,"default","Existe uma busca por seu veículo em andamento.",20000,"bottom","atenção")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") and args[1] then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			local mHash = GetHashKey(args[1])
			local vehObject = CreateVehicle(mHash,coords["x"],coords["y"],coords["z"],heading,true,true)

			while not DoesEntityExist(vehObject) do
				Citizen.Wait(1)
			end

			local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
			local vehPlate = "BXD"..parseInt(math.random(10000,99999) + user_id)
			vCLIENT.createVehicle(-1,mHash,netVeh,vehPlate,1000,1000,100,nil,false,false,false,{ 1.25,0.75,0.95 })
			TriggerEvent("engine:insertEngines",netVeh,100,"")
			vehList[netVeh] = { user_id,vehName,vehPlate }
			TaskWarpPedIntoVehicle(ped,vehObject,-1)
			TriggerEvent("plateHardness",vehPlate,1)
			TriggerEvent("plateEveryone",vehPlate)
			vehPlates[vehPlate] = user_id
			--addNitro(vehPlate,100)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPLACA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("splaca",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasAccessOrHigher(user_id,"admin") and args[1] then
			if vehPlates[args[1]] then 
				TriggerClientEvent("Notify",source,"sucesso","Veículo spawnado por <b>"..vehPlates[args[1]],10000)
			else
				TriggerClientEvent("Notify",source,"negado","Placa não encontrada.",10000,"bottom")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remove",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			TriggerClientEvent("target:toggleAdmin",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dv",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			local vehicle = vRPC.nearVehicle(source,15)
			if vehicle then
				vCLIENT.deleteVehicle(source,vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:lockVehicle")
AddEventHandler("garages:lockVehicle",function(vehNet,vehPlate,vehLock)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vehPlates[vehPlate] == user_id or exports["inventory"]:hasKey(user_id,vehPlate) then
			TriggerClientEvent("garages:vehicleLock",-1,vehNet,vehLock)

			if vehLock then
				TriggerClientEvent("sounds:source",source,"unlock",0.4)
				TriggerClientEvent("Notify",source,"sucesso","Veículo destrancado.",10000,"normal")
			else
				TriggerClientEvent("sounds:source",source,"lock",0.3)
				TriggerClientEvent("Notify",source,"sucesso","Veículo trancado.",10000,"normal")
			end

			if not vRPC.inVehicle(source) then
				vRPC.playAnim(source,true,{"anim@mp_player_intmenu@key_fob@","fob_click"},false)
				Citizen.Wait(400)
				vRPC.stopAnim(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.tryDelete(vehNet,vehEngine,vehBody,vehFuel,vehDoors,vehWindows,vehTyres,vehPlate,vehBrake)
	if vehList[vehNet] and vehNet ~= 0 then
		local user_id = vehList[vehNet][1]
		local vehName = vehList[vehNet][2]

		if parseInt(vehEngine) <= 100 then
			vehEngine = 100
		end

		if parseInt(vehBody) <= 100 then
			vehBody = 100
		end

		if parseInt(vehFuel) >= 100 then
			vehFuel = 100
		end

		if parseInt(vehFuel) <= 5 then
			vehFuel = 5
		end

		local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehName) })
		if vehicle[1] ~= nil then
			vRP.execute("vehicles/updateVehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehName), nitro = GlobalState["Nitro"][vehPlate] or 0, engine = parseInt(vehEngine), body = parseInt(vehBody), fuel = parseInt(vehFuel), doors = json.encode(vehDoors), windows = json.encode(vehWindows), tyres = json.encode(vehTyres), brakes = json.encode(vehBrake) })
		end
	end

	TriggerEvent("garages:deleteVehicle",vehNet,vehPlate)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:deleteVehicle")
AddEventHandler("garages:deleteVehicle",function(vehNet,vehPlate)
	TriggerClientEvent("player:deleteVehicle",-1,vehNet,vehPlate)
	TriggerEvent("plateReveryone",vehPlate)

	if GlobalState["Nitro"][vehPlate] then
		local Nitro = GlobalState["Nitro"]
		Nitro[vehPlate] = nil
		GlobalState["Nitro"] = Nitro
	end

	if vehList[vehNet] then
		vehList[vehNet] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.returnGarages(garageName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if workgarage[garageLocates[garageName]["name"]] == nil then
			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"negado","Multas pendentes encontradas.",3000)
				return false
			end
		end

		if string.sub(garageName,0,5) == "Homes" then
			local consult = vRP.query("propertys/userPermissions",{ name = garageName, user_id = parseInt(user_id) })
			if consult[1] == nil then
				return false
			else
				local ownerConsult = vRP.query("propertys/userOwnermissions",{ name = garageName })
				if ownerConsult[1] then
					if parseInt(os.time()) >= parseInt(ownerConsult[1]["tax"] + 24 * 7 * 60 * 60) then
						TriggerClientEvent("Notify",source,"default","Taxas da propriedade atrasada.",20000,"bottom","atenção")
						return false
					end
				end
			end
		end

		if garageLocates[garageName]["perm"] ~= nil then
			if exports["common"]:Group().hasPermission(user_id,garageLocates[garageName]["perm"]) then
				return vCLIENT.openGarage(source,garageName)
			end
		else
			return vCLIENT.openGarage(source,garageName)
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:UPDATEGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:updateGarages")
AddEventHandler("garages:updateGarages",function(homeName,homeInfos)
	garageLocates[homeName] = { ["name"] = homeName, ["payment"] = false }

	-- CONFIG
	local configFile = LoadResourceFile("logsystem","garageConfig.json")
	local configTable = json.decode(configFile)
	configTable[homeName] = { ["name"] = homeName, ["payment"] = false }
	SaveResourceFile("logsystem","garageConfig.json",json.encode(configTable),-1)

	-- LOCATES
	local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
	local locatesTable = json.decode(locatesFile)
	locatesTable[homeName] = homeInfos
	SaveResourceFile("logsystem","garageLocates.json",json.encode(locatesTable),-1)

	TriggerClientEvent("garages:updateLocs",-1,homeName,homeInfos)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:REMOVEGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:removeGarages")
AddEventHandler("garages:removeGarages",function(homeName)
	if garageLocates[homeName] then
		garageLocates[homeName] = nil

		local configFile = LoadResourceFile("logsystem","garageConfig.json")
		local configTable = json.decode(configFile)
		if configTable[homeName] then
			configTable[homeName] = nil
			SaveResourceFile("logsystem","garageConfig.json",json.encode(configTable),-1)
		end

		local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
		local locatesTable = json.decode(locatesFile)
		if locatesTable[homeName] then
			locatesTable[homeName] = nil
			SaveResourceFile("logsystem","garageLocates.json",json.encode(locatesTable),-1)
		end

		TriggerClientEvent("garages:updateRemove",-1,homeName)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNCFUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local configFile = LoadResourceFile("logsystem","garageConfig.json")
	local configTable = json.decode(configFile)

	for k,v in pairs(configTable) do
		garageLocates[k] = v
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("garages:allPlates",source,vehPlates)
	TriggerClientEvent("hud:allHardness",source,vehHardness)

	local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
	local locatesTable = json.decode(locatesFile)

	TriggerClientEvent("garages:allLocs",source,locatesTable)

	searchTimers[user_id] = GetGameTimer()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if searchTimers[user_id] then
		searchTimers[user_id] = nil
	end

	if spawnTimers[user_id] then
		spawnTimers[user_id] = nil
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHSIGNAL
-----------------------------------------------------------------------------------------------------------------------------------------
exports("vehSignal",function(vehPlate)
	return vehSignal[vehPlate]
end)