class_name Pantalla extends Node2D
@onready var plantilla: Node = %Plantilla

var label 
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

var feina_total_acumulada : float
static var fitxatge_treballador = preload("res://resources/treballador/treballador.tscn")
var so_error = "res://resources/oficina/resources/327738__distillerystudio__error_01.wav"
var button_feina 

var objecte_instance : Node2D = null
var mode_precol·locacio := false
var node_oficina : Node = null
var tipus_actual : String = ""

func _ready() -> void:
	set_process(true) # Activem el process des del principi
	label = get_node("Label")
	diners = diners_inicials
	var temp_pos_treballador = get_node("Oficina/PuntInici").position
	punt_nou_treballador = temp_pos_treballador
	actualitza_llistes_posicions()

func _process(_delta: float) -> void:
	_actualitza_ui()
	_gestiona_feina()
	if mode_precol·locacio:
		_actualitza_precol·locacio()

func _actualitza_ui() -> void:
	var label_diners = get_node("Ux/PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid")
	label_diners.text = str(diners) + "€"
	label.text = str(feina_acumulada)

func _gestiona_feina() -> void:
	if tasca_actual.size() != 0:
		feina_total_acumulada = feina_acumulada["disseny"] + feina_acumulada["enginy"] + feina_acumulada["informatica"]
		_feina_in_progress()

func get_mouse_snapped_position() -> Vector2i:
	var mouse_pos = get_global_mouse_position()
	var grid_pos = mouse_pos / 64.0
	grid_pos = Vector2(floor(grid_pos.x), floor(grid_pos.y))
	return Vector2i(grid_pos)

func _actualitza_precol·locacio() -> void:
	if objecte_instance:
		var snapped_tile = get_mouse_snapped_position()
		var snapped_pos = Vector2(snapped_tile * 64)
		objecte_instance.global_position = snapped_pos

		var es_valid = _es_posicio_valida(snapped_pos)
		objecte_instance.modulate = Color(1, 1, 1, 0.5) if es_valid else Color(1, 0, 0, 0.5)


func _es_posicio_valida(pos: Vector2) -> bool:
	if BusinessEngine.posicions_treball.has(pos) or BusinessEngine.posicions_descans.has(pos):
		print("Posició ocupada: ", pos)
		return false

	if not node_oficina.has_node("Fons"):
		return false

	var fons = node_oficina.get_node("Fons") as TileMapLayer
	var local_pos = fons.to_local(pos)
	var tile_coords = fons.local_to_map(local_pos)
	var tile_data = fons.get_cell_tile_data(tile_coords)

	return tile_data and tile_data.get_custom_data("construible")



func actualitza_llistes_posicions():
	for node in get_node("Oficina/descans").get_children():
		var pos = Vector2i(round(node.global_position.x / 64), round(node.global_position.y / 64)) * 64
		BusinessEngine.posicions_descans[pos] = "lliure" 
	for node in get_node("Oficina/treball").get_children():
		var pos = Vector2i(round(node.global_position.x / 64), round(node.global_position.y / 64)) * 64
		BusinessEngine.posicions_treball[pos] = "lliure"

	
func _feina_in_progress()->void:
	print("tasca actual: " + str(tasca_actual))
	print("feina acumulada: " + str(feina_total_acumulada))
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
	BusinessEngine.llista_candidats.remove_at(index)

static func afegeix_treballador(ubicacio: Node) -> void:
	var fitxatge_treballador_temp = fitxatge_treballador.instantiate()
	fitxatge_treballador_temp.atributs["nom"] = treballador_temp.nom
	fitxatge_treballador_temp.atributs["nivell"] = treballador_temp.nivell
	fitxatge_treballador_temp.atributs["sou"] = treballador_temp.sou
	fitxatge_treballador_temp.atributs["disseny"] = treballador_temp.disseny
	fitxatge_treballador_temp.atributs["enginy"] = treballador_temp.enginy
	fitxatge_treballador_temp.atributs["informatica"] = treballador_temp.informatica
	fitxatge_treballador_temp.atributs["social"] = treballador_temp.social
	fitxatge_treballador_temp.imatge = treballador_temp.imatge
	fitxatge_treballador_temp.position = punt_nou_treballador + Vector2(randi_range(-20,20), randi_range(-20,20))
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

	node_oficina = $Oficina
	var target_node = node_oficina.get_node("treball") if tipus_actual == "treball" else node_oficina.get_node("descans")
	target_node.add_child(objecte_instance)

	mode_precol·locacio = true
	get_node("Ux")._on_close_menu_compres_pressed()

func _input(event: InputEvent) -> void:
	if not mode_precol·locacio or objecte_instance == null:
		return

	if event is InputEventMouseButton:
		var snapped_pos = Vector2(get_mouse_snapped_position() * 64)

		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			objecte_instance.queue_free()
			objecte_instance = null
			mode_precol·locacio = false
			return

		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if _es_posicio_valida(snapped_pos):
				objecte_instance.modulate = Color(1, 1, 1, 1.0)
				objecte_instance.global_position = snapped_pos
				mode_precol·locacio = false

				if tipus_actual == "treball":
					BusinessEngine.posicions_treball[snapped_pos] = "lliure"
				else:
					BusinessEngine.posicions_descans[snapped_pos] = "lliure"
			else:
				get_node("FXPlayer").stream = load(so_error)
				get_node("FXPlayer").volume_db = -6
				get_node("FXPlayer").play()
