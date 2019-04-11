
local cfg = {}

-- PCs positions
cfg.pcs = {
  {441.28457641602,-978.51989746094,30.689605712891}
}
  -- Recruta, Soldado, Cabo [PM]
  -- 3ºSGT, 2ºSGT, 1ºSGT, SubTenente, 2ºTenente, 1ºTenente [FT]
  -- Capitao, Major, Tenente-Coronel, Coronel [RT]
  
-- vehicle tracking configuration
cfg.trackveh = {
  min_time = 300, -- min time in seconds
  max_time = 600, -- max time in seconds
  service = "Recruta [PM]",  -- service to alert when the tracking is successful
  "Soldado [PM]",
  "Cabo [PM]",
  
  "3ºSGT [FT]",
  "2ºSGT [FT]",
  "1ºSGT [FT]",
  "SubTenente [FT]",
  "2ºTenente [FT]",
  "1ºTenente [FT]",

  "Capitao [RT]",
  "Major [RT]",
  "Tenente-Coronel [RT]",
  "Coronel [RT]"
}

-- wanted display
cfg.wanted = {
  blipid = 458,
  blipcolor = 38,
  service = "Recruta [PM]",  -- service to alert when the tracking is successful
  "Soldado [PM]",
  "Cabo [PM]",
  
  "3ºSGT [FT]",
  "2ºSGT [FT]",
  "1ºSGT [FT]",
  "SubTenente [FT]",
  "2ºTenente [FT]",
  "1ºTenente [FT]",

  "Capitao [RT]",
  "Major [RT]",
  "Tenente-Coronel [RT]",
  "Coronel [RT]"
}

-- illegal items (seize)
cfg.seizable_items = {
  "dirty_money",
  "weed",
  "benzoilmetilecgonina",
  "anfetamina",
  "seeds",
  "credit",
  "cocaine",
  "metanfetamina",
  "tartaruga",
  "carnetartaruga",
  "carnesilvestre",
  "carnetriturada",
  "pistol_parts",
  "shotgun_parts",
  "smg_parts",
  "ak47_parts"
}

-- jails {x,y,z,radius}
cfg.jails = {
  {459.485870361328,-1001.61560058594,24.914867401123,2.1},
  {459.305603027344,-997.873718261719,24.914867401123,2.1},
  {459.999938964844,-994.331298828125,24.9148578643799,1.6}
}

-- fines
-- map of name -> money
cfg.fines = {
  ["Insult"] = 100,
  ["Speeding"] = 250,
  ["Red Light"] = 250,
  ["Stealing"] = 1000,
  ["Credit Cards - Per Card"] = 1000,
  ["Drugs - Per Drug"] = 2000,
  ["Dirty Money - Per $1000"] = 1500,
  ["Organized crime (low)"] = 10000,
  ["Organized crime (medium)"] = 25000,
  ["Organized crime (high)"] = 50000
}

return cfg
