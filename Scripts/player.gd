extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 750

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
var CurrentStaticBody : Area2D  
var ColliderInteract : Area2D
var ColliderPris
var direction : bool
var dirTampon : bool
var horizontal_direction : Vector2 = Vector2.ZERO
var animationLocked : bool = false
var numeroIndice =0
var jaiaucunehonte = 0 #compteurdecombiendeporteparcourue

var Indices 
var IndicesCE = ["Oh pittoresque jardin, si seulement je ne savais pas quelle hydre monstrueuse tu caches dans tes sous-bois", "Cupidon lui-même m'avertit du drame. Car alors que ma belle épousée s'égayait dans ces vertes campagnes, elle rencontra caché sous ses pas, l'Auteur de son trépas.", "Tandis que dans l'herbe se promenait mon Eurydice avec son escorte de Naïades, elle meurt, mordue au talon par la dent d’un serpent." ]
var IndicesCDL = ["Mon Eurydice perdue, j'éclate en cris perçants, et me débonde en pleurs. Mais j’ai beau m’affliger, conjurer, et prier, je ne gagne qu'un rhume à force de crier.","Posé sous une branche je recommence ma chanson lamentable, et de mes notes douloureuses je pleurais Eurydice.","En entendant mon chant, les habitants de l’enfer, eux qui n’ont point de sang, versèrent des larmes, mouillant le poil chenu de mon pinceau."]
var IndicesAT = ["La passion et la douleur sont les aliments de mon coeur, l’ultime lumière qui guide mon chant vers les cieux." ,"Par le nitre embrasé de ces enfers brûlants et de ces noirs flambeaux fumants, je me voyais, Moi, me consolant de mon douloureux amour, sur les creuses écailles de ma lyre.","Ma seule étoile est morte, et dans son  tombeau elle emporte, le soleil noir de ma Mélancolie"]
var IndicesRI = ["J’arrivai alors, au bord du ciel splendide, la  mer sublime ce soir baignée d’or,devant l’âme immense du grand hymne d’un poète presque mort.","Tandis que je commençais à chanter, m’accompagnant de mon luth constellé, j'arrachais des pleurs aux âmes exsangues ; Tantale cessa de saisir l'onde toujours fuyante et toi, Sisyphe, tu t'assis sur ton rocher.","Alors, j’entendis les vagues réclamer, ma tête gracieuse et ma lyre en trophée."]

var indice1
var indice2
var indice3

signal dissmiss_Press(pos1,pos2,coll1)
signal moveCamera(top,left,bottom,right)
func _ready():
	dirTampon = false
	$TeteOrphee.visible = false
	IndiceOrphee()
	pass # Replace with function body.

func _physics_process(delta):
	CurrentStaticBody = $DroiteInteract
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y >= 1000 :
			velocity.y = 1000
	
	if Input.is_action_just_pressed("Jump") && is_on_floor() :
		velocity.y = -jump_force
	if Input.is_action_just_pressed("decapit") :
		var corpsdorphee = load("res://Nodes/DecapitedBody.tscn")
		var objetTombe = corpsdorphee.instantiate()
		objetTombe.position = position
		objetTombe.position.y = objetTombe.position.y - 165
		$"..".add_child(objetTombe)
		$AnimatedSprite2D.visible = false
		$TeteOrphee.visible = true
		$AnimationPlayer.play("TeteQuiRoule",-1,1.0,false)

	if Input.is_action_just_pressed("Interact") and ColliderInteract != null :
		ColliderPris = ColliderInteract.name
		Global.cleRecup[ColliderInteract.get_node("SpeItem").numPorte] = 1
		$"../UI".get_child(0).set_texture(ColliderInteract.get_child(1).get_texture())
		ColliderInteract.queue_free()
	
	if Input.is_action_just_pressed(("Dismiss")) and $"../UI".get_child(0).get_texture() != null:
		print(ColliderPris)
		dissmiss_Press.emit($ListeSpawnPos.get_child(0).global_position,$ListeSpawnPos.get_child(1).global_position, ColliderPris)
		
	horizontal_direction = Input.get_vector("left","right","up","down")
	
	velocity.x = 300 * horizontal_direction.x
	
	if velocity.x < 0 :
		direction = true
	elif velocity.x > 0:
		direction = false
	flipBox(direction)
	move_and_slide()
	updateAnimation()
	UpdateFacingDirection()
	#print(ColliderInteract)

func flipBox(dir) :
	if dirTampon != dir :
		dirTampon = dir
		CurrentStaticBody.position.x *= -1
	pass

func updateAnimation() :
	if !animationLocked :
		if horizontal_direction.x != 0 :
			animated_sprite.play("Walk")
		else :
			animated_sprite.play("Idle")
	if !is_on_floor():
		animated_sprite.play("Jump")
	pass

func UpdateFacingDirection() :
	if horizontal_direction.x > 0 :
		animated_sprite.flip_h = false
	if horizontal_direction.x < 0 :
		animated_sprite.flip_h = true
	pass

func _on_droite_area_entered(area):
	ColliderInteract = area
	pass # Replace with function body.


func _on_droite_area_exited(area):
	ColliderInteract = null
	pass # Replace with function body.


func _on_room_detector_area_entered(area):
	var collision_shape = area.get_node("CollisionShape2D")
	var size =  collision_shape.shape.extents*2
	
	var view_size = get_viewport_rect().size
	if size.y < view_size.y :
		size.y = view_size.y
	
	if size.x < view_size.x :
		size.x = view_size.x
		
	moveCamera.emit(collision_shape.global_position.y - size.y/2,collision_shape.global_position.x - size.x/2,size.y,size.x)
	jaiaucunehonte= jaiaucunehonte + 1
	if(jaiaucunehonte >= 4 ):
		$"../Camera2D".zoom = Vector2(0.5,0.5)
	
	$"../UI".get_child(1).set_text("")
	#indice1 = load("res://Musique/Indices/S"+ str(Global.currentRoom) + "/01.mp3")
	#indice2 = load("res://Musique/Indices/S"+ str(Global.currentRoom) + "/02.mp3")
	#indice3 = load("res://Musique/Indices/S"+ str(Global.currentRoom) + "/03.mp3")
	numeroIndice = 0
	
	match(Global.currentRoom):
		6:
			Indices = IndicesCE
		7:
			Indices = IndicesCDL
		8:
			Indices = IndicesAT
		9:
			Indices = IndicesRI
	$Timer.start()
	pass # Replace with function body.

func IndiceOrphee():
	#$AudioStreamPlayer2D.set_stream(mabite)
	match(numeroIndice) :
		1:
			$AudioStreamPlayer2D.set_stream(indice1)
		2:
			$AudioStreamPlayer2D.set_stream(indice2)
		3:
			$AudioStreamPlayer2D.set_stream(indice3)
	if numeroIndice <= 3 :
		$AudioStreamPlayer2D.play(0.0)
		pass
	numeroIndice = numeroIndice + 1
	
	pass

func sdkjfisj() :
	if numeroIndice <= 2 : 
		$"../UI".get_child(1).visible = true
		$"../UI".get_child(1).set_text(Indices[numeroIndice])
	numeroIndice = numeroIndice + 1

func _on_timer_timeout():
	#IndiceOrphee()
	sdkjfisj()
	$Timer.set_wait_time(5.0)
	pass # Replace with function body.
