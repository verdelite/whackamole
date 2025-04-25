extends Node

enum Mole_Types {
	STANDARD,
	PEASANT,
	ELITE,
	BOSS
}

@export var SCORE_THRESHOLDS: Array[int] = [99, 99+3*99, 4*99+5*99, 9*99+7*99, 16*99+9*99, 25*99+11*99, 36*99+13*99, 49*99+15*99, 64*99+17*99, 9999]
#### Level 0: 99, Level 1: 396, Level 2: 891, Level 3: 1584, Level 4: 2475, Level 5: 3564, Level 6: 4851, Level 7: 6336, Level 8: 8019, Level 9: 101*99
## For most thresholds, the calculation equals (n^2)*99, although n=10 is the exception
## This calculation may be needed when implementing an Endless Mode


@export var CURRENT_LEVEL = 0
@export var CURRENT_THRESHOLD: int

func _ready():
	CURRENT_THRESHOLD = SCORE_THRESHOLDS[CURRENT_LEVEL]
	
func update_level():
	CURRENT_THRESHOLD = SCORE_THRESHOLDS[CURRENT_LEVEL]
	print("Threshold reached! New threshold: " + str(CURRENT_THRESHOLD) + "\nCurrent Level: " + str(CURRENT_LEVEL))
	##TODO: Level up actions
	
func check_threshold(new_score: int):
	if new_score >= CURRENT_THRESHOLD:
		CURRENT_LEVEL += 1
		update_level()
