
local cfg = {}

-- define the first spawn position/radius of the player (very first spawn on the server, or after death)
cfg.spawn_enabled = true -- set to false to disable the feature
cfg.spawn_position = {-1041.7530517578,-2744.6650390625,21.359392166138} 
cfg.spawn_death = {281.68014526368,-584.81689453125,43.291759490966}
cfg.spawn_radius = 1

-- customization set when spawning for the first time
-- see https://wiki.fivem.net/wiki/Peds
-- mp_m_freemode_01 (male)
-- mp_f_freemode_01 (female)
cfg.default_customization = {
  model = "mp_m_freemode_01" 
}

-- init default ped parts
for i=0,19 do
  cfg.default_customization[i] = {0,0}
end

cfg.default_customization[2] = {2,4} -- hair / texture
cfg.default_customization[4] = {0,15} -- leg / texture
cfg.default_customization[6] = {5,0} -- shoes
cfg.default_customization[8] = {57,0} -- undershit - camiseta / texture
cfg.default_customization[11] = {97,0} -- tops - jaqueta / texture

cfg.clear_phone_directory_on_death = false
cfg.lose_aptitudes_on_death = true

return cfg