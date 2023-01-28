local userGroupsCache = {}
local groupsList = {
    ["dev"] = {
        ["name"] = "Dev",
        ["role"] = "staff",
        ["access"] = 5
    },
    ["ceo"] = {
        ["name"] = "Ceo",
        ["role"] = "staff",
        ["access"] = 4
    },
    ["cto"] = {
        ["name"] = "Supervisor",
        ["role"] = "staff",
        ["access"] = 3
    },
    ["admin"] = {
        ["name"] = "Administrador",
        ["role"] = "staff",
        ["access"] = 2
    },
    ["mod"] = {
        ["name"] = "Moderador",
        ["role"] = "staff",
        ["access"] = 1
    },
    ["police"] = {
        ["name"] = "Policia",
        ["role"] = "organization"
    },
    ["waitpolice"] = {
        ["name"] = "Policia",
        ["role"] = "organization"
    },
    ["paramedic"] = {
        ["name"] = "Paramedico",
        ["role"] = "organization"
    },
    ["waitparamedic"] = {
        ["name"] = "Paramedico",
        ["role"] = "organization"
    },
    ["mechanic"] = {
        ["name"] = "Mecânico",
        ["role"] = "organization"
    },
    ["waitmechanic"] = {
        ["name"] = "Mecânico",
        ["role"] = "organization"
    },
    ["creator"] = {
        ["name"] = "Creator"
    },
}

Group = {}

function Group.load(userId)
    userGroupsCache[userId] = {}
    local query = exports.oxmysql:query_async("SELECT `group`,`rank` FROM `groups` WHERE `character_id` = @character_id",{ character_id = userId })
    if #query > 0 then
        for _,v in pairs(query) do
            if groupsList[v.group] then
                userGroupsCache[userId][v.group] = true
            end
        end
    end
end

function Group.addSquad(squad,squadName,category)
    groupsList[squad] = {
        ["name"] = squadName,
        ["role"] = category or "organization"
    }
end

function Group.has(userId,group)
    local source = vRP.userSource(userId)
    if source then
        if not userGroupsCache[userId] then
            userGroupsCache[userId] = {}
        end

        if userGroupsCache[userId][group] then
            return true
        end
    else
        local query = exports.oxmysql:query_async("SELECT `id` FROM `groups` WHERE `character_id` = @character_id AND `group` = @group",{ character_id = userId, group = group })
        if #query > 0 then
            return true
        end
    end
    return false
end

function Group.add(userId,group,staffId)
    local source = vRP.userSource(userId)
    local staffSource = vRP.userSource(staffId)
    if not groupsList[group] then
        if staffSource then
            TriggerClientEvent("Notify",staffSource,"negado","Grupo <b>"..group.."</b> não existe.")
        end
        return
    end

    if Group.has(userId,group) then
        if staffSource then
            TriggerClientEvent("Notify",staffSource,"negado","Usuário <b>"..userId.."</b> já possui o grupo <b>"..group.."</b>.")
        end
        return
    end

    if groupsList[group].role == "organization" or groupsList[group].role == "weed" or groupsList[group].role == "cocaine" or groupsList[group].role == "ecstasy" or groupsList[group].role == "ammo" or groupsList[group].role == "weapon" or groupsList[group].role == "laundry" then
        if staffSource then
            TriggerClientEvent("Notify",staffSource,"negado","O grupo <b>"..group.."</b> só pode ser adicionado pelo menu de squads.")
        end
        return
    end
    
    if source then
        if not userGroupsCache[userId] then
            userGroupsCache[userId] = {}
        end

        userGroupsCache[userId][group] = true
    end
    
    exports.oxmysql:query("INSERT INTO `groups` (`character_id`,`group`) VALUES (@character_id,@group)",{ character_id = userId, group = group })
    if staffSource then
        TriggerClientEvent("Notify",staffSource,"sucesso","Usuário <b>"..userId.."</b> adicionado à <b>"..group.."</b>.")
    end
end

function Group.remove(userId,group,staffId)
    local source = vRP.userSource(userId)
    local staffSource = vRP.userSource(staffId)
    if not groupsList[group] then
        if staffSource then
            TriggerClientEvent("Notify",staffSource,"negado","Grupo <b>"..group.."</b> não existe.")
        end
        return
    end
    
    if userGroupsCache[userId] then
        if userGroupsCache[userId][group] then
            userGroupsCache[userId][group] = nil
        end
    end
    
    exports.oxmysql:query("DELETE FROM `groups` WHERE `character_id` = @character_id AND `group` = @group",{ character_id = userId, group = group })
    if staffSource then
        TriggerClientEvent("Notify",staffSource,"sucesso","Usuário <b>"..userId.."</b> removido de <b>"..group.."</b>.")
    end
