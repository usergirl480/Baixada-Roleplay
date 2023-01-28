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
Tunnel.bindInterface("crafting",cRP)
vSERVER = Tunnel.getInterface("crafting")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideNUI" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestCrafting",function(data,cb)
	local inventoryCraft,inventoryUser,invPeso,invMaxpeso = vSERVER.requestCrafting(data["craft"])
	if inventoryCraft then
		cb({ inventoryCraft = inventoryCraft, inventario = inventoryUser, invPeso = invPeso, invMaxpeso = invMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONCRAFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionCraft",function(data,cb)
	vSERVER.functionCrafting(data["index"],data["craft"],data["amount"],data["slot"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONDESTROY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionDestroy",function(data,cb)
	vSERVER.functionDestroy(data["index"],data["craft"],data["amount"],data["slot"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(data,cb)
	TriggerServerEvent("crafting:populateSlot",data["item"],data["slot"],data["target"],data["amount"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(data,cb)
	TriggerServerEvent("crafting:updateSlot",data["item"],data["slot"],data["target"],data["amount"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTING:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:Update")
AddEventHandler("crafting:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local craftList = {}
RegisterNetEvent("crafting:client:setCrafting",function(crafting)
	craftList = {}
    craftList = crafting
	createHoverfy()
end)

createHoverfy = function() 
	local innerTable = {}
	while Tablelength(craftList) < 0 do
		Wait(1000)
	end
	for k,v in pairs(craftList) do
		table.insert(innerTable,{ v[1][1],v[1][2],v[1][3],2,"E","Produção","Pressione para abrir" })
	end
	TriggerEvent("hoverfy:insertTable",innerTable)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and Tablelength(craftList) >= 0 then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(craftList) do
				local distance = #(coords - vector3(v[1][1],v[1][2],v[1][3]))
				if distance <= 1.5 then
					timeDistance = 4
					if IsControlJustPressed(1,38) and vSERVER.requestPerm(v[2]) then
						SetNuiFocus(true,true)
						SendNUIMessage({ action = "showNUI", name = v[2] })
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTING:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("crafting:openSystem",function(shopId)
	if vSERVER.requestPerm(craftList[shopId][5]) then
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showNUI", name = craftList[shopId][5] })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTING:FUELSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("crafting:fuelShop",function()
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "showNUI", name = "fuelShop" })
end)

function Tablelength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end