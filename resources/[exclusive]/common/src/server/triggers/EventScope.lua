local Scope = {}

local Players = {}

CreateThread(function()
	while true do
	for _,v in ipairs(GetPlayers()) do 
		Players[v] = GetEntityCoords(GetPlayerPed(v)) 
	end
	Wait(10000)
	end
end)

AddEventHandler("playerDropped",function(source) 
    if not source then 
        return 
    end 
    Players[source] = nil 
end)

function Scope.TriggerScopeEvent(source,distanceTarget,...)
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    local eventParams = {...}
    local eventName = eventParams[1]
    table.remove(eventParams,1)
    for target,coords in pairs(Players) do 
        local distance = #(coords - srcCoords)
        if distance < distanceTarget then 
            TriggerClientEvent(eventName,target,table.unpack(eventParams))
        end
    end
end
-- @source = src, @number = distance
--exports["common"]:Scope().TriggerScopeEvent(source, 40, "tebaClient", params)
exports("Scope",function() return Scope end)