extends CanvasLayer
class_name UX

@onready var liquid: Label = %Liquid
@onready var calendari: Control = %Calendari
@onready var dia: Label = %dia
@onready var mes: Label = %mes
@onready var any: Label = %any

@onready var calaix_aplicacions: GridContainer = %CalaixAplicacions

@export var tween_intensity: float
@export var tween_duration: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dia.text = str(Calendar.day)
	mes.text = str(Calendar.mes_en_text)
	any.text = str(Calendar.year)
	for button in calaix_aplicacions.get_children():
		btn_hovered(button)

func start_tween(object: Object, property: String, final_val:Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: Button):
	button.pivot_offset = button.size /2
	if button.is_hovered():
		start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		start_tween(button, "scale", Vector2.ONE, tween_duration)
