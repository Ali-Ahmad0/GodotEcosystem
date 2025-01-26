extends Area2D

var own_parent : Creature

@export var stats_debug : Control

@export var state_label : Label
@export var hunger_label : Label
@export var mating_label : Label

func _ready() -> void:
	own_parent = get_parent()
	stats_debug.hide()


func _process(delta: float) -> void:
	state_label.text = "Current State: " + own_parent.current_state
	hunger_label.text = "Hunger: " + str(own_parent.hunger)
	mating_label.text = "Mating %age: " + str(own_parent.mating_percentage) + "%"


func _on_body_entered(body: Node2D) -> void:
	var own_group = own_parent.get_groups()[0]
	
	# Stag has now been eaten
	if own_group == "prey" and body.is_in_group("predator"):
		if body.target == own_parent:
			body.current_state = "idle"
			body.target = null
			get_parent().queue_free()
	
	# Creature has found suitable mate
	if body.is_in_group(own_group) and body.current_state == "mate":
		if body != get_parent():
			# Reset own state and mating urge
			own_parent.current_state = "idle"
			own_parent.target = null
			own_parent.mating_percentage = 0
			
			# Reset other state and mating urge
			body.current_state = "idle"
			body.target = null
			body.mating_percentage = 0
			
			# Preload the creature scene for creating a new instance
			var creature_type : String = own_parent.get_groups()[0]
			var creature_scene : PackedScene
			if creature_type == "prey":
				creature_scene = load("res://scenes/creatures/stag.tscn")
			else:
				creature_scene = load("res://scenes/creatures/wolf.tscn")

			# Create an instance of offspring
			var offspring : Creature = creature_scene.instantiate()
			if offspring:
				# Spawn a new offspring at the position of parents
				offspring.global_position = own_parent.global_position + body.global_position 
				offspring.global_position /= 2
				
				own_parent.get_parent().add_child(offspring)
				
				# Pass parent genes onto the offspring with mutation
				var speed_mutation_factor : int = randi_range(-2, 2)
				var hunger_mutation_factor : int = randi_range(-4, 4)
				var vision_mutation_factor : int = randi_range(-8, 8)
				
				# Pass speed genes
				offspring.speed = pass_genes(
					own_parent.speed, 
					body.speed, 
					speed_mutation_factor
				)
				
				# Pass hunger genes
				offspring.max_hunger = pass_genes(
					own_parent.max_hunger, 
					body.max_hunger, 
					hunger_mutation_factor
				)
				offspring.hunger = offspring.max_hunger
				
				offspring.vision_collision.shape.radius = pass_genes(
					own_parent.vision_collision.shape.radius,
					body.vision_collision.shape.radius,
					vision_mutation_factor
				)


# Return combination of parents genes + mutation factor
func pass_genes(property1, property2, mutation_factor):
	var splitting_factor = randf()
	var result = property1 * splitting_factor + property2 * (1.0 - splitting_factor) + mutation_factor
	
	# Round result to 1 decimal place
	return round(result * 10) / 10.0 


func _on_mouse_entered() -> void:
	stats_debug.show()


func _on_mouse_exited() -> void:
	stats_debug.hide()
