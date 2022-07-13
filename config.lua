--[[
 ________  ________  ________  ___    ___ ________  ___  ________  ___  ___  _________        ________      ___    ___     
|\   ____\|\   __  \|\   __  \|\  \  /  /|\   __  \|\  \|\   ____\|\  \|\  \|\___   ___\     |\   __  \    |\  \  /  /|    
\ \  \___|\ \  \|\  \ \  \|\  \ \  \/  / | \  \|\  \ \  \ \  \___|\ \  \\\  \|___ \  \_|     \ \  \|\ /_   \ \  \/  / /    
 \ \  \    \ \  \\\  \ \   ____\ \    / / \ \   _  _\ \  \ \  \  __\ \   __  \   \ \  \       \ \   __  \   \ \    / /     
  \ \  \____\ \  \\\  \ \  \___|\/  /  /   \ \  \\  \\ \  \ \  \|\  \ \  \ \  \   \ \  \       \ \  \|\  \   \/  /  /      
   \ \_______\ \_______\ \__\ __/  / /      \ \__\\ _\\ \__\ \_______\ \__\ \__\   \ \__\       \ \_______\__/  / /        
    \|_______|\|_______|\|__||\___/ /        \|__|\|__|\|__|\|_______|\|__|\|__|    \|__|        \|_______|\___/ /         
                             \|___|/                                                                      \|___|/                                                                                                    
 _____ ______   ___  ________  _________  ___  ________          ________  _________  ________  ________  _______          
|\   _ \  _   \|\  \|\   ____\|\___   ___\\  \|\   ____\        |\   ____\|\___   ___\\   __  \|\   __  \|\  ___ \         
\ \  \\\__\ \  \ \  \ \  \___|\|___ \  \_\ \  \ \  \___|        \ \  \___|\|___ \  \_\ \  \|\  \ \  \|\  \ \   __/|        
 \ \  \\|__| \  \ \  \ \_____  \   \ \  \ \ \  \ \  \            \ \_____  \   \ \  \ \ \  \\\  \ \   _  _\ \  \_|/__      
  \ \  \    \ \  \ \  \|____|\  \   \ \  \ \ \  \ \  \____        \|____|\  \   \ \  \ \ \  \\\  \ \  \\  \\ \  \_|\ \     
   \ \__\    \ \__\ \__\____\_\  \   \ \__\ \ \__\ \_______\        ____\_\  \   \ \__\ \ \_______\ \__\\ _\\ \_______\    
    \|__|     \|__|\|__|\_________\   \|__|  \|__|\|_______|       |\_________\   \|__|  \|_______|\|__|\|__|\|_______|    
]]

