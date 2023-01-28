local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
local webhookadmin = ""

RegisterCommand('anuncio',function(source,args,rawCommand)
    local userId = vRP.getUserId(source)
    local identity = vRP.userIdentity(userId)
	if exports["common"]:Group().hasAccessOrHigher(userId,"ceo") then
        local mensagem = vRP.prompt(source,"Mensagem:","")
        if mensagem == "" then
            return
        end
        TriggerClientEvent("Notify",-1,"default",mensagem,60000,"center","anúncio")
    end
end)