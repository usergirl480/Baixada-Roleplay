-- local objectsList = {}
-- local gangsStatements = {}
-- local insiderCustomer = false
-- local npcPed = nil
-- local pedCoords = vec4(489.1,-785.97,25.02,274.97)
-- local randomCoords = { 
--     [1] = { ped = vec4(247.22,-1204.28,29.28,269.3), target = vec4(247.53,-1204.27,29.28,85.04) },
--     [2] = { ped = vec4(48.8,-1042.9,29.49,158.75), target = vec4(48.66,-1043.35,29.5,340.16) }
-- }

-- local function createModels(identifier,coords,object)
--     local hash = GetHashKey(object)
--     RequestModel(hash)
-- 	while not HasModelLoaded(hash) do
-- 		Citizen.Wait(1)
-- 	end

-- 	objectsList[identifier] = CreateObjectNoOffset(hash,coords[1],coords[2],coords[3],false,false,false)
-- 	PlaceObjectOnGroundProperly(objectsList[identifier])
-- 	FreezeEntityPosition(objectsList[identifier],true)
-- 	SetEntityHeading(objectsList[identifier],coords[4]-180)
-- 	SetModelAsNoLongerNeeded(hash)
-- 	SetEntityLodDist(objectsList[identifier],0xFFFF)
-- end

-- RegisterNetEvent("squads:gangs:loadStatements",function(statements)
--     gangsStatements = statements
--     for name,values in pairs(gangsStatements) do
--         for k,v in pairs(values) do
--             if k == "chest" or k == "machine" then
--                 createModels(k.."-"..name,v.coords,v.object)
--             end
--         end
--         Citizen.Wait(10)
--     end
-- end)

-- AddEventHandler("onResourceStop",function()
--     for k,v in pairs(objectsList) do
--         if DoesEntityExist(objectsList[k]) then
--             DeleteEntity(objectsList[k])
--         end
--     end
-- end)

-- RegisterNetEvent("gangs:insiderCustomer",function()
--     insiderCustomer = true
--     Citizen.CreateThread(function()
--         while insiderCustomer do
--             Citizen.Wait(900*1000) -- 15m
--             server.requestUpdate("cops")
--         end
--     end)

--     Citizen.CreateThread(function()
--         while insiderCustomer do
--             Citizen.Wait(3600*1000) -- 1h
--             server.requestUpdate("boost")
--         end
--     end)

--     Citizen.CreateThread(function()
--         while insiderCustomer do
--             Citizen.Wait(1800*1000) -- 30m
--             server.requestUpdate("locations")
--         end
--     end)
-- end)

-- local function updateTarget()
--     exports["target"]:AddCircleZone("gangs:insider",vector3(pedCoords["x"],pedCoords["y"],pedCoords["z"]),0.75,{
--         name = "gangs:insider",
--         heading = pedCoords["w"]
--     },{
--         distance = 1.0,
--         options = {
--             {
--                 event = "gangs:talkInsider",
--                 label = "Conversar",
--                 tunnel = "server"
--             }
--         }
--     })
-- end

-- RegisterNetEvent("gangs:updatePed",function()
--     local configPed = randomCoords[math.random(#randomCoords)]
--     if configPed then 
-- 		local _,cdz = GetGroundZFor_3dCoord(configPed.ped.x,configPed.ped.y,configPed.ped.z)
--         SetEntityCoords(npcPed,configPed.ped.x,configPed.ped.y,cdz)
--         SetEntityHeading(npcPed,configPed.ped.w)
--         pedCoords = vec4(configPed.target.x,configPed.target.y,configPed.target.z,configPed.target.w)
--         updateTarget()
--     end
-- end)

-- Citizen.CreateThread(function()
--     Citizen.Wait(1000)
--     updateTarget()
    
--     local mHash = GetHashKey("ig_ramp_gang")
--     RequestModel(mHash)
--     while not HasModelLoaded(mHash) do
--         Citizen.Wait(1)
--     end
    
--     if HasModelLoaded(mHash) then
--         npcPed = CreatePed(4,0xE52E126C,489.09,-785.85,25.02 - 1,274.97,false,true)
--         SetPedArmour(npcPed,100)
--         SetEntityInvincible(npcPed,true)
--         FreezeEntityPosition(npcPed,true)
--         SetBlockingOfNonTemporaryEvents(npcPed,true)
        
--         SetModelAsNoLongerNeeded(mHash)
        
--         RequestAnimDict("anim@heists@heist_corona@single_team")
--         while not HasAnimDictLoaded("anim@heists@heist_corona@single_team") do
--             Citizen.Wait(1)
--         end
        
--         TaskPlayAnim(npcPed,"anim@heists@heist_corona@single_team","single_team_loop_boss",8.0,0.0,-1,1,0,0,0,0)
--     end
-- end)

-- -- RegisterCommand("wrench",function(source,args,rawCommand)
-- --     TriggerEvent("gangs:updatePed")
-- -- end)