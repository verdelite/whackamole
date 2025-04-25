extends MarginContainer

@onready var animation_player: AnimationPlayer = %UIUpgradeAnimationPlayer
@onready var control_node: Control = %ListUpgradeContainers

@export var template_upgrade: PackedScene = preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container.tscn")
var spawned_upgrades: Array[Control] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 3:
		var new_upgrade = template_upgrade.instantiate()
		control_node.add_child(new_upgrade)
		spawned_upgrades.append(new_upgrade)

	await get_tree().create_timer(0.5).timeout
	animation_player.play("open_upgrade_screen")

func show_upgrades():
	for upgrade in spawned_upgrades:
		print(str(upgrade))
		upgrade.open_upgrade_container()
		await get_tree().create_timer(0.2).timeout
