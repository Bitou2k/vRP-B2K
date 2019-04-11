
local noclip = false
local noclip_speed = 0.8

function tvRP.toggleNoclip()
  noclip = not noclip
  local ped = GetPlayerPed(-1)
  if noclip then -- set
    SetEntityInvincible(ped, true)
    SetEntityVisible(ped, false, false)
    SetEntityCollision(ped, false, false)
  else -- unset
    SetEntityInvincible(ped, false)
    SetEntityVisible(ped, true, false)
    SetEntityCollision(ped, true, true)
  end
end

function tvRP.isNoclip()
  return noclip
end

function tvRP.toggleSpec(idSent)
	local id = idSent
	local sonid = GetPlayerFromServerId(id)
	local targetPed = GetPlayerPed(sonid)

  NetworkSetInSpectatorMode(1, targetPed)

  local x,y,z = table.unpack(GetEntityCoords(targetPed, true))

  RequestCollisionAtCoord(x, y, z)
  while not HasCollisionLoadedAroundEntity(targetPed) do
    RequestCollisionAtCoord(x, y, z)
    Citizen.Wait(10)
  end
end

function tvRP.stopSpec()
	NetworkSetInSpectatorMode(0, GetPlayerPed(-1))
end

-- noclip/invisibility
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if noclip then
      local ped = GetPlayerPed(-1)
      local x,y,z = tvRP.getPosition()
      local dx,dy,dz = tvRP.getCamDirection()
      local speed = noclip_speed

      -- reset velocity
      SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

      -- shift press
      if IsControlPressed(0, 21) then
        speed = 5.0
      end

      -- forward
      if IsControlPressed(0,32) then -- MOVE UP
        x = x+speed*dx
        y = y+speed*dy
        z = z+speed*dz
      end

      -- backward
      if IsControlPressed(0,269) then -- MOVE DOWN
        x = x-speed*dx
        y = y-speed*dy
        z = z-speed*dz
      end

      SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
    end
  end
end)