config = { 
    gerais = { 
        veiculosmax = 50, -- Veículos Máximos que o Jogador vai poder ter na Garagem.
        elementfuel = "fuel", -- Element Data de Gasolina do seu Servidor.
        elementid = "ID", -- Element Data de ID do seu Servidor.
        infobox = "showInfobox", -- Evento da sua Infobox.
        distancia = 10, -- Distancia do Player e do Veículo. (Guardar Veículo)
        velocitymax = 350, -- Velocidade Máximas de todos os Veículos.
        acls = {"Console"}, -- ACL's Administradoras do seu Servidor.
    },
    commands = { 
        destruirveh = "dv", -- Comando de Destruir o Veículo.
        giveveh = "giveveh", -- Comando de Givar Veículo a Garagem do Jogador.
        takeveh = "takeveh", -- Comando de Retirar o Veículo da Garagem do Jogador.  IDdoJogador iDmodelDoCarro
        docveh = "doc", -- Comando de Puxar o Documento do Veículo.
    },
    valores = {
        localizar = 500, -- Valor de Localizar o Veículo.
        desmanchar = 5, -- Porcentagem que o Player que Desmanchar irá receber ao Desmanchar um Veículo.
        apreender = 1, -- Porcentagem que o Player que Apreender irá receber ao Apreender um Veículo.
        valorD = math.random (0, 0), -- Valor que o Player irá Receber ao Desmanchar um Veículo que não seja da Concessionaria.
    },
    ipva = { 
        tempo = 1440, -- Tempo em Minutos para o IPVA ser cobrado.
        porcentagem = 2, -- Porcentagem do IPVA a ser Cobrado.
    },
    tempos = { 
        desmanchar = 10, -- Tempo em Segundos para o Jogador desmanhar o Veículo.
        localizar = 60, -- Tempo em Segundos que o Veículo irá ficar Localizado pelo Seguro.
    },
    doc = { 
        acl = "Policial", -- ACL Policial do seu servidor.
    },
    detran = {
        valor_apreender_s = 5, -- Porcentagem que o Player vai ter que pagar para retirar do Detran caso o Veículo tenha seguro.
        valor_apreender = 25, -- Porcentagem que o Player vai ter que pagar para retirar do Detran caso o Veículo não tenha seguro.
        valor_desmanche = 40, -- Porcentagem que o Player vai ter que pagar para retirar do Desmanche.
        valor_emplacar = 5000, -- Valor do Emplacamento do Veículo.
        valor_seguro = 6, -- Porcentagem que o Player vai ter que pagar para Contratar Seguro.
    },
    botoes = { 
        trancardes = "l", -- Botão de trancar e destrancar Veículos.
        desmanchar = "e", -- Botão para Desmanchar veículos.
        apreender = "e", -- Botão para Apreender veículos.
    },
    camera = {
        cameraveiculo = {-2372.9587402344, -233.6618950195, 43.653499603271, -2373.70390625, -234.23181152344, 43.561828613281, 0, 70}, -- Posição da Camera Matrix aonde o Veículo irá aparecer.
        posicaoveiculo = {-2381.1853027344,-239.62937927246, 42.706840515137 -0.5 , -45}, -- Posição, Rotação Z do Veículo na camera Matrix.
    },
    concessionarias = { 
        {x = 1782.2846679688, y =-1784.681640625, z = 13.677879333496, cor = {0, 255, 127, 0}, blip = 12},
		{x = 2200.930, y =1392.439453125, z = 10.8203125, cor = {0, 255, 127, 0}, blip = 12},
		{x = -1952.5057373047, y =266.0404638672, z = 35.4680, cor = {0, 255, 127, 0}, blip = 12},
    },
    garagens = { 
    {x = -1976.124058594, y = 270.04354858398, z = 35.244494628906, cor = {0, 255, 127, 0}, blip = 55, spawn = {-190.5865478516,20.87847900391,35.17180, -0, 0, 2.3113131523132}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	{x = -1561.694335930, y = -2737.7800292969, z = 48.544494628906, cor = {0, 255, 127, 0}, blip = 55, spawn = {-1557.5228271484,-2740.8073730469,48.544334411621, -0, 0, 151.69703674316}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	{x = -2643.1052246094, y = -54.965141296387, z = 4.335930, cor = {0, 255, 127, 0}, blip = 55, spawn = {-2637.0971679688,-55.329544067383,4.335930, -0, 0, 8.0593147277832}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	{x = -2272.2238769531, y = 2285.6264648438, z = 4.8125, cor = {0, 255, 127, 0}, blip = 55, spawn = {-2272.124058594,2289.1540527344,4.8202133178711, -0, 0, 283.56692504883}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
    {x = -1503.5831298828, y = 2524.5061035156, z = 55.680, cor = {0, 255, 127, 0}, blip = 55, spawn = {-1497.346801078,2524.3430,55.680, -0, 0, 8.7782373428345}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
    {x = 2225.7670898438, y = -102.59796142578, z = 26.48430, cor = {0, 255, 127, 0}, blip = 55, spawn = {2224.4240722656,-97.46459197998,26.335930, -0, 0, 259.54089355469}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
    {x = 1372.041992180, y = 273.98822021484, z = 19.566932678223, cor = {0, 255, 127, 0}, blip = 55, spawn = {130.2353515625,268.24765014648,19.566932678223, -0, 0, 9.5968770980835}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
    {x = 695.04241943359, y = -466.66073608398, z = 16.335930, cor = {0, 255, 127, 0}, blip = 55, spawn = {693.25262451172,-470.01132202148,16.335930, -0, 0, 297.31616210938}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
    {x = 183.61363220215, y = -7.0991735458374, z = 1.578125, cor = {0, 255, 127, 0}, blip = 55, spawn = {179.62580871582,-7.1111989021301,1.578125, -0, 0, 185.73377990723}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
    {x = -580.52258300781, y = -1062.9024658203, z = 23.4804680, cor = {0, 255, 127, 0}, blip = 55, spawn = {-583.64880371094,-1065.082203906,23.39400393677, -0, 0, 242.99473571777}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
    {x = -2118.6350097656, y = -2466.1301269531, z = 30.625, cor = {0, 255, 127, 0}, blip = 55, spawn = {-2122.0178222656,-2470.2062988281,30.625, -0, 0, 53.655372619629}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
    {x = -228.00617980957, y = 2608.9597167969, z = 62.703125, cor = {0, 255, 127, 0}, blip = 55, spawn = {-234.24844360352,2609.6901855469,62.703125, -0, 0, 188.7006835930}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	{x = 192.03868103027, y = 1895.733398430, z = 17.640625, cor = {0, 255, 127, 0}, blip = 55, spawn = {192.3420715332,1889.8187255859,17.640625, -0, 0, 274.72415161133}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	{x = -2493.6896972656, y = 1218.2038574219, z = 37.42180, cor = {0, 255, 127, 0}, blip = 55, spawn = {-2501.220390625,1222.4307861328,37.428329467773, -0, 0, 145.01937866211}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
    {x = 1542.6854248047, y = 2259.4797363281, z = 10.8203125, cor = {0, 255, 127, 0}, blip = 55, spawn = {1539.3944091797,2259.207203906,10.8203125, -0, 0, 186.55702209473}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	{x = 1242.0938720703, y = -1294.554680, z = 13.26800190735, cor = {0, 255, 127, 0}, blip = 55, spawn = {1243.0482177734,-1301.4224853516,13.26800190735, -0, 0, 125.96514892578}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	{x = 320.94195556641, y = -1809.3562011719, z = 4.4786410331726, cor = {0, 255, 127, 0}, blip = 55, spawn = {327.6060048828,-1810.4460449219,4.460072517395, -0, 0, 354.79977416992}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	{x = 2010.369, y = -2447.13, z = 13.547, cor = {0, 255, 127, 0}, blip = 55, spawn = {2010.8524169922,-2450.7614746094,13.54680, -0, 0, 133.38887023926}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	{x = 1496.5443115234, y = -1711.0609130859, z = 13.4680, cor = {0, 255, 127, 0}, blip = 55, spawn = {1500.6033935547,-1710.5935058594,13.4680, -0, 0, 176.55633544922}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem
    {x = 2147.4, y = -1189.514, z = 23.82, cor = {0, 255, 127, 0}, blip = 55, spawn = {2145.697039062,-1185.0744628906,23.8203125, -0, 0, 304.22085571289}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.					 
    {x = 2153.262, y = 995.957, z = 10.82, cor = {0, 255, 127, 0}, blip = 55, spawn = {2151.5991210938,987.52288818359,10.8203125, -0, 0, 359.938012207}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.							 
	{x = 1629.434, y = -1085.118, z = 23.906, cor = {0, 255, 127, 0}, blip = 55, spawn = {1628.4792480469,-1089.4968261719,23.90625, -0, 0, 306.581054680}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	{x = 1725.4455566406, y = -1774.7449951172, z = 13.4921875, cor = {0, 255, 127, 0}, blip = 55, spawn = {1725.0278320312,-1768.4259033203,13.508665084839, -0, 0, 358.79284667969}}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Posição/Rotação do Spawn do Veículo ao Retirar da Garagem.
	
	},
    desmanches = {
        {x = 1266.7182617188, y = -2016.1370849609, z = 59.327928161621, cor = {0, 255, 127, 0}, blip = 36, Acl = "TDT"}, -- Posição X, Posição Y, Posição Z, Cor, Blip, Acl do Desmanche.
    },
    detrans = { 
        {x =1673.0003662109, y = -1121.6612548828, z = 23.926765441895, cor = {0, 255, 127, 200}, blip = 48}, -- Posição X, Posição Y, Posição Z, Cor, Blip do Detran.
    },
    apreensoes = {
        {x = 1650.2954101562, y = -1111.3194580078, z = 23.914033889771, cor = {0, 255, 127, 0}, blip = 58, Acl = "Policial"},-- Posição X, Posição Y, Posição Z, Cor, Blip do Apreensão, Acl da Apreensão.
    },
    veiculos = {
        -- Motos
        {name = "PCX", model = 462, price = 12000, mark = "Honda", velocity = 342, capacity = 90},
        {name = "XT-660", model = 468, price = 30000, mark = "Honda", velocity = 342, capacity = 90},
		{name = "CB-300", model = 581, price = 50000, mark = "Honda", velocity = 342, capacity = 90},
        {name = "CB-1000", model = 461, price = 90000, mark = "Honda", velocity = 342, capacity = 90},
		{name = "Harley", model = 463, price = 150000, mark = "Harley", velocity = 342, capacity = 90},
        {name = "Kawasaki-Ninja", model = 521, price = 300000, mark = "Kawasaki", velocity = 342, capacity = 90},
		-- Carros
        {name = "Fusca", model = 535, price = 12000, mark = "Volkswagen", velocity = 90, capacity = 90}, -- ok
        {name = "Santana", model = 426, price = 18000, mark = "Volkswagen", velocity = 113, capacity = 90}, -- ok
        {name = "Chevette 76", model = 517, price = 29000, mark = "Chevette 76", velocity = 127, capacity = 90}, --ok
        {name = "Opala 1979", model = 542, price = 35000, mark = "Opala 1979", velocity = 135, capacity = 90}, -- ok
        {name = "Golf GTI 2017", model = 602, price = 55000, mark = "Gof GTI 2017", velocity = 143, capacity = 90}, -- ok
        {name = "Golf G5", model = 479, price = 75000, mark = "Golf G5", velocity = 160, capacity = 90}, -- ok
        {name = "Cruze", model = 580, price = 110000, mark = "Cruze", velocity = 176, capacity = 90}, -- ok
        {name = "Volks Scirocco", model = 401, price = 120000, mark = "Volks Scirocco", velocity = 182, capacity = 90}, -- ok
        {name = "Golf MK6", model = 603, price = 145000, mark = "Golf MK6", velocity = 187, capacity = 90}, -- ok
        {name = "Saveiro Cross", model = 458, price = 165000, mark = "Saveiro Cross", velocity = 196, capacity = 90}, -- ok
        {name = "Ford Taurus", model = 492, price = 188000, mark = "Ford Taurus", velocity = 207, capacity = 90}, -- ok	
        {name = "Jeep Grand", model = 470, price = 210000, mark = "Jeep Grand", velocity = 214, capacity = 90}, -- ok
        {name = "Mustang", model = 554, price = 280000, mark = "Mustang", velocity = 218, capacity = 90}, -- ok
        {name = "Cadilac", model = 579, price = 350000, mark = "Cadilac", velocity = 228, capacity = 90}, -- ok
        {name = "BMW M5", model = 540, price = 500000, mark = "BMW M5", velocity = 235, capacity = 90}, -- ok
        {name = "BMW X5", model = 400, price = 600000, mark = "BMW X5", velocity = 240, capacity = 90}, -- ok
        {name = "Dodge Charger", model = 402, price = 950000, mark = "Dodge Charger", velocity = 246, capacity = 90}, -- ok
        {name = "Truffade Nero", model = 562, price = 1600000, mark = "Truffade Nero", velocity = 256, capacity = 90}, -- ok
        {name = "Ferrari GTB", model = 503, price = 2350000, mark = "Ferrari GTB", velocity = 268, capacity = 90}, -- ok
        {name = "McLaren MP4", model = 415, price = 3100000, mark = "McLaren MP4", velocity = 279, capacity = 90}, -- ok
        {name = "Lambo Huracan", model = 451, price = 3700000, mark = "Lamborghini Huracan", velocity = 290, capacity = 90}, -- ok
        {name = "McLaren 720ST", model = 558, price = 4500000, mark = "McLaren 720ST", velocity = 300, capacity = 90}, -- ok
        {name = "Porsche Boxter", model = 533, price = 5100000, mark = "Porsche Boxter", velocity = 314, capacity = 90}, -- ok
        {name = "Zentorno", model = 436, price = 7000000, mark = "Zentorno", velocity = 323, capacity = 90}, -- ok
        {name = "Nissan GTR", model = 502, price = 10000000, mark = "Nissan GTR", velocity = 339, capacity = 90}, -- ok
        },
} 