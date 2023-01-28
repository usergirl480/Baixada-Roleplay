RegisterCommand("pon",function(source,args,rawCmd)
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"staff") then
        return
    end

    local users = vRP.userList()
    local playerList = ""
    for k,v in pairs(users) do
        playerList = playerList..k..", "
    end

    TriggerClientEvent("Notify",source,"default","Jogadores conectados: <b>"..GetNumPlayerIndices().."<br>"..playerList,20000,"normal","atenção")
end)

-- RegisterNetEvent("admin:squadOnline",function() - [TERMINAR DEPOIS]

-- RegisterCommand("teste",function(source,args,rawCommand)
--     local source = source
--     local userId = vRP.getUserId(source)
--     if not exports["common"]:Group().hasPermission(userId,"staff") then
--         return
--     end
    
--     TriggerClientEvent("dynamic:closeSystem",source)

--     local targetSquad = vRP.prompt(source,"Squad:","")
--     if targetSquad == "" then return end

--     local identity = vRP.userIdentity(userId)
    
--     targetSquad = squadName.squad

--     local playersCount = exports["common"]:Group().getAllByPermission(squadName.squad)

--     local squadStr = ""
--     for k,v in pairs(playersCount) do
--         local userId = vRP.getUserId(parseInt(v))
--         if userId then
--             local identity = vRP.userIdentity(userId)
--             squadStr = squadStr.."<b>"..userId.."</b>: "..identity.name.." "..identity.name2.."<br>"
--         end
--     end

--     TriggerClientEvent("Notify",source,"default","Atualmente <b>"..#playersCount.."</b> conectado(s).<br>"..squadStr.."",30000,"normal",""..squadName.squad.."")
-- end)

RegisterNetEvent("squads:squadService",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"staff") then
        return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    local squadsQuery = exports.oxmysql:query_async("SELECT * FROM squads")
    if #squadsQuery <= 0 then
        return TriggerClientEvent("Notify",source,"sucesso","Não há nenhum Squad registrado.")
    end
    
    local str = ""
    
    for k,v in pairs(squadsQuery) do
        local playersOn = exports["common"]:Group().getAllByPermission(v.squad)
        if #playersOn > 0 then 
            str = str.."<b>Nome:</b> "..v.squad_name.." (<b>"..#playersOn.."</b>) <br>"
        end
    end
     
    TriggerClientEvent("Notify",source,"sucesso","<b>Squads ativos:</b><br>"..str.."",20000,"normal")
end)

RegisterCommand("staff",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"staff") then
        return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    local staffAmount = exports["common"]:Group().getAllByPermission("staff")
    if #staffAmount <= 0 then
        TriggerClientEvent("Notify",source,"negado","Nenhum staff conectado.",10000,"bottom")
        return
    end

    local staffStr = ""

    for k,v in pairs(staffAmount) do
        local userId = vRP.getUserId(parseInt(v))
        if userId then
            local identity = vRP.userIdentity(userId)
            staffStr = staffStr.."<b>"..userId.."</b>: "..identity.name.." "..identity.name2.."<br>"
        end
    end

    TriggerClientEvent("Notify",source,"sucesso","Atualmente <b>"..#staffAmount.."</b> staff conectado(s).<br>"..staffStr.."",30000)
end)

RegisterCommand("s",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"staff") then
        return
    end

    if not args[1] then return end

    local identity = vRP.userIdentity(user_id)
    local adminCount = exports["common"]:Group().getAllByPermission("staff")
    for k,v in pairs(adminCount) do
        async(function()
            TriggerClientEvent("chatME",v,"^8[STAFF] "..identity["surname"]..": ^4"..rawCommand:sub(3))
        end)
    end
    exports["common"]:Log().embedDiscord(user_id,"commands-chat","**CHAT:**```"..rawCommand:sub(3).."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
end)

RegisterCommand("vip",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then 
        local consult = exports.oxmysql:query_async("SELECT `category`, `expire_time` FROM vips WHERE steam = @steam AND `is_active` = true",{ steam = vRP.getSteam(user_id) })
        if #consult > 0 then 
            for k,v in pairs(consult) do
                if v.expire_time then 
                    TriggerClientEvent("Notify",source,"default","<b>VIP</b>: "..v.category.." <b>Restante</b>: "..exports["common"]:PlayedTime().format(v.expire_time - os.time()),10000,"normal","atenção")
                end
            end
        end
    end
end)

RegisterCommand("produtos",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then 
        local consult = exports.oxmysql:query_async("SELECT `product`, `expire_time` FROM buyers WHERE steam = @steam AND `is_active` = true",{ steam = vRP.getSteam(user_id) })
        if #consult > 0 then 
            for k,v in pairs(consult) do
                if v.expire_time then 
                    TriggerClientEvent("Notify",source,"sucesso","<b>"..v.product.."</b> - "..exports["common"]:PlayedTime().format(v.expire_time - os.time()),15000,"normal")
                end
            end
        end
    end
end)

RegisterNetEvent("admin:checkCars",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"staff") then
        return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end 

    local vehicle = exports.oxmysql:query_async("SELECT * FROM characters_vehicles WHERE user_id = @user_id",{ user_id = targetId })
    if #vehicle > 0 then 
        local notify = ""
        for k,v in pairs(vehicle) do 
            notify = notify.."<br>"..vehicleName(v.vehicle).."<b> ("..v.vehicle..")</b>"
        end
        TriggerClientEvent("Notify",source,"default","Lista de veículos:<br>"..notify,20000,"normal","atenção")
    else
        TriggerClientEvent("Notify",source,"negado","O usuário não possuí nenhum <b>veículo</b>.",10000,"bottom")
    end
end)

