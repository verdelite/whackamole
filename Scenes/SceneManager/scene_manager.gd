extends Node2D
#### This class serves as a signal bus

var whack_a_mole: Node2D
var ui_whack: Control
var character: Node2D

var rng: RandomNumberGenerator

signal mole_emerged
signal mole_hit
signal mole_missed
signal combo_nine

# Called when the node enters the scene tree for the first time.
func _ready():
	
	rng = RandomNumberGenerator.new()
	
	whack_a_mole = get_tree().get_root().get_node("WhackAMole")
	ui_whack = get_tree().get_root().get_node("WhackAMole/CanvasLayer/UIWhack")
	character = get_tree().get_root().get_node("WhackAMole/Character")
	
	mole_emerged.connect(_on_mole_emerged)
	mole_hit.connect(_on_mole_hit)
	mole_missed.connect(_on_mole_missed)
	combo_nine.connect(_on_combo_nine)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

			
func register(emitter):
	emitter.hole_clicked.connect(_on_target_clicked)
	
func _on_target_clicked(emitter):
	whack_a_mole._on_target_clicked(emitter)
	
func _on_mole_emerged(mole):
	whack_a_mole.mole_emerged(mole)

func _on_mole_hit(mole):
	whack_a_mole.mole_hit(mole)
	ui_whack.update_score()

func _on_mole_missed(mole):
	if mole.score > 0:
		whack_a_mole.combo = 0
		ui_whack.update_score()
		
func _on_combo_nine():
	ui_whack.show_combo_nine()
	await get_tree().create_timer(0.1).timeout
	character.combo_nine()
