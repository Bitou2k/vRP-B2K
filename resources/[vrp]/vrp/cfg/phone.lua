
local cfg = {}

-- size of the sms history
cfg.sms_history = 15

-- maximum size of an sms
cfg.sms_size = 300

-- duration of a sms position marker (in seconds)
cfg.smspos_duration = 150

-- define phone services
-- blipid, blipcolor (customize alert blip)
-- alert_time (alert blip display duration in seconds)
-- alert_permission (permission required to receive the alert)
-- alert_notify (notification received when an alert is sent)
-- notify (notification when sending an alert)
cfg.services = {
  ["Policia"] = {
    blipid = 304,
    blipcolor = 38,
    alert_time = 150, -- 5 minutes
    alert_permission = "police.base",
    alert_notify = "~r~[COPOM]:~n~~s~",
    notify = "~b~Você chamou a policia.",
    answer_notify = "~b~A Policia está a caminho."
  },
  ["Samu"] = {
    blipid = 153,
    blipcolor = 1,
    alert_time = 150, -- 5 minutes
    alert_permission = "emergency.service",
    alert_notify = "~r~Resgate:~n~~s~",
    notify = "~b~Você chamou o Samu.",
    answer_notify = "~b~O Samu estão a caminho."
  },
  ["Taxi"] = {
    blipid = 198,
    blipcolor = 5,
    alert_time = 150,
    alert_permission = "taxi.service",
    alert_notify = "~y~Alerta Taxi:~n~~s~",
    notify = "~y~Você chamou um Taxi.",
    answer_notify = "~y~Um Taxi esta a caminho."
  },
  ["Entregador"] = {
    blipid = 198,
    blipcolor = 5,
    alert_time = 150,
    alert_permission = "entregador.service",
    alert_notify = "~y~[Entrega]:~n~~s~",
    notify = "~y~Você pediu um iFood.",
    answer_notify = "~y~O Entregador ja esta chegando."
  },  
  ["Mecanico"] = {
    blipid = 446,
    blipcolor = 5,
    alert_time = 150,
    alert_permission = "repair.service",
    alert_notify = "~y~Chamado:~n~~s~",
    notify = "~y~Você chamou um mecanico.",
    answer_notify = "~y~Um mecanico esta a caminho."
  },
  ["Advogado"] = {
    blipid = 76,
    blipcolor = 3,
    alert_time = 150,
    alert_permission = "advogado.service",
    alert_notify = "~y~[Advogado]:~n~~s~",
    notify = "~y~Você solicitou um Advogado.",
    answer_notify = "~y~O Advogado está a caminho."
  }
}

-- define phone announces
-- image: background image for the announce (800x150 px)
-- price: amount to pay to post the announce
-- description (optional)
-- permission (optional): permission required to post the announce
cfg.announces = {
  ["admin"] = {
    image = "http://i.imgur.com/kjDVoI6.png",
    price = 0,
    description = "Admin only.",
    permission = "admin.announce"
  },
  ["reporter"] = {
    image = "http://i.imgur.com/r8NSIJs.png",
    price = 0,
    description = "Somente Reporter.",
    permission = "report.announce"
  },
  ["police"] = {
    image = "http://i.imgur.com/DY6DEeV.png",
    price = 0,
    description = "Only for police, ex: wanted advert.",
    permission = "police.base"
  },
  ["commercial"] = {
    image = "http://i.imgur.com/b2O9WMa.png",
    description = "Commercial stuff (buy, sell, work).",
    price = 5000
  },
  ["party"] = {
    image = "http://i.imgur.com/OaEnk64.png",
    description = "Organizing a party ? Let everyone know the rendez-vous.",
    price = 5000
  }
}

return cfg
