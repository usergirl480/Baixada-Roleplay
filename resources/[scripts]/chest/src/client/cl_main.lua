local chestOpened = ""
local chestsList = {}

RegisterNetEvent("chests:client:setChests",function(chests)
    chestsList = chests

	if chestsList["Bullguer"] then
		chestsList["Bullguer2"] = { weight = chestsList["Bullguer"].weight, perm = chestsList["Bullguer"].perm, coords = { -579.7,-880.79,26.0,266.46 }, logs = chestsList["Bullguer"].logs }
	end

    for k,v in pairs(chestsList) do
        if not k:find("Bullguer") then
            exports["target"]:AddCircleZone("chest:"..k,vector3(v.coords[1],v.coords[2],v.coords[3]),1.0,{
				name = "chest:"..k,
				heading = v.coords[4]
			},{
				shop = k,
				distance = 1.0,
				options = {
					{
						event = "chest:openSystem",
						label = "Abrir",
						tunnel = "shop"
					},
					{
						event = "chest:storageSystem",
						label = "Estoque",
						tunnel = "shop"
					},
					{
						event = "chest:upgradeSystem",
						label = "Aumentar",
						tunnel = "shop"
					}
				}
			})
        else
            exports["target"]:AddCircleZone("chest:"..k,vector3(v.coords[1],v.coords[2],v.coords[3]),1.0,{
				name = "chest:"..k,
				heading = v.coords[4]
			},{
				shop = k,
				distance = 1.0,
				options = {
					{
						event = "chest:openSystem",
						label = "Abrir",
						tunnel = "shop"
					}
				}
			})
        end
		Citizen.Wait(10)
    end
end)

Citizen.CreateThread(function()
    SetNuiFocus(false,false)
    
end)

AddEventHandler("chest:openSystem",function(chestName)
    if not server.hasPermission(chestName) then return end

    SetNuiFocus(true,true)
    SendNUIMessage({ action = "showMenu", storage = false })
    TriggerEvent("sounds:source","chest",0.7)
    chestOpened = chestName
end)

AddEventHandler("chest:storageSystem",function(chestName)
	if not server.hasPermission(chestName) then return end

    SetNuiFocus(true,true)
    chestOpened = chestName
    SendNUIMessage({ action = "showMenu", storage = true })
    TriggerEvent("sounds:source","chest",0.7)
end)

AddEventHandler("chest:upgradeSystem",function(chestName)
    server.upgradeChest(chestName)
end)

RegisterNUICallback("invClose",function(data)
    SendNUIMessage({ action = "hideMenu" })
    SetNuiFocus(false,false)
    server.closeSystem()
    chestOpened = ""
end)

RegisterNUICallback("requestChest",function(data,cb)
    local myInventory,myChest,invPeso,invMaxpeso,chestPeso,chestMaxpeso = server.openChest(chestOpened,data.storageSystem)
	if myInventory then
		cb({ myInventory = myInventory, myChest = myChest, invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
	end
end)

RegisterNetEvent("chest:Update",function(action)
	SendNUIMessage({ action = action })
end)

RegisterNetEvent("chest:UpdateWeight",function(invPeso,invMaxpeso,chestPeso,chestMaxpeso)
	SendNUIMessage({ action = "updateWeight", invPeso = invPeso, invMaxpeso = invMaxpeso, chestPeso = chestPeso, chestMaxpeso = chestMaxpeso })
end)

RegisterNUICallback("takeItem",function(data)
	server.takeItem(data["item"],data["slot"],data["amount"],data["target"],chestOpened)
end)

RegisterNUICallback("storeItem",function(data)
	server.storeItem(data["item"],data["slot"],data["amount"],data["target"],chestOpened)
end)

RegisterNUICallback("updateChest",function(data,cb)
	server.updateChest(data["slot"],data["target"],data["amount"],chestOpened)
end)