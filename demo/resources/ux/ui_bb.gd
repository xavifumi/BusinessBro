extends CanvasLayer
class_name UX
#signal genera_treballador

@onready var liquid: Label = %Liquid
@onready var calendari: Control = %Calendari
@onready var dia: Label = %dia
@onready var mes: Label = %mes
@onready var any: Label = %any

@onready var calaix_aplicacions: GridContainer = %CalaixAplicacions
@onready var menu_treballadors: PanelContainer = %MenuTreballadors
@onready var llista_candidats: VBoxContainer = %LlistaCandidats

@export var tween_intensity: float
@export var tween_duration: float

var button_es_anim := false
var fitxa_treballador = preload("res://resources/ux/fitxa_treballador.tscn")
var fitxa_informativa = preload("res://resources/ux/fitxa_informativa_treballadors.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	calaix_aplicacions.get_children()[1].button_down.connect(Pantalla._on_button_feina_pressed)
	calaix_aplicacions.get_children()[0].button_down.connect(activa_menu_personal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	dia.text = str(Calendar.day)
	mes.text = str(Calendar.mes_en_text)
	any.text = str(Calendar.year)
	for button in calaix_aplicacions.get_children():
		btn_hovered(button)

func start_tween(object: Object, property: String, final_val:Variant, duration: float):
	var tween = create_tween()
	if button_es_anim:
		tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: Button):
	button.pivot_offset = button.size /2
	if button.is_hovered():
		button_es_anim = true
		start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
		button.get_child(0).show()
		button_es_anim = false
	else:
		button_es_anim = true
		start_tween(button, "scale", Vector2.ONE, tween_duration)
		button.get_child(0).hide()
		button_es_anim = false

func activa_menu_personal():
	menu_treballadors.show()
	var counter := 0
	if BusinessEngine.llista_candidats.is_empty():
		var fitxa_terballador_temp = fitxa_informativa.instantiate()
		llista_candidats.add_child(fitxa_terballador_temp)
	else:
		for estadistiques_temp in BusinessEngine.llista_candidats :
			var fitxa_terballador_temp = fitxa_treballador.instantiate()
			#print(estadistiques_temp)
			fitxa_terballador_temp.get_node("%labelNom").text = estadistiques_temp.nom
			fitxa_terballador_temp.get_node("%labelNivell").text = str(estadistiques_temp.nivell)
			fitxa_terballador_temp.get_node("%labelSou").text = str(estadistiques_temp.sou)
			fitxa_terballador_temp.get_node("%labelDisseny").text = str(estadistiques_temp.disseny)
			fitxa_terballador_temp.get_node("%labelEnginy").text = str(estadistiques_temp.enginy)
			fitxa_terballador_temp.get_node("%labelInformatica").text = str(estadistiques_temp.informatica)
			fitxa_terballador_temp.get_node("%labelSocial").text = str(estadistiques_temp.social)
			fitxa_terballador_temp.get_node("%buttonContracta").pressed.connect(contracta_treballador.bind(estadistiques_temp, counter))
			llista_candidats.add_child(fitxa_terballador_temp)
			counter+=1

func _on_close_menu_treballadors_pressed() -> void:
	menu_treballadors.hide()
	for entrada in llista_candidats.get_children():
		entrada.queue_free()

func contracta_treballador(treballador_temp: Dictionary, index: int) -> void:
	if Pantalla.llista_treballadors.size() < Pantalla.maxim_treballadors:
		Pantalla.llista_treballadors.append(treballador_temp)
		Pantalla.treballador_temp = treballador_temp
		Pantalla.afegeix_treballador($%Plantilla)
		BusinessEngine.llista_candidats.remove_at(index)
		for entrada in llista_candidats.get_children():
			entrada.queue_free()
		activa_menu_personal()
	else:
		activa_popup("Ja tens el màxim de treballadors permesos en aquesta oficina!
Prova a traslladar-te a una nova.")

func _on_popup_close_button_pressed() -> void:
	get_node("%PopUp").hide()
	
func activa_popup(text: String) -> void:
	get_node("PopUp/PopUpLabel").text = text
	get_node("PopUp").show()
