Crypto = {}

function Crypto.get(userId)
    local steam = vRP.getSteam(userId)
    if steam then
        local query = exports.oxmysql:query_async("SELECT `crypto` FROM `accounts` WHERE `steam` = @steam",{ steam = steam })
        return query[1].crypto or 0
    end
    return 0
end

function Crypto.add(userId,amount)
    local steam = vRP.getSteam(userId)
    if steam then
        exports.oxmysql:query("UPDATE `accounts` SET `crypto` = `crypto` + @amount WHERE `steam` = @steam",{ steam = steam, amount = amount })
    end
end

function Crypto.remove(userId,amount)
    local steam = vRP.getSteam(userId)
    if steam then
        if Crypto.get(userId) < amount then
            return false
        end

        exports.oxmysql:query("UPDATE `accounts` SET `crypto` = `crypto` - @amount WHERE `steam` = @steam",{ steam = steam, amount = amount })
        return true
    end
    return false
end

exports("addGems", function(userId, gems)
    Crypto.add(userId,gems)
end)

exports("Crypto",function()
    return Crypto
end)