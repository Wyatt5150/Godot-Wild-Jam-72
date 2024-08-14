extends CharacterBody2D


var darkLightScale = 0.0
var darkMax = -2.0
var lightMax = 2.0
const darkLightMaxUpgradeStrength = .2
const darkLightMaxBoundary = 6.0

var scaleSpeed = 1.0
const scaleSpeedUpgradeStrength = .1
const scaleSpeedMax = 2.0

var hasDashUpgrade = true
var isDashing = false
var canDash = false
var dashTimer = 0.0
const dashTime = 0.3
const dashBaseSpeed = 600.0
const dashMinSpeed = 300.0
const dashMaxSpeed = 1200.0

var timeOffFloor = 0.0
var jumpLock = false
var jumpBuffer = 0.0
const coyoteTime = 0.2
const jumpVelocity = -400.0
const jumpBufferTime = 0.2

const SPEED = 300.0

const maxSpeed = 1200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right")

	if not is_on_floor():
		velocity.y += gravity * delta
	
	LeftRightHandler(delta, direction)
	DarkLightHandler(delta)
	JumpHandler(delta)
	DashHandler(delta, direction)
	
	move_and_slide()
	

func DarkLightHandler(delta):
	if !is_on_floor(): return 0
	var dLock = false 
	var lLock = false
	
	if Input.is_action_pressed("Darken"):
		darkLightScale -= (scaleSpeed * delta)
		darkLightScale = max(darkMax, darkLightScale)
		dLock = true
	if Input.is_action_pressed("Lighten"):
		lLock = true
		darkLightScale += (scaleSpeed * delta)
		darkLightScale = min(lightMax, darkLightScale)
	
	if Input.is_action_just_released("Darken") and !lLock:
		darkLightScale = ceilf(darkLightScale)
	
	if Input.is_action_just_released("Lighten") and !dLock:
		darkLightScale = floorf(darkLightScale) 
	
	print(darkLightScale)

func DashHandler(delta, direction):
	if !hasDashUpgrade: return 0
	
	dashTimer -= delta
	if dashTimer < 0.0:
		isDashing = false
	
	if !isDashing and is_on_floor():
		canDash = true
	
	if !canDash: return 0
	if !Input.is_action_just_pressed("Dash"): return 0
	
	# Determine Dash Speed Using Cube Root Of LightDark Scale
	var dashSpeed = dashBaseSpeed * pow(1.2, darkLightScale)
	dashSpeed = clampf(dashSpeed, dashMinSpeed, dashMaxSpeed)
	
	print(dashSpeed)
	print(darkLightScale)
	
	#Apply Dash Speed
	velocity.x += (dashSpeed * direction)
	
	dashTimer = dashTime
	isDashing = true
	canDash = false

func JumpHandler(delta):
	jumpBuffer -= delta
	if is_on_floor():
		timeOffFloor = 0.0
		jumpLock = false
		if jumpBuffer > 0.0: Jump()
	else:
		timeOffFloor += delta
	
	if timeOffFloor > coyoteTime: jumpLock = true
	if !Input.is_action_just_pressed("Jump"): return 0
	
	if jumpLock: 
		jumpBuffer = jumpBufferTime
		return 0
	
	if timeOffFloor < coyoteTime:
		Jump()

func Jump():
	velocity.y += jumpVelocity
	jumpLock = true

func LeftRightHandler(delta, direction):
	if isDashing: return 0
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func UpgradeHandler(upgrade_type):
	match upgrade_type:
		"DarkMax":
			darkMax -= darkLightMaxUpgradeStrength
			darkMax = max(darkMax, darkLightMaxBoundary)
		"LightMax":
			lightMax += darkLightMaxUpgradeStrength
			lightMax = min(lightMax, darkLightMaxBoundary)
		"ScaleSpeed":
			scaleSpeed += scaleSpeedUpgradeStrength
			scaleSpeed = min(scaleSpeed, scaleSpeedMax)
		"Dash":
			hasDashUpgrade = true

# Dark < 0 < Light
func GetLightScale():
	return floor(self.darkLightScale)

func GetDashState():
	return self.isDashing
