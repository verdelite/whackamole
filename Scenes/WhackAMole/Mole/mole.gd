extends Area2D

@export var speed_emerge: float = 2.0
@export var speed_hide: float = 2.0
@export var speed_wait: float = 3.0

@export var mole_type: Globals.MoleType = Globals.MoleType.STANDARD

@export var play_hit: bool = false

@export var score: int = 1

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var untargetable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	update_mole_speed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_mole_speed():
	animation_tree.set("parameters/Emerge/TimeScale/scale",speed_emerge)
	animation_tree.set("parameters/Hiding/TimeScale/scale", speed_hide)
	animation_tree.set("parameters/Waiting/TimeScale/scale", speed_wait)
	

#func _on_input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton and event.is_pressed():
		#print("Enemy was hit!")
		#mole_clicked.emit(self)
		#$Hitbox.disabled = true
		#$AnimationTree.active = false
		#whack()
		
func whack():
	if not untargetable:
		untargetable = true
		$Sprite2D/AnimatedSprite2D.visible = false
		SceneManager.mole_hit.emit(self)
		
		animation_tree["parameters/conditions/hit"] = true
		
		if play_hit:
			await get_tree().create_timer(0.25).timeout
			audio_player.play_sound("hit")
			
		#if audio_player.playing:
			await audio_player.finished
			
		queue_free()
	
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "Emerge":
		SceneManager.mole_emerged.emit(self)
		audio_player.play_sound("emerge")
		
	if anim_name == "Waiting":
		audio_player.play_sound("fled")
		pass
		
	if anim_name == "Hiding":
		SceneManager.mole_missed.emit(self)
		untargetable = true		
		
		#audio_player.play_sound("fled")
		if audio_player.playing:
			await audio_player.finished
			
		queue_free()
