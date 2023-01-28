local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local clockHours = 18
local clockMinutes = 0
local timeDate = GetGameTimer()
local weatherSync = "EXTRASUNNY"
local termsList = {}
local cupomStatus = false
local currentText = ''
GlobalState["Nitro"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEATHER TYPES
-----------------------------------------------------------------------------------------------------------------------------------------
local weatherTypes = { 
	["BLIZZARD"] = true,
	["CLEAR"] = true,
	["CLEARING  "] = true,
	["CLOUDS"] = true,
	["EXTRASUNNY"] = true,
	["FOGGY"] = true,
	["HALLOWEEN"] = true,
	["OVERCAST"] = true,
	["RAIN"] = true,
	["SMOG"] = true,
	["SNOWLIGHT"] = true,
	["THUNDER"] = true,
	["XMAS"] = true,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if GetGameTimer() >= (timeDate + 1000) then
			timeDate = GetGameTimer()
			clockMinutes = clockMinutes + 1

			if clockMinutes >= 60 then
				clockHours = clockHours + 1
				clockMinutes = 0

				if clockHours >= 24 then
					clockHours = 0
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("time",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"ceo") and parseInt(args[1]) >= 0 and parseInt(args[2]) >= 0 then
			clockMinutes = parseInt(args[2])
			clockHours = parseInt(args[1])

			if clockMinutes >= 60 then
				clockMinutes = 0
			end

			if clockHours >= 24 then
				clockHours = 0
			end
			TriggerClientEvent("hud:syncTimers",-1,{clockMinutes,clockHours,weatherSync})
		end
	end
end)

RegisterCommand("clima",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"ceo") and args[1] ~= "" and weatherTypes[string.upper(args[1])] then
			weatherSync = string.upper(args[1])
			TriggerClientEvent("hud:syncTimers",-1,{clockMinutes,clockHours,weatherSync})
		end
	end
end)

RegisterCommand("cupom",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"ceo") then
			if args[1] then
				TriggerClientEvent("hud:cupom",-1,args[1],true)
				currentText = args[1]
				cupomStatus = true
			else
				TriggerClientEvent("hud:cupom",-1,false)
				currentText = ''
				cupomStatus = false
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("hud:syncTimers",source,{ clockMinutes,clockHours,weatherSync })
	TriggerClientEvent("hud:cupom",-1,currentText,cupomStatus)
	if not termsList[user_id] then
		TriggerClientEvent("hud:terms",source,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("hud:termsAccept", function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		termsList[user_id] = true
	end
end)

RegisterServerEvent("hud:updateNitro", function(vehPlate,nitroFuel)
	if GlobalState["Nitro"][vehPlate] then
		local Nitro = GlobalState["Nitro"]
		Nitro[vehPlate] = nitroFuel
		GlobalState["Nitro"] = Nitro
	end
end)