class_name Pantalla extends Node2D
@onready var plantilla: Node = %Plantilla

var label 
static var llista_treballadors = []
var debug_tiles: Array = []  
static var maxim_treballadors := 2
static var lloguer := 75
static var treballador_temp
static var punt_nou_treballador : Vector2
static var nivell := 1
static var fama = 0
static var exp = 0
static var diners := 0
var diners_inicials := 30000
static var beneficis_any := 0 
static var beneficis_trimestre := 0
static var despeses := 0
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
var so_compra = "res://resources/oficina/resources/180894__jobro__cash-register-opening.wav"
var so_celebra = "res://resources/oficina/resources/651642__krizin__crowd-cheer-2.wav"
var so_no_celebra = "res://resources/sons/362206__taranp__horn_fail_wahwah_1.wav"
var button_feina 

var inici_feina = false
var objecte_instance : Node2D = null
var mode_precol·locacio := false
var node_oficina : Node = null
var tipus_actual : String = ""
var objecte_arrossegat: Node2D = null
var mode_reubicacio := false
var posicio_original: Vector2 = Vector2.ZERO
static var confetti

func _ready() -> void:
	set_process(true)
	diners = diners_inicials
	punt_nou_treballador = get_node("Oficina/PuntInici").position
	actualitza_llistes_posicions()
	get_node("Ux/PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid").text = str(diners)

	# Connecta senyals d'arrossegables
	for node in get_tree().get_nodes_in_group("arrossegables"):
		if node.has_signal("reubicar_solicitat"):
			node.connect("reubicar_solicitat", Callable(self, "_on_reubicar_solicitat"))
			print("Connectat senyal des de:", node.name)


func _process(_delta: float) -> void:
	_actualitza_ui()
	_gestiona_feina()

	if mode_precol·locacio:
		_actualitza_precol·locacio()
	elif mode_reubicacio and objecte_arrossegat:
		var snapped_tile = get_mouse_snapped_position()
		var snapped_pos = Vector2(snapped_tile * 64)

		if is_instance_valid(objecte_arrossegat):
			objecte_arrossegat.global_position = snapped_pos

			var es_valid = _es_posicio_valida(snapped_pos)
			objecte_arrossegat.modulate = Color(1, 1, 1, 0.5) if es_valid else Color(1, 0, 0, 0.5)
	else:
		return


func _actualitza_ui() -> void:
	pass
	#label.text = str(feina_acumulada)

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

	if not node_oficina.get_child(0).has_node("Fons"):
		return false

	var fons = node_oficina.get_child(0).get_node("Fons") as TileMapLayer
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


func find_largest_dict_val(dict):
	var max_val = -999999
	var max_var
	for i in dict:
		var val =  dict[i]
		if val > max_val:
			max_val = val
			max_var = i
	return max_var

func _feina_in_progress()->void:
	#print("tasca actual: " + str(tasca_actual))
	#print("feina acumulada: " + str(feina_total_acumulada))
	if tasca_actual["dies_restants"] > 0:
		if tasca_actual["feina"] <= feina_total_acumulada:
			diners += tasca_actual["recompensa"]
			Pantalla.beneficis_trimestre += tasca_actual["recompensa"]
			var estrelles = 1
			var fama = 1
			if tasca_actual["dies_restants"] >= tasca_actual["durada"]/3:
				estrelles += 1
			if tasca_actual["dificultat"] > 0.7:
				estrelles += 1
			if tasca_actual["dificultat"] > 1.3:
				estrelles += 1
			if find_largest_dict_val(feina_acumulada) == tasca_actual["stat_important"]:
				fama += feina_acumulada[tasca_actual["stat_important"]]/100 if feina_acumulada[tasca_actual["stat_important"]] > 100 else 1
			get_node("Ux").on_feina_acabada_mostra(estrelles, fama, feina_total_acumulada)
			tasca_actual = {}
			feina_acumulada = {
				"disseny": 0,
				"enginy": 0,
				"informatica": 0
			}
			feina_total_acumulada = 0
			#get_node("Ux/FeinaAcabada").show()
			get_node("%Confetti").dispara_confetti()
			get_node("%FXPlayer").stream = load(so_celebra)
			get_node("%FXPlayer").play()
	else:
		var fama = 1
		get_node("Ux").on_feina_no_acabada_mostra(fama, tasca_actual.penyora)
		diners -= tasca_actual.penyora
		tasca_actual = {}
		feina_acumulada = {
				"disseny": 0,
				"enginy": 0,
				"informatica": 0
			}
		feina_total_acumulada = 0
		for treballador in get_node("%Plantilla").get_children():
			treballador.motivacio_actual -= 0.025
		get_node("%FXPlayer").stream = load(so_no_celebra)
		get_node("%FXPlayer").volume_db = 0
		get_node("%FXPlayer").play()
		await get_node("%FXPlayer").finished
		get_node("%FXPlayer").volume_db = -12
	
