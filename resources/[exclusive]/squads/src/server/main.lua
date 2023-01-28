local squadsList = {}
local membersList = {}
local waitFrequency = {}

local function refreshMembers()
    local query = exports.oxmysql:query_async("SELECT `character_id`,`group` AS squad,`rank` as role FROM `groups` WHERE `rank` IS NOT NULL")
    for _,value in pairs(query) do
        if squadsList[value.squad] or value.squad == "waitpolice" or value.squad == "waitparamedic" then
            if value.squad == "waitpolice" then
                value.squad = "police"
            end

            if value.squad == "waitparamedic" then
                value.squad = "paramedic"
            end

            membersList[value.character_id] = { squad = value.squad, role = value.role }
        end
    end
end

local function refreshTable()
    squadsList = {}
    local query = exports.oxmysql:query_async("SELECT `squad`,`squad_name`,`category`,`radio_frequency`,`max_leaders`,`max_members` FROM `squads`")
    for _,value in pairs(query) do
        squadsList[value.squad] = { radio_frequency = value.radio_frequency, category = value.category, max_leaders = value.max_leaders, max_members = value.max_members }
        exports["common"]:Group().addSquad(value.squad,value.squad_name,value.category)
    end
    Wait(1000)
    refreshMembers()
end

local function hasAccess(userId)
    if membersList[userId] then
        return membersList[userId].role >= 2 and true or false
    end
    return false
end

Citizen.CreateThread(function()
    refreshTable()
end)

RegisterNetEvent("squads:refreshSquad",function()
    local source = source
    if source == 0 then
        refreshTable()
        return
    end

    local userId = vRP.getUserId(source)
    if userId and exports["common"]:Group().hasPermission(userId,"staff") then
        refreshTable()
        TriggerClientEvent("Notify",source,"sucesso","Squads atualizados.",10000,"bottom")
    end
end)

-- AddEventHandler("vRP:playerLeave",function(userId,source)
--     if membersList[userId] then 
--         if membersList[userId].squad == "waitpolice" then 
--             membersList[userId].squad = "police"
--         end
--     end
-- end)

RegisterCommand("squad",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if userId then
        local steam = vRP.getSteamBySource(source)
        if not membersList[userId] then
            return TriggerClientEvent("Notify",source,"negado","Você não faz parte de um squad.",10000,"bottom")
        end

        local _membersList = {}
        local _squadInfos = {
            {
                squad = membersList[userId].squad,
                radio = (squadsList[membersList[userId].squad].radio_frequency or 0),
                type = "Organização",
                ranks = {
                    [1] = "Membro",
                    [2] = "Gerente",
                    [3] = "Líder"
                }
            }
        }

        local query = exports.oxmysql:query_async([[
            SELECT groups.character_id, characters.name, characters.name2, accounts.last_login, squads.created_at
            FROM characters 
            INNER JOIN groups ON groups.group = @squad OR groups.group = @squad2
            INNER JOIN squads ON squads.squad = @squad
            INNER JOIN accounts ON characters.steam = accounts.steam
            WHERE groups.character_id = characters.id ORDER BY characters.name ASC
        ]],{ squad = membersList[userId].squad, squad2 = "wait"..membersList[userId].squad })
        
        for _,value in pairs(query) do                
            table.insert(_membersList,{
                name = (value.name.." "..value.name2) or "N/A",
                user_id = (value.character_id) or "N/A",
                group_rank = membersList[value.character_id] and (membersList[value.character_id].role-1) or 0,
                last_login = (os.date('%d/%m/%Y %H:%M', value.last_login/1000)) or "N/A",
                created_at = (os.date('%d/%m/%Y %H:%M', value.created_at/1000)) or "N/A",
                is_online = vRP.userSource(value.character_id) and true or false
            })
        end
        TriggerClientEvent("squads:openMenu",source,_membersList,_squadInfos)
    else
        print("[^1ERRO^7] Não foi possível encontrar o ID (?)")
    end
end)

