-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("characters/allChars","SELECT * FROM characters")
vRP.prepare("characters/getUsers","SELECT * FROM characters WHERE id = @id")
vRP.prepare("characters/getPhone","SELECT id FROM characters WHERE phone = @phone")
vRP.prepare("characters/getSerial","SELECT id FROM characters WHERE serial = @serial")
vRP.prepare("characters/updatePort","UPDATE characters SET port = @port WHERE id = @id")
vRP.prepare("characters/fixPrison","UPDATE characters SET prison = 0 WHERE id = @user_id")
vRP.prepare("characters/updatePhone","UPDATE characters SET phone = @phone WHERE id = @id")
vRP.prepare("characters/updatePenal","UPDATE characters SET penal = @penal WHERE id = @id")
vRP.prepare("characters/addBank","UPDATE characters SET bank = bank + @bank WHERE id = @id")
vRP.prepare("characters/removeCharacters","UPDATE characters SET deleted = 1 WHERE id = @id")
vRP.prepare("characters/updateHomes","UPDATE characters SET homes = homes + 1 WHERE id = @id")
vRP.prepare("characters/removeBank","UPDATE characters SET bank = bank - @bank WHERE id = @id")
vRP.prepare("characters/setSerial","UPDATE characters SET serial = @serial WHERE id = @user_id")
vRP.prepare("characters/addFines","UPDATE characters SET fines = fines + @fines WHERE id = @id")
vRP.prepare("characters/setPrison","UPDATE characters SET prison = @prison WHERE id = @user_id")
vRP.prepare("characters/updateGarages","UPDATE characters SET garage = garage + 1 WHERE id = @id")
vRP.prepare("characters/removeFines","UPDATE characters SET fines = fines - @fines WHERE id = @id")
vRP.prepare("characters/getCharacters","SELECT * FROM characters WHERE steam = @steam and deleted = 0")
vRP.prepare("characters/removePrison","UPDATE characters SET prison = prison - @prison WHERE id = @user_id")
vRP.prepare("characters/updateName","UPDATE characters SET name = @name, name2 = @name2 WHERE id = @user_id")
vRP.prepare("characters/updateSurname","UPDATE characters SET surname = @surname WHERE id = @user_id")
vRP.prepare("characters/lastCharacters","SELECT id FROM characters WHERE steam = @steam ORDER BY id DESC LIMIT 1")
vRP.prepare("characters/countPersons","SELECT COUNT(steam) as qtd FROM characters WHERE steam = @steam and deleted = 0")
vRP.prepare("characters/createCharacters","INSERT INTO characters(steam,name,name2,phone) VALUES(@steam,@name,@name2,@phone)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNTS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("accounts/getInfos","SELECT * FROM accounts WHERE steam = @steam")
vRP.prepare("accounts/infosUnwhitelist","UPDATE accounts SET whitelist = 0 WHERE steam = @steam")
vRP.prepare("accounts/infosWhitelist","UPDATE accounts SET whitelist = @whitelist WHERE steam = @steam")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("playerdata/getUserdata","SELECT dvalue FROM characters_data WHERE user_id = @user_id AND dkey = @key")
vRP.prepare("playerdata/setUserdata","REPLACE INTO characters_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYDATA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("entitydata/removeData","DELETE FROM entitydata WHERE dkey = @dkey")
vRP.prepare("entitydata/getData","SELECT dvalue FROM entitydata WHERE dkey = @dkey")
vRP.prepare("entitydata/setData","REPLACE INTO entitydata(dkey,dvalue) VALUES(@dkey,@value)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vehicles/plateVehicles","SELECT * FROM characters_vehicles WHERE plate = @plate")
vRP.prepare("vehicles/getVehicles","SELECT * FROM characters_vehicles WHERE user_id = @user_id")
vRP.prepare("vehicles/removeVehicles","DELETE FROM characters_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vehicles/selectVehicles","SELECT * FROM characters_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vehicles/updateVehiclesTax","UPDATE characters_vehicles SET tax = @tax WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vehicles/addVehicles","INSERT IGNORE INTO characters_vehicles(user_id,vehicle,plate,work) VALUES(@user_id,@vehicle,@plate,@work)")
vRP.prepare("vehicles/updateHardness","UPDATE characters_vehicles SET hardness = @hardness WHERE vehicle = @vehicle AND plate = @plate")
vRP.prepare("vehicles/moveVehicles","UPDATE characters_vehicles SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vehicles/plateVehiclesUpdate","UPDATE characters_vehicles SET plate = @plate WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vehicles/rentalVehiclesDays","UPDATE characters_vehicles SET rendays = rendays + @days WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vehicles/arrestVehicles","UPDATE characters_vehicles SET arrest = @arrest, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vehicles/countVehicles","SELECT COUNT(vehicle) as qtd FROM characters_vehicles WHERE user_id = @user_id AND work = @work AND rental <= 0")
vRP.prepare("vehicles/rentalVehiclesUpdate","UPDATE characters_vehicles SET rental = @rental, rendays = @days WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vehicles/rentalVehicles","INSERT IGNORE INTO characters_vehicles(user_id,vehicle,plate,work,rental,rendays) VALUES(@user_id,@vehicle,@plate,@work,@rental,@rendays)")
vRP.prepare("vehicles/updateVehicles","UPDATE characters_vehicles SET engine = @engine, body = @body, fuel = @fuel, doors = @doors, windows = @windows, tyres = @tyres, nitro = @nitro WHERE user_id = @user_id AND vehicle = @vehicle")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("propertys/selling","DELETE FROM properties WHERE name = @name")
vRP.prepare("propertys/permissions","SELECT * FROM properties WHERE name = @name")
vRP.prepare("propertys/totalHomes","SELECT name,tax FROM properties WHERE owner = 1")
vRP.prepare("propertys/userList","SELECT name FROM properties WHERE user_id = @user_id")
vRP.prepare("propertys/countUsers","SELECT COUNT(*) as qtd FROM properties WHERE user_id = @user_id")
vRP.prepare("propertys/countPermissions","SELECT COUNT(*) as qtd FROM properties WHERE name = @name")
vRP.prepare("propertys/updateTax","UPDATE properties SET tax = @tax WHERE name = @name AND owner = 1")
vRP.prepare("propertys/userOwnermissions","SELECT * FROM properties WHERE name = @name AND owner = 1")
vRP.prepare("propertys/removePermissions","DELETE FROM properties WHERE name = @name AND user_id = @user_id")
vRP.prepare("propertys/userPermissions","SELECT * FROM properties WHERE name = @name AND user_id = @user_id")
vRP.prepare("propertys/updateVault","UPDATE properties SET vault = vault + 25 WHERE name = @name AND owner = 1")
vRP.prepare("propertys/updateFridge","UPDATE properties SET fridge = fridge + 25 WHERE name = @name AND owner = 1")
vRP.prepare("propertys/updateOwner","UPDATE properties SET user_id = @nuser_id WHERE user_id = @user_id AND name = @name")
vRP.prepare("propertys/newPermissions","INSERT IGNORE INTO properties(name,interior,user_id,owner) VALUES(@name,@interior,@user_id,@owner)")
vRP.prepare("propertys/buying","INSERT IGNORE INTO properties(name,interior,price,user_id,tax,residents,vault,fridge,owner,contract) VALUES(@name,@interior,@price,@user_id,@tax,@residents,@vault,@fridge,1,@contract)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("prison/cleanRecords","DELETE FROM prison WHERE nuser_id = @nuser_id")
vRP.prepare("prison/getRecords","SELECT * FROM prison WHERE nuser_id = @nuser_id ORDER BY id DESC")
vRP.prepare("prison/insertPrison","INSERT INTO prison(police,nuser_id,services,fines,text,date) VALUES(@police,@nuser_id,@services,@fines,@text,@date)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANNEDS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("banneds/getBanned","SELECT * FROM accounts_bans WHERE steam = @steam")
vRP.prepare("banneds/removeBanned","DELETE FROM accounts_bans WHERE steam = @steam")
vRP.prepare("banneds/insertBanned","INSERT INTO accounts_bans(steam,days) VALUES(@steam,@days)")
vRP.prepare("banneds/getTimeBanned","SELECT * FROM accounts_bans WHERE steam = @steam AND (DATEDIFF(CURRENT_DATE,time) >= days)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("chests/getChests","SELECT * FROM chests WHERE name = @name")
vRP.prepare("chests/upgradeChests","UPDATE chests SET weight = weight + 25 WHERE name = @name")
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("races/checkResult","SELECT * FROM races WHERE raceid = @raceid AND user_id = @user_id")
vRP.prepare("races/requestRanking","SELECT * FROM races WHERE raceid = @raceid ORDER BY points ASC LIMIT 5")
vRP.prepare("races/updateRecords","UPDATE races SET points = @points, vehicle = @vehicle WHERE raceid = @raceid AND user_id = @user_id")
vRP.prepare("races/insertRecords","INSERT INTO races(raceid,user_id,name,vehicle,points) VALUES(@raceid,@user_id,@name,@vehicle,@points)")