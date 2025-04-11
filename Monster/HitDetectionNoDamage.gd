extends Area2D

signal hitNoDamage

func _on_area_entered(area):
	hitNoDamage.emit()
