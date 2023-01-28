local fov_max = 110
local fov_min = 10
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0
local toggle_helicam = 51
local toggle_vision = 25
local toggle_rappel = 154
local toggle_spotlight = 29
local toggle_lock_on = 22
local minHeightAboveGround = 1.5

local helicam = false
local polmav_hash = GetHashKey("polmav")
local maverick_hash = GetHashKey("bmheli")
local bell_hash = GetHashKey("b412")
local fov = (fov_max + fov_min) * 0.5
local vision_state = 0
local spotlight_state = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local lPed = GetPlayerPed(-1)
        local heli = GetVehiclePedIsIn(lPed)

        if IsPlayerInPolmav() then

            if IsHeliHighEnough(heli) then
                if IsControlJustPressed(0, toggle_helicam) and not helicam then
                    TriggerEvent("hudActived",false)
                    SendNUIMessage({type = 'show'})
                    SetGameplayCamRelativeHeading(0.0)
                    SetGameplayCamRelativePitch(0.0)

                    helicam = true
                end

                if IsControlJustPressed(0, toggle_rappel) then
                    if GetPedInVehicleSeat(heli, 1) == lPed or GetPedInVehicleSeat(heli, 2) == lPed then
                        TaskRappelFromHeli(lPed, 1)
                    end
                end
            end

            if IsControlJustPressed(0, toggle_spotlight) and helicam and
                GetPedInVehicleSeat(heli, -1) == lPed then
                spotlight_state = not spotlight_state
                TriggerServerEvent("heliCam:spotlight", spotlight_state)
            end
        end

        if helicam then
            local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
            local locked_on_vehicle = nil
            Citizen.Wait(0)

            AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
            SetCamRot(cam, 0.0, 0.0, GetEntityHeading(heli))
            SetCamFov(cam, fov)
            RenderScriptCams(true, false, 0, 1, 0)

            while helicam and not IsEntityDead(lPed) and
                (GetVehiclePedIsIn(lPed) == heli) and IsHeliHighEnough(heli) do
                if IsControlJustPressed(0, toggle_helicam) then
                    TriggerEvent("hudActived",true)
                    helicam = false
                    SendNUIMessage({type = 'hide'})
                end
                if IsControlJustPressed(0, toggle_vision) then
                    if vision_state == 0 then
                        SetNightvision(true)
                        vision_state = 1
                    elseif vision_state == 1 then
                        SetNightvision(false)
                        vision_state = 0
                    end
                end

                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)

                local vehicle = nil

                if locked_on_vehicle then
                    if DoesEntityExist(locked_on_vehicle) and not IsEntityInWater(locked_on_vehicle) and GetEntityType(locked_on_vehicle) == 2 then
                        PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0,true)
                        vehicle = locked_on_vehicle
                        
                        if IsControlJustPressed(0, toggle_lock_on) or not HasEntityClearLosToEntity(heli, locked_on_vehicle, 17) then
                            locked_on_vehicle = nil
                            local rot = GetCamRot(cam, 2)
                            local fov = GetCamFov(cam)
                            local old
                            cam = cam
                            DestroyCam(old_cam, false)
                            cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                            AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
                            SetCamRot(cam, rot, 2)
                            SetCamFov(cam, fov)
                            RenderScriptCams(true, false, 0, 1, 0)
                        end
                    else
                        DestroyCam(cam, false)
                        locked_on_vehicle = nil
                        vehicle = nil
                    end
                else
                    local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
                    CheckInputRotation(cam, zoomvalue)
                    local vehicle_detected = GetEntityInView(cam)
                    if DoesEntityExist(vehicle_detected) and GetEntityType(vehicle_detected) == 2 then
                        vehicle = vehicle_detected

                        if IsControlJustPressed(0, toggle_lock_on) then
                            locked_on_vehicle = vehicle_detected
                        end
                    end
                end
                HandleZoom(cam)
                HideHUDThisFrame()
                HandleSpotlight(cam)

                local playerCoords = GetEntityCoords(lPed)
                local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z))
                local roadHashNearHeli

                local camRot = GetCamRot(cam,2)
                    
                if vehicle == nil then
                    SendNUIMessage({
                        type = "update",
                        info = {
                            zoom = fov,
                            camtype = vision_state,
                            spotlight = spotlight_state,
                            selfSpeed = GetEntitySpeed(heli),
                            selfHeading = GetEntityHeading(heli),
                            selfAlt = GetEntityHeightAboveGround(lPed),
                            selfRoadName = streetname,
                            camHDG = GetCamRot(cam, 2).z,
                            camELV = GetCamRot(cam, 2).x,
                            vehPlate = "",
                            vehSpeed = "",
                            vehRoadName = ""
                        }
                    })
                else
                    local vehicleCoords = GetEntityCoords(vehicle)
                    local vehstreetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z))
                    local vehspd = string.format("%." .. (numDecimalPlaces or 0) .. "f", GetEntitySpeed(vehicle) * 3.6) .. " KMH"

                    SendNUIMessage({
                        type = "update",
                        info = {
                            zoom = fov,
                            camtype = vision_state,
                            spotlight = spotlight_state,
                            selfSpeed = GetEntitySpeed(heli),
                            selfHeading = GetEntityHeading(heli),
                            selfAlt = GetEntityHeightAboveGround(lPed),
                            selfRoadName = streetname,
                            camHDG = GetCamRot(cam, 2).z,
                            camELV = GetCamRot(cam, 2).x,
                            vehPlate = GetVehicleNumberPlateText(vehicle),
                            vehSpeed = vehspd,
                            vehRoadName = vehstreetname
                        }
                    })
                end

                Citizen.Wait(0)
            end
            TriggerEvent("hudActived",true)
            helicam = false
            fov = (fov_max + fov_min) * 0.5
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            SetNightvision(false)
            SetSeethrough(false)
            SendNUIMessage({type = "hide"})
            vision_state = 0
            spotlight_state = false
        end
    end
