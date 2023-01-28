local userList = {}
local weaponsList = {
    [-1569615261] = "Desarmado",
    [-1716189206] = "Faca",
    [1737195953] = "Cassetete",
    [1317494643] = "Martelo",
    [-1786099057] = "Bastão",
    [-2067956739] = "Pé de cabra",
    [1141786504] = "Taco de Golf",
    [-102323637] = "Garrafa",
    [-1834847097] = "Adaga",
    [-102973651] = "Machado",
    [-656458692] = "Soco Inglês",
    [-581044007] = "Machete",
    [-1951375401] = "Lanterna",
    [-538741184] = "Canivete",
    [-1810795771] = "Taco de Sinuca",
    [419712736] = "Chave Inglêsa",
    [-853065399] = "Machado de Batalha",

    [453432689] = "Pistol",
    [-1075685676] = "Five-Seven",
    [1593441988] = "Combat Pistol",
    [-1716589765] = "Pistol 50",
    [-1076751822] = "SNS Pistol",
    [-771403250] = "Heavy Pistol",
    [137902532] = "Vintage Pistol",
    [-598887786] = "Marksman Pistol",
    [-1045183535] = "Revolver",
    [584646201] = "AP Pistol",
    [911657153] = "Taser",
    [1198879012] = "Sinalizador",

    [324215364] = "Micro SMG",
    [-619010992] = "Machine Pistol",
    [736523883] = "SMG",
    [2024373456] = "SMG MK2",
    [270015777] = "MTAR",
    [171789620] = "Sig Sauer",
    [-1660422300] = "MG",
    [2144741730] =  "CombatMG",
    [3686625920] = "CombatMG MK2",
    [1627465347] = "Thompson",
    [-1121678507] = "Mini SMG",

    [-1074790547] = "Assault Rifle",
    [961495388] = "Assault Rifle MK2",
    [-2084633992] = "Carbine Rifle",
    [-86904375] = "Carbine Rifle MK2",
    [-1357824103] = "Advanced Rifle",
    [-1063057011] = "Special Carbine",
    [-1768145561] = "Special Carbine MK2",
    [2132975508] = "Bullpup Rifle",
    [1649403952] = "Compact Rifle",

    [100416529] = "Sniper Rifle",
    [205991906] = "Heavy Sniper",
    [177293209] = "Heavy Sniper MK2",
    [-952879014] = "Marksman Rifle",

    [487013001] = "Pump Shotgun",
    [2017895192] = "Sawnoff Shotgun",
    [-1654528753] = "Bullpup Shotgun",
    [-494615257] = "Assault Shotgun",
    [-1466123874] = "Musket",
    [984333226] = "Heavy Shotgun",
    [-275439685] = "Double Barrel Shotgun",
    [317205821] = "Auto Shotgun",

    [-1568386805] = "Grenade Launcher",
    [-1312131151] = "RPG",
    [1119849093] = "Minigun",
    [2138347493] = "FireWork",
    [1834241177] = "RailGun",
    [1672152130] = "Homing Launcher",
    [1305664598] = "Grenade Launcher Smoke",
    [125959754] = "Compact Launcher",

    [-1813897027] = "Grenade",
    [741814745] = "Sticky Bomb",
    [-1420407917] = "ProximityMine",
    [-1600701090] = "BZGas",
    [615608432] = "Molotov",
    [101631238] = "Extintor",
    [883325847] = "Petrolcan",
    [1233104067] = "Flare",
    [600439132] = "Bola",
    [126349499] = "Bola de Neve",
    [-37975472] = "Smoke Grenade",
    [-1169823560] = "Pipe bomb"
}
local adminMode = false
local blipsStatus = {}

RegisterNetEvent("common:admin_blips:updateList",function(list)
    userList = list
end)

local function drawAdmin(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextFont(4)
        SetTextProportional(1)
        SetTextScale(0.3, 0.3)
        SetTextColour(255,255,255,255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 150)
        SetTextDropshadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local config = {
    Health = true,
    Groups = true,
    Lines = true,
    Weapons = true,
    ID = true,
    Name = true,
    SpecialMode = false,
}

RegisterNetEvent("common:admin_blips:updateConfig",function(index)
    if index == "SpecialMode" then 
        if not config.SpecialMode then 
            config = {
                Name = false,
                Groups = false,
                Health = false,
                Lines = false,
                Weapons = false,
                ID = false,
                SpecialMode = true,
            }
        else
            config = {
                Health = true,
                Groups = true,
                Lines = true,
                Weapons = true,
                ID = true,
                Name = true,
                SpecialMode = false,
            }
        end
        
        return
    end
    if config[index] ~= nil then
        config[index] = not config[index] 
    end
end)

local function startThread(params)
    if params then
        if blipsStatus[params] then
            blipsStatus[params] = nil
        else
            blipsStatus[params] = true
        end
    end

    Citizen.CreateThread(function()
        while adminMode do
            local timeIdle = 999
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            for k,v in pairs(GetActivePlayers()) do
                local targetSource = GetPlayerServerId(v)
                local targetPed = GetPlayerPed(v)
                local targetCoords = GetEntityCoords(targetPed)
                if targetPed and userList[targetSource] then
                    if #(coords - targetCoords) <= 300 and not userList[targetSource].hidden then
                        timeIdle = 0
                        local weapon = weaponsList[GetSelectedPedWeapon(targetPed)]

                        local drawStr = ""
                        
                        if userList[targetSource].timePlayed < 86400 and not config.SpecialMode then
                            drawStr = drawStr.."\n~r~ATENÇÃO~w~"
                            DrawLine(coords.x,coords.y,coords.z,targetCoords.x,targetCoords.y,targetCoords.z,189,25,23,200)
                        end
                        
                        if userList[targetSource].blipsEnabled then
                            drawStr = (not config.SpecialMode and drawStr.."\n"..userList[targetSource].surname.." (~g~#"..userList[targetSource].userId.." "..userList[targetSource].name.."~w~) ~r~[BLIPS ON]~w~" or drawStr.."\n~g~["..userList[targetSource].group.."] ~w~"..userList[targetSource].name.."")
                        else
                            drawStr = (not config.SpecialMode and drawStr.."\n"..userList[targetSource].surname.." (~g~#"..userList[targetSource].userId.." "..userList[targetSource].name.."~w~)" or drawStr.."\n~g~["..userList[targetSource].group.."] ~w~"..userList[targetSource].name.."")
                        end
                        
                        drawStr = (config.Health and (drawStr.."\nVida: ~g~"..(GetEntityHealth(targetPed)-100).."%~w~") or drawStr)
                        
                        if weapon and weapon ~= "Desarmado" then
                            drawStr = (config.Weapons and (drawStr.."\n"..weapon) or drawStr)
                        end
                        
                        drawStr = (config.Groups and (drawStr.."\n"..userList[targetSource].group) or drawStr)
                        if config.Lines then 
                            color1,color2,color3 = 227,160,27
                            if not IsEntityVisible(targetPed) then color1,color2,color3 = 168,24,17 end
                            DrawLine(coords.x, coords.y, coords.z, targetCoords.x, targetCoords.y, targetCoords.z, color1,color2,color3, 255)
                        end
                        drawAdmin(targetCoords.x, targetCoords.y, targetCoords.z+1.10,drawStr)
                    end
                end
            end

            Citizen.Wait(timeIdle)
        end
    end)
end

function client.toggleAdmin(params)
    if params then
        startThread(params)
        return
    end

    if adminMode then
        adminMode = false
        return false
    else
        adminMode = true
        if params then
            startThread(params)
        else
            startThread()
        end
        return true
    end
end