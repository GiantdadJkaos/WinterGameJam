extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var enemy = $Sprite2D
@onready var elf = $"../elf"
@export var BulletScene: PackedScene
@onready var FireDelayTimer = $FireDelay
@export var FireDelay: float = .1
@export var bulletSpeed = 100
@export var health = 10

var attack = false
var place = Vector2.ZERO
var elfPlace = Vector2.ZERO
var moving = Vector2.ZERO


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Health.health = health
	
func _physics_process(delta):
	var projectile = BulletScene.instantiate()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if attack and FireDelayTimer.is_stopped():
		FireDelayTimer.start(FireDelay)
		place = position
		elfPlace = elf.position
		moving = fromToVector(place.x, place.y, elfPlace.x, elfPlace.y)
		projectile.position = position
		projectile.SPEED.x = moving.x * bulletSpeed
		projectile.SPEED.y = moving.y * bulletSpeed
		get_tree().current_scene.add_child(projectile)
		
		
	move_and_slide()


func _on_health_dead():
	$Sprite2D.visible = false
	#$CollissionBox.set_deferred("disabled", true)
	$Health/DamageBox.set_deferred("disabled", true)
	$Body/InvincibleBox.set_deferred("disabled", true)
	$CharacterDetection/Detector.set_deferred("disabled", true)
	$Dead.play()
	print("dead")

func _on_health_hit():
	$Hit.play()


func _on_body_hit_no_damage():
	$NoDamage.play()


func _on_visible_on_screen_notifier_2d_screen_entered():
	$Health.respawn()
	$Sprite2D.visible = true
	#$CollissionBox.set_deferred("disabled", false)
	$Health/DamageBox.set_deferred("disabled", false)
	$Body/InvincibleBox.set_deferred("disabled", false)
	$CharacterDetection/Detector.set_deferred("disabled", false)


func _on_character_detection_area_entered(area):
	attack = true


func _on_character_detection_area_exited(area):
	attack = false
	
func fromToVector(fromX, fromY, toX, toY):
	
	return Vector2(toX - fromX, toY - fromY).normalized()
