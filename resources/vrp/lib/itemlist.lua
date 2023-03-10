-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
	["attachs"] = {
		["index"] = "attachs",
		["name"] = "Modificador de Armas",
		["type"] = "Usável",
		["durability"] = 1,
		["weight"] = 3.25
	},
	["ring"] = {
		["index"] = "ring",
		["name"] = "Aliança de Namoro",
		["type"] = "Usável",
		["weight"] = 0.03,
		["protect"] = true
	},
	["ringbox"] = {
		["index"] = "ringbox",
		["name"] = "Caixa de Aliança",
		["type"] = "Usável",
		["weight"] = 0.75,
		["protect"] = true
	},
	["attachsFlashlight"] = {
		["index"] = "attachsFlashlight",
		["name"] = "Lanterna Tatica",
		["type"] = "Usável",
		["weight"] = 0.75
	},
	["attachsCrosshair"] = {
		["index"] = "attachsCrosshair",
		["name"] = "Mira Holográfica",
		["type"] = "Usável",
		["weight"] = 0.75
	},
	["attachsSilencer"] = {
		["index"] = "attachsSilencer",
		["name"] = "Silenciador",
		["type"] = "Usável",
		["weight"] = 0.75
	},
	["attachsGrip"] = {
		["index"] = "attachsGrip",
		["name"] = "Empunhadura",
		["type"] = "Usável",
		["weight"] = 0.75
	},
	["cheese"] = {
		["index"] = "cheese",
		["name"] = "Queijo",
		["type"] = "Comum",
		["weight"] = 0.75
	},
	["wheat"] = {
		["index"] = "wheat",
		["name"] = "Trigo",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["silk"] = {
		["index"] = "silk",
		["name"] = "Seda",
		["type"] = "Comum",
		["weight"] = 0.18
	},
	["packaging"] = {
		["index"] = "packaging",
		["name"] = "Embalagem",
		["type"] = "Comum",
		["weight"] = 0.05
	},
	["techtrash"] = {
		["index"] = "techtrash",
		["name"] = "Lixo Eletrônico",
		["type"] = "Comum",
		["weight"] = 0.65
	},
	["tarp"] = {
		["index"] = "tarp",
		["name"] = "Lona",
		["type"] = "Comum",
		["weight"] = 0.45
	},
	["sheetmetal"] = {
		["index"] = "sheetmetal",
		["name"] = "Chapa de Metal",
		["type"] = "Comum",
		["weight"] = 0.15
	},
	["steelplate"] = {
		["index"] = "steelplate",
		["name"] = "Chapa de Aço",
		["type"] = "Comum",
		["weight"] = 0.15
	},
	["roadsigns"] = {
		["index"] = "roadsigns",
		["name"] = "Placas de Trânsito",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["leather"] = {
		["index"] = "leather",
		["name"] = "Couro",
		["type"] = "Comum",
		["weight"] = 0.05
	},
	["explosives"] = {
		["index"] = "explosives",
		["name"] = "Explosivos",
		["type"] = "Comum",
		["weight"] = 0.15
	},
	["identity"] = {
		["index"] = "identity",
		["name"] = "Passaporte",
		["type"] = "Usável",
		["weight"] = 0.10
	},
	["spring"] = {
		["index"] = "spring",
		["name"] = "Mola",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["projectile"] = {
		["index"] = "projectile",
		["name"] = "Projétil",
		["type"] = "Comum",
		["weight"] = 0.05
	},
	["gunpowder"] = {
		["index"] = "gunpowder",
		["name"] = "Pólvora",
		["type"] = "Comum",
		["weight"] = 0.05
	},
	["capsule"] = {
		["index"] = "capsule",
		["name"] = "Cápsula",
		["type"] = "Comum",
		["weight"] = 0.05
	},
	["pistolmagazine"] = {
		["index"] = "pistolmagazine",
		["name"] = "Carregador de Pistola",
		["type"] = "Comum",
		["weight"] = 0.15
	},
	["smgmagazine"] = {
		["index"] = "smgmagazine",
		["name"] = "Carregador de SMG",
		["type"] = "Comum",
		["weight"] = 0.15
	},
	["riflemagazine"] = {
		["index"] = "riflemagazine",
		["name"] = "Carregador de Rifle",
		["type"] = "Comum",
		["weight"] = 0.15
	},
	["pistolbody"] = {
		["index"] = "pistolbody",
		["name"] = "Corpo de Pistola",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["smgbody"] = {
		["index"] = "smgbody",
		["name"] = "Corpo de SMG",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["riflebody"] = {
		["index"] = "riflebody",
		["name"] = "Corpo de Rifle",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["cotton"] = {
		["index"] = "cotton",
		["name"] = "Algodão",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["plaster"] = {
		["index"] = "plaster",
		["name"] = "Esparadrapo",
		["type"] = "Comum",
		["weight"] = 0.35
	},
	["sulfuric"] = {
		["index"] = "sulfuric",
		["name"] = "Ácido Sulfúrico",
		["type"] = "Usável",
		["weight"] = 0.45
	},
	["saline"] = {
		["index"] = "saline",
		["name"] = "Soro Fisiológico",
		["type"] = "Comum",
		["weight"] = 0.45
	},
	["defibrillator"] = {
		["index"] = "defibrillator",
		["name"] = "Desfibrilador",
		["type"] = "Usável",
		["durability"] = 3,
		["weight"] = 3.25
	},
	["alcohol"] = {
		["index"] = "alcohol",
		["name"] = "Álcool",
		["type"] = "Comum",
		["weight"] = 0.75
	},
	["wallet"] = {
		["index"] = "wallet",
		["name"] = "Carteira",
		["type"] = "Usável",
		["weight"] = 0.75
	},
	["calcinha"] = {
		["index"] = "calcinha",
		["name"] = "Calcinha",
		["type"] = "Usável",
		["weight"] = 0.75
	},
	["vehkey"] = {
		["index"] = "vehkey",
		["name"] = "Chave Cópia",
		["type"] = "Usável",
		["weight"] = 0.0
	},
	["nitro"] = {
		["index"] = "nitro",
		["name"] = "Nitro",
		["type"] = "Usável",
		["weight"] = 15.00
	},
	["raceCoin"] = {
        ["index"] = "raceCoin",
        ["name"] = "Premiação Corrida",
        ["type"] = "Comum",
        ["weight"] = 0.0
    },
	["bullguer01"] = {
		["index"] = "bullguer01",
		["name"] = "Super",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguer02"] = {
		["index"] = "bullguer02",
		["name"] = "Bullguer",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguer03"] = {
		["index"] = "bullguer03",
		["name"] = "Cheese Please",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguer04"] = {
		["index"] = "bullguer04",
		["name"] = "Chicks",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguer05"] = {
		["index"] = "bullguer05",
		["name"] = "Fisherman",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguer06"] = {
		["index"] = "bullguer06",
		["name"] = "Green One",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguer07"] = {
		["index"] = "bullguer07",
		["name"] = "Lumberjack",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguer08"] = {
		["index"] = "bullguer08",
		["name"] = "Standard",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguer09"] = {
		["index"] = "bullguer09",
		["name"] = "Stencil",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguer10"] = {
		["index"] = "bullguer10",
		["name"] = "Uovo",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguer11"] = {
		["index"] = "bullguer11",
		["name"] = "Cheese Fries",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 3
	},
	["bullguer12"] = {
		["index"] = "bullguer12",
		["name"] = "Crinkles",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 3
	},
	["bullguer13"] = {
		["index"] = "bullguer13",
		["name"] = "Cheese Club",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 3
	},
	["bullguer14"] = {
		["index"] = "bullguer14",
		["name"] = "Smash Club",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 3
	},
	["bullguer15"] = {
		["index"] = "bullguer15",
		["name"] = "Bulldog",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 3
	},
	["bullguer16"] = {
		["index"] = "bullguer16",
		["name"] = "Hotdog",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 3
	},
	["bullguer17"] = {
		["index"] = "bullguer17",
		["name"] = "50-50",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 4
	},
	["bullguer18"] = {
		["index"] = "bullguer18",
		["name"] = "Berrie Lemonade",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 4
	},
	["bullguer19"] = {
		["index"] = "bullguer19",
		["name"] = "Brownie com Sorvete",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 2
	},
	["bullguerfood"] = {
		["index"] = "bullguerfood",
		["name"] = "Caixa de Hamburger",
		["type"] = "Comum",
		["weight"] = 0.15,
		["max"] = 1
	},
	["bullguerjuice"] = {
		["index"] = "bullguerjuice",
		["name"] = "Copo de Suco",
		["type"] = "Comum",
		["weight"] = 0.15,
		["max"] = 1
	},
	["bullguerbox"] = {
		["index"] = "bullguerbox",
		["name"] = "Combo",
		["type"] = "Comum",
		["weight"] = 1.00,
		["max"] = 3
	},
	["chips"] = {
		["index"] = "chips",
		["name"] = "Ficha",
		["type"] = "Comum",
		["weight"] = 0.0001
	},
	["airGangs"] = {
		["index"] = "airdrop",
		["name"] = "AirDrop (A)",
		["type"] = "Usável",
		["weight"] = 1.25
	},
	["wheelchair"] = {
		["index"] = "wheelchair",
		["name"] = "Cadeira de Rodas",
		["type"] = "Usável",
		["weight"] = 7.50
	},
	["evidence01"] = {
		["index"] = "evidence01",
		["name"] = "Evidência",
		["type"] = "Evidência",
		["durability"] = 1,
		["weight"] = 0.05
	},
	["evidence02"] = {
		["index"] = "evidence02",
		["name"] = "Evidência",
		["type"] = "Evidência",
		["durability"] = 1,
		["weight"] = 0.05
	},
	["evidence03"] = {
		["index"] = "evidence03",
		["name"] = "Evidência",
		["type"] = "Evidência",
		["durability"] = 1,
		["weight"] = 0.05
	},
	["evidence04"] = {
		["index"] = "evidence04",
		["name"] = "Evidência",
		["type"] = "Evidência",
		["durability"] = 1,
		["weight"] = 0.05
	},
	["rottweiler01"] = {
		["index"] = "rottweiler",
		["name"] = "Coleira de Rottweiler",
		["desc "] = "Durabilidade da mesma é de 1 dia.",
		["type"] = "Animal",
		["durability"] = 1,
		["protect"] = true,
		["weight"] = 1.25
	},
	["rottweiler02"] = {
		["index"] = "rottweiler",
		["name"] = "Coleira de Rottweiler",
		["desc "] = "Durabilidade da mesma é de 3 dias.",
		["type"] = "Animal",
		["durability"] = 3,
		["protect"] = true,
		["weight"] = 1.25
	},
	["rottweiler03"] = {
		["index"] = "rottweiler",
		["name"] = "Coleira de Rottweiler",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["husky01"] = {
		["index"] = "husky",
		["name"] = "Coleira de Husky",
		["desc "] = "Durabilidade da mesma é de 1 dia.",
		["type"] = "Animal",
		["durability"] = 1,
		["protect"] = true,
		["weight"] = 1.25
	},
	["husky02"] = {
		["index"] = "husky",
		["name"] = "Coleira de Husky",
		["desc "] = "Durabilidade da mesma é de 3 dias.",
		["type"] = "Animal",
		["durability"] = 3,
		["protect"] = true,
		["weight"] = 1.25
	},
	["husky03"] = {
		["index"] = "husky",
		["name"] = "Coleira de Husky",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["shepherd01"] = {
		["index"] = "shepherd",
		["name"] = "Coleira de Shepherd",
		["desc "] = "Durabilidade da mesma é de 1 dia.",
		["type"] = "Animal",
		["durability"] = 1,
		["protect"] = true,
		["weight"] = 1.25
	},
	["shepherd02"] = {
		["index"] = "shepherd",
		["name"] = "Coleira de Shepherd",
		["desc "] = "Durabilidade da mesma é de 3 dias.",
		["type"] = "Animal",
		["durability"] = 3,
		["protect"] = true,
		["weight"] = 1.25
	},
	["shepherd03"] = {
		["index"] = "shepherd",
		["name"] = "Coleira de Shepherd",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["retriever01"] = {
		["index"] = "retriever",
		["name"] = "Coleira de Retriever",
		["desc "] = "Durabilidade da mesma é de 1 dia.",
		["type"] = "Animal",
		["durability"] = 1,
		["protect"] = true,
		["weight"] = 1.25
	},
	["retriever02"] = {
		["index"] = "retriever",
		["name"] = "Coleira de Retriever",
		["desc "] = "Durabilidade da mesma é de 3 dias.",
		["type"] = "Animal",
		["durability"] = 3,
		["protect"] = true,
		["weight"] = 1.25
	},
	["retriever03"] = {
		["index"] = "retriever",
		["name"] = "Coleira de Retriever",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["poodle01"] = {
		["index"] = "poodle",
		["name"] = "Coleira de Poodle",
		["desc "] = "Durabilidade da mesma é de 1 dia.",
		["type"] = "Animal",
		["durability"] = 1,
		["protect"] = true,
		["weight"] = 1.25
	},
	["poodle02"] = {
		["index"] = "poodle",
		["name"] = "Coleira de Poodle",
		["desc "] = "Durabilidade da mesma é de 3 dias.",
		["type"] = "Animal",
		["durability"] = 3,
		["protect"] = true,
		["weight"] = 1.25
	},
	["poodle03"] = {
		["index"] = "poodle",
		["name"] = "Coleira de Poodle",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["cat"] = {
		["index"] = "cat",
		["name"] = "Coleira de Gato",
		["desc "] = "Durabilidade da mesma é de 1 dia.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["chicken"] = {
		["index"] = "chicken",
		["name"] = "Coleira de Galinha",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["chimp"] = {
		["index"] = "chimp",
		["name"] = "Coleira de Macaco",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["chimp2"] = {
		["index"] = "chimp2",
		["name"] = "Coleira de Macaco",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["pig"] = {
		["index"] = "pig",
		["name"] = "Coleira de Porco",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["pug01"] = {
		["index"] = "pug",
		["name"] = "Coleira de Pug",
		["desc "] = "Durabilidade da mesma é de 1 dia.",
		["type"] = "Animal",
		["durability"] = 1,
		["protect"] = true,
		["weight"] = 1.25
	},
	["pug02"] = {
		["index"] = "pug",
		["name"] = "Coleira de Pug",
		["desc "] = "Durabilidade da mesma é de 3 dias.",
		["type"] = "Animal",
		["durability"] = 3,
		["protect"] = true,
		["weight"] = 1.25
	},
	["pug03"] = {
		["index"] = "pug",
		["name"] = "Coleira de Pug",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["westy01"] = {
		["index"] = "westy",
		["name"] = "Coleira de Westy",
		["desc "] = "Durabilidade da mesma é de 1 dia.",
		["type"] = "Animal",
		["durability"] = 1,
		["protect"] = true,
		["weight"] = 1.25
	},
	["westy02"] = {
		["index"] = "westy",
		["name"] = "Coleira de Westy",
		["desc "] = "Durabilidade da mesma é de 3 dias.",
		["type"] = "Animal",
		["durability"] = 3,
		["protect"] = true,
		["weight"] = 1.25
	},
	["westy03"] = {
		["index"] = "westy",
		["name"] = "Coleira de Westy",
		["desc "] = "Durabilidade da mesma é de 7 dias.",
		["type"] = "Animal",
		["durability"] = 7,
		["protect"] = true,
		["weight"] = 1.25
	},
	["gloves"] = {
		["index"] = "gloves",
		["name"] = "Luvas",
		["type"] = "Usável",
		["durability"] = 7,
		["weight"] = 0.15
	},
	["card01"] = {
		["index"] = "card01",
		["name"] = "Cartão Classic",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["card02"] = {
		["index"] = "card02",
		["name"] = "Cartão Gold",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["card03"] = {
		["index"] = "card03",
		["name"] = "Cartão Platinum",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["card04"] = {
		["index"] = "card04",
		["name"] = "Cartão Standard",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["card05"] = {
		["index"] = "card05",
		["name"] = "Cartão Black",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["hardness"] = {
		["index"] = "hardness",
		["name"] = "Cinto Reforçado",
		["type"] = "Usável",
		["weight"] = 5.00
	},
	["graphite01"] = {
		["index"] = "graphite01",
		["name"] = "Grafite 1Mg",
		["type"] = "Usável",
		["desc "] = "Repare o Freio Integral do veículo.",
		["weight"] = 0.01
	},
	["graphite02"] = {
		["index"] = "graphite02",
		["name"] = "Grafite 2Mg",
		["type"] = "Usável",
		["desc "] = "Repare o Freio Dianteiro do veículo.",
		["weight"] = 0.01
	},
	["graphite03"] = {
		["index"] = "graphite03",
		["name"] = "Grafite 3Mg",
		["type"] = "Usável",
		["desc "] = "Repare o Freio Traseiro do veículo.",
		["weight"] = 0.01
	},
	["c4"] = {
		["index"] = "c4",
		["name"] = "C4",
		["type"] = "Usável",
		["durability"] = 14,
		["weight"] = 2.50
	},
	["key"] = {
		["index"] = "key",
		["name"] = "Chaves",
		["type"] = "Comum",
		["durability"] = 3,
		["weight"] = 0.25
	},
	["credential"] = {
		["index"] = "credential",
		["name"] = "Credencial",
		["type"] = "Comum",
		["weight"] = 0.75
	},
	["radio"] = {
		["index"] = "radio",
		["name"] = "Rádio",
		["type"] = "Usável",
		["durability"] = 30,
		["weight"] = 0.75
	},
	["backpack"] = {
		["index"] = "backpack",
		["name"] = "Mochila",
		["type"] = "Usável",
		["weight"] = 4.25
	},
	["vest"] = {
		["index"] = "vest",
		["name"] = "Colete",
		["type"] = "Usável",
		["durability"] = 7,
		["weight"] = 2.25
	},
	["bandage"] = {
		["index"] = "bandage",
		["name"] = "Bandagem",
		["type"] = "Usável",
		["weight"] = 0.10,
		["max"] = 3
	},
	["medkit"] = {
		["index"] = "medkit",
		["name"] = "Kit Médico",
		["type"] = "Usável",
		["weight"] = 0.45,
		["max"] = 2
	},
	["adrenaline"] = {
		["index"] = "adrenaline",
		["name"] = "Adrenalina",
		["type"] = "Usável",
		["weight"] = 0.35
	},
	["pouch"] = {
		["index"] = "pouch",
		["name"] = "Malote",
		["type"] = "Comum",
		["weight"] = 0.75
	},
	["woodlog"] = {
		["index"] = "woodlog",
		["name"] = "Tora de Madeira",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["fishingrod"] = {
		["index"] = "fishingrod",
		["name"] = "Vara de Pescar",
		["type"] = "Usável",
		["durability"] = 14,
		["weight"] = 2.75
	},
	["switchblade"] = {
		["index"] = "switchblade",
		["name"] = "Canivete",
		["type"] = "Usável",
		["desc "] = "Utilizada para remoção de carne.",
		["durability"] = 14,
		["weight"] = 0.75
	},
	["octopus"] = {
		["index"] = "octopus",
		["name"] = "Polvo",
		["type"] = "Comum",
		["weight"] = 0.75
	},
	["shrimp"] = {
		["index"] = "shrimp",
		["name"] = "Camarão",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["carp"] = {
		["index"] = "carp",
		["name"] = "Carpa",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["codfish"] = {
		["index"] = "codfish",
		["name"] = "Bacalhau",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["catfish"] = {
		["index"] = "catfish",
		["name"] = "Bagre",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["goldenfish"] = {
		["index"] = "goldenfish",
		["name"] = "Dourado",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["horsefish"] = {
		["index"] = "horsefish",
		["name"] = "Cavala",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["tilapia"] = {
		["index"] = "tilapia",
		["name"] = "Tilápia",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["pacu"] = {
		["index"] = "pacu",
		["name"] = "Pacu",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["pirarucu"] = {
		["index"] = "pirarucu",
		["name"] = "Pirarucu",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["tambaqui"] = {
		["index"] = "tambaqui",
		["name"] = "Tambaqui",
		["type"] = "Comum",
		["weight"] = 0.75
	},
	["bait"] = {
		["index"] = "bait",
		["name"] = "Isca",
		["type"] = "Comum",
		["weight"] = 0.25,
		["max"] = 35
	},
	["meatA"] = {
		["index"] = "meat",
		["name"] = "Carne Animal",
		["desc "] = "Corte nobre de classe A.",
		["type"] = "Comum",
		["weight"] = 0.75
	},
	["meatB"] = {
		["index"] = "meat2",
		["name"] = "Carne Animal",
		["desc "] = "Corte nobre de classe B.",
		["type"] = "Comum",
		["weight"] = 0.75
	},
	["meatC"] = {
		["index"] = "meat3",
		["name"] = "Carne Animal",
		["desc "] = "Corte nobre de classe C.",
		["type"] = "Comum",
		["weight"] = 0.75
	},
	["meatS"] = {
		["index"] = "meat4",
		["name"] = "Carne Animal",
		["desc "] = "Corte nobre de classe S.",
		["type"] = "Comum",
		["weight"] = 0.75
	},
	["animalpelt"] = {
		["index"] = "animalpelt",
		["name"] = "Pele Animal",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["horndeer"] = {
		["index"] = "horndeer",
		["name"] = "Chifre de Cervo",
		["type"] = "Comum",
		["weight"] = 4.00
	},
	["wheatflour"] = {
		["index"] = "wheatflour",
		["name"] = "Farinha de Trigo",
		["type"] = "Usável",
		["weight"] = 2.00
	},
	["joint"] = {
		["index"] = "joint",
		["name"] = "Baseado",
		["type"] = "Usável",
		["storage"] = 10,
		["weight"] = 0.50
	},
	["codeine"] = {
		["index"] = "codeine",
		["name"] = "Codeína",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["weed"] = {
		["index"] = "weed",
		["name"] = "Maconha",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["weedleaf"] = {
		["index"] = "weedleaf",
		["name"] = "Folha de Maconha",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["fertilizer"] = {
		["index"] = "fertilizer",
		["name"] = "Fertilizante",
		["type"] = "Comum",
		["weight"] = 5.0
	},
	["weedseed"] = {
		["index"] = "weedseed",
		["name"] = "Semente de Maconha",
		["type"] = "Usável",
		["weight"] = 0.10
	},
	["babybottle"] = {
		["index"] = "babybottle",
		["name"] = "Mamadeira",
		["type"] = "Usável",
		["weight"] = 0.25
	},
	["lollipop"] = {
		["index"] = "lollipop",
		["name"] = "Pirulito",
		["type"] = "Usável",
		["weight"] = 0.15
	},
	["candy"] = {
		["index"] = "candy",
		["name"] = "Doce",
		["type"] = "Usável",
		["weight"] = 0.15
	},
	["lean"] = {
		["index"] = "lean",
		["name"] = "Lean",
		["type"] = "Usável",
		["weight"] = 0.50,
		["max"] = 6
	},
	["ecstasy"] = {
		["index"] = "ecstasy",
		["name"] = "Ecstasy",
		["type"] = "Usável",
		["storage"] = 10,
		["weight"] = 0.50
	},
	["coca-paste"] = {
		["index"] = "coca-paste",
		["name"] = "Pasta Base",
		["type"] = "Usável",
		["weight"] = 0.15
	},
	["coca-leaf"] = {
		["index"] = "leaf",
		["name"] = "Folha de Coca",
		["type"] = "Usável",
		["weight"] = 0.15
	},
	["amphetamine"] = {
		["index"] = "amphetamine",
		["name"] = "Anfetamina",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["cocaine"] = {
		["index"] = "cocaine",
		["name"] = "Cocaína",
		["type"] = "Usável",
		["storage"] = 10,
		["weight"] = 0.50
	},
	["cokeseed"] = {
		["index"] = "cokeseed",
		["name"] = "Semente de Cocaína",
		["type"] = "Usável",
		["weight"] = 0.10
	},
	["cokeleaf"] = {
		["index"] = "cokeleaf",
		["name"] = "Folha de Coca",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["methcrystal"] = {
		["index"] = "methcrystal",
		["name"] = "Cristal de Metanfetamina",
		["type"] = "Usável",
		["weight"] = 0.10
	},
	["meth"] = {
		["index"] = "meth",
		["name"] = "Metanfetamina",
		["type"] = "Usável",
		["storage"] = 10,
		["weight"] = 0.50
	},
	["acetone"] = {
		["index"] = "acetone",
		["name"] = "Acetona",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["baby"] = {
		["index"] = "baby",
		["name"] = "VIP Baby - 30 Dias",
		["type"] = "Usável",
		["protect"] = true,
		["weight"] = 0.00
	},
	["premium01"] = {
		["index"] = "premium01",
		["name"] = "VIP Basic - 30 Dias",
		["type"] = "Usável",
		["protect"] = true,
		["weight"] = 0.00
	},
	["premium02"] = {
		["index"] = "premium02",
		["name"] = "VIP Standard - 30 Dias",
		["type"] = "Usável",
		["protect"] = true,
		["weight"] = 0.00
	},
	["premium03"] = {
		["index"] = "premium03",
		["name"] = "VIP Advanced - 30 Dias",
		["type"] = "Usável",
		["protect"] = true,
		["weight"] = 0.00
	},
	["premium04"] = {
		["index"] = "premium04",
		["name"] = "VIP Premium - 30 Dias",
		["type"] = "Usável",
		["protect"] = true,
		["weight"] = 0.00
	},
	["premium05"] = {
		["index"] = "premium05",
		["name"] = "VIP Ultimate - 30 Dias",
		["type"] = "Usável",
		["protect"] = true,
		["weight"] = 0.00
	},
	["newgarage"] = {
		["index"] = "newgarage",
		["name"] = "+1 Garagem",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Limite de garagem em +1.",
		["weight"] = 0.00
	},
	["premiumplate"] = {
		["index"] = "platepremium",
		["name"] = "Placa Premium",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Troca a placa de registro do veículo.",
		["weight"] = 0.00
	},
	["newchars"] = {
		["index"] = "newchars",
		["name"] = "+1 Personagem",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Limite de personagem em +1.",
		["weight"] = 0.00
	},
	["newprops"] = {
		["index"] = "newprops",
		["name"] = "+1 Propriedade",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Limite de propriedade em +1.",
		["weight"] = 0.00
	},
	["chip"] = {
		["index"] = "chip",
		["name"] = "Chip Telefônico",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Troca o número telefônico.",
		["weight"] = 0.00
	},
	["namechange"] = {
		["index"] = "namechange",
		["name"] = "Troca de Nome",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Troca o nome do personagem.",
		["weight"] = 0.00
	},
	["surnamechange"] = {
		["index"] = "namechange",
		["name"] = "Troca de Apelido",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Troca o apelido do personagem.",
		["weight"] = 0.00
	},
	["homecont01"] = {
		["index"] = "homecont01",
		["name"] = "Contrato de Propriedade",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Assinatura de contrato do interior 1.",
		["weight"] = 0.00
	},
	["homecont02"] = {
		["index"] = "homecont02",
		["name"] = "Contrato de Propriedade",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Assinatura de contrato do interior 2.",
		["weight"] = 0.00
	},
	["homecont03"] = {
		["index"] = "homecont03",
		["name"] = "Contrato de Propriedade",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Assinatura de contrato do interior 3.",
		["weight"] = 0.00
	},
	["homecont04"] = {
		["index"] = "homecont04",
		["name"] = "Contrato de Propriedade",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Assinatura de contrato do interior 4.",
		["weight"] = 0.00
	},
	["homecont05"] = {
		["index"] = "homecont05",
		["name"] = "Contrato de Propriedade",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Assinatura de contrato do interior 5.",
		["weight"] = 0.00
	},
	["homecont06"] = {
		["index"] = "homecont06",
		["name"] = "Contrato de Propriedade",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Assinatura de contrato do interior 6.",
		["weight"] = 0.00
	},
	["homecont07"] = {
		["index"] = "homecont07",
		["name"] = "Contrato de Propriedade",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Assinatura de contrato do interior 7.",
		["weight"] = 0.00
	},
	["homecont08"] = {
		["index"] = "homecont08",
		["name"] = "Contrato de Propriedade",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Assinatura de contrato do interior 8.",
		["weight"] = 0.00
	},
	["homecont09"] = {
		["index"] = "homecont09",
		["name"] = "Contrato de Propriedade",
		["type"] = "Usável",
		["protect"] = true,
		["desc "] = "Assinatura de contrato do interior 9.",
		["weight"] = 0.00
	},
	["energetic"] = {
		["index"] = "energetic",
		["name"] = "Energético",
		["type"] = "Usável",
		["weight"] = 0.25,
		["max"] = 6
	},
	["water"] = {
		["index"] = "water",
		["name"] = "Água",
		["type"] = "Usável",
		["weight"] = 0.15,
		["max"] = 5
	},
	["dirtywater"] = {
		["index"] = "dirtywater",
		["name"] = "Água Suja",
		["type"] = "Usável",
		["weight"] = 0.15,
		["max"] = 3
	},
	["emptybottle"] = {
		["index"] = "emptybottle",
		["name"] = "Garrafa Vazia",
		["type"] = "Usável",
		["weight"] = 0.10,
		["max"] = 5
	},
	["coffee"] = {
		["index"] = "coffee",
		["name"] = "Café",
		["type"] = "Usável",
		["weight"] = 0.15,
		["max"] = 4
	},
	["cola"] = {
		["index"] = "cola",
		["name"] = "Cola",
		["type"] = "Usável",
		["weight"] = 0.15,
		["max"] = 4
	},
	["tacos"] = {
		["index"] = "tacos",
		["name"] = "Tacos",
		["type"] = "Usável",
		["weight"] = 0.25,
		["max"] = 4
	},
	["fries"] = {
		["index"] = "fries",
		["name"] = "Fritas",
		["type"] = "Usável",
		["weight"] = 0.15,
		["max"] = 4
	},
	["soda"] = {
		["index"] = "soda",
		["name"] = "Sprunk",
		["type"] = "Usável",
		["weight"] = 0.15,
		["max"] = 4
	},
	["apple"] = {
		["index"] = "apple",
		["name"] = "Maça",
		["type"] = "Usável",
		["weight"] = 0.25
	},
	["orange"] = {
		["index"] = "orange",
		["name"] = "Laranja",
		["type"] = "Usável",
		["weight"] = 0.25
	},
	["strawberry"] = {
		["index"] = "strawberry",
		["name"] = "Morango",
		["type"] = "Usável",
		["weight"] = 0.15
	},
	["grape"] = {
		["index"] = "grape",
		["name"] = "Uva",
		["type"] = "Usável",
		["weight"] = 0.15
	},
	["tange"] = {
		["index"] = "tange",
		["name"] = "Tangerina",
		["type"] = "Usável",
		["weight"] = 0.25
	},
	["banana"] = {
		["index"] = "banana",
		["name"] = "Banana",
		["type"] = "Usável",
		["weight"] = 0.25
	},
	["passion"] = {
		["index"] = "passion",
		["name"] = "Maracujá",
		["type"] = "Usável",
		["weight"] = 0.25
	},
	["tomato"] = {
		["index"] = "tomato",
		["name"] = "Tomate",
		["type"] = "Usável",
		["weight"] = 0.15
	},
	["mushseed"] = {
		["index"] = "mushseed",
		["name"] = "Semente de Cogumelo",
		["type"] = "Usável",
		["weight"] = 0.10
	},
	["mushroom"] = {
		["index"] = "mushroom",
		["name"] = "Cogumelo",
		["type"] = "Usável",
		["weight"] = 0.15
	},
	["sugar"] = {
		["index"] = "sugar",
		["name"] = "Açucar",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["orangejuice"] = {
		["index"] = "orangejuice",
		["name"] = "Suco de Laranja",
		["type"] = "Usável",
		["weight"] = 0.75,
		["max"] = 4
	},
	["tangejuice"] = {
		["index"] = "tangejuice",
		["name"] = "Suco de Tangerina",
		["type"] = "Usável",
		["weight"] = 0.45,
		["max"] = 4
	},
	["grapejuice"] = {
		["index"] = "grapejuice",
		["name"] = "Suco de Uva",
		["type"] = "Usável",
		["weight"] = 0.45,
		["max"] = 4
	},
	["strawberryjuice"] = {
		["index"] = "strawberryjuice",
		["name"] = "Suco de Morango",
		["type"] = "Usável",
		["weight"] = 0.45,
		["max"] = 4
	},
	["bananajuice"] = {
		["index"] = "bananajuice",
		["name"] = "Suco de Banana",
		["type"] = "Usável",
		["weight"] = 0.45,
		["max"] = 4
	},
	["passionjuice"] = {
		["index"] = "passionjuice",
		["name"] = "Suco de Maracujá",
		["type"] = "Usável",
		["weight"] = 0.45,
		["max"] = 4
	},
	["bread"] = {
		["index"] = "bread",
		["name"] = "Pão",
		["type"] = "Usável",
		["weight"] = 0.25
	},
	["ketchup"] = {
		["index"] = "ketchup",
		["name"] = "Ketchup",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["hamburger"] = {
		["index"] = "hamburger",
		["name"] = "Hambúrguer",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 4
	},
	["hamburger2"] = {
		["index"] = "hamburger2",
		["name"] = "X-Burguer",
		["type"] = "Usável",
		["weight"] = 0.55,
		["max"] = 4
	},
	["hamburger3"] = {
		["index"] = "hamburger3",
		["name"] = "X-Salada",
		["type"] = "Usável",
		["weight"] = 0.55,
		["max"] = 4
	},
	["hamburger4"] = {
		["index"] = "hamburger4",
		["name"] = "X-Bacon",
		["type"] = "Usável",
		["weight"] = 0.55,
		["max"] = 4
	},
	["hamburger5"] = {
		["index"] = "hamburger5",
		["name"] = "X-Picanha",
		["type"] = "Usável",
		["weight"] = 0.55,
		["max"] = 4
	},
	["hotdog"] = {
		["index"] = "hotdog",
		["name"] = "Cachorro-Quente",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 4
	},
	["donut"] = {
		["index"] = "donut",
		["name"] = "Rosquinha",
		["type"] = "Usável",
		["weight"] = 0.25,
		["max"] = 4
	},
	["plate"] = {
		["index"] = "plate",
		["name"] = "Placa",
		["type"] = "Usável",
		["weight"] = 0.50
	},
	["lockpick"] = {
		["index"] = "lockpick",
		["name"] = "Lockpick de Alumínio",
		["desc"] = "Utilizada para roubar veículos.",
		["type"] = "Usável",
		["weight"] = 2.75,
		["charges"] = 6,
		["max"] = 1
	},
	["lockpick2"] = {
		["index"] = "lockpick2",
		["name"] = "Lockpick de Cobre",
		["desc"] = "Utilizada para roubar propriedades.",
		["type"] = "Usável",
		["weight"] = 2.75,
		["charges"] = 6,
		["max"] = 1
	},
	["brokenpick"] = {
		["index"] = "brokenpick",
		["name"] = "Lockpick Quebrado",
		["type"] = "Comum",
		["weight"] = 1.25
	},
	["toolbox"] = {
		["index"] = "toolbox",
		["name"] = "Caixa de Ferramentas",
		["type"] = "Usável",
		["weight"] = 1.75,
		["max"] = 1
	},
	["advtoolbox"] = {
		["index"] = "toolbox",
		["name"] = "Ferramentas Avançadas",
		["type"] = "Usável",
		["weight"] = 2.25,
		["charges"] = 3,
		["max"] = 1
	},
	["tyres"] = {
		["index"] = "tyres",
		["name"] = "Pneu",
		["type"] = "Usável",
		["weight"] = 1.50,
		["max"] = 4
	},
	["notebook"] = {
		["index"] = "notebook",
		["name"] = "Notebook",
		["type"] = "Comum",
		["durability"] = 1,
		["weight"] = 1.25
	},
	["notepad"] = {
		["index"] = "notepad",
		["name"] = "Bloco de Notas",
		["type"] = "Usável",
		["weight"] = 0.25
	},
	["cellphone"] = {
		["index"] = "cellphone",
		["name"] = "Celular",
		["desc "] = "Perfeito para jogar Free Fire.",
		["type"] = "Comum",
		["durability"] = 21,
		["weight"] = 0.75
	},
	["divingsuit"] = {
		["index"] = "divingsuit",
		["name"] = "Roupa de Mergulho",
		["type"] = "Usável",
		["durability"] = 14,
		["weight"] = 4.75
	},
	["handcuff"] = {
		["index"] = "handcuff",
		["name"] = "Algemas",
		["type"] = "Usável",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["rope"] = {
		["index"] = "rope",
		["name"] = "Cordas",
		["type"] = "Usável",
		["durability"] = 7,
		["weight"] = 1.50
	},
	["hood"] = {
		["index"] = "hood",
		["name"] = "Capuz",
		["type"] = "Usável",
		["durability"] = 7,
		["weight"] = 1.50
	},
	["nails"] = {
		["index"] = "nails",
		["name"] = "Pregos",
		["type"] = "Comum",
		["weight"] = 0.075
	},
	["plastic"] = {
		["index"] = "plastic",
		["name"] = "Plástico",
		["type"] = "Comum",
		["weight"] = 0.075
	},
	["glass"] = {
		["index"] = "glass",
		["name"] = "Vidro",
		["type"] = "Comum",
		["weight"] = 0.075
	},
	["rubber"] = {
		["index"] = "rubber",
		["name"] = "Borracha",
		["type"] = "Comum",
		["weight"] = 0.050
	},
	["aluminum"] = {
		["index"] = "aluminum",
		["name"] = "Alumínio",
		["type"] = "Comum",
		["weight"] = 0.075
	},
	["copper"] = {
		["index"] = "copper",
		["name"] = "Cobre",
		["type"] = "Comum",
		["weight"] = 0.075
	},
	["fabric"] = {
		["index"] = "fabric",
		["name"] = "Tecido",
		["type"] = "Comum",
		["weight"] = 0.050
	},
	["titanium"] = {
		["index"] = "titanium",
		["name"] = "Titânio",
		["type"] = "Comum",
		["weight"] = 0.150
	},
	["newspaper"] = {
		["index"] = "newspaper",
		["name"] = "Jornal",
		["type"] = "Comum",
		["weight"] = 0.375
	},
	["paper"] = {
		["index"] = "paper",
		["name"] = "Papel",
		["type"] = "Comum",
		["weight"] = 0.375
	},
	["ritmoneury"] = {
		["index"] = "ritmoneury",
		["name"] = "Ritmoneury",
		["type"] = "Usável",
		["weight"] = 0.25,
		["max"] = 3
	},
	["sinkalmy"] = {
		["index"] = "sinkalmy",
		["name"] = "Sinkalmy",
		["type"] = "Usável",
		["weight"] = 0.25,
		["max"] = 3
	},
	["cigarette"] = {
		["index"] = "cigarette",
		["name"] = "Cigarro",
		["type"] = "Usável",
		["weight"] = 0.05,
		["max"] = 6
	},
	["lighter"] = {
		["index"] = "lighter",
		["name"] = "Isqueiro",
		["durability"] = 14,
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["vape"] = {
		["index"] = "vape",
		["name"] = "Vape",
		["type"] = "Usável",
		["durability"] = 28,
		["weight"] = 0.75
	},
	["dollars"] = {
		["index"] = "dollars",
		["name"] = "Dólares",
		["type"] = "Comum",
		["protect"] = true,
		["weight"] = 0.0001
	},
	["dollarsz"] = {
		["index"] = "dollarsz",
		["name"] = "Dólares Marcados",
		["type"] = "Comum",
		["weight"] = 0.0001
	},
	["battery"] = {
		["index"] = "battery",
		["name"] = "Pilhas",
		["type"] = "Comum",
		["weight"] = 0.20
	},
	["elastic"] = {
		["index"] = "elastic",
		["name"] = "Elástico",
		["type"] = "Comum",
		["weight"] = 0.10
	},
	["plasticbottle"] = {
		["index"] = "plasticbottle",
		["name"] = "Garrafa Plástica",
		["type"] = "Comum",
		["weight"] = 0.20
	},
	["glassbottle"] = {
		["index"] = "glassbottle",
		["name"] = "Garrafa de Vidro",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["metalcan"] = {
		["index"] = "metalcan",
		["name"] = "Lata de Metal",
		["type"] = "Comum",
		["weight"] = 0.20
	},
	["chocolate"] = {
		["index"] = "chocolate",
		["name"] = "Chocolate",
		["type"] = "Usável",
		["weight"] = 0.10,
		["max"] = 4
	},
	["sandwich"] = {
		["index"] = "sandwich",
		["name"] = "Sanduiche",
		["type"] = "Usável",
		["weight"] = 0.25,
		["max"] = 4
	},
	["rose"] = {
		["index"] = "rose",
		["name"] = "Rosa",
		["type"] = "Usável",
		["durability"] = 7,
		["weight"] = 0.15
	},
	["toy"] = {
		["index"] = "toy",
		["name"] = "Super-R",
		["type"] = "Contrabando",
		["weight"] = 0.15
	},
	["cupcake"] = {
		["index"] = "cupcake",
		["name"] = "Cupcake",
		["type"] = "Contrabando",
		["weight"] = 0.15
	},
	["teddy"] = {
		["index"] = "teddy",
		["name"] = "Teddy",
		["type"] = "Usável",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["absolut"] = {
		["index"] = "absolut",
		["name"] = "Absolut",
		["type"] = "Usável",
		["weight"] = 0.25,
		["max"] = 4
	},
	["chandon"] = {
		["index"] = "chandon",
		["name"] = "Chandon",
		["type"] = "Usável",
		["weight"] = 0.35,
		["max"] = 4
	},
	["dewars"] = {
		["index"] = "dewars",
		["name"] = "Dewars",
		["type"] = "Usável",
		["weight"] = 0.25,
		["max"] = 4
	},
	["hennessy"] = {
		["index"] = "hennessy",
		["name"] = "Hennessy",
		["type"] = "Usável",
		["weight"] = 0.25,
		["max"] = 4
	},
	["goldbar"] = {
		["index"] = "goldbar",
		["name"] = "Barra de Ouro",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["binoculars"] = {
		["index"] = "binoculars",
		["name"] = "Binóculos",
		["type"] = "Usável",
		["durability"] = 28,
		["weight"] = 0.75
	},
	["camera"] = {
		["index"] = "camera",
		["name"] = "Câmera",
		["type"] = "Usável",
		["durability"] = 28,
		["weight"] = 2.25
	},
	["WEAPON_HATCHET"] = {
		["index"] = "hatchet",
		["name"] = "Machado",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_BAT"] = {
		["index"] = "bat",
		["name"] = "Bastão de Beisebol",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_KATANA"] = {
		["index"] = "katana",
		["name"] = "Katana",
		["type"] = "Armamento",
		["repair"] = "repairkit01",
		["durability"] = 3,
		["weight"] = 0.75
	},
	["WEAPON_KARAMBIT"] = {
		["index"] = "karambit",
		["name"] = "Karambit",
		["type"] = "Armamento",
		["repair"] = "repairkit01",
		["durability"] = 3,
		["weight"] = 0.75
	},
	["WEAPON_BATTLEAXE"] = {
		["index"] = "battleaxe",
		["name"] = "Machado de Batalha",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_CROWBAR"] = {
		["index"] = "crowbar",
		["name"] = "Pé de Cabra",
		["type"] = "Armamento",
		["durability"] = 1,
		["weight"] = 0.75
	},
	["WEAPON_GOLFCLUB"] = {
		["index"] = "golfclub",
		["name"] = "Taco de Golf",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_HAMMER"] = {
		["index"] = "hammer",
		["name"] = "Martelo",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_MACHETE"] = {
		["index"] = "machete",
		["name"] = "Facão",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_POOLCUE"] = {
		["index"] = "poolcue",
		["name"] = "Taco de Sinuca",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_STONE_HATCHET"] = {
		["index"] = "stonehatchet",
		["name"] = "Machado de Pedra",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_WRENCH"] = {
		["index"] = "wrench",
		["name"] = "Chave Inglesa",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_KNUCKLE"] = {
		["index"] = "knuckle",
		["name"] = "Soco Inglês",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_FLASHLIGHT"] = {
		["index"] = "flashlight",
		["name"] = "Lanterna",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["WEAPON_NIGHTSTICK"] = {
		["index"] = "nightstick",
		["name"] = "Cassetete",
		["type"] = "Armamento",
		["durability"] = 7,
		["weight"] = 0.75
	},
	["CLIP_PISTOL_AMMO:50"] = {
		["index"] = "clippistol",
		["name"] = "Pente de Pistola:50",
		["desc"] = "50 Munições de Pistola.",
		["type"] = "Munição",
		["durability"] = 7,
		["storage"] = 100,
		["weight"] = 1.00,
	},
	["CLIP_PISTOL_AMMO:150"] = {
		["index"] = "clippistol",
		["name"] = "Pente de Pistola:150",
		["desc"] = "150 Munições de Pistola.",
		["type"] = "Munição",
		["durability"] = 7,
		["storage"] = 100,
		["weight"] = 3.00,
	},
	["CLIP_PISTOL_AMMO:250"] = {
		["index"] = "clippistol",
		["name"] = "Pente de Pistola:250",
		["desc"] = "250 Munições de Pistola.",
		["type"] = "Munição",
		["durability"] = 7,
		["storage"] = 100,
		["weight"] = 5.00,
	},
	["CLIP_SMG_AMMO:50"] = {
		["index"] = "clipsmg",
		["name"] = "Pente de SMG:50",
		["desc"] = "50 Munições de SMG.",
		["type"] = "Munição",
		["durability"] = 7,
		["storage"] = 100,
		["weight"] = 1.50,
	},
	["CLIP_SMG_AMMO:150"] = {
		["index"] = "clipsmg",
		["name"] = "Pente de SMG:150",
		["desc"] = "150 Munições de SMG.",
		["type"] = "Munição",
		["durability"] = 7,
		["storage"] = 100,
		["weight"] = 4.50,
	},
	["CLIP_SMG_AMMO:250"] = {
		["index"] = "clipsmg",
		["name"] = "Pente de SMG:250",
		["desc"] = "250 Munições de SMG.",
		["type"] = "Munição",
		["durability"] = 7,
		["storage"] = 100,
		["weight"] = 7.50,
	},
	["CLIP_RIFLE_AMMO:50"] = {
		["index"] = "cliprifle",
		["name"] = "Pente de Fuzil:50",
		["desc"] = "50 Munições de Fuzil.",
		["type"] = "Munição",
		["durability"] = 7,
		["storage"] = 100,
		["weight"] = 2.00,
	},
	["CLIP_RIFLE_AMMO:150"] = {
		["index"] = "cliprifle",
		["name"] = "Pente de Fuzil:150",
		["desc"] = "150 Munições de Fuzil.",
		["type"] = "Munição",
		["durability"] = 7,
		["storage"] = 100,
		["weight"] = 6.00,
	},
	["CLIP_RIFLE_AMMO:250"] = {
		["index"] = "cliprifle",
		["name"] = "Pente de Fuzil:250",
		["desc"] = "250 Munições de Fuzil.",
		["type"] = "Munição",
		["durability"] = 7,
		["storage"] = 100,
		["weight"] = 10.00,
	},
	["WEAPON_PISTOL"] = {
		["index"] = "m1911",
		["name"] = "M1911",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PISTOL_AMMO",
		["durability"] = 7,
		["storage"] = 10,
		["vehicle"] = true,
		["weight"] = 1.25
	},
	["WEAPON_PISTOL_MK2"] = {
		["index"] = "fiveseven",
		["name"] = "FN Five Seven",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PISTOL_AMMO",
		["durability"] = 2,
		["storage"] = 10,
		["vehicle"] = true,
		["weight"] = 1.50
	},
	["WEAPON_COMPACTRIFLE"] = {
		["index"] = "akcompact",
		["name"] = "AK Compact",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SMG_AMMO",
		["durability"] = 7,
		["weight"] = 2.25
	},
	["WEAPON_APPISTOL"] = {
		["index"] = "kochvp9",
		["name"] = "Koch Vp9",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PISTOL_AMMO",
		["durability"] = 7,
		["storage"] = 10,
		["vehicle"] = false,
		["weight"] = 1.25
	},
	["WEAPON_HEAVYPISTOL"] = {
		["index"] = "atifx45",
		["name"] = "Ati FX45",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PISTOL_AMMO",
		["durability"] = 1,
		["vehicle"] = true,
		["weight"] = 1.50
	},
	["WEAPON_MACHINEPISTOL"] = {
		["index"] = "tec9",
		["name"] = "Tec-9",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SMG_AMMO",
		["durability"] = 7,
		["vehicle"] = false,
		["weight"] = 1.75
	},
	["WEAPON_MICROSMG"] = {
		["index"] = "uzi",
		["name"] = "Uzi",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SMG_AMMO",
		["durability"] = 7,
		["storage"] = 10,
		["vehicle"] = false,
		["weight"] = 1.25
	},
	["WEAPON_MINISMG"] = {
		["index"] = "skorpionv61",
		["name"] = "Skorpion V61",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SMG_AMMO",
		["durability"] = 7,
		["vehicle"] = false,
		["weight"] = 1.75
	},
	["WEAPON_SNSPISTOL"] = {
		["index"] = "amt380",
		["name"] = "AMT 380",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PISTOL_AMMO",
		["durability"] = 7,
		["vehicle"] = true,
		["weight"] = 1.00
	},
	["WEAPON_SNSPISTOL_MK2"] = {
		["index"] = "hkp7m10",
		["name"] = "HK P7M10",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PISTOL_AMMO",
		["durability"] = 7,
		["vehicle"] = true,
		["weight"] = 1.25
	},
	["WEAPON_VINTAGEPISTOL"] = {
		["index"] = "m1922",
		["name"] = "M1922",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PISTOL_AMMO",
		["durability"] = 7,
		["vehicle"] = true,
		["weight"] = 1.25
	},
	["WEAPON_PISTOL50"] = {
		["index"] = "desert",
		["name"] = "Desert Eagle",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PISTOL_AMMO",
		["durability"] = 7,
		["vehicle"] = true,
		["weight"] = 1.50
	},
	["WEAPON_REVOLVER"] = {
		["index"] = "magnum",
		["name"] = "Magnum 44",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PISTOL_AMMO",
		["durability"] = 7,
		["vehicle"] = true,
		["weight"] = 1.50
	},
	["WEAPON_COMBATPISTOL"] = {
		["index"] = "glock",
		["name"] = "Glock",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PISTOL_AMMO",
		["durability"] = 1,
		["vehicle"] = true,
		["weight"] = 1.25
	},
	["WEAPON_CARBINERIFLE"] = {
		["index"] = "m4a1",
		["name"] = "M4A1",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_RIFLE_AMMO",
		["durability"] = 1,
		["weight"] = 7.75
	},
	["WEAPON_CARBINERIFLE_MK2"] = {
		["index"] = "m4a4",
		["name"] = "M4A4",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_RIFLE_AMMO",
		["durability"] = 1,
		["weight"] = 8.50
	},
	["WEAPON_ADVANCEDRIFLE"] = {
		["index"] = "tar21",
		["name"] = "Tar-21",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_RIFLE_AMMO",
		["durability"] = 7,
		["weight"] = 7.75
	},
	["WEAPON_BULLPUPRIFLE"] = {
		["index"] = "qbz95",
		["name"] = "QBZ-95",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_RIFLE_AMMO",
		["durability"] = 7,
		["weight"] = 7.75
	},
	["WEAPON_BULLPUPRIFLE_MK2"] = {
		["index"] = "l85",
		["name"] = "L85",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_RIFLE_AMMO",
		["durability"] = 7,
		["weight"] = 7.75
	},
	["WEAPON_SPECIALCARBINE"] = {
		["index"] = "g36c",
		["name"] = "G36C",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_RIFLE_AMMO",
		["durability"] = 7,
		["weight"] = 8.25
	},
	["WEAPON_SPECIALCARBINE_MK2"] = {
		["index"] = "sigsauer556",
		["name"] = "Sig Sauer 556",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_RIFLE_AMMO",
		["durability"] = 7,
		["storage"] = 10,
		["weight"] = 8.25
	},
	["WEAPON_PUMPSHOTGUN"] = {
		["index"] = "mossberg590",
		["name"] = "Mossberg 590",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SHOTGUN_AMMO",
		["durability"] = 1,
		["weight"] = 7.25
	},
	["WEAPON_PUMPSHOTGUN_MK2"] = {
		["index"] = "mossberg590a1",
		["name"] = "Mossberg 590A1",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SHOTGUN_AMMO",
		["durability"] = 7,
		["weight"] = 7.25
	},
	["WEAPON_MUSKET"] = {
		["index"] = "winchester",
		["name"] = "Winchester 1892",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_MUSKET_AMMO",
		["durability"] = 7,
		["weight"] = 6.25
	},
	["WEAPON_SNIPERRIFLE"] = {
		["index"] = "sauer101",
		["name"] = "Sauer 101",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_MUSKET_AMMO",
		["durability"] = 7,
		["weight"] = 8.25
	},
	["WEAPON_SAWNOFFSHOTGUN"] = {
		["index"] = "mossberg500",
		["name"] = "Mossberg 500",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SHOTGUN_AMMO",
		["durability"] = 7,
		["weight"] = 5.75
	},
	["WEAPON_SMG"] = {
		["index"] = "mp5",
		["name"] = "MP5",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SMG_AMMO",
		["durability"] = 1,
		["weight"] = 5.25
	},
	["WEAPON_SMG_MK2"] = {
		["index"] = "evo3",
		["name"] = "Evo-3",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SMG_AMMO",
		["durability"] = 7,
		["storage"] = 10,
		["weight"] = 5.25
	},
	["WEAPON_ASSAULTRIFLE"] = {
		["index"] = "ak103",
		["name"] = "AK-103",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_RIFLE_AMMO",
		["durability"] = 7,
		["weight"] = 7.75
	},
	["WEAPON_ASSAULTRIFLE_MK2"] = {
		["index"] = "ak74",
		["name"] = "AK-74",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_RIFLE_AMMO",
		["durability"] = 7,
		["storage"] = 10,
		["weight"] = 7.75
	},
	["WEAPON_ASSAULTSMG"] = {
		["index"] = "steyraug",
		["name"] = "Steyr AUG",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SMG_AMMO",
		["durability"] = 7,
		["storage"] = 10,
		["weight"] = 5.75
	},
	["WEAPON_GUSENBERG"] = {
		["index"] = "thompson",
		["name"] = "Thompson",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_SMG_AMMO",
		["durability"] = 7,
		["weight"] = 6.25
	},
	["WEAPON_PETROLCAN"] = {
		["index"] = "gallon",
		["name"] = "Galão",
		["type"] = "Armamento",
		["ammo "] = "WEAPON_PETROLCAN_AMMO",
		["weight"] = 1.25
	},
	["GADGET_PARACHUTE"] = {
		["index"] = "parachute",
		["name"] = "Paraquedas",
		["type"] = "Usável",
		["weight"] = 2.25
	},
	["WEAPON_STUNGUN"] = {
		["index"] = "stungun",
		["name"] = "Tazer",
		["type"] = "Armamento",
		["durability"] = 1,
		["weight"] = 0.75
	},
	["WEAPON_PISTOL_AMMO"] = {
		["index"] = "pistolammo",
		["name"] = "Munição de Pistola",
		["type"] = "Munição",
		["weight"] = 0.02
	},
	["WEAPON_SMG_AMMO"] = {
		["index"] = "smgammo",
		["name"] = "Munição de Sub",
		["type"] = "Munição",
		["weight"] = 0.03
	},
	["WEAPON_RIFLE_AMMO"] = {
		["index"] = "rifleammo",
		["name"] = "Munição de Rifle",
		["type"] = "Munição",
		["weight"] = 0.04
	},
	["WEAPON_SHOTGUN_AMMO"] = {
		["index"] = "shotgunammo",
		["name"] = "Munição de Escopeta",
		["type"] = "Munição",
		["weight"] = 0.05
	},
	["WEAPON_MUSKET_AMMO"] = {
		["index"] = "musketammo",
		["name"] = "Munição de Mosquete",
		["type"] = "Munição",
		["weight"] = 0.05,
		["max"] = 50
	},
	["WEAPON_PETROLCAN_AMMO"] = {
		["index"] = "fuel",
		["name"] = "Combustível",
		["type"] = "Munição",
		["weight"] = 0.001
	},
	["pager"] = {
		["index"] = "pager",
		["name"] = "Pager",
		["type"] = "Usável",
		["durability"] = 3,
		["weight"] = 1.25
	},
	["firecracker"] = {
		["index"] = "firecracker",
		["name"] = "Fogos de Artificio",
		["type"] = "Usável",
		["weight"] = 2.25
	},
	["analgesic"] = {
		["index"] = "analgesic",
		["name"] = "Analgésico",
		["type"] = "Usável",
		["weight"] = 0.10,
		["max"] = 5
	},
	["oxy"] = {
		["index"] = "analgesic",
		["name"] = "Oxy",
		["type"] = "Usável",
		["weight"] = 0.10,
		["max"] = 5
	},
	["gauze"] = {
		["index"] = "gauze",
		["name"] = "Gaze",
		["type"] = "Usável",
		["weight"] = 0.07,
		["max"] = 3
	},
	["gsrkit"] = {
		["index"] = "gsrkit",
		["name"] = "Kit Residual",
		["type"] = "Usável",
		["weight"] = 0.75
	},
	["gdtkit"] = {
		["index"] = "gdtkit",
		["name"] = "Kit Químico",
		["type"] = "Usável",
		["weight"] = 0.75
	},
	["emerald"] = {
		["index"] = "emerald",
		["name"] = "Esmeralda",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["diamond"] = {
		["index"] = "diamond",
		["name"] = "Diamante",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["ruby"] = {
		["index"] = "ruby",
		["name"] = "Rubi",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["sapphire"] = {
		["index"] = "sapphire",
		["name"] = "Safira",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["amethyst"] = {
		["index"] = "amethyst",
		["name"] = "Ametista",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["amber"] = {
		["index"] = "amber",
		["name"] = "Âmbar",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["turquoise"] = {
		["index"] = "turquoise",
		["name"] = "Turquesa",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["keyboard"] = {
		["index"] = "keyboard",
		["name"] = "Teclado",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["mouse"] = {
		["index"] = "mouse",
		["name"] = "Mouse",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["silverring"] = {
		["index"] = "silverring",
		["name"] = "Anel de Prata",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["goldring"] = {
		["index"] = "goldring",
		["name"] = "Anel de Ouro",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["silvercoin"] = {
		["index"] = "silvercoin",
		["name"] = "Moeda de Prata",
		["type"] = "Comum",
		["weight"] = 0.01
	},
	["goldcoin"] = {
		["index"] = "goldcoin",
		["name"] = "Moeda de Ouro",
		["type"] = "Comum",
		["weight"] = 0.01
	},
	["watch"] = {
		["index"] = "watch",
		["name"] = "Relógio",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["playstation"] = {
		["index"] = "playstation",
		["name"] = "Playstation",
		["type"] = "Comum",
		["weight"] = 2.00
	},
	["Weedbox"] = {
		["index"] = "gangbox",
		["name"] = "Caixa de Maconha",
		["type"] = "Usável",
		["weight"] = 2.75
	},
	["Cocainebox"] = {
		["index"] = "gangbox",
		["name"] = "Caixa de Cocaína",
		["type"] = "Usável",
		["weight"] = 2.75
	},
	["Ecstasybox"] = {
		["index"] = "gangbox",
		["name"] = "Caixa de Ecstasy",
		["type"] = "Usável",
		["weight"] = 2.75
	},
	["xbox"] = {
		["index"] = "xbox",
		["name"] = "Xbox",
		["type"] = "Comum",
		["weight"] = 1.75
	},
	["legos"] = {
		["index"] = "legos",
		["name"] = "Legos",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["ominitrix"] = {
		["index"] = "ominitrix",
		["name"] = "Ominitrix",
		["type"] = "Contrabando",
		["weight"] = 0.15
	},
	["bracelet"] = {
		["index"] = "bracelet",
		["name"] = "Bracelete",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["dildo"] = {
		["index"] = "dildo",
		["name"] = "Vibrador",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["spray01"] = {
		["index"] = "spray01",
		["name"] = "Desodorante",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["spray02"] = {
		["index"] = "spray02",
		["name"] = "Antisséptico",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["spray03"] = {
		["index"] = "spray03",
		["name"] = "Desodorante",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["spray04"] = {
		["index"] = "spray04",
		["name"] = "Desodorante",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["brick"] = {
		["index"] = "brick",
		["name"] = "Tijolo",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["dices"] = {
		["index"] = "dices",
		["name"] = "Dados",
		["type"] = "Usável",
		["weight"] = 0.25
	},
	["dish"] = {
		["index"] = "dish",
		["name"] = "Prato",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["pan"] = {
		["index"] = "pan",
		["name"] = "Panela",
		["type"] = "Usável",
		["weight"] = 0.50
	},
	["sneakers"] = {
		["index"] = "sneakers",
		["name"] = "Tenis",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["fan"] = {
		["index"] = "fan",
		["name"] = "Ventilador",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["rimel"] = {
		["index"] = "rimel",
		["name"] = "Rímel",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["blender"] = {
		["index"] = "blender",
		["name"] = "Liquidificador",
		["type"] = "Usável",
		["weight"] = 0.50
	},
	["switch"] = {
		["index"] = "switch",
		["name"] = "Interruptor",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["horseshoe"] = {
		["index"] = "horseshoe",
		["name"] = "Ferradura",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["brush"] = {
		["index"] = "brush",
		["name"] = "Escova",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["domino"] = {
		["index"] = "domino",
		["name"] = "Dominó",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["floppy"] = {
		["index"] = "floppy",
		["name"] = "Disquete",
		["type"] = "Comum",
		["durability"] = 1,
		["weight"] = 0.15
	},
	["cup"] = {
		["index"] = "cup",
		["name"] = "Cálice",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["deck"] = {
		["index"] = "deck",
		["name"] = "Baralho",
		["type"] = "Usável",
		["weight"] = 0.15
	},
	["eraser"] = {
		["index"] = "eraser",
		["name"] = "Apagador",
		["type"] = "Comum",
		["weight"] = 0.15
	},
	["pliers"] = {
		["index"] = "pliers",
		["name"] = "Alicate",
		["type"] = "Comum",
		["weight"] = 0.25
	},
	["lampshade"] = {
		["index"] = "lampshade",
		["name"] = "Abajur",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["soap"] = {
		["index"] = "soap",
		["name"] = "Sabonete",
		["type"] = "Usável",
		["weight"] = 0.25
	},
	["slipper"] = {
		["index"] = "slipper",
		["name"] = "Chinelo",
		["type"] = "Comum",
		["weight"] = 0.50
	},
	["blocksignal"] = {
		["index"] = "blocksignal",
		["name"] = "Bloqueador de Sinal",
		["type"] = "Usável",
		["weight"] = 0.55,
		["charges"] = 3,
		["max"] = 1
	},
	["pendrive"] = {
		["index"] = "pendrive",
		["name"] = "Pendrive",
		["type"] = "Comum",
		["durability"] = 1,
		["weight"] = 0.25
	},
	["TOKEN_WEAPON_PISTOL"] = {
		["index"] = "tokenpistol",
		["name"] = "Token - M1911",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_PISTOL_MK2"] = {
		["index"] = "tokenpistol",
		["name"] = "Token - FN Five Seven",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_COMPACTRIFLE"] = {
		["index"] = "tokensmg",
		["name"] = "Token - AK Compact",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_APPISTOL"] = {
		["index"] = "tokenpistol",
		["name"] = "Token - Koch Vp9",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_HEAVYPISTOL"] = {
		["index"] = "tokenpistol",
		["name"] = "Token - Ati FX45",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_MACHINEPISTOL"] = {
		["index"] = "tokensmg",
		["name"] = "Token - Tec-9",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_MICROSMG"] = {
		["index"] = "tokensmg",
		["name"] = "Token - Uzi",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_MINISMG"] = {
		["index"] = "tokensmg",
		["name"] = "Token - Skorpion V61",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_SNSPISTOL"] = {
		["index"] = "tokenpistol",
		["name"] = "Token - AMT 380",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_SNSPISTOL_MK2"] = {
		["index"] = "tokenpistol",
		["name"] = "Token - HK P7M10",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_VINTAGEPISTOL"] = {
		["index"] = "tokenpistol",
		["name"] = "Token - M1922",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_PISTOL50"] = {
		["index"] = "tokenpistol",
		["name"] = "Token - Desert Eagle",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_REVOLVER"] = {
		["index"] = "tokenpistol",
		["name"] = "Token - Magnum 44",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_COMBATPISTOL"] = {
		["index"] = "tokenpistol",
		["name"] = "Token - Glock",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_CARBINERIFLE"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - M4A1",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_CARBINERIFLE_MK2"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - M4A4",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_ADVANCEDRIFLE"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - Tar-21",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_BULLPUPRIFLE"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - QBZ-95",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_BULLPUPRIFLE_MK2"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - L85",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_SPECIALCARBINE"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - G36C",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_SPECIALCARBINE_MK2"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - Sig Sauer 556",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_PUMPSHOTGUN"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - Mossberg 590",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_PUMPSHOTGUN_MK2"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - Mossberg 590A1",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_MUSKET"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - Winchester 1892",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_SNIPERRIFLE"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - Sauer 101",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_SAWNOFFSHOTGUN"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - Mossberg 500",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_SMG"] = {
		["index"] = "tokensmg",
		["name"] = "Token - MP5",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_SMG_MK2"] = {
		["index"] = "tokensmg",
		["name"] = "Token - Evo-3",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_ASSAULTRIFLE"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - AK-103",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_ASSAULTRIFLE_MK2"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - AK-74",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_ASSAULTSMG"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - Steyr AUG",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	},
	["TOKEN_WEAPON_GUSENBERG"] = {
		["index"] = "tokenrifle",
		["name"] = "Token - Thompson",
		["type"] = "Comum",
		["durability"] = 14,
		["weight"] = 0.50
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMBODY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemBody(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function itemIndex(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["index"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMNAME
-----------------------------------------------------------------------------------------------------------------------------------------
function itemName(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["name"]
	end

	return "Deletado"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function itemType(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["type"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMMO
-----------------------------------------------------------------------------------------------------------------------------------------
function itemAmmo(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["ammo"]
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function itemVehicle(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["vehicle"] or false
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemWeight(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["weight"] or 0.0
	end

	return 0.0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMMAXAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemMaxAmount(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["max"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAXSTORAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function ItemMaxStorage(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["storage"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMDESCRIPTION
-----------------------------------------------------------------------------------------------------------------------------------------
function itemDescription(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["desc"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMECONOMY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemEconomy(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["economy"] or "S/V"
	end

	return "S/V"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMDURABILITY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemDurability(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["durability"] or false
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMPROTECT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemProtect(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["protect"] or false
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMCHARGES
-----------------------------------------------------------------------------------------------------------------------------------------
function itemCharges(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["charges"] or nil
	end

	return nil
end