local characterCamera = nil

local scene = {
    ped = nil,
    camera = nil,
    camera2 = nil,
}
local animList = {
    ["female"] = {
        { "anim@deathmatch_intros@1hmale","intro_male_1h_d_michael", true },
    },
    ["male"] = {
        { "anim@deathmatch_intros@1hmale","intro_male_1h_d_michael", true },
    }
}
local spawnLocations = {
    { "Garagem",-276.26,-923.22,31.21,"SQUARE" },
	{ "Hospital",-496.66,-336.52,34.49,"HOSPITAL" },
	{ "Policia",-388.77,1105.44,325.79,"POLICE" },
}

local function createPed(hashKey,clothes,barber)
    if DoesEntityExist(scene.ped) then
        DeleteEntity(scene.ped)
        scene.ped = nil
    end

    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end

    local _,z = GetGroundZFor_3dCoord(207.86,-767.32,47.08)
    scene.ped = CreatePed(27, hashKey,207.86,-767.32,z)
    SetEntityHeading(scene.ped,206.93)
    
    ClearPedTasks(scene.ped)
    DecorSetBool(scene.ped, 'ScriptedPed', true)
    SetPedKeepTask(scene.ped, false)
    TaskSetBlockingOfNonTemporaryEvents(scene.ped, false)
    ClearPedTasks(scene.ped)
    FreezeEntityPosition(scene.ped,true)
    SetEntityInvincible(scene.ped,true)
    setBarbershop(scene.ped,barber)
    setClothing(scene.ped,clothes)

    if GetEntityModel(scene.ped) == `mp_f_freemode_01` then
        local randomAnim = math.random(#animList["female"])
        vRP.playAnim(false,{ animList["female"][randomAnim][1], animList["female"][randomAnim][2] },animList["female"][randomAnim][3],scene.ped)
    else
        local randomAnim = math.random(#animList["male"])
        vRP.playAnim(false,{ animList["male"][randomAnim][1], animList["male"][randomAnim][2] },animList["male"][randomAnim][3],scene.ped)
    end
    GiveWeaponToPed(scene.ped,GetHashKey("WEAPON_PISTOL_MK2"),-1,true)
    SetCurrentPedWeapon(scene.ped, "WEAPON_PISTOL_MK2", true)
end

RegisterNetEvent("characters:previewCharacter",function(hash,clothes,barber)
    createPed(hash,clothes,barber)
end)

local function startScene()
    local ped = PlayerPedId()

    SetEntityCoords(PlayerPedId(),207.86,-767.32,47.08) -- lugar onde o ped arrombado precisa ficar
    -- scene.camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -698.36,-573.99,234.97, 0.00, 0.0, -335.0, 35.0, true, 2)  -- camera inicio
    scene.camera2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 209.75,-771.5,47.06, 0.0, 0.0, 25.0, 30.0, true, 2) -- camera final
    RenderScriptCams(1, 1, 0, 0, 0)
    Wait(0)
    -- SetFocusPosAndVel(GetCamCoord(scene.camera), 0.0, 0.0, 0.0)
    SetCamActiveWithInterp(scene.camera2, 5000, 1, 1)
    Wait(0)
    SetFocusPosAndVel(GetCamCoord(scene.camera2), 0.0, 0.0, 0.0)
end

RegisterNetEvent("spawn:generateJoin",function() 
    local ped = PlayerPedId()
  --  TriggerServerEvent("Queue:playerConnect")

    --- Camera propreties
    startScene()

	SetEntityVisible(ped,false,false)
	FreezeEntityPosition(ped,true)
	SetEntityInvincible(ped,true)
	SetEntityHealth(ped,101)
	ShutdownLoadingScreen()
	SetNuiFocus(true,true)
    SendNUIMessage({ action = "openSystem", params = spawnLocations  })
end)

RegisterNUICallback("generateDisplay",function(data,cb)
    local params,timePlayed,chars,maxChars = server.initSystem()
    cb({ params = params, timePlayed = timePlayed, chars = chars, max_chars = maxChars })
end)


RegisterNUICallback("createCharacter",function(data,cb)
    local decoded = data.result
    local check_name = checkName(decoded.name,decoded.name2,decoded.surname)
    if check_name then 
        cb({ sucess = true })
        server.newCharacter(decoded.name,decoded.name2,decoded.surname,decoded.gender)
    else
        TriggerEvent("Notify","negado","Insira um nome diferente.")
    end
end)

RegisterNUICallback("characterSelected",function(data,cb)
    local userLogin = server.getLogin(data.id) 
    SendNUIMessage({ action = "updateLocates", params = userLogin and "{}" or spawnLocations })
    server.previewCharacter(data.id)
    cb("ok")
end)

RegisterNUICallback("spawnCharacter",function(data,cb)
    server.spawnCharacter(data.userId,data.choice)
    cb("ok")
end)

RegisterNetEvent("characters:justSpawn",function(spawn)
    if DoesEntityExist(scene.ped) then
        DeleteEntity(scene.ped)
        scene.ped = nil
    end

    if spawn then
        DoScreenFadeOut(0)
        local ped = PlayerPedId()
        FreezeEntityPosition(ped,false,false)

        --- Camera propreties
        RenderScriptCams(false,false,0,true,true)
        SetCamActive(characterCamera,false)
        DestroyCam(characterCamera,true)
        characterCamera = nil
    
        SetEntityVisible(ped,true,false)
        TriggerEvent("hudActived",true)
        SetEntityCoordsNoOffset(PlayerPedId(),spawnLocations[spawn][2],spawnLocations[spawn][3],spawnLocations[spawn][4],true,true,true)
        SetNuiFocus(false,false)
    
        Citizen.Wait(1000)
    
        DoScreenFadeIn(1000)
    else
        DoScreenFadeOut(0)
        local ped = PlayerPedId()
        FreezeEntityPosition(ped,false,false)
        RenderScriptCams(false,false,0,true,true)
        SetCamActive(characterCamera,false)
        DestroyCam(characterCamera,true)
        characterCamera = nil
    
        SetEntityVisible(ped,true,false)
        TriggerEvent("hudActived",true)
        SetNuiFocus(false,false)
    
        Citizen.Wait(1000)
    
        DoScreenFadeIn(1000)
    end
end)

RegisterNUICallback("deletePed",function(data,cb)
    if DoesEntityExist(scene.ped) then
        DeleteEntity(scene.ped)
        scene.ped = nil
    end
    cb("ok")
end)

RegisterNUICallback("createSimplePed",function(data,cb)
    if DoesEntityExist(scene.ped) then
        DeleteEntity(scene.ped)
        scene.ped = nil
    end

    --createPed(GetHashKey(data.sex),nil,{})
    cb("ok")
end)

AddEventHandler("onClientResourceStart",function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end

	local mHash = GetHashKey("mp_m_freemode_01")

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Citizen.Wait(1)
	end

	if HasModelLoaded(mHash) then
		SetPlayerModel(PlayerId(),mHash)
		SetModelAsNoLongerNeeded(mHash)
		FreezeEntityPosition(PlayerPedId(),false)
	end

	TriggerEvent("spawn:generateJoin")
	TriggerServerEvent("Queue:playerConnect")

	ShutdownLoadingScreen()
end)

function checkName(name,name2,surname)
    for k,v in pairs({"paul", "kush", "wrench"}) do
        if name == v  or name2 == v or surname == v then 
            return false
        end
    end
    return true
end
