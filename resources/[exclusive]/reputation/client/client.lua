local nui = false 

RegisterNetEvent("reputation_modules:showUI",function(reputation,squadRep)
    if not nui then 
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'open', rep = reputation, squad = squadRep })
        nui = true 
    end
end)

RegisterNUICallback("closeReputation", function(data,cb)
    SetNuiFocus(false)
    nui = false 
end)