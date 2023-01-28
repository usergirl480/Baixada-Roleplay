local config = {}
local blips = {}
local coords = nil
local crate = nil
local parachute = nil
local pickingAirDrop = false
local particleId = 0

function gridChunk(x)
	return math.floor((x + 8192) / 128)
end

function toChannel(v)
	return (v["x"] << 8) | v["y"]
end

function getGridzone(x,y)
	local gridChunk = vector2(gridChunk(x),gridChunk(y))
	return toChannel(gridChunk)
end

local function requestParticle(dict)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Citizen.Wait(50)
    end
    UseParticleFxAssetNextCall(dict);
end

local function drawParticle(x, y, z, particleDict, particleName)
    requestParticle(particleDict)
    particleId = StartParticleFxLoopedAtCoord(particleName, x, y, z, 0.0, 0.0, 0.0, 2.0, false, false, false, false);
end

local function createAirSupplyBlip(index, delete, x, y, z, sprite, colour, scale, text)
    if not delete then
        blips[index] = AddBlipForCoord(x, y, z)
        SetBlipSprite(blips[index],sprite)
        SetBlipColour(blips[index],colour)
        SetBlipScale(blips[index],scale)
        SetBlipAsShortRange(blips[index],true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(text)
        EndTextCommandSetBlipName(blips[index])
    else
        if DoesBlipExist(blips[index]) then
            RemoveBlip(blips[index])
        end
        blips[index] = nil
    end
end

RegisterNetEvent("common:airsupply:client:stop",function()
    if DoesEntityExist(crate) then
        DeleteEntity(crate)
    end

    if DoesEntityExist(parachute) then
        DeleteEntity(parachute)
    end

    coords = nil
    crate = nil
    parachute = nil

    createAirSupplyBlip("airSupplyArea", true)
    createAirSupplyBlip("airSupplyCenterFalling", true)
    createAirSupplyBlip("airSupplyCenterOnFloor", true)
end)

RegisterNetEvent("common:container:client:stop",function()
    if DoesEntityExist(crate) then
        DeleteEntity(crate)
    end

    if DoesEntityExist(parachute) then
        DeleteEntity(parachute)
    end

    coords = nil
    crate = nil
    parachute = nil

    createAirSupplyBlip("airContainerCenterOnFloor", true)
    createAirSupplyBlip("airContainerCenterFalling", true)
end)

RegisterNetEvent("common:airsupply:client:start",function(_coords)
    TriggerEvent("Notify","sucesso","Um <b>Air Supply</b> foi lançado, a localização está em seu mapa.",30000)
    
    local crateObj = GetHashKey("ex_prop_adv_case_sm_03")
    local parachuteObj = GetHashKey("p_parachute1_mp_dec")
    local sky = _coords.z + 550
    local floor = _coords.z - 1.0

    crate = CreateObject(crateObj, _coords.x, _coords.y, sky, false, true, false)
    SetEntityAsMissionEntity(crate,true,true)

    parachute = CreateObject(parachuteObj, _coords.x, _coords.y, sky, false, true, false)
    FreezeEntityPosition(crate, true)
    FreezeEntityPosition(parachute, true)
    AttachEntityToEntity(parachute, crate, 0, 0.0, 0.0, 3.4, 0.0, 0.0, 0.0, false, false, false, true, 2, true)

    blips["airSupplyArea"] = AddBlipForRadius(_coords.x, _coords.y, _coords.z, 200.0)
    SetBlipColour(blips["airSupplyArea"], 47)
    SetBlipAlpha(blips["airSupplyArea"], 70)

    createAirSupplyBlip("airSupplyCenterFalling", false, _coords.x, _coords.y, _coords.z, 94, 5, 1.0, "~w~Air Supply")
    drawParticle(_coords.x, _coords.y, _coords.z-1.0, "core", "exp_grd_flare")

    local lastTick = GetGameTimer()
    local startTick = GetGameTimer()
    while sky > floor do
        local currentTick = GetGameTimer()
        local delta = (currentTick - lastTick) / 1000 * 6.6

        sky = sky - delta
        SetEntityCoords(crate, _coords.x, _coords.y, sky)

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local _, _, pedZ = table.unpack(pedCoords)

        if #(pedCoords - vector3(_coords.x, _coords.y, sky)) <= 1.7 then
            SetEntityHealth(ped, 101)
        end

        if sky - floor <= 1 then
            if parachute then
                DeleteEntity(parachute)
            end

            createAirSupplyBlip("airSupplyCenterFalling", true)
            createAirSupplyBlip("airSupplyCenterOnFloor", false, _coords.x, _coords.y, _coords.z, 478, 5, 1.0, "~w~Air Supply")
            StopParticleFxLooped(particleId, false)
            SetEntityCoords(crate,_coords.x,_coords.y,floor)
            PlaceObjectOnGroundProperly(crate)

            local _,cdz = GetGroundZFor_3dCoord(_coords.x, _coords.y, _coords.z)
            local gridZone = getGridzone(_coords.x, _coords.y)

            server.supplyCrate(_coords.x,_coords.y,cdz,gridZone,"airSupply")
            coords = _coords
            break
        end

        lastTick = currentTick
        Citizen.Wait(15)
    end
end)


RegisterNetEvent("common:cointainer:client:start",function(_coords)
    TriggerEvent("Notify","sucesso","Um <b>container</b> foi lançado, a localização está em seu mapa.",30000)
    
    local crateObj = GetHashKey("prop_container_01a")
    local sky = _coords.z
    local floor = _coords.z 

    crate = CreateObject(crateObj, _coords.x, _coords.y, sky, false, true, false)
    SetEntityAsMissionEntity(crate,true,true)

    blips["Container"] = AddBlipForRadius(_coords.x, _coords.y, _coords.z, 200.0)
    SetBlipColour(blips["Container"], 47)
    SetBlipAlpha(blips["Container"], 70)

    createAirSupplyBlip("airContainerCenterFalling", false, _coords.x, _coords.y, _coords.z, 94, 5, 1.0, "~w~Container")
    drawParticle(_coords.x, _coords.y, _coords.z-1.0, "core", "exp_grd_flare")

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local _, _, pedZ = table.unpack(pedCoords)

    if #(pedCoords - vector3(_coords.x, _coords.y, sky)) <= 1.7 then
        SetEntityHealth(ped, 101)
    end

    createAirSupplyBlip("airContainerCenterFalling", true)
    createAirSupplyBlip("airContainerCenterOnFloor", false, _coords.x, _coords.y, _coords.z, 478, 5, 1.0, "~~w~Container")
    StopParticleFxLooped(particleId, false)
    SetEntityCoords(crate,_coords.x,_coords.y,floor)
    PlaceObjectOnGroundProperly(crate)

    local _,cdz = GetGroundZFor_3dCoord(_coords.x, _coords.y, _coords.z)
    local gridZone = getGridzone(_coords.x, _coords.y)

    coords = _coords
   
    Citizen.CreateThread(function()
        LocalPlayer.state:set("nearContainer", false, true)
        while true do
            local ply = PlayerPedId()
            coordsPly = GetEntityCoords(ply)
            local distance = #(coordsPly - vec3(coords.x,coords.y,coords.z))
            if distance <= 10 or DoesObjectOfTypeExistAtCoords(coordsPly,5,GetHashKey("prop_container_01a"),true) then 
                LocalPlayer.state:set("nearContainer", true, true)
            else
                LocalPlayer.state:set("nearContainer", false, true)
            end

            Citizen.Wait(500)
        end
    end)
    
end)

local TimerToExplode = 0
RegisterNetEvent("common:container:client:explode",function()
    if DoesEntityExist(crate) then
        TimerToExplode = 5
        Citizen.CreateThread(function()
            while true do
                if TimerToExplode > 0 then
                    TimerToExplode = TimerToExplode - 1

                    if TimerToExplode <= 0 then
                        local _,cdz = GetGroundZFor_3dCoord(coords.x,coords.y,coords.z)

                        AddExplosion(coords.x,coords.y,coords.z,"EXPLOSION_TANKER",2.0,true,false,2.0)
                        ApplyForceToEntity(crate,0,coords.x,coords.y,coords.z,0.0,0.0,0.0,1,false,true,true,true,true)

                        local gridZone = getGridzone(coords.x, coords.y)
                        server.supplyCrate(coords.x,coords.y,cdz,gridZone,"Container")
                        Citizen.Wait(800)
                        if DoesEntityExist(crate) then
                            DeleteEntity(crate)
                        end
                    end
                end

                Citizen.Wait(1000)
            end
        end)
    end
end)

