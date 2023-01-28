RegisterNetEvent("wanted:client:updateWanted",function(time)
    SendNUIMessage({ timer = time })
end)