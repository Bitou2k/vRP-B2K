-- define items, see the Inventory API on github

local cfg = {}

local function genMedic(vary_hunger, vary_thirst)
  local fgen = function(args)
    local idname = args[1]
    local choices = {}
    local name = vRP.getItemName(idname)

    choices["Usar"] = {function(player,choice)
      local user_id = vRP.getUserId(player)
      if user_id ~= nil then
        vRPclient.isInComa(player,{}, function(in_coma)
          if in_coma then
            vRPclient.notify(player,{"Você está em coma."})
          else
            if vRP.tryGetInventoryItem(user_id,idname,1,false) then
              if vary_hunger ~= 0 then vRP.varyHunger(user_id,vary_hunger) end
              if vary_thirst ~= 0 then vRP.varyThirst(user_id,vary_thirst) end

              vRPclient.notify(player,{"~w~Medicamento: "..name.."."})
              vRPclient.playAnim(player,{true,{{"mp_player_intdrink","intro_bottle",1},{"mp_player_intdrink","loop_bottle",1},{"mp_player_intdrink","outro_bottle",1}},false})

              vRP.closeMenu(player)
            end
          end
        end)
      end
    end}

    return choices
  end

  return fgen
end

-- see the manual to understand how to create parametric items
-- idname = {name or genfunc, description or genfunc, genfunc choices or nil, weight or genfunc}
-- a good practice is to create your own item pack file instead of adding items here
cfg.items = {
  -- COIN
  ["b2kcoin"] = {"B2K Coin", "Moeda B2K.", nil, 0, "<span class='special-item'>B2K Coin</span>"},

  -- Drogas
  ["benzoilmetilecgonina"] = {"Benzoilmetilecgonina", "Usado para fabricar Cocaina.", nil, 1.0, "Ilegal: <span class='ilegal-item'>Benzoilmetilecgonina</span>"}, -- cocaine
  ["anfetamina"] = {"Anfetamina", "Usado para fabricar Metanfetamina.", nil, 1.0, "Ilegal: <span class='ilegal-item'>Anfetamina</span>"}, -- meth
  ["seeds"] = {"Cannabis", "Folha de Cannabis.", nil, 1.0, "Ilegal: <span class='ilegal-item'>Cannabis</span>"}, -- weed
  -- Itens Ilegais
  ["carnesilvestre"] = {"Carne Silvestre", "Carne Ilegal coletado de Animais Silvestres.", nil, 5.0, "Ilegal: <span class='ilegal-item'>Carne Silvestre</span>"},
  ["carnetriturada"] = {"Carne Silvestre Triturada", "Carne Ilegal Triturada coletada de Animais Silvestres.", nil, 2.5, "Ilegal: <span class='ilegal-item'>Carne Silvestre Triturada</span>"},
  ["tartaruga"] = {"Tartaruga", "Uma pobre tartaruga.", nil, 5.0, "Ilegal: <span class='ilegal-item'>Tartaruga</span>"},
  ["carnetartaruga"] = {"Carne de Tartaruga", "Carne de Tartaruga.", nil, 2.5, "Ilegal: <span class='ilegal-item'>Carne de Tartaruga</span>"},

  ["cartaovirgem"] = {"Cartão Crédito Virgem", "Cartão de crédito virgem sem informações.", nil, 1.0, "Ilegal: <span class='ilegal-item'>Cartão Crédito Virgem</span>"},
  ["cartaoclonado"] = {"Cartão Crédito Clonado", "Cartão de crédito clonado.", nil, 1.0, "Ilegal: <span class='ilegal-item'>Cartão Crédito Clonado</span>"},
  
  
  -- Itens Legais
  ["suprimentos"] = {"Suprimentos", "Suprimentos emergenciais da Cruz Vermelha.", nil, 1.0, "Emprego: <span class='job-item'>Suprimentos</span>"},

  ["carnelegal"] = {"Carne de Animal", "Carne de Animais autorizados para caça. Coelho e Veado.", nil, 5.0, "Emprego: <span class='job-item'>Carne Legal de Animal</span>"},
  ["carnelegaltriturada"] = {"Carne Triturada", "Carne de Animais Triturada autorizadas para Caça. Coelho e Veado.", nil, 2.5, "Emprego: <span class='job-item'>Carne Legal Triturada</span>"},
  ["processosjudiciais"] = {"Processos Judiciais", "Processos Judiciais Variados da Comarca de São Paulo.", nil, 2.0, "Emprego: <span class='job-item'>Processos Judiciais</span>"},
  ["rocha"] = {"Rocha", "Fragmento de Rocha.", nil, 2.0, "Emprego: <span class='job-item'>Rocha</span>"},
  ["ouro"] = {"Ouro", "Ouro Bruto.", nil, 1.0, "Emprego: <span class='job-item'>Ouro</span>"},
  ["ferro"] = {"Ferro", "Ferro.", nil, 1.0, "Emprego: <span class='job-item'>Ferro</span>"},
  ["bronze"] = {"Bronze", "Bronze.", nil, 1.0, "Emprego: <span class='job-item'>Bronze</span>"},
  ["diamantelap"] = {"Diamante Lapidado", "Diamante Lapidado.", nil, 1.0, "Emprego: <span class='job-item'>Diamante Lapidado</span>"},
  
  -- Componentes de Armas
  ["pistol_parts"] = {"Componente de Pistola 9mm", "", nil, 0.2, "Ilegal: <span class='ilegal-item'>Componente de Pistola 9mm</span>" },
  ["shotgun_parts"] = {"Componente da Shotgun", "", nil, 0.3, "Ilegal: <span class='ilegal-item'>Componente da Shotgun</span>" },
  ["smg_parts"] = {"Componente da SMG", "", nil, 0.4, "Ilegal: <span class='ilegal-item'>Componente da SMG</span>" },
  ["ak47_parts"] = {"Componente da AK47", "", nil, 0.5, "Ilegal: <span class='ilegal-item'>Componente da AK47</span>" },
  
  
  ["driver"] = {"Licença de Armas", "Licença para portar pistola.", nil, 0.01},
  ["pistollin"] = {"Porte de Arma(Pistola)", "Porte de Arma ( Pistola ).", nil, 0.01},  -- no choices
  ["pesadolin"] = {"Porte de Arma (Shotgun)", "Porte de Arma ( Shotgun ).", nil, 0.01},
  ["sacodelixo"] = {"Saco de Lixo ", "", nil, 0.00},
  ["bank_money"] = {"Dinheiro do Banco", "$.", nil, 0, "Pacote: <span class='food-item'>Dinheiro</span>"},

  -- Remedios
  ["dipiroca"] = {"Dipiroca", "Para dores gerais no corpo", genMedic(1,1), 0.00 , "Remédio: <span class='job-item'>Dipiroca</span>"},
  ["nocucedin"] = {"Nocucedin", "Anti-inflamatório (remédio controlado)", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Nocucedin</span>"},
  ["paracetanal"] = {"Paracetanal", "Para dores nos membros superiores (Braços)", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Paracetanal</span>"},
  ["decupramim"] = {"Decupramim", "Supositório para prisão de ventre e merda dura!", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Decupramim</span>"},
  ["buscopau"] = {"Buscopau", "Dor na região genital masculina", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Buscopau</span>"},
  ["navagina"] = {"Navagina", "Dor na região genital feminina", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Navagina</span>"},
  ["analdor"] = {"Analdor", "Remédio para dores de cabeça", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Analdor</span>"},
  ["sefodex"] = {"Sefodex", "Calmante, para quando você tá querendo mandar as pessoas para aquele lugar.", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Sefodex</span>"},
  ["phodac"] = {"Phoda-C", "Vitamina C para quem morreu de FOME", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Phoda-C</span>"},
  ["danec"] = {"Dane-C", "Vitamina C para quem morreu de SEDE", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Dane-C</span>"},
  ["cotovelol"] = {"Cotovelol", "Para pessoas com inveja e dor de cotovelo", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Cotovelol</span>"},
  ["nokusin"] = {"Nokusin", "Para dores nos membros inferiores (pernas)", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Nokusin</span>"},
  ["viagral"] = {"Viagral", "Para impotência, quando quer pegar a MINA/MINO no geral!", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Viagral</span>"},
  ["glicoanal"] = {"Glicoanal", "Dose bruta de glicose para alcoolizados", genMedic(1,1), 0.00,  "Remédio: <span class='job-item'>Glicoanal</span>"},
  ["quigosado"] = {"Quigosado", "Para ataques de riso e pessoas que falam muito.", genMedic(1,1), 0.00, "Remédio: <span class='job-item'>Quigosado</span>"},
}

-- load more items function
local function load_item_pack(name)
  local items = module("cfg/item/"..name)
  if items then
    for k,v in pairs(items) do
      cfg.items[k] = v
    end
  else
    print("[vRP] item pack ["..name.."] not found")
  end
end

-- PACKS
load_item_pack("required")
load_item_pack("food")
load_item_pack("drugs")

return cfg