RegisterNetEvent("squads:deleteSquad",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
            return
        end

        TriggerClientEvent("dynamic:closeSystem",source)

        local squadName = vRP.prompt(source,"Especifique o nome do Squad:","")
        if squadName == "" then return end

        local squadName = squadName:lower()
        if vRP.request(source,"Você deseja deletar o Squad <b>"..squadName.."</b>?",30) then
            exports.oxmysql:query("DELETE FROM `groups` WHERE `group` = @squadName",{ squadName = squadName })
            exports.oxmysql:query("DELETE FROM `squads` WHERE `squad` = @squadName",{ squadName = squadName })
            for k,v in pairs(membersList) do
                if v.squad == squadName then
                    membersList[k] = nil
                end
            end
            TriggerClientEvent("Notify",source,"sucesso","<b>"..squadName.."</b> deletado.",10000,"bottom")
            squadsList[squadName] = nil
        end
    end
end)

RegisterNetEvent("squads:createSquad",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
            return
        end

        TriggerClientEvent("dynamic:closeSystem",source)

        local squadName = vRP.prompt(source,"Nome:","")
        if squadName == "" then return end

        local leaderId = vRP.prompt(source,"ID do Líder:","")
        if leaderId == "" then return end
        leaderId = parseInt(leaderId)

        local category = vRP.prompt(source,"Categoria:","drugs/ammo/weapon/laundry")
        if category == "" then return end

        local squadQuery = exports.oxmysql:query_async("SELECT `squad_name` FROM `squads` WHERE `squad` = @squad OR `squad_name` = @squadName",{ squad = squadName:lower(), squadName = squadName })
        if #squadQuery > 0 then
            return TriggerClientEvent("Notify",source,"negado","Já existe um Squad chamado <b>"..squadName.."</b>.")
        end

        local leaderQuery = exports.oxmysql:query_async("SELECT `rank` FROM `groups` WHERE `character_id` = @character_id AND `rank` IS NOT NULL",{ character_id = leaderId })
        if #leaderQuery > 0 then
            return TriggerClientEvent("Notify",source,"negado","O Usuário <b>"..leaderId.."</b> já está em uma organização.")
        end

        exports.oxmysql:query("INSERT INTO `squads` (`squad`,`squad_name`,`category`) VALUES (@squad,@squad_name,@category)",{ squad = squadName:lower(), squad_name = squadName, category = category:lower() })
        exports["common"]:Group().addSquad(squadName,squadName:lower(),category:lower())
        Citizen.Wait(1000)
        exports["common"]:Group().addPlayerToSquad(leaderId,squadName:lower(),3)
        membersList[leaderId] = { squad = squadName, role = 3 }
        Citizen.Wait(1000)
        TriggerClientEvent("Notify",source,"sucesso","O Squad <b>"..squadName.."</b> foi criado com sucesso com a liderança do Usuário <b>"..leaderId.."</b>.")
        Citizen.Wait(1000)
        refreshTable()
    end
end)

RegisterNetEvent("squads:listSquad",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasPermission(userId,"staff") then
            return
        end

        local squadsQuery = exports.oxmysql:query_async("SELECT * FROM squads")
        if #squadsQuery <= 0 then
            return TriggerClientEvent("Notify",source,"sucesso","Não há nenhum Squad registrado.")
        end
        
        local str = ""
        for k,v in pairs(squadsQuery) do
            str = str.."<b>Nome:</b> "..v.squad_name.."<br>"
        end
        
        TriggerClientEvent("Notify",source,"default","<b>Lista de Squads:</b><br>"..str.."",20000,"normal","atenção")
    end
end)

