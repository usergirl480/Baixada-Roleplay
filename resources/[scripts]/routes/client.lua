local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

Api = Tunnel.getInterface(GetCurrentResourceName())

local in_route = false
local currentRoute = nil
local currentBlip = nil
local currentPosition = 1

local routes = config_routes.coords

local ui_active = false

function displayUI()
	ui_active = not ui_active
    if ui_active then
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "open", title = "Rotas para "..routes[currentRoute].title, items = Api.getItems(currentRoute) })
    else
		SetNuiFocus(false)
		SendNUIMessage({ action = "exit" })
	end
end

RegisterNUICallback("selectRoute", function(data,cb)
    if data.code then
	    TriggerServerEvent("routes:selectRoute", currentRoute, data.code)
    end
end)

RegisterNUICallback("exit", function(data,cb)
    displayUI()
end)

RegisterNetEvent("routes:exit")
AddEventHandler("routes:exit", function()
	displayUI()
end)

function setRoute(route)
	currentRoute = route
	if not in_route then
		threadMain_route()
		threadButtonRoute()
	end
end

function threadMain_route() 
	Citizen.CreateThread(function()
		while currentRoute do
			local timeDistance = 999
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local distance = #(GetEntityCoords(ped) - vec3(routes[currentRoute].checkpoints[currentPosition][1],routes[currentRoute].checkpoints[currentPosition][2],routes[currentRoute].checkpoints[currentPosition][3]))
			if distance <= 20.0 then timeDistance = 4 end
			if distance <= 1.5 then
				DrawText3D(routes[currentRoute].checkpoints[currentPosition][1],routes[currentRoute].checkpoints[currentPosition][2],routes[currentRoute].checkpoints[currentPosition][3], "~g~E~w~   COLETAR")
				if not IsPedInAnyVehicle(ped) then
					if IsControlJustPressed(0,38) then
						if Api.checkPayment() then
							RemoveBlip(currentBlip)
							
							if currentPosition == #routes[currentRoute].checkpoints then
								currentPosition = 1
							else
								currentPosition = currentPosition + 1
							end
							createBlip(routes[currentRoute].title, routes[currentRoute].checkpoints[currentPosition])
						end
					end
				end
			end
			Citizen.Wait(timeDistance)
		end
	end)
end

function threadButtonRoute() 
	Citizen.CreateThread(function()
		while currentRoute do
			if currentRoute then
				if IsControlJustPressed(0, 168) then
					currentRoute = nil
					currentPosition = 1
					RemoveBlip(currentBlip)
					in_route = false
					TriggerServerEvent("routes:endRoute")
					TriggerEvent("Notify","sucesso","Rota encerrada")
				end
			end
			Citizen.Wait(5)
		end
	end)
end

RegisterNetEvent("routes:startRoute")
AddEventHandler("routes:startRoute", function(route, item)
	in_route = true
    if currentBlip then
		RemoveBlip(currentBlip)
	end

	setRoute(route)
	currentPosition = 1
	createBlip(routes[currentRoute].blip, routes[currentRoute].checkpoints[currentPosition])
	TriggerEvent("Notify","sucesso","Iniciando rota de <b>"..item.."</b>")
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if not in_route then
			for routeCode, route in pairs(routes) do
				for k, v in pairs(route.startPoints) do
					local ped = PlayerPedId()
					local x,y,z = table.unpack(GetEntityCoords(ped))
					local distance = #(GetEntityCoords(ped) - v)
					if distance <= 15.0 then timeDistance = 4 end
					if distance <= 1.5 then
						if IsControlJustPressed(0,38) then
							if Api.checkPermissao(routeCode) then
								currentRoute = routeCode
								displayUI()
							end
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
    for route,k in pairs(routes) do
		for x, v in pairs(k.startPoints) do
			table.insert(innerTable,{ v.x,v.y,v.z,2,"E","Rotas","Pressione para abrir" })
		end
    end
    TriggerEvent("hoverfy:insertTable",innerTable)
end)


function DrawText3D(x,y,z,text)
	SetTextFont(4)
	SetTextCentre(1)
	SetTextEntry("STRING")
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z,0)
	DrawText(0.0,0.0)
	local factor = (string.len(text) / 450) + 0.01
	DrawRect(0.0,0.0125,factor,0.03,47 ,57, 70,200)
	ClearDrawOrigin()
end

function createBlip(name, pos)
	currentBlip = AddBlipForCoord(pos[1], pos[2], pos[3])
	SetBlipSprite(currentBlip,1)
	SetBlipColour(currentBlip,2)
	SetBlipScale(currentBlip,0.4)
	SetBlipAsShortRange(currentBlip,false)
	SetBlipRoute(currentBlip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rotas de "..name)
	EndTextCommandSetBlipName(currentBlip)
end