class_name BusinessEngine extends Node

static var nivell_joc
@onready var pantalla = get_tree().root.get_node("Pantalla")
static var min_habilitat := 15
static var posicions_descans = {}
static var posicions_treball = {}
static var llista_noms := [
	[
	"Jose", "Antonio", "Juan", "Manuel", "Francisco", "Luis", "Javier", "Miguel", "Carlos", "Angel",
	"Jesus", "David", "Pedro", "Daniel", "Alejandro", "Maria", "Alberto", "Rafael", "Fernando", "Pablo",
	"Jorge", "Ramon", "Sergio", "Enrique", "Andres", "Diego", "Vicente", "Victor", "Adrian", "Ignacio",
	"Alvaro", "Raul", "Eduardo", "Ivan", "Oscar", "Joaquin", "Ruben", "Santiago", "Roberto", "Mario",
	"Gabriel", "Alfonso", "Jaime", "Marcos", "Ricardo", "Julio", "Emilio", "Salvador", "Hugo", "Guillermo",
	"Tomas", "Julian", "Martin", "Jordi", "Mohamed", "Nicolas", "Agustin", "Felix", "Gonzalo", "Cristian",
	"Cesar", "Josep", "Joan", "Marc", "Sebastian", "Samuel", "Domingo", "Felipe", "Ismael", "Alfredo",
	"Hector", "Lucas", "Mariano", "Aitor", "Alex", "Rodrigo", "Iker", "Xavier", "Esteban", "Gregorio",
	"Alexander", "Marco", "Arturo", "Lorenzo", "Mateo", "Albert", "Borja", "Eugenio", "Cristobal", "Aaron",
	"Joel", "Dario", "Valentin", "Isaac", "German", "Jonathan", "Adolfo", "Christian", "Pau", "Eric"
	],
	[
	"Maria", "Carmen", "Ana", "Isabel", "Dolores", "Pilar", "Teresa", "Rosa", "Josefa", "Cristina",
	"Angeles", "Laura", "Antonia", "Elena", "Marta", "Francisca", "Lucia", "Mercedes", "Luisa", "Concepcion",
	"Rosario", "Jose", "Paula", "Sara", "Raquel", "Juana", "Manuela", "Eva", "Rocio", "Beatriz",
	"Patricia", "Jesus", "Victoria", "Julia", "Belen", "Andrea", "Silvia", "Encarnacion", "Alba", "Esther",
	"Nuria", "Irene", "Montserrat", "Angela", "Sandra", "Inmaculada", "Monica", "Alicia", "Yolanda", "Sonia",
	"Mar", "Marina", "Margarita", "Susana", "Natalia", "Claudia", "Sofia", "Carolina", "Amparo", "Ines",
	"Gloria", "Nieves", "Veronica", "Lourdes", "Soledad", "Carla", "Alejandra", "Daniela", "Luz", "Noelia",
	"Lorena", "Begoña", "Fatima", "Consuelo", "Asuncion", "Olga", "Blanca", "Nerea", "Miriam", "Esperanza",
	"Milagros", "Clara", "Catalina", "Lidia", "Aurora", "Celia", "Magdalena", "Anna", "Emilia", "Adriana",
	"Elisa", "Martina", "Eugenia", "Vanesa", "Virginia", "Ainhoa", "Gema", "Josefina", "Purificacion", "Diana"
	]
]
static var llista_cognoms = [
	"González", "Rodríguez", "Gómez", "Fernández", "López", "Díaz", "Martínez", "Pérez", "García", "Sánchez",
	"Romero", "Sosa", "Torres", "Álvarez", "Ruiz", "Ramírez", "Flores", "Benítez", "Acosta", "Medina",
	"Herrera", "Suárez", "Aguirre", "Giménez", "Gutiérrez", "Pereyra", "Rojas", "Molina", "Castro", "Ortiz",
	"Silva", "Núñez", "Luna", "Juárez", "Cabrera", "Ríos", "Morales", "Godoy", "Moreno", "Ferreyra",
	"Domínguez", "Carrizo", "Peralta", "Castillo", "Ledesma", "Quiroga", "Vega", "Vera", "Muñoz", "Ojeda",
	"Ponce", "Villalba", "Cardozo", "Navarro", "Coronel", "Vázquez", "Ramos", "Vargas", "Cáceres", "Arias",
	"Figueroa", "Córdoba", "Correa", "Maldonado", "Paz", "Rivero", "Miranda", "Mansilla", "Farias", "Roldán",
	"Méndez", "Guzmán", "Agüero", "Hernández", "Lucero", "Cruz", "Páez", "Escobar", "Mendoza", "Barrios",
	"Bustos", "Ávila", "Ayala", "Blanco", "Soria", "Maidana", "Acuña", "Leiva", "Duarte", "Moyano",
	"Campos", "Soto", "Martín", "Valdez", "Bravo", "Chávez", "Velázquez", "Olivera", "Toledo", "Franco"
]

