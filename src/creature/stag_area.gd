extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# Stag has now been eaten
	if body.is_in_group("predator"):
		body.current_state = "idle"
		body.target = null
		get_parent().queue_free()
	
	if body.is_in_group("prey") and body.current_state == "mate":
		if body != get_parent():
			body.current_state = "idle"
			body.target = null
