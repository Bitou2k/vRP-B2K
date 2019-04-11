
-- gui config file

local cfg = {}

-- additional css loaded to customize the gui display (see gui/design.css to know the available css elements)
-- it is not recommended to modify the vRP core files outside the cfg/ directory, create a new resource instead
-- you can load external images/fonts/etc using the NUI absolute path: nui://my_resource/myfont.ttf
-- example, changing the gui font (suppose a vrp_mod resource containing a custom font)
cfg.css = [[
@font-face {
  font-family: "Custom Font";
  src: url(nui://vrp_mod/customfont.ttf) format("truetype");
}

body{
  font-family: "Custom Font";
}
]]

-- list of static menu types (map of name => {.title,.blipid,.blipcolor,.permissions (optional)})
-- static menus are menu with choices defined by vRP.addStaticMenuChoices(name, choices)
cfg.static_menu_types = {
  ["police_weapons"] = {
    title = "Arsenal", 
    permissions = {"police.base"}
  },
  ["federal_weapons"] = {
    title = "Arsenal", 
    permissions = {"federal.weapons"}
  },
  
  ["emergency_heal"] = {
    title = "Atendimento Médico"
  },
  ["tribunal_e"] = { 
    title = "Tribunal"
  },
  ["tribunal_s"] = { 
    title = "Tribunal"
  },
  ["tribunal_lobbye"] = { 
    title = "Tribunal"
  },
  ["tribunal_lobbys"] = { 
    title = "Tribunal"
  },
  ["mina_entrada"] = {
    title = "Mina"
  },
  ["mina_saida"] = {
    title = "Mina"
  },
  
  ["federal_entrada"] = { 
    title = "Polícia Federal"
  },
  ["federal_saida"] = {
    title = "Polícia Federal"
  },
  ["federal_entrada_heli"] = { 
    title = "Polícia Federal"
  },
  ["federal_saida_heli"] = {
    title = "Polícia Federal"
  },
  
  ["lavagem_entrada"] = { 
    title = "Fábrica de Dinheiro"
  },
  ["lavagem_saida"] = {
    title = "Fábrica de Dinheiro"
  },
  ["weed_entrada"] = { 
    title = "Plantação de Maconha"
  },
  ["weed_saida"] = {
    title = "Plantação de Maconha"
  },
  --["meth_entrada"] = { 
  --  title = "Fábrica de Metanfetamina"
  --},
  --["meth_saida"] = {
  --  title = "Fábrica de Metanfetamina"
  --},
  ["cocaine_entrada"] = { 
    title = "Fábrica de Cocaina"
  },
  ["cocaine_saida"] = {
    title = "Fábrica de Cocaina"
  },
  
  ["bahamas_entrada"] = { 
    title = "Bahamas Club"
  },
  ["bahamas_saida"] = {
    title = "Bahamas Club"
  },
  ["hospheli_entrada"] = { 
    title = "Heli Samu"
  },
  ["hospheli_saida"] = {
    title = "Heli Samu"
  },
  ["b2knewsheli_entrada"] = { 
    title = "Heli B2K News"
  },
  ["b2knewsheli_saida"] = {
    title = "Heli B2K News"
  },
  ["lsquarto01_entrada"] = { 
    title = "Quarto 01"
  },
  ["lsquarto01_saida"] = {
    title = "Quarto 01"
  },
  ["sicimembros_entrada"] = {
    title = "Membros Siciliana",
    permissions = {"siciliana.membros"}
  },
  ["sicimembros_saida"] = {
    title = "Membros Siciliana", 
    permissions = {"siciliana.membros"}
  },
  ["siciarmas_entrada"] = {
    title = "Armas Siciliana",
    permissions = {"siciliana.membros"}
  },
  ["siciarmas_saida"] = {
    title = "Armas Siciliana", 
    permissions = {"siciliana.membros"}
  },
  ["pripatio_entrada"] = {
    title = "Prisao Patio",
  },
  ["pripatio_saida"] = {
    title = "Prisao Patio", 
  },
  ["priacad_entrada"] = {
    title = "Prisao Academia",
  },
  ["priacad_saida"] = {
    title = "Prisao Academia", 
  },
  ["yazukamem_entrada"] = {
    title = "Yakuza Membros",
    permissions = {"yakuza.membros"}
  },
  ["yazukamem_saida"] = {
    title = "Yakuza Membros",
    permissions = {"yakuza.membros"}
  }
}

-- list of static menu points
cfg.static_menus = {
  {"police_weapons", 461.39645385742,-982.65185546875,30.689596176147},
  {"federal_weapons", 470.11422729492,-1085.91015625,38.706508636475},
  {"emergency_heal", 307.73468017578,-594.71624755859,43.291797637939},
  {"tribunal_e", 233.23551940918,-410.48593139648,48.11194229126}, 
  {"tribunal_s",236.01475524902,-413.36260986328,-118.16348266602},
  {"tribunal_lobbye", 225.11094665527,-419.61151123047,-118.1996383667}, 
  {"tribunal_lobbys",238.80630493164,-334.22885131836,-118.77348327637},
  --{"oab_entrada", 155.37397766113,-1103.2545166016,29.323266983032},
  --{"oab_saida", 155.01602172852,-1108.9591064453,37.183734893799},
  
  
  {"mina_entrada", -596.86285400391,2090.830078125,131.41278076172},
  {"mina_saida", -595.21545410156,2085.802734375,131.38134765625},
  
  {"federal_entrada", 416.05096435547,-1086.2639160156,30.057842254639}, 
  {"federal_saida", 467.77380371094,-1097.7532958984,38.706531524658},
  {"federal_entrada_heli", 471.49169921875,-1089.7761230469,38.706504821777}, 
  {"federal_saida_heli", 484.60437011719,-1094.1079101563,43.075649261475},
  
  {"lavagem_entrada", 858.64544677734,-3203.6105957031,5.9949970245361}, 
  {"lavagem_saida", 1138.1552734375,-3198.5004882813,-39.665687561035},
  
  {"weed_entrada",2564.1904296875,4680.482421875,34.076770782471},
  {"weed_saida",1064.9476318359,-3183.3408203125,-39.163444519043},
  --{"meth_entrada", 1454.46875,-1651.9616699219,66.99479675293},
  --{"meth_saida", 997.3916015625,-3200.63671875,-36.393688201904},
  {"cocaine_entrada", 1416.9096679688,6339.8159179688,24.189083099365},
  {"cocaine_saida", 1088.6865234375,-3188.0783691406,-38.993461608887},
  
  --{"yakuza_entrada", -871.18719482422,-1440.8928222656,7.5268039703369},
  --{"yakuza_saida", -893.39910888672,-1446.291015625,7.5268030166626},
  
  --{"siciliana_entrada",-2679.4125976563,1316.6683349609,152.0094909668},
  --{"siciliana_saida",-2673.47265625,1336.3385009766,140.88259887695}
  {"hospheli_saida",339.2073059082,-584.13525390625,74.165672302246},
  {"hospheli_entrada",325.24520874023,-598.69177246094,43.291786193848},
  
  {"b2knewsheli_entrada",-598.76416015625,-929.82464599609,23.86349105835},
  {"b2knewsheli_saida",-569.37023925781,-927.76025390625,36.833557128906},
  
  {"bahamas_entrada",-1388.7598876953,-586.23864746094,30.21915435791},
  {"bahamas_saida",-1387.2572021484,-588.40148925781,30.319505691528},
  
  {"lsquarto01_entrada", 1398.3591308594,1157.0681152344,114.33364868164},
  {"lsquarto01_saida", 151.6649017334,-1007.326171875,-99.0},

  {"sicimembros_entrada",-2678.5578613282,1307.7283935546,147.16165161132},
  {"sicimembros_saida",-2679.6118164062,1315.1262207032,147.44288635254},
  {"siciarmas_entrada",-2679.6271972656,1319.2336425781,152.00950622559},
  {"siciarmas_saida",-2673.2407226563,1336.4757080078,140.88262939453},

  {"pripatio_entrada",1724.8452148438,2648.7521972656,45.784439086914},
  {"pripatio_saida",1712.1800537109,2565.8725585938,45.564868927002},

  {"priacad_entrada",1644.2642822266,2518.2768554688,45.56485748291},
  {"priacad_saida",1642.4438476562,2518.6975097656,45.56485748291},

  {"yazukamem_entrada",-876.830078125,-1454.7742919922,7.5267992019653},
  {"yazukamem_saida",-874.87939453125,-1454.2927246094,7.5268068313599},

}

return cfg
