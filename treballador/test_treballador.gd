class_name Pantalla extends Node2D

static var posicions_descans = {}
static var posicions_treball = {}
static var diners := 0
static var tenim_tasca := true
var tasca_exemple = {
	"nom": "Pla de Marketing",
	"dies_restants": 10,
	"recompensa": 5000,
	"feina":500
}

static var tasca_actual = {
	"nom": "Pla de Marketing",
	"dies_restants": 10,
	"recompensa": 5000,
	"feina":500
}

static var feina_acumulada = {
	"disseny": 0,
	"enginyer": 0,
	"informatica": 0
}

static var feina_total_acumulada = 0
var button_feina 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_feina = get_node("Control/ButtonFeina")
	button_feina.connect("pressed", Callable(self, "_on_button_feina_pressed"))
	
	for node in get_node("esbarjo").get_children():
		posicions_descans[node.global_position] = null

	for node in get_node("treball").get_children():
		posicions_treball[node.global_position] = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var label_diners = get_node("Control/labelDiners")
	var progres_feina = get_node("Control/ProgressBar")
	progres_feina.max_value = tasca_actual["feina"] if tasca_actual.size() != 0 else 0
	feina_total_acumulada = feina_acumulada["disseny"] + feina_acumulada["enginyer"] + feina_acumulada["informatica"]
	progres_feina.value = feina_total_acumulada
	label_diners.text = "diners: " + str(diners) + "€"
	if tasca_actual.size() != 0:
		_feina_in_progress()
	
func _feina_in_progress()->void:
	var progres_feina = get_node("Control/ProgressBar")
	if tasca_actual["dies_restants"] > 0:
		if tasca_actual["feina"] <= feina_total_acumulada:
			diners += tasca_actual["recompensa"]
			tasca_actual = {}
			feina_acumulada = {
				"disseny": 0,
				"enginyer": 0,
				"informatica": 0
			}
			feina_total_acumulada = 0
			progres_feina.value = feina_total_acumulada
			
func _on_button_feina_pressed() -> void:
	tasca_actual = tasca_exemple
	print(tasca_actual)
