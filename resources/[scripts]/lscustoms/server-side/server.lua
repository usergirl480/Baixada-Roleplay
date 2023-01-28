-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("lscustoms",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermission(hasPerm)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"negado","Multas pendentes encontradas.",10000,"bottom")
			return false
		end

		if exports["wanted"]:checkWanted(user_id) then
			return true
		end

		-- local consultReputation = vRP.checkReputation(user_id,"runner")
		-- if consultReputation < 50 then
		-- 	TriggerClientEvent("Notify",source,"negado","Você precisa de <b>50</b> de reputação como <b>Corredor(a)</b>.",10000,"bottom")
		-- 	return false
		-- end
							
		if not hasPerm then
			return true
		else
			if exports["common"]:Group().hasPermission(user_id,hasPerm) then
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:attemptPurchase")
AddEventHandler("lscustoms:attemptPurchase",function(type,mod)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if type == "engines" or type == "brakes" or type == "transmission" or type == "suspension" or type == "shield" then
			if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type][mod])) then
				TriggerClientEvent("lscustoms:purchaseSuccessful",source)
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end
		else
			if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type])) then
				TriggerClientEvent("lscustoms:purchaseSuccessful",source)
			else
				TriggerClientEvent("lscustoms:purchaseFailed",source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:updateVehicle")
AddEventHandler("lscustoms:updateVehicle",function(mods,vehPlate,vehName)
	local plateUser = vRP.userPlate(vehPlate)
	if plateUser then
		vRP.execute("entitydata/setData",{ dkey = "custom:"..plateUser..":"..vehName, value = json.encode(mods) })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:setCustomTuning")
AddEventHandler("lscustoms:setCustomTuning",function(vehPlate, vehName, type)
	local plateUser = vRP.userPlate(vehPlate)
	local vehMods = {}
	local custom = vRP.query("entitydata/getData",{ dkey = "custom:"..user_id..":"..vehName }) or {}
	if parseInt(#custom) > 0 then
		custom = json.decode(custom)
		vehMods = custom[1]["dvalue"]
		vehMods[type] = 1
		vRP.execute("entitydata/setData",{ dkey = "custom:"..plateUser..":"..vehName, value = json.encode(vehMods) })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHEDIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("bennys",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			TriggerClientEvent("lscustoms:openAdmin",source)
		end
	end
end)