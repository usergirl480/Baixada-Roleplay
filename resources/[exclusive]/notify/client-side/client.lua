-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Notify")
AddEventHandler("Notify",function(css,mensagem,timer,position,title)
	if not timer or timer == "" then
		timer = 10000
	end

	SendNUIMessage({ css = css, mensagem = mensagem, timer = timer, position = position, title = title })
end)

RegisterNetEvent("NotifyPol")
AddEventHandler("NotifyPol",function(nomeadm,mensagem,position)
	SendNUIMessage({ css = "default", mensagem = ""..mensagem.."<br>- <b> "..nomeadm.."</b>", timer = 60000, position = "center", title = "anúncio" })
end)

RegisterNetEvent("pma-voice:status")
AddEventHandler("pma-voice:status", function(status)
    SendNUIMessage({ action = 'setVoip', status = status} )
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
local weaponList = {
	-- PISTOL
	[GetHashKey("WEAPON_PISTOL_MK2")] = "fiveseven",
	[GetHashKey("WEAPON_COMBATPISTOL")] = "combatpistol",
	[GetHashKey("WEAPON_SNSPISTOL")] = "snspistol",
	[GetHashKey("WEAPON_HEAVYPISTOL")] = "heavypistol",
	-- SUBMACHINE GUNS
	[GetHashKey("WEAPON_COMBATPDW")] = "combatpdw",
	[GetHashKey("WEAPON_MACHINEPISTOL")] = "machinepistol",
	[GetHashKey("WEAPON_SMG_MK2")] = "smgmk2",
	[GetHashKey("WEAPON_SMG")] = "sgm",
	-- RIFLES
	[GetHashKey("WEAPON_ADVANCEDRIFLE")] = "advancedrifle",
	[GetHashKey("WEAPON_CARBINERIFLE")] = "carbinerifle",
	[GetHashKey("WEAPON_ASSAULTRIFLE")] = "assaultrifle",
	[GetHashKey("WEAPON_CARBINERIFLE_MK2")] = "carbineriflemk2",
	[GetHashKey("WEAPON_SPECIALCARBINE_MK2")] = "specialcarbinemk2",
}

RegisterNetEvent("NotifyKill")
AddEventHandler("NotifyKill",function(data)
	SendNUIMessage({ 
		kill = true, 
		weapon = weaponList[data.weapon_killer], 
		killer = { 
			name = data.killer_name,
			user_id = data.killer,
		}, 
		victim = { 
			name = data.victim_name,
			user_id = data.victim,
		}, 
	})
end)