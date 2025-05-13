extends Area2D
var ocupat := false
@export var tipus: String = "descans" # o "treball", segons el cas
var preu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("arrossegables")
	add_to_group(tipus)
	self.input_pickable = true
	connect("input_event", Callable(self, "_on_input_event"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	body.descansant = true
	#ocupat = true

func _on_body_exited(body: Node2D) -> void:
	body.descansant = false
	#ocupat = false
	
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		emit_signal("reubicar_solicitat", self)

# Opcional: defineix el senyal personalitzat
signal reubicar_solicitat(node)
