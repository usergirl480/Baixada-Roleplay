
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
src = {}
Tunnel.bindInterface("zo_cars", src)
vCLIENT = Tunnel.getInterface("zo_cars")


local function getUserTuning(key)
    local query = vRP.query("entitydata/getData",{ dkey = key }) or {}
    if #query > 0 then 
        return query[1].dvalue
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function src.permissionVIP()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local consultItem = vRP.getInventoryItemAmount(user_id,"wrench2")
		if vRP.checkBroken(consultItem[2]) then
			TriggerClientEvent("Notify",source,"negado","Item quebrado.",5000)
			return false
		end
		if exports["store"]:Buyers().isBuyerById(user_id,"tuning") or exports["common"]:Group().hasPermission(user_id,"staff") or consultItem[1] > 0 then
			return true
		end
	end
end

function src.checkPermission()
    local user_id = vRP.getUserId(source)
    if cfg.permissaoParaInstalar.existePermissao then
        for k, group in pairs(cfg.permissaoParaInstalar.permissoes) do
                if vRP.hasPermission(user_id, group) then
                return true
            end
        end
    else
        return true
    end
    return false
end

function src.checkPermissionShop(perm)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, perm) then
        return true
    end
    return false
end

function src.installXenon(car, plate, name)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.tryGetInventoryItem(user_id,"moduloxenon",1) then
        vRPclient._playAnim(source, true,{{"mini@repair","fixing_a_ped",1}},true)
        TriggerClientEvent("progress",source,30000,"Instalando m??dulo de Xenon")
        SetTimeout(31000, function()
            vRPclient.DeletarObjeto(source)
            vRPclient._stopAnim(source,false)
            TriggerEvent('lscustoms:setCustomTuning', plate, name, 'xenonControl')
        end)
    else
        TriggerClientEvent("Notify",source,"negado","Voc?? n??o possui um m??dulo xenon.")
    end
end



function src.checkXenon()
    local source = source
    local user_id = vRP.getUserId(source)
    local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 5)
    if vehicle and placa then
        local placa_user_id = vRP.userPlate(placa)
        if placa_user_id ~= nil then
            if user_id == placa_user_id and cfg.apenasDonoAcessaXenon then
	            local tuning = getUserTuning("custom:"..user_id..":"..vname) or {}
                local custom = json.decode(tuning) or {}
                if custom.xenonControl == 1 then
                    return true
                end
                return false
            else
	            local tuning = getUserTuning("custom:"..user_id..":"..vname) or {}
                local custom = json.decode(tuning) or {}
                if custom.xenonControl == 1 then
                    return true
                end
                return false
            end
        end
        
    end
    return false
end

function src.installNeon(car)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.tryGetInventoryItem(user_id,"moduloneon", 1) then
        vRPclient._playAnim(source, true,{{"mini@repair","fixing_a_ped",1}}, true)
        TriggerClientEvent("progress", source, 30000, "Instalando m??dulo de neon")
        SetTimeout(31000, function()
            vRPclient.DeletarObjeto(source)
            vRPclient._stopAnim(source, false)
            TriggerEvent('lscustoms:setCustomTuning', plate, name, 'neonControl')
        end)
    else
        TriggerClientEvent("Notify",source,"negado","Voc?? n??o possui um m??dulo de Neon.")
    end
end

function src.checkNeon()
    local source = source
    local user_id = vRP.getUserId(source)
    local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 5)
    if vehicle and placa then
        local placa_user_id = vRP.userPlate(placa)
        if placa_user_id ~= nil then
            if user_id == placa_user_id and cfg.apenasDonoAcessaNeon then
	            local tuning = getUserTuning("custom:"..user_id..":"..vname) or {}
                local custom = json.decode(tuning) or {}
                if custom.neonControl == 1 then
                    return true
                end
                return false
            else
	            local tuning = getUserTuning("custom:"..user_id..":"..vname) or {}

                local custom = json.decode(tuning) or {}
                
                if custom.neonControl == 1 then
                    return true
                end
                return false
            end
        end
        
    end
    return false
end

