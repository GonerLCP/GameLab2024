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
		objetTombe.position = global_position
		add_child(objetTombe)
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
	
	
	#indice1 = load("res://Musique/Indices/S"+ str(Global.currentRoom) + "/01.mp3")
	#indice2 = load("res://Musique/Indices/S"+ str(Global.currentRoom) + "/02.mp3")
	#indice3 = load("res://Musique/Indices/S"+ str(Global.currentRoom) + "/03.mp3")
	#numeroIndice = 1
	#$Timer.start()
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


func _on_timer_timeout():
	IndiceOrphee()
	$Timer.set_wait_time(5.0)
	pass # Replace with function body.
