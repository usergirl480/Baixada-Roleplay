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
Tunnel.bindInterface("crafting",cRP)
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
-- CRAFTLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local craftList = {
	["dirtyMoneys"] = {
		["list"] = {
			["dollars"] = {
				["amount"] = 1000,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 2000
				}
			}
		}
	},
	["BlackMarket"] = {
		["list"] = {
			["lean"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["dollars"] = 600
				}
			},
			["handcuff"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollars"] = 3000,
					["aluminum"] = 10
				}
			}
		}
	},
	["Ecstasy"] = {
		["perm"] = "ecstasy",
		["list"] = {
			["Ecstasybox"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 6,
					["woodlog"] = 6,
					["nails"] = 8,
					["ecstasy"] = 2,
				}
			},
			["ecstasy"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 200,
				}
			},
			["ecstasy"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 200,
				}
			},
		}
	},
	["Cocaine"] = {
		["perm"] = "cocaine",
		["list"] = {
			["Cocainebox"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 6,
					["woodlog"] = 6,
					["nails"] = 8,
					["cocaine"] = 2,
				}
			},
			["cocaine"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 200,
				}
			},
			["cocaine"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 200,
				}
			},
		}
	},
	["Weed"] = {
		["perm"] = "weed",
		["list"] = {
			["Weedbox"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["plastic"] = 6,
					["woodlog"] = 6,
					["nails"] = 8,
					["joint"] = 2,
				}
			},
			["joint"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollarsz"] = 200,
				}
			},
		}
	},

	["AmmoResult"] = {
		["perm"] = "ammo",
		["list"] = {
			["projectile"] = {
				["amount"] = 5,
				["destroy"] = false,
				["require"] = {
					["copper"] = 2
				}
			},
			["gunpowder"] = {
				["amount"] = 5,
				["destroy"] = false,
				["require"] = {
					["rubber"] = 2
				}
			},
			["capsule"] = {
				["amount"] = 5,
				["destroy"] = false,
				["require"] = {
					["aluminum"] = 2
				}
			},
			["CLIP_PISTOL_AMMO:50"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["projectile"] = 25,
					["gunpowder"] = 25,
					["capsule"] = 25
				}
			},
			["CLIP_PISTOL_AMMO:150"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["projectile"] = 45,
					["gunpowder"] = 45,
					["capsule"] = 45
				}
			},
			["CLIP_PISTOL_AMMO:250"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["projectile"] = 75,
					["gunpowder"] = 75,
					["capsule"] = 75
				}
			},
			["CLIP_SMG_AMMO:50"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["projectile"] = 45,
					["gunpowder"] = 45,
					["capsule"] = 45
				}
			},
			["CLIP_SMG_AMMO:150"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["projectile"] = 65,
					["gunpowder"] = 65,
					["capsule"] = 65
				}
			},
			["CLIP_SMG_AMMO:250"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["projectile"] = 75,
					["gunpowder"] = 75,
					["capsule"] = 75
				}
			},
			["CLIP_RIFLE_AMMO:50"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["projectile"] = 55,
					["gunpowder"] = 55,
					["capsule"] = 55
				}
			},
			["CLIP_RIFLE_AMMO:150"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["projectile"] = 65,
					["gunpowder"] = 65,
					["capsule"] = 65
				}
			},
			["CLIP_RIFLE_AMMO:250"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["projectile"] = 85,
					["gunpowder"] = 85,
					["capsule"] = 85
				}
			}
		}
	},
	["WeaponCraft"] = {
        ["perm"] = "weapon",
        ["list"] = {
            ["WEAPON_PISTOL_MK2"] = {
                ["amount"] = 1,
                ["destroy"] = false,
                ["require"] = {
                    ["pistolbody"] = 5,
                    ["aluminum"] = 25,
                    ["plastic"] = 25

                }
            },
            ["WEAPON_APPISTOL"] = {
                ["amount"] = 1,
                ["destroy"] = false,
                ["require"] = {
                    ["pistolbody"] = 10,
                    ["aluminum"] = 45,
                    ["plastic"] = 45
                }
            },
            ["WEAPON_SMG_MK2"] = {
                ["amount"] = 1,
                ["destroy"] = false,
                ["require"] = {
                    ["smgbody"] = 15,
                    ["aluminum"] = 40,
                    ["plastic"] = 40
                }
            },
            ["WEAPON_MICROSMG"] = {
                ["amount"] = 1,
                ["destroy"] = false,
                ["require"] = {
                    ["smgbody"] = 15,
                    ["aluminum"] = 40,
                    ["plastic"] = 40
                }
            },
            ["WEAPON_ASSAULTRIFLE_MK2"] = {
                ["amount"] = 1,
                ["destroy"] = false,
                ["require"] = {
                    ["riflebody"] = 20,
                    ["aluminum"] = 75,
                    ["plastic"] = 75
                }
            },
            ["WEAPON_SPECIALCARBINE_MK2"] = {
                ["amount"] = 20,
                ["destroy"] = false,
                ["require"] = {
                    ["riflebody"] = 20,
                    ["aluminum"] = 100,
                    ["plastic"] = 100
                }
            }
        }
    },
	["lixeiroShop"] = {
		["list"] = {
			["glass"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["glassbottle"] = 1
				}
			},
			["plastic"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["plasticbottle"] = 1
				}
			},
			["rubber"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["elastic"] = 1
				}
			},
			["aluminum"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["metalcan"] = 1
				}
			},
			["copper"] = {
				["amount"] = 3,
				["destroy"] = false,
				["require"] = {
					["battery"] = 1
				}
			}
		}
	},
	["fuelShop"] = {
		["list"] = {
			["WEAPON_PETROLCAN"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["dollars"] = 50
				}
			},
			["WEAPON_PETROLCAN_AMMO"] = {
				["amount"] = 4500,
				["destroy"] = false,
				["require"] = {
					["dollars"] = 200
				}
			}
		}
	},
	["dressMaker"] = {
		["list"] = {
			["backpack"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["fabric"] = 7
				}
			},
			["fabric"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["animalpelt"] = 4,
					["rubber"] = 3
				}
			}
		}
	},
	["makeFoods"] = {
		["list"] = {
			["hamburger2"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["meatA"] = 1,
					["bread"] = 2,
					["ketchup"] = 1
				}
			},
			["hamburger3"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["meatB"] = 1,
					["bread"] = 2,
					["ketchup"] = 1
				}
			},
			["hamburger4"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["meatC"] = 1,
					["bread"] = 2,
					["ketchup"] = 1
				}
			},
			["hamburger5"] = {
				["amount"] = 2,
				["destroy"] = false,
				["require"] = {
					["meatS"] = 1,
					["bread"] = 2,
					["ketchup"] = 1
				}
			},
			["orangejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["orange"] = 9
				}
			},
			["tangejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["tange"] = 9
				}
			},
			["grapejuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["grape"] = 9
				}
			},
			["strawberryjuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["strawberry"] = 9
				}
			},
			["bananajuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["banana"] = 9
				}
			},
			["passionjuice"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["water"] = 1,
					["passion"] = 9
				}
			},
			["ketchup"] = {
				["amount"] = 1,
				["destroy"] = false,
				["require"] = {
					["emptybottle"] = 1,
					["tomato"] = 6
				}
			}
		}
	},
	["Laundry"] = {
		["perm"] = "laundry",
		["list"] = {
			["dollars"] = {
				["amount"] = 9000,
				["destroy"] = false,
				["require"] = {
					["alcohol"] = 25,
					["paper"] = 25,
					["dollarsz"] = 10000,
				}
			}
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPerm(craftType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"negado","Multas pendentes encontradas.",3000)
			return false
		end

		if craftList[craftType]["perm"] ~= nil then
			if not exports["common"]:Group().hasPermission(user_id,craftList[craftType]["perm"]) and not exports["common"]:Group().hasPermission(user_id,"staff") then
				return false
			end
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestCrafting(craftType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inventoryShop = {}
		for k,v in pairs(craftList[craftType]["list"]) do
			local craftList = {}
			for k,v in pairs(v["require"]) do
				table.insert(craftList,{ name = itemName(k), amount = v })
			end

			table.insert(inventoryShop,{ name = itemName(k), index = itemIndex(k), key = k, peso = itemWeight(k), list = craftList, amount = parseInt(v["amount"]), desc = itemDescription(k) })
		end

		local inventoryUser = {}
		local inventory = vRP.userInventory(user_id)
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
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

		return inventoryShop,inventoryUser,vRP.inventoryWeight(user_id),vRP.getBackpack(user_id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionCrafting(shopItem,shopType,shopAmount,slot)
	local source = source
	local free = Lock(source,5000)
	local user_id = vRP.getUserId(source)
	if user_id then
		-- local consumePendrive = ""
		if shopAmount == nil then shopAmount = 1 end
		if shopAmount <= 0 then shopAmount = 1 end

		-- if shopType == "dirtyMoneys" or shopType == "Laundry" then
		-- 	local consultItem = vRP.getInventoryItemAmount(user_id,"pendrive")
		-- 	if consultItem[1] <= 0 then
		-- 		TriggerClientEvent("Notify",source,"importante","Pendrive não encontrado.",5000)
		-- 		return
		-- 	end

		-- 	if vRP.checkBroken(consultItem[2]) then
		-- 		TriggerClientEvent("Notify",source,"negado","Pendrive quebrado.",5000)
		-- 		return
		-- 	end

		-- 	consumePendrive = consultItem[2]
		-- end

		if craftList[shopType]["list"][shopItem] then
			if vRP.checkMaxItens(user_id,shopItem,craftList[shopType]["list"][shopItem]["amount"] * shopAmount) then
				TriggerClientEvent("Notify",source,"negado","Limite atingido.",10000,"bottom")
				TriggerClientEvent("crafting:Update",source,"requestCrafting")
				return
			end

			if (vRP.inventoryWeight(user_id) + (itemWeight(shopItem) * parseInt(shopAmount))) <= vRP.getBackpack(user_id) then
				for k,v in pairs(craftList[shopType]["list"][shopItem]["require"]) do
					local consultItem = vRP.getInventoryItemAmount(user_id,k)
					if consultItem[1] < parseInt(v * shopAmount) then
						return
					end

					if vRP.checkBroken(consultItem[2]) then
						TriggerClientEvent("Notify",source,"negado","Item quebrado.",5000)
						return
					end
				end

				for k,v in pairs(craftList[shopType]["list"][shopItem]["require"]) do
					local consultItem = vRP.getInventoryItemAmount(user_id,k)
					vRP.removeInventoryItem(user_id,consultItem[2],parseInt(v * shopAmount))
				end
				
				vRP.generateItem(user_id,shopItem,craftList[shopType]["list"][shopItem]["amount"] * shopAmount,false,slot)
				
				-- if shopType == "dirtyMoneys" or shopType == "Laundry" then
				-- 	vRP.removeInventoryItem(user_id,consumePendrive,1,true)
				-- end
				
				exports["common"]:Log().embedDiscord(user_id,"commands-crafting","**ITEM:**```"..itemName(shopItem).."```\n**QUANTIDADE:**```"..parseInt(shopAmount).."```\nCraftou às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			end
		end

		TriggerClientEvent("crafting:Update",source,"requestCrafting")
	end
	free()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONDESTROY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionDestroy(shopItem,shopType,shopAmount,slot)--beta
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if shopAmount == nil then shopAmount = 1 end
        if shopAmount <= 0 then shopAmount = 1 end
        local splitName = splitString(shopItem,"-")
		local allow = false
        if craftList[shopType]["list"][splitName[1]] then
            if craftList[shopType]["list"][splitName[1]]["destroy"] then
                if vRP.checkBroken(shopItem) then
                    for k,v in pairs(craftList[shopType]["list"][splitName[1]]["require"]) do
						local rem1 =  vRP.tryGetInventoryItem(user_id,k,v)
						local rem2 =  vRP.tryGetInventoryItem(user_id,shopItem,1)
						if rem1 and rem2 then
							allow = true
						end
                    end
					if allow then
						vRP.generateItem(user_id,splitName[1],1,true)
						TriggerClientEvent("Notify",source,"negado","Itens quebrados reciclados.",5000)
					end
					TriggerClientEvent("crafting:Update",source,"requestCrafting")
                    return
                end
            end
        end

        TriggerClientEvent("crafting:Update",source,"requestCrafting")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:populateSlot")
AddEventHandler("crafting:populateSlot",function(nameItem,slot,target,amount)
	local source = source
	local free = Lock(source,5000)
	local user_id = vRP.getUserId(source)
	if user_id then
		amount = parseInt(amount) or 1
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
			vRP.giveInventoryItem(user_id,nameItem,amount,false,target)
			TriggerClientEvent("crafting:Update",source,"requestCrafting")
		end
	end
	free()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:updateSlot")
AddEventHandler("crafting:updateSlot",function(nameItem,slot,target,amount)
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

		TriggerClientEvent("crafting:Update",source,"requestCrafting")
	end
	free()
end)

local function loadCrafting()
	craftingList = {}
    local query = exports.oxmysql:query_async("SELECT * FROM crafting")
    if #query <= 0 then return end

    for k,v in pairs(query) do
        craftingList[v.id] = { json.decode(v.coords),v.name }
    end

	print("Crafting: Loaded all crafting!")
    TriggerClientEvent("crafting:client:setCrafting",-1,craftingList)
end

local function getNameCrafts()
	local tb_names = {}
    for k,v in pairs(craftList) do
		table.insert(tb_names, k)
	end
	return tb_names
end

Citizen.CreateThread(function()
	loadCrafting()
end)

AddEventHandler("vRP:playerSpawn",function(userId, source) 
    Citizen.Wait(1000) 
    TriggerClientEvent("crafting:client:setCrafting",source,craftingList) 
end)

RegisterNetEvent("admin:newCrafting", function()
    local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
            return
        end

        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)

        TriggerClientEvent("dynamic:closeSystem",source)
		
		local craftsAvaliable = getNameCrafts()
        local craftName = vRP.prompt(source,"Nome do crafting:",table.concat(craftsAvaliable,', '))
        if craftName == "" or not craftList[craftName] then return end

        local chestCoords = vRP.prompt(source,"Coords:",mathLegth(coords[1])..","..mathLegth(coords[2])..","..mathLegth(coords[3])..","..mathLegth(GetEntityHeading(ped)))
        if chestCoords == "" then return end

        local chestFormatted = "["..chestCoords.."]"

        exports.oxmysql:query("INSERT INTO `crafting` (`name`,`coords`) VALUES (@name,@coords)",{ name = craftName, coords = chestFormatted })
        TriggerClientEvent("Notify",source,"sucesso","Crafting <b>"..craftName.."</b> criado com sucesso.",10000,"bottom")
        loadCrafting()
    end
end)

local function getNearestCrafting(source)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)

	for k,v in pairs(craftingList) do
		local distance = #(coords - vec3(v[1][1],v[1][2],v[1][3]))
		if distance <= 10.5 then
			return k, v[2]
		end
	end
	return false
end

RegisterNetEvent("admin:deleteCrafting", function()
	local source = source
    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"admin") then
            return
        end

        TriggerClientEvent("dynamic:closeSystem",source)
		local craftingNear, craftName = getNearestCrafting(source)
		if craftingNear then 
			local chestExists = exports.oxmysql:query_async("SELECT `id` FROM `crafting` WHERE `id` = @id",{ id = tonumber(craftingNear) })
			if #chestExists >= 0 then
				exports.oxmysql:query("DELETE FROM `crafting` WHERE `id` = @id",{ id = tonumber(craftingNear) })
				TriggerClientEvent("Notify",source,"sucesso","Crafting <b>"..craftName.."</b> deleteado com sucesso.",10000,"bottom")
				Citizen.Wait(1000)
				loadCrafting()
			end
		end
    end
end)