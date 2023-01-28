local quarentine = false
local quarentineStatus = {}
local usersLocked = {}
local renameWebhook = "https://discord.com/api/webhooks/1053911234115813396/Hqnn-GtExLVYckYu0nsmRoZploj7EDmdP6a4_B1_eJ3T8OCo2aQ5iIyO7TCtcVAIqzRQ"

RegisterCommand("kickall",function(source,args,rawCommand)
    if source ~= 0 then
        return
    end

    print("[^1Session^7] Iniciando o sistema de desligamento.")
    print("[^1Session^7] Modo manutenção ativado.")
	exports["vrp"]:updateMaintenance(true)

	local playerList = vRP.userList()
	for k,v in pairs(playerList) do
		vRP.kick(k,"[BXD] Você foi desconectado(a), pois o servidor foi reiniciado.")
		Citizen.Wait(100)
	end
	
	TriggerEvent("admin:KickAll")
end)

AddEventHandler("vRP:playerSpawn",function(userId,source)
	local steam = vRP.getSteamBySource(source)
	local identity = vRP.userIdentity(userId)
	if not identity then
		return
	end

	local discordQuery = exports.oxmysql:query_async("SELECT `discord` FROM `accounts` WHERE `steam` = @steam AND `discord` IS NOT NULL",{ steam = steam })
	if #discordQuery > 0 then
		PerformHttpRequest(renameWebhook, function(err, text, headers)
		end, 'POST', json.encode({ content = discordQuery[1].discord.." "..userId.." "..identity.name.." "..identity.name2 }), { ['Content-Type'] = 'application/json' })
	end

	--TriggerClientEvent("Notify",source,"default","<b>"..identity.surname.."</b>, esperamos que você se divirta muito.",30000,"center","SEJA BEM-VINDO(A)!")

    if quarentine then
        if usersLocked[userId] then
            usersLocked[userId].src = source
            repeat
                SetPlayerRoutingBucket(source,parseInt(userId))
                Citizen.Wait(500)
            until GetPlayerRoutingBucket(source) == parseInt(userId)
            
            TriggerClientEvent("Notify",source,"default","Você foi adicionado(a) à <b>quarentena</b>, pois se encaixou em uma lista de jogadores suspeitos de cheating. Aguarde enquanto realizamos algumas verificações e não desconecte-se do servidor.",60000,"normal","atenção")
        end
    end
end)

RegisterCommand("deleteall",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end

    if not args[1] then
        return
    end

    if args[1] == "objects" then
        for _i,item in pairs(GetAllObjects()) do
            DeleteEntity(item)
        end
        TriggerClientEvent("Notify",source,"default","Todos os objetos foram deletados com sucesso.",10000,"normal","atenção")
    elseif args[1] == "npcs" then
        for _,pedHandle in pairs(GetAllPeds()) do
            DeleteEntity(pedHandle)
        end
        TriggerClientEvent("Notify",source,"default","Todos os npcs foram deletados com sucesso.",10000,"normal","atenção")
    -- elseif args[1] == "vehicles" then
    --     for _,vehicles in pairs(GetAllVehicles()) do
    --         DeleteEntity(vehicles)
    --     end
    --     TriggerClientEvent("Notify",source,"default","Todos os veículos foram deletados com sucesso.",10000,"normal","atenção")
    end
end)

local function format(time)
    local days = math.floor(time/86400)
    local hours = math.floor(math.fmod(time, 86400)/3600)
    local minutes = math.floor(math.fmod(time,3600)/60)
    local seconds = math.floor(math.fmod(time,60))
    if days > 0 then
        return string.format("%d dia(s) e %d hora(s)",days,hours)
    elseif hours > 0 then
        return string.format("%d hora(s) e %d minuto(s)",hours,minutes)
    elseif minutes > 0 then        
        return string.format("%d minuto(s) e %d segundos",minutes,seconds)
    else
        return string.format("%d segundos",seconds)
    end
end

