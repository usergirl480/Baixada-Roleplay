-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("bank",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKS
-----------------------------------------------------------------------------------------------------------------------------------------
local locks = {}

function Lock(key, ms)
	while locks[key] and locks[key] > GetGameTimer() do Wait(100) end
	locks[key] = GetGameTimer() + ms
	return function()
		locks[key] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTWANTED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestWanted()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not exports["wanted"]:checkWanted(user_id) then
			return true
		end
	
		local random = math.random(10)
		if random >= 6 then
			exports["wanted"]:dispatchPolice(user_id)
			TriggerClientEvent("Notify",source,"importante","A polícia te encontrou pela câmera de segurança, fuja!")
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANKDEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.bankDeposit(amount)
	local source = source
	local free = Lock(source,5000)
	local user_id = vRP.getUserId(source)
	if user_id then
		local value = parseInt(amount)

		if parseInt(value) > 0 then
			if vRP.tryGetInventoryItem(user_id,"dollars",value,true) then
				vRP.addBank(user_id,value)
			else
				TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
			end
		end
	end
	free()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANWITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.bankWithdraw(amount)
	local source = source
	local free = Lock(source,5000)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"negado","Multas pendentes encontradas.",10000,"bottom")
			return false
		end

		local value = parseInt(amount)
		if (vRP.inventoryWeight(user_id) + (itemWeight("dollars") * value)) <= vRP.getBackpack(user_id) then
			if not vRP.withdrawCash(user_id,value) then
				TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"negado","Mochila cheia.",5000)
		end
	end
	free()
end