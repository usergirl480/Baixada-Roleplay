local userList = {}
local adminList = {}

AddEventHandler("vRP:playerSpawn",function(userId,source)
    Citizen.SetTimeout(2000,function()
        local identity = vRP.userIdentity(userId)

        local set = Group.getHigher(userId) or "user"
		TriggerClientEvent("vrp:playerActive",source,userId,identity.surname,set)

        local timePlayed = exports["common"]:PlayedTime().getDefault(identity.steam)
        userList[source] = {
            userId = userId,
            name = (identity.name.." "..identity.name2) or "N/A",
            surname = (identity.surname) or "N/A",
            timePlayed = timePlayed or 0,
            group = type(set) == "string" and set or "",
            blipsEnabled = adminList[userId] and true or false
        }

        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList",v,userList)
        end
    end)
end)

AddEventHandler("vRP:playerLeave",function(userId,source)
    if userList[source] then
        userList[source] = nil
    end

    if adminList[userId] then
        adminList[userId] = nil
    end

    for k,v in pairs(adminList) do
        TriggerClientEvent("common:admin_blips:updateList",v,userList)
    end
end)

local function loadPlayers()
    Citizen.SetTimeout(2000,function()
        local users = vRP.userList()
        for id,src in pairs(users) do
            if userList[src] and userList[src].hidden then
                goto skip
            end

            local identity = vRP.userIdentity(id)
            local timePlayed = exports["common"]:PlayedTime().getDefault(identity.steam)
            userList[src] = {
                userId = id,
                name = (identity.name.." "..identity.name2) or "N/A",
                surname = (identity.surname) or "N/A",
                timePlayed = timePlayed or 0,
                group = Group.getHigher(id),
                blipsEnabled = adminList[id] and true or false
            }

            ::skip::
        end
    
        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList",v,userList)
        end
    end)
end

AddEventHandler("onResourceStart",function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    loadPlayers()
end)

RegisterCommand("blips",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end

    local res = client.toggleAdmin(source,args[1])
    if res then
        adminList[userId] = source
        userList[source].blipsEnabled = true
        
        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList",v,userList)
        end
    else
        adminList[userId] = nil
        userList[source].blipsEnabled = false

        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList",v,userList)
        end
    end
end)

RegisterCommand("blips-update-all",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end
    
    loadPlayers()
end)

RegisterCommand("v",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(userId,"cto") then
        return
    end
    if not userList[source].hidden then
        userList[source].hidden = true
    
        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList",v,userList)
        end

        TriggerClientEvent("Notify",source,"sucesso","Modo vanish ativado.",10000,"bottom")
    else
        userList[source].hidden = nil
        
        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList",v,userList)
        end
        
        TriggerClientEvent("Notify",source,"sucesso","Modo vanish desativado.",10000,"bottom")
    end
end)



RegisterCommand("v-see",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if userId ~= 1 then return end
    local hiddenStr = ""
    for k,v in pairs(userList) do
        if v.hidden then
            hiddenStr = hiddenStr..v.userId.." "
        end
    end
    TriggerClientEvent("Notify",source,"sucesso","Usuários ocultos: "..hiddenStr)
end)

exports("checkHidden", function(source)
    if userList[source] and userList[source].hidden then
        return true
    end
    return false
end)