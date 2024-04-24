extends Path2D

@onready var speed = 150.0
var peutTraveling = false
var OstLesbos = preload("res://Musique/lesbos.wav")
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalAudioStreamPlayer.stream = OstLesbos
	GlobalAudioStreamPlayer.play(0.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if peutTraveling == true :
		$PathFollow2D.progress += delta*speed
	pass


func _on_timer_timeout():
	peutTraveling = true
	pass # Replace with function body.
