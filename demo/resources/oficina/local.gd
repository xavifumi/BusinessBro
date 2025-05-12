extends Node2D
const MAX_PARTICLES := 500

@onready var fons: TileMapLayer = %Fons
@onready var particules_fons: GPUParticles2D = %ParticulesFons

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#emetre_particules_des_de_fons()
	particules_fons.emitting = true
	await get_tree().create_timer(0.4).timeout
	particules_fons.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
