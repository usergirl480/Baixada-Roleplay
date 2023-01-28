-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("inspect",cRP)
vCLIENT = Tunnel.getInterface("inspect")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local openPlayer = {}
local openSource = {}
local usersControl = {}

function checkInventory(chest, user_id)
	return (not usersControl[chest] or usersControl[chest] == user_id)
end

function setControl(chest, user_id)
	if not chest_user_control[chest] then
		usersControl[chest] = user_id
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:RUNINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:runRobbery",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	local targetId = vRP.getUserId(entity[1])
	local inventory_name = "user_"..targetId
	if user_id and vRP.getHealth(entity[1]) > 101 then
		if not exports["common"]:Group().hasPermission(targetId,"police") then
			if checkInventory(inventory_name, user_id) then
				TriggerClientEvent("Notify",source,"sucesso","Solicitação enviada.",10000,"bottom")
				if vRP.request(entity[1],"Você aceita ser roubado?",15) then
					TriggerClientEvent("player:blockCommands",entity[1],true)
					TriggerClientEvent("inventory:Close",entity[1])
					openPlayer[user_id] = targetId
					setControl(inventory_name,user_id)
					-- usersControl[targetId] = true
					vCLIENT.toggleCarry(entity[1],source)
					openSource[user_id] = entity[1]
					vCLIENT.openInspect(source)
					TriggerClientEvent("Notify",entity[1],"sucesso","Aguarde o término do roubo.",10000,"bottom")
				else
					TriggerClientEvent("Notify",source,"negado","Usuário recusou o roubo.",10000,"bottom")
				end
			end
		else
			TriggerClientEvent("Notify",source,"negado","Você não pode roubar um Policial.",10000,"bottom")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:RUNINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:runInspect",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(entity[1]) <= 101 then
		local targetId = vRP.getUserId(entity[1])
		if not exports["common"]:Group().hasPermission(targetId,"police") then
			TriggerClientEvent("player:blockCommands",entity[1],true)
			TriggerClientEvent("inventory:Close",entity[1])
			openPlayer[user_id] = targetId
			vCLIENT.toggleCarry(entity[1],source)
			openSource[user_id] = entity[1]
			vCLIENT.openInspect(source)
		else
			TriggerClientEvent("Notify",source,"negado","Você não pode saquear um Policial.",10000,"bottom")
		end
	else
		TriggerClientEvent("Notify",source,"negado","Este usuário não está desmaiado.",10000,"bottom")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:RUNINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:runInspect")
