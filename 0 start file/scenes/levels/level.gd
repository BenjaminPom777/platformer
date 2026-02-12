extends Node2D
var bullet_scene = preload("res://scenes/bullets/bullet.tscn")

func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as Bullet
	$Bullets.add_child(bullet)
	bullet.setup(pos, dir)

func _ready() -> void:
	var light_tween = create_tween()
	light_tween.set_loops()
	light_tween.tween_property($PointLight2D4,'energy', 1.5, 0.5)
	light_tween.tween_property($PointLight2D4,'energy', 0.5, 0.5)