RegisterNetEvent("admin:checkVips",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"staff") then
		return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local consult = exports.oxmysql:query_async("SELECT * FROM vips WHERE steam = @steam",{ steam = vRP.getSteam(parseInt(targetId)) })
    if #consult > 0 then 
        for k,v in pairs(consult) do
            if v.is_active and v.expire_time then
                TriggerClientEvent("Notify",source,"sucesso","<b>"..v.category.."</b> - "..exports["common"]:PlayedTime().format(v.expire_time - os.time()),15000)

            end
        end
    end
end)

RegisterNetEvent("admin:checkBuyers",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"staff") then
		return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local consult = exports.oxmysql:query_async("SELECT * FROM buyers WHERE steam = @steam",{ steam = vRP.getSteam(parseInt(targetId)) })
    if #consult > 0 then 
        for k,v in pairs(consult) do
            if v.is_active and v.expire_time then
                TriggerClientEvent("Notify",source,"sucesso","<b>"..v.product.."</b> - "..exports["common"]:PlayedTime().format(v.expire_time - os.time()),15000)
            end
        end
    end
end)

RegisterNetEvent("admin:setGaragesVips",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(user_id,"cto") then
		return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local steam = vRP.getSteam(targetId)
    if steam then
        vRP.execute("characters/updateGarages",{ id = parseInt(targetId) })
        exports["common"]:Log().embedDiscord(user_id,"commands-addvip","**ID:**```"..targetId.."```\n**ADICIONOU-GARAGEM:**``` \nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> recebeu <b>"..parseInt(amountCar).."</b> garagem de benefício VIP.")
    end

end)

RegisterNetEvent("admin:setHouseVips",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(user_id,"cto") then
		return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local amountHouses = vRP.prompt(source, "Insira quantia de casas:","")
    if amountHouses == "" or parseInt(amountHouses) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira uma quantia válida.",10000,"bottom")
    end

    local steam = vRP.getSteam(targetId)
    if steam then
        exports["store"]:Appointments().addSpecificReward({ steam = steam, more_houses = parseInt(amountHouses) }, 'houses')
		exports["common"]:Log().embedDiscord(user_id,"commands-addvip","**ID:**```"..targetId.."```\n**ADICIONOU-CASAS:**```"..amountHouses.." \nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> recebeu <b>"..parseInt(amountCar).."</b> casas de benefício VIP.")
    end

end)

RegisterNetEvent("admin:setCarVips",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(user_id,"cto") then
		return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source,"Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local amountCar = vRP.prompt(source,"Insira a quantidade de carros:","")
    if amountCar == "" or parseInt(amountCar) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira uma quantidade válida.",10000,"bottom")
    end

    local steam = vRP.getSteam(targetId)
    if steam then
        exports["store"]:Appointments().addSpecificReward({ steam = steam, more_vehicles = parseInt(amountCar) }, 'vehicles')
		exports["common"]:Log().embedDiscord(user_id,"commands-addvip","**ID:**```"..targetId.."```\n**ADICIONOU-CARROS:**```"..amountCar.." \nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> recebeu <b>"..parseInt(amountCar).."</b> carros de benefício VIP.")
    end

end)

