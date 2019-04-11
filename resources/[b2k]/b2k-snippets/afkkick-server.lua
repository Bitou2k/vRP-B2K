-- DEFAULT --
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

RegisterServerEvent("kickForBeingAnAFKDouchebag")
AddEventHandler("kickForBeingAnAFKDouchebag", function()
	local source = source
	vRP.kick({source,"[B2K] Você foi kikado por estar AFK."})
end)