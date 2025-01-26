class_name Idle
extends State

@export var agent : Creature
@export var animator : AnimatedSprite2D

func enter() -> void:
	animate()

func update(delta: float) -> void:
	animate()
	
	# Exit the state
	if agent.current_state != self.name.to_lower():
		emit_signal("state_transition", self, agent.current_state)
		
func animate() -> void:
	# Animate the creature
	match agent.direction:
		Direction.NE:
			animator.play("idle_ne")
			
		Direction.NW:
			animator.play("idle_nw")
			
		Direction.SE:
			animator.play("idle_se")
			
		Direction.SW:
			animator.play("idle_sw")
