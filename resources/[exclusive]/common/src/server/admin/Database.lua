Database = {}

function Database.resetId(characterId)
    if characterId then
        local characterPhone = exports.oxmysql:single_async("SELECT `phone` FROM `characters` WHERE `id` = @characterId",{ characterId = characterId })
        exports.oxmysql:query("DELETE FROM `characters` WHERE `id` = @characterId",{ characterId = characterId })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela characters.")

        exports.oxmysql:query("DELETE FROM `characters_data` WHERE `user_id` = @characterId",{ characterId = characterId })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela characters_data.")

        exports.oxmysql:query("DELETE FROM `characters_vehicles` WHERE `user_id` = @characterId",{ characterId = characterId })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela characters_vehicles.")

        exports.oxmysql:query("DELETE FROM `groups` WHERE `character_id` = @characterId",{ characterId = characterId })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela groups.")

        exports.oxmysql:query("DELETE FROM `prison` WHERE `nuser_id` = @characterId",{ characterId = characterId })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela prison.")

        exports.oxmysql:query("DELETE FROM `properties` WHERE `user_id` = @characterId",{ characterId = characterId })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela properties.")

        -- Smartphone
        exports.oxmysql:query("DELETE FROM `smartphone_bank_invoices` WHERE `payee_id` = @characterId OR `payer_id` = @characterId",{ characterId = characterId })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_bank_invoices.")

        exports.oxmysql:query("DELETE FROM `smartphone_blocks` WHERE `user_id` = @characterId OR `phone` = @characterPhone",{ characterId = characterId, characterPhone = characterPhone  })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_blocks.")

        exports.oxmysql:query("DELETE FROM `smartphone_gallery` WHERE `user_id` = @characterId",{ characterId = characterId })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_gallery.")

        exports.oxmysql:query("DELETE FROM `smartphone_olx` WHERE `user_id` = @characterId",{ characterId = characterId })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_gallery.")

        exports.oxmysql:query("DELETE FROM `smartphone_calls` WHERE `initiator` = @characterPhone OR `target` = @characterPhone",{ characterPhone = characterPhone })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_calls.")

        exports.oxmysql:query("DELETE FROM `smartphone_contacts` WHERE `owner` = @characterPhone OR `phone` = @characterPhone",{ characterPhone = characterPhone })
        print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_contacts.")

        local characterInstagramId = exports.oxmysql:query_async("SELECT `id` FROM `smartphone_instagram` WHERE `user_id` = @characterId",{ characterId = characterId })[1].id
        if characterInstagramId then
            exports.oxmysql:query("DELETE FROM `smartphone_instagram` WHERE `id` = @characterInstagramId",{ characterInstagramId = characterInstagramId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_instagram.")

            exports.oxmysql:query("DELETE FROM `smartphone_instagram_followers` WHERE `follower_id` = @characterInstagramId OR `follower_id` = @characterInstagramId",{ characterInstagramId = characterInstagramId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_instagram_followers.")

            exports.oxmysql:query("DELETE FROM `smartphone_instagram_likes` WHERE `profile_id` = @characterInstagramId",{ characterInstagramId = characterInstagramId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_instagram_likes.")

            exports.oxmysql:query("DELETE FROM `smartphone_instagram_notifications` WHERE `profile_id` = @characterInstagramId OR `author_id` = @characterInstagramId",{ characterInstagramId = characterInstagramId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_instagram_notifications.")

            exports.oxmysql:query("DELETE FROM `smartphone_instagram_posts` WHERE `profile_id` = @characterInstagramId",{ characterInstagramId = characterInstagramId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_instagram_posts.")
        else
            print("[^3WARNING^7] Usuário "..characterId.." não possuia Instagram.")
        end

        local characterTinderId = exports.oxmysql:query_async("SELECT `id` FROM `smartphone_tinder` WHERE `user_id` = @characterId",{ characterId = characterId })[1].id
        if characterTinderId then
            exports.oxmysql:query("DELETE FROM `smartphone_tinder` WHERE `user_id` = @characterId",{ characterId = characterId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_tinder.")

            exports.oxmysql:query("DELETE FROM `smartphone_tinder_messages` WHERE `sender` = @characterTinderId OR `target` = @characterTinderId",{ characterTinderId = characterTinderId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_tinder_messages.")

            exports.oxmysql:query("DELETE FROM `smartphone_tinder_rating` WHERE `profile_id` = @characterTinderId OR `rated_id` = @characterTinderId",{ characterTinderId = characterTinderId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_tinder_rating.")
        else
            print("[^3WARNING^7] Usuário "..characterId.." não possuia Tinder.")
        end

        local characterTwitterId = exports.oxmysql:query_async("SELECT `id` FROM `smartphone_twitter_profiles` WHERE `user_id` = @characterId",{ characterId = characterId })[1].id
        if characterTwitterId then
            exports.oxmysql:query("DELETE FROM `smartphone_twitter_profiles` WHERE `user_id` = @characterId",{ characterId = characterId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_twitter_profiles.")

            exports.oxmysql:query("DELETE FROM `smartphone_twitter_followers` WHERE `follower_id` = @characterTwitterId AND `profile_id` = @characterTwitterId",{ characterTwitterId = characterTwitterId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_twitter_followers.")

            exports.oxmysql:query("DELETE FROM `smartphone_twitter_likes` WHERE `profile_id` = @characterTwitterId",{ characterTwitterId = characterTwitterId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_twitter_likes.")

            exports.oxmysql:query("DELETE FROM `smartphone_twitter_tweets` WHERE `profile_id` = @characterTwitterId",{ characterTwitterId = characterTwitterId })
            print("[^3WARNING^7] Deletado Usuário "..characterId.." de tabela smartphone_twitter_tweets.")
        else
            print("[^3WARNING^7] Usuário "..characterId.." não possuia Twitter.")
        end

        print("[^2FINALIZADO^7] Todos os resets realizados.")
    end
end

function Database.changeId(source,oldId,newId)
    if oldId and newId then
        local oldIdExists = exports.oxmysql:query_async("SELECT `id` FROM `characters` WHERE `id` = @oldId",{ oldId = oldId })
        if #oldIdExists > 0 then
            if source == 0 then print("O ID Antigo ainda existe") end
            if source ~= 0 then TriggerClientEvent("Notify",source,"negado","O ID antigo ainda existe.") end
            return
        end

        local newIdExists = exports.oxmysql:query_async("SELECT `id` FROM `characters` WHERE `id` = @newId",{ newId = newId })
        if #newIdExists > 0 then
            if source == 0 then print("O ID novo já existe") end
            if source ~= 0 then TriggerClientEvent("Notify",source,"negado","O ID novo já existe.") end
        end
        
        exports.oxmysql:query("UPDATE `characters` SET `id` = @newId WHERE `id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela characters.")

        exports.oxmysql:query("UPDATE `characters_data` SET `user_id` = @newId WHERE `user_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela characters_data.")

        exports.oxmysql:query("UPDATE `characters_vehicles` SET `user_id` = @newId WHERE `user_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela characters_vehicles.")

        exports.oxmysql:query("UPDATE `groups` SET `character_id` = @newId WHERE `character_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela groups.")

        exports.oxmysql:query("UPDATE `prison` SET `nuser_id` = @newId WHERE `nuser_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela prison.")

        exports.oxmysql:query("UPDATE `properties` SET `user_id` = @newId WHERE `user_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela properties.")

        --- Smartphone
        exports.oxmysql:query("UPDATE `smartphone_bank_invoices` SET `payee_id` = @newId WHERE `payee_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela smartphone_bank_invoices.")

        exports.oxmysql:query("UPDATE `smartphone_blocks` SET `user_id` = @newId WHERE `user_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela smartphone_blocks.")

        exports.oxmysql:query("UPDATE `smartphone_gallery` SET `user_id` = @newId WHERE `user_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela smartphone_gallery.")

        exports.oxmysql:query("UPDATE `smartphone_instagram` SET `user_id` = @newId WHERE `user_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela smartphone_instagram.")

        exports.oxmysql:query("UPDATE `smartphone_olx` SET `user_id` = @newId WHERE `user_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela smartphone_olx.")

        exports.oxmysql:query("UPDATE `smartphone_tinder` SET `user_id` = @newId WHERE `user_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela smartphone_tinder.")

        exports.oxmysql:query("UPDATE `smartphone_twitter_profiles` SET `user_id` = @newId WHERE `user_id` = @oldId",{ newId = newId, oldId = oldId })
        print("[^3WARNING^7] Alterado Usuário "..oldId.." para "..newId.." em tabela smartphone_twitter_profiles.")
    end
end

RegisterNetEvent("admin:resetID",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(user_id,"ceo") then
        return
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local targetId = vRP.prompt(source, "Insira o ID:","")
    if targetId == "" or parseInt(targetId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local characterId = parseInt(targetId)
    local characterSource = vRP.userSource(characterId)
    if characterSource then
        if vRP.request(source,"Você deseja expulsar o usuário <b>"..characterId.."</b>?",30) then
            TriggerClientEvent("Notify",source,"sucesso","Usuário resetado.",10000,"bottom")
            vRP.kick(characterId,"Você foi expulso(a) por um Administrador(a).")
            Wait(5000)
            Database.resetId(characterId)
        end
    else
        if vRP.request(source,"Você deseja resetar o usuário <b>"..characterId.."</b>?",30) then
            TriggerClientEvent("Notify",source,"sucesso","Usuário resetado.",10000,"bottom")
            Database.resetId(characterId)
        end
    end

    TriggerClientEvent("Notify",source,"sucesso","ID resetado.",10000,"bottom")
end)

RegisterNetEvent("admin:changeID",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasAccessOrHigher(user_id,"ceo") then
        return
    end
 
    TriggerClientEvent("dynamic:closeSystem",source)

    local oldId = vRP.prompt(source, "Insira o ID atual:","")
    if oldId == "" or parseInt(oldId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local newId = vRP.prompt(source, "Insira o novo ID:","")
    if newId == "" or parseInt(newId) <= 0 then 
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000,"bottom")
    end

    local oldId = parseInt(oldId)
    local newId = parseInt(newId)
    
    if vRP.userSource(oldId) then
        TriggerClientEvent("Notify",source,"negado","<b>"..oldId.."</b> está conectado no servidor.",10000,"bottom")
        return
    end

    if vRP.userSource(newId) then
        TriggerClientEvent("Notify",source,"negado","<b>"..newId.."</b> está conectado no servidor.",10000,"bottom")
        return
    end

    Database.changeId(source,oldId,newId)
    TriggerClientEvent("Notify",source,"sucesso","ID alterado.",10000,"bottom")
end)

RegisterCommand("resetid",function(source,args,rawCmd)
    if source == 0 then
        if not args[1] then return end
        local characterId = parseInt(args[1])
        local characterSource = vRP.userSource(characterId)
        if characterSource then
            print("[^1ERROR^7] "..characterId.." está conectado ao servidor.")
            return
        end

        Database.resetId(characterId)
    end
end)

RegisterCommand("alterarid",function(source,args,rawCmd)
    if source == 0 then
        if not args[1] or not args[2] then return end

        local oldId = parseInt(args[1])
        local newId = parseInt(args[2])
        if vRP.userSource(oldId) then
            print("[^1ERROR^7] "..oldId.." está conectado ao servidor.")
            return
        end

        if vRP.userSource(newId) then
            print("[^1ERROR^7] "..newId.." está conectado ao servidor.")
            return
        end

        Database.changeId(0,oldId,newId)
    end
end)