AddEventHandler("police:runInspect",function(entity)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.getHealth(source) > 101 then
		local targetId = vRP.getUserId(entity[1])
		if exports["common"]:Group().hasPermission(user_id,"police") then
			TriggerClientEvent("player:blockCommands",entity[1],true)
			TriggerClientEvent("inventory:Close",entity[1])
			openPlayer[user_id] = targetId
			vCLIENT.toggleCarry(entity[1],source)
			openSource[user_id] = entity[1]
			vCLIENT.openInspect(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openChest(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myInventory = {}
		local inventory = vRP.userInventory(user_id)
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["type"] = itemType(v["item"])
			v["desc"] = itemDescription(v["item"])
			v["economy"] = itemEconomy(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				elseif itemCharges(v["item"]) then
					v["charges"] = tostring(parseInt(splitName[2]))
					v["durability"] = 0
					v["days"] = 1
				elseif splitName[1] == "ring" then 
					local identity = vRP.userIdentity(parseInt(splitName[2]))
					v["desc"] = "Em um relacionamento sério com "..identity.name.." "..identity.name2
					v["durability"] = 0
					v["days"] = 1
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			myInventory[k] = v
		end

		local myChest = {}
		local inventory = vRP.userInventory(openPlayer[user_id])
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["type"] = itemType(v["item"])
			v["desc"] = itemDescription(v["item"])
			v["economy"] = itemEconomy(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				elseif itemCharges(v["item"]) then
					v["charges"] = tostring(parseInt(splitName[2]))
					v["durability"] = 0
					v["days"] = 1
				elseif splitName[1] == "ring" then 
					local identity = vRP.userIdentity(parseInt(splitName[2]))
					v["desc"] = "Em um relacionamento sério com "..identity.name.." "..identity.name2
					v["durability"] = 0
					v["days"] = 1
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			myChest[k] = v
		end

		return myInventory,myChest,vRP.inventoryWeight(user_id),vRP.getBackpack(user_id),vRP.inventoryWeight(openPlayer[user_id]),vRP.getBackpack(openPlayer[user_id])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.storeItem(nameItem,slot,amount,target)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if openSource[user_id] then
			if DoesEntityExist(GetPlayerPed(openSource[user_id])) then
				local inventory_name = "user_"..openPlayer[user_id]
				if checkInventory(inventory_name, user_id) then
					if vRP.checkMaxItens(openPlayer[user_id],nameItem,amount) then
						TriggerClientEvent("Notify",source,"negado","Limite atingido.",10000,"bottom")
						TriggerClientEvent("inspect:Update",source,"requestChest")
						return
					end

					if (vRP.inventoryWeight(openPlayer[user_id]) + (itemWeight(nameItem) * parseInt(amount))) <= vRP.getBackpack(openPlayer[user_id]) then
						if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
							vRP.giveInventoryItem(openPlayer[user_id],nameItem,amount,true,target)
						end
						TriggerClientEvent("inspect:Update",source,"requestChest")
					else
						TriggerClientEvent("Notify",source,"negado","Mochila cheia.",5000)
						TriggerClientEvent("inspect:Update",source,"requestChest")
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.takeItem(nameItem,slot,amount,target)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if openSource[user_id] then
			if DoesEntityExist(GetPlayerPed(openSource[user_id])) then
				local inventory_name = "user_"..openPlayer[user_id]
				if checkInventory(inventory_name, user_id) then
					if vRP.checkMaxItens(user_id,nameItem,amount) then
						TriggerClientEvent("Notify",source,"negado","Limite atingido.",10000,"bottom")
						TriggerClientEvent("inspect:Update",source,"requestChest")
						return
					end

					if itemProtect(nameItem) and nameItem ~= "dollars" then 
						TriggerClientEvent("Notify",source,"negado","Ação bloqueada.",10000,"bottom")
						TriggerClientEvent("inspect:Update",source,"requestChest")
						return 
					end

					if (vRP.inventoryWeight(user_id) + (itemWeight(nameItem) * parseInt(amount))) <= vRP.getBackpack(user_id) then
						vRP.removeInventoryItem(openPlayer[user_id],nameItem,amount,false,slot)
						if not exports["common"]:Group().hasPermission(user_id,"police") then 
							vRP.giveInventoryItem(user_id,nameItem,amount,true,target)
						else
							if nameItem == "dollars" or nameItem == "dollarsz" then
								vRP.storePolice(amount)
							end
						end

						TriggerClientEvent("inspect:Update",source,"requestChest")
						exports["common"]:Log().embedDiscord(user_id,"inspect","**ID REVISTADO:**```"..openPlayer[user_id].."```\n**ITEM REMOVIDO:**```"..itemName(nameItem).."```\n**QUANTIDADE:**```"..parseInt(amount).."```\nRevistado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
					else
						TriggerClientEvent("Notify",source,"negado","Mochila cheia.",5000)
						TriggerClientEvent("inspect:Update",source,"requestChest")
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateChest(slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if openSource[user_id] then
			if DoesEntityExist(GetPlayerPed(openSource[user_id])) then
				if vRP.invUpdate(openPlayer[user_id],slot,target,amount) then
					TriggerClientEvent("inspect:Update",source,"requestChest")
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.resetInspect()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if openSource[user_id] then
			if DoesEntityExist(GetPlayerPed(openSource[user_id])) then
				TriggerClientEvent("player:blockCommands",openSource[user_id],false)
				vCLIENT.toggleCarry(openSource[user_id],source)
			end
		end
		--usersControl[openPlayer[user_id]] = false
		for k, v in pairs(usersControl) do
			if v == user_id then				
				usersControl[k] = nil
			end
		end

		if openSource[user_id] then
			openSource[user_id] = nil
		end

		if openPlayer[user_id] then
			openPlayer[user_id] = nil
		end
	end
end

-- AddEventHandler("vRP:playerLeave",function(user_id,source)
-- 	if usersControl[user_id] then
-- 		usersControl[user_id] = nil
-- 	end
-- end)