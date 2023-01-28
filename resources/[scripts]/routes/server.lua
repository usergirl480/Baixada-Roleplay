local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
local Tools = module("vrp","lib/Tools")
Api = {}
Tunnel.bindInterface(GetCurrentResourceName(),Api)

local workingControl = {}
local items = config_routes.itemlist

function Api.getItems(type)
    local tb_ = {}
    for k, v in pairs(items[type].items) do
        tb_[k] = {}
        tb_[k].name = itemName(k)
    end
    return tb_
end

function Api.checkPermissao(type)
    local source = source
    local userId = vRP.getUserId(source)
    if items[type] then
        for k, v in pairs(items[type].permissions) do
            if exports["common"]:Group().hasPermission(userId,v) or exports["common"]:Group().hasPermission(userId,"staff") then
                return true
            end
        end
    end
    return false
end

function Api.checkPayment()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if workingControl[userId] then
            local workingAmount = math.random(2,4)
            if vRP.inventoryWeight(userId) + itemWeight(workingControl[userId].code)*workingAmount <= vRP.getBackpack(userId) then
                vRP.giveInventoryItem(userId,workingControl[userId].code,workingAmount,true)
                vRP.upgradeStress(userId,1)
                return true
            else
                TriggerClientEvent("Notify",source,"negado","Você não tem espaço em sua mochila")
                return false  
            end
        end
    end
end

RegisterServerEvent("routes:selectRoute")
AddEventHandler("routes:selectRoute", function(type, code)
    local source = source
    local userId = vRP.getUserId(source)
    local item = itemName(code)

    if not userId or not item then
        return false
    end

    workingControl[userId] = { type = type, code = code }

    TriggerClientEvent("routes:startRoute", source, type, item)
    TriggerClientEvent("routes:exit", source)
end)

local function resetTable(userId) 
    if workingControl[userId] then
        workingControl[userId] = nil
    end
end

RegisterServerEvent("routes:endRoute")
AddEventHandler("routes:endRoute", function(type, code)
    local source = source
    local userId = vRP.getUserId(source)
    resetTable(userId)
end)

AddEventHandler("playerDropped",function()
    local source = source
    local userId = vRP.getUserId(source)
    resetTable(userId)
end)