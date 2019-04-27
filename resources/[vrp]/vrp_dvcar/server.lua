local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_fixcar")

AddEventHandler('chatMessage', function(source, name, msg)
	if msg == "/dv" then
	  local user_id = vRP.getUserId({source})
	  local player = vRP.getUserSource({user_id})
	  if vRP.hasGroup({user_id,"parcasbot"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"parcassuperbot"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"user"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"[PMDP]Recruta"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"[PMDP]Soldado"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"[PMDP]Sargento"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"[PMDP]Tenente"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"[PMDP]Capitão"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"[PMDP]Coronel"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"Comandante"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"Enfermeiro"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"Paramédico"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"Médico"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"Diretor do Hospital"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"Secretário de Saúde"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"Mecânico"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"doadorult"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"doadorgold"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"Ajudante"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  elseif vRP.hasGroup({user_id,"modereitor"}) then
		CancelEvent();
		TriggerClientEvent('wk:deleteVehicle', source);
	  end
	end
end)