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
vCLIENT = Tunnel.getInterface("storage")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKS
-----------------------------------------------------------------------------------------------------------------------------------------
local locks = {}

function Lock(key, ms)
	while locks[key] and locks[key] > GetGameTimer() do Wait(100) end
	locks[key] = GetGameTimer() + ms
	return function()
	locks[key] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local storage = { 
	["Medellin"] = {
		["WEAPON_PISTOL_MK2"] = 20000,
        ["WEAPON_APPISTOL"] = 25000,
        ["WEAPON_SMG_MK2"] = 30000,
        ["WEAPON_MICROSMG"] = 30000,
        ["WEAPON_ASSAULTRIFLE_MK2"] = 45000,
        ["WEAPON_SPECIALCARBINE_MK2"] = 50000,
	},
	["Madrazo"] = {
		["WEAPON_PISTOL_MK2"] = 20000,
        ["WEAPON_APPISTOL"] = 25000,
        ["WEAPON_SMG_MK2"] = 30000,
        ["WEAPON_MICROSMG"] = 30000,
        ["WEAPON_ASSAULTRIFLE_MK2"] = 45000,
        ["WEAPON_SPECIALCARBINE_MK2"] = 50000,
	},
	-- ["Families"] = {
	-- 	["joint"] = 350,
	-- 	["cocaine"] = 350,
	-- 	["meth"] = 350,
	-- },
	-- ["Ballas"] = {
	-- 	["joint"] = 350,
	-- 	["cocaine"] = 350,
	-- 	["meth"] = 350,
	-- },
	-- ["Favela01"] = {
	-- 	["joint"] = 350,
	-- 	["cocaine"] = 350,
	-- 	["meth"] = 350,
	-- },
	-- ["Favela02"] = {
	-- 	["joint"] = 350,
	-- 	["cocaine"] = 350,
	-- 	["meth"] = 350,
	-- },
	-- ["Favela03"] = {
	-- 	["joint"] = 350,
	-- 	["cocaine"] = 350,
	-- 	["meth"] = 350,
	-- },
	-- ["Favela04"] = {
	-- 	["joint"] = 350,
	-- 	["cocaine"] = 350,
	-- 	["meth"] = 350,
	-- },
	-- ["Favela05"] = {
	-- 	["joint"] = 350,
	-- 	["cocaine"] = 350,
	-- 	["meth"] = 350,
	-- },
	-- ["Favela06"] = {
	-- 	["joint"] = 350,
	-- 	["cocaine"] = 350,
	-- 	["meth"] = 350,
	-- },
	["Siciliana"] = {
		["CLIP_PISTOL_AMMO:50"] = 6000,
        ["CLIP_PISTOL_AMMO:150"] = 10000,
        ["CLIP_PISTOL_AMMO:250"] = 15000,
        ["CLIP_SMG_AMMO:50"] = 10000,
        ["CLIP_SMG_AMMO:150"] = 16000,
        ["CLIP_SMG_AMMO:250"] = 28000,
        ["CLIP_RIFLE_AMMO:50"] = 10000,
        ["CLIP_RIFLE_AMMO:150"] = 20000,
        ["CLIP_RIFLE_AMMO:250"] = 30000,
	},
	["Bratva"] = {
		["CLIP_PISTOL_AMMO:50"] = 6000,
        ["CLIP_PISTOL_AMMO:150"] = 10000,
        ["CLIP_PISTOL_AMMO:250"] = 15000,
        ["CLIP_SMG_AMMO:50"] = 10000,
        ["CLIP_SMG_AMMO:150"] = 16000,
        ["CLIP_SMG_AMMO:250"] = 28000,
        ["CLIP_RIFLE_AMMO:50"] = 10000,
        ["CLIP_RIFLE_AMMO:150"] = 20000,
        ["CLIP_RIFLE_AMMO:250"] = 30000,
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
local function giveChest(resultChest,chestName,amount)
	local empty,equal
	for i in inv_range() do
		local cur = resultChest[i]
		if not empty and cur == nil then
			empty = i
		elseif not equal and cur and cur.item == "dollarsz" then
			equal = i
			break
		end 
	end

	slot = equal or empty

	if resultChest[slot] then
		if resultChest[slot].item == "dollarsz" then
			resultChest[slot] = { item = "dollarsz", amount = parseInt(resultChest[slot].amount) + amount }
		end
	else
		resultChest[slot] = { item = "dollarsz", amount = amount }
	end
	vRP.setSrvdata("storageChest:"..chestName,resultChest)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
local function getAmount(chestName,itemName)
	local totalAmount = 0
	local resultChest = vRP.getSrvdata("storageChest:"..chestName)
	for slot, v in pairs(resultChest) do 
		local chestItem = splitString(v.item,"-")
		if chestItem[1] == itemName then 
			totalAmount = totalAmount + v.amount
		end
	end
	return totalAmount
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYITEM
-----------------------------------------------------------------------------------------------------------------------------------------
local function tryItem(chestName,itemName,itemAmount,payment)
	local resultChest = vRP.getSrvdata("storageChest:"..chestName)
	for slot, v in pairs(resultChest) do 
		local chestItem = splitString(v.item,"-")
		if chestItem[1] == itemName then 
			if v.amount > itemAmount then
				v.amount = v.amount - itemAmount
				itemAmount = 0
			elseif v.amount == itemAmount then
				resultChest[slot] = nil
				itemAmount = 0
			else
				itemAmount = itemAmount - v.amount
				resultChest[slot] = nil	  
			end
		end
	end

	if itemAmount == 0 then 
		giveChest(resultChest,chestName,payment)
		return true 
	end
	
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPerm(storageType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local steam = vRP.getSteamBySource(source)
        if steam then
			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"negado","Multas pendentes encontradas.",10000,"bottom")
				return false
			end

			-- local timePlayed = exports["common"]:PlayedTime().getTime(user_id,steam)
			-- if timePlayed < 86400 then
			-- 	TriggerClientEvent("Notify",source,"negado","Você precisa de <b>"..exports["common"]:PlayedTime().format(86400).."</b> de tempo de jogo.",10000,"bottom")
			-- 	TriggerClientEvent("Notify",source,"sucesso","Tempo de jogo: <b>"..exports["common"]:PlayedTime().format(timePlayed).."</b>.",10000)
			-- 	TriggerClientEvent("inventory:Close",source)
			-- 	return
			-- end

			if vRP.wantedReturn(user_id) then
				return false
			end

			if exports["common"]:Group().hasPermission(user_id,"police") or exports["common"]:Group().hasPermission(user_id,"waitpolice") then
				return false
			end
		
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestStorage(name)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local shopSlots = 15
		local inventoryShop = {}

		if storage[name] then 
			for k,v in pairs(storage[name]) do 
				table.insert(inventoryShop,{ key = k, price = parseInt(v), name = itemName(k), index = itemIndex(k), peso = itemWeight(k), type = itemType(k), max = itemMaxAmount(k), desc = itemDescription(k), economy = getAmount(name,k) })
			end
		end

		local inventoryUser = {}
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

			inventoryUser[k] = v
		end

		if parseInt(#inventoryShop) > 20 then
			shopSlots = parseInt(#inventoryShop)
		end

		return inventoryShop,inventoryUser,vRP.inventoryWeight(user_id),vRP.getBackpack(user_id),shopSlots
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSHOPTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getStorageType(name)
    return storage[name]["mode"]
end
---------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionShops(storageType,storageItem,storageAmount,slot)
	local source = source
	local free = Lock(source,500)
	local user_id = vRP.getUserId(source)
	if user_id then
		if storageAmount == nil then storageAmount = 1 end
		if storageAmount <= 0 then storageAmount = 1 end

		local inventory = vRP.userInventory(user_id)
		if (inventory[tostring(slot)] and inventory[tostring(slot)]["item"] == storageItem) or inventory[tostring(slot)] == nil then
			if vRP.checkMaxItens(user_id,storageItem,storageAmount) then
				TriggerClientEvent("Notify",source,"negado","Limite atingido.",10000,"bottom")
				vCLIENT.updateStorage(source,"requestStorage")
				return
			end

			if (vRP.inventoryWeight(user_id) + (itemWeight(storageItem) * parseInt(storageAmount))) <= vRP.getBackpack(user_id) then
				if storage[storageType][storageItem] then
					local consultItem = vRP.getInventoryItemAmount(user_id,"dollarsz")
					if consultItem[1] >= storage[storageType][storageItem] * storageAmount then 
						if tryItem(storageType,storageItem,storageAmount,storage[storageType][storageItem] * storageAmount) then 
							vRP.tryGetInventoryItem(user_id,"dollarsz",storage[storageType][storageItem] * storageAmount)
							vRP.generateItem(user_id,storageItem,parseInt(storageAmount),true,slot)
							TriggerClientEvent("sounds:source",source,"cash",0.05)

							local playerSquad = exports["common"]:Group().getAllByPermission(storageType:lower())
							--if #playerSquad > 0 then 
								for k,v in pairs(playerSquad) do 
									async(function()
										TriggerClientEvent("hub:sendNotification",v,"warning","<b>LOJA</b>","Você vendeu "..storageAmount.."x  <b>"..itemName(storageItem).."</b> e recebeu <b>$"..parseFormat(storage[storageType][storageItem] * storageAmount).."</b> no baú de estoque.",true)
									end)
								end
							--end

							exports["common"]:Log().embedDiscord(user_id,"storage","**ITEM:**```"..itemName(storageItem).."```\n**QUANTIDADE:**```"..parseFormat(storageAmount).."```\nComprou às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
						else
							TriggerClientEvent("Notify",source,"negado","Estoque Indisponível.",10000,"bottom")
						end
					else
						TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",10000,"bottom")
					end
				end
			else
				TriggerClientEvent("Notify",source,"negado","Mochila cheia.",10000,"bottom")
			end
		end

		vCLIENT.updateStorage(source,"requestStorage")
	end
	free()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("storage:populateSlot")
AddEventHandler("storage:populateSlot",function(nameItem,slot,target,amount)
	local source = source
	local free = Lock(source,500)
	local user_id = vRP.getUserId(source)
	if user_id then
		amount = parseInt(amount) or 1
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
			vRP.giveInventoryItem(user_id,nameItem,amount,false,target)
			vCLIENT.updateStorage(source,"requestStorage")
		end
	end
	free()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("storage:updateSlot")
AddEventHandler("storage:updateSlot",function(nameItem,slot,target,amount)
	local source = source
	local free = Lock(source,500)
	local user_id = vRP.getUserId(source)
	if user_id then
		amount = parseInt(amount) or 1
		if amount <= 0 then amount = 1 end

		local inventory = vRP.userInventory(user_id)
		if inventory[tostring(slot)] and inventory[tostring(target)] and inventory[tostring(slot)]["item"] == inventory[tostring(target)]["item"] then
			if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
				vRP.giveInventoryItem(user_id,nameItem,amount,false,target)
			end
		else
			vRP.swapSlot(user_id,slot,target)
		end

		vCLIENT.updateStorage(source,"requestStorage")
	end
	free()
end)

exports("storeItens",function()
	return storage 
end)