end

function Group.addPlayerToSquad(userId,group,rank)
    local source = vRP.userSource(parseInt(userId))
    if not groupsList[group] then
        return
    end

    if Group.has(userId,group) then
        return
    end
    
    if source then
        if not userGroupsCache[userId] then
            userGroupsCache[userId] = {}
        end

        userGroupsCache[userId][group] = true
    end
     
    local myRank = exports.oxmysql:query_async("SELECT `rank` FROM `groups` WHERE `group` = @group AND `character_id` = @character_id AND `rank` IS NOT NULL",{ character_id = userId, group = group })
    if #myRank > 0 and myRank[1].rank >= 2 then
        exports.oxmysql:query("INSERT INTO `groups` (`character_id`,`group`,`rank`) VALUES (@character_id,@group,@rank)",{ character_id = userId, group = group, rank = myRank[1].rank })
    else
        exports.oxmysql:query("INSERT INTO `groups` (`character_id`,`group`,`rank`) VALUES (@character_id,@group,@myRank)",{ character_id = userId, group = group, myRank = rank })
    end
end

function Group.alterSquadService(userId,groupFrom,groupTo)
    local source = vRP.userSource(userId)       
    if source then
        if not userGroupsCache[userId] then
            userGroupsCache[userId] = {}
        end

        local myRank = exports.oxmysql:query_async("SELECT `rank` FROM `groups` WHERE `group` = @group AND `character_id` = @character_id AND `rank` IS NOT NULL",{ character_id = userId, group = groupFrom })
        if userGroupsCache[userId][groupFrom] then
            userGroupsCache[userId][groupFrom] = nil
        end

        userGroupsCache[userId][groupTo] = true
        
        if #myRank > 0 and myRank[1].rank >= 2 then
            exports.oxmysql:query("INSERT INTO `groups` (`character_id`,`group`,`rank`) VALUES (@character_id,@group,@rank)",{ character_id = userId, group = groupTo, rank = myRank[1].rank })
        else
            exports.oxmysql:query("INSERT INTO `groups` (`character_id`,`group`,`rank`) VALUES (@character_id,@group,NULL)",{ character_id = userId, group = groupTo })
        end

        exports.oxmysql:query("DELETE FROM `groups` WHERE `character_id` = @character_id AND `group` = @group",{ character_id = userId, group = groupFrom })
    end
end

function Group.hasPermission(userId,group)
    if not userGroupsCache[userId] then
        return false,group
    end

    if groupsList[group] then
        if userGroupsCache[userId][group] then
            return true,group
        end
        return false,group
    end

    for k,v in pairs(userGroupsCache[userId]) do
        if groupsList[k].role then
            if groupsList[k].role == group then
                return true,k
            end
        end
    end
    return false,group
end

function Group.hasAccessOrHigher(userId,group,search)
    if not userGroupsCache[userId] then
        return false
    end

    if not groupsList[group] then
        return false
    end

    if not groupsList[group].role or not groupsList[group].access then
        return false
    end

    local role = groupsList[group].role
    local access = groupsList[group].access

    if userGroupsCache[userId] then
        for k,v in pairs(userGroupsCache[userId]) do
            if groupsList[k].role then
                if groupsList[k].role == role then
                    if ((search and access < groupsList[k].access) or (not search and access <= groupsList[k].access)) then
                        return true
                    end
                end
            end
        end

        return false
    end
end

function Group.getAllByPermission(group)
    local returnList = Group.getUsersByPermission(group)
    for k,v in pairs(returnList) do 
        returnList[k] = vRP.userSource(v)
    end

    return returnList
end

function Group.getUsersByPermission(group)
    local returnList = {}
    if groupsList[group] then
        for k,v in pairs(userGroupsCache) do
            for l,w in pairs(v) do
                if l == group then
                    table.insert(returnList,k)
                end
            end
        end
    else
        for k,v in pairs(userGroupsCache) do
            for l,w in pairs(v) do
                if groupsList[l].role then
                    if groupsList[l].role == group then
                        table.insert(returnList,k)
                    end
                end
            end
        end
    end

    return returnList
end

function Group.getRole(group)
    return groupList[group].role and groupList[group].role or false
end

local allowedRoles = { 
    ["laundry"] = true,
    ["weed"] = true,
    ["cocaine"] = true,
    ["ecstasy"] = true,
    ["organization"] = true,
    ["weapon"] = true,
    ["ammo"] = true,
}

