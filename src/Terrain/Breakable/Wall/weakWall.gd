extends ColorRect

@export var wallStrength: int

# Called when the node enters the scene tree for the first time.
func _ready():
	$Terrain/CollisionShape2D.shape.size = size
	$Terrain.position.x = size.x/2
	$Terrain.position.y = size.y/2
	
	$Area2D/CollisionShape2D.shape.size.y = size.y
	$Area2D/CollisionShape2D.shape.size.x = size.x+70
	$Area2D.position.x = size.x/2
	$Area2D.position.y = size.y/2
	
	$Polygon2D.polygon[2].y = size.y
	$Polygon2D.polygon[3].y = size.y
	
	self_modulate.a = 0
	clip_children=0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func destroy():
	$Terrain.set_collision_mask_value(2,false)
	$Terrain/CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Polygon2D.modulate.a = 0
	
	# animation
	pass

func _on_area_2d_body_entered(body):
	if body.GetDashState() and body.GetLightScale() <= wallStrength:
		destroy()
	pass # Replace with function body.
