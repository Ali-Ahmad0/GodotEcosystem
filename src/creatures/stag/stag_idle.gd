class_name StagIdle
extends State

@export var agent : Stag
@export var animator : AnimatedSprite2D

var prev_direction

func enter() -> void:
	prev_direction = agent.direction
	animate()

func update(delta: float) -> void:
	if prev_direction != agent.direction:
		animate()
		prev_direction = agent.direction
		
	if agent.current_state == "wander":
		emit_signal("state_transition", self, "wander")
		
func animate() -> void:
	match agent.direction:
		agent.Direction.NE:
			animator.play("idle_ne")
			
		agent.Direction.NW:
			animator.play("idle_nw")
			
		agent.Direction.SE:
			animator.play("idle_se")
			
		agent.Direction.SW:
			animator.play("idle_sw")
