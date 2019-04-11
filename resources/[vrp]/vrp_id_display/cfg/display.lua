--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

cfg = {}
cfg.showself = true -- True: shows your own id and blip
cfg.distance = 4 -- Max distance for id

cfg.default = {r = 255, g = 255, b = 255} -- Colors for default id
cfg.talker = {r = 255, g = 201, b = 14} -- Colors for talker id

cfg.showteam = false -- True: shows team colored id to everyone, not just team members
cfg.hideteam = true -- True: hides team colored id to everyone, make them use the cfg.default color for id
cfg.blips = { -- Groups blip display (set the teams in cfg/blips.lua)
  ["police"] = {
    id = {r = 70, g = 100, b = 200}, -- Colors for group id and vrp_cmd team chat color
  	sprite = 1, -- Sprite for group blip
  	colour = 29, -- Colour for group blip
  	distance = 200 -- Max distance for group blip
  },
  ["emergency"] = {
    id = {r = 255, g = 100, b = 85},
  	sprite = 1,
  	colour = 1,
  	distance = 300
  },
}

cfg.drawCircleDist = 13
cfg.drawtype = 25
cfg.drawComatype = 21
cfg.drawComascalex = 0.4
cfg.drawComascaley = 0.4
cfg.drawComascalez = 0.4
cfg.drawscalex = 0.7
cfg.drawscaley = 0.7
cfg.drawscalez = 0.7
cfg.drawred = 255--0
cfg.drawgreen = 255--232
cfg.drawblue = 255--162
cfg.drawredtalk = 255
cfg.drawgreentalk = 201
cfg.drawbluetalk = 14

cfg.teams = { -- Only one team for each group, you can set multiple teams, groups on same team will see each other's blips
  ["COPS"] = { -- Team name must be unique
    -- groups
    "police",
    "sheriff"
  },
  -- create more teams here
}

return cfg

-- Link for blip colours: http://i.imgur.com/Hvyx6cE.png
-- Link for blip sprites: https://marekkraus.sk/gtav/blips/list.html