static var llista_habilitats = [
	"desgrava", "becari", "sindicalista", "ionquiDeLaFeina", "fillDeRic", "trepa", "lider", "sabelotodo", "massaSociable", "expert" 
]

static var llista_imatges_personatge = [
	"res://resources/treballador/imatges_treballadors/Character 1.png", 
	"res://resources/treballador/imatges_treballadors/Character 2.png", 
	"res://resources/treballador/imatges_treballadors/Character 3.png", 
	"res://resources/treballador/imatges_treballadors/Character 4.png", 
	"res://resources/treballador/imatges_treballadors/Character 5.png", 
	"res://resources/treballador/imatges_treballadors/Character 6.png", 
	"res://resources/treballador/imatges_treballadors/Character 7.png", 
	"res://resources/treballador/imatges_treballadors/Character 8.png", 
	"res://resources/treballador/imatges_treballadors/Character 9.png", 
	"res://resources/treballador/imatges_treballadors/Character 10.png", 
	"res://resources/treballador/imatges_treballadors/Character 11.png", 
	"res://resources/treballador/imatges_treballadors/Character 12.png", 
	"res://resources/treballador/imatges_treballadors/Character 13.png", 
	"res://resources/treballador/imatges_treballadors/Character 14.png", 
	"res://resources/treballador/imatges_treballadors/Character 15.png", 
	"res://resources/treballador/imatges_treballadors/Character 16.png", 
	"res://resources/treballador/imatges_treballadors/Character 17.png", 
	"res://resources/treballador/imatges_treballadors/Character 18.png"
]

