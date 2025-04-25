extends AudioStreamPlayer

@export var audio_combo: Array[AudioStream]
@export var audio_emerge: Array[AudioStream]
@export var audio_fled: Array[AudioStream]
@export var audio_attack: Array[AudioStream]
@export var audio_special: Array[AudioStream]

func play_sound(sound_name: String):
	if sound_name == "combo":
		set_stream(audio_combo.pick_random())
	elif sound_name == "emerge":
		set_stream(audio_emerge.pick_random())
	elif sound_name == "fled":
		set_stream(audio_fled.pick_random())
	elif sound_name == "attack":
		set_stream(audio_attack.pick_random())
	elif sound_name == "special":
		set_stream(audio_special.pick_random())
		
	if get_stream(): 
		play()
		print("Playing audio: " + sound_name)
		
	else:
		print("No audio found for sound_name: " + sound_name)
