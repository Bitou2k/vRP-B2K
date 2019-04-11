

local lang = {
  common = {
    welcome = "Bienvenue. Appuyez sur K pour les menus.",
    no_player_near = "~r~Pas de joueur à proximité.",
    invalid_value = "~r~Valeur incorrecte.",
    invalid_name = "~r~Nom incorrect.",
    not_found = "~r~Non trouvé.",
    request_refused = "~r~Requête refusée."
  },
  survival = {
    starving = "Affamé",
    thirsty = "Assoiffé"
  },
  money = {
    display = "<span class=\"symbol\">€</span> {1}",
    bdisplay = "<span class=\"symbol\">€</span> {1}",
    given = "Vous avez donné ~r~{1}€.",
    received = "Vous avez reçu ~g~{1}€.",
    not_enough = "~r~Pas assez d'argent.",
    paid = "Payé ~r~{1}€.",
    give = {
      title = "Donner de l'argent",
      description = "Donner de l'argent au joueur le plus proche.",
      prompt = "Montant à donner:"
    }
  },
  inventory = {
    title = "Inventaire",
    description = "Ouvrir l'inventaire.",
    iteminfo = "({1})<br /><br />{2}<br /><em>{3} kg</em>",
    info_weight = "poids {1}/{2} kg",
    give = {
      title = "Donner",
      description = "Donner un objet au joueur le plus proche.",
      prompt = "Quantité à donner (max {1}):",
      given = "Vous avez donné ~r~{1} ~s~{2}.",
      received = "Vous avez reçu ~g~{1} ~s~{2}.",
    },
    trash = {
      title = "Jeter",
      description = "Jeter un objet.",
      prompt = "Quantité à jeter (max {1}):",
      done = "Jeté ~r~{1} ~s~{2}."
    },
    missing = "~r~Manque {2} {1}.",
    full = "~r~Inventaire plein.",
    chest = {
      title = "Coffre",
      already_opened = "~r~Ce coffre est déjà ouvert par quelqu'un d'autre.",
      full = "~r~Coffre plein.",
      take = {
        title = "Prendre",
        prompt = "Quantité à prendre (max {1}):"
      },
      put = {
        title = "Mettre",
        prompt = "Quantité à mettre (max {1}):"
      }
    }
  },
  atm = {
    title = "Distributeur de billets",
    info = {
      title = "Info",
      bank = "Banque: {1} €"
    },
    deposit = {
      title = "Dépot",
      description = "Déposez de l'argent sur votre compte",
      prompt = "Entrez le montant à déposer:",
      deposited = "Vous avez déposé ~r~{1}€~s~."
    },
    withdraw = {
      title = "Retirer",
      description = "Retirez de l'argent de votre compte",
      prompt = "Entrez le montant à retirer:",
      withdrawn = "Vous avez retiré ~g~{1}€ ~s~.",
      not_enough = "~r~Vous n'avez pas assez d'argent sur votre compte."
    }
  },
  business = {
    title = "Chambre de commerce",
    directory = {
      title = "Annuaire",
      description = "Annuaire des entreprises",
      dprev = "> Précédent",
      dnext = "> Suivant",
      info = "<em>Capital: </em>{1} €<br /><em>Propriétaire: </em>{2} {3}<br /><em>Immatriculation: </em>{4}<br /><em>Téléphone: </em>{5}"
    },
    info = {
      title = "Information sur l'entreprise",
      info = "<em>Nom: </em>{1}<br /><em>Capital: </em>{2} €<br /><em>Capital de transfert: </em>{3} €<br /><br/>Le capital de transfert représente la quantité d'argent transférée pour une période. Le maximum ne peut pas dépasser le capital de l'entreprise."
    },
    addcapital = {
      title = "Ajout de capital",
      description = "Augmentez le capital de votre entreprise.",
      prompt = "Montant à ajouter à votre capital:",
      added = "~r~{1}€ ~s~ ajoutés au capital de votre entreprise."
    },
    launder = {
      title = "Blanchiment d'argent",
      description = "Utilisez votre entreprise pour blanchir de l'argent.",
      prompt = "Montant d'argent sale à blanchir (max {1} €): ",
      laundered = "~g~{1}€ ~s~ blanchis.",
      not_enough = "~r~Pas assez d'argent sale."
    },
    open = {
      title = "Ouvrir une entreprise",
      description = "Ouvrez votre entreprise, le capital minimum est de {1} €.",
      prompt_name = "Nom de l'entreprise (ne peut pas être modifié ultérieurement, maximum {1} chars):",
      prompt_capital = "Capital initial (min {1})",
      created = "~g~Entreprise créée."
      
    }
  },
  cityhall = {
    title = "Hôtel de ville",
    identity = {
      title = "Nouvelle identité",
      description = "Creez une nouvelle identité, frais de création = {1} €.",
      prompt_firstname = "Entrez votre prénom:",
      prompt_name = "Entrez votre nom de famille:",
      prompt_age = "Entrez votre âge:"
    },
    menu = {
      title = "Identité",
      info = "<em>Nom: </em>{1}<br /><em>Prénom: </em>{2}<br /><em>Age: </em>{3}<br /><em>N° d'immatriculation: </em>{4}<br /><em>Téléphone: </em>{5}<br /><em>Adresse: </em>{7}, {6}"
    }
  },
  police = {
    title = "Police",
    wanted = "Recherché rang {1}",
    not_handcuffed = "~r~n'est pas menotter",
    cloakroom = {
      title = "Vestiaire",
      uniform = {
        title = "Uniforme",
        description = "Mettre l'uniforme."
      }
    },
    pc = {
      title = "PC",
      searchreg = {
        title = "Recherche immatriculation",
        description = "Recherche d'identité par immatriculation.",
        prompt = "Entrez l'immatriculation:"
      },
      closebusiness = {
        title = "Fermer l'entreprise",
        description = "Fermer l'entreprise du joueur le plus proche",
        request = "Êtes vous sûr de vouloir fermer l'entreprise {3} gérée par {1} {2} ?",
        closed = "~g~Entreprise fermée."
      },
      trackveh = {
        title = "Localisation de véhicule",
        description = "Localisation de véhicule par immatriculation.",
        prompt_reg = "Entrez l'immatriculation:",
        prompt_note = "Entrez une note ou une raison:",
        tracking = "~b~Localisation commencée.",
        track_failed = "~b~Recherche de {1}~s~ ({2}) ~n~~r~Echouée.",
        tracked = "{1} ({2}) localisé."
		},
      records = {
        show = {
          title = "Voir Dossier",
          description = "Montre le dossier de police par l'immatriculation."
        },
        delete = {
          title = "Néttoyez Dossier",
          description = "Néttoie le dossier de police par l'immatriculation.",
          deleted = "~b~Dossier Néttoyez, plus aucune trâce du dossier."
        }
      }
    },
    menu = {
      handcuff = {
        title = "Menotter",
        description = "Menotter/démenotter le joueur le plus proche."
      },
      putinveh = {
        title = "Mettre dans le véhicule",
        description = "Mettre le joueur le plus proche dans le véhicule le plus proche."
      },
	  getoutveh = {
        title = "Sortir du véhicule",
        description = "Fait sortir le joueur de votre vehicule."
      },
      askid = {
        title = "Demander les papiers",
        description = "Demander les papiers d'identité du joueur le plus proche.",
        request = "Voulez vous montrer vos papiers d'identité ?",
        request_hide = "Fermer les informations d'identité.",
        asked = "Demande des papiers..."
      },
      check = {
        title = "Fouiller le joueur",
        description = "Fouiller l'argent, les objets et les armes du joueur le plus proche.",
        request_hide = "Fermer le rapport de fouille.",
        info = "<em>Argent: </em>{1} €<br /><br /><em>Inventaire: </em>{2}<br /><br /><em>Armes: </em>{3}",
        checked = "Vous avez été fouillé."
		},
      seize = {
        seized = "Saisie {2} ~r~{1}",
        weapons = {
          title = "Saisir Armes",
          description = "Saisie les armes du joueur le plus proche",
          seized = "~b~Vos arme ont été saisie."
        },
        items = {
          title = "Saisir Illegals",
          description = "Saisir les substences illegals",
          seized = "~b~vos substences illegal ont été saisie."
        }
      },
      jail = {
        title = "Emprisonner",
        description = "Emprisone/Libère le joueur le plus proche.",
        not_found = "~r~Aucune prison trouvez.",
        jailed = "~b~emprisonez.",
        unjailed = "~b~libèré.",
        notify_jailed = "~b~Vous avez été emprisonnez.",
        notify_unjailed = "~b~Vous avez été libèré."
      },
      fine = {
        title = "Amende",
        description = "Donne un amende au joueur le plus prêt.",
        fined = "~b~amende ~s~{2} $ pour ~b~{1}.",
        notify_fined = "~b~Vous avez recu un amende de ~s~ {2} $ pour ~b~{1}.",
        record = "[Amende] {2} $ de {1}"
      },
      store_weapons = {
        title = "Rangez Armes",
        description = "Range les armes dans votre inventaire. (Peux causez un inventaire plein)"
      }
    },
    identity = {
      info = "<em>Nom: </em>{1}<br /><em>Prénom: </em>{2}<br /><em>Age: </em>{3}<br /><em>N° d'immatriculation: </em>{4}<br /><em>Téléphone: </em>{5}<br /><em>Entreprise: </em>{6}<br /><em>Capital de l'entreprise: </em>{7} €<br /><em>Adresse: </em>{9}, {8}"
    }
  },
  emergency = {
    menu = {
      revive = {
        title = "Réanimer",
        description = "Réanimer le joueur le plus proche.",
        not_in_coma = "~r~Le joueur n'est pas dans le coma."
      }
    }
  },
  phone = {
    title = "Téléphone",
    directory = {
      title = "Répertoire",
      description = "Ouvrir le Répertoire.",
      add = {
        title = "> Ajouter",
        prompt_number = " Entrez le n° de téléphone à ajouter:",
        prompt_name = "Entrez un nom associé au n° de téléphone:",
        added = "~g~N° de téléphone ajouté."
      },
      sendsms = {
        title = "Envoyer un SMS",
        prompt = " Entrez le message à envoyer (max {1} chars):",
        sent = "~g~ Envoyé au n°{1}.",
        not_sent = "~r~ n°{1} non disponible."
      },
      sendpos = {
        title = "Envoi de la position",
      },
      remove = {
        title = "Supprimer"
      }
    },
    sms = {
      title = "Historique des SMS",
      description = "Historique des SMS reçus.",
      info = "<em>{1}</em><br /><br />{2}",
      notify = "SMS~b~ {1}:~s~ ~n~{2}"
    },
    smspos = {
      notify = "SMS-Position ~b~ {1}"
    },
    service = {
      title = "Service",
      description = "Appelez un service ou un n° d'urgence.",
      prompt = "Si besoin, entrez un message pour le service:",
      ask_call = "Reception d'un appel ({1}), voulez vous le prendre ? <em>{2}</em>",
      taken = "~r~Cet appel est déjà pris."
	  },
    announce = {
      title = "Publicité",
      description = "Envoie un annonce a tous les joueurs.",
      item_desc = "{1} $<br /><br/>{2}",
      prompt = "Contenu de l'annonce (10-1000 chars): "
    }
  },
  emotes = {
    title = "Emotes",
    clear = {
      title = "> Arrêter",
      description = "Arrête toutes les emotes en cours."
    }
  },
  home = {
    buy = {
      title = "Acheter",
      description = "Acheter un logement ici, le prix est {1} €.",
      bought = "~g~Acheté.",
      full = "~r~Plus de place.",
      have_home = "~r~Vous avez déjà un logement."
    },
    sell = {
      title = "Vendre",
      description = "Vendre son logement pour {1} €",
      sold = "~g~vendu.",
      no_home = "~r~Vous n'avez pas de logement ici."
    },
    intercom = {
      title = "Interphone",
      description = "Utiliser l'interphone pour entrer dans un logement.",
      prompt = "Numéro:",
      not_available = "~r~Indisponible.",
      refused = "~r~Entrée refusée.",
      prompt_who = "Dites qui vous êtes:",
      asked = "Demande...",
      request = "Quelqu'un veut rentrer dans votre logement: <em>{1}</em>"
    },
    slot = {
      leave = {
        title = "Sortir"
      },
      ejectall = {
        title = "Expulser",
        description = "Expulse tous les visiteurs, même vous, et ferme le logement."
      }
    }
  },
  garage = {
    title = "Garage ({1})",
    owned = {
      title = "Mes Vehicules",
      description = "Les vehicule m'appartenant."
    },
    buy = {
      title = "Acheter",
      description = "Achetez un vehicule.",
      info = "{1} $<br /><br />{2}"
    },
    sell = {
      title = "Vendre",
      description = "Vendre le vehicule."
    },
    rent = {
      title = "Louer",
      description = "Louer le vehicule jusqu'a la fin de la connections."
    },
    store = {
      title = "Ranger Vehicule",
      description = "Ranger le vehicule dans le garage."
    }
  },
vehicle = {
    title = "Véhicule",
    no_owned_near = "~r~Pas de véhicule vous appartenant à proximité.",
    trunk = {
      title = "Coffre",
      description = "Ouvrir le coffre du véhicule."
    },
    detach_trailer = {
      title = "Détacher remorque",
      description = "Détacher la remorque."
	  },
    detach_towtruck = {
      title = "Detacher le vehicule",
      description = "Detache le vehicule."
    },
    detach_cargobob = {
      title = "Detacher le cargo",
      description = "Detach le cargo."
    },
    lock = {
      title = "Vérouille/Déverouille",
      description = "Vérouille ou Déverouille votre vehicule."
    },
    engine = {
      title = "Moteur On/Off",
      description = "Démarre ou arrête votre moteur."
    },
    asktrunk = {
      title = "Demandez d'ouvrir le coffre",
      asked = "~g~Demande...",
      request = "Voulez-vous ouvrir le coffre ?"
    },
    replace = {
      title = "Déplacé vehicule(Usage de manière RP)",
      description = "Replace le vehicule au sol."
    },
    repair = {
      title = "Réparé vehicule",
      description = "Répare le vehicule"
    }
  },
  gunshop = {
    title = "Magasin d'armes ({1})",
    prompt_ammo = "Quantité de munition à acheter pour {1}:",
    info = "<em>Arme: </em> {1} €<br /><em>Munition: </em> {2} €/u<br /><br />{3}"
  },
  market = {
    title = "Supérette ({1})",
    prompt = "Quantité de {1} à acheter:",
    info = "{1} €<br /><br />{2}"
  },
  skinshop = {
    title = "Magasin de vêtements"
  },
  itemtr = {
    informer = {
      title = "Informateur illégal",
      description = "{1} €",
      bought = "~g~Position envoyée au GPS."
    }
  },
  items = {
    dirty_money = {
      title = "Argent sale",
      description = "Argent obtenu illégalement."
    },
    medkit = {
      title = "Kit Médical",
      description = "Utilisé pour réanimer des personnes inconscientes."
	  }
  },
    mission = {
    blip = "Mission ({1}) {2}/{3}",
    display = "<span class=\"name\">{1}</span> <span class=\"step\">{2}/{3}</span><br /><br />{4}",
    cancel = {
      title = "Arrêté la mission"
    }
  },
    aptitude = {
    title = "Aptitudes",
    description = "Montre les aptitude joueur.",
    lose_exp = "Aptitude ~b~{1}/{2} ~r~-{3} ~s~exp.",
    earn_exp = "Aptitude ~b~{1}/{2} ~g~+{3} ~s~exp.",
    level_down = "Aptitude ~b~{1}/{2} ~r~perte de level ({3}).",
    level_up = "Aptitude ~b~{1}/{2} ~g~le level monte ({3}).",
    display = {
    group = "{1}: ",
    aptitude = "--- {1} | exp {2} | lvl {3} | progression {4}%"
    }
  }
}

return lang
