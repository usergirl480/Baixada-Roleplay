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
Tunnel.bindInterface("admin",cRP)
vCLIENT = Tunnel.getInterface("admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			if args[1] then
				local nuser_id = parseInt(args[1])
				local otherPlayer = vRP.userSource(nuser_id)
				if otherPlayer then
					--vRPC.setArmour(otherPlayer,100)
					vRP.upgradeThirst(nuser_id,100)
					vRP.upgradeHunger(nuser_id,100)
					vRP.downgradeStress(nuser_id,100)
					vRPC.revivePlayer(otherPlayer,200)
					TriggerClientEvent("resetBleeding",otherPlayer)
					TriggerClientEvent("resetDiagnostic",otherPlayer)
					exports["common"]:Log().embedDiscord(user_id,"commands-god","**ID:**```"..nuser_id.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
				end
			else
				--vRPC.setArmour(source,100)
				vRPC.revivePlayer(source,200)
				vRP.upgradeThirst(user_id,100)
				vRP.upgradeHunger(user_id,100)
				vRP.downgradeStress(user_id,100)
				TriggerClientEvent("resetHandcuff",source)
				TriggerClientEvent("resetBleeding",source)
				TriggerClientEvent("resetDiagnostic",source)
				exports["common"]:Log().embedDiscord(user_id,"commands-god","**ID:**```"..user_id.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("baby",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasAccessOrHigher(user_id,"ceo") then
			if args[1] then
				local nuser_id = parseInt(args[1])
				local otherPlayer = vRP.userSource(nuser_id)
				local identity = vRP.userIdentity(nuser_id)
				if otherPlayer and identity then
					if vRP.request(source,"Você deseja adicionar 30 dias de <b>VIP Baby</b> para <b>"..nuser_id.."</b>?",15) then
						exports["store"]:Appointments().generateVipPerDays({ steam = identity.steam, category = "baby", timeInDays = 30, priority = 100, max_chars = 2 })
						exports["common"]:Log().embedDiscord(user_id,"commands-vip","**VIP:**```baby```\nVIP ativado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
						TriggerClientEvent("Notify",source,"sucesso","<b>VIP Baby</b> adicionado.",10000,"bottom")
						TriggerClientEvent("Notify",otherPlayer,"sucesso","<b>VIP Baby</b> ativado.",10000,"bottom")
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasAccessOrHigher(user_id,"admin") then
			if args[1] and args[2] and itemBody(args[1]) ~= nil then
				vRP.generateItem(user_id,args[1],parseInt(args[2]),true)
				exports["common"]:Log().embedDiscord(user_id,"commands-item","**ITEM:**```"..args[1].."```\n**QTD:**```"..parseInt(args[2]).."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delete",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] then
		if exports["common"]:Group().hasAccessOrHigher(user_id,"dev") then
			local nuser_id = parseInt(args[1])
			vRP.execute("characters/removeCharacters",{ id = nuser_id })
			TriggerClientEvent("Notify",source,"sucesso","Personagem <b>"..nuser_id.."</b> deletado.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("nc",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			if not vRPC.inVehicle(source) then
				vRPC.noClip(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") and parseInt(args[1]) > 0 then
			TriggerClientEvent("Notify",source,"importante","Passaporte <b>"..args[1].."</b> expulso.",5000)
			vRP.kick(args[1],"Expulso da cidade.")
			exports["common"]:Log().embedDiscord(user_id,"commands-kick","**ID:**```"..args[1].."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if userId then
		if exports["common"]:Group().hasPermission(userId,"staff") then
			local targetId = vRP.prompt(source,"Passaporte:","")
			if targetId == "" then return end
			targetId = parseInt(targetId)

			local punishId = vRP.prompt(source,"ID da punição:","")
			if punishId == "" then return end
			punishId = parseInt(punishId)

			exports["common"]:Ban().intelligence(targetId,punishId,userId)
			exports["common"]:Log().embedDiscord(userId,"commands-ban","**ID:**```"..targetId.."```\n**ID DA PUNIÇÃO:**```"..parseInt(punishId).."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if userId then
		if exports["common"]:Group().hasPermission(userId,"staff") then
			local targetId = vRP.prompt(source,"Passaporte:","")
			if targetId == "" then return end
			targetId = parseInt(targetId)

			local steam = vRP.getSteam(targetId)

			exports.oxmysql:query("UPDATE `bans` SET `is_active` = false WHERE `steam` = @steam",{ steam = steam })
			exports["common"]:Log().embedDiscord(userId,"commands-unban","**ID:**```"..targetId.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> desbanido.")
			exports["common"]:Ban().load()
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			local fcoords = vRP.prompt(source,"Cordenadas:","")
			if fcoords == "" then
				return
			end

			local coords = {}
			for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
				table.insert(coords,parseInt(coord))
			end

			vRPC.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			vRP.prompt(source,"Cordenadas:",mathLegth(coords.x)..","..mathLegth(coords.y)..","..mathLegth(coords.z)..","..mathLegth(heading))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds2",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			vRP.prompt(source,"Cordenadas:","x = "..mathLegth(coords.x)..", y = "..mathLegth(coords.y)..", z = "..mathLegth(coords.z))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if not exports["common"]:Group().hasPermission(user_id,"staff") then
			return
		end

		if not args[1] or not args[2] then return end
		local cant_user = not exports["common"]:Group().hasAccessOrHigher(user_id,args[2]:lower(),true)
		if (cant_user) then
			return TriggerClientEvent("Notify",source,"negado","Você não pode adicionar este grupo.")
		end

		exports["common"]:Group().add(parseInt(args[1]),args[2]:lower(),user_id)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if not exports["common"]:Group().hasAccessOrHigher(user_id,"admin") then
			return
		end

		if not args[1] or not args[2] then
			return
		end

		local cant_user = not exports["common"]:Group().hasAccessOrHigher(user_id,args[2]:lower(),true)
		if (cant_user) then
			return TriggerClientEvent("Notify",source,"negado","Você não pode remover este grupo.")
		end
		
		exports["common"]:Group().remove(parseInt(args[1]),args[2],user_id)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") and parseInt(args[1]) > 0 then
			local otherPlayer = vRP.userSource(args[1])
			if otherPlayer then
				if exports.common:checkHidden(otherPlayer) then
					if user_id ~= 1 and user_id ~= 4 then
						return
					else
						TriggerClientEvent("Notify",source,"sucesso","Você teleportou-se para um jogador escondido.")
					end
				end
				
				local ped = GetPlayerPed(source)
				local coords = GetEntityCoords(ped)

				vRPC.teleport(otherPlayer,coords["x"],coords["y"],coords["z"])
				exports["common"]:Log().embedDiscord(user_id,"commands-tptome","**ID:**```"..args[1].."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") and parseInt(args[1]) > 0 then
			local otherPlayer = vRP.userSource(args[1])
			if otherPlayer then
				if exports.common:checkHidden(otherPlayer) then
					if user_id ~= 1 and user_id ~= 4 then
						return
					else
						TriggerClientEvent("Notify",source,"sucesso","Você teleportou-se para um jogador escondido.")
					end
				end

				local ped = GetPlayerPed(otherPlayer)
				local coords = GetEntityCoords(ped)

				vRPC.teleport(source,coords["x"],coords["y"],coords["z"])
				exports["common"]:Log().embedDiscord(user_id,"commands-tpto","**ID:**```"..args[1].."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			end
		end
	end
end)

RegisterCommand("godmode",function(source,args,rawCmd)
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"dev") or user_id == 4 then
        return
    end
    
    TriggerClientEvent("bxd-misc:admin:toggleGodmode",source)
end)

RegisterCommand("flash",function(source,args,rawCmd)
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"dev") then
        return
    end
    
    TriggerClientEvent("bxd-misc:admin:toggleFlash",source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			vCLIENT.teleportWay(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptoway",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and exports["common"]:Group().hasPermission(user_id,"staff") then 
		if not args[1] or parseInt(args[1]) <= 0 then
			return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
		end

		local otherPlayer = vRP.userSource(parseInt(args[1]))
		if otherPlayer then
			vCLIENT.teleportWay(otherPlayer)
			TriggerClientEvent("Notify",otherPlayer,"sucesso","Você foi teletransportado(a) por um(a) Administrador(a).",20000,"bottom")
		else
			TriggerClientEvent("Notify",source,"negado","Usuário desconectado.",10000,"bottom")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(source) <= 101 then
		vCLIENT.teleportLimbo(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hash",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			local vehicle = vRPC.vehicleHash(source)
			if vehicle then
				exports["common"]:Log().embedDiscord(user_id,"dev","**HASH:**```"..vehicle.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasAccessOrHigher(user_id,"admin") then
			TriggerClientEvent("admin:vehicleTuning",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			local vehicle,vehNet,vehPlate,vehName = vRPC.vehList(source,10)
			if vehicle then
				TriggerClientEvent("inventory:repairAdmin",-1,vehNet,vehPlate)
				exports["common"]:Log().embedDiscord(user_id,"commands-fix","**VEÍCULO:**```"..vehName.."```\n**PLACA:**```"..vehPlate.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limpararea",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)

			TriggerClientEvent("syncarea",-1,coords["x"],coords["y"],coords["z"],100)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("players",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			TriggerClientEvent("Notify",source,"importante","<b>Jogadores Conectados:</b> "..GetNumPlayerIndices(),5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.buttonTxt()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasAccessOrHigher(user_id,"dev") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			vRP.updateTxt(user_id..".txt",mathLegth(coords.x)..","..mathLegth(coords.y)..","..mathLegth(coords.z)..","..mathLegth(heading))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSOLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("console",function(source,args,rawCommand)
	if source == 0 then
		-- TriggerClientEvent("hub:sendNotification",-1,"warning","<b>Notificação</b>",rawCommand:sub(9),true)
		TriggerClientEvent("Notify",-1,"default",rawCommand:sub(9).."<br><b>Enviado por:</b> WRENCH",60000,"center","anúncio")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("itemall",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasAccessOrHigher(user_id,"dev") then
			local playerList = vRP.userList()
			for k,v in pairs(playerList) do
				async(function()
					vRP.generateItem(k,tostring(args[1]),parseInt(args[2]),true)
				end)
			end

			TriggerClientEvent("Notify",source,"sucesso","Envio concluído.",10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBITO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("obito",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and exports["common"]:Group().hasPermission(user_id,"staff") then 
		if not args[1] or parseInt(args[1]) <= 0 then
			return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
		end

		local otherPlayer = vRP.userSource(parseInt(args[1]))
		if otherPlayer then 
			local death = vRPC.getDeath(otherPlayer)
			if not death then 
				TriggerClientEvent("Notify",source,"negado","Este usuário não está morto.",10000,"bottom")
				return 
			end
			vRPC.resetDeath(otherPlayer)
			TriggerClientEvent("Notify",otherPlayer,"sucesso","Você recebeu óbito de um(a) Administrador(a).",20000,"bottom")
		else
			TriggerClientEvent("Notify",source,"negado","Usuário desconectado.",10000,"bottom")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEGUIDORES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("seguidores",function(source,args,rawCmd)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and exports["common"]:Group().hasPermission(user_id,"dev") then
		local myInstagramId = exports.oxmysql:query_async("SELECT id FROM smartphone_instagram WHERE user_id = ?", { user_id })
		if #myInstagramId <= 0 then return end

		local instagramUsersQuery = exports.oxmysql:query_async("SELECT id FROM smartphone_instagram")
		for k,v in pairs(instagramUsersQuery) do
			if myInstagramId[1].id ~= v.id then
				local alreadyFollowQuery = exports.oxmysql:query_async("SELECT * FROM smartphone_instagram_followers WHERE `profile_id` = ? AND `follower_id` = ?", { myInstagramId[1].id, v.id })
				if #alreadyFollowQuery <= 0 then
					exports.oxmysql:query("INSERT INTO `smartphone_instagram_followers`(`follower_id`,`profile_id`) VALUES(?,?)",{ v.id, myInstagramId[1].id })
					print(v.id.." agora está te seguindo.")
				end
			end

			Citizen.Wait(50)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("voar",function(source,args,rawCmd)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and exports["common"]:Group().hasPermission(user_id,"dev") then
		if not args[1] then return end

		local targetSource = vRP.userSource(parseInt(args[1]))
		if targetSource then
			TriggerClientEvent("admin:makeFly",targetSource)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ney",function(source,args,rawCmd)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and exports["common"]:Group().hasPermission(user_id,"dev") then
		if not args[1] then return end

		local targetSource = vRP.userSource(parseInt(args[1]))
		if targetSource then
			TriggerClientEvent("admin:ragdoll",targetSource)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("neyarea",function(source,args,rawCmd)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and exports["common"]:Group().hasPermission(user_id,"dev") then
		local area = 8
		if args[1] then 
			area = parseInt(args[1]) 
		end

		local players = vRPC.nearestPlayers(source,area)
		for _,v in pairs(players) do
			TriggerClientEvent("admin:ragdoll",v[2])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fogo",function(source,args,rawCmd)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and exports["common"]:Group().hasPermission(user_id,"dev") or user_id == 4 then
		if not args[1] then return end

		local targetSource = vRP.userSource(parseInt(args[1]))
		if targetSource then
			TriggerClientEvent("admin:fire",targetSource)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fogoarea",function(source,args,rawCmd)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and exports["common"]:Group().hasPermission(user_id,"dev") then
		local area = 8
		if args[1] then 
			area = parseInt(args[1]) 
		end

		local players = vRPC.nearestPlayers(source,area)
		for _,v in pairs(players) do
			TriggerClientEvent("admin:fire",v[2])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("loja",function(source,args,rawCmd)
	local userId = vRP.getUserId(source)
	if userId then
		if exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
			TriggerClientEvent("skinshop:openShop",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("barbearia",function(source,args,rawCmd)
	local userId = vRP.getUserId(source)
	if userId then
		if exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
			TriggerClientEvent("barbershop:openShop",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TATTOOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tatuagem",function(source,args,rawCmd)
	local userId = vRP.getUserId(source)
	if userId then
		if exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
			TriggerClientEvent("tattoos:openShop",source)
		end
	end
end)