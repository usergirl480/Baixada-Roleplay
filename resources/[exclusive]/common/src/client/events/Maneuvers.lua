local started = false

RegisterCommand("manobras", function()
    started = not started 

    if started then
        TriggerEvent("Notify","sucesso","Você ativou as manobras",10000,"bottom")
        Citizen.CreateThread(function()
            while started do
                local timeIdle = 999
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(ped)
                local speed = GetEntitySpeed(vehicle) * 3.6 
                if IsPedOnAnyBike(ped) then
                    if speed >= 30 then
                        timeIdle = 5
        
                        while not HasAnimDictLoaded("rcmextreme2atv") do
                            Citizen.Wait(0)
                            RequestAnimDict("rcmextreme2atv")
                        end
        
                        if IsControlJustPressed(0,174) or IsControlJustPressed(0,108) then -- Seta esquerda ou numpad 4
                            TaskPlayAnim(ped, "rcmextreme2atv", "idle_b", 8.0, -8.0, -1, 32, 0, false, false, false)
                        elseif IsControlJustPressed(0,175) or IsControlJustPressed(0,107) then
                            TaskPlayAnim(ped, "rcmextreme2atv", "idle_c", 8.0, -8.0, -1, 32, 0, false, false, false)
                        elseif IsControlJustPressed(0,173) or IsControlJustPressed(0,110) then
                            TaskPlayAnim(ped, "rcmextreme2atv", "idle_d", 8.0, -8.0, -1, 32, 0, false, false, false)
                        elseif IsControlJustPressed(0,27) or IsControlJustPressed(0,111) then
                            TaskPlayAnim(ped, "rcmextreme2atv", "idle_e", 8.0, -8.0, -1, 32, 0, false, false, false)
                        end
                    end
                end
        
                Citizen.Wait(timeIdle)
            end
        end)
    else
        TriggerEvent("Notify","sucesso","Você desativou as manobras",10000,"bottom")
    end
end)