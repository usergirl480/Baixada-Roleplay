local openedRequests = {}
local requestCall = {}
local serviceList = {
    ["190"] = { permission = "police", category = "Policia", icon = "police" },
    ["192"] = { permission = "paramedic", category = "Paramedico", icon = "hospital" },
    ["adm"] = { permission = "staff", category = "Staff", icon = "crown" }
}

RegisterCommand("chamar",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if userId then

        if requestCall[userId] then
            if GetGameTimer() < requestCall[userId] then
                local callTime = parseInt((requestCall[userId] - GetGameTimer()) / 1000)
                TriggerClientEvent("Notify",source,"negado","Aguarde <b>"..callTime.." segundos</b>.",5000)
                return
            end
        end

        if not args[1] then return end
        local serviceName = args[1]

        if not serviceList[serviceName] then
            return TriggerClientEvent("Notify",source,"negado","Serviço não existente.")
        end

        local description = vRP.prompt(source,"Descrição do seu chamado:","")
        if description == "" then return end
        description = description:gsub("[<>]","")
        description = description:lower()

        local targets = exports["common"]:Group().getAllByPermission(serviceList[serviceName].permission)
        if #targets <= 0 then
            return TriggerClientEvent("hub:sendNotification",source,"warning","<b>Notificação</b>","Por favor, tente novamente mais tarde.",true)
        end

        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local location = { ceil(coords.x),ceil(coords.y),ceil(coords.z) }
        local identity = vRP.userIdentity(userId)

        requestCall[userId] = GetGameTimer() + 180000
        local sqlQuery = exports.oxmysql:query_async("INSERT INTO `requests` (`category`,`requested_by`,`description`,`location`) VALUES (@category,@requested_by,@description,@location)", { category = serviceList[serviceName].category, requested_by = userId, description = description, location = json.encode(location) })
        if sqlQuery.insertId then
            sendRequest(userId,serviceList[serviceName].permission,serviceList[serviceName].icon," ["..serviceList[serviceName].category.."] - "..(identity.name or "N/A").." "..(identity.name2 or "N/A").." ("..userId..") ",description,sqlQuery.insertId,location)
        end
    end
end)

function sendRequest(requestedBy,permission,icon,title,description,requestId,location)
    if not openedRequests[requestId] and vRP.userSource(requestedBy) then
        openedRequests[requestId] = { requestedBy = requestedBy, permission = permission, timer = 120, location = location }
        
        if description:len() > 150 then
            description = description:sub(1,150)
        end
        
        local targets = exports["common"]:Group().getAllByPermission(permission)
        if #targets > 0 then
            for k,v in pairs(targets) do
                async(function()
                    TriggerClientEvent("hub:sendRequest",v,icon,title,description,requestId)
                end)
            end
        end
    end
end

function src.tryAcceptRequest(requestId)
    local source = source
    requestId = parseInt(requestId)
    
    if not openedRequests[requestId] then
        return false
    end

    local userId = vRP.getUserId(source)

    if not exports["common"]:Group().hasPermission(userId,openedRequests[requestId].permission) then
        return false
    end

    local requestedBy = openedRequests[requestId].requestedBy
    local requestedSource = vRP.userSource(requestedBy)
    local identity = vRP.userIdentity(userId)

    exports.oxmysql:query("UPDATE `requests` SET `attended_by` = @userId, `attended_at` = NOW() WHERE `id` = @id",{ id = requestId, userId = userId })
    
    if requestedSource then
        TriggerClientEvent("hub:sendNotification",requestedSource,"check-circle","<b>Chamado Aceito</b>","Por favor, aguarde no local.",true)
    end

    TriggerClientEvent("smartphone:createSMS",source,"Localização","Aqui está a localização do chamado de "..(identity.name or "N/A").." "..(identity.name2 or "N/A"), { openedRequests[requestId].location[1], openedRequests[requestId].location[2], openedRequests[requestId].location[3] })
        
    local targets = exports["common"]:Group().getAllByPermission(openedRequests[requestId].permission)
    if #targets > 0 then
        for k,v in pairs(targets) do
            async(function()
                if source ~= v then
                    TriggerClientEvent("hub:setAcceptedRequest", v, requestId, userId)
                else
                    TriggerClientEvent("hub:setAcceptedRequest", v, requestId, "ok")
                end
            end)
        end
    end       
        
    openedRequests[requestId] = nil
    return true
end

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(openedRequests) do
            if v.timer > 0 then
                v.timer = v.timer - 1

                if v.timer <= 0 then
                    if vRP.userSource(v.requestedBy) then
                        TriggerClientEvent("hub:sendNotification",vRP.userSource(v.requestedBy),"warning","<b>Notificação</b>","Por favor, tente novamente mais tarde.",true)
                    end

                    local targets = exports["common"]:Group().getAllByPermission(v.permission)
                    if #targets > 0 then
                        for l,w in pairs(targets) do
                            async(function()
                                TriggerClientEvent("hub:setAcceptedRequest",w,k,"ninguém")
                            end)
                        end
                    end

                    openedRequests[k] = nil
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand("reply", function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    local identity = vRP.userIdentity(userId)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end

    if not args[1] then return end

    local description = vRP.prompt(source,"Descrição","")
    local persistentText = vRP.prompt(source, "Persistente (0 ou 1)","")
    local persistent = false

    local identity2 = vRP.userIdentity(parseInt(args[1]))

    
    if persistentText == "1" then
        persistent = true
    end

    if string.len(description) > 0 then
        if vRP.userSource(parseInt(args[1])) then
            TriggerClientEvent("hub:sendNotification", vRP.userSource(parseInt(args[1])),"warning","<b>"..identity.surname.." diz:</b>", description, persistent)
        end

        local adminAmount = exports["common"]:Group().getAllByPermission("staff")
        if #adminAmount > 0 then
            for k,v in pairs(adminAmount) do
                async(function()
                    TriggerClientEvent('chatME',v,"^8"..identity.surname.." disse "..identity2.name.." "..identity2.name2.." ("..(parseInt(args[1])).."): ^4"..description)
                end)
            end
            exports["common"]:Log().embedDiscord(userId,"commands-reply","**ID:**```"..parseInt(args[1]).."```\n**DISSE:**```"..description.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        end
    end
end)

function ceil(n)
    n = math.ceil(n * 100) / 100
    return n
end