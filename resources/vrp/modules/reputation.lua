local reputationList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getReputation(user_id)
    local user_id = parseInt(user_id)
    return reputationList[user_id] and reputationList[user_id] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.insertReputation(user_id,reputation,amount)
	local user_id = parseInt(user_id)

	if reputationList[user_id][reputation] == nil then
		reputationList[user_id][reputation] = 0
	end

	if reputationList[user_id][reputation] < 1000 then 
		reputationList[user_id][reputation] = reputationList[user_id][reputation] + amount
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.checkReputation(user_id,reputation)
	local user_id = parseInt(user_id)

	if reputationList[user_id][reputation] == nil then
		reputationList[user_id][reputation] = 0
	end

	return parseInt(reputationList[user_id][reputation])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.removeReputation(user_id,reputation,amount)
    local user_id = parseInt(user_id)

    if reputationList[user_id][reputation] then
        if amount > reputationList[user_id][reputation] then
            reputationList[user_id][reputation] = 0
            return
        end

        reputationList[user_id][reputation] = reputationList[user_id][reputation] - amount
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.resetReputation(user_id,reputation)
    local user_id = parseInt(user_id)

    if reputationList[user_id] and reputationList[user_id][reputation] then
        reputationList[user_id][reputation] = nil
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET SQUAD REP
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.squadReputation(squad)
	if reputationList[squad] then 
		return reputationList[squad]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET REPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setSquadReputation(squad,amount)
	if reputationList[squad] and reputationList[squad] < 1000 then 
		reputationList[squad] = reputationList[squad] + amount 
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET REPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.reduceSquadReputation(squad,amount)
	if reputationList[squad] then 
		reputationList[squad] = reputationList[squad] - amount 
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET REPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.resetSquadReputation(squad)
	if reputationList[squad] then 
		reputationList[squad] = 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	reputationList[user_id] = vRP.userData(user_id,"Reputation")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if reputationList[user_id] then
		vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Reputation", value = json.encode(reputationList[user_id]) })
		reputationList[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNC SQUAD REPS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	local squads = exports.oxmysql:query_async("SELECT * FROM squads")
	for k,v in pairs(squads) do 
		if not reputationList[v.squad] then 
			reputationList[v.squad] = v.reputation 
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVER DOWN SYNC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("reputation:saveSquads",function()
	local squads = exports.oxmysql:query_async("SELECT * FROM squads")
	for k,v in pairs(squads) do 
		if reputationList[v.squad] then 
			exports.oxmysql:query("UPDATE squads SET reputation = @reputation WHERE squad = @squad",{ squad = v.squad, reputation = reputationList[v.squad] })
		end
	end
end)
