extends ColorRect

@export var weightLimit: int
@export var respawnTime: float

var timer :Timer
var playerDetector : CollisionShape2D
var terrain : CollisionShape2D
var sprite
var respawnCol : CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $Timer
	sprite = $Polygon2D
	
	sprite.polygon[1].x = size.x
	sprite.polygon[2].x = size.x
	
	terrain = $Terrain/CollisionShape2D
	$Terrain/CollisionShape2D.shape.size.x = size.x
	$Terrain.position.x = size.x/2
	
	
	playerDetector = $PlayerDetector/CollisionShape2D
	$PlayerDetector/CollisionShape2D.shape.size.x = size.x
	$PlayerDetector.position.x = size.x/2
	
	clip_children=1
	pass # Replace with function body.

func destroy():
	terrain.disabled = true
	playerDetector.disabled = true
	sprite.visible = false
	timer.start(respawnTime)
	
	# TODO: fling particles
	
func respawn():
	respawnCol.disabled = false
	terrain.disabled = false
	playerDetector.disabled = false
	sprite.visible = true
	
	# TODO: respawn animation
	
func _on_player_detector_body_entered(body):
	if body.GetLightScale()<=weightLimit:
		destroy()
	pass # Replace with function body.
	
func _on_timer_timeout():
	timer.stop()
	if !$Area2D.has_overlapping_bodies():
		respawn()
	else:
		respawnCol.disabled = true
	pass # Replace with function body.

func _on_area_2d_area_exited(area):
	respawn()
	pass # Replace with function body.
