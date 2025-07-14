extends Node

var rhiana: Node2D

var upgrade_tree_rhiana: Array[PackedScene] =  [
	preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container_rhiana_1.tscn"),
	preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container_rhiana_2.tscn"),
	preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container_rhiana_3.tscn"),
	preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container_rhiana_4.tscn"),
	]

var upgrade_tree_collateral: Array[PackedScene] = [
	preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container_collateral_1.tscn"),
	preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container_collateral_2.tscn"),
	preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container_collateral_3.tscn"),
]

var upgrade_tree_misc: Array[PackedScene] = [
	preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container_nala_1.tscn"),
	preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container_misc_2.tscn"),
	preload("res://Scenes/WhackAMole/UI/UpgradeContainer/upgrade_container_misc_3.tscn"),
]

var available_upgrades: Array[PackedScene] = []

var upgrade_tree_rhiana_index: int = 0
var upgrade_tree_collateral_index: int = 0
var upgrade_tree_misc_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.new_upgrade.connect(_on_upgrade_unlocked)
	
func get_upgrades() -> Array[PackedScene]:
	var alt_upgrades = upgrade_tree_misc.duplicate()
	var upgrade_a: PackedScene
	var upgrade_b: PackedScene
	var upgrade_c: PackedScene
	if upgrade_tree_rhiana_index >= 0:
		upgrade_a = upgrade_tree_rhiana[upgrade_tree_rhiana_index]
	else: 
		upgrade_a = alt_upgrades.pick_random()
		alt_upgrades.erase(upgrade_a)
		
	if upgrade_tree_collateral_index >= 0:
		upgrade_b = upgrade_tree_collateral[upgrade_tree_collateral_index]
	else:
		upgrade_b = alt_upgrades.pick_random()
		alt_upgrades.erase(upgrade_b)
		
	upgrade_c = alt_upgrades.pick_random()
	
	available_upgrades = [ 
		upgrade_a,
		upgrade_b,
		upgrade_c
	]
	
	print(str(upgrade_tree_rhiana_index))
	
	return available_upgrades

func _on_upgrade_unlocked(upgrade: Globals.UpgradeType):
	match upgrade:
		Globals.UpgradeType.RHIANA_1:
			rhiana.active = true
			update_array_rhiana()
		Globals.UpgradeType.RHIANA_2:
			rhiana.valid_targets.erase(Globals.MoleType.STANDARD)
			update_array_rhiana()
		Globals.UpgradeType.RHIANA_3:
			rhiana.ATK_COOLDOWN = rhiana.ATK_COOLDOWN_UPGRADED
			update_array_rhiana()
		Globals.UpgradeType.RHIANA_4:
			rhiana.valid_targets.append(Globals.MoleType.PEASANT)
			update_array_rhiana()
		Globals.UpgradeType.COLLATERAL_1:
			Globals.collateral_combo = 1
			upgrade_tree_collateral_index = 1
		Globals.UpgradeType.COLLATERAL_2:
			Globals.COLLATERAL_SCORE_INDEX = 1
			upgrade_tree_collateral_index = 2
		Globals.UpgradeType.COLLATERAL_3:
			Globals.COLLATERAL_SCORE_INDEX = 2
			upgrade_tree_collateral_index = -1
		_:
			print(str(Globals.UpgradeType)+' not implemented in UpgradeManager yet!')
			
func update_array_rhiana():
	upgrade_tree_rhiana.remove_at(upgrade_tree_rhiana_index)
	if upgrade_tree_rhiana.size() > 0:
		upgrade_tree_rhiana_index = randi_range(0, upgrade_tree_rhiana.size()-1)
	else:
		upgrade_tree_rhiana_index = -1
