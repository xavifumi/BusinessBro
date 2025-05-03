class_name Pantalla extends Node2D
@onready var plantilla: Node = %Plantilla


static var llista_treballadors = []
static var maxim_treballadors := 2
static var treballador_temp
static var punt_nou_treballador : Vector2
static var nivell := 1
static var diners := 0
var diners_inicials := 30000
static var tenim_tasca := true
static var tasca_exemple = {
	"nom": "Pla de Marketing",
	"dies_restants": 10,
	"recompensa": 750,
	"penyora": 300,
	"feina":400
}

static var tasca_actual = {
}

static var feina_acumulada = {
	"disseny": 0,
	"enginy": 0,
	"informatica": 0
}

static var feina_total_acumulada = 0
static var fitxatge_treballador = preload("res://resources/treballador/treballador.tscn")
var button_feina 

var objecte_instance : Node2D = null
var mode_precol·locacio := false
var node_oficina : Node = null
var tipus_actual : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	diners = diners_inicials
	#maxim_treballadors = 2
	var temp_pos_treballador = get_node("Oficina/PuntInici").position
	punt_nou_treballador = temp_pos_treballador
	for node in get_node("Oficina/descans").get_children():
		BusinessEngine.posicions_descans[node.global_position] = "lliure" 
	for node in get_node("Oficina/treball").get_children():
		BusinessEngine.posicions_treball[node.global_position] = "lliure" 
	print("posicions treball: " + str(BusinessEngine.posicions_treball))
	print("posicions esbarjo: " + str(BusinessEngine.posicions_descans))
	print(" - ")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#var label_diners = get_node("Control/labelDiners")
	var label_diners = get_node("Ux/PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid")
	#var progres_feina = UX.feina_info
	#progres_feina.max_value = tasca_actual["feina"] if tasca_actual.size() != 0 else 0
	feina_total_acumulada = feina_acumulada["disseny"] + feina_acumulada["enginy"] + feina_acumulada["informatica"]
	#progres_feina.value = feina_total_acumulada
	label_diners.text = str(diners) + "€"
	if tasca_actual.size() != 0:
		_feina_in_progress()
	
	
	if mode_precol·locacio and objecte_instance:
		var mouse_pos = get_global_mouse_position()
		var snapped_pos = Vector2i(round(mouse_pos.x / 64), round(mouse_pos.y / 64)) * 64
		objecte_instance.global_position = snapped_pos

	
func _feina_in_progress()->void:
	#var progres_feina = get_node("Oficina/treball/ProgressBar")
	if tasca_actual["dies_restants"] > 0:
		if tasca_actual["feina"] <= feina_total_acumulada:
			diners += tasca_actual["recompensa"]
			tasca_actual = {}
			feina_acumulada = {
				"disseny": 0,
				"enginy": 0,
				"informatica": 0
			}
			feina_total_acumulada = 0
			get_node("%Confetti").dispara_confetti()
			#progres_feina.value = feina_total_acumulada
	else:
		diners -= tasca_actual.penyora
		tasca_actual = {}
		feina_acumulada = {
				"disseny": 0,
				"enginy": 0,
				"informatica": 0
			}
		feina_total_acumulada = 0
	
static func _on_button_feina_pressed() -> void:
	tasca_actual = tasca_exemple.duplicate()

static func contracta_treballador(treballador_cont_temp: Dictionary, index: int) -> void:
	llista_treballadors.append(treballador_cont_temp)
	# Afegir treballador
	BusinessEngine.llista_candidats.remove_at(index)
	#print(llista_treballadors)

static func afegeix_treballador(ubicacio: Node) -> void:
	var fitxatge_treballador_temp = fitxatge_treballador.instantiate()
	fitxatge_treballador_temp.atributs["nom"] = treballador_temp.nom
	fitxatge_treballador_temp.atributs["nivell"] = treballador_temp.nivell
	fitxatge_treballador_temp.atributs["sou"] = treballador_temp.sou
	fitxatge_treballador_temp.atributs["disseny"] = treballador_temp.disseny
	fitxatge_treballador_temp.atributs["enginy"] = treballador_temp.enginy
	fitxatge_treballador_temp.atributs["informatica"] = treballador_temp.informatica
	fitxatge_treballador_temp.atributs["social"] = treballador_temp.social
	fitxatge_treballador_temp.position = punt_nou_treballador
	ubicacio.add_child(fitxatge_treballador_temp)


func carregar_i_precol·locar(data: Dictionary) -> void:
	var escena_path = data.get("escena", "")
	tipus_actual = data.get("tipus", "descans")

	if escena_path == "":
		push_error("No s'ha especificat el camí de l'escena.")
		return

	var escena_precarregada = load(escena_path)
	objecte_instance = escena_precarregada.instantiate()
	objecte_instance.modulate.a = 0.5

	node_oficina = $Oficina  # Instància existent de l’escena Oficina
	print()
	var target_node = tipus_actual == "treball" if node_oficina.get_node("treball") else node_oficina.get_node("descans")
	target_node.add_child(objecte_instance)

	mode_precol·locacio = true
	set_process(true)


func _input(event: InputEvent) -> void:
	if not (mode_precol·locacio and event is InputEventMouseButton and event.pressed):
		return

	var mouse_pos = get_global_mouse_position()
	var snapped_tile = Vector2i(round(mouse_pos.x / 64), round(mouse_pos.y / 64))
	var snapped_pos = snapped_tile * 64

	# Verificar si ja hi ha un objecte en aquesta posició
	if (tipus_actual == "treball" and BusinessEngine.posicions_treball.has(snapped_tile)) or \
		(tipus_actual == "descans" and BusinessEngine.posicions_descans.has(snapped_tile)):
		print("Ja hi ha un objecte en aquesta posició!")
		objecte_instance.queue_free()
		objecte_instance = null
		mode_precol·locacio = false
		set_process(false)
		return

	# Verificar si la tile és construïble
	var fons = node_oficina.get_node("fons") as TileMap
	var tile_coords = fons.local_to_map(fons.to_local(snapped_pos))
	var tile_data = fons.get_cell_tile_data(0, tile_coords)

	if tile_data and tile_data.get_custom_data("construible"):
		objecte_instance.modulate.a = 1.0
		objecte_instance.global_position = snapped_pos
		mode_precol·locacio = false
		set_process(false)

		# Registrar la posició
		if tipus_actual == "treball":
			BusinessEngine.posicions_treball[snapped_tile] = objecte_instance
		else:
			BusinessEngine.posicions_descans[snapped_tile] = objecte_instance
	else:
		print("No es pot construir en aquesta posició.")
		objecte_instance.queue_free()
		objecte_instance = null
		mode_precol·locacio = false
		set_process(false)
