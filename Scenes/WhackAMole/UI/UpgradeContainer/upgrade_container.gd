extends PanelContainer

var _hovered: bool = false
var SCALE_FACTOR: Vector2 = Vector2(1.1, 1.1)
var SCALE_DURATION: float = 0.25

var SHADOW_COLOR: Color = Color(0.133, 0.035, 0.173, 0.529)
var HIGHLIGHT_COLOR: Color = Color(1.0, 0.37, 0.811, 0.529)

@export var tween_stylebox: StyleBoxFlat

@export var upgrade_type: Globals.UpgradeType = Globals.UpgradeType.RHIANA_1

@export var upgrade_title: String = "Upgrade Name"
@export var upgrade_image: Texture2D
@export var upgrade_flavor: String = "Das wohl!"
@export var upgrade_description: String = "Hier könnte Ihre Beschreibung stehen!"

@export var sound_hover: AudioStream
@export var sound_select: AudioStream
@export var sound_chosen: AudioStream

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var upgrade_disabled = false

var ORIGINAL_POSITION: Vector2
var TWEEN_OFFSET: Vector2 = Vector2(0.0, 600)

func _ready():
	pivot_offset = get_rect().size/2.0
	tween_stylebox = get_theme_stylebox('panel').duplicate()
	add_theme_stylebox_override("panel", tween_stylebox)
	
	%UpgradeName.text = upgrade_title
	%UpgradeImage.texture = upgrade_image
	%UpgradeFlavorText.text = upgrade_flavor
	%UpgradeDescription.text = '[font_size=21][center][color="lightsalmon"]' + upgrade_description + '[/color][/center][/font_size]'

	Globals.all_upgrades.append(upgrade_type)
	Globals.new_upgrade.connect(close_upgrade_container)

	initialize_container()
	

func _on_mouse_entered():
	if position != ORIGINAL_POSITION or upgrade_disabled:
		return
	_hovered = true
	var tween = Globals.new_tween()
	tween.tween_property(self, "scale", SCALE_FACTOR, SCALE_DURATION)
	tween.tween_property(tween_stylebox, "shadow_color", HIGHLIGHT_COLOR, SCALE_DURATION)
	audio_player.stream = sound_hover
	audio_player.play()
	
func _on_mouse_exited():
	if animation_player.current_animation == "select_animation" or upgrade_disabled:
		return
	_hovered = false
	var tween = Globals.new_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), SCALE_DURATION)
	tween.tween_property(tween_stylebox, "shadow_color", SHADOW_COLOR, SCALE_DURATION)

func _on_select_button_pressed():
	upgrade_disabled = true
	Globals.unlock_upgrade(upgrade_type)
	audio_player.stream = sound_select
	audio_player.play()
	#close_upgrade_container()
	select_upgrade_container()

func close_upgrade_container(upgrade: Globals.UpgradeType):
	#print("Caught new_upgrade signal and called close_upgrade_container")
	upgrade_disabled = true
	#if(upgrade_type != upgrade):
	await get_tree().create_timer(0.1).timeout
	if animation_player.current_animation != "select_animation":
		animation_player.play("close_animation")
		tween_close_animation()
	
func select_upgrade_container():
	animation_player.play("select_animation")
	tween_select_animation()
	
func open_upgrade_container():
	animation_player.play("open_animation")
	tween_open_animation()
	
func tween_close_animation():
	var tween = Globals.new_tween()
	tween.tween_property(self, "position", ORIGINAL_POSITION + TWEEN_OFFSET, SCALE_DURATION*3)

func tween_open_animation():
	var tween = Globals.new_tween()
	tween.tween_property(self, "position", ORIGINAL_POSITION, SCALE_DURATION*1.5)

func tween_select_animation():
	#await get_tree().create_timer(0.5).timeout
	update_pivot_point()
	var tween = Globals.new_tween()
	tween.tween_property(self, "global_position", get_viewport_rect().size / 2 - update_pivot_point(), SCALE_DURATION*1.5)
	Globals.unlock_upgrade(upgrade_type)
	await get_tree().create_timer(SCALE_DURATION*2).timeout
	audio_player.stream = sound_chosen
	audio_player.play()
	
func update_pivot_point() -> Vector2:
	pivot_offset = get_rect().size/2.0
	return pivot_offset

func initialize_container():
	await get_tree().create_timer(0.1).timeout
	ORIGINAL_POSITION = get_rect().position
	
	await get_tree().create_timer(0.1).timeout
	position = ORIGINAL_POSITION + TWEEN_OFFSET / 4
	
func _on_animation_player_animation_finished(anim_name):
	print("Animation finished: " + anim_name)
	if anim_name == "select_animation":
		#print("Queue free called for: " + anim_name)
		Globals.close_menu.emit()
		
