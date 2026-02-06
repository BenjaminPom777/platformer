extends CharacterBody2D


var direction_x: float
@export var speed := 1000
var can_shoot = true
@export var jump_strength :=400
@export var gravity := 1000

signal shoot(pos: Vector2, dir:Vector2)
var isOnFloor: bool
var prevPosition

func get_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_strength		
	if Input.is_action_just_pressed("shoot") and $ReloadTimer.time_left == 0:
		shoot.emit(position, get_local_mouse_position().normalized())
		can_shoot = false
		$ReloadTimer.start()
				
		
func apply_gravity(delta):	
	velocity.y += gravity * delta	
	
func animate():
		$AnimationPlayer.current_animation = "run" 	if direction_x else "idle"
		$Legs.flip_h = direction_x < 0		
	
		if !is_on_floor():
			$AnimationPlayer.current_animation = "jump"
			
		print(is_on_floor())
		print($AnimationPlayer.current_animation)

func _physics_process(delta: float) -> void:
	
	get_input()
	apply_gravity(delta)
	animate()
	
#	moving
	if direction_x:
		velocity.x = direction_x * speed
#	not moving
	else:
		velocity.x = 0
		
	move_and_slide()
	
	

	
