class_name DisplayTreballador extends PanelContainer

@onready var label_nom: Label = %labelNom
@onready var label_nivell: Label = %labelNivell
@onready var label_sou: Label = %labelSou
@onready var label_disseny: Label = %labelDisseny
@onready var label_enginy: Label = %labelEnginy
@onready var label_informatica: Label = %labelInformatica
@onready var label_social: Label = %labelSocial
@onready var imatge_treballador: TextureRect = %imatgeTreballador
@onready var button_contracta: TextureButton = %buttonContracta
@onready var motivacio_progress_bar: TextureProgressBar = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/MotivacioProgressBar
@onready var cansament_progress_bar: TextureProgressBar = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer3/CansamentProgressBar

var treballador : Treballador
var bbb
var opcio_jugador
var variables_joc = [
	"burpee", "bitcoin", "babe"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if treballador != null :
		motivacio_progress_bar.max_value = treballador.atributs["motivacio"]
		motivacio_progress_bar.value = treballador.motivacio_actual
		cansament_progress_bar.max_value = treballador.atributs["energia"]
		cansament_progress_bar.value = treballador.energia_actual


func _on_popup_close_button_pressed() -> void:
	get_tree().root.get_node("Pantalla/Ux").anima_sortida_display()


func _on_motiva_button_pressed() -> void:
	bbb = variables_joc.pick_random()
	var Ux = get_tree().root.get_node("Pantalla/Ux")
	Ux.bbb.show()

func bbb_joc() -> void:
	var resultat
	if opcio_jugador == "burpee":
		if bbb == "babe":
			resultat = "victoria"
		elif bbb == "bitcoin":
			resultat = "derrota"
		else:
			resultat = "empat"
	if opcio_jugador == "babe":
		if bbb == "bitcoin":
			resultat = "victoria"
		elif bbb == "burpee":
			resultat = "derrota"
		else:
			resultat = "empat"
	if opcio_jugador == "bitcoin":
		if bbb == "burpee":
			resultat = "victoria"
		elif bbb == "babe":
			resultat = "derrota"
		else:
			resultat = "empat"
	var pantalla = get_tree().root.get_node("Pantalla")
	match resultat:
		"victoria": 
			treballador.motivacio_actual += 0.10
			pantalla.get_node("%Confetti").dispara_confetti()
			pantalla.get_node("%FXPlayer").stream = load("res://resources/oficina/resources/651642__krizin__crowd-cheer-2.wav")
			pantalla.get_node("%FXPlayer").play()
		"derrota": 
			treballador.motivacio_actual -= 0.05
			pantalla.get_node("%FXPlayer").stream = load("res://resources/sons/362206__taranp__horn_fail_wahwah_1.wav")
			pantalla.get_node("%FXPlayer").play()
		"empat": 
			treballador.motivacio_actual
	opcio_jugador = ""


func _on_estudia_button_pressed() -> void:
	treballador.estat = treballador.States.ESTUDIANT
	get_tree().root.get_node("Pantalla/Ux").anima_label(
		get_tree().root.get_node("Pantalla/Ux/PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid"), Pantalla.diners, Pantalla.diners - 600
	)
	Pantalla.diners - 600
	get_tree().root.get_node("Pantalla/FXPlayer").stream = load(get_tree().root.get_node("Pantalla/Ux").so_compra)
	get_tree().root.get_node("Pantalla/FXPlayer").play()


func _on_acomiada_button_pressed() -> void:
	var pantalla = get_tree().root.get_node("Pantalla")
	get_node("Ux").anima_label(
						get_tree().root.get_node("Pantalla/Ux").get_node("PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid"),
						pantalla.diners, pantalla.diners - (treballador.atributs["sou"]/365)*(treballador.dies_contractat - treballador.ultima_nomina)
					)
	pantalla.diners -= (treballador.atributs["sou"]/365)*(treballador.dies_contractat - treballador.ultima_nomina)
	pantalla.get_node("%FxPlayer").stream = pantalla.so_compra
	treballador.get_node("%AudioStreamPlayer").stream = load(treballador.so_transporta)
	treballador.get_node("%AudioStreamPlayer").play()
	get_tree().root.get_node("Pantalla/Ux").anima_sortida_display()
	treballador.get_node("%AnimationPlayer").play("acomiada")
	await get_tree().create_timer(0.95).timeout
	treballador.queue_free()


func _on_augmenta_sou_button_pressed() -> void:
	treballador.atributs["sou"] += 500


func _on_nomina_button_pressed() -> void:
	treballador.cobra_nomina()


func _on_descansar_button_pressed() -> void:
	treballador.estat = treballador.States.CANSAT
