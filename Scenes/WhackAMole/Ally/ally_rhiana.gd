extends Node2D

@export var ATK_COOLDOWN: float = 5.0
var current_cooldown: float = 0.0

@export var active: bool = false

@onready var rhiana_sprite = $AllyAnimatedSprite2D
@onready var animation_tree = $AnimationTree

@export var valid_targets: Array[Globals.MoleType] = [Globals.MoleType.STANDARD, Globals.MoleType.ELITE]

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.new_upgrade.connect(_on_upgrade_unlocked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not active:
		return
	
	if current_cooldown > 0:
		current_cooldown -= delta
	
	else:
		animation_tree.set("parameters/conditions/active", true)
	
func target_mole(mole):
	if active and check_target_validity(mole) and current_cooldown <= 0:
		mole.whack()
		print("Rhina shot the target!")
		current_cooldown = ATK_COOLDOWN
		animation_tree.get("parameters/playback").travel("Shooting", true)
		animation_tree.set("parameters/conditions/active", false)
	
	
func check_target_validity(mole) -> bool:
	return valid_targets.has(mole.mole_type)

func _on_upgrade_unlocked(upgrade: Globals.UpgradeType):
	match upgrade:
		Globals.UpgradeType.RHIANA_1:
			active = true
