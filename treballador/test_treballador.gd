extends Node2D
@export var posicions_descans = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_node("esbarjo").get_children():
		posicions_descans[node.position] = null
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
