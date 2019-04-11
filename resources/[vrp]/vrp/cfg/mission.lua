
local cfg = {}

-- mission display css
cfg.display_css = [[
.div_mission{
  position: absolute;
  top: 125px;
  right: 10px;
  color: white;
  background-color: rgba(0,0,0,0.55);
  padding: 8px;
  max-width: 400px;
  font-size: 12px;
  font-family: 'Roboto', sans-serif;
  border-radius: 5px;
  border-bottom: 2px solid rgba(255,255,255,0.55);
}

.div_mission .name{
  color: rgb(255,226,0);
  font-weight: bold;
}

.div_mission .step{
  color: rgb(0,255,0);
  font-weight: bold;
}
]]

return cfg
