extends CharacterBody2D

class_name Drone

var direction: Vector2
var speed := 50
var player: CharacterBody2D
var health := 3

func _physics_process(_delta: float) -> void:
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		$AnimatedSprite2D.flip_h = dir.x > 0 
		move_and_slide()
		


		
func _on_detection_area_body_entered(player_body: CharacterBody2D) -> void:
	player = player_body


func _on_detection_area_body_exited(_bplayer_body: CharacterBody2D) -> void:
	player = null

func explode():
	speed = 0
	$AnimatedSprite2D.hide()
	$ExplosionSprite.show()
	$AnimationPlayer.play("explode")	
	
	await $AnimationPlayer.animation_finished
	
	queue_free()
	
func chain_reaction():
	for drone in get_tree().get_nodes_in_group('Drones') as Array[Drone]:
		var distance = position.distance_to(drone.position)
		if distance <= 50:
			drone.explode()			

func _on_collision_area_body_entered(_player_body: CharacterBody2D) -> void:
	explode()


func hit():
	health -= 1
	if health <=0:
		explode()
	
