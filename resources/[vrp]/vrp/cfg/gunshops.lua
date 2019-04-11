
local cfg = {}
-- list of weapons for sale
-- for the native name, see https://wiki.fivem.net/wiki/Weapons (not all of them will work, look at client/player_state.lua for the real weapon list)
-- create groups like for the garage config
-- [native_weapon_name] = {display_name,body_price,ammo_price,description}
-- ammo_price can be < 1, total price will be rounded

-- _config: blipid, blipcolor, permissions (optional, only users with the permission will have access to the shop)

cfg.gunshop_types = {
  ["Ammunation"] = {
    _config = {blipid=110,blipcolor=75},
    ["ARMOR"] = {"Colete",10000,0,""},
    ["WEAPON_BAT"] = {"Taco de Baseball",2000,0,""},
    ["WEAPON_KNUCKLE"] = {"Soco-Ingles",2500,0,""},
    ["WEAPON_KNIFE"] = {"Faca",1000,0,""},
  	["WEAPON_FLASHLIGHT"] = {"Lanterna",1000,0,""},
  	["WEAPON_GOLFCLUB"] = {"Taco de Golf",2500,0,""},
    ["WEAPON_PISTOL"] = {"Pistola 9mm",20000,45,""},

    ["WEAPON_HAMMER"] = {"Martelo", 1000, 0, ""},
    ["WEAPON_CROWBAR"] = {"Pé de Cabra", 1000, 0, ""},
    ["WEAPON_HATCHET"] = {"Martelo", 1000, 0, ""},
    ["WEAPON_DAGGER"] = {"Adaga", 1000, 0, ""},
    ["WEAPON_MACHETE"] = {"Facão", 1000, 0, ""},
    ["WEAPON_BOTTLE"] = {"Garrafa", 1000, 0, ""},

    --["WEAPON_PUMPSHOTGUN"] = {"Shotgun",25000,70,""},
  },
  --[[["Loja da Biqueira"] = {
    _config = {blipid=150,blipcolor=1},
    ["WEAPON_ASSAULTRIFLE"] = {"Rifle AK-47",150000,115,""},
	["WEAPON_PUMPSHOTGUN"] = {"Shotgun",25000,55,""},
	["WEAPON_SMG"] = {"SMG",60000,85,""},
    ["ARMOR"] = {"Colete",15000,0,""}
  }]]
}
-- list of gunshops positions

cfg.gunshops = {
  --{"Loja da Biqueira", -732.60589599609,544.69494628906,125.18671417236},
  {"Ammunation", 1692.41, 3758.22, 34.7053},
  {"Ammunation", 252.696, -48.2487, 69.941},
  {"Ammunation", 844.299, -1033.26, 28.1949},
  {"Ammunation", -331.624, 6082.46, 31.4548},
  {"Ammunation", -664.147, -935.119, 21.8292},
  {"Ammunation", -1305.964, -394.166, 36.695},
  {"Ammunation", -1119.488, 2697.086, 18.554},
  {"Ammunation", 2569.62, 294.453, 108.735},
  {"Ammunation", -3172.603, 1085.748, 20.838},
  {"Ammunation", 21.70, -1107.41, 29.79},
  {"Ammunation", 810.15, -2156.88, 29.61}
}

return cfg
