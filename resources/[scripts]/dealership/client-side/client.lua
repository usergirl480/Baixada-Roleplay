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
Tunnel.bindInterface("dealership",cRP)
vSERVER = Tunnel.getInterface("dealership")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local typeCars = {}
local typeBikes = {}
local typeWorks = {}
local typeRental = {}

local location = {
	{ -57.25,-1097.22,26.42 },
}

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)

Citizen.CreateThread(function()
    local innerTable = {}
    for k,v in pairs(location) do
        table.insert(innerTable,{ v[1],v[2],v[3],2,"E","Concessionária","Pressione para abrir" })
    end

    TriggerEvent("hoverfy:insertTable",innerTable)
end)

RegisterKeyMapping("dealership:Open","Dealership","keyboard","E")
RegisterCommand("dealership:Open",function(source,args,rawCommand)
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) then
		local coords = GetEntityCoords(ped)
		for k,v in pairs(location) do
			local distance = #(coords - vector3(v[1],v[2],v[3]))
			if distance <= 1.5 then
				if vSERVER.checkShares() then
					SetNuiFocus(true,true)
					SendNUIMessage({ action = "openSystem" })
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(data)
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "closeSystem" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateVehicles(Cars,Bikes,Works,Rental)
	typeCars = Cars
	typeBikes = Bikes
	typeWorks = Works
	typeRental = Rental
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCARROS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestCarros",function(data,cb)
	cb({ result = typeCars })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMOTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMotos",function(data,cb)
	cb({ result = typeBikes })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSERVICOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestServicos",function(data,cb)
	cb({ result = typeWorks })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTALUGUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestAluguel",function(data,cb)
	cb({ result = typeRental })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPOSSUIDOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestPossuidos",function(data,cb)
	cb({ result = vSERVER.requestPossuidos() })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestBuy",function(data,cb)
	vSERVER.requestBuy(data["name"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTRENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestRental",function(data,cb)
	vSERVER.requestRental(data["name"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTALMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rentalMoney",function(data,cb)
	vSERVER.rentalMoney(data["name"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTAX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestTax",function(data,cb)
	vSERVER.requestTax(data["name"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestSell",function(data,cb)
	vSERVER.requestSell(data["name"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEALERSHIP:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dealership:Update")
AddEventHandler("dealership:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVEABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehDrive = nil
local benDrive = false
local benCoords = { -56.95,-1097.26,26.42 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestDrive",function(data,cb)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local distance = #(coords - vector3(benCoords[1],benCoords[2],benCoords[3]))

	if distance <= 3 then
		vRP.removeObjects()
		SetNuiFocus(false,false)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "closeSystem" })

		local driveIn,vehPlate = vSERVER.startDrive()
		if driveIn then
			TriggerEvent("races:insertList",true)
			TriggerEvent("player:blockCommands",true)
				TriggerEvent("Notify","default","Teste iniciado, para finalizar saia do veículo.",20000,"normal","atenção")

			Citizen.Wait(1000)

			vehCreate(data["name"],vehPlate)

			Citizen.Wait(1000)

			SetPedIntoVehicle(ped,vehDrive,-1)
			benDrive = true
		end
	else
		TriggerEvent("Notify","default","Dirija-se até a <b>Motorsport</b> para efetuar o teste.",20000,"normal","atenção")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCREATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vehCreate(vehName,vehPlate)
	local mHash = GetHashKey(vehName)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Citizen.Wait(1)
	end

	if HasModelLoaded(mHash) then
		vehDrive = CreateVehicle(mHash,-15.59,-1099.96,26.03,158.75,false,false)

		SetEntityInvincible(vehDrive,true)
		SetVehicleOnGroundProperly(vehDrive)
		SetVehicleNumberPlateText(vehDrive,vehPlate)
		SetEntityAsMissionEntity(vehDrive,true,true)
		SetVehicleHasBeenOwnedByPlayer(vehDrive,true)
		SetVehicleNeedsToBeHotwired(vehDrive,false)

		SetModelAsNoLongerNeeded(mHash)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if benDrive then
			timeDistance = 1
			DisableControlAction(1,69,false)

			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				Citizen.Wait(1000)

				benDrive = false
				vSERVER.removeDrive()
				DeleteEntity(vehDrive)
				TriggerEvent("races:insertList",false)
				TriggerEvent("player:blockCommands",false)
				SetEntityCoords(ped,benCoords[1],benCoords[2],benCoords[3],1,0,0,0)
			end
		end

		Citizen.Wait(timeDistance)
	end
end)