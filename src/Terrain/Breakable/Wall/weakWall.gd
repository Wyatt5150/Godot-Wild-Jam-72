extends ColorRect

@export var wallStrength: int
var player
var hitboxActive : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	player = null
	hitboxActive = true
	$Terrain/CollisionShape2D.shape.size = size
	$Terrain.position.x = size.x/2
	$Terrain.position.y = size.y/2
	
	$Destroy/CollisionShape2D.shape.size.y = size.y
	$Destroy/CollisionShape2D.shape.size.x = size.x
	$Destroy.position.x = size.x/2
	$Destroy.position.y = size.y/2
	
	$PlayerNearby/CollisionShape2D.shape.size.y = size.y + 100
	$PlayerNearby/CollisionShape2D.shape.size.x = size.x + 100
	$PlayerNearby.position.x = size.x/2
	$PlayerNearby.position.y = size.y/2
	
	$Polygon2D.polygon[2].y = size.y
	$Polygon2D.polygon[3].y = size.y
	
	self_modulate.a = 0
	clip_children=0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		if hitboxActive != (!player.GetDashState() or player.GetLightScale() > wallStrength):
			hitboxActive = !hitboxActive
			$Terrain/CollisionShape2D.set_deferred("disabled", !hitboxActive)
			$Destroy/CollisionShape2D.set_deferred("disabled", hitboxActive)
		pass
	pass

func destroy():
	$Terrain.set_collision_mask_value(2,false)
	$Terrain/CollisionShape2D.set_deferred("disabled", true)
	$PlayerNearby/CollisionShape2D.set_deferred("disabled", true)
	$Polygon2D.modulate.a = 0
	
	# animation
	pass

func _on_destroy_body_entered(body):
	if body.GetDashState() and body.GetLightScale() <= wallStrength:
		destroy()
	pass # Replace with function body.


func _on_player_nearby_body_entered(body):
	player = body


func _on_player_nearby_body_exited(body):
	player = null