RegisterNetEvent("admin:setPlayerVips",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(user_id,"cto") then
		return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    local vips_category = { "basic", "standard", "advanced", "premium", "ultimate", }

    local function checkNameVip(name) 
        for k,v in pairs(vips_category) do
            if v == name then 
                return true 
            end
        end
        return false
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local categoryVip = vRP.prompt(source, "Insira a categoria do vip:",table.concat(vips_category, ', '))
    if categoryVip == "" or not checkNameVip(categoryVip) then 
        return TriggerClientEvent("Notify",source,"negado","Insira uma categoria válida.",10000,"bottom")
    end

    local daysVip = vRP.prompt(source, "Insira a quantidade de dias:","")
    if daysVip == "" or parseInt(daysVip) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira uma quantidade válida.",10000,"bottom")
    end

    local priorityValue = vRP.prompt(source, "Insira a prioridade de fila:","")
    if priorityValue == "" or parseInt(priorityValue) <= 0 or parseInt(priorityValue) > 100 then 
        return TriggerClientEvent("Notify",source,"negado","Insira uma prioridade válida.",10000,"bottom")
    end

    local charsValue = vRP.prompt(source, "Insira a quantidade de personagens:","1")
    if charsValue == "" or parseInt(charsValue) <= 0 or parseInt(charsValue) > 2 then 
        return TriggerClientEvent("Notify",source,"negado","Insira uma quantidade válida.",10000,"bottom")
    end

    local steam = vRP.getSteam(parseInt(targetId))
    if steam then
        exports["store"]:Appointments().generateVipPerDays({ steam = steam, category = categoryVip, timeInDays = parseInt(daysVip), priority = parseInt(priorityValue), max_chars = parseInt(charsValue) })
        exports["common"]:Log().embedDiscord(user_id,"commands-addvip","**ID:**```"..targetId.."```\n**ADICIONOU-VIP:**```"..categoryVip.." ```\n**DIAS:**```"..daysVip.."```\n**Prioridade:**```"..priorityValue.."```\n**Max Chars:**```"..charsValue.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..parseInt(targetId).."</b> recebeu <b>"..parseInt(daysVip).."</b> dias de VIP <b>"..categoryVip.."</b>.")
    end
end)

RegisterNetEvent("admin:setBuyers",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(user_id,"cto") then
		return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    local productList = { "clothes", "speaker", "tuning", "tv", "verified", }

    local function checkProduct(name) 
        for k,v in pairs(productList) do
            if v == name then 
                return true 
            end
        end
        return false
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local productName = vRP.prompt(source, "Insira o nome do produto:",table.concat(productList, ', '))
    if productName == "" or not checkProduct(productName) then 
        return TriggerClientEvent("Notify",source,"negado","Insira um produto válido.",10000,"bottom")
    end

    local daysBuyers = vRP.prompt(source, "Insira a quantidade de dias:","")
    if daysBuyers == "" or parseInt(daysBuyers) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira uma quantidade válida.",10000,"bottom")
    end

    local steam = vRP.getSteam(parseInt(targetId))
    if steam then
        exports["store"]:Buyers().generateBuyerPerDays({ steam = steam, product = productName, timeInDays = parseInt(daysBuyers) })
        exports["common"]:Log().embedDiscord(user_id,"commands-addvip","**ID:**```"..targetId.."```\n**ADICIONOU-VIP:**```"..productName.." ```\n**DIAS:**```"..daysBuyers.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..parseInt(targetId).."</b> recebeu <b>"..parseInt(daysBuyers).."</b> dias de <b>"..productName.."</b>.")
    end
end)

