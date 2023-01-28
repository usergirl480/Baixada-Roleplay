local locks = {}

function Lock(key, ms)
	while locks[key] and locks[key] > GetGameTimer() do Wait(100) end
	locks[key] = GetGameTimer() + ms
	return function()
	locks[key] = nil
	end
end

local chestsList = {}
local openedVaults = {}
local noStore = {
	["octopus"] = true,
	["shrimp"] = true,
	["carp"] = true,
	["codfish"] = true,
	["catfish"] = true,
	["goldenfish"] = true,
	["horsefish"] = true,
	["tilapia"] = true,
	["pacu"] = true,
	["pirarucu"] = true,
	["tambaqui"] = true,
	["meatA"] = true,
	["meatB"] = true,
	["meatC"] = true,
	["meatS"] = true,
	["energetic"] = true,
	["water"] = true,
	["dirtywater"] = true,
	["coffee"] = true,
	["cola"] = true,
	["tacos"] = true,
	["fries"] = true,
	["soda"] = true,
	["hamburger"] = true,
	["hamburger2"] = true,
	["hamburger3"] = true,
	["hamburger4"] = true,
	["hamburger5"] = true,
	["hotdog"] = true,
	["donut"] = true,
	["chocolate"] = true,
	["sandwich"] = true,
	["absolut"] = true,
	["chandon"] = true,
	["dewars"] = true,
	["hennessy"] = true,
	["ketchup"] = true,
	["orange"] = true,
	["strawberry"] = true,
	["grape"] = true,
	["tange"] = true,
	["banana"] = true,
	["passion"] = true,
	["tomato"] = true,
	["orangejuice"] = true,
	["tangejuice"] = true,
	["grapejuice"] = true,
	["strawberryjuice"] = true,
	["bananajuice"] = true,
	["passionjuice"] = true,
	["bread"] = true,
	["chip"] = true,
	["premium01"] = true,
	["premium02"] = true,
	["premium03"] = true,
	["premium04"] = true,
	["premium05"] = true,
	["premiumplate"] = true,
	["newgarage"] = true,
	["newchars"] = true,
	["newprops"] = true,
	["namechange"] = true,
	["surnamechange"] = true,
	["homecont01"] = true,
	["homecont02"] = true,
	["homecont03"] = true,
	["homecont04"] = true,
	["homecont05"] = true,
	["homecont06"] = true,
	["homecont07"] = true,
	["homecont08"] = true,
	["homecont09"] = true,
	["ring"] = true
}

local function loadChests()
    local query = exports.oxmysql:query_async("SELECT * FROM chests")
    if #query <= 0 then return end

    for k,v in pairs(query) do
        chestsList[v.name] = { weight = v.weight, perm = v.perm, coords = json.decode(v.coords), logs = v.logs }
		Citizen.Wait(10)
    end

	print("Chest: Loaded all chests!")
    TriggerClientEvent("chests:client:setChests",-1,chestsList)
end

function server.hasPermission(chestName)
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if chestName:find("Bullguer") then return true end
        if not chestsList[chestName] then return false end

        if exports.common:Group().hasPermission(userId,chestsList[chestName].perm) or exports.common:Group().hasPermission(userId,"staff")  then
            return true
        end
    end
    return false
end

function server.upgradeChest(chestName)
    local source = source
	local userId = vRP.getUserId(source)
	if userId then
		if chestsList[chestName] then
			local upgradePrice = 50000

			if exports["common"]:Group().hasPermission(userId,chestsList[chestName].perm) or exports["common"]:Group().hasPermission(userId,"staff") then
				if vRP.request(source,"Comprar <b>25Kg</b> pagando <b>$"..parseFormat(upgradePrice).."</b>?",30) then
					if vRP.paymentFull(userId,upgradePrice) then
                        exports.oxmysql:query("UPDATE `chests` SET `weight` = `weight` + 25 WHERE `name` = @name",{ name = chestName })
						chestsList[chestName].weight = chestsList[chestName].weight + 25
						TriggerClientEvent("Notify",source,"sucesso","Compra concluída.",3000)
					else
						TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
					end
				end
			end
		end
	end
end

function server.openChest(chestName,storageSystem)
    local source = source
	local userId = vRP.getUserId(source)
	if userId then
		if chestName == "Bullguer2" then chestName = "Bullguer" end

		local myInventory = {}
		local inventory = vRP.userInventory(userId)
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
		local nameChest = storageSystem and "storageChest:"..chestName or "stackChest:"..chestName
		local result = vRP.getSrvdata(nameChest)
		openedVaults[userId] = nameChest

		for k,v in pairs(result) do
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
				v["durability"] = parseInt(os.time() - splitName[2])
				v["days"] = itemDurability(v["item"])
				v["serial"] = splitName[3]
			else
				v["durability"] = 0
				v["days"] = 1
			end

			myChest[k] = v
		end

		if chestsList[chestName] then
			return myInventory,myChest,vRP.inventoryWeight(userId),vRP.getBackpack(userId),vRP.chestWeight(result),chestsList[chestName].weight
		end
	end
