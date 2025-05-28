extends Node
class_name Calendar

static var year: int = 2021
static var month: int = 1  # Gener
static var mes_en_text: String = "gener"
static var day: int = 1
var global_engine 
var pantalla
@onready var display_any: Label = $UI/VBoxContainer/displayAny
@onready var display_mes: Label = $UI/VBoxContainer/HBoxContainer/displayMes
@onready var display_dia: Label = $UI/VBoxContainer/HBoxContainer/displayDia
@onready var button_x_2: Button = $UI/VBoxContainer/HBoxContainer2/x2
@onready var button_x_1: Button = $UI/VBoxContainer/HBoxContainer2/x1
@onready var button_x_4: Button = $UI/VBoxContainer/HBoxContainer2/x4
@onready var impostos_button: TextureButton = get_node("/root/Pantalla").get_node("Ux").get_node("%ImpostosButton")

var dialeg = preload("res://resources/menus/dialogue.tscn")

var seconds_per_day: float = 10.0  # Un dia dura 60 segons
var timer: Timer

var days_in_months = {
	1: 31,  # Gener
	2: 28,  # Febrer (s'actualitza si l'any és de traspàs)
	3: 31,  # Març
	4: 30,  # Abril
	5: 31,  # Maig
	6: 30,  # Juny
	7: 31,  # Juliol
	8: 31,  # Agost
	9: 30,  # Setembre
	10: 31, # Octubre
	11: 30, # Novembre
	12: 31  # Desembre
}

var mesos_in_any = [
	"gener","febrer","març","abril","maig","juny","juliol","agost","setembre","octubre","novembre","desembre"
]

var dialeg_victoria: Array[Dictionary] = [

	{
		"text": "Vaja, vaja!",
		"character": "base",
	},
	{
		"text": "Sembla que ho has aconseguit! I jo que em pensava que no era possible!",
		"character": "base",
	},
	{
		"text": "Vull dir que la majoria no ho aconsegueixe, si no tenen els calerons del papa com a suport.",
		"character": "base",
	},
	{
		"text": "Així que t'has guanyat el dret d'entrar a la piràmide!",
		"character": "base",
	},
	{
		"text": "No, no és cap estafa, només cal que portis més emprenedors amb capital i tu t'emportes una part dels seus beneficis...",
		"character": "base",
	},
	{
		"text": "Convida'm a uns combinats i te n'explico els detalls...",
		"character": "base",
	},
	{
		"text": "Però sobretot, gràcies per jugar a Business Bro!",
		"character": "base",
	},
	]

var dialeg_derrota: Array[Dictionary] = [

	{
		"text": "Hola.",
		"character": "base",
	},
	{
		"text": "Ha arribat l'hora. He vingut a cobrar",
		"character": "base",
	},
	{
		"text": "I sembla que no ho has aconseguit.",
		"character": "base",
	},
	{
		"text": "Però no has de patir, la majoria no ho aconsegueixen.",
		"character": "base",
	},
	{
		"text": "I pels diners tampoc pateixis.",
		"character": "base",
	},
	{
		"text": "Em vas dir que encara tenies els dos ronyons oi?",
		"character": "base",
	}
	]

func _ready():
	timer = Timer.new()
	timer.wait_time = seconds_per_day
	timer.connect("timeout", Callable(self, "_next_day"))
	add_child(timer)
	timer.start()
	update_calendari()
	button_x_1.pressed.connect(
		func():
			timer.stop()
			timer.wait_time = 20.0
			timer.start()
	)
	button_x_2.pressed.connect(
		func():
			timer.stop()
			timer.wait_time = 10.0
			timer.start()
	)
	button_x_4.pressed.connect(
		func():
			timer.stop()
			timer.wait_time = 5.0
			timer.start()
	)
	global_engine = get_tree().root.get_node("GlobalEngine")


func is_leap_year(y: int) -> bool:
	return (y % 4 == 0 and y % 100 != 0) or (y % 400 == 0)

func _next_day():
	day += 1
	if Pantalla.tasca_actual.size() != 0:
		Pantalla.tasca_actual["dies_restants"] -= 1
	if day % 7 == 0:
		global_engine.genera_llista_candidats()
		global_engine.genera_llista_tasques()
	# Comprovar si febrer ha de tenir 29 dies
	if month == 2:
		days_in_months[2] = 29 if is_leap_year(year) else 28
	# Passar al següent mes
	if day > days_in_months[month]:
		day = 1
		month += 1
		#paga_nomines()
		if month % 3 == 0:
			pass
			#paga_impostos()
		# Passar al següent any
		if month > 12:
			month = 1
			year += 1
			paga_renda()
	mes_en_text = mesos_in_any[month-1]
	update_calendari()
	print("Data actual: %02d/%02d/%d" % [day, month, year])
	
func update_calendari() -> void:
	display_any.text = str(year)
	display_mes.text = str(mesos_in_any[month-1])
	display_dia.text = str(day)
	if month % 3 == 0:
		impostos_button.disabled = false
		impostos_button.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	else:
		impostos_button.disabled = true
		#impostos_button
		#impostos_button.self_modulate = Color(0.5, 0.5, 0.5, 1.0)
		pass
	#display_calendari.text = str(day) + " " + str(mesos_in_any[month-1]) + " " + str(year)


func paga_nomines() -> void:
	var nomines = 0
	for treballadors in get_tree().root.get_node("Pantalla/Oficina/Plantilla").get_children():
		nomines += treballadors.atributs["sou"]
	get_node("Ux").anima_label(get_node("Ux/PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid"), Pantalla.diners, Pantalla.diners - nomines - Pantalla.lloguer)
	Pantalla.diners -= nomines
	Pantalla.diners -= Pantalla.lloguer
	Pantalla.despeses += (nomines + Pantalla.lloguer)
	var so = load(pantalla.so_compra)
	pantalla.get_node("%FXPlayer").stream = so
	pantalla.get_node("%FXPlayer").play()
	
func paga_impostos() -> void:
	get_node("Ux").anima_label(get_node("Ux/PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid"), Pantalla.diners, Pantalla.diners - Pantalla.beneficis_trimestre * 0.21)
	Pantalla.diners -= Pantalla.beneficis_trimestre * 0.21
	Pantalla.beneficis_any += Pantalla.beneficis_trimestre
	Pantalla.beneficis_trimestre = 0
	var so = load(pantalla.so_compra)
	pantalla.get_node("%FXPlayer").stream = so
	pantalla.get_node("%FXPlayer").play()
	
func paga_renda() -> void:
	get_node("Ux").anima_label(get_node("Ux/PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid"), Pantalla.diners, Pantalla.diners - (Pantalla.beneficis_any - Pantalla.despeses) * 0.25)
	Pantalla.diners -= (Pantalla.beneficis_any - Pantalla.despeses) * 0.25
	Pantalla.beneficis_any = 0
	var so = load(pantalla.so_compra)
	pantalla.get_node("%FXPlayer").stream = so
	pantalla.get_node("%FXPlayer").play()

func compte_enrere() -> void:
	if month == 7:
		if Pantalla.diners > 100000:
			victoria()
		else:
			derrota()

func victoria() -> void:
	var final = dialeg.instantiate()
	final.text= dialeg_victoria
	final.escena_final = true
	pantalla.add_child(final)
	
	
func derrota() -> void:
	var final = dialeg.instantiate()
	final.text= dialeg_derrota
	final.escena_final = true
	pantalla.add_child(final)
