extends Area2D

signal hole_clicked

var mole_spawned
@export var mole_types: Array[PackedScene] = []
@export var mole_weights: PackedFloat32Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.register(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		#print("I was clicked!")
		#$AnimatedSprite2D.visible = not $AnimatedSprite2D.visible
		hole_clicked.emit(self)
		
func whack():
	if mole_spawned:
		mole_spawned.whack()
	
	
func spawn_mole():
	if not mole_spawned:
		mole_spawned = mole_types[SceneManager.rng.rand_weighted(mole_weights)].instantiate()
		add_child(mole_spawned)
		
func is_valid_target() -> bool:
	return mole_spawned and not mole_spawned.untargetable
