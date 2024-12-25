extends Camera2D

@onready var color : ColorRect = $ColorRect
@onready var timer : Timer = $Timer

func _ready() -> void:
	color.color = Color.BLACK

func _process(delta: float) -> void:
	var direction : Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Movement
	if direction != Vector2.ZERO:
		move_camera(direction, delta)
	
	# Zoom
	if timer.time_left == 0:
		var scale_factor : int = 0
		
		if Input.is_action_just_pressed("ui_page_up"):
			scale_factor = 1
		if Input.is_action_just_pressed("ui_page_down"):
			scale_factor = -1
		
		if (scale_factor != 0):
			zoom_camera(scale_factor)
		
func move_camera(direction : Vector2, delta: float) -> void:
	position += direction * 100 * delta

func zoom_camera(scale_factor : int) -> void:
	zoom.x += scale_factor
	zoom.y += scale_factor
	
	timer.start()
