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
Tunnel.bindInterface("player",cRP)
vCLIENT = Tunnel.getInterface("player")
vSKINSHOP = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local trunkLimit = {}
local trunkIds = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("upgradeStress")
AddEventHandler("upgradeStress",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.upgradeStress(user_id,parseInt(number))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("reputacao",function(source,args,rawCmd)
--     local userId = vRP.getUserId(source)
--     if userId then
--         local reputation = vRP.getReputation(userId)
-- 		local reputationStr = ""

--         for k,v in pairs(reputation) do
--             reputationStr = reputationStr .. "<b>"..k.."</b>: "..v.."<br>"
--         end

-- 		if reputationStr == "" then
-- 			return TriggerClientEvent("Notify",source,"negado","Você não possui reputação.")
-- 		end

--         TriggerClientEvent("Notify",source,"default",""..reputationStr.."",20000,"normal","atenção")
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("me",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if args[1] then
			if vRP.getHealth(source) > 101 then
				vCLIENT.pressMe(-1,source,rawCommand:sub(3))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:KICKSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:kickSystem")
AddEventHandler("player:kickSystem",function(message)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.kick(user_id,message)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMOTES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(source) > 101 then
		if args[2] == "friend" then
			local otherPlayer = vRPC.nearestPlayer(source,3)
			if otherPlayer then
				if vRP.getHealth(otherPlayer) > 101 and not vCLIENT.getHandcuff(otherPlayer) then
					local identity = vRP.userIdentity(user_id)
					local request = vRP.request(otherPlayer,"Aceitar o pedido de <b>"..identity["name"].." "..identity["name2"].."</b> da animação <b>"..args[1].."</b>?",30)
					if request then
						TriggerClientEvent("emotes",otherPlayer,args[1])
						TriggerClientEvent("emotes",source,args[1])
					end
				end
			end
		else
			TriggerClientEvent("emotes",source,args[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMOTES2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e2",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(source) > 101 then
		local otherPlayer = vRPC.nearestPlayer(source,3)
		if otherPlayer then
			if exports["common"]:Group().hasPermission(user_id,"staff") then
				TriggerClientEvent("emotes",otherPlayer,args[1])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHMENU:DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vehmenu:doors")
AddEventHandler("vehmenu:doors",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet = vRPC.vehList(source,5)
		if vehicle then
			TriggerClientEvent("player:syncDoors",-1,vehNet,number)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.permissionVIP()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local consultItem = vRP.getInventoryItemAmount(user_id,"attachs")

		if vRP.checkBroken(consultItem[2]) then
			TriggerClientEvent("Notify",source,"negado","Item quebrado.",5000)
			return false
		end
		
		if exports["store"]:Appointments().isVipById(user_id) or exports["common"]:Group().hasPermission(user_id,"staff") or consultItem[1] > 0 then
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.receiveSalary()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.userIsBaby(user_id) then
			vRP.generateItem(user_id,"babybottle",4,true)
			vRP.generateItem(user_id,"lollipop",1,true)
			vRP.generateItem(user_id,"candy",1,true)
		end

		if exports["common"]:Group().hasPermission(user_id,"police") then
			vRP.addBank(user_id,5000)
			TriggerClientEvent("Notify",source,"sucesso","Salário de <b>$5.000</b> recebido.",10000)
		end

		if exports["common"]:Group().hasPermission(user_id,"paramedic") then
			vRP.addBank(user_id,5000)
			TriggerClientEvent("Notify",source,"sucesso","Salário de <b>$5.000</b> recebido.",10000)
		end

		if exports["store"]:Appointments().isVipById(user_id,"basic") then
			vRP.addBank(user_id,2300)
			TriggerClientEvent("Notify",source,"sucesso","Benefício de <b>$2300</b> recebido.",10000)
		end

		if exports["store"]:Appointments().isVipById(user_id,"standard") then
			vRP.addBank(user_id,3500)
			TriggerClientEvent("Notify",source,"sucesso","Benefício de <b>$3500</b> recebido.",10000)
		end

		if exports["store"]:Appointments().isVipById(user_id,"advanced") then
			vRP.addBank(user_id,5000)
			TriggerClientEvent("Notify",source,"sucesso","Benefício de <b>$5000</b> recebido.",10000)
		end

		if exports["store"]:Appointments().isVipById(user_id,"premium") then
			vRP.addBank(user_id,7000)
			TriggerClientEvent("Notify",source,"sucesso","Benefício de <b>$7000</b> recebido.",10000)
		end

		if exports["store"]:Appointments().isVipById(user_id,"ultimate") then
			vRP.addBank(user_id,9500)
			TriggerClientEvent("Notify",source,"sucesso","Benefício de <b>$9500</b> recebido.",10000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:SERVICEPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:servicePolice")
AddEventHandler("player:servicePolice",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"police") then
			TriggerEvent("blipsystem:serviceExit",source)
			exports["common"]:Group().alterSquadService(user_id,"police","waitpolice")
			TriggerClientEvent("police:updateService",source,false)
			TriggerClientEvent("Notify",source,"sucesso","Saiu de serviço.",5000,"bottom")
		elseif exports["common"]:Group().hasPermission(user_id,"waitpolice") then
			exports["common"]:Group().alterSquadService(user_id,"waitpolice","police")
			TriggerClientEvent("police:updateService",source,true)

			local identity = vRP.userIdentity(user_id)
			if identity then
				if identity["penal"] >= 1 then
					TriggerEvent("blipsystem:serviceEnter",source,"Penal",24)
				else
					TriggerEvent("blipsystem:serviceEnter",source,"Policia",18)
				end
			end

			TriggerClientEvent("Notify",source,"sucesso","Entrou em serviço.",5000,"bottom")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:SERVICEPARAMEDIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:serviceParamedic")
AddEventHandler("player:serviceParamedic",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"paramedic") then
			TriggerEvent("blipsystem:serviceExit",source)
			exports["common"]:Group().alterSquadService(user_id,"paramedic","waitparamedic")
			TriggerClientEvent("paramedic:updateService",source,false)
			TriggerClientEvent("Notify",source,"sucesso","Saiu de serviço.",5000)
		elseif exports["common"]:Group().hasPermission(user_id,"waitparamedic") then
			exports["common"]:Group().alterSquadService(user_id,"waitparamedic","paramedic")
			TriggerClientEvent("paramedic:updateService",source,true)
			TriggerEvent("blipsystem:serviceEnter",source,"Paramédico",6)
			TriggerClientEvent("Notify",source,"sucesso","Entrou em serviço.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETRUNKLIMIT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.vehicleTrunkLimit(vehPlate)
	local source = source
	local userId = vRP.getUserId(source)
	if not vehPlate then
		return
	end

	if not trunkLimit[vehPlate] then
		trunkLimit[vehPlate] = 0
	end
	
	if trunkLimit[vehPlate] >= 2 then
		TriggerClientEvent("Notify",source,"negado","Porta-malas <b>cheio</b>.",10000,"bottom")
		return false
	end
	
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETRUNKLIMIT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.increaseVehicleTrunk(vehPlate)
	local source = source
	local userId = vRP.getUserId(source)
	if not trunkIds[userId] then
		trunkIds[userId] = vehPlate
		trunkLimit[vehPlate] = trunkLimit[vehPlate] + 1
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETRUNKLIMIT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.decreaseVehicleTrunk()
	local source = source
	local userId = vRP.getUserId(source)
	if trunkIds[userId] then
		local vehPlate = trunkIds[userId]
		trunkLimit[vehPlate] = trunkLimit[vehPlate] - 1
		if trunkLimit[vehPlate] <= 0 then
			trunkLimit[vehPlate] = 0
		end
		trunkIds[userId] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ROPEPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:ropePlayer",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local consultItem = vRP.getInventoryItemAmount(user_id,"rope")
		if consultItem[1] > 0 then 

			local otherPlayer = entity[1]
			if otherPlayer and (vRP.getHealth(otherPlayer) <= 101 or vCLIENT.getHandcuff(otherPlayer)) then
				TriggerClientEvent("rope:toggleRope",source,otherPlayer)
				TriggerClientEvent("inventory:Close",otherPlayer)
			end
		else
			TriggerClientEvent("Notify",source,"importante","Você não possuí <b>"..itemName("rope").."</b> em sua mochila.")
		end	
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:HOODPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:hoodPlayer",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local consultItem = vRP.getInventoryItemAmount(user_id,"hood")
		if consultItem[1] > 0 then 
			local otherPlayer = entity[1]
			if otherPlayer and vCLIENT.getHandcuff(otherPlayer) then
				TriggerClientEvent("hud:toggleHood",otherPlayer)
				TriggerClientEvent("inventory:Close",otherPlayer)
			end
		else
			TriggerClientEvent("Notify",source,"importante","Você não possuí <b>"..itemName("hood").."</b> em sua mochila.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:HOODPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
local handcuffed = {}
RegisterServerEvent("player:handcuffPlayer",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRPC.inVehicle(source) then
			local _entity = nil
			if not entity then
				_entity = vRPC.nearestPlayer(source,2)
			else
				_entity = entity[1]
			end

			if not _entity then
				return
			end

			local nuser_id = vRP.getUserId(_entity)
			local consultItem = vRP.getInventoryItemAmount(user_id,"handcuff")
			if consultItem[1] <= 0 then
				return false
			end

			if vRP.checkBroken(consultItem[2]) then
				TriggerClientEvent("Notify",source,"negado","Item quebrado.",5000)
				return false
			end

			local otherPlayer = _entity
			if otherPlayer then
				if vCLIENT.getHandcuff(otherPlayer) then
					vCLIENT.toggleHandcuff(otherPlayer)
					TriggerClientEvent("sounds:source",source,"uncuff",0.3)
					TriggerClientEvent("sounds:source",otherPlayer,"uncuff",0.3)
					TriggerClientEvent("player:blockCommands",otherPlayer,false)
					if handcuffed[nuser_id] then 
						handcuffed[nuser_id] = nil
					end
				else
					TriggerClientEvent("toggleCarry",otherPlayer,source)
					vRPC.playAnim(otherPlayer,false,{"mp_arrest_paired","crook_p2_back_left"},false)
					vRPC.playAnim(source,false,{"mp_arrest_paired","cop_p2_back_left"},false)

					Citizen.Wait(3500)

					vRPC.stopAnim(source,false)
					vCLIENT.toggleHandcuff(otherPlayer)
					TriggerClientEvent("inventory:Close",otherPlayer)
					TriggerClientEvent("toggleCarry",otherPlayer,source)
					TriggerClientEvent("sounds:source",source,"cuff",0.3)
					TriggerClientEvent("sounds:source",otherPlayer,"cuff",0.3)
					TriggerClientEvent("player:blockCommands",otherPlayer,true)
					handcuffed[nuser_id] = true
				end
			end
		end
	end
end)

-- RegisterCommand("algemar",function(source,args,rawCommand)
-- 	local source = source
-- 	local user_id = vRP.getUserId(source)
-- 	if user_id then 
-- 		vCLIENT.toggleHandcuff(source)
-- 		handcuffed[user_id] = true
-- 	end
-- end)

-- RegisterCommand("desalgemar",function(source,args,rawCommand)
-- 	local source = source
-- 	local user_id = vRP.getUserId(source)
-- 	handcuffed[user_id] = nil
-- end)

exports("handcuffStatus",function(status,user_id)
	if status then 
		handcuffed[user_id] = true
	else
		if handcuffed[user_id] then 
			handcuffed[user_id] = nil
		end
	end
end)

AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local source = source
	if handcuffed[user_id] then
		vCLIENT.toggleHandcuff(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RELATIONSHIPPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:startRelationship",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		local consultItem = vRP.getInventoryItemAmount(user_id,"ringbox")
		if consultItem[1] <= 0 then
			TriggerClientEvent("Notify",source,"negado","Você não possuí uma <b>Caixa de Aliança</b>.",10000,"bottom")
			return
		end

		local item = vRP.getInventoryItemAmount(user_id,"ring")
		if item[1] > 0 then
			local nameItem = splitString(item[2],"-")
			if nameItem and nameItem[2] ~= nil then 
				TriggerClientEvent("Notify",source,"negado","Você já está namorando.",10000,"bottom")
				return 
			end
		end

		local otherPlayer = entity[1]
		local identity = vRP.userIdentity(user_id)
		if otherPlayer then
			local nuser_id = vRP.getUserId(otherPlayer)
			local identity2 = vRP.userIdentity(nuser_id)
			TriggerClientEvent("Notify",source,"importante","Pedido de namoro enviado, aguarde.",10000,"bottom")
			if vRP.request(otherPlayer,"<b>"..identity.name.." "..identity.name2.."</b> te pediu em namoro.",60) then 
				vRP.removeInventoryItem(user_id,"ringbox",1)
				vRP.generateItem(user_id,"ring-"..nuser_id,1,true)
				vRP.generateItem(nuser_id,"ring-"..user_id,1,true)
				TriggerClientEvent("Notify",source,"sucesso","Parabéns, você e <b>"..identity2.name.." "..identity2.name2.."</b> agora estão namorando.",20000,"bottom")
				TriggerClientEvent("Notify",otherPlayer,"sucesso","Parabéns, você e <b>"..identity.name.." "..identity.name2.."</b> agora estão namorando.",20000,"bottom")
			else
				TriggerClientEvent("Notify",source,"negado","O seu pedido de namoro foi recusado.",10000,"bottom")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RELATIONSHIPPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:endRelationship",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local otherPlayer = entity[1]
		if otherPlayer then
			local nuser_id = vRP.getUserId(otherPlayer)
			local consultItem = vRP.getInventoryItemAmount(user_id,"ring")
			local consultItem2 = vRP.getInventoryItemAmount(nuser_id,"ring")
			if consultItem[1] > 0 and consultItem2[1] > 0 then 
				local identity = vRP.userIdentity(user_id)
				local identity2 = vRP.userIdentity(nuser_id)
				local nameItem = splitString(consultItem[2],"-")
				if parseInt(nameItem[2]) == nuser_id then
					TriggerClientEvent("Notify",source,"importante","Pedido de término enviado, aguarde.",10000,"bottom")
					if vRP.request(otherPlayer,"<b>"..identity.name.." "..identity.name2.."</b> quer terminar o namoro.",60)then 
						vRP.removeInventoryItem(user_id,"ring-"..nuser_id,1,true)
						vRP.removeInventoryItem(nuser_id,"ring-"..user_id,1,true)
						TriggerClientEvent("Notify",source,"importante","Infelizmente, você e <b>"..identity2.name.." "..identity2.name2.."</b> não estão mais namorando.",20000,"bottom")
						TriggerClientEvent("Notify",otherPlayer,"importante","Infelizmente, você e <b>"..identity.name.." "..identity.name2.."</b> não estão mais namorando.",20000,"bottom")
					end
				end
			else
				TriggerClientEvent("Notify",source,"negado","Você não está namorando.",10000,"bottom")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ROBPED
-----------------------------------------------------------------------------------------------------------------------------------------
-- local robbedPeds = {}
-- RegisterServerEvent("npc:robPed",function(entity)
-- 	local source = source

-- 	local policeResult = exports["common"]:Group().getAllByPermission("police")
-- 	if parseInt(#policeResult) <= 4 then
-- 		TriggerClientEvent("Notify",source,"negado","Número insuficiente de policiais.",10000,"bottom")
-- 		return false
-- 	end

-- 	if robbedPeds[entity[2]] then 
-- 		TriggerClientEvent("Notify",source,"negado","Este residente já foi assaltado.",10000,"bottom")
-- 		return 
-- 	end

-- 	robbedPeds[entity[2]] = true

-- 	local user_id = vRP.getUserId(source)
-- 	if user_id then 
		
-- 		TriggerClientEvent("Progress",source,1500)
-- 		Wait(1500)
		
-- 		local coords = GetEntityCoords(GetPlayerPed(source))
-- 		local reputationValue = math.random(1,6)

-- 		if math.random(100) >= 75 then
-- 			local policeResult = exports["common"]:Group().getAllByPermission("police")
-- 			for k,v in pairs(policeResult) do
-- 				async(function()
-- 					TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Residente Assaltado", x = coords["x"], y = coords["y"], z = coords["z"], time = "Recebido às "..os.date("%H:%M"), blipColor = 5 })
-- 				end)
-- 			end
-- 			vCLIENT.agressivePed(source,entity[1])
-- 			exports["wanted"]:setWanted(user_id,60)
-- 			TriggerClientEvent("player:applyGsr",source)
-- 			TriggerClientEvent("Notify",source,"default","Você perdeu <b>-"..reputationValue.."</b> de Reputação como Ladrão.",10000,"bottom","atenção")
-- 			vRP.removeReputation(user_id,"thief",reputationValue)
-- 			vRP.upgradeStress(user_id,2)
-- 			return
-- 		end
		
-- 		TriggerClientEvent("Notify",source,"default","Você recebeu <b>+"..reputationValue.."</b> de Reputação como Ladrão.",10000,"bottom","atenção")
-- 		vRP.insertReputation(user_id,"thief",reputationValue)
-- 		vRP.generateItem(user_id,"dollarsz",math.random(25,55),true)
-- 		vRP.upgradeStress(user_id,1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HACKSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
-- local hackerMarkers = {}

-- Citizen.CreateThread(function()
-- 	while true do
-- 		for k,v in pairs(hackerMarkers) do
-- 			if hackerMarkers[k][1] > 0 then
-- 				hackerMarkers[k][1] = hackerMarkers[k][1] - 1

-- 				if hackerMarkers[k][1] <= 0 then
-- 					if vRP.userSource(hackerMarkers[k][2]) then
-- 						TriggerEvent("blipsystem:serviceExit",k)
-- 						TriggerClientEvent("Notify",k,"default","Você foi removido(a) do radar da polícia.",10000,"bottom","atenção")
-- 					end
					
-- 					hackerMarkers[k] = nil
					
-- 				end
-- 			end
-- 		end

-- 		Citizen.Wait(1000)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:NPCHACKED
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterServerEvent("npc:hackedPed",function(entity)
-- 	local source = source

-- 	local policeResult = exports["common"]:Group().getAllByPermission("police")
-- 	if parseInt(#policeResult) <= 4 then
-- 		TriggerClientEvent("Notify",source,"negado","Número insuficiente de policiais.",10000,"bottom")
-- 		return false
-- 	end

-- 	if robbedPeds[entity[2]] then 
-- 		TriggerClientEvent("Notify",source,"negado","Este residente já foi hackeado.",10000,"bottom")
-- 		return 
-- 	end

-- 	robbedPeds[entity[2]] = true

-- 	local user_id = vRP.getUserId(source)
-- 	if user_id then

-- 		TriggerClientEvent("inventory:blockButtons",source,true)
-- 		vRPC.createObjects(source,"amb@world_human_stand_mobile@male@text@enter","enter","prop_amb_phone",50,28422)
-- 		TriggerClientEvent("Progress",source,15000)
-- 		Wait(15000)
		
-- 		local coords = GetEntityCoords(GetPlayerPed(source))
-- 		local reputationValue = math.random(1,6)

-- 		if math.random(100) >= 90 then
-- 			local policeResult = exports["common"]:Group().getAllByPermission("police")
-- 			for k,v in pairs(policeResult) do
-- 				async(function()
-- 					TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Hacker", x = coords["x"], y = coords["y"], z = coords["z"], time = "Recebido às "..os.date("%H:%M"), blipColor = 5 })
-- 				end)
-- 			end
-- 			hackerMarkers[source] = { 10,parseInt(user_id) }
-- 			exports["wanted"]:setWanted(user_id,300)
-- 			TriggerClientEvent("player:applyGsr",source)
-- 			TriggerEvent("blipsystem:serviceEnter",source,"Hacker",1)
-- 			vRP.removeReputation(user_id,"hacking",reputationValue)
-- 			TriggerClientEvent("Notify",source,"default","Você perdeu <b>-"..reputationValue.."</b> de Reputação como Hacker.",10000,"bottom","atenção")
-- 			TriggerClientEvent("Notify",source,"default","Você foi adicionado(a) ao radar da polícia por <b>10 segundos</b>.",10000,"bottom","atenção")
-- 			TriggerClientEvent("inventory:blockButtons",source,false)
-- 			vRPC.removeObjects(source,"one")
-- 			vRP.upgradeStress(user_id,2)
-- 			return
-- 		end
		
-- 		TriggerClientEvent("Notify",source,"default","Você recebeu <b>+"..reputationValue.."</b> de Reputação como Hacker.",10000,"bottom","atenção")
-- 		TriggerClientEvent("inventory:blockButtons",source,false)

-- 		vRP.insertReputation(user_id,"hacking",reputationValue)
-- 		vRP.upgradeStress(user_id,1)
-- 		vRPC.removeObjects(source,"one")
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYREMOVED
-----------------------------------------------------------------------------------------------------------------------------------------
-- AddEventHandler("entityRemoved", function (entity)
-- 	local netid = NetworkGetNetworkIdFromEntity(entity)
-- 	robbedPeds[netid] = nil
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.shotsFired()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local ped = GetPlayerPed(source)
		if DoesEntityExist(ped) then
			local coords = GetEntityCoords(ped)
			TriggerClientEvent("notifyShooting",-1,coords)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CARRYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:carryFunctions")
AddEventHandler("player:carryFunctions",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRPC.inVehicle(source) then
			local otherPlayer = vRPC.nearestPlayer(source,1.1)
			if otherPlayer then
				if exports["common"]:Group().hasPermission(user_id,"paramedic") or exports["common"]:Group().hasPermission(user_id,"police") or exports["common"]:Group().hasPermission(user_id,"staff") then
					if mode == "bracos" then
						vCLIENT.toggleCarry(otherPlayer,source)
					elseif mode == "ombros" then
						TriggerClientEvent("rope:toggleRope",source,otherPlayer)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:drag")
AddEventHandler("player:drag",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local otherPlayer = vRPC.nearestPlayer(source,1.1)
		if otherPlayer then
			if exports["common"]:Group().hasPermission(user_id,"paramedic") or exports["common"]:Group().hasPermission(user_id,"police") then
				vCLIENT.toggleCarry(otherPlayer,source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:WINSFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:winsFunctions")
AddEventHandler("player:winsFunctions",function(mode)
	local source = source
	local vehicle,vehNet = vRPC.vehSitting(source)
	if vehicle then
		TriggerClientEvent("player:syncWins",-1,vehNet,mode)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:IDENTITYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local cooldown = {}
RegisterServerEvent("player:identityFunctions")
AddEventHandler("player:identityFunctions",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not cooldown[user_id] or os.time() - cooldown[user_id] > 15 then 
			cooldown[user_id] = os.time()
			local identity = vRP.userIdentity(user_id)
			if identity then
				local port = "Não"
				if identity["port"] >= 1 then
					port = "Sim"
				end

				local oab = "Não"
				if identity["oab"] >= 1 then
					oab = "Sim"
				end

				TriggerClientEvent("Notify",source,"default","<b>Passaporte:</b> "..parseFormat(user_id).."<br><b>Nome:</b> "..identity["name"].." "..identity["name2"].."<br><b>Apelido:</b> "..identity["surname"].."<br><b>Cryptos:</b> "..parseFormat(exports["store"]:Crypto().get(user_id)).."<br><b>Maximo de Veículos:</b> "..identity["garage"].."<br><b>Maximo de Propriedades:</b> "..identity["homes"].."<br><b>Porte de Armamento:</b> "..port.."<br><b>OAB:</b> "..oab.."",15000,"left","informações")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cv",function(source,args,rawCommand)
	local source = source
	local userId = vRP.getUserId(source)
	local otherPlayer = vRPC.nearestPlayer(source,1.1)
	if otherPlayer then
		local userId = vRP.getUserId(source)
		local consultItem = vRP.getInventoryItemAmount(userId,"rope")
		if exports["common"]:Group().hasPermission(userId,"staff") or exports["common"]:Group().hasPermission(userId,"paramedic") or exports["common"]:Group().hasPermission(userId,"police") or consultItem[1] >= 1 then
			local vehicle,vehNet,vehPlate,vehName,vehLock = vRPC.vehList(source,5)
			if vehicle then
				if vehLock ~= 1 then
					vCLIENT.putVehicle(otherPlayer,vehNet)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rv",function(source,args,rawCommand)
	local source = source
	local userId = vRP.getUserId(source)
	local otherPlayer = vRPC.nearestPlayer(source,10.0)
	if otherPlayer then
		local userId = vRP.getUserId(source)
		local consultItem = vRP.getInventoryItemAmount(userId,"rope")
		if exports["common"]:Group().hasPermission(userId,"staff") or exports["common"]:Group().hasPermission(userId,"paramedic") or exports["common"]:Group().hasPermission(userId,"police") or consultItem[1] >= 1 then
			local vehicle,vehNet,vehPlate,vehName,vehLock = vRPC.vehList(source,5)
			if vehicle then
				if vehLock ~= 1 then
					vCLIENT.removeVehicle(otherPlayer)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local preset = {
	["1"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 148, texture = 0 },
			["vest"] = { item = 73, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 197, texture = 0 },
			["torso"] = { item = 423, texture = 2 },
			["accessory"] = { item = 169, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 4, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 147, texture = 0 },
			["vest"] = { item = 71, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 241, texture = 0 },
			["torso"] = { item = 456, texture = 0 },
			["accessory"] = { item = 140, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 14, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["2"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 148, texture = 0 },
			["vest"] = { item = 73, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 197, texture = 0 },
			["torso"] = { item = 422, texture = 2 },
			["accessory"] = { item = 169, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 11, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 147, texture = 0 },
			["vest"] = { item = 71, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 241, texture = 0 },
			["torso"] = { item = 456, texture = 0 },
			["accessory"] = { item = 140, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 14, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["3"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 20, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 1, texture = 1 },
			["tshirt"] = { item = 96, texture = 0 },
			["torso"] = { item = 32, texture = 7 },
			["accessory"] = { item = 126, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 79, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 23, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 1, texture = 0 },
			["tshirt"] = { item = 101, texture = 0 },
			["torso"] = { item = 58, texture = 7 },
			["accessory"] = { item = 96, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 91, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["4"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 20, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 57, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 1, texture = 1 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 249, texture = 0 },
			["accessory"] = { item = 126, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 90, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 23, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 65, texture = 0 },
			["mask"] = { item = 121, texture = 0 },
			["shoes"] = { item = 1, texture = 0 },
			["tshirt"] = { item = 2, texture = 0 },
			["torso"] = { item = 257, texture = 0 },
			["accessory"] = { item = 96, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 104, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["5"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 20, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 1, texture = 1 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 146, texture = 6 },
			["accessory"] = { item = 127, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 85, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 23, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 1, texture = 0 },
			["tshirt"] = { item = 2, texture = 0 },
			["torso"] = { item = 141, texture = 1 },
			["accessory"] = { item = 97, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 109, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:presetFunctions")
AddEventHandler("player:presetFunctions",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"paramedic") or exports["common"]:Group().hasPermission(user_id,"police") then
			local model = vRP.modelPlayer(source)

			if model == "mp_m_freemode_01" or "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",source,preset[number][model])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local job = {
	["1"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 36, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 1, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 56, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 0, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 35, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 9, texture = 0 },
			["tshirt"] = { item = 36, texture = 0 },
			["torso"] = { item = 50, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 0, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["2"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 39, texture = 0 },
			["pants"] = { item = 25, texture = 0 },
			["vest"] = { item = 78, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 76, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 154, texture = 0 },
			["torso"] = { item = 317, texture = 1 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 1, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 38, texture = 0 },
			["pants"] = { item = 37, texture = 0 },
			["vest"] = { item = 31, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 85, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 6, texture = 0 },
			["tshirt"] = { item = 159, texture = 0 },
			["torso"] = { item = 328, texture = 1 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 1, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["3"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 145, texture = 2 },
			["pants"] = { item = 47, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 1, texture = 0 },
			["tshirt"] = { item = 59, texture = 0 },
			["torso"] = { item = 0, texture = 1 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 41, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 144, texture = 2 },
			["pants"] = { item = 49, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 9, texture = 0 },
			["tshirt"] = { item = 36, texture = 0 },
			["torso"] = { item = 49, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 46, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETJOBS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:presetJobs")
AddEventHandler("player:presetJobs",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local model = vRP.modelPlayer(source)
		if model == "mp_m_freemode_01" or "mp_f_freemode_01" then
			TriggerClientEvent("updateRoupas",source,job[number][model])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local intro = {
	["mp_m_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 0, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 0, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 193, texture = 4 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 0, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 3, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 9, texture = 0 },
		["tshirt"] = { item = 6, texture = 0 },
		["torso"] = { item = 33, texture = 8 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 4, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETINTRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:presetIntro")
AddEventHandler("player:presetIntro",function(source)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local model = vRP.modelPlayer(source)
		if model == "mp_m_freemode_01" or "mp_f_freemode_01" then
			TriggerClientEvent("updateRoupas",source,intro[model])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
	local source = source
	local otherPlayer = vRPC.nearestPlayer(source,2)
	if otherPlayer then
		TriggerClientEvent("player:checkTrunk",otherPlayer)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTFIT - REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
local removeFit = {
	["homem"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 5, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mulher"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 5, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:outfitFunctions")
AddEventHandler("player:outfitFunctions",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and not vRP.reposeReturn(user_id) and not exports["wanted"]:checkWanted(user_id) then
		if mode == "aplicar" then
			local result = vRP.getSrvdata("saveClothes:"..user_id)
			if result["pants"] ~= nil then
				TriggerClientEvent("updateRoupas",source,result)
				TriggerClientEvent("Notify",source,"sucesso","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"negado","Roupas não encontradas.",3000)
			end
		elseif mode == "preaplicar" then
			if exports["store"]:Appointments().isVipById(user_id) then
				local result = vRP.getSrvdata("premClothes:"..user_id)
				if result["pants"] ~= nil then
					TriggerClientEvent("updateRoupas",source,result)
					TriggerClientEvent("Notify",source,"sucesso","Roupas aplicadas.",3000)
				else
					TriggerClientEvent("Notify",source,"negado","Roupas não encontradas.",3000)
				end
			end
		elseif mode == "salvar" then
			local checkBackpack = vSKINSHOP.checkBackpack(source)
			if not checkBackpack then
				local custom = vSKINSHOP.getCustomization(source)
				if custom then
					vRP.setSrvdata("saveClothes:"..user_id,custom)
					TriggerClientEvent("Notify",source,"sucesso","Roupas salvas.",3000)
				end
			else
				TriggerClientEvent("Notify",source,"negado","Remova do corpo o acessório item.",5000)
			end
		elseif mode == "presalvar" then
			if exports["store"]:Appointments().isVipById(user_id) then
				local checkBackpack = vSKINSHOP.checkBackpack(source)
				if not checkBackpack then
					local custom = vSKINSHOP.getCustomization(source)
					if custom then
						vRP.setSrvdata("premClothes:"..user_id,custom)
						TriggerClientEvent("Notify",source,"sucesso","Roupas salvas.",3000)
					end
				else
					TriggerClientEvent("Notify",source,"negado","Remova do corpo o acessório item.",5000)
				end
			end
		elseif mode == "remover" then
			local model = vRP.modelPlayer(source)
			if model == "mp_m_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["homem"])
			elseif model == "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["mulher"])
			end
		else
			TriggerClientEvent("skinshop:set"..mode,source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MÁSCARA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mascara",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"mask")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLUSA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blusa",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"tshirt")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JAQUETA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("jaqueta",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"torso")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("colete",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"vest")
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------
-- CALÇA
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("calca",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"pants")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MÃOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("maos",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"arms")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACESSÓRIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("acessorios",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"accessory")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mochila",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"backpack")
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------
-- SAPATOS
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("sapatos",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"shoes")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAPÉU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("chapeu",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"hat")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ÓCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("oculos",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["store"]:Buyers().isBuyerById(userId,"clothes") or exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"glass")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("repouso",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
		local timer = parseInt(args[2])
		local nuser_id = parseInt(args[1])
		local uSource = vRP.userSource(nuser_id)
		if uSource then
			local identity = vRP.userIdentity(nuser_id)
			if vRP.request(source,"Deseja aplicar <b>"..timer.." minutos</b> de repouso no(a) <b>"..identity["name"].." "..identity["name2"].."</b>?.",30) then
				TriggerClientEvent("Notify",source,"importante","Aplicou <b>"..timer.." minutos</b> de repouso.",10000)
				vRP.reposeTimer(nuser_id,timer)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WALKING
-----------------------------------------------------------------------------------------------------------------------------------------
local walking = {
	{ "move_m@alien" },
	{ "anim_group_move_ballistic" },
	{ "move_f@arrogant@a" },
	{ "move_m@brave" },
	{ "move_m@casual@a" },
	{ "move_m@casual@b" },
	{ "move_m@casual@c" },
	{ "move_m@casual@d" },
	{ "move_m@casual@e" },
	{ "move_m@casual@f" },
	{ "move_f@chichi" },
	{ "move_m@confident" },
	{ "move_m@business@a" },
	{ "move_m@business@b" },
	{ "move_m@business@c" },
	{ "move_m@drunk@a" },
	{ "move_m@drunk@slightlydrunk" },
	{ "move_m@buzzed" },
	{ "move_m@drunk@verydrunk" },
	{ "move_f@femme@" },
	{ "move_characters@franklin@fire" },
	{ "move_characters@michael@fire" },
	{ "move_m@fire" },
	{ "move_f@flee@a" },
	{ "move_p_m_one" },
	{ "move_m@gangster@generic" },
	{ "move_m@gangster@ng" },
	{ "move_m@gangster@var_e" },
	{ "move_m@gangster@var_f" },
	{ "move_m@gangster@var_i" },
	{ "anim@move_m@grooving@" },
	{ "move_f@heels@c" },
	{ "move_m@hipster@a" },
	{ "move_m@hobo@a" },
	{ "move_f@hurry@a" },
	{ "move_p_m_zero_janitor" },
	{ "move_p_m_zero_slow" },
	{ "move_m@jog@" },
	{ "anim_group_move_lemar_alley" },
	{ "move_heist_lester" },
	{ "move_f@maneater" },
	{ "move_m@money" },
	{ "move_m@posh@" },
	{ "move_f@posh@" },
	{ "move_m@quick" },
	{ "female_fast_runner" },
	{ "move_m@sad@a" },
	{ "move_m@sassy" },
	{ "move_f@sassy" },
	{ "move_f@scared" },
	{ "move_f@sexy@a" },
	{ "move_m@shadyped@a" },
	{ "move_characters@jimmy@slow@" },
	{ "move_m@swagger" },
	{ "move_m@tough_guy@" },
	{ "move_f@tough_guy@" },
	{ "move_p_m_two" },
	{ "move_m@bag" },
	{ "move_m@injured" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANDAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("andar",function(source,args,rawCommand)
	if not args[1] then
		return
	end

	if walking[parseInt(args[1])] then
		vCLIENT.movementClip(source,walking[parseInt(args[1])][1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:SERVICOFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local delayDuty = {}
RegisterServerEvent("player:servicoFunctions")
AddEventHandler("player:servicoFunctions",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and delayDuty[user_id] == nil then
		delayDuty[user_id] = true

		if exports["common"]:Group().hasPermission(user_id,"paramedic") or exports["common"]:Group().hasPermission(user_id,"police") then
			local service = {}
			local onDuty = "<b>Passaporte:</b> "

			if exports["common"]:Group().hasPermission(user_id,"police") then
				service = exports["common"]:Group().getAllByPermission("police")
			elseif exports["common"]:Group().hasPermission(user_id,"paramedic") then
				service = exports["common"]:Group().getAllByPermission("paramedic")
			end

			for k,v in pairs(service) do
				local nuser_id = vRP.getUserId(v)
				if nuser_id then
					if k ~= #service then
						onDuty = onDuty..nuser_id..", "
					else
						onDuty = onDuty..nuser_id
					end
				end
			end

			TriggerClientEvent("Notify",source,"default",onDuty,30000,"normal","atenção")
		end

		delayDuty[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if delayDuty[user_id] then
		delayDuty[user_id] = nil
	end

	if trunkIds[user_id] then
		local vehPlate = trunkIds[user_id]
		trunkLimit[vehPlate] = trunkLimit[vehPlate] - 1
		if trunkLimit[vehPlate] <= 0 then
			trunkLimit[vehPlate] = 0
		end
		trunkIds[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDEATHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:deathLogs")
AddEventHandler("player:deathLogs",function(nSource)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and source ~= nSource then
		local nuser_id = vRP.getUserId(nSource)
		if nuser_id then
			exports["common"]:Log().embedDiscord(user_id,"commands-death","**MATOU:** ```"..nuser_id.."```\nMatou às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
		end
	end
end)