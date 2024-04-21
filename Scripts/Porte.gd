extends StaticBody2D

@export var numPorte : int
@export var nomSpriteOuvert : String #Renseigner le nom du sprite a remplacer
var spriteOuvert 
# Called when the node enters the scene tree for the first time.
func _ready():
	var stringdeFou = "res://Assetts/PortesOuvertes/" + str(nomSpriteOuvert)
	spriteOuvert = load(stringdeFou) #Quand on aura tout remplacer par l'emplacement du fichier et liasser un blanc pour nomSpriteOuvert
	pass # Replace with function body.



@warning_ignore("unused_parameter")
func _on_area_2d_body_entered(body): #Si je veux arreter le joueur je devrais mettre un collider autre et pas un area
	if Global.cleRecup[numPorte] == 1 :
		$Sprite2D.texture = spriteOuvert
		$CollisionShape2D.set_deferred("disabled", true)
		Global.currentRoom = numPorte
		#self.queue_free()
	pass # Replace with function body.
