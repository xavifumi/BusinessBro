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
@onready var feina_info: PanelContainer = %FeinaInfo
@onready var menu_tasques: PanelContainer = %MenuTasques
@onready var llista_tasques: VBoxContainer = %LlistaTasques
@onready var menu_compres: PanelContainer = %MenuCompres
@onready var material: VBoxContainer = %Material
@onready var locals: VBoxContainer = %Locals
var pantalla
var fxplayer


@export var tween_intensity: float
@export var tween_duration: float

var button_es_anim := false
var fitxa_treballador = preload("res://resources/ux/fitxa_treballador.tscn")
var fitxa_informativa = preload("res://resources/ux/fitxa_informativa_treballadors.tscn")
var fitxa_tasca = preload("res://resources/ux/fitxa_tasca.tscn")
var fitxa_material = preload("res://resources/ux/fitxa_material.tscn")
var fitxa_local = preload("res://resources/ux/fitxa_local.tscn")
var so_compra = "res://resources/oficina/resources/180894__jobro__cash-register-opening.wav"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pantalla = get_parent()
	fxplayer = pantalla.get_node("%FXPlayer")
	calaix_aplicacions.get_children()[2].button_down.connect(activa_menu_compres)
	calaix_aplicacions.get_children()[1].button_down.connect(activa_menu_tasques)
	calaix_aplicacions.get_children()[0].button_down.connect(activa_menu_personal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	dia.text = str(Calendar.day)
	mes.text = str(Calendar.mes_en_text)
	any.text = str(Calendar.year)
	for button in calaix_aplicacions.get_children():
		btn_hovered(button)
	if Pantalla.tasca_actual.size() != 0:
		%FeinaInfo.show()
	else :
		%FeinaInfo.hide()
	if %FeinaInfo.is_visible_in_tree():
		%FeinaInfoDescription.text = Pantalla.tasca_actual["nom"]  if Pantalla.tasca_actual.size() != 0 else ""
		%FeinaInfoDies.text = str(Pantalla.tasca_actual["dies_restants"]) if Pantalla.tasca_actual.size() != 0 else ""
		%FeinaInfoProgress.max_value = Pantalla.tasca_actual["feina"] if Pantalla.tasca_actual.size() != 0 else 0
		%FeinaInfoProgress.value = Pantalla.feina_acumulada["disseny"] + Pantalla.feina_acumulada["enginy"] + Pantalla.feina_acumulada["informatica"]
		

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
	if !menu_treballadors.is_visible_in_tree():
		_on_close_menu_compres_pressed()
		_on_close_menu_tasques_pressed()
		menu_treballadors.show()
		var counter := 0
		if BusinessEngine.llista_candidats.is_empty():
			var fitxa_terballador_temp = fitxa_informativa.instantiate()
			fitxa_informativa.get_node("Label").text = "No hi ha treballadors disponibles!"
			llista_candidats.add_child(fitxa_terballador_temp)
		else:
			for estadistiques_temp in BusinessEngine.llista_candidats :
				var fitxa_terballador_temp = fitxa_treballador.instantiate()
				var old_atlas = fitxa_terballador_temp.get_node("%imatgeTreballador").texture as AtlasTexture
				var new_image := load(estadistiques_temp.imatge)

				var new_atlas := AtlasTexture.new()
				new_atlas.atlas = new_image
				new_atlas.region = old_atlas.region
				new_atlas.margin = old_atlas.margin
				new_atlas.filter_clip = old_atlas.filter_clip
				fitxa_terballador_temp.get_node("%imatgeTreballador").texture = new_atlas
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
		fxplayer.stream = load(so_compra)
		fxplayer.play()
		
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
	
static func activa_panell_info(node: Node) -> void:
	node.show()

static func amaga_panell_info(node: Node) -> void:
	node.hide()

static func set_valor_maxim(node: ProgressBar, valor: int)-> void:
	node.max_value = valor

static func actualitza_valor(node: ProgressBar, valor: int)-> void:
	node.value = valor

func _on_close_menu_tasques_pressed() -> void:
	menu_tasques.hide()
	for entrada in llista_tasques.get_children():
		entrada.queue_free()

func activa_menu_tasques():
	if !menu_tasques.is_visible_in_tree():
		_on_close_menu_treballadors_pressed()
		_on_close_menu_compres_pressed()
		menu_tasques.show()
		var counter := 0
		if BusinessEngine.llista_tasques.is_empty():
			var fitxa_terballador_temp = fitxa_informativa.instantiate()
			fitxa_informativa.get_node("Label").text = "No hi ha contractes disponibles!"
			llista_tasques.add_child(fitxa_terballador_temp)
		else:
			for contractes_temp in BusinessEngine.llista_tasques :
				var fitxa_terballador_temp = fitxa_tasca.instantiate()
				print(contractes_temp)
				fitxa_terballador_temp.get_node("%labelNomEmpresa").text = contractes_temp.nom
				fitxa_terballador_temp.get_node("%labelNomTasca").text = contractes_temp.tasca
				fitxa_terballador_temp.get_node("%labelDurada").text = str(contractes_temp.dies_restants)
				fitxa_terballador_temp.get_node("%labelPressu").text = str(contractes_temp.recompensa)
				fitxa_terballador_temp.get_node("%labelPenyora").text = str(contractes_temp.penyora)
				fitxa_terballador_temp.get_node("%labelDificultat").text = str("facil" if contractes_temp.dificultat <0.7 else "normal" if contractes_temp.dificultat <1.3 else "dificil")
				fitxa_terballador_temp.get_node("%buttonAcceptaTasca").pressed.connect(accepta_contracte.bind(contractes_temp, counter))
				llista_tasques.add_child(fitxa_terballador_temp)
				counter+=1

func accepta_contracte(tasca_temp: Dictionary, index: int) -> void:
	if Pantalla.tasca_actual.size() != 0:
		activa_popup("Ja tens un contracte actiu! Acaba'l abans d'agafar-ne un altre!")
	else:
		Pantalla.tasca_actual = tasca_temp
		BusinessEngine.llista_tasques.remove_at(index)
		_on_close_menu_tasques_pressed()
		#print(Pantalla.tasca_actual)
		

func activa_menu_compres():
	if not menu_compres.is_visible_in_tree():
		_on_close_menu_treballadors_pressed()
		_on_close_menu_tasques_pressed()
		menu_compres.show()
		
		if BusinessEngine.llista_material.is_empty():
			var fitxa_terballador_temp = fitxa_informativa.instantiate()
			fitxa_terballador_temp.get_node("Label").text = "No hi ha materials disponibles!"
			material.add_child(fitxa_terballador_temp)
		else:
			var counter := 0
			for contractes_temp in BusinessEngine.llista_material :
				var fitxa_terballador_temp = fitxa_material.instantiate()
				var valors = BusinessEngine.llista_material[contractes_temp]
				#print(contractes_temp)
				fitxa_terballador_temp.get_node("%labelNom").text = valors.nom
				fitxa_terballador_temp.get_node("%imatge").texture = load(valors.icona)
				fitxa_terballador_temp.get_node("%descripcio").text = valors.descripcio
				fitxa_terballador_temp.get_node("%labelPreu").text = str(valors.preu)
				fitxa_terballador_temp.get_node("%buttonCompra").pressed.connect(pantalla.carregar_i_precol·locar.bind(valors))
				material.add_child(fitxa_terballador_temp)
				counter+=1
			
		if BusinessEngine.llista_locals.is_empty():
			var fitxa_terballador_temp = fitxa_informativa.instantiate()
			fitxa_terballador_temp.get_node("Label").text = "No hi ha locals disponibles!"
			locals.add_child(fitxa_terballador_temp)
		else:
			var counter := 0
			for contractes_temp in BusinessEngine.llista_locals :
				var fitxa_terballador_temp = fitxa_local.instantiate()
				var valors = BusinessEngine.llista_locals[contractes_temp]
				#print(contractes_temp)
				fitxa_terballador_temp.get_node("%labelNom").text = contractes_temp
				fitxa_terballador_temp.get_node("%descripcio").text = valors.descripcio
				fitxa_terballador_temp.get_node("%labelPreu").text = str(valors.preu)
				fitxa_terballador_temp.get_node("%labelCapacitat").text = str(valors.treballadors)
				fitxa_terballador_temp.get_node("%labelMaterial").text = str(valors.material)
				fitxa_terballador_temp.get_node("%buttonCompra").pressed.connect(pantalla.remplaça_local.bind(get_node("/root/Pantalla/Oficina").get_child(0), valors))
				locals.add_child(fitxa_terballador_temp)
				counter+=1

func _on_close_menu_compres_pressed() -> void:
	menu_compres.hide()
	for entrada in material.get_children():
		entrada.queue_free()
	for entrada in locals.get_children():
		entrada.queue_free()

func anima_label(label: Label, start_val: int, end_val: int, duration: float = 1.5):
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_method(_update_label.bind(label), start_val, end_val, duration)

func _update_label(value: float, label: Label):
	label.text = str(round(value))
