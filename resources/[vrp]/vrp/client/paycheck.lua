vRP = Proxy.getInterface("vRP")

Citizen.CreateThread(function ()
	while true do
		local user_id = vRP.getUserId(source)
		Citizen.Wait((1000*60*35)) -- Every X ms you'll get paid (300000 = 5 min)
		TriggerServerEvent('paycheck:salary:b2k')
	end
end)

Citizen.CreateThread(function ()
	while true do
		local user_id = vRP.getUserId(source)
		Citizen.Wait((1000*60*25)) -- Every X ms you'll get paid (300000 = 5 min)
		TriggerServerEvent('paycheck:bonus:b2k')
	end
end)

