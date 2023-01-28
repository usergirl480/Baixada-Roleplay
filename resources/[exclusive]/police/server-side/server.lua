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
Tunnel.bindInterface("police",cRP)
vCLIENT = Tunnel.getInterface("police")
vTASKBAR = Tunnel.getInterface("taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local prisonMarkers = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local preset = {
	["mp_m_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 59, texture = 1 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 0, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 5, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 61, texture = 1 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 25, texture = 0 },
		["tshirt"] = { item = 37, texture = 0 },
		["torso"] = { item = 74, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 4, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:PRISONCLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:prisonClothes")
AddEventHandler("police:prisonClothes",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(source) > 101 then
		if exports["common"]:Group().hasPermission(user_id,"police") then
			local mHash = vRP.modelPlayer(entity[1])
			if mHash == "mp_m_freemode_01" or mHash == "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",entity[1],preset[mHash])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.initPrison(nuser_id,services,fines,text)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			local identity = vRP.userIdentity(user_id)
			local otherPlayer = vRP.userSource(nuser_id)
			local reputationValue = math.random(1,3)
			if otherPlayer then
				vCLIENT.syncPrison(otherPlayer,true,false)
				TriggerClientEvent("radio:outServers",otherPlayer)
				vRP.insertReputation(nuser_id,"fugitive",reputationValue)
				TriggerClientEvent("Notify",otherPlayer,"default","Você perdeu <b>-"..reputationValue.."</b> de Reputação como Fugitivo.",10000,"bottom","atenção")
			end

			vRP.execute("prison/insertPrison",{ police = identity["name"].." "..identity["name2"], nuser_id = parseInt(nuser_id), services = services, fines = fines, text = text, date = os.date("%d/%m/%Y").." ás "..os.date("%H:%M") })
			vRP.execute("characters/setPrison",{ user_id = parseInt(nuser_id), prison = parseInt(services) })
			vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
			TriggerClientEvent("Notify",source,"importante","Prisão efetuada.",5000)
			TriggerClientEvent("police:Update",source,"reloadPrison")

			if fines > 0 then
				vRP.addFines(nuser_id,fines)
			end

			exports["common"]:Log().embedDiscord(user_id,"commands-prison","**ID:** ```"..parseFormat(nuser_id).."```\n**SERVIÇOS:** ```"..parseFormat(services).."```\n**MULTA:** ```$"..parseFormat(fines).."```\n**RELATÓRIO:** ```"..text.."```\nPrisão aplicada às "..os.date("%d/%m/%y %H:%M:%S"),8686827)

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHUSER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.searchUser(nuser_id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.userIdentity(nuser_id)
		if identity then
			local fines = vRP.getFines(nuser_id)
			local records = vRP.query("prison/getRecords",{ nuser_id = parseInt(nuser_id) })

			return { true,identity["name"].." "..identity["name2"],identity["phone"],fines,records,identity["port"],identity["oab"],identity["serial"],identity["penal"] }
		end
	end

	return { false }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.initFine(nuser_id,fines,text)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and fines > 0 then
		if actived[user_id] == nil then
			actived[user_id] = true

			exports["common"]:Log().embedDiscord(user_id,"commands-fine","**ID:** ```"..parseFormat(nuser_id).."```\n**MULTA:** ```$"..parseFormat(fines).."```\n**MOTIVO:** ```"..text.."```\nMulta aplicada às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			TriggerClientEvent("Notify",source,"importante","Multa aplicada.",5000)
			TriggerClientEvent("police:Update",source,"reloadFine")
			vRP.addFines(nuser_id,fines)

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pd",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] and vRP.getHealth(source) > 101 then
		if exports["common"]:Group().hasPermission(user_id,"police") then
			local identity = vRP.userIdentity(user_id)
			local policeResult = exports["common"]:Group().getAllByPermission("police")
			for k,v in pairs(policeResult) do
				async(function()
					TriggerClientEvent("chatME",v,"^7["..user_id.."] "..identity["name"].." "..identity["name2"]..": ^4"..rawCommand:sub(3))
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("112",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] and vRP.getHealth(source) > 101 then
		if exports["common"]:Group().hasPermission(user_id,"paramedic") then
			local identity = vRP.userIdentity(user_id)
			local paramedicResult = exports["common"]:Group().getAllByPermission("paramedic")
			for k,v in pairs(paramedicResult) do
				async(function()
					TriggerClientEvent("chatME",v,"^6["..user_id.."] "..identity["name"].." "..identity["name2"]..": ^4"..rawCommand:sub(3))
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updatePort(nuser_id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local portStatus = ""
		local identity = vRP.userIdentity(user_id)
		local nidentity = vRP.userIdentity(nuser_id)

		if nidentity["port"] == 0 then
			portStatus = "Ativado"
			vRP.execute("characters/updatePort",{ port = 1, id = parseInt(nuser_id) })
		else
			portStatus = "Desativado"
			vRP.execute("characters/updatePort",{ port = 0, id = parseInt(nuser_id) })
		end

		TriggerClientEvent("police:Update",source,"reloadSearch",parseInt(nuser_id))
		exports["common"]:Log().embedDiscord(user_id,"commands-port","**ID:** ```"..parseFormat(nuser_id).."```\n**PORTE:** ```"..portStatus.."```\nAtualizado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
		
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPENAL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updatePenal(nuser_id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasAccessOrHigher(user_id,"comandante") then
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				if identity["penal"] == 0 then
					vRP.execute("characters/updatePenal",{ penal = 1, id = parseInt(nuser_id) })
				else
					vRP.execute("characters/updatePenal",{ penal = 0, id = parseInt(nuser_id) })
				end

				TriggerClientEvent("police:Update",source,"reloadSearch",parseInt(nuser_id))
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISONSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(prisonMarkers) do
			if prisonMarkers[k][1] > 0 then
				prisonMarkers[k][1] = prisonMarkers[k][1] - 1

				if prisonMarkers[k][1] <= 0 then
					if vRP.userSource(prisonMarkers[k][2]) then
						TriggerEvent("blipsystem:serviceExit",k)
					end

					prisonMarkers[k] = nil
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.resetPrison()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vCLIENT.syncPrison(source,false,true)
		prisonMarkers[source] = { 180,parseInt(user_id) }
		vRP.execute("characters/fixPrison",{ user_id = parseInt(user_id) })

		local reputationValue = math.random(1,3)

		local coords = GetEntityCoords(GetPlayerPed(source))
		local policeResult = exports["common"]:Group().getAllByPermission("police")
		for k,v in pairs(policeResult) do
			async(function()
				TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Fugitivo", x = coords["x"], y = coords["y"], z = coords["z"], time = "Recebido às "..os.date("%H:%M"), blipColor = 5 })
			end)
		end

		exports["wanted"]:setWanted(user_id,180)
		TriggerEvent("blipsystem:serviceEnter",source,"Prisioneiro",48)
		vRP.insertReputation(user_id,"fugitive",reputationValue)
		TriggerClientEvent("Notify",source,"default","Você recebeu <b>+"..reputationValue.."</b> de Reputação como Fugitivo.",10000,"bottom","atenção")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REDUCEPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.reducePrison()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("characters/removePrison",{ user_id = parseInt(user_id), prison = 1 })

		local reputationFugitive = vRP.checkReputation(user_id,"fugitive")
		if reputationFugitive >= 4 then
			vRP.execute("characters/removePrison",{ user_id = parseInt(user_id), prison = 2 })
		end

		local consult = vRP.getInformation(user_id)
		if parseInt(consult[1]["prison"]) <= 0 then
			vCLIENT.syncPrison(source,false,true)
			vRP.execute("characters/fixPrison",{ user_id = parseInt(user_id) })
			TriggerClientEvent("Notify",source,"importante","O seu serviço acabou, esperamos não vê-lo novamente.",5000)
		else
			vCLIENT.asyncServices(source)
			TriggerClientEvent("Notify",source,"default","Restam <b>"..parseInt(consult[1]["prison"]).." serviços</b>.",10000,"bottom","atenção")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKKEY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkKey()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		local policeResult = exports["common"]:Group().getAllByPermission("police")
		if parseInt(#policeResult) <= 4 then
			TriggerClientEvent("Notify",source,"negado","Número insuficiente de policiais.",10000,"bottom")
			return false
		end

		local consultItem = vRP.getInventoryItemAmount(user_id,"key")
		if consultItem[1] > 0 then
			if not vRP.checkBroken(consultItem[2]) then
				local taskResult = vTASKBAR.taskDoors(source)
				if taskResult then
					vRP.tryGetInventoryItem(user_id,consultItem[2],1,true)
					return true
				end
			end
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEKEY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.giveKey()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.generateItem(user_id,"key",1,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPolice()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"police") then
			return true
		end
	end

	return false
end
--------------------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
--------------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local consult = vRP.getInformation(user_id)
	if consult[1] then
		if parseInt(consult[1]["prison"]) <= 0 then
			return
		else
			TriggerClientEvent("Notify",source,"default","Restam <b>"..parseInt(consult[1]["prison"]).." serviços</b>.",10000,"bottom","atenção")
			vCLIENT.syncPrison(source,true,true)
		end
	end
end)