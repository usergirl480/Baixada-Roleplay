-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = {}
tvRP = {}
vRP.userIds = {}
vRP.userTables = {}
vRP.userSources = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNER/PROXY
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy.addInterface("vRP",vRP)
Tunnel.bindInterface("vRP",tvRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYSQL
-----------------------------------------------------------------------------------------------------------------------------------------
local mysqlDriver
local userSql = {}
local mysqlInit = false
local maintenance = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CACHE
-----------------------------------------------------------------------------------------------------------------------------------------
local cacheQuery = {}
local cachePrepare = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERDBDRIVER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.registerDBDriver(name,on_init,on_prepare,on_query)
	if not userSql[name] then
		userSql[name] = { on_init,on_prepare,on_query }
		mysqlDriver = userSql[name]
		mysqlInit = true

		for _,prepare in pairs(cachePrepare) do
			on_prepare(table.unpack(prepare,1,table.maxn(prepare)))
		end

		for _,query in pairs(cacheQuery) do
			query[2](on_query(table.unpack(query[1],1,table.maxn(query[1]))))
		end

		cachePrepare = {}
		cacheQuery = {}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETXT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateTxt(archive,text)
	archive = io.open("resources/logsystem/"..archive,"a")
	if archive then
		archive:write(text.."\n")
	end

	archive:close()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.prepare(name,query)
	if mysqlInit then
		mysqlDriver[2](name,query)
	else
		table.insert(cachePrepare,{ name,query })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.query(name,params,mode)
	if not mode then mode = "query" end

	if mysqlInit then
		return mysqlDriver[3](name,params or {},mode)
	else
		local r = async()
		table.insert(cacheQuery,{{ name,params or {},mode },r })
		return r:wait()
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXECUTE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.execute(name,params)
	return vRP.query(name,params,"execute")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFOACCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.infoAccount(steam)
	local infoAccount = vRP.query("accounts/getInfos",{ steam = steam })
	if infoAccount[1] then
		return infoAccount[1]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userData(user_id,key)
	local consult = vRP.query("playerdata/getUserdata",{ user_id = parseInt(user_id), key = key })
	if consult[1] then
		return json.decode(consult[1]["dvalue"])
	else
		return {}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOMEPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateHomePosition(user_id,x,y,z)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable then
		dataTable["position"] = { x = mathLegth(x), y = mathLegth(y), z = mathLegth(z) }
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userInventory(user_id)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable then
		if dataTable["inventory"] == nil then
			dataTable["inventory"] = {}
		end

		return dataTable["inventory"]
	end

	return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUSERINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setUserInventory(user_id,inv)
    local dataTable = vRP.getDatatable(user_id)
    if dataTable then
        dataTable["inventory"] = inv
    end

    return dataTable["inventory"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESELECTSKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateSelectSkin(user_id,hash)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable then
		dataTable["skin"] = hash
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERID
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUserId(source)
	return vRP.userIds[parseInt(source)]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userList()
	return vRP.userSources
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.userPlayers()
	return vRP.userIds
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERSOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userSource(user_id)
	return vRP.userSources[parseInt(user_id)]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getDatatable(user_id)
	return vRP.userTables[parseInt(user_id)]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function saveTables()
	SetTimeout(60000,saveTables)
	for k,v in pairs(vRP.userTables) do
		vRP.execute("playerdata/setUserdata",{ user_id = parseInt(k), key = "Datatable", value = json.encode(v) })
	end
end

async(function()
	saveTables()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function(reason)
	playerDropped(source,reason)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.kick(user_id,reason)
	local userSource = vRP.userSource(user_id)
	if userSource then
		playerDropped(userSource,"Kick/Afk")
		DropPlayer(userSource,reason)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
function playerDropped(source,reason)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataTable = vRP.getDatatable(user_id)
		if dataTable then
			TriggerEvent("vRP:playerLeave",user_id,source)
			exports["common"]:Log().embedDiscord(user_id,"usuario-desconectou","Desconectou-se às "..os.date("%d/%m/%y %H:%M:%S"))
			vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Datatable", value = json.encode(dataTable) })
			vRP.userSources[parseInt(user_id)] = nil
			vRP.userTables[parseInt(user_id)] = nil
			vRP.userIds[parseInt(source)] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEINFORMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.userUpdate(pArmour,pHealth,pCoords)
	local source = source
	if Player(source).state.inArena then 
		return false
	end
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataTable = vRP.getDatatable(user_id)
		if dataTable then
			dataTable["armour"] = parseInt(pArmour)
			dataTable["health"] = parseInt(pHealth)
			dataTable["position"] = { x = mathLegth(pCoords["x"]), y = mathLegth(pCoords["y"]), z = mathLegth(pCoords["z"]) }
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEUSER
-----------------------------------------------------------------------------------------------------------------------------------------
local function createUser(steam)
	local accountQuery = exports.oxmysql:query_async("SELECT `whitelist` FROM `accounts` WHERE `steam` = @steam",{ steam = steam })
	if #accountQuery <= 0 then
		exports.oxmysql:query("INSERT INTO `accounts` (`steam`) VALUES (@steam)",{ steam = steam })
		return false
	end

	if accountQuery[1].whitelist == 1 then
		return true
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
local tkn = "Bot "..KADOKASODKASOKDOASKD
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDAPIREQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
local function discordAPIRequest(method,endpoint,jsonData)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = { data = resultData, code = errorCode, headers = resultHeaders}
    end, method, #jsonData > 0 and json.encode(jsonData) or "", {["Content-Type"] = "application/json", ["Authorization"] = tkn })

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISINDISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
local function isInDiscord(discordId)
    if discordId then
        local endpoint = ("guilds/%s/members/%s"):format(GUILD_ID,discordId)
        local member = discordAPIRequest("GET",endpoint,{})
        if member.code == 200 then
			return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Queue:playerConnecting",function(source,identifiers,deferrals)
	local src = source
	local steam = vRP.getSteamBySource(source)
	if not steam then
		deferrals.done("[WRENCH] Não foi possível encontrar sua Steam.")
		TriggerEvent("Queue:removeQueue",identifiers)
		return
	end

	-- local discord = vRP.getDiscordBySource(source)
	-- if not discord then
	-- 	deferrals.done("[WRENCH] Não foi possível encontrar seu Discord.")
	-- 	TriggerEvent("Queue:removeQueue",identifiers)
	-- 	return
	-- end

	-- local isInDiscord = isInDiscord(discord)
	-- if not isInDiscord then
	-- 	deferrals.done("[WRENCH] Entre em nosso discord para conseguir jogar! discord.gg/baixada")
	-- 	TriggerEvent("Queue:removeQueue",identifiers)
	-- 	return
	-- end

	if maintenance then
		local isSudo = exports.oxmysql:query_async("SELECT `sudo` FROM `accounts` WHERE `steam` = @steam",{ steam = steam })
		if #isSudo <= 0 or isSudo[1].sudo == 0 then
			deferrals.done("[WRENCH] Servidor em manutenção.")
			TriggerEvent("Queue:removeQueue",identifiers)
			return
		end
	end

	local whitelisted = createUser(steam)
	if not whitelisted then
		deferrals.done("[WRENCH] Envie sua steam na sala de liberação: "..steam)
		TriggerEvent("Queue:removeQueue",identifiers)
		return
	end

	exports.oxmysql:query("UPDATE `accounts` SET `last_login` = NOW(), `endpoint` = @endpoint WHERE `steam` = @steam",{ steam = steam, endpoint = (GetPlayerEndpoint(source) or "0.0.0.0") })
	deferrals.done()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.characterChosen(source,user_id,model)
	vRP.userIds[source] = user_id
	vRP.userSources[user_id] = source
	vRP.userTables[user_id] = vRP.userData(user_id,"Datatable")

	if model ~= nil then
		vRP.userTables[user_id]["backpack"] = 25
		vRP.userTables[user_id]["inventory"] = {}
		vRP.generateItem(user_id,"water",3,false)
		vRP.generateItem(user_id,"sandwich",3,false)
		vRP.generateItem(user_id,"cellphone",1,false)

		vRP.userTables[user_id]["skin"] = GetHashKey(model)
	end

	local identity = vRP.userIdentity(user_id)
	if identity["serial"] == nil then
		vRP.execute("characters/setSerial",{ user_id = user_id, serial = vRP.generateSerial() })
	end

	TriggerEvent("vRP:playerSpawn",user_id,source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetGameType("BAIXADA")
	SetMapName("BAIXADA")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBANNED REPLACEMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setBanned(userId,banned)
	if banned then
		vRP.kick(userId,"Seu acesso a comunidade foi revogado permanentemente por suspeita de trapaça.")
		exports["common"]:Ban().intelligence(userId,10,0)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPLACEMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.hasPermission(userId,permission)
	if permission == '$verified' then
		return exports["store"]:Buyers().isBuyerById(userId,"verified")
	end
	return exports["common"]:Group().hasPermission(userId,permission)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERSBYPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUsersByPermission(perm)
	return exports["common"]:Group().getAllByPermission(perm)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINS CONTROL
-----------------------------------------------------------------------------------------------------------------------------------------
local block_actions_skins = {
	[`baby`] = true,[`baby`] = true,[`baby2`] = true,[`baby3`] = true,[`Baby-67`] = true,[`BabyCaioG`] = true,[`Baby-dresses`] = true,[`BabyEnzoP`] = true,[`BabyFloraG`] = true,
	[`babyflorenciahkmods`] = true,[`baby-girl12`] = true,[`baby-girl56`] = true,[`BabyHenryG`] = true,[`babylari`] = true,[`BabyLuizaG`] = true,[`babyluna`] = true,[`BabyMaite`] = true,
	[`babymarquinhoshkmods`] = true,[`BabySolG`] = true,[`babythiagohkmods`] = true,[`baby-unicorn6`] = true,[`Dante`] = true,[`FB11_Bombom_TBMODSG`] = true,[`FB13_Manu_TBMODSG`] = true,
	[`FB29_Linda_TBMODB`] = true,[`FJ11_Jade_TBMODSB`] = true,[`Gui-Baby`] = true,[`Gui-baby2`] = true,[`KidHugoP`] = true,[`KidYumiY_SMALLER`] = true,[`MJ02_Wrench_TBMODSB`] = true,[`MS_MODS_babygui`] = true,[`MS_MODS_babymykaella`] = true,
	[`MT05_Henry_TBMODSG`] = true,[`MT33_Maju_TBMODSB`] = true,[`Sofia-Baby`] = true,[`TeenThomas`] = true,[`chucky`] = true,[`BabyBoyKaduBlack`] = true,[`babysofia01`] = true,[`babysofia02`] = true,
	[`MS_MODS_babypietra`] = true,[`baby-maite`] = true,[`BabyAurora`] = true,[`MS_MODS_babygabriela`] = true,[`NEWBORN_Lany_MS-MODS`] = true,[`NEWBORN_Lucas_MS-MODS`] = true,[`babylimaof`] = true,
	[`babylimaoM`] = true,[`BabyAurora`] = true,[`MS_MODS_newbornlucas`] = true,[`MS_MODS_newbornlany`] = true,[`MS_MODS_babyfox`] = true,[`mf18_noah_thebestmodsb`] = true,
	[`MS_MODS_babyemma`] = true,[`MT33_Maju2_TBMODSB`] = true,[`MS_MODS_babyluanav6`] = true,[`MS_MODS_babymika`] = true,[`MS_MODS_babyluanav5`] = true,[`MS_MODS_babykatyv2`] = true,
	[`MS_MODS_babyolivia`] = true,[`BabyGirlPhelps`] = true,[`BabyBoyPhelps`] = true,[`Baby-girl109`] = true,[`BabyMatheus`] = true,[`babygael`] = true,[`MS_MODS_babyluiza4`] = true,[`MS_MODS_babylucas`] = true,[`MS_MODS_babylany`] = true,[`babylimao4`] = true,
	[`babylimao3`] = true,[`babylimao2`] = true,[`babylimao1`] = true,[`MS_MODS_babymikav1`] = true,[`MS_MODS_babyjadev7`] = true,[`MS_MODS_babyclara`] = true,[`MS_MODS_babytheo`] = true,[`LoLo`] = true,[`anitaoti`] = true,[`MS_MODS_fofuxocorinthiasv1`] = true,
	[`BabyMelissaM`] = true,[`QueenMods_BabySophie`] = true,[`QueenMods_BabyTH`] = true,[`BabyCandyMelissa`] = true,
}

function vRP.userIsBaby(user_id)
	local src = vRP.userSource(user_id)
	if src then 
		local model = GetEntityModel(GetPlayerPed(src))
		if block_actions_skins[model] then 
			return true 
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MANUTENÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("manutencao",function(source,args,rawCmd)
	if source ~= 0 then
		return
	end

	maintenance = not maintenance
	if maintenance then
		print("[^2MANUTENÇÃO^7] Manutenção ativada.")
	else
		print("[^2MANUTENÇÃO^7] Manutenção desativada.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCE
-----------------------------------------------------------------------------------------------------------------------------------------
function updateMaintenance(status)
	maintenance = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUsersByDimension(dimension)
    local users_in_dimension = {}

    local users = vRP.userList()
    for id,src in pairs(users) do
        if GetPlayerRoutingBucket(src) == dimension then
			table.insert(users_in_dimension,tonumber(id))
		end
    end
	return users_in_dimension
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("updateMaintenance",updateMaintenance)

vRP.getUserSource = vRP.userSource
vRP.getUserIdentity = vRP.userIdentity