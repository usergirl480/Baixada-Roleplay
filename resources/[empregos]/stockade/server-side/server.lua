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
Tunnel.bindInterface("stockade",cRP)
vCLIENT = Tunnel.getInterface("stockade")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local stockadeNet = 0
local stockadeTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkStockade()
	local source = source
	local userId = vRP.getUserId(source)
	local identity = vRP.userIdentity(userId)
	if userId then
		local steam = vRP.getSteamBySource(source)
        if steam then 
			local policeResult = exports["common"]:Group().getAllByPermission("police")
			if parseInt(#policeResult) <= 6 or GetGameTimer() < stockadeTimer then
				TriggerClientEvent("Notify",source,"negado","Número insuficiente de policiais.",10000,"bottom")
				return false
			end
			
			local timePlayed = exports["common"]:PlayedTime().getTime(userId,steam)
            if timePlayed < 86400 then
				TriggerClientEvent("Notify",source,"negado","Você precisa de <b>"..exports["common"]:PlayedTime().format(86400).."</b> de tempo de jogo.",10000,"bottom")
				TriggerClientEvent("Notify",source,"sucesso","Tempo de jogo: <b>"..exports["common"]:PlayedTime().format(timePlayed).."</b>.",10000)
				return false
			end

			-- local consultReputation = vRP.checkReputation(userId,"hacking")
			-- if consultReputation < 250 then
			-- 	TriggerClientEvent("Notify",source,"negado","Você precisa de <b>250</b> de reputação como <b>Hacker</b> para roubar.",10000,"bottom")
			-- 	return false
			-- end

			local consultItem = vRP.getInventoryItemAmount(userId,"notebook")
			if consultItem[1] <= 0 then
				TriggerClientEvent("Notify",source,"negado","Você precisa de <b>1x Notebook</b> para roubar.",5000,"bottom")
				return false
			end

			if vRP.checkBroken(consultItem[2]) then
				TriggerClientEvent("Notify",source,"negado","Item quebrado.",5000)
				return false
			end

			if vRP.tryGetInventoryItem(userId,consultItem[2],1,true,false) then
				stockadeTimer = GetGameTimer() + (120 * 60000)
				TriggerClientEvent("player:applyGsr",source)
				return true
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOCKADEINSERT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.stockadeInsert(vehNet)
	stockadeNet = parseInt(vehNet)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("stockade:explodeVehicle")
AddEventHandler("stockade:explodeVehicle",function()
	stockadeNet = 0
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOCKADENET
-----------------------------------------------------------------------------------------------------------------------------------------
function stockadeNet()
	return stockadeNet
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("stockadeNet",stockadeNet)