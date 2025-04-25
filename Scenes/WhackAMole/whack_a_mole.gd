extends Node2D

# Player Management
@export var character: Node2D
@export var atk_cooldown_time: float = 0.15
@export var atk_delay: float = 0.1

var can_attack: bool = true
var atk_cooldown: float = 0

# Ally Management
@onready var ally_rhiana: Node2D = %AllyRhiana

# Hole Management
@export var template_hole: PackedScene = preload("res://Scenes/WhackAMole/Hole/hole.tscn")
@export var hole_rows: int = 4
@export var hole_cols: int = 5

var hole_list: Array[Node2D] = []
var start_position: Vector2 = Vector2(240, 140)
var hole_distance: Vector2 = Vector2(200, 150)

# Mole Management
var spawn_speed: float = 1.0
var spawn_time: float = 5.0
var spawn_interval: Array[float] = [0.0, 2.0]

# Score Management
var score: int = 0
var combo_bonus: int = 1
var combo: int = 0
var hit_count_total: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().set_physics_object_picking_first_only(true)
	
	for i in hole_cols:
		for j in hole_rows:
			var new_hole = template_hole.instantiate()
			hole_list.append(new_hole)
			hole_list[-1].global_position = Vector2(i * hole_distance.x, j * hole_distance.y) + start_position
			add_child(new_hole)
			#print("instantiating new hole at " + str(hole_list[-1].position))
			
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if spawn_time > 0:
		spawn_time -= delta
		if spawn_time <= 0:
			spawn_mole()
	
	if atk_cooldown > 0:
		atk_cooldown -= delta
		if atk_cooldown <= 0:
			print("Attack is ready!")

			
func spawn_mole():
	#print("Spawning Mole from WhackAMole...")
	var target = hole_list.pick_random()
	target.spawn_mole()
	spawn_time = SceneManager.rng.randf_range(spawn_interval[0], spawn_interval[1]) / spawn_speed
	#print("New Spawn time: " + str(spawn_time))


func _on_target_clicked(emitter):
	# TODO: Maybe merge with hole_clicked? Also, delays and timing needs to be rethought
	# Move player behavior into character.gd, perhaps by separating this into multiple functions with emitting signals
	if not can_attack or atk_cooldown > 0: 
		print("can_attack: " + str(can_attack) + " Cooldown: " + str(atk_cooldown))
		return
	
	hit_count_total += 1	
	can_attack = false
	character.whack(emitter)
	await get_tree().create_timer(atk_delay).timeout

	emitter.whack()
	
	can_attack = true
	atk_cooldown = atk_cooldown_time
	
func mole_hit(mole):
	if mole.score > 0:
		combo += 1
		score += mole.score * (1 + (combo / 9))
		
		if combo % 9 == 0:
			SceneManager.combo_nine.emit()
		
	else:
		combo = 0
		score += mole.score
		
func mole_emerged(mole):
	if ally_rhiana:
		ally_rhiana.target_mole(mole)
