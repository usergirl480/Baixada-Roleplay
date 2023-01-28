Buyers = {}

function Buyers.generateBuyerPerDays(params)
    local timeConverted = params.timeInDays * 86400 + os.time()

    local alreadyHasBuyerQuery = exports.oxmysql:query_async("SELECT `id`, `expire_time` FROM `buyers` WHERE `product` = @product AND `is_active` = true AND `steam` = @steam",{ product = params.product, steam = params.steam })
    if #alreadyHasBuyerQuery > 0 then
        local newExpire = alreadyHasBuyerQuery[1].expire_time + (params.timeInDays * 86400)
        exports.oxmysql:query("UPDATE `buyers` SET `expire_time` = @expireTime WHERE `id` = @id",{ id = alreadyHasBuyerQuery[1].id, expireTime = newExpire })
        return
    end

    exports.oxmysql:query_async("INSERT INTO `buyers` (`steam`,`product`,`expire_time`) VALUES (@steam,@product,@expire_time)",{ steam = params.steam, product = params.product, expire_time = timeConverted })
end

function Buyers.checkExpired()
    local query = exports.oxmysql:query_async("SELECT * FROM buyers WHERE `is_active` = true AND `expire_time` IS NOT NULL")
    for k,v in pairs(query) do
        if os.time() >= v.expire_time then
            exports.oxmysql:query("UPDATE `buyers` SET `is_active` = false, `expire_time` = NULL, `expired_at` = NOW() WHERE `id` = @id",{ id = v.id })
            print("[^2BUYERS^7] O item "..v.product.." do usuário "..v.steam.." expirou. ["..os.date("%d/%m/%y %H:%M:%S").."]")
        end
    end
end

function Buyers.isBuyerById(userId,product)
    local steam = vRP.getSteam(userId)
    if steam then
        return Buyers.isBuyerBySteam(steam,product)
    end
    return false
end

function Buyers.isBuyerBySteam(steam,product)
    local query = exports.oxmysql:query_async("SELECT `product` FROM `buyers` WHERE `steam` = @steam AND `is_active` = true",{ steam = steam })
    if #query > 0 then
        if not product then
            return true
        else
            for k,v in pairs(query) do
                if v.product == product then
                    return true
                end
            end
        end
    end
    return false
end

function Buyers.add(userId,product,time)
    local steam = vRP.getSteam(userId)
    if steam then
        exports["store"]:Buyers().generateBuyerPerDays({ steam = steam, product = product, timeInDays = time })
    end
end

exports("addBuyers", function(userId,product,time)
    Buyers.add(userId,product,time)
end)

AddEventHandler("onResourceStart",function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    Buyers.checkExpired()
end)

exports("Buyers",function()
    return Buyers
end)