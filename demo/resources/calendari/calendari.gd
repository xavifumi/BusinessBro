extends Node
class_name Calendar

static var year: int = 2021
static var month: int = 1  # Gener
static var mes_en_text: String = "gener"
static var day: int = 1
var global_engine 
@onready var display_any: Label = $UI/VBoxContainer/displayAny
@onready var display_mes: Label = $UI/VBoxContainer/HBoxContainer/displayMes
@onready var display_dia: Label = $UI/VBoxContainer/HBoxContainer/displayDia
@onready var button_x_2: Button = $UI/VBoxContainer/HBoxContainer2/x2
@onready var button_x_1: Button = $UI/VBoxContainer/HBoxContainer2/x1
@onready var button_x_4: Button = $UI/VBoxContainer/HBoxContainer2/x4


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
		paga_nomines()
		#impostos
		if month % 3 == 0:
			paga_impostos()
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

func paga_nomines() -> void:
	var nomines = 0
	for treballadors in get_node("Pantalla/Plantilla").get_children():
		nomines += treballadors.sou
	Pantalla.diners -= nomines
	Pantalla.diners -= Pantalla.lloguer
	Pantalla.despeses += (nomines + Pantalla.lloguer)
	
func paga_impostos() -> void:
	get_node("Ux").anima_label(get_node("Ux/PantallaSencera/PanellSuperior/MarginContainer/HBoxContainer/Liquid"), Pantalla.diners, Pantalla.beneficis_trimestre * 0.21)
	Pantalla.diners -= Pantalla.beneficis_trimestre * 0.21
	Pantalla.beneficis_any += Pantalla.beneficis_trimestre
	Pantalla.beneficis_trimestre = 0
	
func paga_renda() -> void:
	Pantalla.diners -= (Pantalla.beneficis_trimestre - Pantalla.despeses) * 0.25
