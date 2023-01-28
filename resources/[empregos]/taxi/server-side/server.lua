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
Tunnel.bindInterface("taxi",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentService()
	local source = source
	local userId = vRP.getUserId(source)
	if userId then
		local value = math.random(400,600)
		
		vRP.generateItem(userId,"dollars",value,true)
		exports.common:Economy().jobAdd(userId,"taxi",value)
		
		-- local reputationValue = math.random(1,6)
		-- TriggerClientEvent("Notify",source,"default","Você recebeu <b>+"..reputationValue.."</b> de Reputação como Taxista.",10000,"bottom","atenção")
		-- vRP.insertReputation(userId,"taxi",reputationValue)

	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.initService(status)
	return true
end