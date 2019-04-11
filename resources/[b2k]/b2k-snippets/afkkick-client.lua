-- CONFIG --

-- AFK Kick Time Limit (in seconds)
secondsUntilKick = (15*60)

-- Warn players if 3/4 of the Time Limit ran up
kickWarning = true

-- CODE --
local time = secondsUntilKick
local startCount = true

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		playerPed = GetPlayerPed(-1)
		if playerPed then
			currentPos = GetEntityCoords(playerPed, true)

			if currentPos == prevPos then
				if time > 0 then
					if kickWarning and time == math.ceil(secondsUntilKick / 4) then
						TriggerEvent("chatMessage", "SERVER", {255, 0, 0}, "^1Você vai ser kikado em " .. time .. " segundos por estar AFK!")
					end

					time = time - 1
				else
					TriggerServerEvent("kickForBeingAnAFKDouchebag")
				end
			else
				time = secondsUntilKick
			end

			prevPos = currentPos
		end
	end
end)