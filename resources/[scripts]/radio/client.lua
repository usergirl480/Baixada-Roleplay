-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
src = Tunnel.getInterface("radio")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local radioShow = false
local radioVolume = 20
local activeRadio = false
local actionDelay = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLENUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:openSystem")
AddEventHandler("radio:openSystem",function()
	SetNuiFocus(true,true)
	SendNUIMessage({ show = true })

	if not IsPedInAnyVehicle(PlayerPedId()) then
		vRP.createObjects("cellphone@","cellphone_text_in","prop_cs_hand_radio",50,28422)
	end
end)

function src.checkFrequency()
    for i=1,999 do
        if exports["pma-voice"]:isPlayerInChannel(i) then
            return i
        end
    end
    return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHANGEVOLUME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("changevolume",function(data,cb)
	if parseInt(data["volume"]) ~= radioVolume then 
		radioVolume = parseInt(data["volume"])
		exports["pma-voice"]:setVolume(radioVolume / 100,"radio")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("activeFrequency",function(data,cb)
	if actionDelay >= GetGameTimer() then 
		TriggerEvent("Notify","negado","Aguarde alguns instantes.",5000,"bottom")
		return
	end

	local frequency = parseInt(data["freq"])
	if src.startFrequency(frequency) then
		exports["pma-voice"]:setRadioChannel(frequency)
		exports["pma-voice"]:setVoiceProperty("radioEnabled",true)
		TriggerEvent("hud:RadioDisplay",parseInt(frequency))
		TriggerEvent("Notify","sucesso","Conectado <b>"..frequency..".00</b> MHz.",5000,"bottom")
	else
		actionDelay = GetGameTimer() + 2000
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INATIVEFREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("inativeFrequency",function(data,cb)
	local frequency = parseInt(data["freq"])
	exports["pma-voice"]:removePlayerFromRadio()
	TriggerEvent("hud:RadioDisplay","")
	TriggerEvent("Notify","sucesso","Desconectado",5000,"bottom")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTSERVERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:outServers")
AddEventHandler("radio:outServers",function()
	exports["pma-voice"]:removePlayerFromRadio()
	exports["pma-voice"]:setVoiceProperty("radioEnabled",false)
	TriggerEvent("hud:RadioDisplay","")
	src.removeRadio()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSERADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeRadio",function(data,cb)
	SetNuiFocus(false)
	radioShow = false
	SendNUIMessage({ show = false })
	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LISTRADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio_modules:listRadio",function(isActive,isIdentity)
	SendNUIMessage({ listRadio = isActive, identity = isIdentity })
end)