static var llista_candidats = []
static var llista_tasques = []
static var idees_creatives = [
  [
	"Llença", "Organitza", "Publica", "Dissenya", "Contracta", "Personalitza", "Lloga", "Simula",
	"Espia", "Reutilitza", "Dibuixa", "Automatitza", "Envia", "Fabrica", "Programa", "Crea",
	"Estampa", "Construeix", "Interroga", "Reinterpreta", "Grava", "Barreja", "Compra", "Encola",
	"Vesteix", "Compón", "Juga", "Embolica", "Vesteix", "Emula", "Pinta", "Incorpora", "Camufla",
	"Coreografia", "Fotocopia", "Organitza", "Atreu", "Domina", "Reemplaça", "Tatuatge", "Llenca",
	"Sincronitza", "Utilitza", "Reinvindica", "Afegeix", "Anuncia", "Condimenta", "Col·labora", "Juga"
  ],
  [
	"una newsletter perfumada", "un webinar de crits", "un TikTok amb flamencs", "una app de meditació amb reggaeton",
	"un pallasso especialista en SEO", "una tassa amb frases de PPC", "un helicòpter amb pancarta críptica",
	"una crisi de reputació amb llamps", "influencers amb prismàtics", "mems del 2012",
	"un embut de conversió amb plastilina", "una playlist de jingles agressius", "stickers d'Excel",
	"una disfressa de chatbot", "un test A/B de gossos i gats", "una IA que només fa hashtags",
	"el teu ROI a una samarreta", "una landing page en format còmic", "leads freds amb preguntes filosòfiques",
	"la bio de l’empresa com si fos una novel·la", "un podcast amb grills de fons", "un Excel amb sabó",
	"un domini amb accents estranys", "un QR a una fruita", "un chatbot amb roba vintage",
	"un jingle amb galls dindi", "a pedra-paper-email", "un informe SEO amb paper de regal",
	"el community amb una capa", "una startup del 2007", "un KPI sobre una paret",
	"un GIF de llamps en tots els butlletins", "un CTA dins d’un meme de gats",
	"una dansa per anunciar el Black Friday", "una landing en versió fax", "una rave amb LinkedIners",
	"audiències Z amb gifs de dinosaures", "l’art de les fonts Comic Sans", "el copy amb haikus",
	"un insight de Google Analytics", "globus amb CTA", "stories amb les fases lunars",
	"fum de colors per fer branding", "el spam com a forma d'art", "gifs d’explosions en els informes",
	"una API amb un poema èpic", "una estratègia amb memes picants", "amb un ninot de ventríloc",
	"amb colors fluorescents"
  ],
  [
	"per seduir unicorns digitals", "per atraure boomers confusos", "per promocionar croquetes veganes",
	"per relaxar CM sobreestresats", "per millorar el CTR dels memes", "per fidelitzar trolls de Reddit",
	"per anunciar el nou logo minimalista", "per provar la paciència del community", "per robar idees de reels",
	"per generar engagement nostàlgic", "per presentar-lo a la reunió del CEO", "per enviar-la a leads dubtosos",
	"per motivar el teu equip de vendes", "per a la convenció anual de màrqueting", "per descobrir qui converteix més",
	"per fer trending cada diumenge", "per regalar-la a prospectes enfadats", "per captivar gent amb TDAH",
	"per qualificar-los amb estil", "per captar l’atenció dels poetes digitals", "per tranquil·litzar el públic objectiu",
	"per netejar dades brutes", "per posicionar a Mart", "per llançar una campanya experimental",
	"per seduir millennials nostàlgics", "per cridar l’atenció a Thanksgiving", "per decidir l’estratègia trimestral",
	"per entregar-lo amb drama", "per fer-lo superheroi de crisis", "per fer veure que ets retroinnovador",
	"per fer brainstorming mural", "per augmentar la tensió del CTA", "per fer-lo més clicable",
	"per viralitzar el descompte", "per tornar als orígens", "per connectar professionals “en viu”",
	"per generar likes críptics", "per revaloritzar l’humor corporatiu", "per captivar lectors zen",
	"per demostrar compromís amb les dades", "per fer màrqueting al cel", "per captar audiències místicas",
	"per aparèixer a TikTok", "per fer exposicions digitals", "per emocionar els inversors",
	"per llançar una startup vikinga", "per atreure foodies digitals", "per fer vídeos virals amb diàlegs estranys",
	"per cridar l’atenció dels més adormits"
  ]
]
static var noms_empresa = [
	[
  "Super", "Mega", "Micro", "Ultra", "Eco", "Crypto", "Turbo", "Quantum", "Meta", "Pseudo",
  "Retro", "Post", "Neo", "Anti", "Fake", "Giga", "Nano", "Inter", "Bio", "Zero",
  "Extra", "Virtual", "Snack", "Happy", "Sad", "Zen", "Cool", "Tòxic", "Legal", "Espongiforme",
  "Salvatge", "Orgànic", "Funky", "Màgic", "Viral", "Excessiu", "Invisible", "Mutant", "Colossal", "Flexible",
  "Ambidextre", "Sostenible", "Paranoic", "Minúscul", "Barroc", "Disruptiu", "Patatós", "Hipster", "Anàrquic", "Asincrònic"
],
[
  "Algoritme", "Cafè", "Píxel", "Tauró", "Bot", "Influencer", "Mem", "Unicorn", "Croqueta", "Gat",
  "Dron", "Excel", "Server", "Data", "Spam", "Cloud", "Like", "Hashtag", "Bug", "Còmic",
  "Emoji", "IoT", "GIF", "API", "Codi", "Startup", "Zombi", "NFT", "Avatar", "Tuit",
  "Pingüí", "Sushibot", "Monstre", "Troll", "Cookie", "Robot", "Qüantum", "Patró", "Hashtag", "Filtro",
  "Mockup", "Debug", "Click", "PixelArt", "Criptopeix", "Freelancer", "Landing", "Widget", "Captcha", "InfluZilla"
],
[
  "S.A.", "Studio", "Corp", "Lab", "Agency", "Consulting", "Factory", "Universe", "Team", "Unlimited",
  "Express", "Solutions", "del Futur", "del Segle XIX", "del Submón", "del Garatge", "del Bar", "del Tercer Pis", "de la Jungla", "del Codi",
  "Galàctic", "S.L.", "Espacial", "Legalitzada", "Certified", "Randomitzada", "Beta", "de Colors", "Deluxe", "Reutilitzable",
  "Segell", "Dreawoks", "Inc.", "Obsoleta", "Transcendental", "del Bunker", "del Backoffice", "Premium", "de Plàstic", "a la Planxa",
  "Manual", "Autoexec", "del Mercat", "de la Crisi", "Amb Extra de Bug", "Amb Formatge", "En Vers", "En Flashback", "En Loop", "de Dimarts"
]
]

