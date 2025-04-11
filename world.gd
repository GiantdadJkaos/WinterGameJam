extends Node2D


func _on_sea_intro_finished():
	$Music/SeaLoop.play()


func _on_elf_death():
	get_tree().change_scene_to_file("world.tscn")


func _on_end_goal_body_entered(body):
	get_tree().change_scene_to_file("ending.tscn")
