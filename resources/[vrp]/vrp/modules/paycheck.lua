local Proxy = module("vrp", "lib/Proxy")

RegisterServerEvent('paycheck:salary:b2k')
AddEventHandler('paycheck:salary:b2k', function()

	local src = source
  	local user_id = vRP.getUserId(src)
	if user_id then
		local player = vRP.getUserSource(user_id)
		vRP.getUData(user_id,"paycheck", function(data)
			local delay = json.decode(data) or 0
			local cond = (os.time() >= delay+1*33*60)
			if cond then
				delay = os.time()
				vRP.setUData(user_id,"paycheck", json.encode(delay))
				
				-- Salarios
				local salarioFederal = 4300
				
				local salarioPM = 2100--1700--1100
				local salarioFT = 2900--2200--1500
				local salarioRT = 3500--1900
				
				local salarioSAMUPraca = 2100--1700--1100
				local salarioSAMUGraduados = 2900--2200--1500
				local salarioSAMUSuperiores = 3500--2700--1900
				
				local salarioAdvEstagiario = 1500--1000
				local salarioAdvJunior = 2000--1300
				local salarioAdvPresidente = 2500--1600
				
				local salarioReporter = 2000
				
				local salarioMecanico = 950
				local salarioUber = 950
				local salarioSedex = 950
				local salarioEntregador = 950
				local salarioMinerador = 950
				local salarioCruzVermelha = 950
				
				if vRP.hasPermission(user_id,"paycheck.policial.federal") then
					vRP.giveBankMoney(user_id,salarioFederal)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"Policial Federal",false,"Salário: R$~g~".. salarioFederal})

				elseif vRP.hasPermission(user_id,"paycheck.policial.pm") then
					vRP.giveBankMoney(user_id,salarioPM)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"Policial Militar",false,"Salário: R$~g~".. salarioPM})

				elseif vRP.hasPermission(user_id,"paycheck.policial.ft") then
					vRP.giveBankMoney(user_id,salarioFT)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"Força Tática",false,"Salário: R$~g~".. salarioFT})

				elseif vRP.hasPermission(user_id,"paycheck.policial.rt") then
					vRP.giveBankMoney(user_id,salarioRT)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"ROTA",false,"Salário: R$~g~".. salarioRT})
				
				elseif vRP.hasPermission(user_id,"paycheck.samu.praca") then
					vRP.giveBankMoney(user_id,salarioSAMUPraca)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"SAMU Praças",false,"Salário: R$~g~".. salarioSAMUPraca})

				elseif vRP.hasPermission(user_id,"paycheck.samu.graduados") then
					vRP.giveBankMoney(user_id,salarioSAMUGraduados)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"SAMU Graduados",false,"Salário: R$~g~".. salarioSAMUGraduados})

				elseif vRP.hasPermission(user_id,"paycheck.samu.superiores") then
					vRP.giveBankMoney(user_id,salarioSAMUSuperiores)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"SAMU Superiores",false,"Salário: R$~g~".. salarioSAMUSuperiores})
				
				elseif vRP.hasPermission(user_id,"paycheck.adv.estagiario") then
					vRP.giveBankMoney(user_id,salarioAdvEstagiario)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"OAB Estagiário",false,"Salário: R$~g~".. salarioAdvEstagiario})

				elseif vRP.hasPermission(user_id,"paycheck.adv.junior") then
					vRP.giveBankMoney(user_id,salarioAdvJunior)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"OAB Advogados",false,"Salário: R$~g~".. salarioAdvJunior})

				elseif vRP.hasPermission(user_id,"paycheck.adv.presidente") then
					vRP.giveBankMoney(user_id,salarioAdvPresidente)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"OAB Presidente",false,"Salário: R$~g~".. salarioAdvPresidente})

				elseif vRP.hasPermission(user_id,"paycheck.mecanico") then
					vRP.giveBankMoney(user_id,salarioMecanico)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"Mecânico",false,"Salário: R$~g~".. salarioMecanico})

				elseif vRP.hasPermission(user_id,"paycheck.taxi") then
					vRP.giveBankMoney(user_id,salarioUber)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"Taxi",false,"Salário: R$~g~".. salarioUber})

				elseif vRP.hasPermission(user_id,"paycheck.sedex") then
					vRP.giveBankMoney(user_id,salarioSedex)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"Sedex",false,"Salário: R$~g~".. salarioSedex})

				elseif vRP.hasPermission(user_id,"paycheck.entregador") then
					vRP.giveBankMoney(user_id,salarioEntregador)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"Entregador",false,"Salário: R$~g~".. salarioEntregador})

				elseif vRP.hasPermission(user_id,"paycheck.minerador") then
					vRP.giveBankMoney(user_id,salarioMinerador)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"Minerador",false,"Salário: R$~g~".. salarioMinerador})

				elseif vRP.hasPermission(user_id,"paycheck.reporter") then
					vRP.giveBankMoney(user_id,salarioReporter)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"Reporter",false,"Salário: R$~g~".. salarioReporter})

				elseif vRP.hasPermission(user_id,"paycheck.cruz.vermelha") then
					vRP.giveBankMoney(user_id,salarioCruzVermelha)
					vRPclient.notifyPicture(player,{"CHAR_BANK_MAZE",1,"Cruz vermelha",false,"Salário: R$~g~".. salarioCruzVermelha})
				end
			else
				SendWebhookMessage(ac_webhook_gameplay, "**ADMIN POSSIVEL PAYCHECK INJECT** \n```\nUser ID: "..user_id.."```")
			end
		end)
	end
end)

RegisterServerEvent('paycheck:bonus:b2k')
AddEventHandler('paycheck:bonus:b2k', function()
	local src = source
  	local user_id = vRP.getUserId(src)
	if user_id and vRP.hasPermission(user_id,"user.paycheck") then
		local player = vRP.getUserSource(user_id)
		vRP.getUData(user_id,"paycheckBonus", function(data)
			local delay = json.decode(data) or 0
			local cond = (os.time() >= delay+1*23*60)
			if cond then
				vRP.giveBankMoney(user_id,250)
				vRPclient.notify(player,{"Bônus por Jogar: ~g~R$250"})
				
				delay = os.time()
				vRP.setUData(user_id,"paycheckBonus", json.encode(delay))
			else
				SendWebhookMessage(ac_webhook_gameplay, "**ADMIN POSSIVEL PAYCHECK BONUS INJECT** \n```\nUser ID: "..user_id.."```")
			end
		end)
	end
end)