local function quarentineSessionMove()
    local playerList = vRP.userList()
	for id,src in pairs(playerList) do
        local steam = vRP.getSteamBySource(src)
        if not steam then
            return
        end

		local query = exports.oxmysql:query_async("SELECT `time_played` FROM `accounts` WHERE `steam` = @steam AND `time_played` < 86400",{ steam = steam })
        if #query > 0 then
            usersLocked[id] = { steam = steam, src = src }

            repeat
                SetPlayerRoutingBucket(src,id)
                Citizen.Wait(100)
            until GetPlayerRoutingBucket(src) == id

            TriggerClientEvent("Notify",src,"default","Você foi adicionado(a) à <b>quarentena</b>, pois se encaixou em uma lista de jogadores suspeitos de cheating. Aguarde enquanto realizamos algumas verificações e não desconecte-se do servidor.",60000,"normal","atenção")
            
            exports["common"]:Log().embedDiscord(id,"quarentena","**ATIVIDADE SUSPEITA**\nUsuário com pouco tempo de jogo.\n\nTempo de jogo: "..format(query[1].time_played).."\nInício da quarentena: "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        end
	end
end

local function quarentineSessionRemove()
    for k,v in pairs(usersLocked) do
        TriggerClientEvent("Notify",v.src,"sucesso","Você foi removido(a) da <b>quarentena</b>, desculpe o incoveniente.",15000,"bottom")
        usersLocked[k] = nil
    end
end 

RegisterNetEvent("admin:quarentineSystem")
AddEventHandler("admin:quarentineSystem",function()
    local source = source
    local userId = vRP.getUserId(source)
    local identity = vRP.userIdentity(userId)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end
    
    TriggerClientEvent("dynamic:closeSystem",source)

    if not quarentine and vRP.request(source,"Você deseja iniciar a quarentena?",30) then
        quarentine = true
        quarentineStatus = { admin = userId, started_at = os.time() }
        exports["common"]:Log().embedDiscord(userId,"quarentena-admin","**QUARENTENA INICIADA**.\n\nID: "..quarentineStatus.admin.."\nInício da quarentena: "..os.date("%d/%m/%y %H:%M:%S", quarentineStatus.started_at),8686827)
        Citizen.Wait(1000)
        local adminCount = exports["common"]:Group().getAllByPermission("staff")
        for k,v in pairs(adminCount) do
            async(function()
                TriggerClientEvent("Notify",v,"sucesso","Quarentena ativada por <b>"..identity.surname.."</b>",20000,"bottom")
            end)
        end

        quarentineSessionMove()
    else
        if quarentine and vRP.request(source,"Você deseja finalizar a quarentena?",30) then
            quarentine = false
            exports["common"]:Log().embedDiscord(userId,"quarentena-admin","**QUARENTENA FINALIZADA**.\n\nID: "..quarentineStatus.admin.."\nInício da quarentena: "..os.date("%d/%m/%y %H:%M:%S", quarentineStatus.started_at).."\nFinal da quarentena: "..os.date("%d/%m/%y %H:%M:%S").."\nTempo de duração: "..format(os.time()-quarentineStatus.started_at),8686827)
            Citizen.Wait(1000)
            local adminCount = exports["common"]:Group().getAllByPermission("staff")
            for k,v in pairs(adminCount) do
                async(function()
                    TriggerClientEvent("Notify",v,"sucesso","Quarentena desativada por <b>"..identity.surname.."</b>",20000,"bottom")
                end)
            end
            
            quarentineSessionRemove()
            usersLocked = {}
            quarentineStatus = {}
        end
    end

end)

RegisterNetEvent("admin:quarentineList")
AddEventHandler("admin:quarentineList",function()
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end
    
    if not quarentine then
        return
    end

    if quarentine then
        local str = ""
        for k,v in pairs(usersLocked) do
            str = str.."<br><b>ID:</b> "..k.." | <b>Tempo de jogo:</b> "..exports["common"]:PlayedTime().get(v.steam).." | <b>Online:</b> "..(vRP.userSource(targetId) and "Não" or "Sim")
            exports["common"]:Log().embedDiscord(userId,"quarentena-lista","**QUARENTENA FINALIZADA**.\n\nID: "..quarentineStatus.admin.."\nInício da quarentena: "..os.date("%d/%m/%y %H:%M:%S", quarentineStatus.started_at).."\nFinal da quarentena: "..os.date("%d/%m/%y %H:%M:%S").."\nTempo de duração: "..format(os.time()-quarentineStatus.started_at),8686827)
        end

        TriggerClientEvent("Notify",source,"default","Usuários em quarentena:<br>"..str,30000,"normal","atenção")
    else
        TriggerClientEvent("Notify",source,"negado","Nenhum usuário em <b>quarentena</b>.",10000,"bottom")
    end
end)

RegisterNetEvent("admin:quarentineCheck")
AddEventHandler("admin:quarentineCheck",function()
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end
    
    if not quarentine then
        return
    end
    
    TriggerClientEvent("dynamic:closeSystem",source)
    
    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local targetId = vRP.getUserId(parseInt(targetId))
    if usersLocked[targetId] then
        TriggerClientEvent("Notify",source,"sucesso","<b>ID:</b> "..targetId.." | <b>Tempo de jogo:</b> "..exports["common"]:PlayedTime().get(usersLocked[targetId].steam).." | <b>Online:</b> "..(vRP.userSource(targetId) and "Não" or "Sim"))
    else
        TriggerClientEvent("Notify",source,"sucesso","Status da quarentena: <b>Desativada</b>.",15000,"bottom")
    end
end)

RegisterNetEvent("admin:quarentineAdd")
AddEventHandler("admin:quarentineAdd",function()
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end
    
    if not quarentine then
        return
    end

    TriggerClientEvent("dynamic:closeSystem",source)
    
    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end
    
    local targetId = parseInt(targetId)
    local targetSource = vRP.userSource(targetId)
    if not targetSource then
        return
    end

    if not usersLocked[targetId] then
        if vRP.request(source,"Você deseja adicionar o Usuário <b>"..targetId.."</b> na quarentena?",30) then
            local steam = vRP.getSteamBySource(targetSource)
            if not steam then
                return
            end

            usersLocked[targetId] = { steam = steam, src = targetSource } 
            repeat
                SetPlayerRoutingBucket(targetSource,parseInt(targetId))
                Citizen.Wait(100)
            until GetPlayerRoutingBucket(targetSource) == parseInt(targetId)
            
            TriggerClientEvent("Notify",targetSource,"default","Você foi adicionado(a) à <b>quarentena</b>, pois se encaixou em uma lista de jogadores suspeitos de cheating. Aguarde enquanto realizamos algumas verificações e não desconecte-se do servidor.",60000,"normal","atenção")
            
            exports["common"]:Log().embedDiscord(targetId,"quarentena","**ATIVIDADE SUSPEITA**\nUsuário com pouco tempo de jogo.\n\nTempo de jogo: "..exports["common"]:PlayedTime().get(steam).."\nInício da quarentena: "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        end
    end
end)

RegisterNetEvent("admin:quarentineRemove")
AddEventHandler("admin:quarentineRemove",function()
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end
    
    if not quarentine then
        return
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local targetId = parseInt(targetId)
    if usersLocked[targetId] then
        if vRP.request(source,"Você deseja remover o Usuário <b>"..targetId.."</b> da quarentena?",30) then
            
            local targetSource = vRP.userSource(targetId)
            if targetSource then
                repeat
                    SetPlayerRoutingBucket(usersLocked[targetId].src,0)
                    Citizen.Wait(100)
                until GetPlayerRoutingBucket(usersLocked[targetId].src) == 0

                TriggerClientEvent("Notify",usersLocked[targetId].src,"sucesso","Você foi removido(a) da <b>quarentena</b>, desculpe o incoveniente.",15000,"bottom")
            end
            usersLocked[targetId] = nil
        end
    end
end)

RegisterNetEvent("admin:quarentineStatus")
AddEventHandler("admin:quarentineStatus",function()
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end
    
    if quarentine then
        TriggerClientEvent("Notify",source,"sucesso","Status da quarentena: <b>Ativada</b>.",15000,"bottom")
    else
        TriggerClientEvent("Notify",source,"sucesso","Status da quarentena: <b>Desativada</b>.",15000,"bottom")
    end
end)

RegisterCommand("sessao",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end
    
    if args[1] and args[2] then
        local targetId = parseInt(args[1])
        if targetId > 0 then
            local targetSource = vRP.userSource(targetId)
            if targetSource then
                SetPlayerRoutingBucket(targetSource,parseInt(args[2]))
                Player(targetSource).state.session = parseInt(args[1])
                TriggerClientEvent("Notify",source,"sucesso","Você enviou o usuário para a sessão <b>"..parseInt(args[2]).."</b>",10000,"bottom")
                TriggerClientEvent("Notify",targetSource,"sucesso","Um(a) Administrador(a) moveu você para sessão <b>"..parseInt(args[2]).."</b>",10000,"bottom")
            else
                TriggerClientEvent("Notify",source,"negado","Usuário desconectado.",10000,"bottom")
            end
        end
    elseif args[1] then
        SetPlayerRoutingBucket(source,parseInt(args[1]))
        Player(source).state.session = parseInt(args[1])
        TriggerClientEvent("Notify",source,"sucesso","Você entrou na sessão <b>"..parseInt(args[1]).."</b>",10000,"bottom")
    else
        SetPlayerRoutingBucket(source,0)
        Player(source).state.session = 0
        TriggerClientEvent("Notify",source,"sucesso","Você voltou para a sessão <b>0</b>",10000,"bottom")
        return 
    end
end)

RegisterCommand("vsessao",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end
    
    if not args[1] then
        return 
    end

    local targetSource = vRP.userSource(parseInt(args[1]))
    if not targetSource then
        return
    end

    TriggerClientEvent("Notify",source,"default","O usuário <b>"..parseInt(args[1]).."</b> está na sessão <b>"..GetPlayerRoutingBucket(targetSource).."<b>",15000,"normal","atenção")
end)