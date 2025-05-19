class_name FitxaTreballador extends PanelContainer

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
	pass # Replace with function body.


func _on_estudia_button_pressed() -> void:
	pass # Replace with function body.


func _on_acomiada_button_pressed() -> void:
	get_tree().root.get_node("Pantalla/Ux").anima_sortida_display()
	treballador.get_node("%AnimationPlayer").play("acomiada")
	await get_tree().create_timer(0.95).timeout
	treballador.queue_free()
