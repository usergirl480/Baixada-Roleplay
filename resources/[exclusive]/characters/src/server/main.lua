local charLocked = {}
local usersLogin = {}

function src.initSystem()
    local source = source
    local steam = vRP.getSteamBySource(source)
    local characterList = {}
    
    local timePlayed = exports["common"]:PlayedTime().get(steam)
    local maxChars = exports["store"]:Appointments().maxCharsBySteam(steam)
    local query = exports.oxmysql:query_async("SELECT `id`,`name`,`name2`,`surname` FROM `characters` WHERE `steam` = @steam AND `deleted` = 0",{ steam = steam })
    if #query > 0 then
        for k,v in pairs(query) do
            table.insert(characterList,{ userId = v.id, name = v.name.." "..v.name2, surname = v.surname })
        end
    end

    return characterList,timePlayed or 0,#query,maxChars
end

function src.spawnCharacter(userId,spawnPoint)
    local source = source
    local steam = vRP.getSteamBySource(source)
    local query = exports.oxmysql:query_async("SELECT `name` FROM `characters` WHERE `steam` = @steam AND `id` = @id",{ steam = steam, id = userId })

    if #query > 0 then
        vRP.characterChosen(source,userId,nil) 
        if spawnPoint == 999 then
            local dataTable = vRP.getDatatable(userId)
            if dataTable then
                if dataTable["position"] then
                    if dataTable["position"]["x"] == nil or dataTable["position"]["y"] == nil or dataTable["position"]["z"] == nil then
                        dataTable["position"] = { x = -33.63, y = -154.53, z = 57.07 }
                    end
                else
                    dataTable["position"] = { x = -33.63, y = -154.53, z = 57.07 }
                end

                vRPC.teleport(source,dataTable["position"]["x"],dataTable["position"]["y"],dataTable["position"]["z"])
                TriggerClientEvent("characters:justSpawn",source)
            else
                TriggerClientEvent("characters:justSpawn",source,1)
            end
        else
            TriggerClientEvent("characters:justSpawn",source,spawnPoint)
        end
        
        exports["common"]:Log().embedDiscord(userId,"usuario-conectou","Conectou-se às "..os.date("%d/%m/%y %H:%M:%S"))
        if not usersLogin[userId] then 
            usersLogin[userId] = true 
        end
    end 
end

function src.newCharacter(name,name2,surname,sex)
    local source = source
    if not charLocked[source] then
        charLocked[source] = true

        local steam = vRP.getSteamBySource(source)
        local maxChars = exports["store"]:Appointments().maxCharsBySteam(steam)
        local countCharsQuery = exports.oxmysql:query_async("SELECT COUNT(id) AS qtd FROM `characters` WHERE `steam` = @steam AND `deleted` = 0",{ steam = steam })

        if parseInt(maxChars) <= parseInt(countCharsQuery[1]["qtd"]) then
            TriggerClientEvent("Notify",source,"negado","Você atingiu o limite máximo de personagens.")
            return
        end
        
        local created = exports.oxmysql:query_async("INSERT INTO `characters` (`steam`,`name`,`name2`,`surname`,`phone`) VALUES (@steam,@name,@name2,@surname,@phone)",{
            steam = steam,
            name = name,
            name2 = name2,
            surname = surname,
            phone = vRP.generatePhone()
        })

        vRP.characterChosen(source,created.insertId,sex)
        TriggerClientEvent("characters:justSpawn",source)
        
        TriggerClientEvent("Notify",source,"sucesso","Seja bem-vindo(a) ao <b>BAIXADA!",30000,"center")
        TriggerClientEvent("Notify",source,"sucesso","Pressione <b>E</b> para abrir a <b>Barbearia</b> e criar o seu personagem.",30000,"bottom")

        Wait(2000)
        
        TriggerEvent("player:presetIntro",source)
        TriggerEvent("identity:atualizar",tonumber(created.insertId))
        charLocked[source] = nil
        usersLogin[created.insertId] = true

        local dataTable = vRP.getDatatable(created.insertId)
        if dataTable then
            if dataTable["position"] then
                if dataTable["position"]["x"] == nil or dataTable["position"]["y"] == nil or dataTable["position"]["z"] == nil then
                    dataTable["position"] = { x = -33.63, y = -154.53, z = 57.07 }
                end
            else
                dataTable["position"] = { x = -33.63, y = -154.53, z = 57.07 }
            end

            vRPC.teleport(source,dataTable["position"]["x"],dataTable["position"]["y"],dataTable["position"]["z"])
            TriggerClientEvent("characters:justSpawn",source)
        else
            TriggerClientEvent("characters:justSpawn",source,1)
        end
    end
end

function src.previewCharacter(userId)
    local source = source
    local data = vRP.userData(userId,"Datatable")
    local clothes = vRP.userData(userId,"Clothings")
    local barber = vRP.userData(userId,"Barbershop")
    TriggerClientEvent("characters:previewCharacter",source,data.skin,clothes,barber)
end

function src.getLogin(userId)
    return usersLogin[userId] or false
end