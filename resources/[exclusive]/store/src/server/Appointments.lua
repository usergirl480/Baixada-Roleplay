Appointments = {}

function Appointments.generateVipPerDays(params)
    local timeConverted = params.timeInDays * 86400 + os.time()

    local alreadyHasVipQuery = exports.oxmysql:query_async("SELECT `id`, `expire_time` FROM `vips` WHERE `category` = @category AND `is_active` = true AND `steam` = @steam",{ category = params.category, steam = params.steam })
    if #alreadyHasVipQuery > 0 then
        local newExpire = alreadyHasVipQuery[1].expire_time + (params.timeInDays * 86400)
        exports.oxmysql:query("UPDATE `vips` SET `expire_time` = @expireTime WHERE `id` = @id",{ id = alreadyHasVipQuery[1].id, expireTime = newExpire })
        return
    end

    local insertId = exports.oxmysql:query_async("INSERT INTO `vips` (`steam`,`category`,`expire_time`) VALUES (@steam,@category,@expire_time)",{ steam = params.steam, category = params.category, expire_time = timeConverted }).insertId
    if params.priority then
        exports.oxmysql:query("UPDATE `vips` SET `priority` = @priority WHERE `id` = @id",{ id = insertId, priority = params.priority })
    end
    
    if params.max_chars then
        exports.oxmysql:query("UPDATE `vips` SET `max_chars` = @max_chars WHERE `id` = @id",{ id = insertId, max_chars = params.max_chars })
    end

    if params.more_vehicles then 
        exports.oxmysql:query("UPDATE `accounts` SET `vehicles` = vehicles + @vehicles WHERE `steam` = @steam",{ steam = params.steam, vehicles = params.more_vehicles }) 
    end

    if params.more_houses then 
        exports.oxmysql:query("UPDATE `accounts` SET `residences` = residences + @residences WHERE `steam` = @steam",{ steam = params.steam, residences = params.more_houses }) 
    end
end

function Appointments.addSpecificReward(params, type)
    if type == "vehicles" then 
        if params.more_vehicles then 
            exports.oxmysql:query("UPDATE `accounts` SET `vehicles` = vehicles + @vehicles WHERE `steam` = @steam",{ steam = params.steam, vehicles = params.more_vehicles })
            return true 
        end
    end

    if type == "houses" then 
        if params.more_houses then 
            exports.oxmysql:query("UPDATE `accounts` SET `residences` = residences + @residences WHERE `steam` = @steam",{ steam = params.steam, residences = params.more_houses }) 
            return true 
        end
    end

end

function Appointments.checkExpired()
    local query = exports.oxmysql:query_async("SELECT * FROM vips WHERE `is_active` = true AND `expire_time` IS NOT NULL")
    for k,v in pairs(query) do
        if os.time() >= v.expire_time then
            exports.oxmysql:query("UPDATE `vips` SET `is_active` = false, `expire_time` = NULL, `expired_at` = NOW() WHERE `id` = @id",{ id = v.id })
            print("[^2APPOINTMENTS^7] O pacote "..v.category.." do Usuário "..v.steam.." expirou. ["..os.date("%d/%m/%y %H:%M:%S").."]")
        end
    end
end

function Appointments.isVipById(userId,category)
    local steam = vRP.getSteam(userId)
    if steam then
        return Appointments.isVipBySteam(steam,category)
    end
    return false
end

function Appointments.isVipBySteam(steam,category)
    local query = exports.oxmysql:query_async("SELECT `category` FROM `vips` WHERE `steam` = @steam AND `is_active` = true",{ steam = steam })
    if #query > 0 then
        if not category then
            return true, query[#query].category
        else
            for k,v in pairs(query) do
                if v.category == category then
                    return true
                end
            end
        end
    end
    return false
end

function Appointments.maxCharsBySteam(steam)
    local averangeChars = 1
    local query = exports.oxmysql:query_async("SELECT `max_chars` FROM `vips` WHERE `steam` = @steam AND `is_active` = true",{ steam = steam })
    if #query > 0 then
        for k,v in pairs(query) do
            local maxChars = v.max_chars or 0
            if v.max_chars > averangeChars then
                averangeChars = v.max_chars
            end
        end
    end
    return averangeChars
end

AddEventHandler("onResourceStart",function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    Appointments.checkExpired()
end)

exports("Appointments",function()
    return Appointments
end)