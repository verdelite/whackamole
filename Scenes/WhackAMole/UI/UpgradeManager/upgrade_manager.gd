extends Node

@export var rhiana: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.new_upgrade.connect(_on_upgrade_unlocked)

func _on_upgrade_unlocked(upgrade: Globals.UpgradeType):
	match upgrade:
		Globals.UpgradeType.RHIANA_1:
			rhiana.active = true
			
		Globals.UpgradeType.RHIANA_2:
			rhiana.valid_targets.erase(Globals.MoleType.STANDARD)
			
		Globals.UpgradeType.RHIANA_3:
			rhiana.ATK_COOLDOWN = rhiana.ATK_COOLDOWN_UPGRADED
			
		Globals.UpgradeType.RHIANA_4:
			rhiana.valid_targets.append(Globals.MoleType.PEASANT)
