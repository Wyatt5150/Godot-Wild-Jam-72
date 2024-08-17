extends ColorRect

@export var wallStrength: int
@export var oneWay: bool
var player
var hitboxActive : bool
var destroyed :bool
var dir

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = PlayerData.GetColor(wallStrength)
	dir = 1
	destroyed = false
	player = null
	hitboxActive = true
	$Terrain/CollisionShape2D.shape.size = size
	$Terrain.position.x = size.x/2
	$Terrain.position.y = size.y/2
	
	$Destroy/CollisionShape2D.shape.size.y = size.y
	$Destroy/CollisionShape2D.shape.size.x = size.x
	$Destroy.position.x = size.x/2
	$Destroy.position.y = size.y/2
	
	if oneWay:
		$PlayerNearby/CollisionShape2D.shape.size.x = 80
		$PlayerNearby.position.x = -10
	else:
		$PlayerNearby/CollisionShape2D.shape.size.x = size.x + 100
		$PlayerNearby.position.x = size.x/2
	$PlayerNearby/CollisionShape2D.shape.size.y = size.y + 100
	$PlayerNearby.position.y = size.y/2
	
	if !oneWay:
		$Polygon2D.texture = load("res://Terrain/Breakable/Wall/weakWall.png")
		$Polygon2D.polygon[1].x = size.x
		$Polygon2D.polygon[2].x = size.x
	$Polygon2D.polygon[2].y = size.y
	$Polygon2D.polygon[3].y = size.y
	
	if oneWay:
		color = Color.WHITE
		if rotation != 0:
			position.x -= 50
		else:
			position.x += 50
		size.x -= 50
		for child in get_children():
			child.position.x-= 50
	else:
		self_modulate.a = 0
	set_clip_children_mode(CLIP_CHILDREN_DISABLED)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		if hitboxActive != (!player.GetDashState() or PlayerData.GetWeight() > wallStrength):
			hitboxActive = !hitboxActive
			$Terrain/CollisionShape2D.set_deferred("disabled", !hitboxActive)
			$Destroy/CollisionShape2D.set_deferred("disabled", hitboxActive)
		pass
	if destroyed:
		modulate.a -= 10*delta
		if modulate.a <= 0:
			queue_free()
		position.x += dir*200*delta
	pass

func destroy():
	if player.position.x>position.x:
		dir =-1
	destroyed = true
	player = null
	$Terrain/CollisionShape2D.set_deferred("disabled", true)
	$PlayerNearby/CollisionShape2D.set_deferred("disabled", true)
	$Destroy/CollisionShape2D.set_deferred("disabled", true)
	Audio.PlaySFX(Audio.SFX_TRACKS.ROCKFALL)

func _on_destroy_body_entered(body):
	if body.GetDashState() and PlayerData.GetWeight() <= wallStrength:
		destroy()
	pass # Replace with function body.


func _on_player_nearby_body_entered(body):
	player = body


func _on_player_nearby_body_exited(_body):
	if destroyed:
		return
	$Terrain/CollisionShape2D.set_deferred("disabled", false)
	player = null
