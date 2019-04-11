
local cfg = {}

-- start wallet/bank values
cfg.open_wallet = 700
cfg.open_bank = 5000

cfg.display_css = [[
.div_money {
  position: absolute;
  top: 80px;
  right: 10px;
  font-size: 16px;
  font-family: bankgothic;
  color: #FFFFFF;
  background-color: rgba(0,0,0,0.55);
  padding: 2px;
  border-radius: 5px;
  border-bottom: 2px solid rgba(255,255,255,0.55);
  vertical-align: middle;
}

.div_money .symbol {
  vertical-align: middle;
  content: url('nui://vrp/gui/imgs/wallet.png');
  width:23px;
  height:20px;
  vertical-align:middle;
  border:0;
}
]]

return cfg