
local cfg = {}

cfg.inventory_weight_per_strength = 10 -- weight for an user inventory per strength level (no unit, but thinking in "kg" is a good norm)

-- default chest weight for vehicle trunks
cfg.default_vehicle_chest_weight = 120

-- define vehicle chest weight by model in lower case
cfg.vehicle_chest_weights = {
  ["monster"] = 250,
  ["akuma"] = 75,
  ["avarus"] = 75,
  ["bagger"] = 100,
  ["bati"] = 75,
  ["bati2"] = 75,
  ["bf400"] = 75,
  ["carbonrs"] = 75,
  ["chimera"] = 75,
  ["cliffhanger"] = 75,
  ["daemon"] = 75,
  ["daemon2"] = 75,
  ["defiler"] = 75,
  ["diablous"] = 75,
  ["diablous2"] = 75,
  ["double"] = 75,
  ["enduro"] = 75,
  ["esskey"] = 75,
  ["faggio"] = 75,
  ["faggio2"] = 75,
  ["faggio3"] = 75,
  ["fcr"] = 75,
  ["fcr2"] = 75,
  ["gargoyle"] = 75,
  ["hakuchou"] = 75,
  ["hakuchou2"] = 75,
  ["hexer"] = 75,
  ["innovation"] = 75,
  ["innovation"] = 75,
  ["lectro"] = 75,
  ["manchez"] = 75,
  ["nemesis"] = 75,
  ["nightblade"] = 75,
  ["oppressor"] = 75,
  ["pcj"] = 75,
  ["ratbike"] = 75,
  ["ruffian"] = 75,
  ["sanchez"] = 30,
  ["sanchez2"] = 75,
  ["sanctus"] = 75,
  ["shotaro"] = 75,
  ["sovereign"] = 75,
  ["thrust"] = 75,
  ["vader"] = 75,
  ["vindicator"] = 75,
  ["vortex"] = 75,
  ["wolfsbane"] = 75,
  ["zombiea"] = 75,
  ["zombieb"] = 75,
  ["panto"] = 80,
  ["riata"] = 200,
  ["kamacho"] = 200,

  ["seminole"] = 160,
  ["bjxl"] = 160,
  ["baller"] = 160,
  ["gresley"] = 160,
  ["patriot"] = 160,
  ["baller2"] = 160,
  ["radi"] = 160,
  ["rocoto"] = 160,
  ["baller2"] = 160,
}

-- list of static chest types (map of name => {.title,.blipid,.blipcolor,.weight, .permissions (optional)})
cfg.static_personal_chest_types = {
  ["baupessoal"] = { -- example of a static chest
    id = "baupessoal",
    title = "Baú Pessoal",
    blipid = 50,
    blipcolor = 6,
    weight = 70
  },
  ["sicilianabau"] = { -- example of a static chest
    id = "sicilianabau",
    title = "Siciliana Baú",
    permissions = {"siciliana.bau"},
    weight = 800
  },
  ["yakuzabau"] = {
    id = "yakuzabau",
    title = "Yakuza Baú",
    permissions = {"yakuza.bau"},
    weight = 800
  }
}

-- list of static chest points
cfg.static_personal_chests = {
  {"baupessoal", -1603.765625,-831.6318359375,10.070781707764},
  {"sicilianabau", -2675.0712890625,1329.8322753906,140.88255310059},
  {"yakuzabau", -867.52136230469,-1457.8796386719,7.5268054008484}
}

return cfg
