class_name Mate
extends State

@export var agent : Creature
@export var animator : AnimatedSprite2D
@export var navigation : NavigationAgent2D

var direction : Vector2

func enter() -> void:
	direction = agent.direction
	animate()
	
func update(delta: float) -> void:
	# Navigate to the mate
	direction = (navigation.get_next_path_position() - agent.global_position).normalized()
	agent.velocity = direction * agent.speed
	
	animate()
	agent.move_and_slide()
	
	# Mate no longer exists
	if !agent.target:
		agent.current_state = "idle"
		
	# Exit the state
	if agent.current_state != self.name.to_lower():
		emit_signal("state_transition", self, agent.current_state)
	
func leave() -> void:
	# Mating urge resets
	agent.mating_urge = 0
	print("Mating done")
	
	
func animate() -> void:
	# Animate the creature
	if direction.x > 0 and direction.y < 0:
		animator.play("run_ne")
		
	if direction.x < 0 and direction.y < 0:
		animator.play("run_nw")
		
	if direction.x > 0 and direction.y > 0:
		animator.play("run_se")
		
	if direction.x < 0 and direction.y > 0:
		animator.play("run_sw")

func makepath() -> void:
	# Create a path to the target
	if agent.target:
		navigation.target_position = agent.target.global_position

func _on_timer_timeout() -> void:
	makepath()
