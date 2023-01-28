Vehicles = {}

function Vehicles.add(userId,vehName)
    local steam = vRP.getSteam(userId)
    if steam then
        vRP.execute("vehicles/addVehicles",{ user_id = userId, vehicle = vehName, plate = vRP.generatePlate(), work = tostring(false) })
    end
end

function Vehicles.remove(userId,vehName)
    local steam = vRP.getSteam(userId)
    if steam then
        vRP.execute("vehicles/removeVehicles",{ user_id = userId, vehicle = vehName })
    end
end

exports("addVehicles", function(userId,vehicle)
    Vehicles.add(userId,vehicle)
end)

exports("removeVehicles", function(userId,vehicle)
    Vehicles.remove(userId,vehicle)
end)

exports("Vehicles",function()
    return Vehicles
end)