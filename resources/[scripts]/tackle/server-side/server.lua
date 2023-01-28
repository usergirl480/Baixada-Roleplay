-----------------------------------------------------------------------------------------------------------------------------------------
-- TACKLE:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tackle:Update")
AddEventHandler("tackle:Update",function(sourcePlayer)
	TriggerClientEvent("tackle:Player",sourcePlayer)
end)