local actionDelay = 0

RegisterNetEvent("squads:openMenu",function(membersList,squadInfos)
    SetNuiFocus(true,true)
    SendNUIMessage({ show = true, squadInfos = squadInfos, membersList = membersList })
end)

RegisterNUICallback("closeMenu",function(data,cb)
    SetNuiFocus(false,false)
    SendNUIMessage({ show = false })
    cb("ok")
end)

RegisterNUICallback("contractPlayer",function(data,cb)
    server.contractPlayer(data.user_id)
    cb("ok")
end)

RegisterNUICallback("demotePlayer",function(data,cb)
    server.demotePlayer(data.user_id)
    cb("ok")
end)

RegisterNUICallback("updatePlayer",function(data,cb)
    server.updatePlayer(data.user_id,data.newRank)
    cb("ok")
end)