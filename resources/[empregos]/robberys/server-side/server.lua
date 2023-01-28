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
Tunnel.bindInterface("robberys",cRP)
vCLIENT = Tunnel.getInterface("robberys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYAVAILABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local robberyCooldown = {}
local robberyAvailable = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
local robberys = {
	["1"] = {
		["coords"] = { 28.24,-1339.23,29.49 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["2"] = {
		["coords"] = { 2549.35,384.98,108.61 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["3"] = {
		["coords"] = { 1159.63,-314.07,69.2},
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 20,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["4"] = {
		["coords"] = { -709.68,-904.18,19.21 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["5"] = {
		["coords"] = { -43.47,-1748.42,29.42 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180, 
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["6"] = {
		["coords"] = { 378.2,333.34,103.56 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["7"] = {
		["coords"] = { -3249.92,1004.51,12.82 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["8"] = {
		["coords"] = { 1734.88,6420.69,35.03 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["9"] = {
		["coords"] = { 546.33,2662.73,42.16 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["10"] = {
		["coords"] = { 1959.34,3748.96,32.33 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["11"] = {
		["coords"] = { 2672.87,3286.62,55.23 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["12"] = {
		["coords"] = { 1707.86,4920.45,42.06 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["13"] = {
		["coords"] = { -1829.18,798.76,138.19 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["14"] = {
		["coords"] = { -2963.11,387.39,15.05 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["15"] = {
		["coords"] = { -3048.69,588.57,7.9 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["16"] = {
		["coords"] = { -3047.86,585.62,7.9 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["17"] = {
		["coords"] = { 1169.2,2717.85,37.15 },
		["name"] = "Loja de Departamento",
		["type"] = "department",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",100000,100000 }
		}
	},
	["20"] = {
		["coords"] = { 20.8,-1104.13,29.79 },
		["name"] = "Ammunation 10/11",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",25000,25000 }
		}
	},
	["21"] = {
		["coords"] = { 812.29,-2159.67,29.62 },
		["name"] = "Ammunation 11/11",
		["type"] = "ammunation",
		["distance"] = 12.0,
		["cooldown"] = 30,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 175,
		["timer"] = 180,
		["cops"] = 6,
		["payment"] = {
			{ "dollarsz",20000,20000 }
		}
	},
	["31"] = {
		["coords"] = { -1210.409,-336.485,38.29 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["reputationName"] = "Hacker",
		["reputationType"] = "hacking",
		["reputation"] = 300,
		["item"] = "notebook",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "dollarsz",635000,635000 }
		}
	},
	["32"] = {
		["coords"] = { -353.519,-55.518,49.54 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["reputationName"] = "Hacker",
		["reputationType"] = "hacking",
		["reputation"] = 300,
		["item"] = "notebook",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "dollarsz",635000,635000 }
		}
	},
	["33"] = {
		["coords"] = { 311.525,-284.649,54.67 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["reputationName"] = "Hacker",
		["reputationType"] = "hacking",
		["reputation"] = 300,
		["item"] = "notebook",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "dollarsz",635000,635000 }
		}
	},
	["34"] = {
		["coords"] = { 147.210,-1046.292,29.87 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["reputationName"] = "Hacker",
		["reputationType"] = "hacking",
		["reputation"] = 300,
		["item"] = "notebook",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "dollarsz",635000,635000 }
		}
	},
	["35"] = {
		["coords"] = { -2956.449,482.090,16.2 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["reputationName"] = "Hacker",
		["reputationType"] = "hacking",
		["reputation"] = 300,
		["item"] = "notebook",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "dollarsz",635000,635000 }
		}
	},
	["36"] = {
		["coords"] = { 1175.66,2712.939,38.59 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["reputationName"] = "Hacker",
		["reputationType"] = "hacking",
		["reputation"] = 300,
		["item"] = "notebook",
		["timer"] = 180,
		["cops"] = 12,
		["payment"] = {
			{ "dollarsz",635000,635000 }
		}
	},
	["37"] = {
		["coords"] = { -810.15,-179.57,37.57 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["38"] = {
		["coords"] = { 134.4,-1707.81,29.28 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["39"] = {
		["coords"] = { -1284.26,-1115.11,6.99 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["40"] = {
		["coords"] = { 1930.61,3727.97,32.84 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["41"] = {
		["coords"] = { 1211.45,-470.7,66.2 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["42"] = {
		["coords"] = { -30.56,-151.83,57.07 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["43"] = {
		["coords"] = { -277.75,6230.6,31.69 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",15000,20000 }
		}
	},
	["44"] = {
		["coords"] = { -104.386,6477.150,31.83 },
		["name"] = "Saving Bank",
		["type"] = "banks",
		["distance"] = 12.0,
		["cooldown"] = 360,
		["reputationName"] = "Hacker",
		["reputationType"] = "hacking",
		["reputation"] = 750,
		["item"] = "notebook",
		["timer"] = 900,
		["cops"] = 20,
		["payment"] = {
			{ "dollarsz",800000,800000 }
		}
	},
	["45"] = {
		["coords"] = { 265.336,220.184,102.09 },
		["name"] = "Vinewood Vault",
		["type"] = "banks",
		["distance"] = 20.0,
		["cooldown"] = 360,
		["reputationName"] = "Hacker",
		["reputationType"] = "hacking",
		["reputation"] = 750,
		["item"] = "notebook",
		["timer"] = 900,
		["cops"] = 15,
		["payment"] = {
			{ "dollarsz",800000,800000 }
		}
	},
	["46"] = {
		["coords"] = { 3559.93,3675.97,28.12 },
		["name"] = "Humane Labs",
		["type"] = "banks",
		["distance"] = 20.0,
		["cooldown"] = 360,
		["reputationName"] = "Hacker",
		["reputationType"] = "hacking",
		["reputation"] = 750,
		["item"] = "notebook",
		["timer"] = 1200,
		["cops"] = 12,
		["lock"] = 6,
		["payment"] = {
			{ "dollarsz",1030000,1030000 }
		}
	},
	["47"] = {
		["coords"] = { -622.0,-230.82,38.05 },
		["name"] = "Joalheria",
		["type"] = "jewelry",
		["distance"] = 12.0,
		["cooldown"] = 180,
		["reputationName"] = "Hacker",
		["reputationType"] = "hacking",
		["reputation"] = 300,
		["item"] = "notebook",
		["timer"] = 600,
		["cops"] = 10,
		["payment"] = {
			{ "dollarsz",555000,555000  }
		}
	},
	["48"] = {
		["coords"] = { 1326.14,-1651.74,52.27 },
		["name"] = "Tatuagem 1/4",
		["type"] = "tattooshop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",20000,30000 }
		}
	},
	["49"] = {
		["coords"] = { -1150.7,-1425.49,4.95 },
		["name"] = "Tatuagem 2/4",
		["type"] = "tattooshop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",20000,30000 }
		}
	},
	["50"] = {
		["coords"] = { 320.27,183.2,103.58 },
		["name"] = "Tatuagem 3/4",
		["type"] = "tattooshop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",20000,30000 }
		}
	},
	["51"] = {
		["coords"] = { -3172.7,1073.62,20.83 },
		["name"] = "Tatuagem 4/4",
		["type"] = "tattooshop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["reputationName"] = "Ladrão",
		["reputationType"] = "thief",
		["reputation"] = 115,
		["timer"] = 180,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",20000,30000 }
		}
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkRobbery(robberyId)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id and identity then
		if robberys[robberyId] then
			local prev = robberys[robberyId]

			if vRP.userIsBaby(user_id) then
				TriggerClientEvent("Notify",source,"negado","Ação bloqueada.",5000,"bottom")
				return
			end

			if robberyCooldown[robberyId] then
				if GetGameTimer() < robberyCooldown[robberyId] then
					TriggerClientEvent("Notify",source,"negado","Este local foi assaltado recentemente.",10000,"bottom")
					return
				end
			end

			if robberyAvailable[prev["type"]] then
				if GetGameTimer() < robberyAvailable[prev["type"]] then
					TriggerClientEvent("Notify",source,"negado","Um estabelecimento desta categoria foi assaltado recentemente.",10000,"bottom")
					return
				end
			end

			local policeResult = exports["common"]:Group().getAllByPermission("police")
			if parseInt(#policeResult) < parseInt(prev["cops"]) then
				TriggerClientEvent("Notify",source,"negado","Número insuficiente de policiais.",10000,"bottom")
				return false
			end

			if prev["item"] then
				local consultItem = vRP.getInventoryItemAmount(user_id,prev["item"])
				if consultItem[1] <= 0 then
					TriggerClientEvent("Notify",source,"negado","Você precisa de <b>1x "..itemName(prev["item"]).."</b> para roubar.",5000,"bottom")
					return false
				end
				
				if vRP.checkBroken(consultItem[2]) then
					TriggerClientEvent("Notify",source,"negado","O seu <b>"..itemName(prev["item"]).."</b> está quebrado.",5000,"bottom")
					return false
				end
				vRP.tryGetInventoryItem(user_id,consultItem[2],1)
			end
			
			TriggerClientEvent("player:applyGsr",source)
			robberyCooldown[robberyId] = GetGameTimer() + (prev["cooldown"] * 60000)
			robberyAvailable[prev["type"]] = GetGameTimer() + (prev["cooldown"] * 60000)
			for k,v in pairs(policeResult) do
				async(function()
					TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = prev["name"], x = prev["coords"][1], y = prev["coords"][2], z = prev["coords"][3], time = "Recebido às "..os.date("%H:%M"), blipColor = 22 })
					vRPC.playSound(v,"Beep_Green","DLC_HEIST_HACKING_SNAKE_SOUNDS")
				end)
			end
			
			exports["common"]:Log().embedDiscord(user_id,"robberys","**ASSALTO:**```"..prev["name"].."```\nRealizado às "..os.date("%d/%m/%y %H:%M:%S"),8686827,false)
			return true

		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentRobbery(robberyId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		exports["wanted"]:setWanted(user_id,900)
		for k,v in pairs(robberys[robberyId]["payment"]) do
			local value = math.random(v[2],v[3])
			vRP.generateItem(user_id,v[1],parseInt(value),true)
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	Citizen.Wait(1000)
	vCLIENT.inputRobberys(source,robberys)
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	vCLIENT.inputRobberys(-1,robberys)
end)