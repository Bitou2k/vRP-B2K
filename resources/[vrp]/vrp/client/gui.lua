
-- pause
AddEventHandler("vRP:pauseChange", function(paused)
  SendNUIMessage({act="pause_change", paused=paused})
end)

-- MENU

function tvRP.openMenuData(menudata)
  SendNUIMessage({act="open_menu", menudata = menudata})
end

function tvRP.closeMenu()
  SendNUIMessage({act="close_menu"})
end

-- PROMPT

function tvRP.prompt(title,default_text)
  SendNUIMessage({act="prompt",title=title,text=tostring(default_text)})
  SetNuiFocus(true)
end

-- REQUEST

function tvRP.request(id,text,time)
  SendNUIMessage({act="request",id=id,text=tostring(text),time = time})
  tvRP.playSound("HUD_MINI_GAME_SOUNDSET","5_SEC_WARNING")
end

-- gui menu events
RegisterNUICallback("menu",function(data,cb)
  if data.act == "close" then
    vRPserver.closeMenu({data.id})
  elseif data.act == "valid" then
    vRPserver.validMenuChoice({data.id,data.choice,data.mod})
  end
end)

-- gui prompt event
RegisterNUICallback("prompt",function(data,cb)
  if data.act == "close" then
    SetNuiFocus(false)
    SetNuiFocus(false)
    vRPserver.promptResult({data.result})
  end
end)

-- gui request event
RegisterNUICallback("request",function(data,cb)
  if data.act == "response" then
    vRPserver.requestResult({data.id,data.ok})
  end
end)

-- ANNOUNCE

-- add an announce to the queue
-- background: image url (800x150)
-- content: announce html content
function tvRP.announce(background,content)
  SendNUIMessage({act="announce",background=background,content=content})
end

-- cfg
local hasLoaded = false

function GetMinimapAnchor()
	if not hasLoaded then
		-- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
		-- 0.05 * ((safezone - 0.9) * 10)
		local safezone = GetSafeZoneSize()
		local safezone_x = 1.0 / 20.0
		local safezone_y = 1.0 / 20.0
		local aspect_ratio = GetAspectRatio(0)
		local res_x, res_y = GetActiveScreenResolution()

		local xscale = 1.0 / res_x
		local yscale = 1.0 / res_y
		local Minimap = {}
		Minimap.width = xscale * (res_x / (4 * aspect_ratio))
		Minimap.height = yscale * (res_y / 5.674)
		Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
		Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
		Minimap.right_x = Minimap.left_x + Minimap.width
		Minimap.top_y = Minimap.bottom_y - Minimap.height
		Minimap.x = Minimap.left_x
		Minimap.y = Minimap.top_y
		Minimap.xunit = xscale
		Minimap.yunit = yscale
		Minimap.res_x = res_x
		Minimap.res_y = res_y

		hasLoaded = true
		return Minimap
	end
end

newUI = GetMinimapAnchor()
newGUI = {
  anchor_minimap_width = (newUI.res_x * newUI.width)+1,
  anchor_minimap_left = (newUI.res_x * newUI.x)-2,
  anchor_minimap_bottom = (newUI.res_y-(newUI.res_y * newUI.bottom_y))+20
}


RegisterNUICallback("cfg",function(data,cb) -- if NUI loaded after
  SendNUIMessage({act="cfg",cfg=newGUI})
end)
SendNUIMessage({act="cfg",cfg=newGUI}) -- if NUI loaded before

-- try to fix missing cfg issue (cf: https://github.com/ImagicTheCat/vRP/issues/89)
for i=1,5 do
  SetTimeout(5000*i, function() SendNUIMessage({act="cfg",cfg=newGUI}) end)
end

-- PROGRESS BAR

-- create/update a progress bar
function tvRP.setProgressBar(name,anchor,text,r,g,b,value)
  local pbar = {name=name,anchor=anchor,text=text,r=r,g=g,b=b,value=value}

  -- default values
  if pbar.value == nil then pbar.value = 0 end

  SendNUIMessage({act="set_pbar",pbar = pbar})
end

-- set progress bar value in percent
function tvRP.setProgressBarValue(name,value)
  SendNUIMessage({act="set_pbar_val", name = name, value = value})
end

-- set progress bar text
function tvRP.setProgressBarText(name,text)
  SendNUIMessage({act="set_pbar_text", name = name, text = text})
end

-- remove a progress bar
function tvRP.removeProgressBar(name)
  SendNUIMessage({act="remove_pbar", name = name})
end

-- DIV

-- set a div
-- css: plain global css, the div class is "div_name"
-- content: html content of the div
function tvRP.setDiv(name,css,content)
  SendNUIMessage({act="set_div", name = name, css = css, content = content})
end

-- set the div css
function tvRP.setDivCss(name,css)
  SendNUIMessage({act="set_div_css", name = name, css = css})
end

-- set the div content
function tvRP.setDivContent(name,content)
  SendNUIMessage({act="set_div_content", name = name, content = content})
end

-- execute js for the div
-- js variables: this is the div
function tvRP.divExecuteJS(name,js)
  SendNUIMessage({act="div_execjs", name = name, js = js})
end

-- remove the div
function tvRP.removeDiv(name)
  SendNUIMessage({act="remove_div", name = name})
end

-- CONTROLS/GUI

local paused = false

function tvRP.isPaused()
  return paused
end

-- gui controls (from cellphone)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    -- menu controls
    if IsControlJustPressed(table.unpack(cfg.controls.phone.up)) then SendNUIMessage({act="event",event="UP"}) end
    if IsControlJustPressed(table.unpack(cfg.controls.phone.down)) then SendNUIMessage({act="event",event="DOWN"}) end
    if IsControlJustPressed(table.unpack(cfg.controls.phone.left)) then SendNUIMessage({act="event",event="LEFT"}) end
    if IsControlJustPressed(table.unpack(cfg.controls.phone.right)) then SendNUIMessage({act="event",event="RIGHT"}) end
    if IsControlJustPressed(table.unpack(cfg.controls.phone.select)) then SendNUIMessage({act="event",event="SELECT"}) end
    if IsControlJustPressed(table.unpack(cfg.controls.phone.cancel)) then SendNUIMessage({act="event",event="CANCEL"}) end

    -- open general menu
    if IsControlJustPressed(table.unpack(cfg.controls.phone.open)) and (not tvRP.isInComa() or not cfg.coma_disable_menu) and (not tvRP.isHandcuffed() or not cfg.handcuff_disable_menu) then vRPserver.openMainMenu({}) end

    -- F5,F6 (default: control michael, control franklin)
    if IsControlJustPressed(table.unpack(cfg.controls.request.yes)) then SendNUIMessage({act="event",event="F5"}) end
    if IsControlJustPressed(table.unpack(cfg.controls.request.no)) then SendNUIMessage({act="event",event="F6"}) end

    -- pause events
    local pause_menu = IsPauseMenuActive()
    if pause_menu and not paused then
      paused = true
      TriggerEvent("vRP:pauseChange", paused)
    elseif not pause_menu and paused then
      paused = false
      TriggerEvent("vRP:pauseChange", paused)
    end
  end
end)