end)

function IsPlayerInPolmav()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    return (IsVehicleModel(vehicle, polmav_hash) or IsVehicleModel(vehicle, bell_hash) or IsVehicleModel(vehicle, maverick_hash))
end

function IsHeliHighEnough(heli)
    return GetEntityHeightAboveGround(heli) > minHeightAboveGround
end

function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1)
    HideHudComponentThisFrame(2)
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(4)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(11)
    HideHudComponentThisFrame(12)
    HideHudComponentThisFrame(13)
    HideHudComponentThisFrame(15)
    HideHudComponentThisFrame(18)
    HideHudComponentThisFrame(19)
    HideHudComponentThisFrame(21)
end

function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomvalue + 0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end
end

function HandleZoom(cam)
    if IsControlJustPressed(0, 241) then
        fov = math.max(fov - zoomspeed, fov_min)
    end
    if IsControlJustPressed(0, 242) then
        fov = math.min(fov + zoomspeed, fov_max)
    end
    local current_fov = GetCamFov(cam)
    if math.abs(fov - current_fov) < 0.1 then
        fov = current_fov
    end
    SetCamFov(cam, current_fov + (fov - current_fov) * 0.08)
end

function GetEntityInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	local x, y, z = table.unpack(coords + (forward_vector*100.0))
    local NorthCoord = tostring(y*10000000)
    local WestCoord = tostring(x*10000000)

	local rayhandle = StartShapeTestRay(coords, coords + (forward_vector * 10000.0), 10, GetVehiclePedIsIn(GetPlayerPed(-1)),4,0,7)
	local retval, hit, endCoords, surfaceNormal , entityHit = GetShapeTestResult(rayhandle)
	local distancetoentity = GetDistanceBetweenCoords(coords, endCoords, true)
	if entityHit > 0 then
		local entitySpeed = (GetEntitySpeed(entityHit))* 2.236936
		return entityHit
	else
		return nil
	end
end

local currentPlayerId = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))

function HandleSpotlight(cam)
    if IsControlJustPressed(0, toggle_spotlight) then
        spotlight_state = not spotlight_state
    end
    if spotlight_state then
        local rotation = GetCamRot(cam, 2)
        local forward_vector = RotAnglesToVec(rotation)
        local camcoords = GetCamCoord(cam)
        DrawSpotLight(camcoords, forward_vector, 255, 255, 255, 350.0, 8.0, 8.5,
                      7.50, 75.0)
    end
end

function RotAnglesToVec(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end
