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

signal dissmiss_Press(pos1,pos2,coll1)
signal moveCamera(top,left,bottom,right)
func _ready():
	dirTampon = false
	pass # Replace with function body.

func _physics_process(delta):
	CurrentStaticBody = $DroiteInteract
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y >= 1000 :
			velocity.y = 1000
	
	if Input.is_action_just_pressed("Jump") && is_on_floor() :
		velocity.y = -jump_force
	
	if Input.is_action_just_pressed("Interact") and ColliderInteract != null :
		#print(ColliderInteract.name)
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
	#var cam = $Camera2D
	#
	#cam.limit_top = collision_shape.global_position.y - size.y/2
	#cam.limit_left =  collision_shape.global_position.x - size.x/2
	#
	#cam.limit_bottom = cam.limit_top + size.y
	#cam.limit_right = cam.limit_left + size.x
	pass # Replace with function body.