static func _on_button_feina_pressed() -> void:
	tasca_actual = tasca_exemple.duplicate()

static func contracta_treballador(treballador_cont_temp: Dictionary, index: int) -> void:
	llista_treballadors.append(treballador_cont_temp)
	BusinessEngine.llista_candidats.remove_at(index)
	print(llista_treballadors)

func afegeix_treballador(ubicacio: Node) -> void:
	var fitxatge_treballador_temp = fitxatge_treballador.instantiate()
	fitxatge_treballador_temp.atributs["nom"] = treballador_temp.nom
	fitxatge_treballador_temp.atributs["nivell"] = treballador_temp.nivell
	fitxatge_treballador_temp.atributs["sou"] = treballador_temp.sou
	fitxatge_treballador_temp.atributs["disseny"] = treballador_temp.disseny
	fitxatge_treballador_temp.atributs["enginy"] = treballador_temp.enginy
	fitxatge_treballador_temp.atributs["informatica"] = treballador_temp.informatica
	fitxatge_treballador_temp.atributs["social"] = treballador_temp.social
	fitxatge_treballador_temp.imatge = treballador_temp.imatge
	fitxatge_treballador_temp.add_to_group("arrossegables")
	#fitxatge_treballador_temp.connect("reubicar_solicitat", Callable(self, "_on_reubicar_solicitat"))
	#fitxatge_treballador_temp.position = punt_nou_treballador + Vector2(randi_range(-20,20), randi_range(-20,20))
	fitxatge_treballador_temp.position = get_posicions_construibles_disponibles().pick_random()
	ubicacio.add_child(fitxatge_treballador_temp)

func carregar_i_precol·locar(data: Dictionary) -> void:
	var escena_path = data.get("escena", "")
	tipus_actual = data.get("tipus", "descans")

	if escena_path == "":
		push_error("No s'ha especificat el camí de l'escena.")
		return
	
	var escena_precarregada = load(escena_path)
	objecte_instance = escena_precarregada.instantiate()
	objecte_instance.preu = data.preu
	objecte_instance.modulate.a = 0.5
	objecte_instance.add_to_group("arrossegables")
	objecte_instance.add_to_group(objecte_instance.tipus)
	objecte_instance.connect("reubicar_solicitat", Callable(self, "_on_reubicar_solicitat"))

	node_oficina = $Oficina
	var target_node = node_oficina.get_node("treball") if tipus_actual == "treball" else node_oficina.get_node("descans")
	target_node.add_child(objecte_instance)

	mode_precol·locacio = true
	get_node("Ux")._on_close_menu_compres_pressed()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_pressed: bool = event.pressed
		var button: MouseButton = event.button_index

		# --- Precol·locació ---
		if mode_precol·locacio and objecte_instance != null:
			#mostra_tiles_disponibles()
			var snapped_pos: Vector2 = get_mouse_snapped_position() * 64

			if button == MOUSE_BUTTON_RIGHT and mouse_pressed:
				if objecte_instance:
					objecte_instance.queue_free()
					objecte_instance = null
				mode_precol·locacio = false
				neteja_tiles_debug()
				return


			if button == MOUSE_BUTTON_LEFT and mouse_pressed:
				if _es_posicio_valida(snapped_pos):
					objecte_instance.global_position = snapped_pos
					objecte_instance.modulate = Color(1, 1, 1, 1.0)
					get_node("Ux").anima_label(
						get_node("Ux/PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid"),
						diners, diners - objecte_instance.preu
					)
					diners -= objecte_instance.preu
					get_node("FXPlayer").stream = load(so_compra)
					get_node("FXPlayer").play()
					mode_precol·locacio = false

					if tipus_actual == "treball":
						BusinessEngine.posicions_treball[snapped_pos] = "lliure"
					else:
						BusinessEngine.posicions_descans[snapped_pos] = "lliure"
				else:
					get_node("FXPlayer").stream = load(so_error)
					get_node("FXPlayer").play()
					neteja_tiles_debug()
				return

		# --- Confirmar nova posició amb clic esquerre ---
		elif button == MOUSE_BUTTON_LEFT and mouse_pressed and mode_reubicacio and objecte_arrossegat:
			var snapped_pos: Vector2 = get_mouse_snapped_position() * 64
			if _es_posicio_valida(snapped_pos):
				objecte_arrossegat.global_position = snapped_pos
				objecte_arrossegat.modulate.a = 1.0
				mode_reubicacio = false

				# Actualitzar llistes
				if objecte_arrossegat.is_in_group("treball"):
					BusinessEngine.posicions_treball.erase(posicio_original)
					BusinessEngine.posicions_treball[snapped_pos] = "lliure"
				elif objecte_arrossegat.is_in_group("descans"):
					BusinessEngine.posicions_descans.erase(posicio_original)
					BusinessEngine.posicions_descans[snapped_pos] = "lliure"
			else:
				get_node("FXPlayer").stream = load(so_error)
				get_node("FXPlayer").play()

		# --- Cancel·lar reubicació amb clic dret ---
		elif button == MOUSE_BUTTON_RIGHT and mouse_pressed and mode_reubicacio:
			objecte_arrossegat.global_position = posicio_original
			objecte_arrossegat.modulate.a = 1.0
			mode_reubicacio = false
			objecte_arrossegat = null

	# --- Moure l'objecte reubicat amb el ratolí mentre està en mode reubicació ---
	elif event is InputEventMouseMotion and mode_reubicacio and objecte_arrossegat:
		var snapped_pos: Vector2 = get_mouse_snapped_position() * 64
		if is_instance_valid(objecte_arrossegat):
			objecte_arrossegat.global_position = snapped_pos




