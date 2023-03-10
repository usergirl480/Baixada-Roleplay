-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("dynamic",cRP)
vSERVER = Tunnel.getInterface("dynamic")
vCLOTHES = Tunnel.getInterface("common")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local menuOpen = false
local policeService = false
local paramedicService = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
local animalHahs = nil
local animalFollow = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:updateService")
AddEventHandler("police:updateService",function(status)
	policeService = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("paramedic:updateService")
AddEventHandler("paramedic:updateService",function(status)
	paramedicService = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddButton",function(title,description,trigger,par,id,server)
	SetNuiFocus(true,true)
	SendNUIMessage({ addbutton = true, title = title, description = description, trigger = trigger, par = par, id = id, server = server })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("SubMenu",function(title,description,menuid)
	SetNuiFocus(true,true)
	SendNUIMessage({ addmenu = true, title = title, description = description, menuid = menuid })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICKED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("clicked",function(data,cb)
	if data["server"] == "true" then
		TriggerServerEvent(data["trigger"],data["param"])
	else
		TriggerEvent(data["trigger"],data["param"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data,cb)
	SetNuiFocus(false,false)
	menuOpen = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:closeSystem")
AddEventHandler("dynamic:closeSystem",function()
	if menuOpen then
		SendNUIMessage({ close = true })
		SetNuiFocus(false,false)
		menuOpen = false
	end
end)

RegisterNetEvent("dynamic:close")
AddEventHandler("dynamic:close",function()
	SendNUIMessage({ close = true })
	SetNuiFocus(false,false)
	menuOpen = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("globalFunctions",function(source,args)
	if not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not menuOpen then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 then
			menuOpen = true

			exports["dynamic"]:AddButton("Chap??u","Colocar/Retirar o chap??u.","player:outfitFunctions","Hat","clothes",true)
			exports["dynamic"]:AddButton("M??scara","Colocar/Retirar a m??scara.","player:outfitFunctions","Mask","clothes",true)
			exports["dynamic"]:AddButton("??culos","Colocar/Retirar o ??culos.","player:outfitFunctions","Glasses","clothes",true)
			exports["dynamic"]:AddButton("Jaqueta","Colocar/Retirar a jaqueta.","player:outfitFunctions","Jacket","clothes",true)
			exports["dynamic"]:AddButton("Camiseta","Colocar/Retirar a camiseta.","player:outfitFunctions","Shirt","clothes",true)
			exports["dynamic"]:AddButton("Luvas","Colocar/Retirar as luvas.","player:outfitFunctions","Arms","clothes",true)
			exports["dynamic"]:AddButton("Cal??as","Colocar/Retirar as cal??as.","player:outfitFunctions","Pants","clothes",true)
			exports["dynamic"]:AddButton("Sapatos","Colocar/Retirar os sapatos.","player:outfitFunctions","Shoes","clothes",true)
			exports["dynamic"]:AddButton("Colete","Colocar/Retirar o colete.","player:outfitFunctions","Vest","clothes",true)

			exports["dynamic"]:AddButton("Aplicar","Vestir as roupas salvas.","player:outfitFunctions","aplicar","outfit",true)
			exports["dynamic"]:AddButton("Salvar","Guardar as roupas do corpo.","player:outfitFunctions","salvar","outfit",true)
			exports["dynamic"]:AddButton("Remover","Remover as roupas salvas.","player:outfitFunctions","remover","outfit",true)

			exports["dynamic"]:AddButton("Aplicar","Vestir as roupas salvas.","player:outfitFunctions","preaplicar","premiumfit",true)
			exports["dynamic"]:AddButton("Salvar","Guardar as roupas do corpo.","player:outfitFunctions","presalvar","premiumfit",true)

			exports["dynamic"]:AddButton("Lixeiro","Vestir uniforme de Lixeiro.","player:presetJobs","1","preJobs",true)
			exports["dynamic"]:AddButton("Transportador","Vestir uniforme de Transportador.","player:presetJobs","2","preJobs",true)
			-- exports["dynamic"]:AddButton("Eletricista","Vestir uniforme de Eletricista.","player:presetJobs","3","preJobs",true)

			-- if animalHahs ~= nil then
			-- 	exports["dynamic"]:AddButton("Seguir","Seguir o propriet??rio.","dynamic:animalFunctions","seguir","animal",false)
			-- 	exports["dynamic"]:AddButton("Colocar no Ve??culo","Colocar o animal no ve??culo.","dynamic:animalFunctions","colocar","animal",false)
			-- 	exports["dynamic"]:AddButton("Remover do Ve??culo","Remover o animal no ve??culo.","dynamic:animalFunctions","remover","animal",false)
			-- end

			-- exports["dynamic"]:AddButton("Informa????es","Todas as informa????es de sua identidade.","player:identityFunctions","","others",true)
			--exports["dynamic"]:AddButton("Desmanche","Listagem dos ve??culos.","dismantle:invokeList","","others",true)
			exports["dynamic"]:AddButton("Comercializa????o","Iniciar/Finalizar venda de drogas.","drugs:toggleService","","others",false)
			exports["dynamic"]:AddButton("Ferimentos","Verificar ferimentos no corpo.","paramedic:myInjuries","","others",false)
			exports["dynamic"]:AddButton("Chamados","Verificar lista de chamados.","hub:open","","others",false)
			exports["dynamic"]:AddButton("Reputa????o","Verifique a sua reputa????o.","reputation_modules:openRep","","others",true)

			if not IsPedInAnyVehicle(ped) then
				exports["dynamic"]:AddButton("Rebocar","Colocar ve??culo na prancha do reboque.","towdriver:invokeTow","","others",false)

				exports["dynamic"]:AddButton("Trancar","Trancar a propriedade.","homes:invokeSystem","trancar","propertys",true)
				exports["dynamic"]:AddButton("Garagem","Comprar garagem da propriedade.","homes:invokeSystem","garagem","propertys",true)
				exports["dynamic"]:AddButton("Permiss??es","Checar permiss??es da propriedade.","homes:invokeSystem","checar","propertys",true)
				exports["dynamic"]:AddButton("Taxas","Pagar as taxas da propriedade.","homes:invokeSystem","tax","propertys",true)
				exports["dynamic"]:AddButton("Arm??rio","Aumentar o arm??rio da propriedade.","homes:invokeSystem","armario","propertys",true)
				exports["dynamic"]:AddButton("Geladeira","Aumentar a geladeira da propriedade.","homes:invokeSystem","geladeira","propertys",true)
				--exports["dynamic"]:AddButton("Vender","Vender a propriedade.","homes:invokeSystem","vender","propertys",true)
				
			else
				exports["dynamic"]:AddButton("Banco Dianteiro Esquerdo","Sentar no banco do motorista.","player:seatPlayer","0","vehicle",false)
				exports["dynamic"]:AddButton("Banco Dianteiro Direito","Sentar no banco do passageiro.","player:seatPlayer","1","vehicle",false)
				exports["dynamic"]:AddButton("Banco Traseiro Esquerdo","Sentar no banco do passageiro.","player:seatPlayer","2","vehicle",false)
				exports["dynamic"]:AddButton("Banco Traseiro Direito","Sentar no banco do passageiro.","player:seatPlayer","3","vehicle",false)
				exports["dynamic"]:AddButton("Banco Ca??amba Esquerda","Sentar no banco do passageiro.","player:seatPlayer","4","vehicle",false)
				exports["dynamic"]:AddButton("Banco Ca??amba Direita","Sentar no banco do passageiro.","player:seatPlayer","5","vehicle",false)
				exports["dynamic"]:AddButton("Levantar Vidros","Levantar todos os vidros.","player:winsFunctions","1","vehicle",true)
				exports["dynamic"]:AddButton("Abaixar Vidros","Abaixar todos os vidros.","player:winsFunctions","0","vehicle",true)

				exports["dynamic"]:SubMenu("Ve??culo","Fun????es do ve??culo.","vehicle")
			end

			exports["dynamic"]:AddButton("Propriedades","Ativa/Desativa as propriedades no mapa.","homes:togglePropertys","","propertys",false)

			exports["dynamic"]:SubMenu("Uniformes","Todos os uniformes de empregos.","preJobs")

			exports["dynamic"]:SubMenu("Roupas","Colocar/Retirar roupas.","clothes")
			exports["dynamic"]:SubMenu("Vestu??rio","Mudan??a de roupas r??pidas.","outfit")
			exports["dynamic"]:SubMenu("Vestu??rio Premium","Mudan??a de roupas premium.","premiumfit")

			exports["dynamic"]:SubMenu("Propriedades","Todas as fun????es das propriedades.","propertys")

			if animalHahs ~= nil then
				exports["dynamic"]:SubMenu("Dom??sticos","Todas as fun????es dos animais dom??sticos.","animal")
			end
			
			exports["dynamic"]:SubMenu("Outros","Todas as fun????es do personagem.","others")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("adminFunctions",function(source,args)
	if vSERVER.checkPermission() and not menuOpen then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 then
			menuOpen = true
			
			exports["dynamic"]:AddButton("Vida","Ativar/Desativar.","common:admin_blips:updateConfig","Health","blips")
			exports["dynamic"]:AddButton("Armas","Ativar/Desativar.","common:admin_blips:updateConfig","Weapons","blips")
			exports["dynamic"]:AddButton("Grupos","Ativar/Desativar.","common:admin_blips:updateConfig","Groups","blips")
			exports["dynamic"]:AddButton("Linhas","Ativar/Desativar.","common:admin_blips:updateConfig","Lines","blips")
			exports["dynamic"]:AddButton("Domina????o","Ativar/Desativar.","common:admin_blips:updateConfig","SpecialMode","blips")
			exports["dynamic"]:SubMenu("Blips","Gerenciamento de blips.","blips")

			exports["dynamic"]:AddButton("Quarentena","Ativar/Desativar.","admin:quarentineSystem","","quarentine",true)
			exports["dynamic"]:AddButton("Usu??rios","Usu??rios em quarentena.","admin:quarentineList","","quarentine",true)
			exports["dynamic"]:AddButton("Status","Status da quarentena.","admin:quarentineStatus","","quarentine",true)
			exports["dynamic"]:AddButton("Verificar","Verificar usu??rio.","admin:quarentineCheck","","quarentine",true)
			exports["dynamic"]:AddButton("Adicionar","Adicionar usu??rio.","admin:quarentineAdd","","quarentine",true)
			exports["dynamic"]:AddButton("Remover","Remover usu??rio.","admin:quarentineRemove","","quarentine",true)
			exports["dynamic"]:SubMenu("Quarentena","Gerenciamento de quarentena.","quarentine")
			
			exports["dynamic"]:AddButton("Adicionar","Adicionar reputa????o em squad.","reputation:Add","","reputation",true)
			exports["dynamic"]:AddButton("Remover","Remover reputa????o de squad.","reputation:Remove","","reputation",true)
			exports["dynamic"]:AddButton("Resetar","Resetar reputa????o de squad.","reputation:Reset","","reputation",true)
			exports["dynamic"]:SubMenu("Reputa????o","Gerenciamento de reputa????o.","reputation")
			
			-- exports["dynamic"]:AddButton("Alterar","Alterar passaporte.","admin:changeID","","users",true)
			-- exports["dynamic"]:AddButton("Resetar","Resetar passaporte.","admin:resetID","","users",true)
			exports["dynamic"]:AddButton("Renomear","Renomear usu??rio.","admin:renameUsers","","users",true)
			exports["dynamic"]:AddButton("Steam","Alterar steam.","admin:steamUsers","","users",true)
			exports["dynamic"]:AddButton("Discord","Alterar discord.","admin:discordUsers","","users",true)
			exports["dynamic"]:AddButton("Mochila","Adicionar mochila.","admin:setBackpack","","users",true)
			exports["dynamic"]:AddButton("Serial","Consultar serial.","admin:consultSerial","","users",true)
			exports["dynamic"]:SubMenu("Usu??rio","Gerenciamento de usu??rios.","users")

			exports["dynamic"]:AddButton("Adicionar","Adicionar ve??culos.","admin:addCars","","cars",true)
			exports["dynamic"]:AddButton("Remover","Remover ve??culos.","admin:removeCars","","cars",true)
			exports["dynamic"]:AddButton("Verificar","Verificar ve??culos.","admin:checkCars","","cars",true)
			exports["dynamic"]:SubMenu("Ve??culo","Gerenciamento de ve??culos.","cars")

			exports["dynamic"]:AddButton("Adicionar","Adicionar cryptos ao usu??rio.","admin:addCryptos","","cryptos",true)
			exports["dynamic"]:AddButton("Remover","Remover cryptos do usu??rio.","admin:removeCryptos","","cryptos",true)
			exports["dynamic"]:AddButton("Verificar","Verificar cryptos do usu??rio.","admin:checkCryptos","","cryptos",true)
			exports["dynamic"]:SubMenu("Crypto","Gerenciamento de cryptos.","cryptos")

			exports["dynamic"]:AddButton("Adicionar","Adicionar usu??rio no squad.","squads:userSquad","","squad",true)
			exports["dynamic"]:AddButton("Criar","Criar squad.","squads:createSquad","","squad",true)
			exports["dynamic"]:AddButton("Deletar","Deletar squad.","squads:deleteSquad","","squad",true)
			exports["dynamic"]:AddButton("Entrar","Entrar no squad.","squads:joinSquad","","squad",true)
			exports["dynamic"]:AddButton("Sair","Sair do squad.","squads:exitSquad","","squad",true)
			exports["dynamic"]:AddButton("Membros","Verificar membros de um squad.","squads:memberSquad","","squad",true)
			exports["dynamic"]:AddButton("Online","Verificar squads online.","squads:squadService","","squad",true)
			exports["dynamic"]:AddButton("Lista","Listar todos squads.","squads:listSquad","","squad",true)
			exports["dynamic"]:AddButton("Atualizar","Atualizar todos squads.","squads:refreshSquad","","squad",true)
			exports["dynamic"]:SubMenu("Squad","Gerenciamento de squads.","squad")
	
			exports["dynamic"]:AddButton("Adicionar","Adicionar VIP.","admin:setPlayerVips","","vip",true)
			exports["dynamic"]:AddButton("Produtos","Adicionar produtos.","admin:setBuyers","","vip",true)
			exports["dynamic"]:AddButton("Consultar","Consultar VIP.","admin:checkVips","","vip",true)
			exports["dynamic"]:AddButton("Consultar","Consultar Produtos.","admin:checkBuyers","","vip",true)
			exports["dynamic"]:AddButton("Garagem","Adicionar benef??cio.","admin:setGaragesVips","","vip",true)
			exports["dynamic"]:AddButton("Carro","Adicionar benef??cio.","admin:setCarVips","","vip",true)
			exports["dynamic"]:AddButton("Casa","Adicionar benef??cio.","admin:setHouseVips","","vip",true)
			exports["dynamic"]:SubMenu("VIP","Gerenciamento de VIPs.","vip")

			exports["dynamic"]:AddButton("Criar","Criar craft.","admin:newCrafting","","crafting",true)
			exports["dynamic"]:AddButton("Deletar","Deletar craft.","admin:deleteCrafting","","crafting",true)
			exports["dynamic"]:SubMenu("Crafting","Gerenciamento de craft.","crafting")

			exports["dynamic"]:AddButton("Criar","Criar ba??.","admin:newChest","","chest",true)
			exports["dynamic"]:AddButton("Deletar","Deletar ba??.","admin:deleteChest","","chest",true)
			exports["dynamic"]:AddButton("Resetar","Resetar ba??.","admin:resetChest","","chest",true)
			exports["dynamic"]:AddButton("Listar","Listar ba??.","admin:listChest","","chest",true)
			exports["dynamic"]:SubMenu("Ba??","Gerenciamento de ba??.","chest")

		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("emergencyFunctions",function(source,args)
	if policeService or paramedicService then
		if not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not menuOpen then

			local ped = PlayerPedId()
			if GetEntityHealth(ped) > 101 then
				menuOpen = true

				exports["dynamic"]:AddButton("Servi??o","Verificar companheiros em servi??o.","player:servicoFunctions","","utilitys",true)

				if not IsPedInAnyVehicle(ped) then
					exports["dynamic"]:AddButton("Carregar pelos Bra??os","Carregar a pessoa mais pr??xima.","player:carryFunctions","bracos","player",true)
					exports["dynamic"]:AddButton("Carregar nos Ombros","Carregar a pessoa mais pr??xima.","player:carryFunctions","ombros","player",true)

					exports["dynamic"]:SubMenu("Jogador","Pessoa mais pr??xima de voc??.","player")
				end

				if policeService then
					exports["dynamic"]:AddButton("Computador","Abrir o dispositivo m??vel.","police:openSystem","","utilitys",false)
					exports["dynamic"]:AddButton("Barreira","Colocar barreira na frente.","police:insertBarrier","","utilitys",false)
					exports["dynamic"]:AddButton("Invadir","Invadir a resid??ncia.","homes:invadeSystem","","utilitys",true)

					exports["dynamic"]:AddButton("Remover Chap??u","Remover da pessoa mais pr??xima.","skinshop:removeProps","hat","player",true)
					exports["dynamic"]:AddButton("Remover M??scara","Remover da pessoa mais pr??xima.","skinshop:removeProps","mask","player",true)
					exports["dynamic"]:AddButton("Defusar","Desativar bomba do ve??culo.","races:defuseBomb","","player",true)

					exports["dynamic"]:AddButton("Policia","Fardamento de manga longa.","player:presetFunctions","1","prePolice",true)
					exports["dynamic"]:AddButton("Policia","Fardamento de manga curta.","player:presetFunctions","2","prePolice",true)

					exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos policiais.","prePolice")
					exports["dynamic"]:SubMenu("Utilidades","Todas as fun????es dos policiais.","utilitys")
				elseif paramedicService then
					exports["dynamic"]:AddButton("Medical Center","Fardamento de doutor.","player:presetFunctions","3","preMedic",true)
					exports["dynamic"]:AddButton("Medical Center","Fardamento de param??dico.","player:presetFunctions","4","preMedic",true)
					exports["dynamic"]:AddButton("Medical Center","Fardamento de param??dico interno.","player:presetFunctions","5","preMedic",true)

					exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos m??dicos.","preMedic")
					exports["dynamic"]:SubMenu("Utilidades","Todas as fun????es dos param??dicos.","utilitys")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("globalFunctions","Abrir menu principal.","keyboard","F9")
RegisterKeyMapping("adminFunctions","Abrir menu de admin.","keyboard","Insert")
RegisterKeyMapping("emergencyFunctions","Abrir menu de emerg??ncia.","keyboard","F10")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:animalSpawn")
AddEventHandler("dynamic:animalSpawn",function(model)
	if animalHahs == nil then
		local ped = PlayerPedId()
		local mHash = GetHashKey(model)

		RequestModel(mHash)
		while not HasModelLoaded(mHash) do
			Citizen.Wait(1)
		end

		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,1.0,0.0)
		animalHahs = CreatePed(28,mHash,coords["x"],coords["y"],coords["z"] - 1,GetEntityHeading(ped),0,1)

		SetPedCanRagdoll(animalHahs,false)
		SetEntityInvincible(animalHahs,true)
		SetPedFleeAttributes(animalHahs,0,0)
		SetBlockingOfNonTemporaryEvents(animalHahs,true)
		SetPedRelationshipGroupHash(animalHahs,GetHashKey("k9"))
		GiveWeaponToPed(animalHahs,GetHashKey("WEAPON_ANIMAL"),200,true,true)

		NetworkRegisterEntityAsNetworked(animalHahs)
		while not NetworkGetEntityIsNetworked(animalHahs) do
			NetworkRegisterEntityAsNetworked(animalHahs)
			Citizen.Wait(1)
		end

		TriggerEvent("dynamic:animalFunctions","seguir")

		vSERVER.animalRegister(NetworkGetNetworkIdFromEntity(animalHahs))
	else
		vSERVER.animalCleaner()
		animalFollow = false
		animalHahs = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:ANIMALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:animalFunctions")
AddEventHandler("dynamic:animalFunctions",function(functions)
	if animalHahs ~= nil then
		local ped = PlayerPedId()

		if functions == "seguir" then
			if not animalFollow then
				TaskFollowToOffsetOfEntity(animalHahs,ped,1.0,1.0,0.0,5.0,-1,2.5,1)
				SetPedKeepTask(animalHahs,true)
				animalFollow = true
			else
				SetPedKeepTask(animalHahs,false)
				ClearPedTasks(animalHahs)
				animalFollow = false
			end
		elseif functions == "colocar" then
			if IsPedInAnyVehicle(ped) and not IsPedOnAnyBike(ped) then
				local vehicle = GetVehiclePedIsUsing(ped)
				if IsVehicleSeatFree(vehicle,0) then
					TaskEnterVehicle(animalHahs,vehicle,-1,0,2.0,16,0)
				end
			end
		elseif functions == "remover" then
			if IsPedInAnyVehicle(ped) and not IsPedOnAnyBike(ped) then
				TaskLeaveVehicle(animalHahs,GetVehiclePedIsUsing(ped),256)
				TriggerEvent("dynamic:animalFunctions","seguir")
			end
		elseif functions == "deletar" then
			vSERVER.animalCleaner()
			animalFollow = false
			animalHahs = nil
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNIFORMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("squad-uniformes",function(source,args)
    if not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not menuOpen then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 then
			local permitted,leader,squadName = vCLOTHES.requestSquad()
			if permitted and leader then
				menuOpen = true
				exports["dynamic"]:SubMenu("Uniformes","Todas os uniformes do seu squad.","uniforms")
				exports["dynamic"]:AddButton("Remover","Remover a roupa.","uniforms:applyPreset","remove","uniforms",true)
				exports["dynamic"]:SubMenu("Op????es","Gerenciamento de uniformes.","optionsUniforms")
				exports["dynamic"]:AddButton("Adicionar","Adicione o uniforme que est?? em seu corpo.","uniforms:applyPreset","apply","optionsUniforms",true)
				exports["dynamic"]:AddButton("Deletar","Delete algum uniforme existente.","uniforms:applyPreset","delete","optionsUniforms",true)
			elseif permitted then
				menuOpen = true
				exports["dynamic"]:SubMenu("Uniformes","Todas os uniformes do seu squad.","uniforms")
					exports["dynamic"]:AddButton("Remover","Remover a roupa.","uniforms:applyPreset","remove","uniforms",true)
				end
				
				local myUniforms = vCLOTHES.requestUniforms(squadName)
				if myUniforms then 
					menuOpen = true
					for _,x in pairs(myUniforms) do 
					exports["dynamic"]:AddButton(x.name,"Roupa para utilizar em servi??o.","uniforms:applyPreset",x.name,"uniforms",true)
				end
			end
		end
    end
end)