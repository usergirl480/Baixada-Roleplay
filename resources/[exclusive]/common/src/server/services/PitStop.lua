local requestRepair = {}

function server.vehicleRepair()
	local source = source
	local userId = vRP.getUserId(source)
	if userId then
        
        local vehicle,vehNet,vehPlate,vehName,vehLock,vehBlock = vRPC.vehList(source,4)
        if vehicle then

            if not exports["common"]:Group().hasPermission(userId,"police") then
                return TriggerClientEvent("Notify",source,"negado","Você não é um membro da <b>Polícia</b>.",10000,"bottom")
            end

            if requestRepair[userId] then
                if GetGameTimer() < requestRepair[userId] then
                    local repairTime = parseInt((requestRepair[userId] - GetGameTimer()) / 1000)
                    TriggerClientEvent("Notify",source,"negado","Aguarde <b>"..repairTime.." segundos</b>.",5000)
                    return
                end
            end

            if vRP.request(source,"Você deseja reparar o veículo?",30) then
                if vRP.paymentFull(userId,750) then
                    TriggerClientEvent("inventory:repairVehicle",-1,vehNet,vehPlate)
                    exports["common"]:Scope().TriggerScopeEvent(source,40,"inventory:repairTyre",vehNet,0,vehPlate)
                    exports["common"]:Scope().TriggerScopeEvent(source,40,"inventory:repairTyre",vehNet,1,vehPlate)
                    exports["common"]:Scope().TriggerScopeEvent(source,40,"inventory:repairTyre",vehNet,4,vehPlate)
                    exports["common"]:Scope().TriggerScopeEvent(source,40,"inventory:repairTyre",vehNet,5,vehPlate)
                    TriggerClientEvent("Notify",source,"sucesso","Viatura reparada.")
                    requestRepair[userId] = GetGameTimer() + 120000
                else
                    TriggerClientEvent("Notify",source,"negado","Você precisa de <b>$750</b>.")
                end
            end

            if vRP.request(source,"Você deseja reparar os freios do veículo?",30) then
                local vehicle,vehNet,playerAround = vRPC.vehAround(source)
                if vehicle then
                    if vRP.paymentFull(userId,500) then
                        TriggerEvent("engine:applyBrakes","graphite01",vehNet,100,playerAround)
                        TriggerEvent("engine:applyBrakes","graphite02",vehNet,100,playerAround)
                        TriggerEvent("engine:applyBrakes","graphite03",vehNet,100,playerAround)
                        TriggerClientEvent("Notify",source,"sucesso","Freios reparados.")
                    else
                        TriggerClientEvent("Notify",source,"negado","Você precisa de <b>$500</b>.")
                    end
                end
            end
        end
	end
end