RegisterNetEvent("squads:userSquad",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasPermission(userId,"staff") then
            return
        end

        TriggerClientEvent("dynamic:closeSystem",source)

        local targetId = vRP.prompt(source,"ID:","")
        if targetId == "" then return end
        targetId = parseInt(targetId)
        
        local squadName = vRP.prompt(source,"Nome do Squad:","")
        if squadName == "" then return end

        local rankUser = vRP.prompt(source,"Nome do Squad:"," 1 = Membro, 2 Gerente, 3 = Líder ")
        if rankUser == "" or not parseInt(rankUser) then return end

        rankUser = parseInt(rankUser)
        if vRP.request(source,"Você deseja adicionar o Usuário <b>"..targetId.."</b> ao Squad <b>"..squadName.."</b>?",30) then
            local targetSource = vRP.userSource(targetId)
            if not targetSource then
                return TriggerClientEvent("Notify",source,"negado","Não foi possível encontrar o Usuário <b>"..targetId.."</b>.")
            end

            if exports["common"]:Group().has(userId,squadName) then
                return TriggerClientEvent("Notify",source,"negado","Já está nesta organização.")
            end

            exports["common"]:Group().addPlayerToSquad(targetId,squadName,rankUser)
            membersList[targetId] = { squad = squadName, role = rankUser }
            TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> permitido em <b>"..squadName.."</b>.")
        end
    end
end)

RegisterNetEvent("squads:joinSquad",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasPermission(userId,"staff") then
            return
        end
        
        TriggerClientEvent("dynamic:closeSystem",source)

        local squadName = vRP.prompt(source,"Nome do Squad:","")
        if squadName == "" then return end
        
        squadName = squadName:lower()

        if exports["common"]:Group().has(userId,squadName) then
            return TriggerClientEvent("Notify",source,"negado","Você já está nesta organização.",10000,"bottom")
        end

        exports["common"]:Group().addPlayerToSquad(userId,squadName,2)
        membersList[userId] = { squad = squadName, role = 2 }
        TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..userId.."</b> permitido em <b>"..squadName.."</b>.")
        exports["common"]:Log().embedDiscord(userId,"squads-admin","**ENTROU:**```"..squadName:lower().."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
    end
end)

