
local cfg = {}

-- city hall position
cfg.city_hall =	{-1045.6138916016,-2751.2299804688,21.363447189331}

-- cityhall blip {blipid,blipcolor}
cfg.blip = {416,4}

-- cost of a new identity
cfg.new_identity_cost = 30000

-- phone format (max: 20 chars, use D for a random digit)
cfg.phone_format = "DDDD-DDDD"
-- cfg.phone_format = "06DDDDDDDD" -- another example for cellphone in France
-- rg format
cfg.rg_format = "DDLLLDDD"
-- (ex: DDDLLL, D => digit, L => letter)

-- config the random name generation (first join identity)
-- (I know, it's a lot of names for a little feature)
-- (cf: http://names.mongabay.com/most_common_surnames.htm)
cfg.random_first_names = {
  "Sem"
}

cfg.random_last_names = {
  "Nome"
}

return cfg
