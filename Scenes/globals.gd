extends Node

enum MoleType {
	STANDARD,
	PEASANT,
	ELITE,
	BOSS
}

enum UpgradeType {
	RHIANA_1,
	RHIANA_2,
	RHIANA_3,
	RHIANA_4,
	COLLATERAL_1,
	COLLATERAL_2,
	COLLATERAL_3,
	NALA_1,
	LISELOTTE_1,
	LU_1
}

var all_upgrades: Array[UpgradeType] = []
var upgrades_unlocked: Array[UpgradeType] = []

signal new_upgrade
signal close_menu
signal level_up

@export var SCORE_THRESHOLDS: Array[int] = [1, 15, 30, 60, 90, 120, 150, 180, 49*99+15*99, 64*99+17*99, 9999]
#### Level 0: 99, Level 1: 396, Level 2: 891, Level 3: 1584, Level 4: 2475, Level 5: 3564, Level 6: 4851, Level 7: 6336, Level 8: 8019, Level 9: 101*99
## For most thresholds, the calculation equals (n^2)*99, although n=10 is the exception
## This calculation may be needed when implementing an Endless Mode
## [1, 3, 99+3*99, 4*99+5*99, 9*99+7*99, 16*99+9*99, 25*99+11*99, 36*99+13*99, 49*99+15*99, 64*99+17*99, 9999]

@export var CURRENT_LEVEL = 0
@export var CURRENT_THRESHOLD: int

var collateral_combo: int = 0

var COLLATERAL_SCORE_LIST: Array [int] = [ 1, 0, -1 ] # Will be multiplied with score if score is negative
var COLLATERAL_SCORE_INDEX: int = 0 

var tween: Tween

func _ready():
	CURRENT_THRESHOLD = SCORE_THRESHOLDS[CURRENT_LEVEL]
	close_menu.connect(close_upgrade_menu)
	
func get_collateral_multiplier() -> int:
	return COLLATERAL_SCORE_LIST[COLLATERAL_SCORE_INDEX]
	
func update_level():
	CURRENT_THRESHOLD = SCORE_THRESHOLDS[CURRENT_LEVEL]
	print("Threshold reached! New threshold: " + str(CURRENT_THRESHOLD) + "\nCurrent Level: " + str(CURRENT_LEVEL))
	
func new_tween():
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	return tween
	
func check_threshold(new_score: int):
	if new_score >= CURRENT_THRESHOLD:
		CURRENT_LEVEL += 1
		update_level()
		level_up.emit(CURRENT_LEVEL)
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = true

func unlock_upgrade(upgrade: UpgradeType):
	upgrades_unlocked.append(UpgradeType)
	new_upgrade.emit(upgrade)
	
func check_upgrade(upgrade: UpgradeType) -> bool:
	return upgrades_unlocked.has(UpgradeType)
	
func close_upgrade_menu():
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
