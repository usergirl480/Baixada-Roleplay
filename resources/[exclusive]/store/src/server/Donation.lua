Donation = {}

function Donation.add(userId,category,time,priority,max_chars)
    local steam = vRP.getSteam(userId)
    if steam then
        exports["store"]:Appointments().generateVipPerDays({ steam = steam, category = category, timeInDays = time, priority = priority, max_chars = max_chars })
    end
end

exports("addDonation", function(userId,category,time,priority,max_chars)
    Donation.add(userId,category,time,priority,max_chars)
end)

exports("Donation",function()
    return Donation
end)