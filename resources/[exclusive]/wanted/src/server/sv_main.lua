local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

local cachedWanted = {}
local dispatchCooldown = {}

RegisterCommand("procurado",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"police") then
        return
    end
    
    if targetSource then
        local targetSource = vRPC.nearestPlayer(source,3)
        local targetId = vRP.getUserId(targetSource)
        local identity = vRP.userIdentity(targetId)
        if identity then
            local timerWanted = cachedWanted[targetId] or 0
            if timerWanted > 0 then
                TriggerClientEvent("Notify",source,"importante","<b>"..identity.name.." "..identity.firstname.."</b> está procurado durante <b>"..timerWanted.."</b> segundos.")
            else
                TriggerClientEvent("Notify",source,"importante","<b>"..identity.name.." "..identity.firstname.."</b> não está procurado.")
            end
        end
    end
end)

local function setWanted(targetId,time)
    targetId = parseInt(targetId)
    time = parseInt(time)
    local targetSource = vRP.userSource(targetId)
    if targetSource then
        if not cachedWanted[targetId] then
            cachedWanted[targetId] = time
        else
            cachedWanted[targetId] = parseInt(cachedWanted[targetId]) + time
        end

        exports.oxmysql:query("UPDATE `characters` SET `wanted` = @wanted WHERE `id` = @id",{ id = targetId, wanted = cachedWanted[targetId] })
        TriggerClientEvent("wanted:client:updateWanted",targetSource,cachedWanted[targetId])
    end
end

local function checkWanted(targetId)
    return cachedWanted[targetId] and cachedWanted[targetId] or false
end

local function dispatchPolice(targetId)
    local source = vRP.userSource(targetId)
    if source then
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        if not dispatchCooldown[targetId] or os.time() >= dispatchCooldown[targetId] + 60 then
            dispatchCooldown[targetId] = os.time()
            local policeAmount = exports["common"]:Group().getAllByPermission("police")
            for k,v in pairs(policeAmount) do
                async(function()
                    TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Procurado", x = coords["x"], y = coords["y"], z = coords["z"], time = "Recebido às "..os.date("%H:%M"), blipColor = 22 })
					vRPC.playSound(v,"Beep_Green","DLC_HEIST_HACKING_SNAKE_SOUNDS")
                end)
            end
        end
    end
end

local function removeWanted(targetId)
    if cachedWanted[targetId] then
        exports.oxmysql:query("UPDATE `characters` SET `wanted` = @wanted WHERE `id` = @id",{ id = targetId, wanted = 0 })
        cachedWanted[targetId] = nil
    end
end

AddEventHandler("vRP:playerSpawn",function(userId,source,first_spawn)
    local wantedTime = exports.oxmysql:query_async("SELECT `wanted` FROM `characters` WHERE `id` = @id",{ id = userId })
    if #wantedTime > 0 then
        cachedWanted[userId] = parseInt(wantedTime[1].wanted)
        TriggerClientEvent("wanted:client:updateWanted",source,cachedWanted[userId])
    end
end)

AddEventHandler("vRP:playerLeave",function(userId,source)
    if userId then
        local timerWanted = cachedWanted[userId]
        if timerWanted then
            exports.oxmysql:query("UPDATE `characters` SET `wanted` = @wanted WHERE `id` = @id",{ id = userId, wanted = cachedWanted[userId] })
            cachedWanted[userId] = nil
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(cachedWanted) do
            cachedWanted[k] = cachedWanted[k] - 1
            if cachedWanted[k] <= 0 then
                exports.oxmysql:query("UPDATE `characters` SET `wanted` = @wanted WHERE `id` = @id",{ id = k, wanted = 0 })
                cachedWanted[k] = nil
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand("teste-w",function(source,args,rawcmd)
    if source == 0 then
        setWanted(args[1],args[2])
    end
end)

exports("setWanted",setWanted)
exports("checkWanted",checkWanted)
exports("removeWanted",removeWanted)
exports("dispatchPolice",dispatchPolice)

RegisterCommand("teste-w",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    exports["wanted"]:setWanted(userId,30)
end)