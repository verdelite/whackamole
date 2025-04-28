extends MarginContainer

@onready var animation_player: AnimationPlayer = %UIUpgradeAnimationPlayer
@onready var control_node: Control = %ListUpgradeContainers
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

@export var template_upgrade: PackedScene = preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container.tscn")

@export var audio_open: AudioStream
@export var audio_close: AudioStream

var spawned_upgrades: Array[Control] = []
var NUM_UPGRADES = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_upgrades()
	
	Globals.level_up.connect(show_menu)
	Globals.close_menu.connect(hide_menu)
	print("Upgrade screen ready and connected!")

func show_menu(new_level: int):
	print("Signal caught for level: " +str(new_level))
	audio_player.stream = audio_open
	await get_tree().create_timer(0.5).timeout
	audio_player.play()
	animation_player.play("open_upgrade_screen")
	
func hide_menu():
	audio_player.stream = audio_close
	audio_player.play()
	for upgrade in spawned_upgrades:
		upgrade.queue_free()
	animation_player.play("close_upgrade_screen")
	spawn_upgrades()
	
func spawn_upgrades():
	spawned_upgrades = []
	for i in NUM_UPGRADES:
		var new_upgrade = template_upgrade.instantiate()
		control_node.add_child(new_upgrade)
		spawned_upgrades.append(new_upgrade)

func show_upgrades():
	for upgrade in spawned_upgrades:
		print(str(upgrade))
		upgrade.open_upgrade_container()
		await get_tree().create_timer(0.2).timeout
		