function Group.getSquad(userId)
    if userGroupsCache[userId] then
        for k,v in pairs(userGroupsCache[userId]) do
            if allowedRoles[groupsList[k].role] then 
               return { squad = k, squadName = groupsList[k].name, reputation = vRP.squadReputation(k) }
            end
        end
        return nil
    end
end

function Group.getHigher(userId)
    local template = userId
    local higher = template

    if userGroupsCache[userId] then
        for k,v in pairs(userGroupsCache[userId]) do
            if groupsList[k].role then
                if higher == template then
                    higher = k
                end
                    
                if groupsList[higher] == nil or groupsList[higher].access == nil then
                    return k
                end
                
                if groupsList[k] == nil or groupsList[k].access == nil then
                    return higher
                end

                if groupsList[higher].access < groupsList[k].access then
                    return higher
                end
            end
        end
    end
    return higher
end

local function verifyOverrideRoles()
    for k,v in pairs(groupsList) do
        if k == v.role then
            print("^1[ERRO CRUCIAL] ^7Foi encontrado um grupo com o mesmo nome de uma role "..v.role)
        end
    end
end

AddEventHandler("vRP:playerSpawn",function(userId,source)
    Group.load(userId)
end)

AddEventHandler("vRP:playerLeave",function(userId,source)
    if not userGroupsCache[userId] then return end
    
    if userGroupsCache[userId]["police"] then
        exports.oxmysql:query("UPDATE `groups` SET `group` = 'waitpolice' WHERE `character_id` = @character_id AND `group` = 'police'",{ character_id = userId })
    end

    if userGroupsCache[userId]["paramedic"] then
        exports.oxmysql:query("UPDATE `groups` SET `group` = 'waitparamedic' WHERE `character_id` = @character_id AND `group` = 'paramedic'",{ character_id = userId })
    end

    if userGroupsCache[userId]["mechanic"] then
        exports.oxmysql:query("UPDATE `groups` SET `group` = 'waitmechanic' WHERE `character_id` = @character_id AND `group` = 'mechanic'",{ character_id = userId })
    end

    userGroupsCache[userId] = nil
end)

RegisterCommand("update",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if userId then
        Group.load(userId)
        TriggerClientEvent("Notify",source,"sucesso","Você atualizou seus grupos.")
    end
end)

RegisterCommand("vgroups",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if userId then
        if not Group.hasPermission(userId,"staff") then
            return
        end

        if not args[1] then return end
        local targetId = parseInt(args[1])
        local messageStr = ""

        if userGroupsCache[targetId] then
            for k,v in pairs(userGroupsCache[targetId]) do
                messageStr = messageStr.." "..k
            end
            TriggerClientEvent("Notify",source,"importante","Grupos de Usuário <b>"..targetId.."</b> (online):<br>"..messageStr)
        else
            local query = exports.oxmysql:query_async("SELECT `group` FROM `groups` WHERE `character_id` = @character_id",{ character_id = targetId })
            if #query > 0 then
                for _,v in pairs(query) do
                    messageStr = messageStr.." "..v.group
                end
            end
            TriggerClientEvent("Notify",source,"importante","Grupos de Usuário <b>"..targetId.."</b> (offline):<br>"..messageStr)
        end

    end
end)

RegisterNetEvent("squads:memberSquad",function()
    local source = source
    local userId = vRP.getUserId(source)
    if not Group.hasPermission(userId,"staff") then
        return
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local squadName = vRP.prompt(source,"Nome do Squad:","")
    if squadName == "" then return TriggerClientEvent("Notify",source,"negado","Informe um squad.",10000,"bottom") end

    if groupsList[squadName] then
        local getAll = exports.oxmysql:query_async("SELECT `character_id`,`group`,`rank` FROM `groups` WHERE `group` = @group",{ group = squadName }) 
        if #getAll > 0 then 
            local messageStr = ""
            for k,v in pairs(getAll) do 
                messageStr = messageStr.." <b>"..v.character_id.."</b>: "..v.group.."<br>"
            end
            TriggerClientEvent("Notify",source,"importante",""..messageStr)
        end
    else
        TriggerClientEvent("Notify",source,"negado","Squad não encontrado.",10000,"bottom")
    end
end)

AddEventHandler("onResourceStart",function(resourceName)
    Citizen.Wait(300)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    verifyOverrideRoles()

    local users = vRP.userList()
    for id,src in pairs(users) do
        Group.load(id)
    end
end)


exports("Group",function()
    return Group
end)