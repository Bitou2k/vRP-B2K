local objectSets = {}
local spawns = {}
local currentParseName, currentParseResource

function DeleteObject(object)
	return Citizen.InvokeNative(0x539E0AE3E6634B9F, Citizen.PointerValueIntInitialized(object))
end

local function getSetLoader(sets)
	return function()
		-- request all the models
		for _,obj in ipairs(sets) do
			RequestModel(obj.hash)
		end

		-- make sure all the models are loaded
		while true do
			local loaded = true

			Citizen.Wait(0)

			for _,obj in ipairs(sets) do
				if not HasModelLoaded(obj.hash) then
					loaded = false
					break
				end
			end

			if loaded then
				break
			end
		end
	end
end

local function clearObjectSet(set)
	for _, obj in ipairs(set) do
		if obj.object then
			DeleteObject(obj.object)
		end

		SetModelAsNoLongerNeeded(obj.hash)
	end
end

-- object streamer
local function isNearObject(p1, obj)
	local diff = obj.pos - p1
	local dist = (diff.x * diff.x) + (diff.y * diff.y)

	return (dist < (400 * 400))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		-- spawn objects
		local pos = GetEntityCoords(GetPlayerPed(-1))

		for k, sets in pairs(objectSets) do
			for i, obj in ipairs(sets) do
				local shouldHave = isNearObject(pos, obj)

				if shouldHave and not obj.object then
					local o = CreateObjectNoOffset(obj.hash, obj.pos, false --[[ create netobj? ]], false, false)

					if o then
						SetEntityRotation(o, obj.rot, 2, true)
						FreezeEntityPosition(o, true)

						obj.object = o
					end
				elseif not shouldHave and obj.object then
					DeleteObject(obj.object)
					obj.object = nil
				end

				if (i % 75) == 0 then
					Citizen.Wait(15)
				end
			end
		end
	end
end)

local function registerObjectSpawn(name, pos, heading)
	local t = {
		name = name,
		filename = currentParseName,
		owner = currentParseResource,
		spawnPos = { pos.x, pos.y, pos.z },
		heading = heading
	}

	table.insert(spawns, t)

	TriggerEvent('objectLoader:onSpawnLoaded', t)
end

function getSpawns()
	return spawns
end

local function createObject(data)
	-- a no-op
	return data
end

local function parseIniObjectSet(data)
	local i = parseIni(data)
	local a = {}

	for k, v in pairs(i) do
		if v.Model then
			table.insert(a, createObject({
				pos = vector3(tonumber(v.x), tonumber(v.y), tonumber(v.z) + tonumber(v.h)),
				rot = quat(tonumber(v.qx), tonumber(v.qy), tonumber(v.qz), tonumber(v.qw)),
				hash = tonumber(v.Model)
			}))
		end
	end

	registerObjectSpawn(currentParseName, vector3(
		tonumber(i.Player.x),
		tonumber(i.Player.y),
		tonumber(i.Player.z)),
	0.0)

	return a
end

local function parseMapEditorXml(xml)
	local a = {}

	for _,obj in ipairs(xml.Objects[1].MapObject) do
		if obj.Type[1] == 'Prop' then
			table.insert(a, createObject({
				pos = vector3(tonumber(obj.Position[1].X[1]), tonumber(obj.Position[1].Y[1]), tonumber(obj.Position[1].Z[1])),
				rot = vector3(tonumber(obj.Rotation[1].X[1]), tonumber(obj.Rotation[1].Y[1]), tonumber(obj.Rotation[1].Z[1])),
				hash = tonumber(obj.Hash[1])
			}))
		end
	end

	if xml.Metadata then
		registerObjectSpawn(xml.Metadata[1].Name[1], vector3(
			tonumber(xml.Metadata[1].TeleportPoint[1].X[1]),
			tonumber(xml.Metadata[1].TeleportPoint[1].Y[1]),
			tonumber(xml.Metadata[1].TeleportPoint[1].Z[1])),
		tonumber(xml.Metadata[1].TeleportPoint[1].Heading[1]))
	end

	return a
end

