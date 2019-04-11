
local cfg = {}

-- minimum capital to open a business
cfg.minimum_capital = 1000000000000000

-- capital transfer reset interval in minutes
-- default: reset every 24h
cfg.transfer_reset_interval = 24*60

-- commerce chamber {blipid,blipcolor}
cfg.blip = {431,70}

-- positions of commerce chambers
cfg.commerce_chambers = {
	--{-1081.9671630859,-247.8620300293,37.763298034668}
}

return cfg
