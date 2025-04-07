class_name Treballador extends CharacterBody2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var emocions: Sprite2D = %Emocions
@onready var _raycasts: Node2D = %Raycasts

@export var max_speed := 300.0
var actual_speed := 500.0
## How much speed is added per second when the player presses a movement key.
@export var acceleration := 600.0
## How much speed is lost per second when the player releases all movement keys.
@export var deceleration := 540.0
@export var avoidance_strength := 21000.0

var atributs = {
	"nivell": 1,
	"disseny": 0,
	"enginyer": 0,
	"informatica": 0,
	"social": 0,
	"motivacio": 1
}
var llista_emocions ={
	"ofuscat" : Vector2i(1,1),
	"cantant" : Vector2i(2,1),
	"trist" : Vector2i(3,1),
	"gota" : Vector2i(4,1),
	"cercle" : Vector2i(5,1),
	"malediccio" : Vector2i(1,2),
	"riure" : Vector2i(2,2),
	"feliç" : Vector2i(3,2),
	"diners" : Vector2i(5,2),
	"estrella" : Vector2i(1,3),
	"bombeta" : Vector2i(2,3),
	"cors" : Vector2i(2,4),
	"exclamacions" : Vector2i(3,4),
	"enfadat" : Vector2i(5,4),
	"cor_trencat" : Vector2i(2,5),
	"exclamacio_gran" : Vector2i(3,5),
	"creu" : Vector2i(4,5),
	"interrogant" : Vector2i(1,6),
	"cor_gran" : Vector2i(2,6),
	"suor" : Vector2i(3,6),
	"nuvol" : Vector2i(4,6),
	"mal_humor" : Vector2i(5,6)
}

enum States {TREBALLANT, ESTUDIANT, ESPERANT, AVORRIT, CAOS}

var estat: States = States.ESPERANT
var avorriment: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("idle")
	avorriment = Timer.new()
	avorriment.set_wait_time(10.0)
	avorriment.one_shot = true
	avorriment.connect("timeout", Callable(self, "avorreix"))
	add_child(avorriment)
	avorriment.start()
	#mostra_emocio("riure")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match estat:
		States.TREBALLANT:
			treballa()
		States.ESTUDIANT:
			estudia()
		States.ESPERANT:
			espera()
		States.AVORRIT:
			avorreix(delta)
		States.CAOS:
			caos()

func treballa() -> void:
	pass

func estudia() -> void:
	pass

func espera() -> void:
	pass

func avorreix(delta: float) -> void:
	print("avorrit!")
	

func caos() -> void:
	pass

func mostra_emocio(emocio: String)-> void:
	var coord_emocio = llista_emocions[emocio] - Vector2i(1,1)
	emocions.frame_coords = coord_emocio
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(emocions, "modulate:a", 255, 1).set_delay(0.5)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(emocions, "scale", Vector2(), 1).set_delay(5)
	#tween.tween_callback(emocions.queue_free)	

func camina(desti: Vector2, delta)->void:
	var direction := global_position.direction_to(desti)
	var distance := global_position.distance_to(desti)
	var speed := actual_speed if distance > 100 else actual_speed * distance / 100
	var has_input_direction := direction.length() > 0.0
	var desired_velocity := direction * speed
	desired_velocity += calculate_avoidance_force() * delta
	if has_input_direction:
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()
	if velocity.length() > 10.0:
		animation_player.play("walk")
	else:
		animation_player.play("idle")

func calculate_avoidance_force() -> Vector2:
	var avoidance_force := Vector2.ZERO

	for raycast: RayCast2D in _raycasts.get_children():
		if raycast.is_colliding():
			var collision_position := raycast.get_collision_point()
			var direction_away_from_obstacle := collision_position.direction_to(raycast.global_position)
			var ray_length := raycast.target_position.length()
			var intensity := 1.0 - collision_position.distance_to(raycast.global_position) / ray_length
			var force := direction_away_from_obstacle * avoidance_strength * intensity
			avoidance_force += force
	return avoidance_force
