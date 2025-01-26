extends Node2D

@onready var stags_group : Node2D = $Stags
@onready var wolfs_group : Node2D = $Wolfs
@onready var debug_display : Control = $CanvasLayer/GlobalStats

var stag_scene : PackedScene
var wolf_scene : PackedScene

func _ready() -> void:
	stag_scene = preload("res://scenes/creatures/stag.tscn")
	wolf_scene = preload("res://scenes/creatures/wolf.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("q"):
		var stag : Creature = stag_scene.instantiate()
		stag.global_position = get_global_mouse_position()
		
		# Add a new stag to the environment
		stags_group.add_child(stag)
	
	if Input.is_action_just_pressed("e"):
		var wolf : Creature = wolf_scene.instantiate()
		wolf.global_position = get_global_mouse_position()
			
		# Add a new wolf to the environment
		wolfs_group.add_child(wolf)
	
	if Input.is_action_just_pressed("ui_cancel"):
		debug_display.visible = !debug_display.visible

	# Display overall fitness for the environment
	if Input.is_action_just_pressed("ui_accept"):
		print("Stag Fitness: " + str(fitness(stags_group)))
		print("Wolf Fitness: " + str(fitness(wolfs_group)))
	
	# Display some debug data for the world
	var stags_count : int = stags_group.get_child_count()
	var wolfs_count : int = wolfs_group.get_child_count()
	var total_count : int = stags_count + wolfs_count
	
	# Update text
	debug_display.get_child(0).text = "Total Count: " + str(total_count)
	debug_display.get_child(1).text = "Stags Count: " + str(stags_count)
	debug_display.get_child(2).text = "Wolves Count: " + str(wolfs_count)


# Fitness calculation function
func fitness(group : Node2D) -> float:
	var fitness_value : float = 0
	for creature : Creature in group.get_children():
		fitness_value += creature.speed + creature.max_hunger + creature.vision_collision.shape.radius
	
	return round(fitness_value / group.get_child_count())
