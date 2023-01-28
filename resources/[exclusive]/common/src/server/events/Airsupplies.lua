local airSupplyProperties = {
    ["airSupply"] = {
        coords = nil
    },
    ["Container"] = {
        coords = nil
    },
}
local airSupplyConfig = {
    ["airSupply"] = {
        ["eventName"] = {"common:airsupply:client:start", "common:airsupply:client:stop"},
        ["positions"] = {
            { -786.0,-2401.01,14.95 },
            { -1387.0,-1570.02,2.91 },
            { -1239.45,104.92,56.46 },
            { 460.0,612.99,188.94 },
            { 2956.0,2488.99,164.93 },
            { 2956.69,2489.5,164.4 },
            { 2103.29,-1233.77,169.32 },
            { 1598.26,-2599.21,52.6 },
            { -545.47,1251.55,322.22 },
            { 473.6,1456.5,348.05 },
            { -556.52,4192.74,191.84 },
            { -900.23,6047.71,43.76 },
            { -1429.09,5401.24,23.45 },
            { 1914.14,6494.27,96.95 },
            { 3311.36,5040.85,22.24 },
            { 1523.0,6616.45,2.38 },
            { 1458.22,3143.65,41.01 },
            { -902.72,4820.17,304.56 },
            { -1187.77,3854.38,490.08 },
            { 514.77,5515.72,773.73 },
        },
        ["rewards"] = {
            { item = "ammofragment", amount = 350 },
            { item = "weaponfragment", amount = 350 },
            { item = "drugsfragment", amount = 350 },
            { item = "washfragment", amount = 350 },
            { item = "copper", amount = 200 },
            { item = "aluminum", amount = 200 },
        },
    },

    ["Container"] = {
        ["eventName"] = {"common:cointainer:client:start", "common:cointainer:client:stop"},
        ["positions"] = {
             { 1151.87,-3081.85,5.78 }
        },
        ["rewards"] = {
            { item = "ammofragment", amount = 350 },
            { item = "weaponfragment", amount = 350 },
            { item = "drugsfragment", amount = 350 },
            { item = "washfragment", amount = 350 },
            { item = "copper", amount = 200 },
            { item = "aluminum", amount = 200 },
        },
    },
}



local function stopAirSupply(type)
    airSupplyProperties[type].coords = nil
    TriggerClientEvent(airSupplyConfig[type]["eventName"][2],-1)
end

local function initAirSupply(type)
    local coords = airSupplyConfig[type]["positions"][math.random(#airSupplyConfig[type]["positions"])]
    airSupplyProperties[type].coords = coords

    TriggerClientEvent(airSupplyConfig[type]["eventName"][1],-1,{ x = coords[1], y = coords[2], z = coords[3]  })
end

function server.supplyCrate(x,y,z,gridZone,type)
    local randomReward = math.random(#airSupplyConfig[type]["rewards"])
    local selectedReward = airSupplyConfig[type]["rewards"][randomReward]

    exports.inventory:createDrop(selectedReward.item,selectedReward.amount,x,y,z,gridZone,1)
end


RegisterCommand("start-container",function(source,args,rawCmd)
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"dev") then
        return
    end

    initAirSupply('Container')
end)

RegisterCommand("stop-container",function(source,args,rawCmd)
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"dev") then
        return
    end

    stopAirSupply('Container')
end)

RegisterCommand("start-supply",function(source,args,rawCmd)
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"dev") then
        return
    end

    initAirSupply('airSupply')
end)

RegisterCommand("stop-supply",function(source,args,rawCmd)
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"dev") then
        return
    end

    stopAirSupply('airSupply')
end)

-- Citizen.CreateThread(function()
--     Citizen.Wait(3000)
--     local lastHour
--     while true do
--         Citizen.Wait(5*60*1000)

--         local time = os.date("*t")
--         local hour = parseInt(time.hour)
--         if (hour == 13 or hour == 16 or hour == 19 or hour == 22 or hour == 01) and lastHour ~= hour then
--             lastHour = hour
--             initAirSupply()
--             Citizen.SetTimeout(1000 * 60 * 10, function()
--                 stopAirSupply()
--             end)
--         end
--     end
-- end)