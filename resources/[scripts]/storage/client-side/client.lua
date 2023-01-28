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
Tunnel.bindInterface("storage",cRP)
vSERVER = Tunnel.getInterface("storage")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideNUI" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestStorage",function(data,cb)
	local inventoryShop,inventoryUser,invPeso,invMaxpeso,shopSlots = vSERVER.requestStorage(data["shop"])
	if inventoryShop then
		cb({ inventoryShop = inventoryShop, inventoryUser = inventoryUser, invPeso = invPeso, invMaxpeso = invMaxpeso, shopSlots = shopSlots })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("functionShops",function(data,cb)
	vSERVER.functionShops(data.shop,data.item,data.amount,data.slot)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(data,cb)
	TriggerServerEvent("storage:populateSlot",data.item,data.slot,data.target,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(data,cb)
	TriggerServerEvent("storage:updateSlot",data.item,data.slot,data.target,data.amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateStorage(action)
	SendNUIMessage({ action = action })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local storageList = {
	{ 646.07,267.24,103.26,"Madrazo",true,false },
	{ -2073.23,-327.34,13.31,"Medellin",true,false },
	-- { -141.86,-1697.48,30.77,"Families",true,false },
	-- { 54.16,-1873.34,22.8,"Ballas",true,false },
	-- { 1234.41,-354.88,69.08,"Favela01",true,false },
	-- { 2559.35,373.79,108.61,"Favela03",true,false },
	-- { 2562.1,2590.87,38.08,"Favela04",true,false },
	-- { 791.49,2176.58,52.64,"Favela05",true,false },
	-- { 346.48,3406.12,36.48,"Favela06",true,false },
	{ 20.42,-1505.48,31.85,"Siciliana",true,false },
	{ 240.66,-1379.4,33.73,"Bratva",true,false },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(storageList) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 1.5 then
					timeDistance = 4
					if IsControlJustPressed(1,38) and vSERVER.requestPerm(v[4]) then
						SetNuiFocus(true,true)
						SendNUIMessage({ action = "showNUI", name = tostring(v[4]), type = vSERVER.getStorageType(v[4]) })
						if v[5] then
							TriggerEvent("sounds:source","shop",0.5)
						end
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
    local innerTable = {}
    for k,v in pairs(storageList) do
        table.insert(innerTable,{ v[1],v[2],v[3],2,"E","Estoque","Pressione para abrir" })
    end

    TriggerEvent("hoverfy:insertTable",innerTable)
end)
