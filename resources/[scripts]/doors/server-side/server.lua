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
Tunnel.bindInterface("doors",cRP)
vTASKBAR = Tunnel.getInterface("taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Doors"] = {
	[1] = { x = 1846.049, y = 2604.733, z = 45.579, hash = 741314661, lock = true, text = true, distance = 30, press = 10, perm = "police" },
	[2] = { x = 1819.475, y = 2604.743, z = 45.577, hash = 741314661, lock = true, text = true, distance = 30, press = 10, perm = "police" },
	[3] = { x = 1836.71, y = 2590.32, z = 46.20, hash = 539686410, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[4] = { x = 1769.52, y = 2498.92, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[5] = { x = 1766.34, y = 2497.09, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[6] = { x = 1763.20, y = 2495.26, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[7] = { x = 1756.89, y = 2491.66, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[8] = { x = 1753.75, y = 2489.85, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[9] = { x = 1750.61, y = 2488.02, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[10] = { x = 1757.14, y = 2474.87, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[11] = { x = 1760.26, y = 2476.71, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[12] = { x = 1763.44, y = 2478.50, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[13] = { x = 1766.54, y = 2480.33, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[14] = { x = 1769.73, y = 2482.13, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[15] = { x = 1772.83, y = 2483.97, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[16] = { x = 1776.00, y = 2485.77, z = 46.00, hash = 913760512, lock = true, text = true, distance = 5, press = 2, perm = "police" },

	[21] = { x = -952.54, y = -2049.71, z = 6.1, hash = -806761221, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[22] = { x = -953.05, y = -2051.72, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[23] = { x = -955.99, y = -2049.01, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[24] = { x = -959.65, y = -2052.67, z = 9.4, hash = -1291439697, lock = true, text = true, distance = 5, press = 2, perm = "police" },

	[31] = { x = -925.98, y = -2035.20, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "police", other = 32 },
	[32] = { x = -926.82, y = -2034.42, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "police", other = 31 },
	[33] = { x = -953.81, y = -2044.32, z = 9.7, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "police" },
	[34] = { x = -954.02, y = -2058.36, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "police", other = 35 },
	[35] = { x = -954.78, y = -2057.61, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "police", other = 34 },
	[36] = { x = -912.94, y = -2033.33, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "police", other = 37 },
	[37] = { x = -913.69, y = -2032.55, z = 9.6, hash = 1307986194, lock = true, text = true, distance = 5, press = 2, perm = "police", other = 36 },

	[38] = { x = -1864.65, y = 2060.18, z = 140.97, hash = -1141522158, lock = true, text = false, distance = 5, press = 2, perm = "madrazo", other = 39 },
	[39] = { x = -1864.65, y = 2060.89, z = 140.97, hash = 988364535, lock = true, text = false, distance = 5, press = 2, perm = "madrazo", other = 38 },
	[40] = { x = -1883.96, y = 2059.68, z = 145.57, hash = 534758478, lock = true, text = true, distance = 5, press = 2, perm = "madrazo", other = 41 },
	[41] = { x = -1885.14, y = 2060.11, z = 145.57, hash = 534758478, lock = true, text = true, distance = 5, press = 2, perm = "madrazo", other = 40 },
	[42] = { x = 1406.91, y = 1127.87, z = 114.33, hash = 262671971, lock = true, text = true, distance = 5, press = 2, perm = "medellin" },
	[43] = { x = -2667.19, y = 1330.21, z = 147.44, hash = -147325430, lock = true, text = true, distance = 5, press = 2, perm = "siciliana" },
	[44] = { x = -2667.48, y = 1326.26, z = 147.44, hash = 1901183774, lock = true, text = true, distance = 5, press = 2, perm = "siciliana" },
	[45] = { x = -600.17, y = 283.07, z = 82.16, hash = -1977830166, lock = true, text = true, distance = 5, press = 2, perm = "arcade" },
	[46] = { x = 465.88, y = -1732.27, z = 29.17, hash = 1742849246, lock = true, text = true, distance = 5, press = 2, perm = "aztecas" },
	[47] = { x = -1179.25, y = -1781.26, z = 4.38, hash = 1742849246, lock = true, text = true, distance = 5, press = 1.5, perm = "favela01" },
	[48] = { x = -2565.0, y = 2306.94, z = 33.23, hash = 1742849246, lock = true, text = true, distance = 5, press = 1.5, perm = "favela02" },
	[49] = { x = 257.68, y = -3063.37, z = 5.87, hash = 1742849246, lock = true, text = true, distance = 5, press = 1.5, perm = "favela03" },
	[50] = { x = -1579.19, y = -917.21, z = 9.41, hash = 1742849246, lock = true, text = true, distance = 5, press = 1.5, perm = "favela04" },
	[51] = { x = 149.45, y = 6362.39, z = 31.54, hash = 1742849246, lock = true, text = true, distance = 5, press = 1.5, perm = "favela05" },
	[52] = { x = -585.19, y = -896.41, z = 26.0, hash = 263193286, lock = true, text = true, distance = 5, press = 1.5, perm = "bullguer" },
	[53] = { x = -583.04, y = 228.41, z = 79.43, hash = -612979079, lock = true, text = false, distance = 5, press = 1.5, perm = "hackerspace" },
	[54] = { x = -789.21, y = -1212.35, z = 3.56, hash = 631614199, lock = true, text = false, distance = 5, press = 1.5, perm = "police" },
	[55] = { x = -786.75, y = -1214.34, z = 3.56, hash = 631614199, lock = true, text = false, distance = 5, press = 1.5, perm = "police" },
	[56] = { x = -186.13, y = -1702.66, z = 33.01, hash = 1742849246, lock = true, text = false, distance = 5, press = 1.5, perm = "families" },
	[57] = { x = 116.67, y = -1990.66, z = 18.48, hash = 1742849246, lock = true, text = false, distance = 5, press = 1.5, perm = "ballas" },
	[58] = { x = 415.69, y = -2051.61, z = 22.36, hash = 1742849246, lock = true, text = false, distance = 5, press = 1.5, perm = "vagos" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSSTATISTICS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.doorsStatistics(doorNumber,doorStatus)
	local Doors = GlobalState["Doors"]

	Doors[doorNumber]["lock"] = doorStatus

	if Doors[doorNumber]["other"] ~= nil then
		local doorSecond = Doors[doorNumber]["other"]
		Doors[doorSecond]["lock"] = doorStatus
	end

	GlobalState["Doors"] = Doors
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.doorsPermission(doorNumber)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if GlobalState["Doors"][doorNumber]["perm"] ~= nil then
			if exports["common"]:Group().hasPermission(user_id,GlobalState["Doors"][doorNumber]["perm"]) or exports["common"]:Group().hasPermission(user_id,"staff") then
				return true
			else
				local consultItem = vRP.getInventoryItemAmount(user_id,"lockpick2")
				if consultItem[1] >= 1 then
					if math.random(100) >= 50 then
						vRP.removeInventoryItem(user_id,consultItem[2],1,true)
						vRP.generateItem(user_id,"brokenpick",1,false)
					end

					local taskResult = vTASKBAR.taskDoors(source)
					if taskResult then
						return true
					end
				end
			end
		end
	end

	return false
end