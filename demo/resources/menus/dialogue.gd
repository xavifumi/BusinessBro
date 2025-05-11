extends CanvasLayer

var bodies := {
	"base": preload("res://resources/dialegs/1746946914129.jpg")
}

var voices := {
	"base": preload("res://resources/sons/talking_synth.ogg"),
}

@onready var body: TextureRect = %Body
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer


var dialogue_items: Array[Dictionary] = [

	{
		"text": "Hey Bro! \nBenvingut al món dels taurons de Wall Street!",
		"character": "base",
	},
		{
		"text": "Bé, no som a Wall Street, però gràcies a la tecnologia podem ser d'on volguem, sóm esperits lliures, nòmades digitals... vull dir que no ens cal tributar al lloc on vivim...",
		"character": "base",
	},
		{
		"text": "L'important és que tens [wave][rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0]DINERS[/rainbow][/wave] i has pres la decisió correcta: Guanyar-ne més.",
		"character": "base",
	},
	{
		"text": "Però no pateixis, no és tan dificil com sembla, a baix de la pantalla tens tot el que necessites per triomfar: eines per a que uns altres treballin per tu.",
		"character": "base",
	},
	{
		"text": "Com pots veure hi ha tres botons, un per a contractar terballadors, un per a acceptar projectes i un altre per a comprar el material que necessiten els teus [s]micos[/s] treballadors per a produir beneficis.",
		"character": "base",
	},
	{
		"text": "L'únic que has de recordar és que els diners que t'hem deixat, [pulse freq=1.0 color=#ffffff40 ease=-2.0][b]ens els has de tornar d'aqui 6 mesos exactament.[/b][/pulse] El dia 1 de juliol.",
		"character": "base",
	},
	{
		"text": "[shake rate=20.0 level=5 connected=1] JAJAJAJAJAJAJA[/shake] Que si no els pots tornar dius? Que graciós que ets.",
		"character": "base",
	},
		{
		"text": "Millor que no t'hi trobis. De veritat",
		"character": "base",
	},
		{
		"text": "Doncs, apa, sort amb la teva empresa,  Bro!",
		"character": "base",
	},
]

var current_item_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_text()
	next_button.pressed.connect(advance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	body.texture = bodies[current_item.character]
	rich_text_label.text = current_item.text
	rich_text_label.visible_ratio = 0.0
	audio_stream_player.stream = voices[current_item.character]
	var tween := create_tween()
	var current_text: String = current_item["text"]
	var text_appearing_duration := current_text.length() / 30.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	var sound_max_length := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_length
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)
	slide_in()
	next_button.disabled = true
	tween.finished.connect(func() -> void:
		next_button.disabled = false
	)

func advance() -> void:
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		queue_free()
	else:
		show_text()
		
func slide_in() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	body.position.x = 200.0
	tween.tween_property(body, "position:x", 0.0, 0.3)
	body.modulate.a = 0.0
	tween.parallel().tween_property(body, "modulate:a", 1.0, 0.2)
