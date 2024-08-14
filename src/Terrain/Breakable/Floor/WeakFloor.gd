extends ColorRect

@export var weightLimit: int
@export var respawnTime: float

var timer :Timer
var playerDetector : CollisionShape2D
var terrain : CollisionShape2D
var sprite
var player

var dying : bool
var respawning : bool
var shake:float

# Called when the node enters the scene tree for the first time.
func _ready():
	player = null
	# c = (weightLimit+maxDark)/(maxDark+maxLight)
	# modulate = Color(c,c,c)
	shake = 0
	size.x = max(size.x ,50)
	timer = $Timer
	sprite = $Polygon2D
	
	sprite.polygon[1].x = size.x
	sprite.polygon[2].x = size.x
	
	terrain = $Terrain/CollisionShape2D
	$Terrain/CollisionShape2D.shape.size.x = size.x
	$Terrain.position.x = size.x/2
	
	$Area2D/CollisionShape2D.shape.size.x = size.x
	$Area2D.position.x = size.x/2
	
	playerDetector = $PlayerDetector/CollisionShape2D
	$PlayerDetector/CollisionShape2D.shape.size.x = size.x-5
	$PlayerDetector.position.x = size.x/2
	
	self_modulate.a = 0
	set_clip_children_mode(CLIP_CHILDREN_DISABLED)
	pass # Replace with function body.

func _process(delta):
	if player != null:
		if player.GetLightScale()<=weightLimit:
			destroy()
		
	if respawning:
		sprite.modulate.a += 4*delta
		if sprite.modulate.a >=1:
			respawning = false
	elif dying:
		sprite.modulate.a -= 4*delta
		sprite.position.y += 400*delta;
		if sprite.modulate.a <=0:
			dying = false
	elif shake > 0:
		sprite.position.y += shake*delta*10
		if sprite.position.y >= shake:
			shake *= -1
	elif shake <0:
		sprite.position.y += shake*delta*10
		if sprite.position.y <= 0:
			sprite.position.y = 0
			shake = 0

# DESTROY STUFF
func destroy():
	respawning = false
	shake = 0
	sprite.position.y = 0
	terrain.set_deferred("disabled", true)
	playerDetector.set_deferred("disabled", true)
	dying = true
	timer.start(respawnTime)

func _on_player_detector_body_entered(body):
	player = body
	if body.GetLightScale()<=weightLimit:
		destroy()
	else:
		shake = max(6-body.GetLightScale()+weightLimit,1)
	pass # Replace with function body.

# RESPAWN STUFF
func respawn():
	sprite.position.y = 0;
	respawning = true
	shake = 0
	sprite.position.y = 0
	terrain.set_deferred("disabled", false)
	playerDetector.set_deferred("disabled", false)
	
func _on_timer_timeout():
	timer.stop()
	if !$Area2D.has_overlapping_bodies():
		respawn()
	pass # Replace with function body.

func _on_area_2d_body_exited(_body):
	if timer.is_stopped():
		respawn()
	pass # Replace with function body.


func _on_player_detector_body_exited(_body):
	player = null
	pass # Replace with function body.
