extends CharacterBody2D

@export var speed: float = 100.0
@export var health: int = 3
@export var vision_range: float = 300.0

var target_body: Node2D = null
var active: bool = false
var exploded: bool = false

func _ready() -> void:
	$VisionArea.body_entered.connect(_on_vision_body_entered)
	$HitboxArea.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(delta: float) -> void:
	if exploded:
		return
		
	if active and target_body:
		var direction = position.direction_to(target_body.position)
		velocity = direction * speed
		move_and_slide()
		
		# Optional: Face the player
		if direction.x > 0:
			$Sprite2D.flip_h = false
		elif direction.x < 0:
			$Sprite2D.flip_h = true

func _on_vision_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		active = true
		target_body = body

func _on_hitbox_body_entered(body: Node2D) -> void:
	if exploded:
		return
		
	if body.name == "Player":
		explode()

func take_damage(amount: int) -> void:
	if exploded:
		return
		
	health -= amount
	if health <= 0:
		explode()

func explode() -> void:
	exploded = true
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	$HitboxArea/CollisionShape2D.set_deferred("disabled", true)
	
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	queue_free()
