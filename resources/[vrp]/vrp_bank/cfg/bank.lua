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

cfg.blips = true -- enable blips

cfg.seconds = 600 -- seconds to rob

cfg.cooldown = 7200 -- time between robbaries

cfg.cops = 4 -- minimum cops online
cfg.permission = "bank.police" -- permission given to cops

cfg.banks = { -- list of banks
	-- ["fleeca"] = {
	-- 	position = { ['x'] = 147.04908752441, ['y'] = -1044.9448242188, ['z'] = 29.36802482605 },
	-- 	reward = 30000 + math.random(100000,200000),
	-- 	nameofbank = "Fleeca Bank",
	-- 	lastrobbed = 0 -- this is always 0
	-- },
	["fleeca2"] = {
		position = { ['x'] = -2957.6674804688, ['y'] = 481.45776367188, ['z'] = 15.697026252747 },
		reward = 30000 + math.random(100000,250000),
		nameofbank = "Banco do Brasil (Rodovia)",
		lastrobbed = 0
	},
	["blainecounty"] = {
		position = { ['x'] = -107.06505584717, ['y'] = 6474.8012695313, ['z'] = 31.62670135498 },
		reward = 30000 + math.random(100000,250000),
		nameofbank = "Banco do Brasil (Interior)",
		lastrobbed = 0
	},
	-- ["fleeca3"] = {
	-- 	position = { ['x'] = -1212.2568359375, ['y'] = -336.128295898438, ['z'] = 36.7907638549805 },
	-- 	reward = 30000 + math.random(100000,200000),
	-- 	nameofbank = "Fleeca Bank (Vinewood Hills)",
	-- 	lastrobbed = 0
	-- },
	-- ["fleeca4"] = {
	-- 	position = { ['x'] = -354.452575683594, ['y'] = -53.8204879760742, ['z'] = 48.0463104248047 },
	-- 	reward = 30000 + math.random(100000,200000),
	-- 	nameofbank = "Fleeca Bank (Burton)",
	-- 	lastrobbed = 0
	-- },
	-- ["fleeca5"] = {
	-- 	position = { ['x'] = 309.967376708984, ['y'] = -283.033660888672, ['z'] = 53.1745223999023 },
	-- 	reward = 30000 + math.random(100000,200000),
	-- 	nameofbank = "Fleeca Bank (Alta)",
	-- 	lastrobbed = 0
	-- },
	-- ["fleeca6"] = {
	-- 	position = { ['x'] = 1176.86865234375, ['y'] = 2711.91357421875, ['z'] = 38.097785949707 },
	-- 	reward = 30000 + math.random(100000,200000),
	-- 	nameofbank = "Fleeca Bank (Desert)",
	-- 	lastrobbed = 0
	-- },7
	["pacific"] = {
		position = { ['x'] = 255.001098632813, ['y'] = 225.855895996094, ['z'] = 101.005694274902 },
		reward = 30000 + math.random(250000,400000),
		nameofbank = "Banco do Brasil (Central)",
		lastrobbed = 0
	},
	["humanlabs"] = {
		position = { ['x'] = 3559.7858886719, ['y'] = 3671.7880859375, ['z'] = 28.12188911438 },
		reward = 30000 + math.random(300000,450000),
		nameofbank = "Reserva Nacional Nióbio",
		lastrobbed = 0
	}
}