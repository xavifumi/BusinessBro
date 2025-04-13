extends Node
class_name Calendar

static var year: int = 2021
static var month: int = 1  # Gener
static var mes_en_text: String = "gener"
static var day: int = 1
@onready var display_any: Label = $UI/VBoxContainer/displayAny
@onready var display_mes: Label = $UI/VBoxContainer/HBoxContainer/displayMes
@onready var display_dia: Label = $UI/VBoxContainer/HBoxContainer/displayDia
@onready var button_x_2: Button = $UI/VBoxContainer/HBoxContainer2/x2
@onready var button_x_1: Button = $UI/VBoxContainer/HBoxContainer2/x1
@onready var button_x_4: Button = $UI/VBoxContainer/HBoxContainer2/x4


var seconds_per_day: float = 20.0  # Un dia dura 60 segons
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

func is_leap_year(y: int) -> bool:
	return (y % 4 == 0 and y % 100 != 0) or (y % 400 == 0)

func _next_day():
	day += 1

	# Comprovar si febrer ha de tenir 29 dies
	if month == 2:
		days_in_months[2] = 29 if is_leap_year(year) else 28
	# Passar al següent mes
	if day > days_in_months[month]:
		day = 1
		month += 1
		# Passar al següent any
		if month > 12:
			month = 1
			year += 1
	mes_en_text = mesos_in_any[month-1]
	update_calendari()
	print("Data actual: %02d/%02d/%d" % [day, month, year])
	
func update_calendari() -> void:
	display_any.text = str(year)
	display_mes.text = str(mesos_in_any[month-1])
	display_dia.text = str(day)
