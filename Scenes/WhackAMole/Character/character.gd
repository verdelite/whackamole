extends Node2D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_player_weapon: AudioStreamPlayer = $AudioStreamPlayerWeapon

var offset: Vector2 = Vector2(-50, -10)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func whack(target):
	position = target.position + offset
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("Whack")
	audio_player.play_sound("attack")
	
	var target_valid = target.is_valid_target()
	
	await get_tree().create_timer(0.2).timeout
	
	if target_valid:
		audio_player_weapon.play_sound("emerge")
	else:
		audio_player_weapon.play_sound("hit")


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.get_animation() == "Whack":
		$AnimatedSprite2D.play("Idle")

func combo_nine():
	audio_player.play_sound("special")
