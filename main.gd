extends Node2D



func _on_button_pressed():
	get_tree().change_scene_to_file("world.tscn")


func _on_quit_pressed():
	get_tree().quit()
