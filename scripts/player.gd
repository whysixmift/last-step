
extends CharacterBody2D

@export var speed: float = 320.0
@export var jump_velocity: float = -480.0
@export var gravity: float = 1200.0

@export var death_y: float = 900.0
@export var respawn_delay: float = 0.5

var is_dead: bool = false
var spawn_position: Vector2

func _ready() -> void:
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	var direction: float = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()

	if global_position.y > death_y:
		die()

func die() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	tween.tween_property(self, "modulate:a", 1.0, 0.1)
	tween.set_loops(3)

	await get_tree().create_timer(respawn_delay).timeout

	global_position = spawn_position
	velocity = Vector2.ZERO
	modulate.a = 1.0
	is_dead = false
