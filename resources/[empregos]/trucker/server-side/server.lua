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
Tunnel.bindInterface("trucker",cRP)
vGARAGE = Tunnel.getInterface("trucker")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local deliveryPackage = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkExist()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if deliveryPackage[user_id] then
			if not exports["store"]:Appointments().isVipById(user_id) then
				if deliveryPackage[user_id] >= 2 then
					TriggerClientEvent("Notify",source,"importante","Atingiu o limite diário.",5000)
					return true
				end
			else
				TriggerClientEvent("Notify",source,"importante","Atingiu o limite diário.",5000)
				return true
			end
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
-- local randItems = { "plasticbottle", "glassbottle", "elastic", "metalcan", "battery", "fabric" }
function cRP.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		-- if deliveryPackage[user_id] == nil then
		-- 	deliveryPackage[user_id] = 0
		-- end

		local value = math.random(4500,5000)

		vRP.generateItem(user_id,"dollars",value,true)
		exports.common:Economy().jobAdd(user_id,"trucker",value)

		-- for k,v in pairs(randItems) do 
		-- 	vRP.generateItem(user_id,v,value,true)
		-- 	exports.common:Economy().itemAdd(user_id,v,value)
		-- end

		-- deliveryPackage[user_id] = deliveryPackage[user_id] + 1
	end
end