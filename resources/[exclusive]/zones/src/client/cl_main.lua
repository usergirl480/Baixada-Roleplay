local safeStatus = false

function startControl(isPointInside)
    if not isPointInside and safeStatus then
        safeStatus = false
        SendNUIMessage({ show = false })
    end

    if isPointInside and not safeStatus then
        safeStatus = true
        SendNUIMessage({ show = true, text = "<i class='fas fa-check-square ico'></i> safezone" })
        Citizen.CreateThread(function()
            while safeStatus do
                local timeIdle = 500
                local ped = PlayerPedId()
                if IsPedInAnyVehicle(ped) then
                    timeIdle = 0
                    local veh = GetVehiclePedIsUsing(ped)
                    if not IsEntityGhostedToLocalPlayer(ped) then
                        SetLocalPlayerAsGhost(true)
                        SetGhostedEntityAlpha(240)
                    end
                else
                    if IsEntityGhostedToLocalPlayer(ped) then
                        SetLocalPlayerAsGhost(false)
                    end
                end
    
                Citizen.Wait(timeIdle)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        if not safeStatus then
            if IsEntityGhostedToLocalPlayer(PlayerPedId()) then
                SetLocalPlayerAsGhost(false)
            end
        end
        Citizen.Wait(500)
    end
end)

local square = PolyZone:Create({
    vector2(158.39469909668, -1014.4967041016),
    vector2(109.21350097656, -997.29583740234),
    vector2(170.62394714355, -829.80255126953),
    vector2(281.79461669922, -870.12463378906),
    vector2(219.78315734863, -1035.1650390625)
  }, {
    name="square",
    -- debugPoly = true,
    -- debugGrid = true
})
square:onPlayerInOut(function(isPointInside, point) startControl(isPointInside) end)

local hospital_south = PolyZone:Create({
    vector2(1097.6395263672, -1447.2685546875),
    vector2(1223.0776367188, -1446.1412353516),
    vector2(1219.1394042969, -1555.2016601562),
    vector2(1185.267578125, -1590.4885253906),
    vector2(1157.7546386719, -1619.9261474609),
    vector2(1118.8326416016, -1631.5550537109),
    vector2(1112.2026367188, -1626.2113037109)
  }, {
    name="hospital_south",
    -- debugPoly = true,
    -- debugGrid = true
})
hospital_south:onPlayerInOut(function(isPointInside, point) startControl(isPointInside) end) 

RegisterCommand("bxdClose",function(source,args)
    SetNuiFocus(false,false)
    SendNUIMessage({ show = false })
end)
RegisterKeyMapping("bxdClose","Ocultar","keyboard","LMENU")