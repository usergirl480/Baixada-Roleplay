VRP_DEBUG = false

RegisterCommand("pk_vrp_debug", function()
    VRP_DEBUG = not VRP_DEBUG
    print("okay")
end)