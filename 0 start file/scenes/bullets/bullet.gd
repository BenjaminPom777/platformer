extends Area2D

class_name Bullet

@export var speed: float = 200.0
var direction: Vector2 
		
func setup(pos: Vector2, dir: Vector2):

	position = pos + dir * 16
	direction = dir
	rotation = direction.angle()
	
	
func _physics_process(delta: float) -> void:
		position += direction * speed * delta
