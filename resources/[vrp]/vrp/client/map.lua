-- BLIPS: see https://wiki.gtanet.work/index.php?title=Blips for blip id/color

-- TUNNEL CLIENT API

-- BLIP

-- create new blip, return native id
function tvRP.addBlip(x,y,z,idtype,idcolor,text)
  local blip = AddBlipForCoord(x+0.001,y+0.001,z+0.001) -- solve strange gta5 madness with integer -> double
  SetBlipSprite(blip, idtype)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip,idcolor)

  if text ~= nil then
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
  end

  return blip
end

function tvRP.addScaledBlip(x,y,z,scale,idtype,idcolor,text)
  local blip = AddBlipForCoord(x+0.001,y+0.001,z+0.001) -- solve strange gta5 madness with integer -> double
  SetBlipSprite(blip, idtype)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip,idcolor)
  SetBlipScale(blip, scale)

  if text ~= nil then
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
  end

  return blip
end

-- remove blip by native id
function tvRP.removeBlip(id)
  RemoveBlip(id)
end


local named_blips = {}

-- set a named blip (same as addBlip but for a unique name, add or update)
-- return native id
function tvRP.setNamedBlip(name,x,y,z,idtype,idcolor,text)
  tvRP.removeNamedBlip(name) -- remove old one

  named_blips[name] = tvRP.addBlip(x,y,z,idtype,idcolor,text)
  return named_blips[name]
end

-- remove a named blip
function tvRP.removeNamedBlip(name)
  if named_blips[name] ~= nil then
    tvRP.removeBlip(named_blips[name])
    named_blips[name] = nil
  end
end

-- GPS

-- set the GPS destination marker coordinates
function tvRP.setGPS(x,y)
  SetNewWaypoint(x+0.0001,y+0.0001)
end

-- set route to native blip id
function tvRP.setBlipRoute(id)
  SetBlipRoute(id,true)
end

-- MARKER

local markers = {}
local marker_ids = Tools.newIDGenerator()
local named_markers = {}

-- add a circular marker to the game map
-- return marker id
function tvRP.addMarker(x,y,z,sx,sy,sz,r,g,b,a,visible_distance)
  local marker = {id=27,x=x,y=y,z=z,rx=0.0,ry=0.0,rz=0.0,sx=sx,sy=sy,sz=sz,r=r,g=g,b=b,a=a,visible_distance=visible_distance,rot=0,facec=0,bobud=0}

  -- default values
  if marker.sx == nil then marker.sx = 2.0 end
  if marker.sy == nil then marker.sy = 2.0 end
  if marker.sz == nil then marker.sz = 0.7 end

  if marker.r == nil then marker.r = 0 end
  if marker.g == nil then marker.g = 155 end
  if marker.b == nil then marker.b = 255 end
  if marker.a == nil then marker.a = 200 end

  -- fix gta5 integer -> double issue
  marker.x = marker.x+0.001
  marker.y = marker.y+0.001
  marker.z = marker.z+0.001
  marker.sx = marker.sx+0.001
  marker.sy = marker.sy+0.001
  marker.sz = marker.sz+0.001

  if marker.visible_distance == nil then marker.visible_distance = 150 end

  local id = marker_ids:gen()
  markers[id] = marker

  return id
end