static var llista_material = {
	"planta_plastic" : {
		"tipus": "descans",
		"nom": "Planta de plàstic",
		"descripcio" : "Una planta feta de plàstic, redueix l'estrés. Requereix menys manteniment que un treballador i tenen una intel·ligència similar.",
		"icona": "Planta",
		"preu": 100,
		"h": 64,
		"w": 64,
		"nivell": 1,
		"escena":"res://resources/mobiliari/llocDescans.tscn",
		"atributs": {
			"disseny": 0,
			"enginy": 0,
			"informatica": 0,
			"social": 0,
			"recuperacio_energia": 0
		}
	},
	"taula_treball" : {
		"tipus": "treball",
		"nom": "Taula de treball",
		"descripcio" : "Una taula, per a que els teus treballadors s'estiguin una estona quiets. A veure si es concentren.",
		"icona": "Taula",
		"preu":200,
		"h": 64,
		"w": 64,
		"nivell": 1,
		"escena":"res://resources/mobiliari/llocTreball.tscn",
		"atributs": {
			"disseny": 0,
			"enginy": 0,
			"informatica": 0,
			"social": 0,
			"recuperacio_energia": 0
		}
	},
	"dispensador_aigua" : {
		"tipus": "descans",
		"nom": "Dispensador d'aigua",
		"descripcio" : "Ideal per a que els treballadors s'hidratin mentre descansen. No reomplir amb alcohol, un altre cop no siusplau.",
		"icona": "Aigua",
		"preu": 250,
		"h": 64,
		"w": 64,
		"nivell": 1,
		"escena":"res://resources/mobiliari/llocDescans.tscn",
		"atributs": {
			"disseny": 0,
			"enginy": 0,
			"informatica": 0,
			"social": 0,
			"recuperacio_energia": 0.005
		}
	},
	"taula_llibres" : {
		"tipus": "treball",
		"nom": "Taula amb llibres",
		"descripcio" : "Espai de treball creatiu, amb llibres per colorejar i contes moderns que eviten traumes infantils",
		"icona": "Llibres",
		"preu":350,
		"h": 64,
		"w": 64,
		"nivell": 1,
		"escena":"res://resources/mobiliari/llocTreball.tscn",
		"atributs": {
			"disseny": 0,
			"enginy": 10,
			"informatica": 0,
			"social": 0,
			"recuperacio_energia": 0
		}
	},
	"taula_telefon" : {
		"tipus": "treball",
		"nom": "Taula amb telefon",
		"descripcio" : "Taula equipada amb línia telefònica. Res de smartphones, que ens deprimeixen els comercials.",
		"icona": "Telefon",
		"preu":350,
		"h": 64,
		"w": 64,
		"nivell": 2,
		"escena":"res://resources/mobiliari/llocTreball.tscn",
		"atributs": {
			"disseny": 0,
			"enginy": 0,
			"informatica": 10,
			"social": 0,
			"recuperacio_energia": 0
		}
	},
	"nevera" : {
		"tipus": "descans",
		"nom": "Nevera compartida",
		"descripcio" : "Compartiment refrigerat per a que desin les seves racions d'aliment. Es recomana canviar-la cada dos anys o si un tupper s'hi queda durant tres mesos",
		"icona": "Nevera",
		"preu": 500,
		"h": 64,
		"w": 64,
		"nivell": 2,
		"escena":"res://resources/mobiliari/llocDescans.tscn",
		"atributs": {
			"disseny": 0,
			"enginy": 0,
			"informatica": 0,
			"social": 0,
			"recuperacio_energia": 0.01
		}
	},
	"cafetera" : {
		"tipus": "descans",
		"nom": "Màquina de cafè",
		"descripcio" : "Base de càrrega per a treballadors. Utilitza bateries tipus 'Arabica' o 'Capuccino', en altes quantitats produeix adicció",
		"icona": "Cafetera",
		"preu": 600,
		"h": 64,
		"w": 64,
		"nivell": 3,
		"escena":"res://resources/mobiliari/llocDescans.tscn",
		"atributs": {
			"disseny": 0,
			"enginy": 0,
			"informatica": 0,
			"social": 0,
			"recuperacio_energia": 0.015
		}
	},
	"ordinador" : {
		"tipus": "treball",
		"nom": "Ordinador Personal",
		"descripcio" : "El futur, un Commodore últim model per a que puguin escriure, fer fulls de càlcul o jugar al solitari. El que donen de si 64Kb de RAM",
		"icona": "Ordinador",
		"preu":900,
		"h": 64,
		"w": 64,
		"nivell": 3,
		"escena":"res://resources/mobiliari/llocTreball.tscn",
		"atributs": {
			"disseny": 20,
			"enginy": 0,
			"informatica": 20,
			"social": 0,
			"recuperacio_energia": 0
		}
	},
	"expenedora" : {
		"tipus": "descans",
		"nom": "Màquina Expenedora",
		"descripcio" : "El més semblant a un restaurant que veuran avui els treballadors. Els permet exercir la llibertat de compra. Capitalisme en una capsa. Genial.",
		"icona": "Expenedora",
		"preu": 1000,
		"h": 64,
		"w": 64,
		"nivell": 4,
		"escena":"res://resources/mobiliari/llocDescans.tscn",
		"atributs": {
			"disseny": 0,
			"enginy": 0,
			"informatica": 0,
			"social": 0,
			"recuperacio_energia": 0.02
		}
	},
	"impressora" : {
		"tipus": "treball",
		"nom": "Impressora Multifunció",
		"descripcio" : "Dossiers, informes, novel·les pirata. Si ho pots llegir ho pots imprimir! Així podreu repartir coses a les reunions i els treballadors se sentiran estimats.",
		"icona": "Impressora",
		"preu":1200,
		"h": 64,
		"w": 64,
		"nivell": 4,
		"escena":"res://resources/mobiliari/llocTreball.tscn",
		"atributs": {
			"disseny": 20,
			"enginy": 20,
			"informatica": 20,
			"social": 0,
			"recuperacio_energia": 0
		}
	},
}

