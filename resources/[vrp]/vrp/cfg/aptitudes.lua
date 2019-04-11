
local cfg = {}

-- exp notes:
-- levels are defined by the amount of xp
-- with a step of 5: 5|15|30|50|75 (by default)
-- total exp for a specific level, exp = step*lvl*(lvl+1)/2
-- level for a specific exp amount, lvl = (sqrt(1+8*exp/step)-1)/2

-- define groups of aptitudes
--- _title: title of the group
--- map of aptitude => {title,init_exp,max_exp}
---- max_exp: -1 for infinite exp
cfg.gaptitudes = {
  ["personagem"] = {
    _title = "Personagem",
    ["strength"] = {"Força Física", 30, 105}
  },
  ["science"] = {
    _title = "Ciências",
    ["chemicals"] = {"Estudo de quimica", 0, -1}, -- example
    ["mathematics"] = {"Estudo de matematica", 0, -1} -- example
  },
  ["hacker"] = {
    _title = "Estudos Computação",
  	["logic"] = {"Lógica de Programação.", 0, -1},
  	["c++"] = {"Linguagem C++.", 0, -1},
  	["lua"] = {"Linguagem LUA.", 0, -1},
  	["hacking"] = {"Hackear.", 0, -1}
  }
}

return cfg
