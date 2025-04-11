extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var enemy = $Sprite2D
@onready var elf = $"../elf"
@export var BulletScene: PackedScene
@export var FireDelay: float = .3
@export var FireWait: float = .2
@export var JumpDelay: float = .2
@export var PresentSpeed = 200
@export var health = 3
@onready var FireDelayTimer = $FireDelay
@onready var FireWaitTimer = $FireDelay
@onready var JumpDelayTimer = $FireDelay
@onready var anim = $AnimatedSprite2D
var jump
var attack
var fire
var shots = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Health.health = health

func _physics_process(delta):
	var projectile = BulletScene.instantiate()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# and elf.posistion.y < position.y 
	if is_on_floor()and jump and JumpDelayTimer.is_stopped() and elf.position.y < position.y:
		JumpDelayTimer.start(JumpDelay)
		velocity.y = JUMP_VELOCITY
	
	if attack and fire and FireDelayTimer.is_stopped() and FireWaitTimer.is_stopped():
		FireDelayTimer.start(FireDelay)
		projectile.position = position
		projectile.SPEED.x = -PresentSpeed
		get_tree().current_scene.add_child(projectile)
		shots += 1
	if shots == 2:
		shots = 0
		FireWaitTimer.start(FireWait)
	
	if velocity.y < 0:
		anim.play("jump")
	else:
		anim.play("idle")
	
	move_and_slide()


func _on_health_dead():
	anim.visible = false
	#$CollissionBox.set_deferred("disabled", true)
	$Health/DamageBox.set_deferred("disabled", true)
	$Body/InvincibleBox.set_deferred("disabled", true)
	$CharacterDetection/Detector.set_deferred("disabled", true)
	$CharacterDetection2/Detector.set_deferred("disabled", true)
	$Dead.play()
	print("dead")

func _on_health_hit():
	$Hit.play()


func _on_body_hit_no_damage():
	$NoDamage.play()


func _on_visible_on_screen_notifier_2d_screen_entered():
	$Health.respawn()
	anim.visible = true
	#$CollissionBox.set_deferred("disabled", false)
	$Health/DamageBox.set_deferred("disabled", false)
	$Body/InvincibleBox.set_deferred("disabled", false)
	$CharacterDetection/Detector.set_deferred("disabled", false)
	$CharacterDetection2/Detector.set_deferred("disabled", false)
	attack = true

#Jumps with player
func _on_character_detection_area_entered(area):
	jump = true

#No longer jumps
func _on_character_detection_area_exited(area):
	jump = false

#Fires projectiles
func _on_character_detection_2_area_entered(area):
	fire = true

#Fires projectiles
func _on_character_detection_2_area_exited(area):
	fire = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	attack = false
