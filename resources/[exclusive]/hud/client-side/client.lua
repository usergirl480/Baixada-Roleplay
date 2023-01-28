-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
BXD = {}
Tunnel.bindInterface("hud",BXD)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local voice = 2
local hardness = {}
local clientstress = 2
local clientHunger = 100
local clientThirst = 100
local showHud = false
local talking = false
local showMovie = false
local radioDisplay = ""
local homeInterior = false
local hour = nil
local minute = nil
local updateFoods = GetGameTimer()
local playerActive = true
local pauseBreak = false
local lastWeapon = nil
local triggerWeapon = false
local assaultEnable = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIVINABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local divingMask = nil
local divingTank = nil
local clientOxigen = 100
local divingTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- Lights Car
-----------------------------------------------------------------------------------------------------------------------------------------
local lightState = "off"
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
local beltLock = 0
local beltSpeed = 0
local beltVelocity = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOCKVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local clockHours = 20
local clockMinutes = 0
local timeDate = GetGameTimer()
local weatherSync = "EXTRASUNNY"
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp:playerActive")
AddEventHandler("vrp:playerActive",function(userId)
	playerActive = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if playerActive then
			if divingMask ~= nil then
				if GetGameTimer() >= divingTimers then
					divingTimers = GetGameTimer() + 35000
					clientOxigen = clientOxigen - 1
					vRPS.clientOxigen()

					if clientOxigen <= 0 then
						ApplyDamageToPed(PlayerPedId(),50,false)
					end
				end
			end
		end

		Citizen.Wait(5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOODS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if playerActive and not LocalPlayer.state.inArena and not LocalPlayer.state.inNoclip then
			local ped = PlayerPedId()
			if GetGameTimer() >= updateFoods and GetEntityHealth(ped) > 101 then
				updateFoods = GetGameTimer() + 90000
				clientThirst = clientThirst - 1
				clientHunger = clientHunger - 1
				vRPS.clientFoods()
			end
		end

		Citizen.Wait(30000)
	end
end)
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
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if homeInterior then
			SetWeatherTypeNow("CLEAR")
			SetWeatherTypePersist("CLEAR")
			SetWeatherTypeNowPersist("CLEAR")
			NetworkOverrideClockTime(05,00,00)
		else
			SetWeatherTypeNow(weatherSync)
			SetWeatherTypePersist(weatherSync)
			SetWeatherTypeNowPersist(weatherSync)
			NetworkOverrideClockTime(clockHours,clockMinutes,00)
		end

		if beltLock >= 1 then
			DisableControlAction(1,75,true)
		end

		Citizen.Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOICETALKING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:VoiceTalking",function(status)
	talking = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:showWeapon",function(weapon)
	lastWeapon = weapon
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHUD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if playerActive then
			if IsPauseMenuActive() then
				SendNUIMessage({ hud = false })
				pauseBreak = true
			else
				if showHud then
					if pauseBreak then
						SendNUIMessage({ hud = true })
						pauseBreak = false
						updateDisplayHud()
					else
						updateDisplayHud()

						local ped = PlayerPedId()
						if IsPedInAnyVehicle(ped) then
							timeDistance = 100
						end
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEDISPLAYHUD
-----------------------------------------------------------------------------------------------------------------------------------------
local streetLast = 0
local flexDirection = "Norte"
local showWeapon = false
function updateDisplayHud()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local heading = GetEntityHeading(ped)
	local armour = GetPedArmour(ped)
	local health = GetEntityHealth(ped)
	local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords["x"],coords["y"],coords["z"]))
	if lastWeapon then 
		local ammo = GetAmmoInPedWeapon(ped, lastWeapon)
		local bool, inclip = GetAmmoInClip(ped, lastWeapon)
		triggerWeapon = false
		showWeapon = true
		tb_guns = { 
			weaponsInfo = {
				index = itemIndex(lastWeapon),
				maxammo = inclip,
				inclip = ammo-inclip
			} 
		}
	else
		if not triggerWeapon then 
			triggerWeapon = true
			showWeapon = false
		end
	end

	talking = NetworkIsPlayerTalking(PlayerId())
	
	if heading >= 315 or heading < 45 then
		flexDirection = "Norte"
	elseif heading >= 45 and heading < 135 then
		flexDirection = "Oeste"
	elseif heading >= 135 and heading < 225 then
		flexDirection = "Sul"
	elseif heading >= 225 and heading < 315 then
		flexDirection = "Leste"
	end

	hours = clockHours
	minutes = clockMinutes
	if hours <= 9 then
		hours = "0"..hours
	end

	if minutes <= 9 then
		minutes = "0"..minutes
	end

	-- if GetClockHours() >= 22 or GetClockHours() <= 5 then
	-- 	assaultEnable = true
	-- else
	-- 	assaultEnable = false
	-- end

	local horario = hours..":"..minutes
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)
		local fuel = GetVehicleFuelLevel(vehicle)
		local vehicleGear = GetVehicleCurrentGear(vehicle)
		local plate = GetVehicleNumberPlateText(vehicle)
		local vehicleHealth = GetVehicleBodyHealth(vehicle)
		local speed = GetEntitySpeed(vehicle) * 2.236936
		local showBelt = true

		if speed > 0 and vehicleGear == 0 then
			vehicleGear = 7
		end
		
		if GetVehicleClass(vehicle) == 8 and (GetVehicleClass(vehicle) >= 13 and GetVehicleClass(vehicle) <= 16) and GetVehicleClass(vehicle) == 21 then
			showBelt = false
		end
		SendNUIMessage({ vehicle = true, assault = assaultEnable, usingGun = false, infoGun = tb_guns, talking = talking, health = health, armour = armour, thirst = clientThirst, hunger = clientHunger, stress = clientStress, oxigen = clientOxigen, suit = divingMask, street = streetName, direction = flexDirection, radio = radioDisplay, voice = voice, fuel = fuel, speed = speed, time = horario, showbelt = showBelt, seatbelt = beltLock, hardness = (hardness[plate] or 0), vehicleEngine = parseInt(vehicleHealth), lightState = lightState, gear = vehicleGear })
	else
		SendNUIMessage({ vehicle = false, assault = assaultEnable, usingGun = showWeapon, infoGun = tb_guns, talking = talking, health = health, armour = armour, thirst = clientThirst, hunger = clientHunger, stress = clientStress, oxigen = clientOxigen, suit = divingMask, street = streetName, direction = flexDirection, radio = radioDisplay, voice = voice, time = horario })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hud",function(source,args)
	showHud = not showHud

	updateDisplayHud()
	SendNUIMessage({ hud = showHud })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:terms",function(status)
	terms = status
	if terms then
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ terms = true })
	else
		SetNuiFocus(false,false)
		SendNUIMessage({ terms = false })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:cupom",function(args,status)
	cupom = status
	if cupom then
		SendNUIMessage({ cupom = true, text = args })
	else
		SendNUIMessage({ cupom = false })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOVIE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("movie",function(source,args)
	showMovie = not showMovie

	updateDisplayHud()
	SendNUIMessage({ movie = showMovie })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	DisplayRadar(false)

	RequestStreamedTextureDict("circlemap",false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Citizen.Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics","radarmasksm","circlemap","radarmasksm")

	SetMinimapClipType(1)

	SetMinimapComponentPosition("minimap","L","B",0.0,0.0,0.158,0.28)
	SetMinimapComponentPosition("minimap_mask","L","B",0.155,0.12,0.080,0.164)
	SetMinimapComponentPosition("minimap_blur","L","B",-0.005,0.021,0.240,0.302)

	Citizen.Wait(5000)

	SetBigmapActive(true,false)

	Citizen.Wait(100)

	SetBigmapActive(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:TOGGLEHOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:toggleHood")
AddEventHandler("hud:toggleHood",function()
	showHood = not showHood

	if showHood then
		SetPedComponentVariation(PlayerPedId(),1,69,0,1)
	else
		SetPedComponentVariation(PlayerPedId(),1,0,0,1)
	end

	SendNUIMessage({ hood = showHood })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:HARDNESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:plateHardness")
AddEventHandler("hud:plateHardness",function(vehPlate,status)
	hardness[vehPlate] = parseInt(status)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ALLHARDNESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:allHardness")
AddEventHandler("hud:allHardness",function(vehHardness)
	hardness = vehHardness
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVEHOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:removeHood")
AddEventHandler("hud:removeHood",function()
	if showHood then
		showHood = false
		SendNUIMessage({ hood = showHood })
		SetPedComponentVariation(PlayerPedId(),1,0,0,1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusHunger")
AddEventHandler("statusHunger",function(number)
	clientHunger = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSTHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusThirst")
AddEventHandler("statusThirst",function(number)
	clientThirst = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSSTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusStress")
AddEventHandler("statusStress",function(number)
	clientStress = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSOXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusOxigen")
AddEventHandler("statusOxigen",function(number)
	clientOxigen = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEOXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:rechargeOxigen")
AddEventHandler("hud:rechargeOxigen",function()
	TriggerEvent("Notify","sucesso","Reabastecimento concluído.")
	vRPS.rechargeOxigen()
	clientOxigen = 100
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUDACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hudActived")
AddEventHandler("hudActived",function(status)
	showHud = status
	
	updateDisplayHud()

	SendNUIMessage({ hud = showHud })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUDACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("termsActived")
AddEventHandler("termsActived",function(status)
	SetNuiFocus(true,true)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ terms = true })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOICEMODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("pma-voice:setTalkingMode")
AddEventHandler("pma-voice:setTalkingMode",function(status)
	voice = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOICEMODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:VoiceMode")
AddEventHandler("hud:VoiceMode",function(status)
	voice = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:RADIODISPLAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RadioDisplay")
AddEventHandler("hud:RadioDisplay",function(number)
	if parseInt(number) <= 0 then
		radioDisplay = ""
	else
		radioDisplay = parseInt(number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Progress")
AddEventHandler("Progress",function(time)
	SendNUIMessage({ progressShow = true, progress = tonumber(time-500) })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOWARDPED
-----------------------------------------------------------------------------------------------------------------------------------------
function fowardPed(ped)
	local heading = GetEntityHeading(ped) + 90.0
	if heading < 0.0 then
		heading = 360.0 + heading
	end

	heading = heading * 0.0174533

	return { x = math.cos(heading) * 2.0, y = math.sin(heading) * 2.0 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBELT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if playerActive then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				if not IsPedOnAnyBike(ped) and not IsPedInAnyHeli(ped) and not IsPedInAnyPlane(ped) then
					timeDistance = 1

					local vehicle = GetVehiclePedIsUsing(ped)
					local speed = GetEntitySpeed(vehicle) * 3.6
					if speed ~= beltSpeed then
						local plate = GetVehicleNumberPlateText(vehicle)

						if ((beltSpeed - speed) >= 50 and beltLock == 0) or ((beltSpeed - speed) >= 75 and beltLock == 1 and hardness[plate] == nil and GetPedInVehicleSeat(vehicle,-1) == ped) then
							local fowardVeh = fowardPed(ped)
							local coords = GetEntityCoords(ped)
							SetEntityCoords(ped,coords["x"] + fowardVeh["x"],coords["y"] + fowardVeh["y"],coords["z"] + 1,1,0,0,0)
							SetEntityVelocity(ped,beltVelocity["x"],beltVelocity["y"],beltVelocity["z"])
							ApplyDamageToPed(ped,50,false)

							Citizen.Wait(1)

							SetPedToRagdoll(ped,5000,5000,0,0,0,0)
						end

						beltVelocity = GetEntityVelocity(vehicle)
						beltSpeed = speed
					end
				end
			else
				if beltSpeed ~= 0 then
					beltSpeed = 0
				end

				if beltLock == 1 then
					beltLock = 0
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("seatbelt",function(source,args)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		if not IsPedOnAnyBike(ped) then
			if beltLock == 1 then
				TriggerEvent("sounds:source","unbelt",0.5)
				beltLock = 0
			else
				TriggerEvent("sounds:source","belt",0.5)
				beltLock = 1
			end
		end
	end
end)

RegisterCommand('+indicatorlights',function(source,args)
	local ped = PlayerPedId()
	local isIn = IsPedInAnyVehicle(ped,false)
	if isIn then
		local vehicle = GetVehiclePedIsIn(ped, false)
		local lights = GetVehicleIndicatorLights(vehicle)
		if args[1] == 'up' then
			lightState = 'up'
			SetVehicleIndicatorLights(vehicle,0,true)
			SetVehicleIndicatorLights(vehicle,1,true)
		elseif args[1] == 'left' then
			lightState = 'left'
			SetVehicleIndicatorLights(vehicle,1,true)
			SetVehicleIndicatorLights(vehicle,0,false)
		elseif args[1] == 'right' then
			lightState = 'right'
			SetVehicleIndicatorLights(vehicle,0,true)
			SetVehicleIndicatorLights(vehicle,1,false)
		elseif args[1] == 'off' and lights >= 0 then
			lightState = 'off'
			SetVehicleIndicatorLights(vehicle,0,false)
			SetVehicleIndicatorLights(vehicle,1,false)
		end
	end
end)

RegisterKeyMapping("+indicatorlights up","Ambas setas.","keyboard","UP")
RegisterKeyMapping("+indicatorlights left","Seta para esquerda.","keyboard","LEFT")
RegisterKeyMapping("+indicatorlights right","Seta para direita.","keyboard","RIGHT")
RegisterKeyMapping("+indicatorlights off","Desligar setas.","keyboard","BACK")

-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("seatbelt","Colocar/Retirar o cinto.","keyboard","g")
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:SYNCTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:syncTimers")
AddEventHandler("hud:syncTimers",function(timer)
	clockHours = parseInt(timer[2])
	clockMinutes = parseInt(timer[1])
	weatherSync = timer[3]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES:HOURS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("homes:Hours")
AddEventHandler("homes:Hours",function(status)
	homeInterior = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHEALTHREDUCE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if playerActive then
			local ped = PlayerPedId()
			if GetEntityHealth(ped) > 101 then
				if clientHunger >= 10 and clientHunger <= 20 then
					ApplyDamageToPed(ped,1,false)
					TriggerEvent("Notify","default","Sofrendo com a fome.",10000,"bottom","atenção")
				elseif clientHunger <= 9 then
					ApplyDamageToPed(ped,2,false)
					TriggerEvent("Notify","default","Sofrendo com a fome.",10000,"bottom","atenção")
				end

				if clientThirst >= 10 and clientThirst <= 20 then
					ApplyDamageToPed(ped,1,false)
					TriggerEvent("Notify","default","Sofrendo com a sede.",10000,"bottom","atenção")
				elseif clientThirst <= 9 then
					ApplyDamageToPed(ped,2,false)
					TriggerEvent("Notify","default","Sofrendo com a sede.",10000,"bottom","atenção")
				end
			end
		end

		Citizen.Wait(15000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHAKESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	clientStress = 0
	while true do
		local timeDistance = 999
		if playerActive then
			local ped = PlayerPedId()
			local health = GetEntityHealth(ped)

			if health > 101 then
				if clientStress >= 99 then
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.95)
				elseif clientStress >= 80 and clientStress <= 98 then
					timeDistance = 9990
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.85)
				elseif clientStress >= 60 and clientStress <= 79 then
					timeDistance = 7500
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.75)
				elseif clientStress >= 40 and clientStress <= 59 then
					timeDistance = 9990
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.55)
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADAR
-----------------------------------------------------------------------------------------------------------------------------------------
local radarStatus = false
RegisterNetEvent("hud:toggleRadar",function(status)
	radarStatus = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGPS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if not radarStatus then
			if IsPedInAnyVehicle(ped) and showHud then
				if not IsMinimapRendering() then
					DisplayRadar(true)
				end
			else
				if IsMinimapRendering() then
					DisplayRadar(false)
				end
			end
		else
			DisplayRadar(true)
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVESCUBA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:removeScuba")
AddEventHandler("hud:removeScuba",function()
	local ped = PlayerPedId()
	if DoesEntityExist(divingMask) or DoesEntityExist(divingTank) then
		if DoesEntityExist(divingMask) then
			TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(divingMask))
			divingMask = nil
		end

		if DoesEntityExist(divingTank) then
			TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(divingTank))
			divingTank = nil
		end

		SetEnableScuba(ped,false)
		SetPedMaxTimeUnderwater(ped,10.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:SETDIVING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:setDiving")
AddEventHandler("hud:setDiving",function()
	local ped = PlayerPedId()

	if DoesEntityExist(divingMask) or DoesEntityExist(divingTank) then
		if DoesEntityExist(divingMask) then
			TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(divingMask))
			divingMask = nil
		end

		if DoesEntityExist(divingTank) then
			TriggerServerEvent("tryDeleteObject",NetworkGetNetworkIdFromEntity(divingTank))
			divingTank = nil
		end

		SetEnableScuba(ped,false)
		SetPedMaxTimeUnderwater(ped,10.0)
	else
		local maskModel = GetHashKey("p_s_scuba_mask_s")
		local tankModel = GetHashKey("p_s_scuba_tank_s")

		RequestModel(tankModel)
		while not HasModelLoaded(tankModel) do
			Citizen.Wait(1)
		end

		RequestModel(maskModel)
		while not HasModelLoaded(maskModel) do
			Citizen.Wait(1)
		end

		if HasModelLoaded(tankModel) then
			divingTank = CreateObject(tankModel,1.0,1.0,1.0,true,true,false)
			AttachEntityToEntity(divingTank,ped,GetPedBoneIndex(ped,24818),-0.28,-0.24,0.0,180.0,90.0,0.0,1,1,0,0,2,1)
			SetEntityAsMissionEntity(divingTank,true,true)
			SetModelAsNoLongerNeeded(divingTank)
		end

		if HasModelLoaded(maskModel) then
			divingMask = CreateObject(maskModel,1.0,1.0,1.0,true,true,false)
			AttachEntityToEntity(divingMask,ped,GetPedBoneIndex(ped,12844),0.0,0.0,0.0,180.0,90.0,0.0,1,1,0,0,2,1)
			SetEntityAsMissionEntity(divingMask,true,true)
			SetModelAsNoLongerNeeded(divingMask)
		end

		SetEnableScuba(ped,true)
		SetPedMaxTimeUnderwater(ped,2000.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:TERMSACCEPT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("termsAccept",function(data,cb)
	SetNuiFocus(false)
	SendNUIMessage({ terms = false })
	TriggerServerEvent("hud:termsAccept")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITROENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function nitroEnable()
	if nitroActive then 
		return 
	end
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)
		if GetPedInVehicleSeat(vehicle,-1) == ped then
			local speed = GetEntitySpeed(vehicle) * 3.6
			if speed >= 70 then
				local vehPlate = GetVehicleNumberPlateText(vehicle)
				nitroFuel = GlobalState["Nitro"][vehPlate] or 0

				if nitroFuel >= 1 then
					TriggerEvent("sounds:source","nitro",0.3)
					nitroActive = true

					while nitroActive do
						if nitroFuel >= 1 then
							nitroFuel = nitroFuel - 1

							if not GetScreenEffectIsActive("RaceTurbo") then
								StartScreenEffect("RaceTurbo",0,true)
							end

							SetVehicleCheatPowerIncrease(vehicle,5.0)
							ModifyVehicleTopSpeed(vehicle,20.0)
							fireExaust(vehicle)
						else
							SetVehicleCheatPowerIncrease(vehicle,0.0)
							TriggerServerEvent('hud:updateNitro',vehPlate,nitroFuel)
							ModifyVehicleTopSpeed(vehicle,0.0)

							if GetScreenEffectIsActive("RaceTurbo") then
								StopScreenEffect("RaceTurbo")
							end

							nitroActive = false
						end

						Citizen.Wait(100)
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITRODISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function nitroDisable()
	if nitroActive then
		nitroActive = false

		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsUsing(ped)
			local vehPlate = GetVehicleNumberPlateText(vehicle)

			SetVehicleCheatPowerIncrease(vehicle,0.0)
			TriggerServerEvent('hud:updateNitro',vehPlate,nitroFuel)

			ModifyVehicleTopSpeed(vehicle,0.0)

			if GetScreenEffectIsActive("RaceTurbo") then
				StopScreenEffect("RaceTurbo")
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXAUSTS
-----------------------------------------------------------------------------------------------------------------------------------------
local exausts = {
	"exhaust","exhaust_2","exhaust_3","exhaust_4","exhaust_5","exhaust_6","exhaust_7","exhaust_8",
	"exhaust_9","exhaust_10","exhaust_11","exhaust_12","exhaust_13","exhaust_14","exhaust_15","exhaust_16"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIREEXAUST
-----------------------------------------------------------------------------------------------------------------------------------------
function fireExaust(vehicle)
	for k,v in ipairs(exausts) do
		local exaustNumber = GetEntityBoneIndexByName(vehicle,v)

		if exaustNumber > -1 then
			UseParticleFxAssetNextCall("core")
			StartNetworkedParticleFxNonLoopedOnEntityBone("veh_backfire",vehicle,0.0,0.0,0.0,0.0,0.0,0.0,exaustNumber,1.75,false,false,false)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVENITRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+activeNitro",nitroEnable)
RegisterCommand("-activeNitro",nitroDisable)
RegisterKeyMapping("+activeNitro","Ativação do nitro.","keyboard","LMENU")