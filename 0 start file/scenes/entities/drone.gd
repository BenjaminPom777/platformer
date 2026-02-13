extends CharacterBody2D

class_name Drone

var direction: Vector2
var speed := 50
var player: CharacterBody2D
var health := 3
var exploded := false

func _ready() -> void:
	$ExplosionSprite.hide()
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()

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
	if exploded:
		return
	exploded = true
	
	speed = 0
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.hide()
	$ExplosionSprite.show()
	$AnimationPlayer.play("explode")
	$AudioStreamPlayer2D.play()
	await $AnimationPlayer.animation_finished
	
	queue_free()
	
func chain_reaction():
	for drone in get_tree().get_nodes_in_group('Drones') as Array[Drone]:
		var distance = position.distance_to(drone.position)
		if distance <= 50 && drone != self:
			drone.explode()

func _on_collision_area_body_entered(_player_body: CharacterBody2D) -> void:
	explode()


func hit():
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D.material, 'shader_parameter/Progress', 0.1, 0.5)
	tween.tween_property($AnimatedSprite2D.material, 'shader_parameter/Progress', 1, 0.5)
	
	health -= 1
	if health <= 0:
		explode()
