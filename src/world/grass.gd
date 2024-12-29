extends Sprite2D

@onready var target_collision : CollisionShape2D = $Area2D/CollisionShape2D
@onready var timer : Timer = $Timer
@onready var animation : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Set wait time
	timer.wait_time = randi_range(10, 20)
	timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Grass has now been eaten
	if body.is_in_group("prey"):
		animation.play_backwards("grow")
		timer.start()
		
		body.current_state = "idle"
		body.target = null

func _on_timer_timeout() -> void:
	animation.play("grow")
