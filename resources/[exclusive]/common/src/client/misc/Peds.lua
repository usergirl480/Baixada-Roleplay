local localPeds = {}

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(config.peds) do
			local distance = #(coords - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))
			if distance <= v["distance"] then
				if not IsPedInAnyVehicle(ped) then
					if localPeds[k] == nil then
						local mHash = GetHashKey(v["model"][2])

						RequestModel(mHash)
						while not HasModelLoaded(mHash) do
							Citizen.Wait(1)
						end

						if HasModelLoaded(mHash) then
							localPeds[k] = CreatePed(4,v["model"][1],v["coords"][1],v["coords"][2],v["coords"][3] - 1,v["coords"][4],false,true)
							SetPedArmour(localPeds[k],100)
							SetEntityInvincible(localPeds[k],true)
							FreezeEntityPosition(localPeds[k],true)
							SetBlockingOfNonTemporaryEvents(localPeds[k],true)

							if v["casino"] then
								if v["casino"] == "male" then
									SetPedDefaultComponentVariation(localPeds[k])
									SetPedComponentVariation(localPeds[k],0,3,0,0)
									SetPedComponentVariation(localPeds[k],1,1,0,0)
									SetPedComponentVariation(localPeds[k],2,3,0,0)
									SetPedComponentVariation(localPeds[k],3,1,0,0)
									SetPedComponentVariation(localPeds[k],4,0,0,0)
									SetPedComponentVariation(localPeds[k],6,1,0,0)
									SetPedComponentVariation(localPeds[k],7,2,0,0)
									SetPedComponentVariation(localPeds[k],8,3,0,0)
									SetPedComponentVariation(localPeds[k],10,1,0,0)
									SetPedComponentVariation(localPeds[k],11,1,0,0)
								elseif v["casino"] == "female" then
									SetPedDefaultComponentVariation(localPeds[k])
									SetPedComponentVariation(localPeds[k],0,3,0,0)
									SetPedComponentVariation(localPeds[k],1,0,0,0)
									SetPedComponentVariation(localPeds[k],2,3,0,0)
									SetPedComponentVariation(localPeds[k],3,0,1,0)
									SetPedComponentVariation(localPeds[k],4,1,0,0)
									SetPedComponentVariation(localPeds[k],6,1,0,0)
									SetPedComponentVariation(localPeds[k],7,1,0,0)
									SetPedComponentVariation(localPeds[k],8,0,0,0)
									SetPedComponentVariation(localPeds[k],10,0,0,0)
									SetPedComponentVariation(localPeds[k],11,0,0,0)
									SetPedPropIndex(localPeds[k],1,0,0,false)
								end
							end

							SetModelAsNoLongerNeeded(mHash)

							if v["anim"][1] ~= nil then
								if v["anim"][1] == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then
									TaskStartScenarioAtPosition(localPeds[k],"PROP_HUMAN_SEAT_CHAIR_MP_PLAYER",v["coords"][1],v["coords"][2],v["coords"][3],v["coords"][4],-1,1,false)
								else
									RequestAnimDict(v["anim"][1])
									while not HasAnimDictLoaded(v["anim"][1]) do
										Citizen.Wait(1)
									end

									TaskPlayAnim(localPeds[k],v["anim"][1],v["anim"][2],8.0,0.0,-1,1,0,0,0,0)
								end
							end
						end
					end
				end
			else
				if localPeds[k] then
					DeleteEntity(localPeds[k])
					localPeds[k] = nil
				end
			end
		end

		Citizen.Wait(1000)
	end
end)