
local cfg = {}

-- define static item transformers
-- see https://github.com/ImagicTheCat/vRP to understand the item transformer concept/definition
cfg.item_transformers = {
    {
        name="Academia", -- menu name
        r=255,g=125,b=0, -- color
        max_units=1000,
        units_per_minute=100,
        x=-1202.96252441406,y=-1566.14086914063,z=4.61040639877319,
        radius=7.5, height=1.5, -- area
        recipes = {
            ["Força"] = { -- action name
                description="Aumente sua força. Custo R$ 30", -- action description
                in_money=15, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={}, -- items taken per unit
                products={}, -- items given per unit
                aptitudes={ -- optional
                    ["personagem.strength"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
    {
        name="Academia Prisao", -- menu name
        r=255,g=125,b=0, -- color
        max_units=1000,
        units_per_minute=100,
        x=1642.3005371094,y=2529.4814453125,z=45.56485748291,
        radius=7.5, height=1.5, -- area
        recipes = {
            ["Força"] = { -- action name
                description="Aumente sua força.", -- action description
                in_money=0, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={}, -- items taken per unit
                products={}, -- items given per unit
                aptitudes={ -- optional
                    ["personagem.strength"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
    {
        name="Minerar Rocha", -- menu name
        permissions = {"harvest.diamantes"}, -- you can add permissions
        r=0,g=125,b=255, -- color
        max_units=500,
        units_per_minute=500,
        x=-563.98059082031,y=1886.7434082031,z=123.06147766113, -- pos -563.98059082031,1886.7434082031,123.06147766113
        radius=5, height=1.5, -- area
        recipes = {
            ["Minerar"] = { -- action name
                description="Minerar Rocha.", -- action description
                in_money=70, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={}, -- items taken per unit
                products={ -- items given per unit
                    ["rocha"] = 1
                }
            }
        }
    --, onstart = function(player,recipe) end, -- optional start callback
    -- onstep = function(player,recipe) end, -- optional step callback
    -- onstop = function(player,recipe) end -- optional stop callback
    },
	{
        name="Fundir Rocha", -- menu name
        permissions = {"lapidar.diamantes"}, -- you can add permissions
        r=0,g=125,b=255, -- color
        max_units=300,
        units_per_minute=50,
        x=1109.1038818359,y=-2007.6942138672,z=30.983907699585, -- pos 1109.1038818359,-2007.6942138672,30.983907699585
        radius=5, height=1.5, -- area
        recipes = {
            ["Fundir"] = { -- action name
                description="Fundir Rocha.", -- action description
                in_money=0, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["rocha"] = 1
                }, -- items taken per unit
                products={ -- items given per unit
                    ["diamantelap"] = 1,
                    ["ferro"] = 3,
                    ["bronze"] = 5,
                    ["ouro"] = 2
                }
            }
        }
    --, onstart = function(player,recipe) end, -- optional start callback
    -- onstep = function(player,recipe) end, -- optional step callback
    -- onstop = function(player,recipe) end -- optional stop callback
    },
    {
        name="Vender Materiais", -- menu name
        permissions = {"vender.diamantes"}, -- you can add permissions
        r=0,g=125,b=255, -- color
        max_units=300,
        units_per_minute=50,
        x=-624.59771728516,y=-231.11968994141,z=38.057052612305, -- pos -624.59771728516,-231.11968994141,38.057052612305
        radius=5, height=1.5, -- area
        recipes = {
            ["Vender Diamantes"] = { -- action name
                description="Vender Diamantes.", -- action description
                in_money=0, -- money taken per unit
                out_money=170, -- money earned per unit
                reagents={
                    ["diamantelap"] = 1
                }, -- items taken per unit
                products={}
            },
            ["Vender Ouro"] = { -- action name
                description="Vender Ouro.", -- action description
                in_money=0, -- money taken per unit
                out_money=100, -- money earned per unit
                reagents={
                    ["ouro"] = 1
                }, -- items taken per unit
                products={}
            },
            ["Vender Ferro"] = { -- action name
                description="Vender Ferro.", -- action description
                in_money=0, -- money taken per unit
                out_money=70, -- money earned per unit
                reagents={
                    ["ferro"] = 1
                }, -- items taken per unit
                products={}
            },
            ["Vender Bronze"] = { -- action name
                description="Vender Bronze.", -- action description
                in_money=0, -- money taken per unit
                out_money=50, -- money earned per unit
                reagents={
                    ["bronze"] = 1
                }, -- items taken per unit
                products={}
            }
        }
    --, onstart = function(player,recipe) end, -- optional start callback
    -- onstep = function(player,recipe) end, -- optional step callback
    -- onstop = function(player,recipe) end -- optional stop callback
    },
    
	-- #################### Dinheiro
    {
        name="Lavar Dinheiro", -- menu name
        r=0,g=125,b=255, -- color
        max_units=10000,
        units_per_minute=20,
        x=1138.1376953125,y=-3194.3112792969,z=-40.395278930664, -- interior
        radius=4, height=1.5, -- area
        recipes = {
            ["Lavar Dinheiro 50%"] = { -- action name
                description="Lavar Dinheiro.", -- action description
                in_money=0, -- money taken per unit
                out_money=250, -- money earned per unit
                reagents={
                    ["dirty_money"] = 500
                }, -- items taken per unit
                products={ -- items given per unit
                }
            }
        }
    --, onstart = function(player,recipe) end, -- optional start callback
    -- onstep = function(player,recipe) end, -- optional step callback
    -- onstop = function(player,recipe) end -- optional stop callback
    },
	-- #################### Dinheiro Mafias
	{
        name="Lavar Dinheiro", -- menu name
		permissions = {"yakuza.lavagem.dinheiro"}, -- you can add permissions
        r=0,g=125,b=255, -- color
        max_units=5000,
        units_per_minute=10,
        x=1118.8881835938,y=-3193.2758789063,z=-40.391212463379, -- interior
        radius=3, height=1.5, -- area
        recipes = {
            ["Lavar Dinheiro 100%"] = { -- action name
                description="Lavar Dinheiro.", -- action description
                in_money=0, -- money taken per unit
                out_money=5000, -- money earned per unit
                reagents={
                    ["dirty_money"] = 5000
                }, -- items taken per unit
                products={ -- items given per unit
                }
            }
        }
    },
	{
        name="Lavar Dinheiro", -- menu name
		permissions = {"siciliana.lavagem.dinheiro.off"}, -- you can add permissions
        r=0,g=125,b=255, -- color
        max_units=5000,
        units_per_minute=10,
        x=-2677.2446289062,y=1336.3935546875,z=152.00958251954, -- interior
        radius=3, height=1.5, -- area
        recipes = {
            ["Lavar Dinheiro 80%"] = { -- action name
                description="Lavar Dinheiro.", -- action description
                in_money=0, -- money taken per unit
                out_money=4000, -- money earned per unit
                reagents={
                    ["dirty_money"] = 5000
                }, -- items taken per unit
                products={ -- items given per unit
                }
            }
        }
    },
	-- #################### Craft Armas Mafias
	{
        name="Fábrica de Armas", -- menu name
		permissions = {"harvest.armas"}, -- you can add permissions
        r=0,g=125,b=255, -- color
        max_units=1,
        units_per_minute=1,
        x=1553.1348876953,y=-138.09239196777,z=197.34834289551,
        radius=2, height=1.5, -- area
        recipes = {
            ["Pistola 9mm"] = { -- action name
                description="Craftar Pistola. Custo R$ 7000", -- action description
                in_money=7000, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["pistol_parts"] = 10
                }, -- items taken per unit
                products={ -- items given per unit
					["wbody|WEAPON_PISTOL"] = 1
                }
            },
			["Shotgun"] = { -- action name
                description="Craftar Shotgun. Custo R$ 15000", -- action description
                in_money=15000, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["shotgun_parts"] = 18
                }, -- items taken per unit
                products={ -- items given per unit
					["wbody|WEAPON_PUMPSHOTGUN"] = 1
                }
            },
			["SMG"] = { -- action name
                description="Craftar SMG. Custo R$ 30000", -- action description
                in_money=25000, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["smg_parts"] = 25
                }, -- items taken per unit
                products={ -- items given per unit
					["wbody|WEAPON_SMG"] = 1
                }
            },
			["AK47"] = { -- action name
                description="Craftar AK47. Custo R$ 80000", -- action description
                in_money=80000, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["ak47_parts"] = 45
                }, -- items taken per unit
                products={ -- items given per unit
					["wbody|WEAPON_ASSAULTRIFLE"] = 1
                }
            },
        }
    },
    {
        name="Fábrica de Armas", -- menu name
        permissions = {"siciliana.craft.armas"}, -- you can add permissions
        r=0,g=125,b=255, -- color
        max_units=1,
        units_per_minute=1,
        x=1416.9499511719,y=-674.00225830078,z=90.171089172363,
        radius=2, height=1.5, -- area
        recipes = {
            ["Pistola 9mm"] = { -- action name
                description="Craftar Pistola. Custo R$ 5000", -- action description
                in_money=5000, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["pistol_parts"] = 10
                }, -- items taken per unit
                products={ -- items given per unit
                    ["wbody|WEAPON_PISTOL"] = 1
                }
            },
            ["Shotgun"] = { -- action name
                description="Craftar Shotgun. Custo R$ 10000", -- action description
                in_money=10000, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["shotgun_parts"] = 18
                }, -- items taken per unit
                products={ -- items given per unit
                    ["wbody|WEAPON_PUMPSHOTGUN"] = 1
                }
            },
            ["SMG"] = { -- action name
                description="Craftar SMG. Custo R$ 15000", -- action description
                in_money=15000, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["smg_parts"] = 25
                }, -- items taken per unit
                products={ -- items given per unit
                    ["wbody|WEAPON_SMG"] = 1
                }
            },
            ["AK47"] = { -- action name
                description="Craftar AK47. Custo R$ 45000", -- action description
                in_money=45000, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["ak47_parts"] = 45
                }, -- items taken per unit
                products={ -- items given per unit
                    ["wbody|WEAPON_ASSAULTRIFLE"] = 1
                }
            },
        }
    },
	-- ####################
	-- ################################################################################################################## DROGAS
    -- #################### MACONHA
    {
        name="Plantação de Cannabis", -- menu name
        permissions = {"harvest.weed"}, -- you can add permissions
        r=0,g=200,b=72, -- color
        max_units=200,
        units_per_minute=20,
        x=2194.4907226563,y=5596.2744140625,z=53.762428283691,
        radius=4.0, height=1.5, -- area
        recipes = {
            ["Colher"] = { -- action name
                description="Colher folha de cannabis. Custo R$ 70", -- action description
                in_money=70, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={}, -- items taken per unit
                products={
                    ["seeds"] = 1
                }, -- items given per unit
                aptitudes={ -- optional
                    ["science.chemicals"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
    {
        name="Maconha's Lab", -- menu name
        permissions = {"lab.weed"}, -- you can add permissions    1037.5168457031,-3205.3576660156,-38.170280456543
        r=0,g=200,b=72, -- color
        max_units=300,
        units_per_minute=10,
        x=1516.1158447266,y=-193.50645446777,z=219.80960083008,
        radius=4.5, height=1.5, -- area
        recipes = {
            ["Processar Maconha"] = { -- action name
                description="Processar a Maconha para Venda/Consumo.", -- action description
                in_money=0, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["seeds"] = 2
                }, -- items taken per unit
                products={
                    ["weed"] = 1
                }, -- items given per unit
                aptitudes={ -- optional
                    ["leveup"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
    -- ####################
	-- #################### Anfetamina
    { -- 1454.46875,-1651.9616699219,66.99479675293 teleport saida
	  -- 997.3916015625,-3200.63671875,-36.393688201904 entrada
        name="Fabricar Anfetamina", -- menu name
        permissions = {"harvest.anfetamina"}, -- you can add permissions
        r=0,g=0,b=255, -- color
        max_units=200,
        units_per_minute=20,
        x=1007.6564331055,y=-3200.3444824219,z=-38.993156433105, -- pos 2434.1403808594,4969.396484375,42.347602844238
        radius=4.5, height=1.5, -- area
        recipes = {
            ["Fabricar"] = { -- action name
                description="Fabricar Anfetamina. Custo R$ 70", -- action description
                in_money=70, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={}, -- items taken per unit
                products={
                    ["anfetamina"] = 1
                }, -- items given per unit
                aptitudes={ -- optional
                    ["science.mathematics"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
	{
        name="Anfetamina's Lab", -- menu name
        permissions = {"lab.anfetamina"}, -- you can add permissions    1037.5168457031,-3205.3576660156,-38.170280456543
        r=0,g=200,b=72, -- color
        max_units=300,
        units_per_minute=10,
		-- -2972.9130859375,1254.8104248047,39.619853973389
        x=-2972.9130859375,y=1254.8104248047,z=39.619853973389,
        radius=7.5, height=1.5, -- area
        recipes = {
            ["Processar Anfetamina"] = { -- action name
                description="Processar a Anfetamina para Venda/Consumo.", -- action description
                in_money=0, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["anfetamina"] = 2
                }, -- items taken per unit
                products={
                    ["metanfetamina"] = 1
                }, -- items given per unit
                aptitudes={ -- optional
                    ["leveup"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
	-- 771.42059326172,-260.44281005859,68.945846557617
	-- ####################
	-- #################### Cocaina
	{
        name="Fabricar Cocaina", -- menu name
        permissions = {"harvest.cocaine"}, -- you can add permissions
        r=255,g=255,b=255, -- color
        max_units=200,
        units_per_minute=20,
        x=2357.4868164063,y=3120.8020019531,z=48.2087059021,
        radius=4.5, height=1.5, -- area
        recipes = {
            ["Colher"] = { -- action name
                description="Colher materia prima da Cocaina. Custo R$ 70", -- action description
                in_money=70, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={}, -- items taken per unit
                products={
                    ["benzoilmetilecgonina"] = 1
                }, -- items given per unit
                aptitudes={ -- optional
                    ["science.mathematics"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
	{
        name="Cocaine's Lab", -- menu name
        permissions = {"lab.cocaine"}, -- you can add permissions    1037.5168457031,-3205.3576660156,-38.170280456543
        r=255,g=255,b=255, -- color
        max_units=300,
        units_per_minute=10,
        x=1439.5183105469,y=-184.04234313965,z=185.9727935791,
        radius=4.5, height=1.5, -- area
        recipes = {
            ["Processar Cocaina"] = { -- action name
                description="Processar a Cocaina para Venda/Consumo.", -- action description
                in_money=0, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["benzoilmetilecgonina"] = 2
                }, -- items taken per unit
                products={
                    ["cocaine"] = 1
                }, -- items given per unit
                aptitudes={ -- optional
                    ["leveup"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
	-- ################################################################################################################## DROGAS
	
	-- #################### Tartarugas
    {
        name="Tartarugas", -- menu name
        permissions = {"harvest.tart"}, -- you can add permissions    -78.046783447266,6223.658203125,31.089906692505
        r=0,g=0,b=255, -- color
        max_units=100,
        units_per_minute=10,
        x=1232.6042480469,y=6989.93359375,z=-55.763236999512,
        radius=7.5, height=1.5, -- area
        recipes = {
            ["Pegar Tartaruga"] = { -- action name
                description="Pegar Tartarugas.", -- action description
                in_money=0, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={}, -- items taken per unit
                products={
                    ["tartaruga"] = 1
                }, -- items given per unit
                aptitudes={ -- optional
                    ["leveup"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
	{
        name="Tartarugas", -- menu name
        permissions = {"harvest.tart"}, -- you can add permissions    -78.046783447266,6223.658203125,31.089906692505
        r=0,g=0,b=255, -- color
        max_units=100,
        units_per_minute=10,
        x=-643.22442626953,y=6940.927734375,z=-19.314043045044,
        radius=7.5, height=1.5, -- area
        recipes = {
            ["Pegar Tartaruga"] = { -- action name
                description="Pegar Tartarugas.", -- action description
                in_money=0, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={}, -- items taken per unit
                products={
                    ["tartaruga"] = 1
                }, -- items given per unit
                aptitudes={ -- optional
                    ["leveup"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
    {
        name="Retirar Carne Tartaruga", -- menu name
        permissions = {"harvest.tart"}, -- you can add permissions    -78.046783447266,6223.658203125,31.089906692505
        r=0,g=0,b=255, -- color
        max_units=300,
        units_per_minute=10,
		x=1301.0490722656,y=4225.775390625,z=33.908679962158,
        radius=5.5, height=1.5, -- area
        recipes = {
            ["Retirar Carne"] = { -- action name
                description="Retirar carne da tartaruga. Custo R$ 70", -- action description
                in_money=70, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["tartaruga"] = 1
                }, -- items taken per unit
                products={
                    ["carnetartaruga"] = 2
                }, -- items given per unit
                aptitudes={ -- optional
                    ["leveup"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
    {
        name="Vender Tartarugas", -- menu name
        permissions = {"vender.tart"}, -- you can add permissions
        r=0,g=125,b=255, -- color
        max_units=300,
        units_per_minute=10,
        --x=-563.98059082031,y=1886.7434082031,z=123.06147766113, -- pos -563.98059082031,1886.7434082031,123.06147766113
        --x=-2222.0200195313,y=-366.70877075195,z=13.321027755737,
		x=-643.21520996094,y=-1227.8507080078,z=11.547574996948,
        radius=5, height=1.5, -- area
        recipes = {
            ["Vender"] = { -- action name
                description="Vender Carne de Tartaruga", -- action description
                in_money=0, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["carnetartaruga"] = 1
                }, -- items taken per unit
                products={
                    ["dirty_money"] = 650
                }
            }
        }
    --, onstart = function(player,recipe) end, -- optional start callback
    -- onstep = function(player,recipe) end, -- optional step callback
    -- onstop = function(player,recipe) end -- optional stop callback
    },
	-- #################### Carnes Silvestres
	-- 994.63110351563,-2162.2958984375,30.410612106323 -- processar
	{
        name="Triturar Carnes", -- menu name
        --permissions = {"job.wildhunting"}, -- you can add permissions    -78.046783447266,6223.658203125,31.089906692505
        r=255,g=0,b=0, -- color
        max_units=300,
        units_per_minute=20,
        x=994.63110351563,y=-2162.2958984375,z=30.410612106323,
        radius=4.0, height=1.5, -- area
        recipes = {
            ["Triturar Carne Silvestre"] = { -- action name
                description="Tritura a Carne dos animais silvestres. Custo R$ 70", -- action description
                in_money=70, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["carnesilvestre"] = 1
                }, -- items taken per unit
                products={
                    ["carnetriturada"] = 2
                }, -- items given per unit
                aptitudes={ -- optional
                    ["leveup"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            },
			["Triturar Carne Legal"] = { -- action name
                description="Tritura a Carne dos animais autorizados pelo Ibama. Custo R$ 30", -- action description
                in_money=30, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["carnelegal"] = 1
                }, -- items taken per unit
                products={
                    ["carnelegaltriturada"] = 2
                }, -- items given per unit
                aptitudes={ -- optional
                    ["leveup"] = 1 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
	{
        name="Vender Carne Triturada", -- menu name
        --permissions = {"job.wildhunting"}, -- you can add permissions
        r=255,g=0,b=0, -- color
        max_units=300,
        units_per_minute=20,
        x=-1540.4641113281,y=-454.0182800293,z=40.519046783447,
        radius=5, height=1.5, -- area
        recipes = {
            ["Vender Carne Ilegal"] = { -- action name
                description="Vender Carne Ilegal Triturada para Hamburgueria", -- action description
                in_money=0, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["carnetriturada"] = 1
                }, -- items taken per unit
                products={
                    ["dirty_money"] = 650
                }
            },
			["Vender Carne Legal"] = { -- action name
                description="Vender Carne Triturada Autorizada pelo Ibama para Hamburgueria", -- action description
                in_money=0, -- money taken per unit
                out_money=170, -- money earned per unit
                reagents={
                    ["carnelegaltriturada"] = 1
                }, -- items taken per unit
                products={
                }
            }
        }
    },
	-- #################### Hacker
	{
		name="Notebook", -- menu name
		permissions = {"hacker.credit_cards"}, -- you can add permissions
		r=255,g=125,b=0, -- color
        max_units=300,
        units_per_minute=30,
		x=1599.0821533203,y=3581.1967773438,z=38.770057678223,
		radius=3, height=1.0, -- area
		recipes = {
			["Criar Cartão"] = { -- action name
				description="Criar Cartões de Crédito. Custo R$ 70", -- action description
				in_money=70, -- money taken per unit
				out_money=0, -- money earned per unit
				reagents={}, -- items taken per unit
				products={
					["cartaovirgem"] = 1,
					["dirty_money"] = 1
				}, -- items given per unit
				aptitudes={ -- optional
					["hacker.hacking"] = 0.2 -- "group.aptitude", give 1 exp per unit
				}
			}
		}
	},
    {
        name="Notebook", -- menu name
        permissions = {"hacker.credit_cards"}, -- you can add permissions
        r=255,g=125,b=0, -- color
        max_units=300,
        units_per_minute=30,
        x=1073.8482666016,y=-194.22375488281,z=71.30207824707,
        radius=3, height=1.0, -- area
        recipes = {
            ["Clonar Cartão"] = { -- action name
                description="Clonar Cartões de Crédito.", -- action description
                in_money=0, -- money taken per unit
                out_money=0, -- money earned per unit
                reagents={
                    ["cartaovirgem"] = 2
                }, -- items taken per unit
                products={
                    ["cartaoclonado"] = 1
                }, -- items given per unit
                aptitudes={ -- optional
                    ["hacker.hacking"] = 0.2 -- "group.aptitude", give 1 exp per unit
                }
            }
        }
    },
	
	-- #################### Advogados
	{
		name="Processos Judiciais", -- menu name
		permissions = {"mission.adv"}, -- you can add permissions
		r=255,g=125,b=0, -- color
        max_units=100,
        units_per_minute=10,
		x=241.68287658691,y=-416.92864990234,z=-118.19956970215,
		radius=2, height=1.0, -- area
		recipes = {
			["Tirar Cópias"] = { -- action name
				description="Tira cópias dos processos judiciais para entrega-los. Custo R$ 70", -- action description
				in_money=70, -- money taken per unit
				out_money=0, -- money earned per unit
				reagents={}, -- items taken per unit
				products={
					["processosjudiciais"] = 1
				}, -- items given per unit
				aptitudes={ -- optional
					["leveup"] = 1 -- "group.aptitude", give 1 exp per unit
				}
			}
		}
	}
}

-- define transformers randomly placed on the map
cfg.hidden_transformers = {
}

-- time in minutes before hidden transformers are relocated (min is 5 minutes)
cfg.hidden_transformer_duration = 5*24*60 -- 5 days

-- configure the information reseller (can sell hidden transformers positions)
cfg.informer = {
    infos = {
    },
    positions = {
    },
    interval = 1, -- interval in minutes for the reseller respawn
    duration = 10, -- duration in minutes of the spawned reseller
    blipid = 133,
    blipcolor = 2
}

return cfg