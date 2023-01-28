local rewardList = {
    ["cupcake"] = {
        ["price"] = { 1500, 1500 },
        ["rand"] = { 4, 8 }
    },
    ["toy"] = {
        ["price"] = { 1500, 1500 },
        ["rand"] = { 4, 8 }
    },
    ["ominitrix"] = {
        ["price"] = { 1500, 1500 },
        ["rand"] = { 4, 8 }
    },
}

function src.noBaby()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if vRP.userIsBaby(userId) then
            TriggerClientEvent("Notify",source,"negado","Ação bloqueada.",5000,"bottom")
            return false
        end
    end
    return true
end

function src.reward()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        for k,v in pairs(rewardList) do
            local random = math.random(v.rand[1],v.rand[2])
            local consultItem = vRP.getInventoryItemAmount(userId,k)
            if consultItem[1] >= parseInt(random) then
                if vRP.tryGetInventoryItem(userId,k,random,true) then
                    vRP.upgradeStress(userId,2)
                    TriggerClientEvent("player:applyGsr",source)
                    TriggerClientEvent("sounds:source",source,"cash",0.05)

                    -- local reputationValue = math.random(1,6)
                    local randomPlusPrice = math.random(1500, 1500) * random
                    vRP.generateItem(userId,"dollarsz",randomPlusPrice,true)
                    
                    exports.common:Economy().jobAdd(userId,"drugs",randomPlusPrice)
                    vRP.upgradeStress(userId,2)
                    -- vRP.insertReputation(userId,"drugs",reputationValue)
                    -- TriggerClientEvent("Notify",source,"default","Você recebeu <b>+"..reputationValue.."</b> de Reputação como Vendedor de Drogas.",10000,"bottom","atenção")

                    --- Call police
                    if math.random(100) >= 75 then
                        local ped = GetPlayerPed(source)
                        local coords = GetEntityCoords(ped)
    
                        local policeResult = exports["common"]:Group().getAllByPermission("police")
                        for k,v in pairs(policeResult) do
                            async(function()
                                TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Venda de Drogas", x = coords["x"], y = coords["y"], z = coords["z"], time = "Recebido às "..os.date("%H:%M"), blipColor = 5 })
                            end)
                        end
                    end

                    return true
                end
            end
        end
    end
    return false
end

-- local old = nil
-- function boostPrice(item,newPrice)
-- 	if rewardList[item] then
--         old = rewardList[item]["price"]
-- 		rewardList[item]["price"][2] = newPrice 
-- 	end
-- end

-- function unboostPrice(item,newPrice)
-- 	if rewardList[item] then
-- 		rewardList[item]["price"][2] = old or 11500
--         old = nil 
-- 	end
-- end

-- exports("boostPrice",boostPrice)
-- exports("unboostPrice",unboostPrice)