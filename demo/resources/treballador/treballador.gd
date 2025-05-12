class_name Treballador extends CharacterBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var emocions: Sprite2D = %Emocions
@onready var _raycasts: Node2D = %Raycasts
@onready var particules_treball: GPUParticles2D = %ParticulesTreball
@onready var progress_energia: ProgressBar = %progressEnergia
@onready var print_estat: Label = $Control/printEstat
@onready var audio_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var sprite_2d: Sprite2D = %Sprite2D

@export var max_speed := 300.0
var actual_speed := 300.0
@export var acceleration := 300.0
@export var deceleration := 5000.0
@export var avoidance_strength := 500.0
var posicio_desti = Vector2.INF

static var atributs = {
	"nom": "",
	"nivell": 1,
	"sou": 15000,
	"disseny": 100,
	"enginy": 100,
	"informatica": 100,
	"social": 0,
	"motivacio": 1,
	"energia": 100
}
static var imatge = "res://resources/treballador/imatges_treballadors/Character 1.png"

var energia_actual := 100
var descansant = false
var moviment := false
var treballant := false
var tween_começat = false
var last_delta = 0

var llista_emocions = {
	"ofuscat": Vector2i(1,1), "cantant": Vector2i(2,1), "trist": Vector2i(3,1), "gota": Vector2i(4,1), "cercle": Vector2i(5,1),
	"malediccio": Vector2i(1,2), "riure": Vector2i(2,2), "feliç": Vector2i(3,2), "diners": Vector2i(5,2), "estrella": Vector2i(1,3),
	"bombeta": Vector2i(2,3), "cors": Vector2i(2,4), "exclamacions": Vector2i(3,4), "enfadat": Vector2i(5,4), "cor_trencat": Vector2i(2,5),
	"exclamacio_gran": Vector2i(3,5), "creu": Vector2i(4,5), "interrogant": Vector2i(1,6), "cor_gran": Vector2i(2,6), "suor": Vector2i(3,6),
	"nuvol": Vector2i(4,6), "mal_humor": Vector2i(5,6)
}
var audio_bombolles = load("res://resources/treballador/702996_bombolles.mp3")

enum States {TREBALLANT, ESTUDIANT, ESPERANT, AVORRIT, CAOS}

var estat: States = States.ESPERANT
var avorriment: Timer
var tasca: Timer
var pantalla

func _ready() -> void:
	tasca = get_node("tasca")
	tasca.one_shot = true
	tasca.set_wait_time(5)
	tasca.connect("timeout", Callable(self, "fes_tasca"))

	avorriment = get_node("avorriment")
	avorriment.set_wait_time(5)
	avorriment.one_shot = true
	avorriment.connect("timeout", avorreix.bind(last_delta))

	progress_energia.max_value = atributs["energia"]
	sprite_2d.texture = load(imatge)
	pantalla = get_node("/root/Pantalla")
	animation_player.play("apareix")

func _process(delta: float) -> void:
	last_delta = delta
	var estat_a_text = States.keys()[estat]
	print_estat.text = "treballant: " + str(treballant) + " -descansant: " + str(descansant)
	progress_energia.value = energia_actual

	match estat:
		States.TREBALLANT:
			treballa(delta)
		States.ESTUDIANT:
			estudia()
		States.ESPERANT:
			espera()
		States.AVORRIT:
			avorreix(delta)
		States.CAOS:
			caos()

func mostra_emocio(emocio: String) -> void:
	tween_começat = true
	var coord_emocio = llista_emocions[emocio] - Vector2i(1,1)
	emocions.frame_coords = coord_emocio
	var tween = create_tween()
	if tween_começat:
		tween.set_trans(Tween.TRANS_EXPO)
		tween.tween_property(emocions, "scale", Vector2(1.5,1.5), 1).set_delay(0.5)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(emocions, "scale", Vector2(), 1).set_delay(5)
		tween_começat = false