function src.anim()
    local source = source
    vRPclient._playAnim(source, false, {{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"}}, true)
    SetTimeout(7000, function()
        vRPclient.DeletarObjeto(source)
        vRPclient._stopAnim(source,false)
        vCLIENT.instalando(source, false)
    end)
end

function src.setSuspensao(pVehicle)
    local source = source
    local user_id = vRP.getUserId(source)
    local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 5)
    if vRP.tryGetInventoryItem(user_id, "suspensaoar", 1) then
        if vehicle == pVehicle then
            if vehicle and placa then
                local placa_user_id = vRP.userPlate(placa)
                if placa_user_id ~= nil then
                    local tuning = getUserTuning("custom:"..user_id..":"..vname) or {}
                    local custom = json.decode(tuning) or {}
                    custom.suspensaoAr = 1
		            vRP.execute("entitydata/setData",{ dkey = "custom:"..placa_user_id..":"..vname, value = json.encode(custom) })
                end
            end
        end
    else
        TriggerClientEvent("Notify",source,"negado","Voc?? n??o possui um Kit de suspens??o a ar.")
    end
end

function src.checkSuspension()
    local source = source
    local user_id = vRP.getUserId(source)
    local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 5)
    if vehicle and placa then
        local placa_user_id = vRP.userPlate(placa)
        if placa_user_id ~= nil then
            if user_id == placa_user_id and cfg.apenasDonoAcessaSuspensao then
                local tuning = getUserTuning("custom:"..user_id..":"..vname) or {}
                local custom = json.decode(tuning) or {}
                if custom.suspensaoAr == 1 then
                    return true
                end
                return false
            else
                local tuning = getUserTuning("custom:"..user_id..":"..vname) or {}
                local custom = json.decode(tuning) or {}
                
                if custom.suspensaoAr == 1 then
                    return true
                end
                return false
            end
        end
        
    end
    return false
end

function src.setPreset(value)
    local source = source
    local user_id = vRP.getUserId(source)
    local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 5)
    if vehicle and placa then
        local tuning = getUserTuning("custom:"..user_id..":"..vname) or {}
        local custom = json.decode(tuning) or {}
        custom.presetSuspe = value
        vRP.execute("entitydata/setData",{ dkey = "custom:"..user_id..":"..vname, value = json.encode(custom) })
    end
end

function src.returnPreset()
    local source = source
    local user_id = vRP.getUserId(source)
    local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 5)
    if vehicle and placa then
        local tuning = getUserTuning("custom:"..user_id..":"..vname) or {}
        local custom = json.decode(tuning) or {}
        if custom.presetSuspe ~= nil then
            return custom.presetSuspe
        end
        return 0
    end
    return 0
end

RegisterNetEvent("tryzosuspe")
AddEventHandler('tryzosuspe', function(vehicle, pAlturaAtual, pAlturaAnterior, variacao, type)
    local altura = pAlturaAnterior
    if type == "subir" then
        while altura > pAlturaAtual do
            altura = altura - variacao
            TriggerClientEvent("synczosuspe", -1, vehicle, altura)
            Citizen.Wait(1)
        end
    elseif type == "descer" then
        while altura < pAlturaAtual do
            altura = altura + variacao
            TriggerClientEvent("synczosuspe", -1, vehicle, altura)
            Citizen.Wait(1)
        end
    end
end)

-- RegisterServerEvent("departamento-comprar")
-- AddEventHandler("departamento-comprar",function(item)
--     local source = source
--     local user_id = vRP.getUserId(source)
--     if user_id then
--         for k, v in pairs(cfg.valores) do
--             if item == v.item then
--                 if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(v.item) * v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
--                     local preco = parseInt(v.compra)
--                     if preco then
--                         if vRP.tryPayment(user_id, parseInt(preco)) then
--                             TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(preco)).."</b>.")
--                             vRP.giveInventoryItem(user_id, v.item, parseInt(v.quantidade))
--                         else
--                             TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
--                         end
--                     end
--                 else
--                     TriggerClientEvent("Notify",source,"negado","Espa??o insuficiente.")
--                 end
--             end
--         end
--     end
-- end)