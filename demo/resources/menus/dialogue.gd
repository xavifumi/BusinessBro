extends Control

var bodies := {
	"sophia": preload("res://assets/sophia.png"),
	"pink": preload("res://assets/pink.png")
}

var expressions := {
	"happy": preload("res://assets/emotion_happy.png"),
	"regular": preload("res://assets/emotion_regular.png"),
	"sad": preload("res://assets/emotion_sad.png"),
}

var voices := {
	"sophia": preload("res://assets/talking_synth.ogg"),
	"pink": preload("res://assets/talking_synth_alternate.ogg")
}

@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer


var dialogue_items: Array[Dictionary] = [

	{
		"expression": expressions["regular"],
		"text": "I've been learning about [wave]arrays and dictionaries[/wave] lately.",
		"character": "sophia",
	},
	{
		"expression": expressions["regular"],
		"text": "Oh, nice. How has it been going?",
		"character": "pink",
	},
	{
		"expression": expressions["sad"],
		"text": "Well... it's a little [shake]complicated[/shake]!",
		"character": "sophia",
	},
	{
		"expression": expressions["sad"],
		"text": "Oh!",
		"character": "pink",
	},
	{
		"expression": expressions["regular"],
		"text": "It sure takes time to click at first.",
		"character": "pink",
	},
	{
		"expression": expressions["happy"],
		"text": "If you keep at it, eventually, you'll get the hang of it!",
		"character": "pink",
	},
	{
		"expression": expressions["regular"],
		"text": "Mhhh... I see. I'll keep at it, then.",
		"character": "sophia",
	},
	{
		"expression": expressions["happy"],
		"text": "Thanks for the encouragement. Time to [tornado freq=3.0][rainbow val=1.0]LEARN!!![/rainbow][/tornado]",
		"character": "sophia",
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
	expression.texture = current_item.expression
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
		get_tree().quit()
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