end

function server.storeItem(nameItem,slot,amount,target,chestName)
	local source = source
	local free = Lock(source,5000)
	local userId = vRP.getUserId(source)
	if userId then
		if chestName == "Bullguer2" then chestName = "Bullguer" end

		if chestName ~= "Bullguer" then
			local name = splitString(nameItem,"-")
			if noStore[name[1]] then
				TriggerClientEvent("chest:Update",source,"requestChest")
				TriggerClientEvent("Notify",source,"negado","Ação bloqueada.",10000,"bottom")
				return
			end
		else
			if chestName == "Bullguer" and nameItem ~= "bullguerbox" then
				TriggerClientEvent("chest:Update",source,"requestChest")
				TriggerClientEvent("Notify",source,"negado","Ação bloqueada.",10000,"bottom")
				return
			end
		end

		if chestsList[chestName] then
			if (openedVaults[userId]):find "storageChest:" then 
				local storageItens = exports.storage:storeItens()
				local consultItem = splitString(nameItem,"-")
				if consultItem[2] then 
					local storageTime = parseInt(os.time() - (itemDurability(nameItem) / 2) * 86400) 
					if parseInt(consultItem[2]) <= storageTime then 
						TriggerClientEvent("chest:Update",source,"requestChest")
						return TriggerClientEvent("Notify",source,"negado","Item usado.",10000,"bottom") 
					end
				end

				if ItemMaxStorage(nameItem) then 
					local resultChest = vRP.getSrvdata("storageChest:"..chestName)
					local totalAmount = amount
					local splitName = splitString(nameItem,"-")
					for k,v in pairs(resultChest) do 
						local itemName = splitString(v.item,"-")
						if itemName[1] == splitName[1] then 
							totalAmount = totalAmount + v.amount
						end
					end

					if totalAmount > ItemMaxStorage(nameItem) then 
						TriggerClientEvent("chest:Update",source,"requestChest")
						return TriggerClientEvent("Notify",source,"negado","Limite máximo de "..ItemMaxStorage(nameItem).."x <b>"..itemName(nameItem).."</b> atingido.",10000,"bottom")
					end
				end
				

				if storageItens[chestName] and not storageItens[chestName][consultItem[1]] then 
					TriggerClientEvent("chest:Update",source,"requestChest")
					return TriggerClientEvent("Notify",source,"negado","Ação bloqueada.",10000,"bottom")
				end
			end

			if vRP.storeChest(userId,openedVaults[userId],amount,chestsList[chestName]["weight"],slot,target) then
				TriggerClientEvent("chest:Update",source,"requestChest")
			else
				local result = vRP.getSrvdata(openedVaults[userId])
				TriggerClientEvent("chest:UpdateWeight",source,vRP.inventoryWeight(userId),vRP.getBackpack(userId),vRP.chestWeight(result),chestsList[chestName]["weight"])

				if parseInt(chestsList[chestName]["logs"]) >= 1 then
					exports["common"]:Log().embedDiscord(userId,"chest-"..chestName:lower(),"**GUARDOU**```"..amount.."x "..itemName(nameItem).."```\nAção executada às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
				end
			end
		end
	end
	free()
end

function server.takeItem(nameItem,slot,amount,target,chestName)
	local source = source
	local free = Lock(source,5000)
	local userId = vRP.getUserId(source)
	if userId then
		if chestName == "Bullguer2" then chestName = "Bullguer" end

		if chestsList[chestName] then
			if vRP.tryChest(userId,openedVaults[userId],amount,slot,target) then
				TriggerClientEvent("chest:Update",source,"requestChest")
			else
				local result = vRP.getSrvdata(openedVaults[userId])
				TriggerClientEvent("chest:UpdateWeight",source,vRP.inventoryWeight(userId),vRP.getBackpack(userId),vRP.chestWeight(result),chestsList[chestName]["weight"])

				if parseInt(chestsList[chestName]["logs"]) >= 1 then
					exports["common"]:Log().embedDiscord(userId,"chest-"..chestName:lower(),"**RETIROU**```"..amount.."x "..itemName(nameItem).."```\nAção executada às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
				end
			end
		end
	end
	free()
end

function server.updateChest(slot,target,amount,chestName)
	local source = source
	local userId = vRP.getUserId(source)
	if userId then
		if vRP.updateChest(userId,openedVaults[userId],slot,target,amount) then
			TriggerClientEvent("chest:Update",source,"requestChest")
		end
	end
end

function server.closeSystem()
    local source = source
    local userId = vRP.getUserId(source)
    if openedVaults[userId] then openedVaults[userId] = nil end
end

AddEventHandler("vRP:playerSpawn",function(userId, source) 
    Citizen.Wait(1000) 
    TriggerClientEvent("chests:client:setChests",source,chestsList) 
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	loadChests()
end)

exports("loadChests", loadChests)