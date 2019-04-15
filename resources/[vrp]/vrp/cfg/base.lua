
local cfg = {}

-- mysql credentials
cfg.db = {
  host = "192.168.27.100", -- database ip (default is local)
  database = "publicvrpb2k",   -- name of database
  user = "bitou2k",    --  database username
  password = "b33tl3"   -- password of your database
}

cfg.save_interval = 15 -- seconds
cfg.whitelist = true -- enable/disable whitelist
cfg.steamhex = false -- enable/disable steamhex whitelist
cfg.ignore_ip_identifier = true -- This will allow multiple same IP connections (for families etc)

-- delay the tunnel at loading (for weak connections)
cfg.load_duration = 30 -- seconds, player duration in loading mode at the first spawn
cfg.load_delay = 0 -- milliseconds, delay the tunnel communication when in loading mode
cfg.global_delay = 30 -- milliseconds, delay the tunnel communication when not in loading mode

cfg.ping_timeout = 4 -- number of minutes after a client should be kicked if not sending pings


-- SET YOUR LANGUAGE HERE - MAKE SURE IT'S INSIDE THE ""
cfg.lang = "pt-pt" -- en / fr / it / ger / pt / ru / lith / dan / ar / pl / es / swe / fin / cn / ro 
-- English/Français/Italiano/Deutsche/Português/Pусский/Lietuvių/Dansk/العربية/Polskie/Español/Svenska/Suomalainen/中文/Română
cfg.debug = false


return cfg
