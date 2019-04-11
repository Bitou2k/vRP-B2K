
-- this file configure the cloakrooms on the map

local cfg = {}

-- prepare surgeries customizations
local surgery_male = { model = "mp_m_freemode_01" }
local surgery_female = { model = "mp_f_freemode_01" }

--local femalecop = { model = "S_F_Y_Cop_01" }

local federal01 = { model = "s_m_y_blackops_01" }
local federal02 = { model = "s_m_y_swat_01" }

local rota01 = { model = "rota01" }
local rota02 = { model = "rota02" }
local rota03 = { model = "rota03" }
local rota04 = { model = "rota04" }
local ft01 = { model = "ft01" }
local ft02 = { model = "ft02" }
local ft03 = { model = "ft03" }
local ft04 = { model = "ft04" }
local rp01 = { model = "rp01" }
local rp02 = { model = "rp02" }
local rp03 = { model = "rp03" }
local rp04 = { model = "rp04" }
local rocam01 = { model = "rocam01" }
local rocam02 = { model = "rocam02" }
local rocam03 = { model = "rocam03" }
local rocam04 = { model = "rocam04" }
local piloto = { model = "piloto" }

for i=0,19 do
	surgery_female[i] = {0,0}
	surgery_male[i] = {0,0}

	-- PM
	federal01[i] = {0,0}
	federal02[i] = {0,0}
	rota01[i] = {0,0}
	rota02[i] = {0,0}
	rota03[i] = {0,0}
	rota04[i] = {0,0}
	ft01[i] = {0,0}
	ft02[i] = {0,0}
	ft03[i] = {0,0}
	ft04[i] = {0,0}
	rp01[i] = {0,0}
	rp02[i] = {0,0}
	rp03[i] = {0,0}
	rp04[i] = {0,0}
	rocam01[i] = {0,0}
	rocam02[i] = {0,0}
	rocam03[i] = {0,0}
	rocam04[i] = {0,0}
	piloto[i] = {0,0}
  
end

-- Male Initial
surgery_male[2] = {2,4} -- hair / texture
surgery_male[3] = {0,0} -- upper body gloves / texture
surgery_male[4] = {0,15} -- leg / texture
surgery_male[5] = {0,0} -- parachute
surgery_male[6] = {5,0} -- shoes
surgery_male[8] = {57,0} -- undershit - camiseta / texture
surgery_male[11] = {97,0} -- tops - jaqueta / texture

-- Female Initial
surgery_female[0] = {33,0} -- hair / texture
surgery_female[2] = {4,3} -- hair / texture
surgery_female[3] = {0,0} -- upper body gloves / texture
surgery_female[4] = {31,0} -- leg / texture
surgery_female[5] = {0,0} -- parachute
surgery_female[6] = {5,0} -- shoes
surgery_female[8] = {6,0} -- undershit - camiseta / texture
surgery_female[11] = {49,0} -- tops - jaqueta / texture

cfg.defaultMale = surgery_male
cfg.defaultFemale = surgery_female
-- cloakroom types (_config, map of name => customization)
--- _config:
---- permissions (optional)
---- not_uniform (optional): if true, the cloakroom will take effect directly on the player, not as a uniform you can remove
cfg.cloakroom_types = {
  ["Radio Patrulha"] = {
    _config = { permissions = {"police.base" } },
    ["Radio Patrulha 01"] = rp01,
    ["Radio Patrulha 02"] = rp04,
    ["Radio Patrulha 03"] = rp02,
    ["Radio Patrulha 04"] = rp03
  },
  ["ROCAM"] = {
    _config = { permissions = {"police.base" } },
    ["Rocam 01"] = rocam01,
    ["Rocam 02"] = rocam02,
    ["Rocam 03"] = rocam03,
    ["Rocam 04"] = rocam04,
	--["Patrulha Feminina"] = femalecop
    ["Piloto"] = piloto,
	
  },
  ["ROTA"] = {
    _config = { permissions = {"police.base" } },
    ["Masculino 01"] = rota01,
    ["Masculino 02"] = rota02,
    ["Masculino 03"] = rota03,
    ["Masculino 04"] = rota04	
  },
  ["FT"] = {
    _config = { permissions = {"police.base" } },
    ["Masculino 01"] = ft01,
    ["Masculino 02"] = ft02,
    ["Masculino 03"] = ft03,
    ["Masculino 04"] = ft04
  },
  ["Federal"] = {
    _config = { permissions = {"federal.cloakroom" } },
    ["Farda 01"] = federal01,
    ["Farda 02"] = federal02
  },
  ["Troca Sexo"] = {
    _config = { not_uniform = true },
    ["Male"] = surgery_male,
    ["Female"] = surgery_female
  },
}

cfg.cloakrooms = {
  {"Radio Patrulha", 458.3005065918,-990.93511962891,30.689601898193},
  {"ROCAM",456.34713745117,-990.93511962891,30.689601898193},  
  {"ROTA",454.34713745117,-990.93511962891,30.689601898193},
  {"FT",452.34713745117,-990.93511962891,30.689601898193},  
  {"Federal",474.1796875,-1085.8166503906,38.706508636475},
  {"Troca Sexo", -1044.1293945313,-2748.8293457031,21.363422393799},
  {"Samu", 325.20159912109,-582.50323486328,43.317405700684},
}

return cfg