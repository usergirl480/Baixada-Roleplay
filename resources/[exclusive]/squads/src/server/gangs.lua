-- local insiderCustomers = {}
-- local drugBoosted = nil
-- local drugsList = {
--     "cocaine",
--     "meth",
--     "joint"
-- }
-- local gangsStatements = {
--     ["salieris"] = {
--         ["chest"] = { coords = { -2361.01,3242.89,92.89,334.49 }, object = "p_v_43_safe_s" },
--         ["machine"] = { coords = { -2362.51,3245.71,92.89,240.95 }, object = "bkr_prop_weed_table_01a" },
--     },
-- }

-- Citizen.CreateThread(function()
--     Citizen.Wait(1000)
--     TriggerClientEvent("squads:gangs:loadStatements",-1,gangsStatements)
-- end)

-- AddEventHandler("vRP:playerSpawn",function(userId,source)
--     TriggerClientEvent("squads:gangs:loadStatements",source,gangsStatements)
-- end)

-- RegisterNetEvent("gangs:talkInsider",function()
--     local source = source
--     local userId = vRP.getUserId(source)
--     if not insiderCustomers[userId] then 
--         if vRP.request(source,"Eu posso te fornecer algumas informações, mas quero <b>$15000</b> sujo.",30) then
--             if vRP.tryGetInventoryItem(userId,"dollarsz",15000,true) then
--                 insiderCustomers[userId] = true
--                 TriggerClientEvent("Notify",source,"sucesso","Beleza, fica de olho no seu celular, daqui alguns minutos te envio algo.")
--                 TriggerClientEvent("gangs:insiderCustomer",source)
--             else
--                 TriggerClientEvent("Notify",source,"negado","Você precisa de <b>$15000</b> sujo.",10000)
--             end
--         end
--     else
--         TriggerClientEvent("Notify",source,"negado","Você já está na lista de envio das informações",10000)
--     end
-- end)

-- Citizen.CreateThread( function()
--     while true do
--         Citizen.Wait(600e3)

--         if drugBoosted then
--             exports["drugs"]:unboostPrice(drugBoosted)
--             drugBoosted = nil
--         end
    
--         if not drugBoosted then
--             local random = math.random(#drugsList)
--             drugBoosted = drugsList[random]
--             exports["drugs"]:boostPrice(drugBoosted,800)
--         end

--         if math.random(100) >= 90 then 
--             for k,v in pairs(insiderCustomers) do 
--                 local player = vRP.userSource(k)
--                 if player then 
--                     TriggerClientEvent("smartphone:createSMS",player,"X9","A polícia está na minha cola, estou apagando todos os meus contatos e mudando de lugar. Me procurem novamente em breve!")
--                     TriggerClientEvent("Notify",player,"sucesso","O seu contato foi deletado do celular do <b>X9</b>.",10000,"bottom")
--                     TriggerClientEvent("gangs:updatePed",-1)
--                 end
--             end
--             insiderCustomers = {}
--         end
--     end
-- end)

-- local information = {
--     [1] = { coords = vec3(-2073.23,-327.34,13.31), name = "Vendedor de Armas", desc = "vai lá dar uma conferida." },
--     [2] = { coords = vec3(646.07,267.24,103.26), name = "Vendedor de Armas", desc = "vai lá dar uma conferida." },
--     [3] = { coords = vec3(-141.86,-1697.48,30.77), name = "Vendedor de Drogas", desc = "vai lá dar uma conferida." },
--     [4] = { coords = vec3(54.16,-1873.34,22.8), name = "Vendedor de Drogas", desc = "vai lá dar uma conferida." },
--     [5] = { coords = vec3(1234.41,-354.88,69.08), name = "Vendedor de Drogas", desc = "vai lá dar uma conferida." },
--     [6] = { coords = vec3(2559.35,373.79,108.61), name = "Vendedor de Drogas", desc = "vai lá dar uma conferida." },
--     [7] = { coords = vec3(2562.1,2590.87,38.08), name = "Vendedor de Drogas", desc = "vai lá dar uma conferida." },
--     [8] = { coords = vec3(791.49,2176.58,52.64), name = "Vendedor de Drogas", desc = "vai lá dar uma conferida." },
--     [9] = { coords = vec3(346.48,3406.12,36.48), name = "Vendedor de Drogas", desc = "vai lá dar uma conferida." },
--     [10] = { coords = vec3(20.42,-1505.48,31.85), name = "Vendedor de Munições", desc = "vai lá dar uma conferida." },
--     [11] = { coords = vec3(240.66,-1379.4,33.73), name = "Vendedor de Munições", desc = "vai lá dar uma conferida." },
-- }

-- function src.requestUpdate(type)
--     local source = source
--     local userId = vRP.getUserId(source)
--     if insiderCustomers[userId] then
--         if type == "cops" then
--             local policeAmount = exports["common"]:Group().getAllByPermission("police")
--             if #policeAmount > 0 then
--                 TriggerClientEvent("smartphone:createSMS",source,"X9","Fica de olho aberto porquê tem "..#policeAmount.." políciais rodando por aí.")
--             else
--                 TriggerClientEvent("smartphone:createSMS",source,"X9","Fiquei sabendo que não tem nenhum policial em serviço.")
--             end
--         elseif type == "boost" then
--             if drugBoosted then
--                 TriggerClientEvent("smartphone:createSMS",source,"X9","Acabei de saber que "..drugBoosted.." está em alta neste momento.")
--             end
--         elseif type == "locations" then
--             local loc = information[math.random(#information)]
--             TriggerClientEvent("smartphone:createSMS",source,"X9","Encontrei um possível "..loc.name.." nesta localização, "..loc.desc,{ loc.coords.x,loc.coords.y,loc.coords.z })
--         end
--     end
-- end