function tvRP.addCustomMarker(id,x,y,z,rx,ry,rz,sx,sy,sz,r,g,b,a,visible_distance,rot,facec,bobud)
  local marker = {id=id,x=x,y=y,z=z,rx=rx,ry=ry,rz=rz,sx=sx,sy=sy,sz=sz,r=r,g=g,b=b,a=a,visible_distance=visible_distance,rot=rot,facec=facec,bobud=bobud}

  if marker.id == nil then marker.id = 27 end
  if marker.rot == nil then marker.rot = 0 end
  if marker.facec == nil then marker.facec = 0 end
  if marker.bobud == nil then marker.bobud = 0 end
  
  -- default values
  if marker.sx == nil then marker.sx = 2.0 end
  if marker.sy == nil then marker.sy = 2.0 end
  if marker.sz == nil then marker.sz = 0.7 end

  if marker.rx == nil then marker.rx = 0.0 end
  if marker.ry == nil then marker.ry = 0.0 end
  if marker.rz == nil then marker.rz = 0.0 end

  if marker.r == nil then marker.r = 0 end
  if marker.g == nil then marker.g = 155 end
  if marker.b == nil then marker.b = 255 end
  if marker.a == nil then marker.a = 200 end

  -- fix gta5 integer -> double issue
  marker.x = marker.x+0.001
  marker.y = marker.y+0.001
  marker.z = marker.z+0.001
  marker.sx = marker.sx+0.001
  marker.sy = marker.sy+0.001
  marker.sz = marker.sz+0.001

  if marker.visible_distance == nil then marker.visible_distance = 150 end

  local id = marker_ids:gen()
  markers[id] = marker

  return id
end

-- remove marker
function tvRP.removeMarker(id)
  if markers[id] ~= nil then
    markers[id] = nil
    marker_ids:free(id)
  end
end

-- set a named marker (same as addMarker but for a unique name, add or update)
-- return id
function tvRP.setNamedMarker(name,x,y,z,sx,sy,sz,r,g,b,a,visible_distance)
  tvRP.removeNamedMarker(name) -- remove old marker

  named_markers[name] = tvRP.addMarker(x,y,z,sx,sy,sz,r,g,b,a,visible_distance)
  return named_markers[name]
end

function tvRP.removeNamedMarker(name)
  if named_markers[name] ~= nil then
    tvRP.removeMarker(named_markers[name])
    named_markers[name] = nil
  end
end

-- markers draw loop
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    local px,py,pz = tvRP.getPosition()

    for k,v in pairs(markers) do
      -- check visibility
      if GetDistanceBetweenCoords(v.x,v.y,v.z,px,py,pz,true) <= v.visible_distance then
        DrawMarker(v.id,v.x,v.y,v.z,0,0,0,v.rx,v.ry,v.rz,v.sx,v.sy,v.sz,v.r,v.g,v.b,v.a, v.bobud, v.facec, 0, v.rot, 0, 0, 0)
      end
    end
  end
end)

-- AREA

local areas = {}

-- create/update a cylinder area
function tvRP.setArea(name,x,y,z,radius,height)
  local area = {x=x+0.001,y=y+0.001,z=z+0.001,radius=radius,height=height}

  -- default values
  if area.height == nil then area.height = 6 end

  areas[name] = area
end

-- remove area
function tvRP.removeArea(name)
  if areas[name] ~= nil then
    areas[name] = nil
  end
end

-- areas triggers detections
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(100)

    local px,py,pz = tvRP.getPosition()

    for k,v in pairs(areas) do
      -- detect enter/leave

      local player_in = (GetDistanceBetweenCoords(v.x,v.y,v.z,px,py,pz,true) <= v.radius and math.abs(pz-v.z) <= v.height)

      if v.player_in and not player_in then -- was in: leave
        vRPserver.leaveArea({k})
      elseif not v.player_in and player_in then -- wasn't in: enter
        vRPserver.enterArea({k})
      end

      v.player_in = player_in -- update area player_in
    end
  end
end)

-- DOOR

-- set the closest door state
-- doordef: .model or .modelhash
-- locked: boolean
-- doorswing: -1 to 1
function tvRP.setStateOfClosestDoor(doordef, locked, doorswing)
  local x,y,z = tvRP.getPosition()
  local hash = doordef.modelhash
  if hash == nil then
    hash = GetHashKey(doordef.model)
  end

  SetStateOfClosestDoorOfType(hash,x,y,z,locked,doorswing+0.0001)
end

function tvRP.openClosestDoor(doordef)
  tvRP.setStateOfClosestDoor(doordef, false, 0)
end

function tvRP.closeClosestDoor(doordef)
  tvRP.setStateOfClosestDoor(doordef, true, 0)
end
