class_name BusinessEngine extends Node

static var nivell_joc
static var min_habilitat := 15
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

static var llista_candidats = []



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	genera_llista_candidats()


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
	var sou_mig = (16576*(1+0.05*lvl))+ 100*(lvl-1)
	var sou = (sou_mig+(sou_mig*(ambicio/100))) * ((randi_range(50,75)/100) if habilitat=="becari" else 1)
	var mitja_habilitats = 100 + (lvl - 1)*10 + ambicio
	var disseny = randi_range(min_habilitat, mitja_habilitats - min_habilitat)
	var enginy = randi_range(min_habilitat, mitja_habilitats - disseny - min_habilitat)
	var informatica = randi_range(min_habilitat, mitja_habilitats - disseny - enginy - min_habilitat)
	var social = mitja_habilitats - disseny - enginy - informatica
	var resposta = {
		"sexe": sexe,
		"nom" : nom,
		"nivell": lvl,
		"ambicio": ambicio,
		"habilitat": habilitat,
		"sou": sou,
		"disseny": disseny,
		"enginy": enginy,
		"informatica": informatica,
		"social": social
		
	}
	#print( str(sexe) + " - " + str(nom) + " - " +str(lvl)+ " - " +str(ambicio)+ " - " +habilitat+ " - " +str(sou)+ " - " + str(disseny)+ " - " +str(enginy)+ " - " +str(informatica)+ " - " +str(social) )
	return resposta
	
static func genera_llista_candidats() -> void:
	for candidat in 4:
		llista_candidats.append(genera_treballador())
	#print(llista_candidats)
