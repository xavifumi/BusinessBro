extends Area2D
var ocupat := false
@export var tipus: String = "treball" # o "treball", segons el cas
var preu

signal reubicar_solicitat(node)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("arrossegables")
	add_to_group(tipus)
	self.input_pickable = true
	connect("input_event", Callable(self, "_on_input_event"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_body_entered(body: Node2D) -> void:
	pass
	#body.treballant = true
	#ocupat = true
	
func _on_body_exited(body: Node2D) -> void:
	pass
	#body.treballant = false
	#ocupat = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		print("click sobre Taula")
		emit_signal("reubicar_solicitat", self)
		print("Senyal emès!")
