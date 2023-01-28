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
Tunnel.bindInterface("skinshop",cRP)
vSERVER = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local cam = -1
local skinData = {}
local previousSkinData = {}
local oldClothes = {}
local customCamLocation = nil
local creatingCharacter = false
local priceClothes = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINDATA
-----------------------------------------------------------------------------------------------------------------------------------------
local skinData = {
	["pants"] = { item = 0, texture = 0 },
	["arms"] = { item = 0, texture = 0 },
	["tshirt"] = { item = 1, texture = 0 },
	["torso"] = { item = 0, texture = 0 },
	["vest"] = { item = 0, texture = 0 },
	["backpack"] = { item = 0, texture = 0 },
	["shoes"] = { item = 1, texture = 0 },
	["mask"] = { item = 0, texture = 0 },
	["hat"] = { item = -1, texture = 0 },
	["glass"] = { item = 0, texture = 0 },
	["ear"] = { item = -1, texture = 0 },
	["watch"] = { item = -1, texture = 0 },
	["bracelet"] = { item = -1, texture = 0 },
	["accessory"] = { item = 0, texture = 0 },
	["decals"] = { item = 0, texture = 0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
local loaded = false
RegisterNetEvent("skinshop:apply")
AddEventHandler("skinshop:apply",function(status)
	if status["pants"] ~= nil then
		skinData = status
	end

	resetClothing(skinData)
	vSERVER.updateClothes(json.encode(skinData))
	
	Wait(3000)
	if not loaded and skinData then 
		resetClothing(skinData)
		loaded = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("updateRoupas")
AddEventHandler("updateRoupas",function(custom, updating)
	skinData = custom
	resetClothing(custom)
	if not updating then 
		vSERVER.updateClothes(json.encode(custom))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETATTOO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:updateTattoo")
AddEventHandler("skinshop:updateTattoo",function()
	resetClothing(skinData)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATESHOPS
-----------------------------------------------------------------------------------------------------------------------------------------
local locateShops = {
    { 75.40,-1392.92,29.37 }, --, squadVip = true
    { -709.40,-153.66,37.41 },
    { -163.20,-302.03,39.73 },
    { 425.58,-806.23,29.49 },
    { -822.34,-1073.49,11.32 },
    { -1193.81,-768.49,17.31 },
    { -1450.85,-238.15,49.81 },
    { 4.90,6512.47,31.87 },
    { 1693.95,4822.67,42.06 },
    { 126.05,-223.10,54.55 },
    { 614.26,2761.91,42.08 },
    { 1196.74,2710.21,38.22 },
    { -3170.18,1044.54,20.86 },
    { -1101.46,2710.57,19.10 },
    { 105.66,-1303.04,28.8, squadVip = true },
    { 1101.26,197.48,-49.44, squadVip = true },
    { -783.5,-1215.73,10.38 },
    { -1887.25,2070.12,145.57, squadVip = true },
    { 1393.3,1163.85,114.33, squadVip = true },
    { -66.97,827.83,231.33, squadVip = true },
    { 3060.22,2993.74,92.03, squadVip = true },
    { -2589.07,1895.81,163.71 },
    { -823.76,-1236.03,7.33 },
    { -1467.69,-45.58,58.67 },
    { 3032.59,3086.43,126.37, squadVip = true },
    { 2006.18,440.95,171.41, squadVip = true },
    { 1248.18,-208.03,100.1, squadVip = true },
    { -1074.56,-1648.02,4.5, squadVip = true },
    { 449.78,-1720.57,29.34, squadVip = true },
    { 125.57,-1989.4,18.35, squadVip = true },
    { 228.6,-1760.29,28.68, squadVip = true },
    { -204.01,-1707.65,32.65, squadVip = true },
    { 1402.63,-1539.0,54.71, squadVip = true },
    { -1007.69,-1013.06,2.16, squadVip = true },
    { -448.31,1103.99,327.68 },
    { 837.1,1064.59,292.61, squadVip = true },
    { 127.01,6596.69,19.33, squadVip = true },
    { -623.69,-1617.03,33.01 },
    { 705.76,-960.71,30.4 },
    { 3060.9,3020.17,105.36, squadVip = true },
    { 1276.62,-77.12,70.13, squadVip = true },
    { 2022.94,500.31,168.06, squadVip = true },
    { 836.81,1064.79,292.61, squadVip = true },
    { 2487.12,3778.79,48.61, squadVip = true },
    { 1272.2,-1383.73,47.28, squadVip = true },
    { 19.94,3771.0,39.13, squadVip = true },
    { 2492.95,3818.88,48.51, squadVip = true },
    { -3220.49,782.93,14.09, squadVip = true },
    { 93.93,-1291.8,29.27, squadVip = true },
    { -1367.39,-614.12,30.31, squadVip = true },
    { -266.86,-732.38,125.46 },
    { -2674.32,1304.77,152.0, squadVip = true },
    { -443.3,-310.73,34.91 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local innerTable = {}
	for k,v in pairs(locateShops) do
		table.insert(innerTable,{ v[1],v[2],v[3],2,"E","Loja de Roupas","Interagir" })
	end

	TriggerEvent("hoverfy:insertTable",innerTable)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and not creatingCharacter and not LocalPlayer.state.inRoyale then
			local coords = GetEntityCoords(ped)

			for k,v in pairs(locateShops) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2 then
					timeDistance = 1

					if IsControlJustPressed(0,38) and vSERVER.checkShares() then
						if not v.squadVip or vSERVER.checkSquadVip() then
							customCamLocation = nil

							openMenu({
								{ menu = "character", label = "Roupas", selected = true },
								{ menu = "accessoires", label = "Utilidades", selected = false }
							})
						end
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:OPENSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:openShop")
AddEventHandler("skinshop:openShop",function()
	if not creatingCharacter and vSERVER.checkShares() then
		customCamLocation = nil

		openMenu({
			{ menu = "character", label = "Roupas", selected = true },
			{ menu = "accessoires", label = "Utilidades", selected = false }
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETOUTFIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("resetOutfit",function()
	resetClothing(json.decode(previousSkinData))
	skinData = json.decode(previousSkinData)
	previousSkinData = {}
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATERIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rotateRight",function()
	local ped = PlayerPedId()
	local heading = GetEntityHeading(ped)
	SetEntityHeading(ped,heading + 30)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATELEFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rotateLeft",function()
	local ped = PlayerPedId()
	local heading = GetEntityHeading(ped)
	SetEntityHeading(ped,heading - 30)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOTHINGCATEGORYS
-----------------------------------------------------------------------------------------------------------------------------------------
local clothingCategorys = {
	["arms"] = { type = "variation", id = 3 },
	["tshirt"] = { type = "variation", id = 8 },
	["torso"] = { type = "variation", id = 11 },
	["pants"] = { type = "variation", id = 4 },
	["vest"] = { type = "variation", id = 9 },
	["backpack"] = { type = "variation", id = 5 },
	["shoes"] = { type = "variation", id = 6 },
	["mask"] = { type = "mask", id = 1 },
	["hat"] = { type = "prop", id = 0 },
	["glass"] = { type = "prop", id = 1 },
	["ear"] = { type = "prop", id = 2 },
	["watch"] = { type = "prop", id = 6 },
	["bracelet"] = { type = "prop", id = 7 },
	["accessory"] = { type = "variation", id = 7 },
	["decals"] = { type = "variation", id = 10 }
}

RegisterNetEvent("changeClothes")
AddEventHandler("changeClothes",function(index,color,type_clothe)
    local ped = PlayerPedId()
    if GetEntityHealth(ped) > 101 then
        local v = clothingCategorys[type_clothe]
        if v then 
			ClearPedTasks(ped)
            if index == nil then
				if v.type == "prop" then
					SetPedPropIndex(ped,v.id,0,0,2)
				else
					SetPedComponentVariation(ped,v.id,0,0,2)
				end
				skinData[type_clothe]["texture"] = 0
				skinData[type_clothe]["item"] = 0
			else
				if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") or GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
					if v.type == "prop" then
						SetPedPropIndex(ped,v.id,parseInt(index),parseInt(color),2)
					else
						SetPedComponentVariation(ped,v.id,parseInt(index),parseInt(color),2)
					end
					skinData[type_clothe]["texture"] = parseInt(color)
					skinData[type_clothe]["item"] = parseInt(index)
				end
            end
			vSERVER.updateClothes(skinData)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETMAXVALUES
-----------------------------------------------------------------------------------------------------------------------------------------
function GetMaxValues()
	local ped = PlayerPedId()
	maxModelValues = {
		["arms"] = { type = "character", item = 0, texture = 0, id = 3 },
		["tshirt"] = { type = "character", item = 0, texture = 0, id = 8  },
		["torso"] = { type = "character", item = 0, texture = 0, id = 11 },
		["pants"] = { type = "character", item = 0, texture = 0, id = 4 },
		["shoes"] = { type = "character", item = 0, texture = 0, id = 6 },
		["vest"] = { type = "character", item = 0, texture = 0, id = 9 },
		["backpack"] = { type = "character", item = 0, texture = 0, id = 5 },
		["accessory"] = { type = "character", item = 0, texture = 0, id = 7 },
		["decals"] = { type = "character", item = 0, texture = 0, id = 10 },
		["mask"] = { type = "accessoires", item = 0, texture = 0, id = 1 },
		["hat"] = { type = "accessoires", item = 0, texture = 0, id = "p0" },
		["glass"] = { type = "accessoires", item = 0, texture = 0, id = "p1" },
		["ear"] = { type = "accessoires", item = 0, texture = 0, id = "p2"},
		["watch"] = { type = "accessoires", item = 0, texture = 0, id = "p6" },
		["bracelet"] = { type = "accessoires", item = 0, texture = 0, id = "p7" }
	}
	for k,v in pairs(clothingCategorys) do
		if v["type"] == "variation" then
			maxModelValues[k]["item"] = GetNumberOfPedDrawableVariations(ped,v["id"]) - 1
			maxModelValues[k]["texture"] = GetNumberOfPedTextureVariations(ped,v["id"],GetPedDrawableVariation(ped,v["id"])) - 1
			
			if maxModelValues[k]["texture"] <= 0 then
				maxModelValues[k]["texture"] = 0
			end
		end

		if v["type"] == "mask" then
			maxModelValues[k]["item"] = GetNumberOfPedDrawableVariations(ped,v["id"]) - 1
			maxModelValues[k]["texture"] = GetNumberOfPedTextureVariations(ped,v["id"],GetPedDrawableVariation(ped,v["id"])) - 1

			if maxModelValues[k]["texture"] <= 0 then
				maxModelValues[k]["texture"] = 0
			end
		end

		if v["type"] == "prop" then
			maxModelValues[k]["item"] = GetNumberOfPedPropDrawableVariations(ped,v["id"]) - 1
			maxModelValues[k]["texture"] = GetNumberOfPedPropTextureVariations(ped,v["id"],GetPedPropIndex(ped,v["id"])) - 1

			if maxModelValues[k]["texture"] <= 0 then
				maxModelValues[k]["texture"] = 0
			end
		end
	end

	SendNUIMessage({ action = "updateMax", maxValues = maxModelValues })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENMENU
-----------------------------------------------------------------------------------------------------------------------------------------
function openMenu(allowedMenus)
	local currentGender = ""
	creatingCharacter = true
	previousSkinData = json.encode(skinData)
	oldClothes = json.encode(skinData)
	GetMaxValues()
	priceClothes = 0
	if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then 
		currentGender = "male"
	elseif GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
		currentGender = "female"
	end

	SendNUIMessage({ action = "open", menus = allowedMenus, currentClothing = skinData, currentGender = currentGender })

	SetNuiFocus(true,true)
	SetCursorLocation(0.9,0.25)

	enableCam()

	vRP.playAnim(false,{"mp_sleep","bind_pose_180"},true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENABLECAM
-----------------------------------------------------------------------------------------------------------------------------------------
function enableCam()
	local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0,2.0,0)
	RenderScriptCams(false,false,0,1,0)
	DestroyCam(cam,false)

	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
		SetCamActive(cam,true)
		RenderScriptCams(true,false,0,true,true)
		SetCamCoord(cam,coords["x"],coords["y"],coords["z"] + 0.5)
		SetCamRot(cam,0.0,0.0,GetEntityHeading(PlayerPedId()) + 180)
	end

	if customCamLocation ~= nil then
		SetCamCoord(cam,customCamLocation["x"],customCamLocation["y"],customCamLocation["z"])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATECAM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rotateCam",function(data)
	local ped = PlayerPedId()
	local rotType = data["type"]
	local coords = GetOffsetFromEntityInWorldCoords(ped,0,2.0,0)

	if rotType == "left" then
		SetEntityHeading(ped,GetEntityHeading(ped) - 10)
		SetCamCoord(cam,coords["x"],coords["y"],coords["z"] + 0.5)
		SetCamRot(cam,0.0,0.0,GetEntityHeading(ped) + 180)
	else
		SetEntityHeading(ped,GetEntityHeading(ped) + 10)
		SetCamCoord(cam,coords["x"],coords["y"],coords["z"] + 0.5)
		SetCamRot(cam,0.0,0.0,GetEntityHeading(ped) + 180)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUPCAM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("setupCam",function(data)
	local value = data["value"]

	if value == 1 then
		local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0,0.75,0)
		SetCamCoord(cam,coords["x"],coords["y"],coords["z"] + 0.6)
	elseif value == 2 then
		local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0,1.0,0)
		SetCamCoord(cam,coords["x"],coords["y"],coords["z"] + 0.2)
	elseif value == 3 then
		local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0,1.0,0)
		SetCamCoord(cam,coords["x"],coords["y"],coords["z"] - 0.5)
	else
		local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0,2.0,0)
		SetCamCoord(cam,coords["x"],coords["y"],coords["z"] + 0.5)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSEMENU
-----------------------------------------------------------------------------------------------------------------------------------------
function closeMenu()
	SendNUIMessage({ action = "close" })
	RenderScriptCams(false,true,250,1,0)
	DestroyCam(cam,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETCLOTHING
-----------------------------------------------------------------------------------------------------------------------------------------
function resetClothing(data)
	local ped = PlayerPedId()

	if data["backpack"] == nil then
		data["backpack"] = {}
		data["backpack"]["item"] = 0
		data["backpack"]["texture"] = 0
	end

	SetPedComponentVariation(ped,4,data["pants"]["item"],data["pants"]["texture"],1)
	SetPedComponentVariation(ped,3,data["arms"]["item"],data["arms"]["texture"],1)
	SetPedComponentVariation(ped,5,data["backpack"]["item"],data["backpack"]["texture"],1)
	SetPedComponentVariation(ped,8,data["tshirt"]["item"],data["tshirt"]["texture"],1)
	SetPedComponentVariation(ped,9,data["vest"]["item"],data["vest"]["texture"],1)
	SetPedComponentVariation(ped,11,data["torso"]["item"],data["torso"]["texture"],1)
	SetPedComponentVariation(ped,6,data["shoes"]["item"],data["shoes"]["texture"],1)
	SetPedComponentVariation(ped,1,data["mask"]["item"],data["mask"]["texture"],1)
	SetPedComponentVariation(ped,10,data["decals"]["item"],data["decals"]["texture"],1)
	SetPedComponentVariation(ped,7,data["accessory"]["item"],data["accessory"]["texture"],1)

	if data["hat"]["item"] ~= -1 and data["hat"]["item"] ~= 0 then
		SetPedPropIndex(ped,0,data["hat"]["item"],data["hat"]["texture"],1)
	else
		ClearPedProp(ped,0)
	end

	if data["glass"]["item"] ~= -1 and data["glass"]["item"] ~= 0 then
		SetPedPropIndex(ped,1,data["glass"]["item"],data["glass"]["texture"],1)
	else
		ClearPedProp(ped,1)
	end

	if data["ear"]["item"] ~= -1 and data["ear"]["item"] ~= 0 then
		SetPedPropIndex(ped,2,data["ear"]["item"],data["ear"]["texture"],1)
	else
		ClearPedProp(ped,2)
	end

	if data["watch"]["item"] ~= -1 and data["watch"]["item"] ~= 0 then
		SetPedPropIndex(ped,6,data["watch"]["item"],data["watch"]["texture"],1)
	else
		ClearPedProp(ped,6)
	end

	if data["bracelet"]["item"] ~= -1 and data["bracelet"]["item"] ~= 0 then
		SetPedPropIndex(ped,7,data["bracelet"]["item"],data["bracelet"]["texture"],1)
	else
		ClearPedProp(ped,7)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data)
	RenderScriptCams(false,true,250,1,0)
	creatingCharacter = false
	SetNuiFocus(false,false)
	DestroyCam(cam,false)
	vRP.removeObjects()
	resetChart()
	if data and data.restore then 
		if type(oldClothes) == "string" then
			oldClothes = json.decode(oldClothes)
		end
		resetClothing(oldClothes)
		skinData = oldClothes
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSkin",function(data,cb)
	ChangeVariation(data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESKINONINPUT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSkinOnInput",function(data)
	ChangeVariation(data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHANGEVARIATION
-----------------------------------------------------------------------------------------------------------------------------------------
local chartPrice =  { 
	["arms"] =   {  price = 100 },
	["tshirt"] = { price = 100  },
	["torso"] =  {  price = 100 },
	["pants"] =  {  price = 100 },
	["shoes"] =  {  price = 100 },
	["vest"] =   {  price = 100 },
	["backpack"] = {  price = 100 },
	["accessory"] = {  price = 100 },
	["decals"] = {  price = 100 },
	["mask"] = {  price = 100 },
	["hat"] = {  price = 100 },
	["glass"] = {  price = 100 },
	["ear"] = { price = 100},
	["watch"] = { price = 100 },
	["bracelet"] = { price = 100 } 
}

function resetChart() 
	for k,v in pairs(chartPrice) do 
		if chartPrice[k].buyed then 
			chartPrice[k].buyed = false
		end
	end 
end

function ChangeVariation(data)
	local ped = PlayerPedId()
	local types = data["type"]
	local item = data["articleNumber"]
	local category = data["clothingType"]
	local price = data["price"]

	if type(oldClothes) == "string"	then 
		oldClothes = json.decode(oldClothes)
	end

	if not chartPrice[category].buyed then
		chartPrice[category].buyed = true
		priceClothes = priceClothes + chartPrice[category].price
	end
	
	if category == "pants" then
		if types == "item" then
			SetPedComponentVariation(ped,4,item,0,1)
			skinData["pants"]["item"] = item
		elseif types == "texture" then
			SetPedComponentVariation(ped,4,GetPedDrawableVariation(ped,4),item,1)
			skinData["pants"]["texture"] = item
		end
	elseif category == "arms" then
		if types == "item" then
			SetPedComponentVariation(ped,3,item,0,1)
			skinData["arms"]["item"] = item
		elseif types == "texture" then
			SetPedComponentVariation(ped,3,GetPedDrawableVariation(ped,3),item,1)
			skinData["arms"]["texture"] = item
		end
	elseif category == "tshirt" then
		if types == "item" then
			SetPedComponentVariation(ped,8,item,0,1)
			skinData["tshirt"]["item"] = item
		elseif types == "texture" then
			SetPedComponentVariation(ped,8,GetPedDrawableVariation(ped,8),item,1)
			skinData["tshirt"]["texture"] = item
		end
	elseif category == "vest" then
		if types == "item" then
			SetPedComponentVariation(ped,9,item,0,1)
			skinData["vest"]["item"] = item
		elseif types == "texture" then
			SetPedComponentVariation(ped,9,skinData["vest"]["item"],item,1)
			skinData["vest"]["texture"] = item
		end
	elseif category == "backpack" then
		if types == "item" then
			SetPedComponentVariation(ped,5,item,0,1)
			skinData["backpack"]["item"] = item
		elseif types == "texture" then
			SetPedComponentVariation(ped,5,skinData["backpack"]["item"],item,1)
			skinData["backpack"]["texture"] = item
		end
	elseif category == "decals" then
		if types == "item" then
			SetPedComponentVariation(ped,10,item,0,1)
			skinData["decals"]["item"] = item
		elseif types == "texture" then
			SetPedComponentVariation(ped,10,skinData["decals"]["item"],item,1)
			skinData["decals"]["texture"] = item
		end
	elseif category == "accessory" then
		if types == "item" then
			SetPedComponentVariation(ped,7,item,0,1)
			skinData["accessory"]["item"] = item
		elseif types == "texture" then
			SetPedComponentVariation(ped,7,skinData["accessory"]["item"],item,1)
			skinData["accessory"]["texture"] = item
		end
	elseif category == "torso" then
		if types == "item" then
			SetPedComponentVariation(ped,11,item,0,1)
			skinData["torso"]["item"] = item
		elseif types == "texture" then
			SetPedComponentVariation(ped,11,GetPedDrawableVariation(ped,11),item,1)
			skinData["torso"]["texture"] = item
		end
	elseif category == "shoes" then
		if types == "item" then
			SetPedComponentVariation(ped,6,item,0,1)
			skinData["shoes"]["item"] = item
		elseif types == "texture" then
			SetPedComponentVariation(ped,6,GetPedDrawableVariation(ped,6),item,1)
			skinData["shoes"]["texture"] = item
		end
	elseif category == "mask" then
		if types == "item" then
			SetPedComponentVariation(ped,1,item,0,1)
			skinData["mask"]["item"] = item
		elseif types == "texture" then
			SetPedComponentVariation(ped,1,GetPedDrawableVariation(ped,1),item,1)
			skinData["mask"]["texture"] = item
		end
	elseif category == "hat" then
		if types == "item" then
			if item ~= -1 then
				SetPedPropIndex(ped,0,item,skinData["hat"]["texture"],1)
			else
				ClearPedProp(ped,0)
			end

			skinData["hat"]["item"] = item
		elseif types == "texture" then
			SetPedPropIndex(ped,0,skinData["hat"]["item"],item,1)
			skinData["hat"]["texture"] = item
		end
	elseif category == "glass" then
		if types == "item" then
			if item ~= -1 then
				SetPedPropIndex(ped,1,item,skinData["glass"]["texture"],1)
				skinData["glass"]["item"] = item
			else
				ClearPedProp(ped,1)
			end
		elseif types == "texture" then
			SetPedPropIndex(ped,1,skinData["glass"]["item"],item,1)
			skinData["glass"]["texture"] = item
		end
	elseif category == "ear" then
		if types == "item" then
			if item ~= -1 then
				SetPedPropIndex(ped,2,item,skinData["ear"]["texture"],1)
			else
				ClearPedProp(ped,2)
			end

			skinData["ear"]["item"] = item
		elseif types == "texture" then
			SetPedPropIndex(ped,2,skinData["ear"]["item"],item,1)
			skinData["ear"]["texture"] = item
		end
	elseif category == "watch" then
		if types == "item" then
			if item ~= -1 then
				SetPedPropIndex(ped,6,item,skinData["watch"]["texture"],1)
			else
				ClearPedProp(ped,6)
			end

			skinData["watch"]["item"] = item
		elseif types == "texture" then
			SetPedPropIndex(ped,6,skinData["watch"]["item"],item,1)
			skinData["watch"]["texture"] = item
		end
	elseif category == "bracelet" then
		if types == "item" then
			if item ~= -1 then
				SetPedPropIndex(ped,7,item,skinData["bracelet"]["texture"],1)
			else
				ClearPedProp(ped,7)
			end

			skinData["bracelet"]["item"] = item
		elseif types == "texture" then
			SetPedPropIndex(ped,7,skinData["bracelet"]["item"],item,1)
			skinData["bracelet"]["texture"] = item
		end
	end

	GetMaxValues()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVECLOTHING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("saveClothing",function()
	vSERVER.updateClothes(skinData)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMASK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setMask")
AddEventHandler("skinshop:setMask",function()
	local ped = PlayerPedId()
	
	if GetPedDrawableVariation(ped,1) == skinData["mask"]["item"] then
		SetPedComponentVariation(ped,1,0,0,1)
	else
		SetPedComponentVariation(ped,1,skinData["mask"]["item"],skinData["mask"]["texture"],1)
	end
	
	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setHat")
AddEventHandler("skinshop:setHat",function()
	local ped = PlayerPedId()

	if GetPedPropIndex(ped,0) == skinData["hat"]["item"] then
		ClearPedProp(ped,0)
	else
		SetPedPropIndex(ped,0,skinData["hat"]["item"],skinData["hat"]["texture"],1)
	end

	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETGLASSES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setGlasses")
AddEventHandler("skinshop:setGlasses",function()
	local ped = PlayerPedId()

	if GetPedPropIndex(ped,1) == skinData["glass"]["item"] then
		ClearPedProp(ped,1)
	else
		SetPedPropIndex(ped,1,skinData["glass"]["item"],skinData["glass"]["texture"],1)
	end

	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETARMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setArms")
AddEventHandler("skinshop:setArms",function()
	local ped = PlayerPedId()

	if GetPedDrawableVariation(ped,3) == skinData["arms"]["item"] then
		SetPedComponentVariation(ped,3,15,0,1)
	else
		SetPedComponentVariation(ped,3,skinData["arms"]["item"],skinData["arms"]["texture"],1)
	end

	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSHOES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setShoes")
AddEventHandler("skinshop:setShoes",function()
	local ped = PlayerPedId()

	if GetPedDrawableVariation(ped,6) == skinData["shoes"]["item"] then
		SetPedComponentVariation(ped,6,34,0,1)
	else
		SetPedComponentVariation(ped,6,skinData["shoes"]["item"],skinData["shoes"]["texture"],1)
	end

	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETPANTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setPants")
AddEventHandler("skinshop:setPants",function()
	local ped = PlayerPedId()

	if GetPedDrawableVariation(ped,4) == skinData["pants"]["item"] then
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,4,14,0,1)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,4,15,0,1)
		end
	else
		SetPedComponentVariation(ped,4,skinData["pants"]["item"],skinData["pants"]["texture"],1)
	end

	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSHIRT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setShirt")
AddEventHandler("skinshop:setShirt",function()
	local ped = PlayerPedId()

	if GetPedDrawableVariation(ped,8) == skinData["tshirt"]["item"] then
		SetPedComponentVariation(ped,8,15,0,1)
		SetPedComponentVariation(ped,3,15,0,1)
	else
		SetPedComponentVariation(ped,8,skinData["tshirt"]["item"],skinData["tshirt"]["texture"],1)
	end

	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETJACKET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setJacket")
AddEventHandler("skinshop:setJacket",function()
	local ped = PlayerPedId()

	if GetPedDrawableVariation(ped,11) == skinData["torso"]["item"] then
		SetPedComponentVariation(ped,11,15,0,1)
		SetPedComponentVariation(ped,3,15,0,1)
	else
		SetPedComponentVariation(ped,11,skinData["torso"]["item"],skinData["torso"]["texture"],1)
	end

	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETVEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:setVest")
AddEventHandler("skinshop:setVest",function()
	local ped = PlayerPedId()

	if GetPedDrawableVariation(ped,9) == skinData["vest"]["item"] then
		SetPedComponentVariation(ped,9,0,0,1)
	else
		SetPedComponentVariation(ped,9,skinData["vest"]["item"],skinData["vest"]["texture"],1)
	end

	vRP.removeObjects()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLEBACKPACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:toggleBackpack")
AddEventHandler("skinshop:toggleBackpack",function(numBack)
	if skinData["backpack"]["item"] == parseInt(numBack) then
		skinData["backpack"]["item"] = 0
		skinData["backpack"]["texture"] = 0
	else
		skinData["backpack"]["texture"] = 0
		skinData["backpack"]["item"] = parseInt(numBack)
	end

	SetPedComponentVariation(PlayerPedId(),5,skinData["backpack"]["item"],skinData["backpack"]["texture"],1)

	vSERVER.updateClothes(skinData)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEBACKPACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:removeBackpack")
AddEventHandler("skinshop:removeBackpack",function(numBack)
	if skinData["backpack"]["item"] == parseInt(numBack) then
		skinData["backpack"]["item"] = 0
		skinData["backpack"]["texture"] = 0
		SetPedComponentVariation(PlayerPedId(),5,0,0,1)

		vSERVER.updateClothes(skinData)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMASK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinshop:removeMask")
AddEventHandler("skinshop:removeMask",function()
	local ped = PlayerPedId()
	SetPedComponentVariation(ped,1,0,0,1)
	vRP.removeObjects()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCUSTOMIZATION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getCustomization()
	return skinData
end

exports("getCustomization",function()
    return skinData
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOW CLOTHES USER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ppreset",function(source,args)
    local ped = PlayerPedId()
    local chapeu, jaqueta, blusa, mascara, calca, maos, acessorios, sapatos, oculos, mochila, colete = ""
    if GetEntityHealth(ped) > 101 then
        chapeu = "chapeu "..(GetPedPropIndex(ped, 0) > 0 and GetPedPropIndex(ped, 0) or "").." "..(GetPedPropTextureIndex(ped, 0) > 0 and GetPedPropTextureIndex(ped, 0) or "")
        oculos = "oculos "..(GetPedPropIndex(ped, 0) > 0 and GetPedPropIndex(ped, 0) or "").." "..(GetPedPropTextureIndex(ped, 0) > 0 and GetPedPropTextureIndex(ped, 0) or "")
        mascara = "mascara "..GetPedDrawableVariation(ped, 1).." "..GetPedTextureVariation(ped, 1)
        maos = "maos "..GetPedDrawableVariation(ped, 3).." "..GetPedTextureVariation(ped, 3)
        calca = "calca "..GetPedDrawableVariation(ped, 4).." "..GetPedTextureVariation(ped, 4)
        mochila = "mochila "..GetPedDrawableVariation(ped, 5).." "..GetPedTextureVariation(ped, 5)
        sapatos = "sapatos "..GetPedDrawableVariation(ped, 6).." "..GetPedTextureVariation(ped, 6)
        acessorios = "acessorios "..GetPedDrawableVariation(ped, 7).." "..GetPedTextureVariation(ped, 7)
        blusa = "blusa "..GetPedDrawableVariation(ped, 8).." "..GetPedTextureVariation(ped, 8)
        colete = "colete "..GetPedDrawableVariation(ped, 9).." "..GetPedTextureVariation(ped, 9)
        jaqueta = "jaqueta "..GetPedDrawableVariation(ped, 11).." "..GetPedTextureVariation(ped, 11)
		vRP.prompt("Roupas atuais: ",chapeu.."; "..mascara.."; "..jaqueta.."; "..blusa.."; "..maos.."; "..calca.."; "..sapatos.."; "..acessorios.."; "..oculos.."; "..mochila.."; "..colete)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RotatePlayer",function(data,cb)
	local ped = PlayerPedId()
	local heading = GetEntityHeading(ped)
	if data.left then
		SetEntityHeading(ped,heading + 10)
	elseif data.right then
		SetEntityHeading(ped,heading - 10)
	end 
end)