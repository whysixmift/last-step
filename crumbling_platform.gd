extends StaticBody2D

@export var crumble_delay: float = 0.65
@export var respawn_delay: float = 2.0

var triggered := false
var original_position: Vector2

@onready var visual: Polygon2D = $Polygon2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	original_position = position
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if triggered or not body is CharacterBody2D:
		return
		
		
	triggered = true
	crumble()
	
func crumble () -> void:
	await get_tree().create_timer(crumble_delay).timeout
	
	collision.set_deferred("disabled", true)
	visual.color = Color("#ff4040")

	var tween := create_tween()
	tween.tween_property(self, "position:y", position.y + 500.0, 0.8)
	await tween.finished

	await get_tree().create_timer(respawn_delay).timeout

	position = original_position
	visual.color = Color.WHITE
	collision.set_deferred("disabled", false)
	triggered = false
