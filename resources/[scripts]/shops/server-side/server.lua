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
Tunnel.bindInterface("shops",cRP)
vCLIENT = Tunnel.getInterface("shops")
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

local shops = {
	["beanMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["chocolate"] = 15,
			["coffee"] = 20,
			["donut"] = 15
		}
	},
	["Bullguer"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		--["perm"] = "bullguer",
		["list"] = {
			["bullguer01"] = 75,
			["bullguer02"] = 75,
			["bullguer03"] = 75,
			["bullguer04"] = 75,
			["bullguer05"] = 75,
			["bullguer06"] = 75,
			["bullguer07"] = 75,
			["bullguer08"] = 75,
			["bullguer09"] = 75,
			["bullguer10"] = 75,
			["bullguer11"] = 30,
			["bullguer12"] = 30,
			["bullguer13"] = 30,
			["bullguer14"] = 30,
			["bullguer15"] = 30,
			["bullguer16"] = 30,
			["bullguer17"] = 30,
			["bullguer18"] = 30,
			["bullguer19"] = 30
		}
	},
	["animalStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["rottweiler01"] = 3000,
			["rottweiler02"] = 12000,
			["rottweiler03"] = 20000,
			["husky01"] = 3000,
			["husky02"] = 12000,
			["husky03"] = 20000,
			["shepherd01"] = 3000,
			["shepherd02"] = 12000,
			["shepherd03"] = 20000,
			["retriever01"] = 3000,
			["retriever02"] = 12000,
			["retriever03"] = 20000,
			["poodle01"] = 3000,
			["poodle02"] = 12000,
			["poodle03"] = 20000,
			["pug01"] = 3000,
			["pug02"] = 12000,
			["pug03"] = 20000,
			["westy01"] = 3000,
			["westy02"] = 12000,
			["westy03"] = 20000
		}
	},
	["departamentStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["energetic"] = 15,
			["emptybottle"] = 30,
			["cigarette"] = 10,
			["lighter"] = 175,
			["chocolate"] = 15,
			["sandwich"] = 15,
			["cola"] = 15,
			["soda"] = 15
		}
	},
	["departamentFishs"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["bait"] = 4,
			["energetic"] = 15,
			["emptybottle"] = 30,
			["cigarette"] = 10,
			["lighter"] = 175,
			["chocolate"] = 15,
			["sandwich"] = 15,
			["cola"] = 15,
			["soda"] = 15,
			["fishingrod"] = 725
		}
	},
	["mercadoCentral"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["teddy"] = 75,
			["rose"] = 25,
			["rope"] = 875,
			["firecracker"] = 100,
			["radio"] = 975,
			["cellphone"] = 575,
			["binoculars"] = 275,
			["camera"] = 275,
			["vape"] = 4750,
			["backpack"] = 2500,
			["ringbox"] = 15000
		}
	},
	["mechanicTools"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["tyres"] = 275,
			["toolbox"] = 500,
			["hardness"] = 900,
			["lockpick"] = 400,
			["graphite01"] = 7,
			["graphite02"] = 7,
			["graphite03"] = 7,
			["WEAPON_CROWBAR"] = 725,
			["WEAPON_WRENCH"] = 725
		}
	},
	["oxyStore"] = {
		["mode"] = "Buy",
		["type"] = "Consume",
		["item"] = "dollarsz",
		["list"] = {
			["oxy"] = 75
		}
	},
	["pharmacyStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["gauze"] = 175,
			["bandage"] = 225,
			["analgesic"] = 105,
			["medkit"] = 525,
			["sinkalmy"] = 325,
			["ritmoneury"] = 475,
			["adrenaline"] = 975
		}
	},
	["pharmacyParamedic"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "paramedic",
		["list"] = {
			["gauze"] = 125,
			["bandage"] = 175,
			["analgesic"] = 65,
			["medkit"] = 375,
			["sinkalmy"] = 225,
			["ritmoneury"] = 375,
			["wheelchair"] = 2750
		}
	},
	["ammunationStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["GADGET_PARACHUTE"] = 475,
			["WEAPON_HATCHET"] = 975,
			["WEAPON_BAT"] = 975,
			["WEAPON_BATTLEAXE"] = 975,
			["WEAPON_KATANA"] = 975,
			["WEAPON_KARAMBIT"] = 975,
			["WEAPON_GOLFCLUB"] = 975,
			["WEAPON_HAMMER"] = 725,
			["WEAPON_MACHETE"] = 975,
			["WEAPON_POOLCUE"] = 975,
			["WEAPON_STONE_HATCHET"] = 975,
			["WEAPON_KNUCKLE"] = 975,
			["WEAPON_FLASHLIGHT"] = 675,
			["WEAPON_CROWBAR"] = 725,
			["WEAPON_WRENCH"] = 725,
			["attachs"] = 2750
		}
	},
	-- ["premiumStore"] = {
	-- 	["mode"] = "Buy",
	-- 	["type"] = "Premium",
	-- 	["list"] = {
	-- 		["chip"] = 25,
	-- 		["premium01"] = 50,
	-- 		["premium02"] = 100,
	-- 		["premium03"] = 150,
	-- 		["premium04"] = 200,
	-- 		["premium05"] = 300,
	-- 		["premiumplate"] = 30,
	-- 		["newgarage"] = 5,
	-- 		["newprops"] = 25,
	-- 		["namechange"] = 25,
	-- 		["surnamechange"] = 15,
	-- 		["husky03"] = 7,
	-- 		["cat"] = 7,
	-- 		["pig"] = 7,
	-- 		["shepherd03"] = 7,
	-- 		["retriever03"] = 7,
	-- 		["poodle03"] = 7,
	-- 		["pug03"] = 7,
	-- 		["westy03"] = 7,
	-- 		["ringbox"] = 1
	-- 	}
	-- },
	["huntingSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["meatA"] = 40,
			["meatB"] = 45,
			["meatC"] = 50,
			["meatS"] = 55,
			["animalpelt"] = 50,
			["horndeer"] = 225,
			["tomato"] = 6,
			["banana"] = 4,
			["passion"] = 4,
			["grape"] = 4,
			["tange"] = 4,
			["orange"] = 4,
			["strawberry"] = 4
		}
	},
	["fishingSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["octopus"] = 20,
			["shrimp"] = 20,
			["carp"] = 18,
			["horsefish"] = 18,
			["tilapia"] = 20,
			["codfish"] = 22,
			["catfish"] = 22,
			["goldenfish"] = 23,
			["pirarucu"] = 23,
			["pacu"] = 25,
			["tambaqui"] = 23
		}
	},
	["casinoBuy"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["chips"] = 1
		}
	},
	["casinoSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["chips"] = 1
		}
	},
	-- ["huntingStore"] = {
	-- 	["mode"] = "Buy",
	-- 	["type"] = "Cash",
	-- 	["list"] = {
	-- 		["switchblade"] = 725,
	-- 		["WEAPON_MUSKET"] = 3250,
	-- 		["WEAPON_SNIPERRIFLE"] = 7250,
	-- 		["WEAPON_MUSKET_AMMO"] = 7
	-- 	}
	-- },
	["recyclingSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["key"] = 45,
			["plastic"] = 8,
			["glass"] = 8,
			["rubber"] = 8,
			["aluminum"] = 12,
			["copper"] = 12,
			["fabric"] = 75,
			["radio"] = 485,
			["rope"] = 435,
			["cellphone"] = 285,
			["binoculars"] = 135,
			["emptybottle"] = 15,
			["camera"] = 135,
			["vape"] = 2375,
			["rose"] = 15,
			["lighter"] = 75,
			["teddy"] = 35,
			["tyres"] = 100,
			["bait"] = 2,
			["firecracker"] = 50,
			["fishingrod"] = 365,
			["divingsuit"] = 485,
			["newspaper"] = 15,
			["titanium"] = 225,
			["silvercoin"] = 5,
			["goldcoin"] = 10
		}
	},
	["minerShop"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["emerald"] = 100,
			["diamond"] = 75,
			["ruby"] = 45,
			["sapphire"] = 40,
			["amethyst"] = 35,
			["amber"] = 20,
			["turquoise"] = 25
		}
	},
	["coffeeMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["coffee"] = 20
		}
	},
	["sodaMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["cola"] = 15,
			["soda"] = 15
		}
	},
	["donutMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["donut"] = 15,
			["chocolate"] = 15
		}
	},
	["burgerMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["hamburger"] = 25
		}
	},
	["hotdogMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["hotdog"] = 15
		}
	},
	["waterMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["water"] = 30
		}
	},
	["policeStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "police",
		["list"] = {
			["vest"] = 225,
			["gsrkit"] = 35,
			["gdtkit"] = 35,
			["handcuff"] = 225,
			["WEAPON_SMG"] = 1,
			["WEAPON_PUMPSHOTGUN"] = 1,
			["WEAPON_CARBINERIFLE"] = 1,
			["WEAPON_CARBINERIFLE_MK2"] = 1,
			["WEAPON_STUNGUN"] = 1,
			["WEAPON_COMBATPISTOL"] = 1,
			["WEAPON_HEAVYPISTOL"] = 1,
			["WEAPON_NIGHTSTICK"] = 225,
			["WEAPON_PISTOL_AMMO"] = 6,
			["WEAPON_SMG_AMMO"] = 8,
			["WEAPON_RIFLE_AMMO"] = 8,
			["WEAPON_SHOTGUN_AMMO"] = 8
		}
	},
	["ilegalSelling"] = {
		["mode"] = "Sell",
		["type"] = "Consume",
		["item"] = "dollarsz",
		["list"] = {
			["keyboard"] = 85,
			["mouse"] = 85,
			["silverring"] = 85,
			["goldring"] = 125,
			["watch"] = 100,
			["playstation"] = 100,
			["xbox"] = 100,
			["legos"] = 85,
			["bracelet"] = 95,
			["dildo"] = 85,
			["goldbar"] = 875,
			["lockpick2"] = 75,
			["spray01"] = 85,
			["spray02"] = 85,
			["spray03"] = 85,
			["spray04"] = 85,
			["brick"] = 30,
			["dices"] = 40,
			["dish"] = 85,
			["pan"] = 125,
			["sneakers"] = 115,
			["fan"] = 85,
			["rimel"] = 85,
			["blender"] = 85,
			["switch"] = 35,
			["brush"] = 85,
			["domino"] = 65,
			["floppy"] = 55,
			["horseshoe"] = 85,
			["cup"] = 125,
			["deck"] = 75,
			["eraser"] = 75,
			["pliers"] = 75,
			["lampshade"] = 115,
			["slipper"] = 75,
			["soap"] = 75,
			["pager"] = 225,
			["card01"] = 325,
			["card02"] = 325,
			["card03"] = 375,
			["card04"] = 275,
			["card05"] = 375,
			["pendrive"] = 425,
			["notebook"] = 425
		}
	},
	["mcFridge"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["energetic"] = 15,
			["soda"] = 15,
			["cola"] = 15,
			["sandwich"] = 15,
			["fries"] = 15,
			["donut"] = 15
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPerm(shopType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"negado","Multas pendentes encontradas.",10000,"bottom")
			return false
		end

		if shops[shopType]["perm"] ~= nil then
			if not exports["common"]:Group().hasPermission(user_id,shops[shopType]["perm"]) then
				return false
			end
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestShop(name)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local shopSlots = 20
		local inventoryShop = {}
		for k,v in pairs(shops[name]["list"]) do
			table.insert(inventoryShop,{ key = k, price = parseInt(v), name = itemName(k), index = itemIndex(k), peso = itemWeight(k), type = itemType(k), max = itemMaxAmount(k), desc = itemDescription(k), economy = itemEconomy(k) })
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
function cRP.getShopType(name)
    return shops[name]["mode"]
end---------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionShops(shopType,shopItem,shopAmount,slot)
	local source = source
	local free = Lock(source,5000)
	local user_id = vRP.getUserId(source)
	if user_id then
		if shopAmount == nil then shopAmount = 1 end
		if shopAmount <= 0 then shopAmount = 1 end

		local inventory = vRP.userInventory(user_id)
		if (inventory[tostring(slot)] and inventory[tostring(slot)]["item"] == shopItem) or inventory[tostring(slot)] == nil then
			if shops[shopType]["mode"] == "Buy" then
				if vRP.checkMaxItens(user_id,shopItem,shopAmount) then
					TriggerClientEvent("Notify",source,"negado","Limite atingido.",10000,"bottom")
					vCLIENT.updateShops(source,"requestShop")
					return
				end

				if (vRP.inventoryWeight(user_id) + (itemWeight(shopItem) * parseInt(shopAmount))) <= vRP.getBackpack(user_id) then
					if shops[shopType]["type"] == "Cash" then
						if shops[shopType]["list"][shopItem] then
							if vRP.paymentFull(user_id,shops[shopType]["list"][shopItem] * shopAmount) then
								vRP.generateItem(user_id,shopItem,parseInt(shopAmount),false,slot)
								TriggerClientEvent("sounds:source",source,"cash",0.05)
								exports["common"]:Log().embedDiscord(user_id,"commands-shops","**ITEM:**```"..itemName(shopItem).."```\n**QUANTIDADE:**```"..parseFormat(shopAmount).."```\nComprou às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
							else
								TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
							end
						end
					elseif shops[shopType]["type"] == "Consume" then
						if vRP.tryGetInventoryItem(user_id,shops[shopType]["item"],parseInt(shops[shopType]["list"][shopItem] * shopAmount)) then
							vRP.generateItem(user_id,shopItem,parseInt(shopAmount),false,slot)
							TriggerClientEvent("sounds:source",source,"cash",0.05)
							exports["common"]:Log().embedDiscord(user_id,"commands-shops","**ITEM:**```"..itemName(shopItem).."```\n**QUANTIDADE:**```"..parseFormat(shopAmount).."```\nComprou às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
						else
							TriggerClientEvent("Notify",source,"negado","Insuficiente "..itemName(shops[shopType]["item"])..".",5000)
						end
					elseif shops[shopType]["type"] == "Premium" then
						if exports["store"]:Crypto().remove(user_id,shops[shopType]["list"][shopItem] * shopAmount) then
							TriggerClientEvent("sounds:source",source,"cash",0.05)
							vRP.generateItem(user_id,shopItem,parseInt(shopAmount),false,slot)
							TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseFormat(shopAmount).."x "..itemName(shopItem).."</b> por <b>"..parseFormat(shops[shopType]["list"][shopItem] * shopAmount).." Cryptos</b>.",5000)
							exports["common"]:Log().embedDiscord(user_id,"commands-shops","**ITEM:**```"..itemName(shopItem).."```\n**QUANTIDADE:**```"..parseFormat(shopAmount).."```\nComprou às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
						end
					end
				else
					TriggerClientEvent("Notify",source,"negado","Mochila cheia.",5000)
				end
			elseif shops[shopType]["mode"] == "Sell" then
				local splitName = splitString(shopItem,"-")

				if shops[shopType]["list"][splitName[1]] then
					if vRP.checkBroken(shopItem) then
						TriggerClientEvent("Notify",source,"negado","Itens quebrados não podem ser vendidos.",5000,"bottom")
						vCLIENT.updateShops(source,"requestShop")
						return
					end

					if shops[shopType]["type"] == "Cash" then
						if vRP.tryGetInventoryItem(user_id,shopItem,parseInt(shopAmount),true,slot) then
							vRP.generateItem(user_id,"dollars",parseInt(shops[shopType]["list"][splitName[1]] * shopAmount),false)
							TriggerClientEvent("sounds:source",source,"cash",0.05)
							exports["common"]:Log().embedDiscord(user_id,"commands-shops","**ITEM:**```"..itemName(shopItem).."```\n**QUANTIDADE:**```"..parseFormat(shopAmount).."```\nVendeu às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
						end
					elseif shops[shopType]["type"] == "Consume" then
						if vRP.tryGetInventoryItem(user_id,shopItem,parseInt(shopAmount),true,slot) then
							vRP.generateItem(user_id,shops[shopType]["item"],parseInt(shops[shopType]["list"][splitName[1]] * shopAmount),false)
							TriggerClientEvent("sounds:source",source,"cash",0.05)
							exports["common"]:Log().embedDiscord(user_id,"commands-shops","**ITEM:**```"..itemName(shopItem).."```\n**QUANTIDADE:**```"..parseFormat(shopAmount).."```\nVendeu às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
						end
					end
				end
			end
		end

		vCLIENT.updateShops(source,"requestShop")
	end
	free()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:populateSlot")
AddEventHandler("shops:populateSlot",function(nameItem,slot,target,amount)
	local source = source
	local free = Lock(source,5000)
	local user_id = vRP.getUserId(source)
	if user_id then
		amount = parseInt(amount) or 1
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
			vRP.giveInventoryItem(user_id,nameItem,amount,false,target)
			vCLIENT.updateShops(source,"requestShop")
		end
	end

	free()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:updateSlot")
AddEventHandler("shops:updateSlot",function(nameItem,slot,target,amount)
	local source = source
	local free = Lock(source,5000)
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

		vCLIENT.updateShops(source,"requestShop")
	end
	free()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:DIVINGSUIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:divingSuit")
AddEventHandler("shops:divingSuit",function()
	local source = source
	local free = Lock(source,5000)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.request(source,"Comprar a <b>Roupa de Mergulho</b> pagando <b>$975</b>?",30) then
			if vRP.paymentFull(user_id,975) then
				vRP.generateItem(user_id,"divingsuit",1,true)
			else
				TriggerClientEvent("Notify",source,"negado","Dólares insuficientes.",5000)
			end
		end
	end
	free()
end)