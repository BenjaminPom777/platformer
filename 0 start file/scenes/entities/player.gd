extends CharacterBody2D


var direction_x: float
@export var speed := 200
var is_shooting = true
@export var jump_strength :=400
@export var gravity := 1000

signal shoot(pos: Vector2, dir:Vector2)

const gun_directions = {
	Vector2i(1,0): 0,
	Vector2i(1,1): 1,
	Vector2i(0,1): 2,
	Vector2i(-1,1): 3,
	Vector2i(-1,0): 4,
	Vector2i(-1,-1): 5,
	Vector2i(0,-1): 6,
	Vector2i(1,-1): 7,
}

func get_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_strength		
	if Input.is_action_just_pressed("shoot") and $ReloadTimer.time_left == 0:
		shoot.emit(position, get_local_mouse_position().normalized())
		is_shooting = false
		$ReloadTimer.start()
		var tween = get_tree().create_tween()
		tween.tween_property($Marker, "scale", Vector2(0.1, 0.1), 0.2)
		tween.tween_property($Marker, "scale", Vector2(0.5, 0.5), 0.4)
				
		
func apply_gravity(delta):	
	velocity.y += gravity * delta	
	
func animation():	
	$Legs.flip_h = direction_x < 0		
	
	if is_on_floor():
		$AnimationPlayer.current_animation = "run" 	if direction_x else "idle"
	else:
		$AnimationPlayer.current_animation = "jump"
			
	var raw_dir = get_local_mouse_position().normalized()
	var adjusted_dir = Vector2i(round(raw_dir.x),round(raw_dir.y))	
	$Torso.frame = gun_directions[adjusted_dir]
	

func update_marker():
	$Marker.position = get_local_mouse_position().normalized() * 50
		
func _physics_process(delta: float) -> void:
	get_input()
	apply_gravity(delta)
	animation()
	update_marker()
	
#	moving
	if direction_x:
		velocity.x = direction_x * speed
#	not moving
	else:
		velocity.x = 0
		
	move_and_slide()
	
	
