extends Node2D
var emitting


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	emitting = self.get_children()[0].is_emitting()

func dispara_confetti():
	for confetti in self.get_children():
		confetti.emitting = true
