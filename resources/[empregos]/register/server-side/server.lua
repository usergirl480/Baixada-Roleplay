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
Tunnel.bindInterface("register",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local boxTimers = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.applyTimers(boxId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		
		if vRP.userIsBaby(user_id) then
			TriggerClientEvent("Notify",source,"negado","Ação bloqueada.",5000,"bottom")
			return
		end

		local policeAtive = exports["common"]:Group().getAllByPermission("police")
		if parseInt(#policeAtive) <= 4 then
			TriggerClientEvent("Notify",source,"negado","Número insuficiente de policiais.",10000,"bottom")
			return false
		end

		-- local reputationResult = vRP.checkReputation(user_id,"thief")
		-- if reputationResult >= 150 then
			if boxTimers[boxId] then
				if GetGameTimer() < boxTimers[boxId] then
					TriggerClientEvent("Notify",source,"negado","Esta registradora já foi roubada.",10000,"bottom")
					return false
				else
					startBox(boxId,source)
					return true
				end
			else
				startBox(boxId,source)
				return true
			end
		-- else
			-- TriggerClientEvent("Notify",source,"negado","Você precisa de <b>150</b> de Reputação como <b>Ladrão</b>.",10000,"bottom")
		-- end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTBOX
-----------------------------------------------------------------------------------------------------------------------------------------
function startBox(boxId,source)
    local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
        boxTimers[boxId] = GetGameTimer() + (20 * 60000)

        if math.random(100) >= 75 then
            local ped = GetPlayerPed(source)
            local coords = GetEntityCoords(ped)
            
            local policeResult = exports["common"]:Group().getAllByPermission("police")
            for k,v in pairs(policeResult) do
                async(function()
                    vRPC.playSound(v,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
                    TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Caixa Registradora", x = coords["x"], y = coords["y"], z = coords["z"], criminal = "Alarme de segurança", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
                end)
            end
            
            -- local reputationRemove = math.random(1,6)
            TriggerClientEvent("player:applyGsr",source)
            -- TriggerClientEvent("Notify",source,"default","Você perdeu <b>-"..reputationRemove.."</b> de Reputação como Ladrão.",10000,"bottom","atenção")
            -- vRP.removeReputation(user_id,"thief",reputationRemove)
			vRP.upgradeStress(user_id,2)
            return
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		exports["wanted"]:setWanted(user_id,120)
		vRP.generateItem(user_id,"dollarsz",math.random(75,125),true)
	end
end