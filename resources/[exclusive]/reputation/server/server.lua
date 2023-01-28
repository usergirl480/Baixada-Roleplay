local function getReputation(userId)
    if userId then 
        local reputation = vRP.getReputation(userId)
        local squadName = exports["common"]:Group().getSquad(userId)
        if reputation == false then
			return TriggerClientEvent("Notify",vRP.getUserSource(parseInt(userId)),"negado","Você não possui reputação.")
        end

        TriggerClientEvent("reputation_modules:showUI",vRP.getUserSource(parseInt(userId)),reputation,(squadName or nil))
    end
end

RegisterCommand("+rep",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if userId then 
        getReputation(userId)
    end
end)

RegisterServerEvent("reputation_modules:openRep",function()
    local source = source 
    local userId = vRP.getUserId(source)
    if userId then 
        TriggerClientEvent("dynamic:close",source)
        getReputation(userId)
    end
end)