extends CanvasLayer
class_name UX
#signal genera_treballador

@onready var liquid: Label = %Liquid
@onready var calendari: Node
@onready var display_calendari: Button = %DisplayCalendari
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
@onready var display_treballador: DisplayTreballador = %DisplayTreballador
var pantalla
var fxplayer
var treballadors_per_generar = []
var generant_treballadors = false


@export var tween_intensity: float
@export var tween_duration: float

var button_es_anim := false
var fitxa_treballador = preload("res://resources/ux/fitxa_treballador.tscn")
var fitxa_informativa = preload("res://resources/ux/fitxa_informativa_treballadors.tscn")
var fitxa_tasca = preload("res://resources/ux/fitxa_tasca.tscn")
var fitxa_material = preload("res://resources/ux/fitxa_material.tscn")
var fitxa_local = preload("res://resources/ux/fitxa_local.tscn")
var so_compra = "res://resources/oficina/resources/180894__jobro__cash-register-opening.wav"
var so_inici_feina = "res://resources/sons/651010__therandomsoundbyte2637__pre-match-countdown.wav"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pantalla = get_parent()
	fxplayer = pantalla.get_node("%FXPlayer")
	calendari = get_tree().root.get_node("Pantalla/Calendari")
	calaix_aplicacions.get_children()[2].button_down.connect(activa_menu_compres)
	calaix_aplicacions.get_children()[1].button_down.connect(activa_menu_tasques)
	calaix_aplicacions.get_children()[0].button_down.connect(activa_menu_personal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#dia.text = str(Calendar.day)
	#mes.text = str(Calendar.mes_en_text)
	#any.text = str(Calendar.year)
	display_calendari.text = str(Calendar.day) + " " + str(Calendar.mes_en_text) + " " + str(Calendar.year)
	for button in calaix_aplicacions.get_children():
		btn_hovered(button)
	if Pantalla.tasca_actual.size() != 0:
		var tween = create_tween()
		tween.tween_property(%FeinaInfo, "position:y", 575, tween_duration)
		#%FeinaInfo.show()
	else :
		var tween = create_tween()
		tween.tween_property(%FeinaInfo, "position:y", 655, tween_duration)
		#%FeinaInfo.hide()
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
	if !menu_treballadors.is_visible_in_tree() and !generant_treballadors:
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
	generant_treballadors = true
	menu_treballadors.hide()
	for entrada in llista_candidats.get_children():
		entrada.queue_free()
	for treballador in treballadors_per_generar :
		genera_treballador(treballador)
		await get_tree().create_timer(randf_range(0.5,1.0)).timeout
	treballadors_per_generar = []
	generant_treballadors = false

func contracta_treballador(treballador_temp: Dictionary, index: int) -> void:
	var	node_oficina = pantalla.get_node("Oficina")
	if node_oficina.has_node("Empty"):
		#get_node("Ux")._on_close_menu_treballadors_pressed()
		activa_popup("Abans de contractar ningú necessites un local.")
		return
	elif Pantalla.llista_treballadors.size() < Pantalla.maxim_treballadors:
		Pantalla.llista_treballadors.append(treballador_temp)
		treballadors_per_generar.append(treballador_temp)

		BusinessEngine.llista_candidats.remove_at(index)
		menu_treballadors.hide()
		for entrada in llista_candidats.get_children():
			entrada.queue_free()
		activa_menu_personal()
		fxplayer.stream = load(so_compra)
		fxplayer.play()
	else:
		activa_popup("Ja tens el màxim de treballadors permesos en aquesta oficina!
Prova a traslladar-te a una nova.")

func genera_treballador(treballador_temp: Dictionary) -> void:
	pantalla.treballador_temp = treballador_temp
	pantalla.afegeix_treballador($%Plantilla)


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
	if !menu_tasques.is_visible_in_tree() and !generant_treballadors:
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
	var	node_oficina = pantalla.get_node("Oficina")
	if node_oficina.has_node("Empty"):
		activa_popup("Abans d'acceptar un contracte necessites un local.")
		return
	if Pantalla.tasca_actual.size() != 0:
		activa_popup("Ja tens un contracte actiu! Acaba'l abans d'agafar-ne un altre!")
	else:
		pantalla.inici_feina = true
		Pantalla.tasca_actual = tasca_temp
		BusinessEngine.llista_tasques.remove_at(index)
		_on_close_menu_tasques_pressed()
		fxplayer.stream = load(so_inici_feina)
		fxplayer.play()
		for treballador in pantalla.get_node("Oficina/Plantilla").get_children():
			treballador.mostra_emocio("exclamacions")
		await get_tree().create_timer(3.0).timeout
		pantalla.inici_feina = false
		#print(Pantalla.tasca_actual)
		

func activa_menu_compres():
	if not menu_compres.is_visible_in_tree() and !generant_treballadors:
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
				var valors = BusinessEngine.llista_material[contractes_temp]
				if valors.nivell <= pantalla.nivell:
					var fitxa_terballador_temp = fitxa_material.instantiate()
					#print(contractes_temp)
					fitxa_terballador_temp.get_node("%labelNom").text = valors.nom
					fitxa_terballador_temp.get_node("%imatge").texture = load(valors.icona)
					fitxa_terballador_temp.get_node("%descripcio").text = valors.descripcio
					fitxa_terballador_temp.get_node("%labelPreu").text = str(valors.preu)
					fitxa_terballador_temp.get_node("%buttonCompra").pressed.connect(pantalla.carregar_i_precol·locar.bind(valors))
					material.add_child(fitxa_terballador_temp)
				else:
					var fitxa_terballador_temp = fitxa_informativa.instantiate()
					fitxa_terballador_temp.get_node("label"). text = valors.nom + " disponible a partir del nivell " + str(valors.nivell)
					material.add_child(fitxa_terballador_temp)
				counter+=1
			
		if BusinessEngine.llista_locals.is_empty():
			var fitxa_terballador_temp = fitxa_informativa.instantiate()
			fitxa_terballador_temp.get_node("Label").text = "No hi ha locals disponibles!"
			locals.add_child(fitxa_terballador_temp)
		else:
			var counter := 0
			for contractes_temp in BusinessEngine.llista_locals :
				var valors = BusinessEngine.llista_locals[contractes_temp]
				if valors.nivell <= pantalla.nivell:
					var fitxa_terballador_temp = fitxa_local.instantiate()
					#print(contractes_temp)
					fitxa_terballador_temp.get_node("%labelNom").text = contractes_temp
					fitxa_terballador_temp.get_node("%descripcio").text = valors.descripcio
					fitxa_terballador_temp.get_node("%labelPreu").text = str(valors.preu)
					fitxa_terballador_temp.get_node("%labelCapacitat").text = str(valors.treballadors)
					fitxa_terballador_temp.get_node("%labelMaterial").text = str(valors.material)
					fitxa_terballador_temp.get_node("%buttonCompra").pressed.connect(pantalla.remplaça_local.bind(get_node("/root/Pantalla/Oficina").get_child(0), valors))
					locals.add_child(fitxa_terballador_temp)
				else:
					var fitxa_terballador_temp = fitxa_informativa.instantiate()
					fitxa_terballador_temp.get_node("Label"). text = contractes_temp + " disponible a partir del nivell " + str(valors.nivell)
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
	
func anima_entrada_display(dades: Treballador):
	print("senyal rebuda: " + str(dades.atributs))
	display_treballador.label_nom.text = dades.atributs.nom
	display_treballador.label_nivell.text = str(dades.atributs.nivell)
	display_treballador.label_sou.text = str(dades.atributs.sou)
	display_treballador.label_disseny.text = str(dades.atributs.disseny)
	display_treballador.label_enginy.text = str(dades.atributs.enginy)
	display_treballador.label_informatica.text = str(dades.atributs.informatica)
	display_treballador.label_social.text = str(dades.atributs.social)
	var old_atlas = display_treballador.imatge_treballador.texture as AtlasTexture
	var regio_atlas = old_atlas.region
	var new_image = load(dades.imatge)
	var new_atlas := AtlasTexture.new()
	new_atlas.atlas = new_image
	new_atlas.region = old_atlas.region
	new_atlas.margin = old_atlas.margin
	new_atlas.filter_clip = old_atlas.filter_clip
	display_treballador.imatge_treballador.texture = new_atlas
	display_treballador.treballador = dades
	display_treballador.show()
	
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(display_treballador, "position:y", 460, 1.0)

func anima_sortida_display():
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(display_treballador, "position:y", 655, 1.0)
	await tween.finished
	display_treballador.hide()
	

func on_feina_acabada_mostra(estrelles: int, fama: int, exp: int) -> void:
	get_node("%FeinaAcabada/MarginContainer2/VBoxContainer/felicitacioLabel").text = BusinessEngine.felicitacions[0].pick_random() + " " + BusinessEngine.felicitacions[1].pick_random()
	for punts in estrelles:
		get_node("%FeinaAcabada/MarginContainer2/VBoxContainer/contenidorEstrelles").get_child(punts).texture = load("res://resources/ux/UI/yellow/star.png")
	get_node("%FeinaAcabada/MarginContainer2/VBoxContainer/VBoxContainer/labelFama").text = "FAMA: " + str(fama)
	get_node("%FeinaAcabada/MarginContainer2/VBoxContainer/VBoxContainer/labelExp").text = "EXP: " + str(exp)
	get_node("%FeinaAcabada").show()

func on_feina_no_acabada_mostra(fama: int, multa: int) -> void:
	get_node("%FeinaNoAcabada/MarginContainer2/VBoxContainer/queixaLabel").text = BusinessEngine.queixes.pick_random()
	get_node("%FeinaNoAcabada/MarginContainer2/VBoxContainer/VBoxContainer/PopUpLabel3").text = "FAMA: " + str(fama)
	get_node("%FeinaNoAcabada/MarginContainer2/VBoxContainer/VBoxContainer/PopUpLabel2").text = "MULTA: " + str(multa)
	get_node("%FeinaNoAcabada").show()

func _on_feina_no_acabada_close_button_pressed() -> void:
	get_node("%FeinaNoAcabada").hide() # Replace with function body.


func _on_feina_acabada_close_button_pressed() -> void:
	get_node("%FeinaAcabada").hide()


func _on_calendari_pressed() -> void:
	if !get_node("%ControlTemps").is_visible():
		get_node("%ControlTemps").show()
	else:
		%ControlTemps.hide()


func _on_control_temps_close_button_pressed() -> void:
	if !get_node("%ControlTemps").is_visible():
		get_node("%ControlTemps").show()
	else:
		%ControlTemps.hide()


func _on_renda_button_pressed() -> void:
	calendari.paga_renda()


func _on_impostos_button_pressed() -> void:
	calendari.paga_impostos()


func _on_temps_x_1_pressed() -> void:
	pass # Replace with function body.


func _on_temps_x_2_pressed() -> void:
	pass # Replace with function body.


func _on_temps_x_3_pressed() -> void:
	pass # Replace with function body.
