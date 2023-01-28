local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
src = {}
Tunnel.bindInterface("radio",src)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

src.checkItens = function()
	local source = source 
	local user_id = vRP.getUserId(source)
	if user_id then 
		local consultItem = vRP.getInventoryItemAmount(user_id,"radio")
		if consultItem[1] >= 1 then 
			return true 
		end
		return false 
	end
end

local inRadio = {}

src.startFrequency = function(frequency)
	local source = source 
	local user_id = vRP.getUserId(source)
	if user_id then 
		frequency = parseInt(frequency)
		local radio = exports["oxmysql"]:single_async("SELECT squad FROM squads WHERE radio_frequency = @radio",{ radio = frequency })
		if radio then 
			if exports["common"]:Group().hasPermission(user_id,radio.squad) then
				inRadio[user_id] = { frequency,source }
				return true 
			else
				TriggerClientEvent("Notify",source,"default","Você não pode entrar nesta frequência.",10000,"normal","atenção")
				return false
			end
		end

		inRadio[user_id] = { frequency,source }
		return true 
	end
end

src.checkRadio = function()
	local source = source
	local user_id = vRP.getUserId(source)
	local consultItem = vRP.getInventoryItemAmount(user_id,"radio")
	return (consultItem[1] >= 1)
end

Citizen.CreateThread(function()
	while true do
		local timeDistance = 10000
		if #inRadio > 0 then 
			timeDistance = 5000
			for k,v in pairs(inRadio) do 
				if inRadio[k] then
					local plyTable = inRadio[k]
					local consultItem = vRP.getInventoryItemAmount(k,"radio")
					if consultItem[1] < 1 then  
						TriggerClientEvent("radio:outServers",plyTable[2])
						TriggerClientEvent("Notify",plyTable[2],"sucesso","Você foi removido(a) da frequência.")
						inRadio[k] = nil
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)

src.removeRadio = function()
	local source = source
	local user_id = user_id 
	if user_id and inRadio[user_id] then 
		inRadio[user_id] = nil
	end
end

AddEventHandler("vRP:playerLeave",function(user_id,source)
	if inRadio[user_id] then
		inRadio[user_id] = nil
	end
end)