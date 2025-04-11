extends Node


func playSound(stream: AudioStream):
	var sound = AudioStreamPlayer.new()
	sound.stream = stream
	add_child(sound)
	sound.play()
	queue_free()
