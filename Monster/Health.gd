extends Area2D

@export var health = 3
@onready var startingHealth = health
signal dead
signal hit

func _on_area_entered(area):
	health -= 1
	print("hit")
	hit.emit()
	if health == 0:
		dead.emit()

func respawn():
	health = startingHealth
	
