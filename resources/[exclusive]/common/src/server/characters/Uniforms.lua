local vSKINSHOP = Tunnel.getInterface("skinshop")
local uniformsList = {
    ["Police"] = { slots = 15, permission = "police" },
    ["Paramedic"] = { slots = 12, permission = "paramedic" },
    ["Mechanic"] = { slots = 2, permission = "mechanic" },
    ["Arcade"] = { slots = 2, permission = "arcade" },
    ["Aztecas"] = { slots = 2, permission = "aztecas" },
    ["Bahama"] = { slots = 2, permission = "bahama" },
    ["Families"] = { slots = 2, permission = "families" },
    ["Ballas"] = { slots = 2, permission = "ballas" },
    ["Bloods"] = { slots = 2, permission = "bloods" },
    ["Vagos"] = { slots = 2, permission = "Vagos" },
    ["Crips"] = { slots = 2, permission = "crips" },
    ["Bullguer"] = { slots = 2, permission = "bullguer" },
    ["Cartel"] = { slots = 2, permission = "cartel" },
    ["Casino"] = { slots = 2, permission = "casino" },
    ["Favela01"] = { slots = 2, permission = "favela01" },
    ["Favela02"] = { slots = 2, permission = "favela02" },
    ["Favela03"] = { slots = 2, permission = "favela03" },
    ["Favela04"] = { slots = 2, permission = "favela04" },
    ["Favela05"] = { slots = 2, permission = "favela05" },
    ["Favela06"] = { slots = 2, permission = "favela06" },
    ["Hackerspace"] = { slots = 2, permission = "hackerspace" },
    ["Madrazo"] = { slots = 2, permission = "madrazo" },
    ["Marabunta"] = { slots = 2, permission = "marabunta" },
    ["Medellin"] = { slots = 2, permission = "medellin" },
    ["Siciliana"] = { slots = 2, permission = "siciliana" },
    ["Triads"] = { slots = 2, permission = "triads" },
}

RegisterServerEvent("uniforms:applyPreset",function(params)
    local source = source
    local userId = vRP.getUserId(source)
    if not userId then return end

    if params == "apply" then
        local myClothes = vSKINSHOP.getCustomization(source)
        if myClothes then
            local nearestBlip = client.getNearestBlip(source)
            local squad 
            if not nearestBlip then squad = exports["common"]:Group().getSquad(userId) end

            
            TriggerClientEvent("dynamic:close",source)

            local presetName = vRP.prompt(source,"Nome do preset:","")
            if presetName == "" then return end

            
            local sex = "mp_m_freemode_01"
            if GetEntityModel(GetPlayerPed(source)) ~= `mp_m_freemode_01` then
                sex = "mp_f_freemode_01"
            end
            
            local presetExists = exports.oxmysql:query_async("SELECT `id` FROM `uniforms` WHERE `category` = @category AND `name` = @name",{ name = presetName, category = nearestBlip or squad.squadName })
            if #presetExists > 0 then
                return TriggerClientEvent("Notify",source,"negado","Já existe um preset com este nome.",10000,"bottom")
            end

            TriggerClientEvent("Notify",source,"sucesso","Uniforme <b>"..presetName.."</b> adicionado.",10000,"bottom")

           exports.oxmysql:query("INSERT INTO `uniforms` (`name`,`category`,`sex`,`custom`) VALUES (@name,@category,@sex,@custom)",{ name = presetName, category = nearestBlip or squad.squadName, sex = sex, custom = json.encode(myClothes) })
        end
    elseif params == "delete" then
        local nearestBlip = client.getNearestBlip(source)
        local squad 
        if not nearestBlip then squad = exports["common"]:Group().getSquad(userId) end
        
        TriggerClientEvent("dynamic:close",source)

        local presetName = vRP.prompt(source,"Nome do preset:","")
        if presetName == "" then return end
        
        local presetExists = exports.oxmysql:query_async("SELECT `id` FROM `uniforms` WHERE `category` = @category AND `name` = @name",{ name = presetName, category = nearestBlip or squad.squadName })
        if #presetExists <= 0 then
            return TriggerClientEvent("Notify",source,"negado","Não existe um preset com este nome.",10000,"bottom")
        end
        
        TriggerClientEvent("Notify",source,"sucesso","Uniforme <b>"..presetName.."</b> deletado.",10000,"bottom")

       exports.oxmysql:query("DELETE FROM `uniforms` WHERE `id` = @id",{ id = presetExists[1].id })
    elseif params == "remove" then
        TriggerClientEvent("skinshop:apply",source,vRP.userData(userId,"Clothings"))
    else
        local query = exports.oxmysql:query_async("SELECT `custom` FROM `uniforms` WHERE `name` = @name",{ name = params })
        if #query > 0 then
            TriggerClientEvent("updateRoupas",source,json.decode(query[1].custom))
        end
    end
end)

function server.requestUniforms(k)
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not uniformsList[k] then
            return
        end

        if exports["common"]:Group().hasPermission(userId,uniformsList[k].permission) then
            local sex = "mp_m_freemode_01"

            if GetEntityModel(GetPlayerPed(source)) ~= `mp_m_freemode_01` then
                sex = "mp_f_freemode_01"
            end

            local myPresets = exports.oxmysql:query_async("SELECT `name`,`custom` FROM `uniforms` WHERE `category` = @category AND `sex` = @sex",{ category = k, sex = sex })
            if #myPresets > 0 then
                return myPresets
            end
        end
    end
    return false
end

function server.requestPerm(k)
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if uniformsList[k] then
            return exports["common"]:Group().hasPermission(userId,uniformsList[k].permission),exports.squads:hasAccess(userId) or false
        end
    end
    return false,false
end

function server.requestSquad()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        local squad = exports["common"]:Group().getSquad(userId)
        if squad == nil then 
            TriggerClientEvent("Notify",source,"negado","Você não pertence a um <b>Squad</b>.",10000,"bottom")
            return false
        end
        
        if uniformsList[squad.squadName] then
            return exports["common"]:Group().hasPermission(userId,squad.squad),exports.squads:hasAccess(userId),squad.squadName
        end
    end
    return false,false
end

RegisterCommand("copypreset",function(source,args,rawCommand)
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end

    if not args[1] or parseInt(args[1]) <= 0 then
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local otherPlayer = vRP.userSource(parseInt(args[1]))
    if not otherPlayer then 
        return TriggerClientEvent("Notify",source,"negado","Usuário desconectado.",10000,"bottom")
    end

    local myClothes = vSKINSHOP.getCustomization(otherPlayer)
    if myClothes then
        TriggerClientEvent("updateRoupas",source,myClothes)
        return TriggerClientEvent("Notify",source,"sucesso","Roupa copiada com sucesso.",10000,"bottom")
    end 
end)

RegisterCommand("setpreset",function(source,args,rawCommand)
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end

    if not args[1] or parseInt(args[1]) <= 0 then
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local otherPlayer = vRP.userSource(parseInt(args[1]))
    if not otherPlayer then 
        return TriggerClientEvent("Notify",source,"negado","Usuário desconectado.",10000,"bottom")
    end

    local myClothes = vSKINSHOP.getCustomization(source)
    if myClothes then
        TriggerClientEvent("updateRoupas",otherPlayer,myClothes)
        return TriggerClientEvent("Notify",source,"sucesso","Roupa adicionada com sucesso.",10000,"bottom")
    end 
end)