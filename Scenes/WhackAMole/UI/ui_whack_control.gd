extends Control

@export var score_name: String = "Score"
@export var combo_name: String = "Combo"

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_combo: AnimationPlayer = %UIComboAnimationPlayer
@onready var animation_tree: AnimationTree = %UIAnimationTree
var animation_playback: AnimationNodeStateMachinePlayback


# Called when the node enters the scene tree for the first time.
func _ready():
	%ScoreLabel.text = score_name + ": "
	%ScoreCounter.text = "0"
	%ComboLabel.text = combo_name #+ ":"
	%ComboCounter.text = "0"
	animation_playback = animation_tree.get("parameters/playback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_score():
	%ScoreCounter.text = str(SceneManager.whack_a_mole.score)
	%ComboCounter.text = str(SceneManager.whack_a_mole.combo)
	Globals.check_threshold(SceneManager.whack_a_mole.score)
	
	if SceneManager.whack_a_mole.combo > 0:
		animation_playback.travel("counter_increase", true)
	
func show_combo_nine():
	%UIAnimationPlayer.play("nine_appears")
	audio_player.play_sound("combo")
