extends AudioStreamPlayer

@export var audio_hit: Array[AudioStream]
@export var audio_emerge: Array[AudioStream]
@export var audio_fled: Array[AudioStream]
@export var audio_attack: Array[AudioStream]
@export var audio_special: Array[AudioStream]

var do_not_interrupt: bool = false

func play_sound(sound_name: String):
	
	if do_not_interrupt and playing:
		return
	
	if sound_name == "hit" and audio_hit.size() > 0:
		set_stream(audio_hit.pick_random())
	elif sound_name == "emerge" and audio_emerge.size() > 0:
		set_stream(audio_emerge.pick_random())
	elif sound_name == "fled" and audio_fled.size() > 0:
		set_stream(audio_fled.pick_random())
	elif sound_name == "attack" and audio_attack.size() > 0:
		set_stream(audio_attack.pick_random())
		
	if sound_name == "special":
		do_not_interrupt = true
		set_stream(audio_special.pick_random())
	else:
		do_not_interrupt = false
		
	if get_stream(): 
		play()
		#print("Playing audio: " + sound_name)
		
	else:
		print("No audio found for sound_name: " + sound_name)
