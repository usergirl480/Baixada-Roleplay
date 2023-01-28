Economy = {}
local controlMoneyTable = {}
local controlItemTable = {}
local maxMoneyTimers = GetGameTimer()
local maxItemTimers = GetGameTimer()

local maxMoneyTable = {
    ["taxi"] = 600,
    ["dismantle"] = 900,
    ["drugs"] = 15000,
    ["trucker"] = 6000,
}

local maxItemTable = {
    ["plasticbottle"] = 20,
    ["glassbottle"] = 20,
    ["elastic"] = 20,
    ["metalcan"] = 20,
    ["battery"] = 20,
    ["fabric"] = 20,
}

function Economy.jobAdd(userId,serviceName,amount)
    if not controlMoneyTable[userId] then
        controlMoneyTable[userId] = {}
    end

    if not controlMoneyTable[userId][serviceName] or os.time() > controlMoneyTable[userId][serviceName].end_at then
        controlMoneyTable[userId][serviceName] = { amount = 0, started_at = os.time(), end_at = os.time() + 1 }
    end

    if not maxMoneyTable[serviceName] then
        return print("[^3WARNING^7] Não foi possível encontrar um cadastro de "..serviceName.." no controle de empregos.")
    end

    local newAmount = controlMoneyTable[userId][serviceName].amount + amount
    if newAmount >= maxMoneyTable[serviceName] then
        exports["common"]:Log().embedDiscord(userId,"controle-empregos","**ATIVIDADE SUSPEITA**\nEste usuário recebeu mais dinheiro do que o permitido.\n\nServiço: "..serviceName.."\nRecebido agora: $"..amount.."\nTotal recebido: $"..newAmount.."/$"..maxMoneyTable[serviceName].." (máximo)\nInicio da verificação: "..os.date("%d/%m/%y %H:%M:%S", controlMoneyTable[userId][serviceName].started_at).."\nData da verificação: "..os.date("%d/%m/%y %H:%M:%S", os.time()).."\nData de reset dos valores de verificação: "..os.date("%d/%m/%y %H:%M:%S", controlMoneyTable[userId][serviceName].end_at),8686827)
        vRP.tryGetInventoryItem(userId,"dollars",amount,true)
        vRP.kick(userId,"Seu acesso a comunidade foi revogado permanentemente por suspeita de trapaça.")
		exports["common"]:Ban().intelligence(userId,10,0)

        if GetGameTimer() >= maxMoneyTimers then 
            local staffAlert = exports["common"]:Group().getAllByPermission("staff")
            for k,v in pairs(staffAlert) do
                async(function()
                    TriggerClientEvent("hub:sendNotification",v,"warning","<b>ANTICHEAT</b>","O usuário <b>"..userId.."</b> foi banido por <b>[SPAWN DE DINHEIRO]</b>.",true)
                end)
            end
            maxMoneyTimers = GetGameTimer() + 10000
        end

    end

    controlMoneyTable[userId][serviceName]["amount"] = newAmount
end

function Economy.itemAdd(userId,itemName,amount)
    if not controlItemTable[userId] then
        controlItemTable[userId] = {}
    end

    if not controlItemTable[userId][itemName] or os.time() > controlItemTable[userId][itemName].end_at then
        controlItemTable[userId][itemName] = { amount = 0, started_at = os.time(), end_at = os.time() + 1 }
    end

    if not maxItemTable[itemName] then
        return print("[^3WARNING^7] Não foi possível encontrar um cadastro de "..itemName.." no controle de itens.")
    end
    
    if not controlItemTable[userId][itemName].amount then return end
    if not amount then return end
    
    local newAmount = controlItemTable[userId][itemName].amount + amount
    if newAmount >= maxItemTable[itemName] then
        exports["common"]:Log().embedDiscord(userId,"controle-empregos2","**ATIVIDADE SUSPEITA**\nEste usuário recebeu mais itens do que o permitido.\n\nItem: "..itemName.."\nRecebido agora: "..amount.."\nTotal recebido: "..newAmount.."/"..maxItemTable[itemName].." (máximo)\nInicio da verificação: "..os.date("%d/%m/%y %H:%M:%S", controlItemTable[userId][itemName].started_at).."\nData da verificação: "..os.date("%d/%m/%y %H:%M:%S", os.time()).."\nData de reset dos valores de verificação: "..os.date("%d/%m/%y %H:%M:%S", controlItemTable[userId][itemName].end_at),8686827)
        vRP.kick(userId,"Seu acesso a comunidade foi revogado permanentemente por suspeita de trapaça.")
		exports["common"]:Ban().intelligence(userId,10,0)

        if GetGameTimer() >= maxItemTimers then 
            local staffAlert = exports["common"]:Group().getAllByPermission("staff")
            for k,v in pairs(staffAlert) do
                async(function()
                    TriggerClientEvent("hub:sendNotification",v,"warning","<b>ANTICHEAT</b>","O usuário <b>"..userId.."</b> foi banido por <b>[SPAWN DE DINHEIRO]</b>.",true)
                end)
            end
            maxItemTimers = GetGameTimer() + 10000
        end

    end

    controlItemTable[userId][itemName]["amount"] = newAmount
end

exports("Economy",function()
    return Economy
end)