static var llista_locals = {
	"Parquing de casa la iaia": {
		"descripcio": "Una habitació que ningú fa servir ja que tràfic va calificar la iaia com a perill públic al volant. A és, mai et faltarà colacao!",
		"treballadors": 2,
		"material": 3,
		"preu": 130,
		"nivell": 1,
		"escena":"res://resources/oficina/local00.tscn"
	},
	"Viver d'empreses": {
		"descripcio": "",
		"treballadors": 4,
		"material": 6,
		"preu": 350,
		"nivell": 2,
		"escena":"res://resources/oficina/local01.tscn"
	},
	"Coworking": {
		"descripcio": "",
		"treballadors": 6,
		"material": 9,
		"preu": 800,
		"nivell":3,
		"escena":"res://resources/oficina/local02.tscn"
	},
	"Local cutre": {
		"descripcio": "",
		"treballadors": 10,
		"material": 15,
		"preu": 1800,
		"nivell":4,
		"escena":"res://resources/oficina/local03.tscn"
	}
}

static var felicitacions = [
	[ # Llista de felicitacions
		"Molt bé,\n",
		"Felicitats,\n",
		"Ho has petat,\n",
		"Ets un crac,\n",
		"Brutal,\n",
		"Vas fort,\n",
		"Quin nivell,\n",
		"Jugues en una altra\nlliga,",
		"Ets un visionari,\n",
		"Ni el Warren Buffett,\n"
	],
	[ # Llista d'apel·latius 'quilles' o barriobajeros
		"Bro!",
		"Màquina!",
		"Monstre!",
		"Tità!",
		"Animal!",
		"Lendakari del capital!",
		"Rei del blockchain!",
		"Killah!",
		"Ninja del mercat!",
		"Cripto-bèstia!"
	]
]

static var queixes = [
	"Els hauries de fer treballar\nmés hores pel que cobren.",
	"No sé si treballen o fan\nturisme laboral en grup.",
	"Van més lents que una\nreunió sense cafè.",
	"Jo crec que es pensen\nque l'horari és opcional.",
	"Si ser improductius fos una\ncompetició, tindrien medalla d’or.",
	"Només es mouen quan sona\nla sirena de plegar.",
	"Treballar? Ells només ho\nfan si no hi ha cap altra opció.",
	"Fan més pausa que feina,\ni encara es queixen.",
	"No sé si estan treballant\no fent una performance d'art lent.",
	"Van tan relaxats que fins\ni tot l’escó està cansat d’ells.",
	"Són tan discrets treballant\nque sembla que no hi siguin.",
	"Treballen amb tanta calma que\nem posen nerviós només de mirar-los.",
	"Només els falta portar\nuna hamaca i un mojito.",
	"Per què fer avui el que\npots ajornar eternament? Oi?",
	"Van a un ritme que ni les\npedres els poden seguir.",
	"Sembla que estiguin en una\nmeditació laboral permanent.",
	"Si cobressin per cada excusa,\nserien milionaris.",
	"Tenen una relació complicada\namb el concepte d’esforç.",
	"Entre pausa i pausa,\npotser fan mitja tasca.",
	"Ells pensen que 'multitasca'\nvol dir parlar i no fer res alhora."
]




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	genera_llista_candidats()
	#genera_llista_tasques()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

