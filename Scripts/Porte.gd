extends StaticBody2D

@export var numPorte : int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_2d_body_entered(body): #Si je veux arreter le joueur je devrais mettre un collider autre et pas un area
	if Global.cleRecup[numPorte] == 1 :
		self.queue_free()
	pass # Replace with function body.
