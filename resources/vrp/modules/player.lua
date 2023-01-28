-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local identity = vRP.userIdentity(user_id)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable then
		if dataTable["backpack"] == nil then
			dataTable["backpack"] = 50
		end

		if dataTable["inventory"] == nil then
			dataTable["inventory"] = {}
		end

		if dataTable["health"] == nil then
			dataTable["health"] = 200
		end

		if dataTable["armour"] == nil then
			dataTable["armour"] = 0
		end

		if dataTable["stress"] == nil then
			dataTable["stress"] = 0
		end

		if dataTable["hunger"] == nil then
			dataTable["hunger"] = 100
		end

		if dataTable["thirst"] == nil then
			dataTable["thirst"] = 100
		end

		if dataTable["oxigen"] == nil then
			dataTable["oxigen"] = 100
		end

		Citizen.Wait(1000)

		vRPC.applySkin(source,dataTable["skin"])
		vRPC.setArmour(source,dataTable["armour"])
		vRPC.setHealth(source,dataTable["health"])

		Citizen.Wait(1000)

		TriggerClientEvent("statusStress",source,dataTable["stress"])
		TriggerClientEvent("statusHunger",source,dataTable["hunger"])
		TriggerClientEvent("statusThirst",source,dataTable["thirst"])
		TriggerClientEvent("statusOxigen",source,dataTable["oxigen"])

		TriggerClientEvent("barbershop:apply",source,vRP.userData(user_id,"Barbershop"))
		TriggerClientEvent("skinshop:apply",source,vRP.userData(user_id,"Clothings"))
		TriggerClientEvent("tattoos:apply",source,vRP.userData(user_id,"Tatuagens"))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryDeleteObject")
AddEventHandler("tryDeleteObject",function(entIndex)
	TriggerClientEvent("player:deleteObject",-1,entIndex)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:ENDGAME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:endGame")
AddEventHandler("vRP:endGame",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local dataTable = vRP.getDatatable(user_id)
        if dataTable["inventory"] then
            local isPolice,isCreator,isVip = exports["common"]:Group().hasPermission(user_id,"police"),exports["common"]:Group().hasPermission(user_id,"creator"),exports["store"]:Appointments().isVipById(user_id)
            if not isPolice then 
                for k,v in pairs(dataTable["inventory"]) do 
                    if not itemProtect(v.item) then 
                        dataTable["inventory"][k] = nil 
                    end
                end
            end

			if isPolice or isCreator or isVip then
				dataTable["backpack"] = dataTable["backpack"]
			else
				dataTable["backpack"] = 15
			end

            vRP.upgradeThirst(user_id,100)
            vRP.upgradeHunger(user_id,100)
            vRP.downgradeStress(user_id,100)
        end

        TriggerEvent("inventory:clearWeapons",user_id)
        TriggerClientEvent("dynamic:animalFunctions",source,"deletar")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDAGRADETHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.upgradeThirst(user_id,amount)
	local userSource = vRP.userSource(user_id)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable and userSource then
		if dataTable["thirst"] == nil then
			dataTable["thirst"] = 0
		end

		dataTable["thirst"] = dataTable["thirst"] + amount

		if dataTable["thirst"] >= 100 then
			dataTable["thirst"] = 100
		end

		TriggerClientEvent("statusThirst",userSource,dataTable["thirst"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.upgradeHunger(user_id,amount)
	local userSource = vRP.userSource(user_id)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable and userSource then
		if dataTable["hunger"] == nil then
			dataTable["hunger"] = 0
		end

		dataTable["hunger"] = dataTable["hunger"] + amount

		if dataTable["hunger"] >= 100 then
			dataTable["hunger"] = 100
		end

		TriggerClientEvent("statusHunger",userSource,dataTable["hunger"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.upgradeStress(user_id,amount)
	local userSource = vRP.userSource(user_id)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable and userSource then
		if dataTable["stress"] == nil then
			dataTable["stress"] = 0
		end

		dataTable["stress"] = dataTable["stress"] + amount

		if dataTable["stress"] >= 100 then
			dataTable["stress"] = 100
		end

		TriggerClientEvent("statusStress",userSource,dataTable["stress"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADETHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.downgradeThirst(user_id,amount)
	local userSource = vRP.userSource(user_id)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable and userSource then
		if dataTable["thirst"] == nil then
			dataTable["thirst"] = 100
		end

		dataTable["thirst"] = dataTable["thirst"] - amount

		if dataTable["thirst"] <= 0 then
			dataTable["thirst"] = 0
		end

		TriggerClientEvent("statusThirst",userSource,dataTable["thirst"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADEHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.downgradeHunger(user_id,amount)
	local userSource = vRP.userSource(user_id)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable and userSource then
		if dataTable["hunger"] == nil then
			dataTable["hunger"] = 100
		end

		dataTable["hunger"] = dataTable["hunger"] - amount

		if dataTable["hunger"] <= 0 then
			dataTable["hunger"] = 0
		end

		TriggerClientEvent("statusHunger",userSource,dataTable["hunger"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.downgradeStress(user_id,amount)
	local userSource = vRP.userSource(user_id)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable and userSource then
		if dataTable["stress"] == nil then
			dataTable["stress"] = 0
		end

		dataTable["stress"] = dataTable["stress"] - amount

		if dataTable["stress"] <= 0 then
			dataTable["stress"] = 0
		end

		TriggerClientEvent("statusStress",userSource,dataTable["stress"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLIENTFOODS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.clientFoods()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataTable = vRP.getDatatable(user_id)
		if dataTable then
			if dataTable["thirst"] == nil then
				dataTable["thirst"] = 100
			end

			if dataTable["hunger"] == nil then
				dataTable["hunger"] = 100
			end

			dataTable["hunger"] = dataTable["hunger"] - 1
			dataTable["thirst"] = dataTable["thirst"] - 1

			if dataTable["thirst"] <= 0 then
				dataTable["thirst"] = 0
			end

			if dataTable["hunger"] <= 0 then
				dataTable["hunger"] = 0
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLIENTOXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.clientOxigen()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataTable = vRP.getDatatable(user_id)
		if dataTable then
			if dataTable["oxigen"] == nil then
				dataTable["oxigen"] = 100
			end

			if dataTable["hunger"] == nil then
				dataTable["hunger"] = 100
			end

			dataTable["oxigen"] = dataTable["oxigen"] - 1
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEOXIGEN
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.rechargeOxigen()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataTable = vRP.getDatatable(user_id)
		if dataTable then
			dataTable["oxigen"] = 100
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET POLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getPolice()
	local source = source
	local userId = vRP.getUserId(source)
	if userId then
		return exports["common"]:Group().hasPermission(userId,"police")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET STCreator
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getCreator()
	local source = source
	local userId = vRP.getUserId(source)
	if userId then
		return exports["common"]:Group().hasPermission(userId,"creator")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET HAS PARAMEDIC
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.hasParamedic()
	local source = source
	local userId = vRP.getUserId(source)
	if userId then
		local amountPerms = exports["common"]:Group().getAllByPermission("paramedic")
		return #amountPerms > 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BABY
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getBaby()
	local source = source
	local userId = vRP.getUserId(source)
	if userId then
		return vRP.userIsBaby(userId)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getHealth(source)
	return GetEntityHealth(GetPlayerPed(source))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODELPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.modelPlayer(source)
	local ped = GetPlayerPed(source)
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		return "mp_m_freemode_01"
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		return "mp_f_freemode_01"
	end
end
