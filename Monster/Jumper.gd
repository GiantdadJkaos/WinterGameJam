extends Area2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var MoveWait = 2
@export var SPEED = 100
@export var velocity = Vector2.ZERO
@export var health = 2
@onready var elf = $"../elf"
var place = Vector2.ZERO
var elfPlace  = Vector2.ZERO
var moving = Vector2.ZERO
var enter = false

@onready var moveTimer = $MoveAmmount
@onready var waitTimer = $WaitAmmount
@onready var startingPosition = position

var moveTime: float = 2
var waitTime: float = .5
var timeOut = true
var dead = false

func _ready():
	$HitDetection.health = health

func _process(delta):
	var direction = (elf.position - self.position).normalized()
	#if direction.x < 0:
		#velocity.x = -SPEED
	#elif direction.x > 0:
		#velocity.x = SPEED
	#else:
		#velocity.x = 0
	#if direction.y < 0:
		#velocity.y = -SPEED
	#elif direction.y > 0:
		#velocity.y = SPEED
	#else:
		#velocity.y = 0
	
	if enter and moveTimer.is_stopped() and waitTimer.is_stopped() and (not dead):
		moveTimer.start(moveTime)
		place = position
		elfPlace = elf.position
		moving = fromToVector(place.x, place.y, elfPlace.x, elfPlace.y)
		#print(elf.velocity)
		
	if not enter:
		moving.x = 0
		moving.y = 0
		
	position.x += moving.x /4
	position.y += moving.y /4


func _on_visible_on_screen_notifier_2d_screen_entered():
	$HitDetection.respawn()
	$AnimatedSprite2D.visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	$HitDetection/CollisionShape2D.set_deferred("disabled", false)
	#$Body/InvincibleBox.set_deferred("disabled", false)
	dead = false


func _on_hit_detection_hit():
	$Hit.play()


func _on_hit_detection_dead():
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$HitDetection/CollisionShape2D.set_deferred("disabled", true)
	position = startingPosition
	$Dead.play()
	print("dead")
	dead = true
	moving = Vector2.ZERO


func _on_character_detection_area_entered(area):
	enter = true


func _on_character_detection_area_exited(area):
	enter = false

func fromToVector(fromX, fromY, toX, toY):
	
	return Vector2(toX - fromX, toY - fromY).normalized()



func _on_move_ammount_timeout():
	moving = Vector2.ZERO
	waitTimer.start(waitTime)


func _on_wait_ammount_timeout():
	timeOut = false
