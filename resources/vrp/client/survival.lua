-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local timeDeath = 600
local treatment = false
local deathStatus = false
local invencibleCount = 0
local playerActive = false
local emergencyButton = false
local updateTimers = GetGameTimer()
local respawnCoords = vec3(340.13,-1395.7,32.5)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp:playerActive")
AddEventHandler("vrp:playerActive",function(user_id,surname)
	playerActive = true

	SetDiscordAppId(994010956155863183)
    SetDiscordRichPresenceAsset('logo')
    SetDiscordRichPresenceAction(0, "JOGAR", "fivem://connect/baixada.net")
	SetDiscordRichPresenceAction(1, "DISCORD", "https://discord.gg/baixada")
    SetRichPresence(""..surname.." ["..user_id.."]")

	SetEntityInvincible(PlayerPedId(),true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if playerActive then
			if GetGameTimer() >= updateTimers then
				if not LocalPlayer.state.inArena then 
					local ped = PlayerPedId()
					updateTimers = GetGameTimer() + 10000
					vRPS.userUpdate(GetPedArmour(ped),GetEntityHealth(ped),GetEntityCoords(ped))

					if invencibleCount < 3 then
						invencibleCount = invencibleCount + 1

						if invencibleCount >= 3 then
							SetEntityInvincible(ped,false)
							TriggerEvent("paramedic:playerActive")
						end
					end
				end
			end
		end

		Citizen.Wait(5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	LocalPlayer.state.inArena = false
	while true do
		local timeDistance = 999

		if playerActive then
			local ped = PlayerPedId()
			if GetEntityHealth(ped) <= 101 and not LocalPlayer.state.inArena then
				if not deathStatus then
					timeDeath = 600
					respawnCoords = vec3(340.13,-1395.7,32.5)

					if vRPS.getPolice() then 
						timeDeath = 300
						respawnCoords = vec3(-740.8,-1242.72,5.7)
					end

					if vRPS.getBaby() then 
						timeDeath = 150
					end

					if vRPS.getCreator() then 
						timeDeath = 300
					end

					if not vRPS.hasParamedic() then
						timeDeath = 60
					end

					deathStatus = true
					emergencyButton = false

					SendNUIMessage({ death = true })

					TriggerEvent("inventory:preventWeapon",false)

					local coords = GetEntityCoords(ped)
					NetworkResurrectLocalPlayer(coords,true,true,false)

					SetEntityHealth(ped,101)
					SetEntityInvincible(ped,true)

					TriggerEvent("hud:removeHood")
					TriggerEvent("hud:removeScuba")
					TriggerEvent("radio:outServers")
					TriggerEvent("pma-voice:toggleMute")
					TriggerEvent("inventory:Close")
					TriggerServerEvent("inventory:Cancel")
					exports["smartphone"]:closeSmartphone()
				else
					timeDistance = 1
					SetEntityHealth(ped,101)

					if timeDeath == 0 then
						SendNUIMessage({ deathtext = "<color><h1>E</h1></color> <small>pressione para renascer</small>" })
					else
						SendNUIMessage({ deathtext = "<h1>DESMAIADO</h1> <small>aguarde <color>"..timeDeath.." segundos </color></small>" })
					end

					if not IsEntityPlayingAnim(ped,"dead","dead_a",3) and not IsPedInAnyVehicle(ped) then
						tvRP.playAnim(false,{"dead","dead_a"},true)
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTHRECHARGE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		SetPlayerHealthRechargeMultiplier(PlayerId(),0)
		SetPlayerHealthRechargeLimit(PlayerId(),0)
		
		if GetEntityMaxHealth(PlayerPedId()) ~= 200 then
			SetEntityMaxHealth(PlayerPedId(),200)
			SetPedMaxHealth(PlayerPedId(),200)
		end

		Citizen.Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.checkDeath()
	if deathStatus and timeDeath <= 0 then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getDeath()
	return deathStatus
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.resetDeath()
	timeDeath = 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVEPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.revivePlayer(health)
	SetEntityHealth(PlayerPedId(),health)
	SetEntityInvincible(PlayerPedId(),false)

	if deathStatus then
		timeDeath = 600
		deathStatus = false

		ClearPedTasks(PlayerPedId())

		TriggerEvent("resetBleeding")
		SendNUIMessage({ death = false })
		TriggerEvent("pma-voice:toggleMute")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.startTreatment()
	if not treatment then
		TriggerEvent("player:blockCommands",true)
		TriggerEvent("resetDiagnostic")
		TriggerEvent("resetBleeding")
		treatment = true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local treatmentTimers = GetGameTimer()

	while true do
		if GetGameTimer() >= treatmentTimers then
			treatmentTimers = GetGameTimer() + 1000

			if treatment then
				local ped = PlayerPedId()
				local health = GetEntityHealth(ped)

				if health < 200 then
					SetEntityHealth(ped,health + 1)
				else
					treatment = false
					TriggerEvent("player:blockCommands",false)
					TriggerEvent("Notify","importante","Tratamento concluido.",5000)
				end
			end
		end

		Citizen.Wait(500)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMEDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local deathTimers = GetGameTimer()

	while true do
		if GetGameTimer() >= deathTimers then
			deathTimers = GetGameTimer() + 1000

			if deathStatus then
				if timeDeath > 0 then
					timeDeath = timeDeath - 1
				end
			end
		end

		Citizen.Wait(500)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if deathStatus then
			timeDistance = 1
			DisableControlAction(1,18,true)
			DisableControlAction(1,22,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,68,true)
			DisableControlAction(1,69,true)
			DisableControlAction(1,70,true)
			DisableControlAction(1,91,true)
			DisableControlAction(1,75,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND DEATH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+death",function(source,args,rawCommand)
	local ped = PlayerPedId()
	if timeDeath <= 0 then 
		timeDeath = 600
		deathStatus = false

		ClearPedTasks(ped)
		ClearPedBloodDamage(ped)
		SetEntityHealth(ped,200)
		SetEntityInvincible(ped,false)

		TriggerEvent("resetHandcuff")
		TriggerEvent("resetBleeding")
		TriggerEvent("resetDiagnostic")
		TriggerServerEvent("vRP:endGame")
		TriggerEvent("pma-voice:toggleMute")
		TriggerEvent("inventory:clearWeapons")

		DoScreenFadeOut(0)
		SetEntityCoordsNoOffset(ped,respawnCoords.x,respawnCoords.y,respawnCoords.z,false,false,false,true)
		SendNUIMessage({ death = false })

		Citizen.Wait(1000)

		DoScreenFadeIn(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING DEATH
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	RegisterKeyMapping("+death","E","keyboard","E")
end)