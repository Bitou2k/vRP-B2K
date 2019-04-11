local lang = {
  common = {
    welcome = "Pressione K para menu do jogador, e F7 para o tablet.",
    no_player_near = "Nenhum jogador próximo.",
    invalid_value = "Valor Inválido.",
    invalid_name = "Nome Inválido.",
    not_found = "Não encontrado.",
    request_refused = "Solicitação Recusada.",
    wearing_uniform = "Atenção, você está utilizando um Uniforme.",
    not_allowed = "Não autorizado."
  },
  weapon = {
    pistol = "Pistola"
  },
  survival = {
    starving = "Fome",
    thirsty = "Sede"
  },
  money = {
    display = "{1} <span class=\"symbol\">R$</span>",
    given = "Enviado R${1}.",
    received = "Recebido R${1}.",
    not_enough = "Dinheiro insuficiente.",
    paid = "Pago R${1}.",
    give = {
      title = "<img src='nui://vrp/gui/imgs/money.png'/> Enviar Dinheiro",
      description = "Envia dinheiro ao jogador mais proximo.",
      prompt = "Quantidade a enviar:"
    }
  },
  inventory = {
    title = "<img src='nui://vrp/gui/imgs/backpack.png'/> Inventário",
    description = "Abrir Inventário.",
    iteminfo = "({1})<br /><br />{2}<br /><em>{3} kg</em>",
    info_weight = "Peso {1}/{2} kg",
    give = {
      title = "Enviar",
      description = "Envia o Item ao jogador mais proximo.",
      prompt = "Quantidade a Enviar (max {1}):",
      given = "Enviado {1} (x{2}).",
      received = "Recebido {1} (x{2}).",
    },
    trash = {
      title = "Lixo",
      description = "Destruir itens.",
      prompt = "Quantidade para o lixo (max {1}):",
      done = "Jogou fora {1} x~s~{2}."
    },
    missing = "Faltando {1} ({2}).",
    full = "Inventário cheio.",
    chest = {
      title = "Baú",
      already_opened = "Este baú ja está aberto por outra pessoa.",
      full = "Baú cheio.",
      take = {
        title = "Retirar",
        prompt = "Quantidade a Retirar (max {1}):"
      },
      put = {
        title = "Colocar",
        prompt = "Quantidade a Colocar  (max {1}):"
      }
    }
  },
  atm = {
    title = "Caixa Eletrônico",
    info = {
      title = "Saldo",
      bank = "Banco: R${1}"
    },
    deposit = {
      title = "Depositar",
      description = "Depositar dinheiro na sua conta",
      prompt = "Quantidade a Depositar:",
      deposited = "Depositado: R${1}"
    },
    withdraw = {
      title = "Sacar",
      description = "Sacar dinheiro da sua conta",
      prompt = "Quantidade a Sacar:",
      withdrawn = "Saque: R${1}",
      not_enough = "Você não tem esse dinheiro no banco."
    }
  },
  business = {
    title = "Centro de Empresas",
    directory = {
      title = "Diretório",
      description = "Listagem de Empresas.",
      dprev = "> Anterior",
      dnext = "> Seguinte",
      info = "<em>Capital: </em>R${1}<br /><em>Dono: </em>{2} {3}<br /><em>Nº registro: </em>{4}<br /><em>Nº de telefone: </em>{5}"
    },
    info = {
      title = "Informação da Empresa",
      info = "<em>Nome: </em>{1}<br /><em>Capital: </em>{2} $<br /><em>Capital de transferência: </em>R${3}<br /><br/>O Capital de transferência é a quantidade de dinheiro que pode transferir num periodo de tempo, o maximo é o valor do capital do negócio."
    },
    addcapital = {
      title = "Adicionar Capital",
      description = "Adicionar capital ao seu negocio.",
      prompt = "Quantidade a adicionar ao capital:",
      added = "R${1} adicionados ao capital do seu negocio."
    },
    launder = {
      title = "Lavagem de Dinheiro",
      description = "Use o seu negócio para lavar dinheiro sujo.",
      prompt = "Montante de dinheiro sujo para lavagem (max R${1}): ",
      laundered = "Lavado: R${1}",
      not_enough = "Não tem dinheiro sujo suficiente."
    },
    open = {
      title = "Abrir Empresa",
      description = "Abre o seu negócio, o investimento minimo para abrir o seu negócio é de R${1}.",
      prompt_name = "Nome da Empresa (não poderá ser alterado futuramente, maximo de {1} carateres):",
      prompt_capital = "Capital Inicial (min {1})",
      created = "Empresa aberta."
      
    }
  },
  cityhall = {
    title = "Alfândega",
    identity = {
      title = "Nova identidade",
      description = "Para criar uma nova identidade irá custar: R${1}",
      prompt_nome = "Coloque seu nome:",
      prompt_sobrenome = "Coloque seu sobrenome:",
      prompt_age = "Coloque sua idade:",
    },
    menu = {
      title = "<img src='nui://vrp/gui/imgs/id.png'/> Identidade",
      info = "<em>Nome: </em>{1}<br /><em>Sobrenome: </em>{2}<br /><em>Idade: </em>{3}<br /><em>RG: </em>{4}<br /><em>Telefone: </em>{5}<br /><em>Endereço: </em>{7}, {6}<br /><em>Trabalho: </em>{8}"
    }
  },
  police = {
    title = "<img src='nui://vrp/gui/imgs/apm_siren.png'/> Polícia",
    wanted = "Procurado {1}",
    not_handcuffed = "Não algemado",
    cloakroom = {
      title = "Vestuário",
      uniform = {
        title = "Uniforme",
        description = "Vestir uniforme."
      }
    },
    pc = {
      title = "PC",
      searchreg = {
        title = "Procurar cidadão",
        description = "Procurar identificação pelo RG.",
        prompt = "Inserir RG de Cidadão:"
      },
      closebusiness = {
        title = "Fechar Empresa",
        description = "Fechar o negócio do jogador mais proximo.",
        request = "Tem a certeza que deseja fechar o negócio {3} do cidadão {1} {2} ?",
        closed = "Negócio fechado."
      },
      trackveh = {
        title = "Localizar Veiculo",
        description = "Localizar veiculo pelo registo.",
        prompt_reg = "Insira o numero de Registo:",
        prompt_note = "Insira o motivo da Localização:",
        tracking = "Localização iniciada.",
        track_failed = "Localização de {1} ({2}) Falhou.",
        tracked = "Localizado {1} ({2})"
      },
      records = {
        show = {
          title = "Mostrar registo criminal",
          description = "Mostrar registo criminal por RG."
        },
        delete = {
          title = "Limpar registo criminal",
          description = "Limpar registo criminal por RG.",
          deleted = "Registo criminal limpo."
        }
      }
    },
    menu = {
      handcuff = {
        title = "Algemar",
        description = "Algemar/Desalgemar jogador proximo."
      },
      putinveh = {
        title = "Colocar no Veiculo",
        description = "Colocar jogador algemado proximo no veiculo."
      },
      getoutveh = {
        title = "Tirar do veiculo",
        description = "Tirar do veiculo jogador mais proximo.."
      },
      askid = {
        title = "<img src='nui://vrp/gui/imgs/businessman.png'/> Pedir RG",
        description = "Pedir RG do jogador mais proximo.",
        request = "Deseja mostrar a seu RG?",
        request_hide = "Esconder RG.",
        asked = "Pedindo RG..."
      },
      check = {
        title = "Revistar cidadão",
        description = "Revista se o cidadão possui dinheiro, algo no seu inventário e armas ao jogador mais proximo.",
        request_hide = "Esconder revista.",
        info = "<em>Dinheiro: </em>R${1}<br /><br /><em>Inventário: </em>{2}<br /><br /><em>Armas Equipadas: </em>{3}",
        checked = "Você está sendo revistado."
      },
      seize = {
        seized = "Foi aprendido {2} {1}",
        weapons = {
          title = "Confiscar Armas",
          description = "Confisca as armas do jogador mais proximo",
          seized = "Suas armas foram confiscadas."
        },
        items = {
          title = "Confiscar Ilegais",
          description = "Confisca materiais ilegais do jogador mais proximo",
          seized = "Seus itens ilegais foram confiscados."
        }
      },
      jail = {
        title = "Prender Cela",
        description = "Prender/Libertar o jogador mais proximo na cela",
        not_found = "Nenhuma cela encontrada.",
        jailed = "Preso.",
        unjailed = "Libertado.",
        notify_jailed = "Você foi preso",
        notify_unjailed = "Você foi libertado."
      },
      fine = {
        title = "Multar",
        description = "Multar jogador mais proximo.",
        fined = "Multado R${2} por {1}.",
        notify_fined = "Você foi multado, R${2} por {1}.",
        record = "[Multa] R${2} por {1}"
      },
      store_weapons = {
        title = "Guardar armas",
        description = "Guarda as armas no seu inventário."
      }
    },
    identity = {
      info = "<em>Nome: </em>{1}<br /><em>Apelido: </em>{2}<br /><em>Idade: </em>{3}<br /><em>N° de Cidadão: </em>{4}<br /><em>Nº de Telefone: </em>{5}<br /><em>Negócio: </em>{6}<br /><em>Capital do Negócio: </em>{7} $<br /><em>Morada: </em>{9}, {8}"
    }
  },
  emergency = {
    menu = {
      revive = {
        title = "<img src='nui://vrp/gui/imgs/afirst-aid-kit.png'/> Reanimar",
        description = "Reanimar cidadão mais proximo.",
        not_in_coma = "Não está em coma."
      }
    }
  },
  phone = {
    title = "<img src='nui://vrp/gui/imgs/smartphone.png'/> Telefone",
    directory = {
      title = "Contatos",
      description = "Abrir os contatos do telefone.",
      add = {
        title = "<img src='nui://vrp/gui/imgs/add.png'/> Add",
        prompt_number = "Insira o numero de telefone:",
        prompt_name = "Insira o nome do cidadão:",
        added = "Contacto adicionado."
      },
      sendsms = {
        title = "Enviar SMS",
        prompt = "Insira a mensagem (max {1} carateres):",
        sent = "Enviado para n°{1}.",
        not_sent = " N°{1} inválido."
      },
      sendpos = {
        title = "Enviar Localização",
      },
      remove = {
        title = "Apagar"
      }
    },
    sms = {
      title = "Histórico de SMS",
      description = "Histórico de SMS recebidas.",
      info = "<em>{1}</em><br /><br />{2}",
      notify = "SMS {1}: {2}"
    },
    smspos = {
      notify = "SMS-Localização {1}"
    },
    service = {
      title = "Serviços",
      description = "Chamar um serviço comum ou de emergencia.",
      prompt = "Se preciso, insira uma mensagem para o serviço que pediu:",
      ask_call = "Chamado {1} recebido, você quer aceitar? <em>{2}</em>", 
      taken = "Esta chamada ja foi atendida."
    },
    announce = {
      title = "Anunciar",
      description = "Mandar um anuncio para todos os cidadãos por alguns segundos.",
      item_desc = "R${1} <br /><br/>{2}",
      prompt = "O anuncio contem (10-1000 carateres): "
    }
  },
  emotes = {
    title = "<img src='nui://vrp/gui/imgs/man-dancing.png'/> Emotes",
    clear = {
      title = "> Limpar",
      description = "Parar todas as animações."
    }
  },
  home = {
    buy = {
      title = "Comprar",
      description = "Comprar esta casa, o seu preço é R${1}.",
      bought = "Comprado.",
      full = "O Lugar está cheio.",
      have_home = "Você já tem uma casa."
    },
    sell = {
      title = "Vender",
      description = "Vender a sua casa por R${1}.",
      sold = "Vendido.",
      no_home = "Você não tem casa aqui."
    },
    intercom = {
      title = "Interfone",
      description = "Use o interfone para entrar em casa.",
      prompt = "Numero:",
      not_available = "Não Disponível.",
      refused = "Entrada Recusada.",
      prompt_who = "Diga quem você é",
      asked = "Perguntando...",
      request = "Uma pessoa está querendo entrar na sua casa: <em>{1}</em>"
    },
    slot = {
      leave = {
        title = "Sair"
      },
      ejectall = {
        title = "Expulsar todos",
        description = "Expulsar todas as vizitas, incluindo voce, e fechar a casa."
      }
    },
    wardrobe = {
      title = "Vestuário Pessoal",
      save = {
        title = "> Guardar",
        prompt = "Guardar com o nome de:"
      }
    },
    gametable = {
      title = "Mesa de Apostas",
      bet = {
        title = "Iniciar Aposta",
        description = "Aposta com os cidadões mais proximos, o vencedor será escolhido aleatoriamente.",
        prompt = "Valor da Aposta:",
        request = "[APOSTA] Deseja apostar R${1} ?",
        started = "Aposta feita."
      }
    }
  },
  garage = {
    title = "{1}",
    owned = {
      title = "Meus veiculos",
      description = "Lista de carros que comprou."
    },
    buy = {
      title = "Comprar",
      description = "Comprar veiculos novos.",
      info = "{2}<br />Preço: R$ {1}<br />",
	  request = "Tem certeza de que quer comprar este veículo?"
    },
    sell = {
      title = "Vender",
      description = "Vender veiculos seus."
    },
    rent = {
      title = "Alugar",
      description = "Alugar carro para esta sessão (irá perde-lo quando sair da sessão)."
    },
    store = {
      title = "Guardar",
      description = "Guardar veiculo na garagem."
    },
    keys = {
	  title = "<img src='nui://vrp/gui/imgs/car.png'/> Chaves",
	  key = "Chave ({1})",
	  description = "Verifique as chaves do seu veículo",
	  sell = {
	    title = "Vender",
		prompt = "Valor da Oferta:",
	    owned = "Veículo já possuído",
		request = "Você aceita a oferta para comprar um {1} por {2}?",
		description = "Oferta para vender veículo ao jogador mais próximo."
	  }
	},
	personal = {
	  client = {
	    locked = "Veículo trancado",
		unlocked = "Veículo destrancado"
	  },
	  out = "Veículo deste tipo já fora da garagem.",
	  bought = "Veículo enviado para sua garagem",
	  sold = "Veículo vendido",
	  stored = "Veículo guardado",
	  toofar = "Veículo longe demais"
	}
  },
  vehicle = {
    title = "<img src='nui://vrp/gui/imgs/car.png'/> Veículo",
    no_owned_near = "Não existe nenhum veículo seu proximo.",
    trunk = {
      title = "Porta-Malas",
      description = "Abrir o Porta-malas do seu veiculo."
    },
    detach_trailer = {
      title = "Detach Trailer",
      description = "Detach trailer."
    },
    detach_towtruck = {
      title = "Detach Tow truck",
      description = "Detach tow truck."
    },
    detach_cargobob = {
      title = "Detach Cargobob",
      description = "Detach cargobob."
    },
    lock = {
      title = "Travar/Destravar",
      description = "Travar ou Destravar veiculo."
    },
    engine = {
      title = "Motor Ligado/Desligado",
      description = "Ligar ou desligar o motor do veiculo."
    },
    asktrunk = {
      title = "<img src='nui://vrp/gui/imgs/trunk-open.png'/> Solicitar Porta Malas",
      asked = "Solicitando...",
      request = "Deseja abrir o Porta-Malas?"
    },
    replace = {
      title = "Substituir veiculo",
      description = "Substituir veiculo mais proximo."
    },
    repair = {
      title = "<img src='nui://vrp/gui/imgs/car.png'/> Reparar veiculo",
      description = "Reparar veiculo mais proximo."
    }
  },
  gunshop = {
    title = "Loja de armas ({1})",
    prompt_ammo = "Quantidade de munições que deseja comprar {1}:",
    info = "<em>Arma: </em>R$ {1}<br /><em>Munições: </em>R${2}/u<br /><br />{3}"
  },
  market = {
    title = "Loja ({1})",
    prompt = "Quantidade de {1} para comprar:",
    info = "R${1}<br /><br />{2}"
  },
  skinshop = {
    title = "Loja de Roupa"
  },
  cloakroom = {
    title = "Vestuário ({1})",
    undress = {
      title = "> Retirar Uniforme"
    }
  },
  itemtr = {
    informer = {
      title = "Informante Ilegal",
      description = "R${1}",
      bought = "Localização enviada para o seu GPS."
    }
  },
  mission = {
    blip = "Missão ({1}) {2}/{3}",
    display = "<span class=\"name\">{1}</span> <span class=\"step\">{2}/{3}</span><br /><br />{4}",
    cancel = {
      title = "<img src='nui://vrp/gui/imgs/cancel.png'/> Cancelar Missão"
    }
  },
  aptitude = {
    title = "<img src='nui://vrp/gui/imgs/books.png'/> Capacidades, XP e Level",
    description = "Mostrar suas capacidades.",
    lose_exp = "XP {1}/{2} -{3} exp.",
    earn_exp = "XP {1}/{2} +{3} exp.",
    level_down = "XP {1}/{2} baixou de nivel ({3}).",
    level_up = "XP {1}/{2} subiu de nivel ({3}).",
    display = {
      group = "{1}: ",
      aptitude = "{1} LVL {3} EXP {2}"
    }
  },
  userlist = {
    id = "ID",
	nickname = "Nick",
	rpname = "Nome no RP",
	job = "Emprego"
  }
}

return lang