func treballa(delta: float) -> void:
	if Pantalla.tasca_actual.size() != 0:
		if energia_actual > atributs["energia"] * 0.1:
			if not treballant and not moviment:
				var nova_posicio = BusinessEngine.assigna_posicio_treball()
				if nova_posicio != Vector2.INF:
					if posicio_desti != Vector2.ZERO and posicio_desti in BusinessEngine.posicions_treball:
						BusinessEngine.posicions_treball[posicio_desti] = "lliure"
					posicio_desti = limita_posicio(nova_posicio)
					moviment = true
					print("Assignada nova posició de treball: " + str(posicio_desti))
				else:
					print("Cap posició de treball disponible.")
			elif not treballant and moviment:
				camina(posicio_desti, delta)
			else:
				espera()

			if tasca.is_stopped() and (treballant or not moviment):
				animation_player.play("work")
				await get_tree().create_timer(1.0).timeout
				tasca.set_wait_time(randi_range(2, 5))
				tasca.start()
		else:
			if posicio_desti in BusinessEngine.posicions_treball:
				BusinessEngine.posicions_treball[posicio_desti] = "lliure"
			mostra_emocio("ofuscat")
			estat = States.AVORRIT
			treballant = false
	else:
		mostra_emocio("feliç")
		estat = States.ESPERANT
		treballant = false
		if posicio_desti in BusinessEngine.posicions_treball:
			BusinessEngine.posicions_treball[posicio_desti] = "lliure"

func tria_aleatori(dic: Dictionary) -> String:
	var total = 0
	for valor in dic.values():
		total += valor
	
	var rand = randi_range(1, total)
	var acumulat = 0

	for clau in dic.keys():
		acumulat += dic[clau]
		if rand <= acumulat:
			return clau
	return dic.keys()[0]

func fes_tasca() -> void:
	if treballant:
		var feina_actual : String
		var stats := {
			"disseny": atributs["disseny"],
			"enginy": atributs["enginy"],
			"informatica": atributs["informatica"]
			}
		feina_actual = tria_aleatori(stats)
		match feina_actual:
			"disseny":
				particules_treball.texture = load("res://resources/palette.svg")
			"enginy":
				particules_treball.texture = load("res://resources/unbalanced.svg")
			"informatica":
				particules_treball.texture = load("res://resources/processor.svg")
		var punts_feina_actuals = randi_range(atributs[feina_actual]*atributs["motivacio"], atributs[feina_actual])
		energia_actual -= punts_feina_actuals / 3
		pantalla.feina_acumulada[feina_actual] += punts_feina_actuals
		pantalla.feina_total_acumulada += punts_feina_actuals
		#Pantalla.feina_total_acumulada += punts_feina_actuals
		particules_treball.emitting = true
		audio_player.stream = audio_bombolles
		audio_player.pitch_scale = randf_range(0.7, 1.3)
		audio_player.play()
		await get_tree().create_timer(1.0).timeout
		particules_treball.emitting = false
		print(pantalla.feina_acumulada)
		print(Pantalla.feina_acumulada)
	if descansant:
		energia_actual += 10

func estudia() -> void:
	pass

func espera() -> void:
	var confetti = get_node("/root/Pantalla/Confetti")
	if confetti.get_node("verd").is_emitting():
		var delay = randf_range(0.0, 1.5)
		await get_tree().create_timer(delay).timeout
		animation_player.play("celebra")
	else:
		animation_player.queue("idle")
	if Pantalla.tasca_actual.size() != 0:
		estat = States.TREBALLANT

func avorreix(delta: float) -> void:
	avorriment.start()
	if not descansant and not moviment:
		posicio_desti = limita_posicio(BusinessEngine.assigna_posicio_descans())
		moviment = true
	elif not descansant and moviment:
		camina(posicio_desti, delta)
	else:
		if energia_actual < atributs["energia"]:
			animation_player.play("idle")
			if tasca.is_stopped():
				tasca.set_wait_time(randi_range(1, 1))
				tasca.start()
			energia_actual += 0.01
		else:
			BusinessEngine.posicions_descans[posicio_desti] = "lliure"
			estat = States.ESPERANT

func caos() -> void:
	pass

func camina(desti: Vector2, delta: float) -> void:
	if not is_instance_valid(get_viewport()):
		return
	var screen_rect = get_viewport().get_visible_rect()
	if not screen_rect.has_point(desti):
		print("Posició fora de pantalla: ", desti)
		moviment = false
		return
	var rot = rad_to_deg((global_position - desti).angle())
	if global_position != desti:
		moviment = true
		$Sprite2D.flip_h = rot >= -90 and rot <= 90
		animation_player.play("walk")
		global_position = global_position.move_toward(desti, delta * max_speed)
	else:
		moviment = false

func limita_posicio(pos: Vector2) -> Vector2:
	var screen_rect = get_viewport().get_visible_rect()
	return Vector2(
		clamp(pos.x, screen_rect.position.x, screen_rect.end.x),
		clamp(pos.y, screen_rect.position.y, screen_rect.end.y)
	)

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
