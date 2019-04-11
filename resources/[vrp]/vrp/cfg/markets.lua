
local cfg = {}

-- define market types like garages and weapons
-- _config: blipid, blipcolor, permissions (optional, only users with the permission will have access to the market)

cfg.market_types = {
  ["Mercado"] = {
    _config = {blipid=52, blipcolor=2},

    -- list itemid => price
    -- Drinks
    ["milk"] = 2,
    ["water"] = 2,
    ["coffee"] = 4,
    ["tea"] = 4,
    ["icetea"] = 8,
    ["orangejuice"] = 8,
    ["gocagola"] = 12,
    ["redgull"] = 12,
    ["lemonlimonad"] = 14,
    ["vodka"] = 30,

    --Food
    ["bread"] = 2,
    ["donut"] = 2,
    ["tacos"] = 8,
    ["sandwich"] = 14,
    ["kebab"] = 20,
    ["pdonut"] = 65,
  },
  ["Samu"] = {
    _config = {blipid=403, blipcolor=49, permissions={"emergency.market"}},
    ["medkit"] = 0,
  	["dipiroca"] = 0,
  	["nocucedin"] = 0,
  	["paracetanal"] = 0,
  	["decupramim"] = 0,
  	["buscopau"] = 0,
  	["navagina"] = 0,
  	["analdor"] = 0,
  	["sefodex"] = 0,
  	["phodac"] = 0,
  	["danec"] = 0,
  	["cotovelol"]= 0,
  	["nokusin"] = 0,
  	["viagral"] = 0,
  	["glicoanal"] = 0,
  	["quigosado"] = 0
  },
  ["Ferramentas"] = {
    _config = {blipid=255, blipcolor=5},
    ["scubagear"] = 5000,
    ["algemas"] = 500,
    ["vendaolhos"] = 200,
  },
  ["Mecanico"] = {
    _config = {blipid=402, blipcolor=47, permissions={"repair.market"}},
    ["repairkit"] = 50
  }
}

-- list of markets {type,x,y,z}

cfg.markets = {
  {"Mercado",128.1410369873, -1286.1120605469, 29.281036376953},
  {"Mercado",-47.522762298584,-1756.85717773438,29.4210109710693},
  {"Mercado",25.7454013824463,-1345.26232910156,29.4970207214355}, 
  {"Mercado",1135.57678222656,-981.78125,46.4157981872559}, 
  {"Mercado",1163.53820800781,-323.541320800781,69.2050552368164}, 
  {"Mercado",374.190032958984,327.506713867188,103.566368103027}, 
  {"Mercado",2555.35766601563,382.16845703125,108.622947692871}, 
  {"Mercado",2676.76733398438,3281.57788085938,55.2411231994629}, 
  {"Mercado",1960.50793457031,3741.84008789063,32.3437385559082},
  {"Mercado",1393.23828125,3605.171875,34.9809303283691}, 
  {"Mercado",1166.18151855469,2709.35327148438,38.15771484375}, 
  {"Mercado",547.987609863281,2669.7568359375,42.1565132141113}, 
  {"Mercado",1698.30737304688,4924.37939453125,42.0636749267578}, 
  {"Mercado",1729.54443359375,6415.76513671875,35.0372200012207}, 
  {"Mercado",-3243.9013671875,1001.40405273438,12.8307056427002}, 
  {"Mercado",-2967.8818359375,390.78662109375,15.0433149337769}, 
  {"Mercado",-3041.17456054688,585.166198730469,7.90893363952637}, 
  {"Mercado",-1820.55725097656,792.770568847656,138.113250732422}, 
  {"Mercado",-1486.76574707031,-379.553985595703,40.163387298584}, 
  {"Mercado",-1223.18127441406,-907.385681152344,12.3263463973999}, 
  {"Mercado",-707.408996582031,-913.681701660156,19.2155857086182},
  {"Samu", 310.36694335938,-598.89642333984,43.291820526123},
  {"Mecanico",-231.54925537109,-1378.5734863281,31.258247375488},
  {"Ferramentas",22.58203125,-1109.8516845703,29.793336868286}  
}

return cfg
