extends StaticBody2D

@export var numPorte : int
@export var nomSpriteOuvert : String
var spriteOuvert 
# Called when the node enters the scene tree for the first time.
func _ready():
	spriteOuvert = preload("res://Assetts/S6 - Les Champs Elysées/porteS7.png")
	pass # Replace with function body.



@warning_ignore("unused_parameter")
func _on_area_2d_body_entered(body): #Si je veux arreter le joueur je devrais mettre un collider autre et pas un area
	if Global.cleRecup[numPorte] == 1 :
		$Sprite2D.texture = spriteOuvert
		#$CollisionShape2D.disabled = true
		$CollisionShape2D.set_deferred("disabled", true)
		#self.queue_free()
	pass # Replace with function body.