static func genera_treballador():
	nivell_joc = Pantalla.nivell
	var sexe = randi_range(0, 1)
	var nom = str(llista_noms[sexe].pick_random()) + " " + str(llista_cognoms.pick_random())
	var lvl = randi_range(1 if nivell_joc/2 < 1 else int(nivell_joc/2), int(nivell_joc+nivell_joc/2))
	var ambicio = randi_range(-10, 10)
	var habilitat = "no" if randi_range(0,1)==1 else llista_habilitats.pick_random()
	var sou_mig = (16576.0*(1.0+0.05*lvl))+ 100.0*(lvl-1)
	print(sou_mig* (ambicio/100.0))
	print(sou_mig* (ambicio/100.0) + sou_mig)
	var sou = (sou_mig* (ambicio/100.0) + sou_mig) * (randf_range(50.0,75.0)/100.0) if habilitat=="becari" else sou_mig* (ambicio/100.0) + sou_mig
	var mitja_habilitats = 100 + (lvl - 1)*10 + ambicio
	var disseny = randi_range(min_habilitat, mitja_habilitats - min_habilitat)
	var enginy = randi_range(min_habilitat, mitja_habilitats - disseny - min_habilitat)
	var informatica = randi_range(min_habilitat, mitja_habilitats - disseny - enginy - min_habilitat)
	var social = mitja_habilitats - disseny - enginy - informatica if mitja_habilitats - disseny - enginy - informatica > 0 else 0
	var imatge = llista_imatges_personatge.pick_random()
	
	var resposta = {
		"sexe": sexe,
		"nom" : nom,
		"nivell": lvl,
		"ambicio": ambicio,
		"habilitat": habilitat,
		"sou": snappedf(sou, 0.01),
		"disseny": disseny,
		"enginy": enginy,
		"informatica": informatica,
		"social": social,
		"imatge": imatge
	}
	#print(resposta)
	return resposta
	
static func genera_llista_candidats() -> void:
	llista_candidats = []
	for candidat in 4:
		llista_candidats.append(genera_treballador())
	
func genera_tasca() -> Dictionary:
	var nom_tasca = idees_creatives[0].pick_random() + " " + idees_creatives[1].pick_random() + " " + idees_creatives[2].pick_random()
	var empresa = noms_empresa[0].pick_random() + noms_empresa[1].pick_random() + " " +noms_empresa[2].pick_random()
	var durada = randi_range(5,15)
	var dificultat = randf_range(0.5, 1.5)
	var punts_necessaris = 50 * dificultat * pantalla.maxim_treballadors * durada
	var recompensa = int(punts_necessaris * 1.5)
	var stat = ["disseny", "enginy", "informatica"].pick_random()
	var retorn = {
		"nom": empresa,
		"tasca": nom_tasca,
		"durada":durada,
		"dies_restants": durada,
		"recompensa": recompensa,
		"penyora": recompensa/2,
		"dificultat": dificultat,
		"feina": punts_necessaris,
		"stat_important": stat
	}
	#print(str(dificultat) + " - " +str(Pantalla.maxim_treballadors ) + " - "+ str(durada) + " - "+ str(punts_necessaris))
	#print(retorn)
	return retorn
	
func genera_llista_tasques() -> void:
	llista_tasques = []
	for tasca in 4:
		llista_tasques.append(genera_tasca())
		

static func assigna_posicio_treball() -> Vector2:
	for pos in posicions_treball:
		if posicions_treball[pos] == "lliure":
			posicions_treball[pos] = "reservat"
			return pos
	return Vector2.INF  # Cap lloc disponible

	
static func assigna_posicio_descans() -> Vector2:
	for pos in posicions_descans:
		if posicions_descans[pos] == "lliure":
			posicions_descans[pos] = "reservat"
			return pos
	return Vector2.INF 