RegisterNetEvent("squads:exitSquad",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasPermission(userId,"staff") then
            return
        end

        if membersList[userId] then
            local temp = membersList[userId].squad
            exports["common"]:Group().remove(userId,membersList[userId].squad)
            exports["common"]:Group().remove(userId,"wait"..membersList[userId].squad)
            membersList[userId] = nil
            TriggerClientEvent("Notify",source,"sucesso","Você se retirou do Squad <b>"..temp.."</b>.")
            exports["common"]:Log().embedDiscord(userId,"squads-admin","**SAIU:**```"..temp.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        else
            TriggerClientEvent("Notify",source,"negado","Você não está em nenhum Squad.",10000,"bottom")
        end
    end
end)

function src.contractPlayer(targetId)
    local source = source
    local userId = vRP.getUserId(source)
    if not userId then
        return
    end

    if not membersList[userId] or (membersList[userId].role < 2) then
        return TriggerClientEvent("Notify",source,"negado","Sem acesso.")
    end

    local squadName = membersList[userId].squad

    local targetSource = vRP.userSource(targetId)
    if not targetSource then
        return TriggerClientEvent("Notify",source,"negado","Não foi possível encontrar o Usuário <b>"..targetId.."</b>.")
    end

    if exports["common"]:Group().has(targetId,squadName) then
        return TriggerClientEvent("Notify",source,"negado","Já está em sua organização.")
    end

    local countMembersQuery = exports.oxmysql:query_async("SELECT COUNT(1) AS qtd FROM `groups` WHERE `group` = @squad",{ squad = squadName })[1].qtd
    if countMembersQuery >= squadsList[squadName].max_members then
        return TriggerClientEvent("Notify",source,"negado","Limite de membros excedido.")
    end

    TriggerClientEvent("Notify",source,"sucesso","Você convidou o Usuário <b>"..targetId.."</b> para <b>"..squadName.."</b>.")
    if vRP.request(targetSource,"Você deseja juntar-se à(o) <b>"..squadName.."</b>?",30) then
        exports["common"]:Group().addPlayerToSquad(targetId,squadName,1)
        TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> permitido em <b>"..squadName.."</b>.")
        exports["common"]:Log().embedDiscord(userId,"squads","**ADICIONOU:**```"..targetId.."```\n**ORGANIZAÇÃO:**```"..squadName.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
    end
end

function src.demotePlayer(targetId)
    local source = source
    local userId = vRP.getUserId(source)
    if not userId then
        return
    end

    if not membersList[userId] or (membersList[userId].role < 2) then
        return TriggerClientEvent("Notify",source,"negado","Sem acesso.")
    end

    if userId == targetId then
        return TriggerClientEvent("Notify",source,"negado","Você não pode se remover.")
    end
    
    local squadName = membersList[userId].squad
    if not squadName then 
        return TriggerClientEvent("Notify",source,"negado","Squad não encontrado.")
    end
    
    local query = exports.oxmysql:query_async("SELECT `rank` FROM `groups` WHERE `character_id` = @targetId AND `group` = @squadName AND `rank` IS NOT NULL",{ targetId = targetId, squadName = squadName })
    if #query > 0 then
        if parseInt(query[1].rank) > parseInt(membersList[userId].role) then
            return TriggerClientEvent("Notify",source,"negado","Você não pode remover um superior seu.")
        end
    end

    if membersList[targetId] then
        membersList[targetId] = nil
    end
    
    exports["common"]:Group().remove(targetId,squadName)
    exports["common"]:Group().remove(targetId,"wait"..squadName)
    TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> teve seu acesso removido de <b>"..squadName.."</b>.")
    exports["common"]:Log().embedDiscord(userId,"squads","**REMOVEU:**```"..targetId.."```\n**ORGANIZAÇÃO:**```"..squadName.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
end

function src.updatePlayer(targetId,newRole)
    local source = source
    local userId = vRP.getUserId(source)
    if not userId then
        return
    end

    local is_staff = exports["common"]:Group().hasAccessOrHigher(userId,"admin")
    if membersList[userId].role ~= 3 and not is_staff then
        return TriggerClientEvent("Notify",source,"negado","Você não pode atualizar ninguém.")
    end

    local squadName = membersList[userId].squad
    local targetSource = vRP.userSource(targetId)

    if newRole == 3 and not is_staff then
        return TriggerClientEvent("Notify",source,"negado","Você não pode promover alguem para Líder.")
    end
    
    if membersList[targetId] and membersList[targetId].role == 3 then
        return TriggerClientEvent("Notify",source,"negado","O usuário já está no cargo mais alto.")
    end

    if membersList[targetId] and newRole == membersList[targetId].role then
        return TriggerClientEvent("Notify",source,"negado","O usuário já possui esse cargo.")
    end

    if userId == targetId and not is_staff then
        return TriggerClientEvent("Notify",source,"negado","Você não pode se remover.")
    end

    if membersList[targetId] and newRole > membersList[targetId].role then
        local countLeadersQuery = exports.oxmysql:query_async("SELECT COUNT(1) AS qtd FROM `groups` WHERE `group` = @squad AND `rank` >= 2",{ squad = squadName })[1].qtd
        if countLeadersQuery >= squadsList[squadName].max_leaders and not is_staff then
            return TriggerClientEvent("Notify",source,"negado","Limite de lideres excedido.")
        end
    end

    if newRole < 2 then
        exports.oxmysql:query("UPDATE `groups` SET `rank` = NULL WHERE `character_id` = @character_id AND `group` = @squadName",{ character_id = targetId, squadName = squadName, rank = newRole })
        membersList[targetId] = nil
    else
        exports.oxmysql:query("UPDATE `groups` SET `rank` = @rank WHERE `character_id` = @character_id AND `group` = @squadName",{ character_id = targetId, squadName = squadName, rank = newRole })
        membersList[targetId] = { squad = squadName, role = newRole }
    end

    exports["common"]:Log().embedDiscord(userId,"squads","**ATUALIZOU:**```"..targetId.."```\n**ORGANIZAÇÃO:**```"..squadName.."```\n**RANK:**```"..newRole.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
    TriggerClientEvent("Notify",source,"importante","Usuário <b>"..targetId.."</b> atualizado.")
end

RegisterCommand("bpm",function(source,args,rawCommand)
    local userId = vRP.getUserId(source)
    local identity = vRP.userIdentity(userId)
	if membersList[userId] and membersList[userId].squad == "police" and membersList[userId].role < 2 then
        local message = vRP.prompt(source,"Mensagem:","")
        if message == "" then
            return
        end
        
        TriggerClientEvent("Notify",-1,"default",""..message.."<br><br>Enviado por: <b>"..identity["name"].." "..identity["name2"].."",2*30000,"left","1° BPM INFORMA:")
        exports["common"]:Log().embedDiscord(userId,"commands-alert","**ANÚNCIO:**```"..message.."```\n**ORGANIZAÇÃO:**```police```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
    end
end)

RegisterCommand("hp",function(source,args,rawCommand)
    local userId = vRP.getUserId(source)
    local identity = vRP.userIdentity(userId)
	if membersList[userId] and membersList[userId].squad == "paramedic" and membersList[userId].role < 2 then
        local message = vRP.prompt(source,"Mensagem:","")
        if message == "" then
            return
        end
        
        TriggerClientEvent("Notify",-1,"default",""..message.."<br><br>Enviado por: <b>"..identity["name"].." "..identity["name2"].."",2*30000,"bottom","HOSPITAL:")
        exports["common"]:Log().embedDiscord(userId,"commands-alert","**ANÚNCIO:**```"..message.."```\n**ORGANIZAÇÃO:**```paramedic```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
    end
end)

RegisterNetEvent("reputation:Add",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"ceo") then
            return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
        end

        TriggerClientEvent("dynamic:closeSystem",source)

        local squad = vRP.prompt(source,"Nome do Squad:","")
        if squad == "" then return end
        squad = squad:lower()

        local amount = vRP.prompt(source,"Quantidade:","")
        if amount == "" then return end
        amount = parseInt(amount)

        vRP.setSquadReputation(squad,parseInt(amount))
        TriggerClientEvent("Notify",source,"sucesso","Você adicionou <b>"..parseInt(amount).."</b> de reputação para o Squad <b>"..squad.."</b>.",10000)
    end
end)

RegisterNetEvent("reputation:Remove",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"ceo") then
            return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
        end

        TriggerClientEvent("dynamic:closeSystem",source)

        local squad = vRP.prompt(source,"Nome do Squad:","")
        if squad == "" then return end
        squad = squad:lower()

        local amount = vRP.prompt(source,"Quantidade:","")
        if amount == "" then return end
        amount = parseInt(amount)

        vRP.reduceSquadReputation(squad,parseInt(amount))
        TriggerClientEvent("Notify",source,"sucesso","Você removeu <b>"..parseInt(amount).."</b> de reputação do Squad <b>"..squad.."</b>.",10000)
    end
end)

RegisterNetEvent("reputation:Reset",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"ceo") then
            return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
        end

        TriggerClientEvent("dynamic:closeSystem",source)

        local squad = vRP.prompt(source,"Nome do Squad:","")
        if squad == "" then return end
        squad = squad:lower()

        vRP.resetSquadReputation(squad)
        TriggerClientEvent("Notify",source,"sucesso","Você resetou a reputação do Squad <b>"..squad.."</b>.",10000)
    end
end)

RegisterNetEvent("reputation:Remove",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"ceo") then
            return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
        end

        TriggerClientEvent("dynamic:closeSystem",source)

        local squad = vRP.prompt(source,"Nome do Squad:","")
        if squad == "" then return end
        squad = squad:lower()

        local amount = vRP.prompt(source,"Quantidade:","")
        if amount == "" then return end
        amount = parseInt(amount)

        vRP.reduceSquadReputation(squad,parseInt(amount))
        TriggerClientEvent("Notify",source,"sucesso","Você removeu <b>"..parseInt(amount).."</b> de reputação do Squad <b>"..squad.."</b>.",10000)
    end
end)

RegisterCommand("squad-online",function(source,args,rawCommand)
    local userId = vRP.getUserId(source)
    local identity = vRP.userIdentity(userId)
    local squadName = exports["common"]:Group().getSquad(userId)
    if squadName == nil then 
        return TriggerClientEvent("Notify",source,"negado","Você não pertence a um <b>Squad</b>.",10000,"bottom")
    end
    
    local squadCount = exports["common"]:Group().getAllByPermission(squadName.squad)
    
    local squadStr = ""
    for k,v in pairs(squadCount) do
        local userId = vRP.getUserId(parseInt(v))
        if userId then
            local identity = vRP.userIdentity(userId)
            squadStr = squadStr.."<b>"..userId.."</b>: "..identity.name.." "..identity.name2.."<br>"
        end
    end

    TriggerClientEvent("Notify",source,"default","Atualmente <b>"..#squadCount.."</b> conectado(s).<br>"..squadStr.."",30000,"normal",""..squadName.squad.."")
end)

RegisterCommand("squad-radio",function(source,args,rawCommand)
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if waitFrequency[userId] then 
            if GetGameTimer() < waitFrequency[userId] then
                return TriggerClientEvent("Notify",source,"negado","Aguarde <b>10 minutos</b> para alterar a frequência novamente.",10000,"bottom")
            end
        end

        if membersList[userId] and membersList[userId].role >= 3 then
            local reputation = vRP.squadReputation(membersList[userId].squad)
            if reputation < 100 then
                return TriggerClientEvent("Notify",source,"negado","Seu squad não possui reputação suficiente.",10000,"bottom")
            end

            local consultItem = vRP.getInventoryItemAmount(userId,"dollars")
            if consultItem[1] < 75000 then
                return TriggerClientEvent("Notify",source,"negado","Você não possuí dinheiro suficiente.",10000,"bottom")
            end

            if squadsList[membersList[userId].squad] then
                local radio = vRP.prompt(source,"Insira uma Frequência:","")
                if radio == "" then
                    return
                end
                 
                if #radio > 3 then 
                    return TriggerClientEvent("Notify",source,"negado","Insira uma frequência de três dígitos.",10000,"bottom")
                end

                radio = parseInt(radio)

                for k,v in pairs(squadsList) do
                    if v.radio_frequency == radio then
                        return TriggerClientEvent("Notify",source,"negado","Insira uma frequência diferente de uma existente.",10000,"bottom")
                    end
                end

                if vRP.tryGetInventoryItem(userId,"dollars",75000,true) then
                    squadsList[membersList[userId].squad].radio_frequency = radio
                    exports.oxmysql:query("UPDATE squads SET radio_frequency = @frequency WHERE squad = @squad",{ squad = membersList[userId].squad, frequency = radio })
                    waitFrequency[userId] = GetGameTimer() + (10 * 60000)
                    return TriggerClientEvent("Notify",source,"sucesso","Frequência Atualizada.",10000)
                end
            end
        else
            TriggerClientEvent("Notify",source,"negado","Somente o líder pode alterar a frequência.",10000,"bottom")
        end
    end
end)

RegisterCommand("anuncio2",function(source,args,rawCommand)
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"ceo") then
            return
        end

        local squad = vRP.prompt(source,"Squad:","")
        if squad == "" then
            return
        end

        local message = vRP.prompt(source,"Mensagem:","")
        if message == "" then
            return
        end

        squad = squad:lower()

        local identity = vRP.userIdentity(userId)
        for k,v in pairs(membersList) do 
            if v.squad == squad then
                TriggerClientEvent("hub:sendNotification",vRP.getUserSource(parseInt(k)),"warning","<b>HACKERSPACE</b>",message,true)
            end
        end
    end
end)

exports("hasAccess",hasAccess)