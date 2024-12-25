extends Sprite2D

@onready var timer : Timer = $Timer
@onready var area_collision : CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	# Hide the grass initially
	visible = false
	area_collision.disabled = true
	
	# Randomized grow time
	timer.wait_time = randi_range(10, 20)


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Grass has now been eaten
	if body.is_in_group("prey"):
		visible = false
		area_collision.disabled = true
	
		# Randomize grow time
		timer.wait_time = randi_range(10, 20)
		 
		# Start the grow timer
		timer.start()


func _on_timer_timeout() -> void:
	# Grass has grown
	visible = true
	area_collision.disabled = false
