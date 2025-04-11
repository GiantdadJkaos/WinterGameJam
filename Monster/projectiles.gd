extends Area2D

var Right = 1
var velocity = Vector2.ZERO
@export var SPEED = Vector2.ZERO

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x  = SPEED.x * Right
	velocity.y = SPEED.y
	
	rotation += 0.05 * Right
	
	position.x += SPEED.x * delta
	position.y += SPEED.y * delta


func _on_area_entered(area):
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
