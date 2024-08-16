extends CharacterBody2D

var weight = 0
var darkMax = -2
var lightMax = 2
var weightLock = 0.0

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
const jumpVelocity = -500.0
const jumpBufferTime = 0.2

const SPEED = 300.0
const maxSpeed = 1200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	PullData()

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
	weightLock -= delta
	if weightLock > 0:
		return 0
	
	if Input.is_action_pressed("Darken"):
		weight = max(darkMax, weight-1)
		weightLock = PlayerData.GetChangeSpeed()
		PlayerData.SetWeight(weight)
	elif Input.is_action_pressed("Lighten"):
		weight = min(lightMax, weight+1)
		weightLock = PlayerData.GetChangeSpeed()
		PlayerData.SetWeight(weight)
	
	PlayerData.SetWeight(weight)

func DashHandler(delta, direction):
	if !hasDashUpgrade: return 0
	
	dashTimer -= delta
	if dashTimer < 0.0: isDashing = false
	if is_on_wall(): isDashing = false
	
	if !isDashing and is_on_floor(): canDash = true
	
	if !canDash: return 0
	if !Input.is_action_just_pressed("Dash"): return 0
	
	# Determine Dash Speed Using LightDark Scale
	var dashSpeed = dashBaseSpeed * PlayerData.GetWeightModifier()
	dashSpeed = clampf(dashSpeed, dashMinSpeed, dashMaxSpeed)
	
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
		velocity.y += jumpVelocity * PlayerData.GetWeightModifier()
		jumpLock = true

func LeftRightHandler(delta, direction):
	if isDashing: return 0
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func UpgradeHandler(upgrade_type):
	PlayerData.UpgradeHandler(upgrade_type)
	PullData()

func PullData():
	self.hasDashUpgrade = PlayerData.HasDash()
	self.weight = PlayerData.GetWeight()
	self.darkMax = PlayerData.GetDarkMax()
	self.lightMax = PlayerData.GetLightMax()

func GetDashState():
	return self.isDashing
