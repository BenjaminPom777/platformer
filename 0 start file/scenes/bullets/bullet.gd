extends Area2D

class_name Bullet

@export var speed: float = 200.0
var direction: Vector2 
		
func setup(pos: Vector2, dir: Vector2):

	position = pos + dir * 16
	direction = dir
	rotation = direction.angle()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
		queue_free()

func _physics_process(delta: float) -> void:
		position += direction * speed * delta
		
		
		
