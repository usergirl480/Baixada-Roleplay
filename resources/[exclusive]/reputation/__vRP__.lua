Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

local SERVER = IsDuplicityVersion()
local CLIENT = not SERVER

if SERVER then
    src = {}
    Tunnel.bindInterface(GetCurrentResourceName(),src)
    client = Tunnel.getInterface(GetCurrentResourceName())
end

if CLIENT then
    src = {}
    Tunnel.bindInterface(GetCurrentResourceName(),src)
    server = Tunnel.getInterface(GetCurrentResourceName())
end