local function parseSpoonerXml(xml)
	local a = {}

	for _,obj in ipairs(xml.Placement) do
		if obj.Type[1] == '3' then
			table.insert(a, createObject({
				pos = vector3(tonumber(obj.PositionRotation[1].X[1]), tonumber(obj.PositionRotation[1].Y[1]), tonumber(obj.PositionRotation[1].Z[1])),
				rot = vector3(tonumber(obj.PositionRotation[1].Pitch[1]), tonumber(obj.PositionRotation[1].Roll[1]), tonumber(obj.PositionRotation[1].Yaw[1])),
				hash = tonumber(obj.ModelHash[1])
			}))
		end
	end

	if xml.ReferenceCoords then
		registerObjectSpawn(currentParseName, vector3(
			tonumber(xml.ReferenceCoords[1].X[1]),
			tonumber(xml.ReferenceCoords[1].Y[1]),
			tonumber(xml.ReferenceCoords[1].Z[1])),
		0.0)
	end

	return a
end

local function processXml(el)
	local v = {}
	local text

	for _,kid in ipairs(el.kids) do
		if kid.type == 'text' then
			text = kid.value
		elseif kid.type == 'element' then
			if not v[kid.name] then
				v[kid.name] = {}
			end

			table.insert(v[kid.name], processXml(kid))
		end
	end

	v._ = el.attr

	if #el.attr == 0 and #el.el == 0 then
		v = text
	end

	return v
end

local function parseObjectSet(data)
	local xml = SLAXML:dom(data)

	if xml and xml.root then
		Citizen.Trace("parsed as xml\n")

		if xml.root.name == 'Map' then
			return parseMapEditorXml(processXml(xml.root))
		elseif xml.root.name == 'SpoonerPlacements' then
			return parseSpoonerXml(processXml(xml.root))
		end
	else
		-- ini maps don't work due to quaternions being weird
		--return parseIniObjectSet(data)
		return {}
	end
end

AddEventHandler('onClientResourceStart', function(name)
	local metaEntries = GetNumResourceMetadata(name, 'object_file')

	if not metaEntries then
		return
	end

	currentParseResource = name

	local sets = {}

	for i = 0, metaEntries - 1 do
		local fileName = GetResourceMetadata(name, 'object_file', i)
		local data = LoadResourceFile(name, fileName)

		currentParseName = fileName

		if data then
			table.merge(sets, parseObjectSet(data))
		end
	end

	objectSets[name] = sets
	
	Citizen.CreateThread(getSetLoader(sets))
end)

AddEventHandler('onClientResourceStop', function(name)
	if objectSets[name] then
		clearObjectSet(objectSets[name])
	end
end)

-- mapmanager support
local mapObjectSets = {}
local mapObjectSet = 1

AddEventHandler('getMapDirectives', function(add, resource)
	local function addMap(state, data)
        local set = parseObjectSet(data)

        Citizen.CreateThread(getSetLoader(set))

        mapObjectSets[mapObjectSet] = set
        state.set = mapObjectSet

        mapObjectSet = mapObjectSet + 1
	end

	local function undoMap(state, arg)
        clearObjectSet(mapObjectSets[state.set])
        mapObjectSets[state.set] = nil
    end

    add('object_data', addMap, undoMap)

	if not resource then
		return
	end

	-- if no owning resource was specified, don't add the object_file directive
    add('object_file', function(state, name)
        local data = LoadResourceFile(resource, name)

        addMap(state, data)
    end, undoMap)
end)

function table.merge(t1, t2)
	for k,v in ipairs(t2) do
		table.insert(t1, v)
	end
end

-- ini parser
--[[
	Copyright (c) 2012 Carreras Nicolas
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
--]]
--- Lua INI Parser.
-- It has never been that simple to use INI files with Lua.
--@author Dynodzzo

--- Returns a table containing all the data from the INI file.
--@param fileName The name of the INI file to parse. [string]
--@return The table containing all data from the INI file. [table]
function parseIni(fileData)
	local function lines(str)
		local t = {}
		local function helper(line) table.insert(t, line) return "" end
		helper((str:gsub("(.-)\r?\n", helper)))
		return t
	end

	local data = {};
	local section;
	for _, line in ipairs(lines(fileData)) do
		local tempSection = line:match('^%[([^%[%]]+)%]$');
		if(tempSection)then
			section = tonumber(tempSection) and tonumber(tempSection) or tempSection;
			data[section] = data[section] or {};
		end
		local param, value = line:match('^([%w|_]+)%s-=%s-(.+)$');
		if(param and value ~= nil)then
			if(tonumber(value))then
				value = tonumber(value);
			elseif(value == 'true')then
				value = true;
			elseif(value == 'false')then
				value = false;
			end
			if(tonumber(param))then
				param = tonumber(param);
			end
			data[section][param] = value;
		end
	end
	return data;
end