RegisterNetEvent("admin:addCryptos",function()
    local source = source
	local userId = vRP.getUserId(source)
	if userId then
		if not exports["common"]:Group().hasAccessOrHigher(userId,"cto") then
			return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
		end

		TriggerClientEvent("dynamic:closeSystem",source)

		local targetId = vRP.prompt(source, "Insira o passaporte:","")
        if targetId == "" or parseInt(targetId) <= 0 then 
            return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
        end

		targetId = parseInt(targetId)

		local amount = vRP.prompt(source,"Quantidade:","")
		if amount == "" then return end
		amount = parseInt(amount)
		
		exports["store"]:Crypto().add(targetId,amount)
		exports["common"]:Log().embedDiscord(userId,"commands-crypto","**ID:**```"..targetId.."```\n**ADICIONOU:**```"..parseInt(amount).." Cryptos```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)

		TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> recebeu <b>"..amount.." Cryptos</b>.")
	end
end)

RegisterNetEvent("admin:removeCryptos",function()
    local source = source
	local userId = vRP.getUserId(source)
	if userId then
		if not exports["common"]:Group().hasAccessOrHigher(userId,"cto") then
			return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
		end

		TriggerClientEvent("dynamic:closeSystem",source)
		
		local targetId = vRP.prompt(source, "Insira o passaporte:","")
        if targetId == "" or parseInt(targetId) <= 0 then 
            return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
        end

		targetId = parseInt(targetId)

		local amount = vRP.prompt(source,"Quantidade:","")
		if amount == "" then return end
		amount = parseInt(amount)
		
		local res = exports["store"]:Crypto().remove(targetId,amount)
		if res then
			TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> perdeu <b>"..amount.." Cryptos</b>.")
			exports["common"]:Log().embedDiscord(userId,"commands-crypto","**ID:**```"..targetId.."```\n**REMOVEU:**```"..parseInt(amount).." Cryptos```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
		else
			TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> não possui <b>"..amount.." Cryptos</b>.")
		end
	end
end)

RegisterNetEvent("admin:checkCryptos",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"staff") then
        return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local consult = exports.oxmysql:single_async("SELECT crypto FROM accounts WHERE steam = @steam",{ steam = vRP.getSteam(parseInt(targetId)) })
    TriggerClientEvent("Notify",source,"default","O usuário possuí <b>"..consult.crypto.."</b> Cryptos.",10000,"normal","atenção")
end)

RegisterNetEvent("admin:addCars",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(user_id,"admin") then
        return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local carName = vRP.prompt(source,"Nome do veículo:","")
    if carName == "" then return end

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    if vehicleName(carName) then 
        local vehicle = exports.oxmysql:query_async("SELECT * FROM characters_vehicles WHERE user_id = @user_id AND vehicle = @vehicle",{ user_id = targetId, vehicle = carName })
        if not vehicle[1] then 
			vRP.execute("vehicles/addVehicles",{ user_id = targetId, vehicle = carName, plate = vRP.generatePlate(), work = tostring(false) })
            TriggerClientEvent("Notify",source,"sucesso","<b>"..carName.."</b> adicionado para o usuário <b>"..targetId.."</b>",10000,"bottom")
            exports["common"]:Log().embedDiscord(user_id,"commands-addcar","**ID:**```"..targetId.."```\n**VEÍCULO:**```"..carName.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        else
            TriggerClientEvent("Notify",source,"negado","O usuário já possuí este <b>veículo</b>.",10000,"bottom")
        end
    else
        TriggerClientEvent("Notify",source,"negado","Este veículo não existe.",10000,"bottom")
    end
end)

RegisterNetEvent("admin:removeCars",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(user_id,"admin") then
        return
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local carName = vRP.prompt(source,"Nome do veículo:","")
    if carName == "" then return end

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    if vehicleName(carName) then
        local vehicle = exports.oxmysql:query_async("SELECT * FROM characters_vehicles WHERE user_id = @user_id AND vehicle = @vehicle",{ user_id = targetId, vehicle = carName })
        if vehicle[1] then 
			vRP.execute("vehicles/removeVehicles",{ user_id = targetId, vehicle = carName })
            TriggerClientEvent("Notify",source,"sucesso","<b>"..carName.."</b> removido do usuário <b>"..targetId.."</b>",10000,"bottom")
            exports["common"]:Log().embedDiscord(user_id,"commands-remcar","**ID:**```"..targetId.."```\n**VEÍCULO:**```"..carName.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        else
            TriggerClientEvent("Notify",source,"negado","O usuário não possuí este <b>veículo</b>.",10000,"bottom")
        end
    else
        TriggerClientEvent("Notify",source,"negado","Este veículo não existe.",10000,"bottom")
    end
end)

RegisterNetEvent("admin:consultSerial",function()
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetSerial = vRP.prompt(source,"Serial:","")
    if targetSerial == "" then return end

    local sqlQuery = exports.oxmysql:query_async("SELECT `id` FROM `characters` WHERE `serial` = @serial",{ serial = targetSerial })
    if #sqlQuery > 0 then
        TriggerClientEvent("Notify",source,"sucesso","Serial <b>"..targetSerial.."</b> pertence ao usuário <b>"..sqlQuery[1].id.."</b>.",10000,"bottom")
    else
        TriggerClientEvent("Notify",source,"negado","Serial não encontrado.",10000,"bottom")
    end
end)

RegisterNetEvent("admin:renameUsers",function()
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
        return TriggerClientEvent("Notify",source,"negado","Você não tem permissão para realizar esta ação.")
    end
    
    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o passaporte:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local otherIdentity = vRP.userIdentity(targetId)

    local newName = vRP.prompt(source, "Novo nome (Tab para não alterar):",""..otherIdentity.name)
    local newName2 = vRP.prompt(source, "Novo sobrenome (Tab para não alterar):",""..otherIdentity.name2)
    local newSurname = vRP.prompt(source, "Novo apelido (Tab para não alterar):",""..otherIdentity.surname)

    exports["oxmysql"]:query_async("UPDATE `characters` SET `name` = @name, `name2` = @name2, `surname` = @surname WHERE `id` = @id",{
        id = parseInt(targetId),
        name = newName == "" and otherIdentity.name or newName,
        name2 = newName2 == "" and otherIdentity.name2 or newName2,
        surname = newSurname == "" and otherIdentity.surname or newSurname,
    })
    TriggerEvent("identity:atualizar",tonumber(targetId))
    TriggerClientEvent("Notify",source,"sucesso","Identidade atualizada com sucesso.",10000,"bottom")
    exports["common"]:Log().embedDiscord(userId,"rename","**NOME:**```"..newName.."```\n**SOBRENOME:**```"..newName2.."```\n**APELIDO:**```"..newSurname.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
end)

RegisterCommand("clearinv",function(source,args,rawCmd)
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end

    if not args[1] then return end

    local targetSource = vRP.userSource(parseInt(args[1]))
    if targetSource then
        local targetId = vRP.getUserId(targetSource)
        if vRP.request(source,"Você deseja limpar o inventário de <b>"..args[1].."</b>?",30) then 
            TriggerClientEvent("player:endGame",targetSource)
            TriggerClientEvent("Notify",source,"sucesso","Usuário <b>"..targetId.."</b> teve seu inventário limpo.",10000,"bottom")
            exports["common"]:Log().embedDiscord(userId,"commands-clearinv","**ID:**```"..targetId.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
        end
    end
end)

RegisterNetEvent("admin:resetChest",function()
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
        return
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetChest = vRP.prompt(source,"Baú:","")
    if targetChest == "" then return end

    local getSData = vRP.getSrvdata("stackChest:"..targetChest)
    if getSData then 
        if vRP.request(source,"Você realmente deseja resetar o baú <b>"..targetChest.."</b>?",30) then 
            vRP.remSrvdata("stackChest:"..targetChest)
            TriggerClientEvent("Notify",source,"sucesso","O baú <b>"..targetChest.."</b> foi resetado.",10000,"bottom")
        end
    end
end)

RegisterCommand("pv",function(source,args,rawCommand)
    local source = source
    local userId = vRP.getUserId(source)
    if userId then

        local squadName = exports["common"]:Group().getSquad(userId)
        if squadName == nil then 
            return TriggerClientEvent("Notify",source,"negado","Você não pertence a um <b>Squad</b>.",10000,"bottom")
        end

        if not args[1] then return end
        
        local identity = vRP.userIdentity(userId)
        local playersCount = exports["common"]:Group().getAllByPermission(squadName.squad)
        for k,v in pairs(playersCount) do
            async(function()
                TriggerClientEvent("chatME",v,"^8["..squadName.squadName.. "] "..identity["surname"]..": ^4"..rawCommand:sub(3))
            end)
        end
    end
end)

RegisterNetEvent("admin:setBackpack",function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then 
        if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
            return
        end

        TriggerClientEvent("dynamic:closeSystem",source)

        local targetId = vRP.prompt(source, "Insira o passaporte:","")
        if targetId == "" or parseInt(targetId) <= 0 then 
            return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
        end

		local amount = vRP.prompt(source,"Quantidade:","")
		if amount == "" then return end
		amount = parseInt(amount)
        
		targetId = parseInt(targetId)

        local targetSource = vRP.userSource(targetId)
        if targetSource then
            if vRP.getBackpack(targetId) + parseInt(amount) >= 100 then
                return TriggerClientEvent("Notify",source,"negado","O usuário excedeu o limite de <b>100KG</b>.",10000,"bottom")
            end
            TriggerClientEvent("Notify",source,"sucesso","Você adicionou <b>"..amount.."KG</b> de mochila para o usuário <b>"..targetId.."</b>",10000,"bottom")
            vRP.giveBackpack(targetId,parseInt(amount))
        else
            TriggerClientEvent("Notify",source,"negado","Usuário desconectado.",10000,"bottom")
        end
    end
end)

RegisterNetEvent("admin:newChest", function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
            return
        end

        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)

        TriggerClientEvent("dynamic:closeSystem",source)
        
        local chestName = vRP.prompt(source,"Nome do baú:","")
        if chestName == "" then return end

        local chestWeight = vRP.prompt(source,"Tamanho do baú:","300")
        if chestWeight == "" then return end
        chestWeight = parseInt(chestWeight)

        local chestPermission = vRP.prompt(source,"Permissão:","")
        if chestPermission == "" then return end
        chestPermission = chestPermission:lower()

        local chestCoords = vRP.prompt(source,"Coords:",mathLegth(coords[1])..","..mathLegth(coords[2])..","..mathLegth(coords[3])..","..mathLegth(GetEntityHeading(ped)))
        if chestCoords == "" then return end

        local chestFormatted = "["..chestCoords.."]"

        exports.oxmysql:query("INSERT INTO `chests` (`name`,`weight`,`perm`,`coords`) VALUES (@name,@weight,@perm,@coords)",{ name = chestName, weight = chestWeight, perm = chestPermission, coords = chestFormatted, logs = true })
        TriggerClientEvent("Notify",source,"sucesso","Baú <b>"..chestName.."</b> criado com sucesso.",10000,"bottom")
        exports.chest:loadChests()
    end
end)

RegisterNetEvent("admin:deleteChest", function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
            return
        end

        TriggerClientEvent("dynamic:closeSystem",source)
        
        local chestName = vRP.prompt(source,"Nome do baú:","")
        if chestName == "" then return end
        
        local chestExists = exports.oxmysql:query_async("SELECT `id` FROM `chests` WHERE `name` = @name",{ name = chestName })
        if #chestExists >= 0 then
            exports.oxmysql:query("DELETE FROM `chests` WHERE `name` = @name",{ name = chestName })
            TriggerClientEvent("Notify",source,"sucesso","Baú <b>"..chestName.."</b> deleteado com sucesso.",10000,"bottom")
            exports.chest:loadChests()
        end
    end
end)

RegisterNetEvent("admin:listChest", function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
            return
        end

        TriggerClientEvent("dynamic:closeSystem",source)
        
        local chestExists = exports.oxmysql:query_async("SELECT `name` FROM `chests`",{})
        if #chestExists >= 0 then
            local chestStr = ""
            for k,v in pairs(chestExists) do
                chestStr = chestStr.."<b>"..v.name.."</b><br>"
            end

            TriggerClientEvent("Notify",source,"default",chestStr,20000,"normal","ATENÇÃO")
        end
    end
end)

RegisterCommand("mochila",function(source,args,rawCommand)
    local source = source
    local userId = vRP.getUserId(source)
    if userId then 
        if not exports["common"]:Group().hasAccessOrHigher(userId,"dev") then
            return
        end
        vRP.giveBackpack(userId,parseInt(args[1]))
        TriggerClientEvent("Notify",source,"sucesso","Mochila adicionada.",10000,"bottom")
    end
end)

RegisterCommand("remmochila",function(source,args,rawCommand)
    local source = source
    local userId = vRP.getUserId(source)
    if userId then 
        if not exports["common"]:Group().hasAccessOrHigher(userId,"dev") then
            return
        end
        vRP.removeBackpack(userId)
        TriggerClientEvent("Notify",source,"sucesso","Mochila removida.",10000,"bottom")
    end
end)

RegisterCommand("tpcar",function(source,args,rawCmd)
    local source = source
	local userId = vRP.getUserId(source)
    if userId then 
        if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
            return
        end

        if not args[1] then
            local targetSource = vRP.getUserSource(parseInt(args[1]))
            TriggerClientEvent("admin:setInVehiclePlayer",source,targetSource)
            TriggerClientEvent("Notify",source,"sucesso","Você se teletransportou para o veículo mais próximo.",10000,"bottom")
        else
            TriggerClientEvent("admin:setInVehicle",source)
            TriggerClientEvent("Notify",source,"sucesso","Você se teletransportou para um veículo.",10000,"bottom")
        end
    end
end)