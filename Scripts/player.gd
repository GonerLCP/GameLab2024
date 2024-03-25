extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 500

var CurrentStaticBody : Area2D  
var ColliderInteract : StaticBody2D
var ColliderPris
var direction : bool
var dirTampon : bool

signal dissmiss_Press(pos1,pos2,coll1)

func _ready():
	dirTampon = false
	pass # Replace with function body.

func _physics_process(delta):
	CurrentStaticBody = $Droite
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y >= 1000 :
			velocity.y = 1000
	
	if Input.is_action_just_pressed("Jump") && is_on_floor() :
		velocity.y = -jump_force
	
	if Input.is_action_just_pressed("Interact") and ColliderInteract != null :
		#print(ColliderInteract.name)
		ColliderPris = ColliderInteract.name
		$"../UI".get_child(0).set_texture(ColliderInteract.get_child(1).get_texture())
		ColliderInteract.queue_free()
	
	if Input.is_action_just_pressed(("Dismiss")) and $"../UI".get_child(0).get_texture() != null:
		print(ColliderPris)
		dissmiss_Press.emit($ListeSpawnPos.get_child(0).global_position,$ListeSpawnPos.get_child(1).global_position, ColliderPris)
		
	var horizontal_direction = Input.get_axis("left","right")
	
	velocity.x = 300 * horizontal_direction
	
	if velocity.x < 0 :
		direction = true
	elif velocity.x > 0:
		direction = false
	flipBox(direction)
	move_and_slide()
	#print(ColliderInteract)

func flipBox(dir) :
	if dirTampon != dir :
		dirTampon = dir
		CurrentStaticBody.position.x *= -1
	pass


func _on_droite_body_entered(body):
	ColliderInteract = body
	pass # Replace with function body.


func _on_droite_body_exited(body):
	ColliderInteract = null
	pass # Replace with function body.
