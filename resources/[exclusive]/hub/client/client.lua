RegisterNetEvent("hub:open",function()
    TriggerEvent("dynamic:closeSystem")
    Citizen.Wait(250)
    SetNuiFocus(true,true)
    SendNUIMessage({ action = "open" })
end)

RegisterNUICallback("close",function(data,cb)
    SetNuiFocus(false,false)
    cb("ok")
end)

RegisterNUICallback("tryAcceptRequest",function(data,cb)
    if data.id then
        server.tryAcceptRequest(data.id)
    end

    cb({ })
end)

RegisterNetEvent("hub:sendNotification", function(type, title, description, persistent)
    SendNUIMessage({ action = "addNotification", type = type, title = title, description = description, persistent = persistent })
end)

RegisterNetEvent("hub:sendRequest", function(type, title, description, id)
    SendNUIMessage({ action = "addRequest", type = type, title = title, description = description, id = id })
end)

RegisterNetEvent("hub:setAcceptedRequest", function(requestId, userId)
    SendNUIMessage({ action = "setAcceptedRequest", id = requestId, user_id = userId })
end)