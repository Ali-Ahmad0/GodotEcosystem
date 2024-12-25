extends Creature

var target : Node2D

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func _on_timer_timeout() -> void:
	if target is CharacterBody2D:
		super.create_path(target)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("prey"):
		target = body
