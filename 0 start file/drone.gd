extends CharacterBody2D


const SPEED = 50.0

var target: Node2D = null
var direction: Vector2
var health = 3

func move_towards()->void:
	direction = (target.position - position).normalized()
	velocity = 	direction * SPEED
	move_and_slide()
	
func _ready() -> void:
	$AnimationPlayer.current_animation = 'fly'
	
func animation()->void:
	if direction:
		$Drone.flip_h = direction.x > 0
	
func explode()->void:
	$Drone.visible = false
	$Explosion.visible = true
	$AnimationPlayer.current_animation = 'explode'	
	$Timer.start()	

func _physics_process(_delta: float) -> void:
	animation()
	if target:
		move_towards()		
	

func _on_vision_radius_body_entered(body: Node2D) -> void:
	if (body.name == 'Player'):
		target = body
		
		


func _on_hitbox_radius_body_entered(body: Node2D) -> void:	
	if (body.name == 'Player'):
		explode()


func _on_timer_timeout() -> void:
	queue_free()
	return


func _on_hitbox_radius_area_entered(area: Area2D) -> void:
	if area is Bullet:
		health=health-1		
	if health == 0:
		explode()
		
		
		
		
		
		
		
