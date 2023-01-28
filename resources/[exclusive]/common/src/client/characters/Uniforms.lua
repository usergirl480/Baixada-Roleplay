local uniformsCoords = {
    ["Police"] = { -780.52,-1211.19,10.38,136.07 },
    ["Paramedic"] = { 1149.18,-1586.75,35.28,175.75 }
}

local function DrawText3D(x,y,z,text)
	SetTextFont(4)
	SetTextCentre(1)
	SetTextEntry("STRING")
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z,0)
	DrawText(0.0,0.0)
	local factor = (string.len(text) / 450) + 0.01
	DrawRect(0.0,0.0125,factor,0.03,40,36,52,240)
	ClearDrawOrigin()
end

function client.getNearestBlip()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    for k,v in pairs(uniformsCoords) do
        local distance = #(coords - vec3(v[1],v[2],v[3]))
        if distance <= 1.5 then
            return k
        end
    end
    return nil
end

Citizen.CreateThread(function()
    while true do
        local timeIdle = 999
        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped) then
            local coords = GetEntityCoords(ped)
            for k,v in pairs(uniformsCoords) do
                local distance = #(coords - vec3(v[1],v[2],v[3]))
                if distance <= 1.5 then
                    timeIdle = 4
                    DrawText3D(v[1],v[2],v[3],"~p~E~w~   ABRIR")
                    if IsControlJustPressed(0,38) then
                        local permitted,leader = server.requestPerm(k)
                        if permitted and leader then
                            exports["dynamic"]:SubMenu("Uniformes","Todas os uniformes de sua corporação.","uniforms")
                            exports["dynamic"]:AddButton("Remover","Remover a roupa de serviço.","uniforms:applyPreset","remove","uniforms",true)

                            exports["dynamic"]:SubMenu("Opções","Gerenciamento de uniformes líder.","optionsUniforms")
                            exports["dynamic"]:AddButton("Adicionar","Adicione o uniforme que está em seu corpo.","uniforms:applyPreset","apply","optionsUniforms",true)
                            exports["dynamic"]:AddButton("Deletar","Delete algum uniforme existente.","uniforms:applyPreset","delete","optionsUniforms",true)
                        elseif permitted then
                            exports["dynamic"]:SubMenu("Uniformes","Todas os uniformes de sua corporação.","uniforms")
                            exports["dynamic"]:AddButton("Remover","Remover a roupa de serviço.","uniforms:applyPreset","remove","uniforms",true)
                        end

                        local myUniforms = server.requestUniforms(k)
                        if myUniforms then 
                            for _,x in pairs(myUniforms) do 
                                exports["dynamic"]:AddButton(x.name,"Roupa para utilizar em serviço.","uniforms:applyPreset",x.name,"uniforms",true)
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(timeIdle)
    end
end)