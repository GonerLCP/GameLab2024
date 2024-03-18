extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 500

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y >= 1000 :
			velocity.y = 1000
	
	if Input.is_action_just_pressed("Jump") && is_on_floor() :
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("left","right")
	
	velocity.x = 300 * horizontal_direction
	move_and_slide()
	print(velocity)