func remplaça_local(original_node: Node2D, data: Dictionary):
	var steam = preload("res://resources/oficina/332602__vckhaze__smoke-bomb.wav")
	var parent = original_node.get_parent()
	var index = original_node.get_index()
	var new_scene_path: String = data.escena
	transform = original_node.transform # per 2D pots usar global_position, rotation, scale
	
	original_node.queue_free()

	var new_scene = load(new_scene_path).instantiate()
	parent.add_child(new_scene)
	parent.move_child(new_scene, index)

	# Si vols mantenir la posició, rotació, etc.
	new_scene.global_position = transform.origin
	new_scene.rotation = original_node.rotation
	new_scene.scale = original_node.scale
	get_node("Ux")._on_close_menu_compres_pressed()
	get_node("Ux").anima_label(get_node("Ux/PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid"), diners, diners - data.preu)
	diners -= data.preu*4
	get_node("%FXPlayer").stream = steam
	get_node("%FXPlayer").play()
	#mostra_tiles_disponibles()


func _on_reubicar_solicitat(node: Node2D) -> void:
	objecte_arrossegat = node
	posicio_original = node.global_position
	mode_reubicacio = true
	objecte_arrossegat.modulate.a = 0.5

	# Alliberar posició original
	var pos_orig = Vector2(round(posicio_original.x / 64), round(posicio_original.y / 64)) * 64
	if node.is_in_group("treball"):
		BusinessEngine.posicions_treball.erase(pos_orig)
	elif node.is_in_group("descans"):
		BusinessEngine.posicions_descans.erase(pos_orig)
	

func get_posicions_construibles_disponibles() -> Array:
	var posicions_disponibles := []
	var node_oficina = get_tree().root.get_node("Pantalla/Oficina")
	
	# Agafem el node TileMap que conté els tiles
	if not node_oficina.get_child(0).has_node("Fons"):
		return posicions_disponibles
	
	var fons = node_oficina.get_child(0).get_node("Fons") as TileMapLayer

	# Recorrem tots els tiles ocupats
	for coords in fons.get_used_cells():
		var tile_data = fons.get_cell_tile_data(coords)
		if not tile_data:
			continue

		if tile_data.get_custom_data("construible"):
			var global_pos = fons.to_global(Vector2i(coords) * fons.tile_set.tile_size)
			global_pos = Vector2(floor(global_pos.x), floor(global_pos.y))

			if BusinessEngine.posicions_treball.has(global_pos) or BusinessEngine.posicions_descans.has(global_pos):
				continue

			posicions_disponibles.append(global_pos)


	return posicions_disponibles

#Debbuging de colocacio erronia
func mostra_tiles_disponibles():
	neteja_tiles_debug()  # Esborra si ja n’hi havia

	var posicions = get_posicions_construibles_disponibles()
	node_oficina = $Oficina
	for pos in posicions:
		var debug_rect := ColorRect.new()
		debug_rect.color = Color(0, 1, 0, 0.3)
		debug_rect.size = Vector2(64, 64)
		debug_rect.position = pos
		node_oficina.add_child(debug_rect)
		debug_tiles.append(debug_rect)  # El guardem

func neteja_tiles_debug():
	for rect in debug_tiles:
		if is_instance_valid(rect):
			rect.queue_free()
	debug_tiles.clear()
