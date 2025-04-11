extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
signal death

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var gravityReset = gravity
var maxGravity = 400

@export var Present_scene: PackedScene
@export var FireDelay: float = .1
@export var PresentSpeed = 450
@onready var anim = $AnimatedSprite2D
@onready var FireDelayTimer = $FireDelay
@onready var HitDelay = $HitDelay
@onready var InvincibilityTimer = $Invinicibility
@onready var HitBoxCollision = $HitBox/HitBoxCollision
@onready var RespawnDelay = $RespawnDelay


@export var health: float = 10
@export var hitDuration: float = 1
@export var InvincibilityDuration: float = 3
@export var presentPosistion = Vector2.ZERO
@export var respawnTime: float = 1
var screen_size

var lastPosition = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	print(screen_size)

func _physics_process(delta):
	var Present = Present_scene.instantiate()
	Present.SPEED.x = PresentSpeed
	# Add the gravity.
	if not is_on_floor() and velocity.y < maxGravity:
		velocity.y += gravity * delta
	elif is_on_floor():
		lastPosition = position
		gravity = gravityReset
		


	if position.y > 150 and RespawnDelay.is_stopped():
		RespawnDelay.start(respawnTime)
		$Fall.play()
	
	if InvincibilityTimer.is_stopped():
		anim.modulate = Color(1, 1, 1, 1)
	
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Jump.play()
	if Input.is_action_just_released("ui_accept") and HitDelay.is_stopped():
		gravity = gravityReset * 2
	
	if Input.is_action_pressed("ui_up") and FireDelayTimer.is_stopped():
		FireDelayTimer.start(FireDelay)
		Present.position.x = position.x
		Present.position.y = position.y + 7
		get_tree().current_scene.add_child(Present)
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and HitDelay.is_stopped():
		velocity.x = direction * SPEED
	elif HitDelay.is_stopped():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.y > 0:
		anim.play("fall")
	elif velocity.y < 0:
		anim.play("jump")
	elif is_on_floor() and Input.is_action_pressed("ui_left"):
		anim.flip_h = true
		anim.play("run")
	elif  is_on_floor() and Input.is_action_pressed("ui_right"):
		anim.flip_h = false
		anim.play("run")
	else:
		anim.play("idle")
		
	if anim.flip_h:
		Present.Right = -1
	
	move_and_slide()


func _on_hit_box_area_entered(area):
	if HitDelay.is_stopped() and health > 0:
		HitDelay.start(hitDuration)
		velocity.y = JUMP_VELOCITY / 2
		gravity = gravityReset
		if anim.flip_h:
			velocity.x = SPEED / 2
		else:
			velocity.x = -SPEED / 2
		
		
	if InvincibilityTimer.is_stopped():
		hurt(1)
		
	
	if health == 0:
		print('dead')
		$GameOver.play()
		death.emit()
		


func hurt(damage):
	InvincibilityTimer.start(InvincibilityDuration)
	health -= damage
	print("hit")
	$Hit.play()
	anim.modulate = Color(1, 1, 1, 0.6)


func _on_respawn_delay_timeout():
	velocity.x = 0
	velocity.y = 0
	position = lastPosition
	hurt(1)


func _on_game_over_finished():
	death.emit()
