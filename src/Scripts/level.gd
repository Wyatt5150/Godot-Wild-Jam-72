# ADD THIS NODE AS A CHILD OF ANY LEVEL
extends Node2D

@export var toScenes : Array[String]

@export var fromScenes : Array[String]

# objects connected to save data
var objects : Array
var nextScene
var timer
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(ToNextRoom)
	
	# load objects
	objects = $Objects.get_children()
	var saveData = SaveData.GetRoomSave(self)
	print(saveData)
	for i in objects.size():
		if !saveData[i]:
			objects[i].queue_free()
			
	# set up transitions
	nextScene = null
	var i = 0
	for area in $Transitions.get_children():
		area.set_collision_mask(1)
		area.set_collision_layer(0)
		area.body_entered.connect(EnteredTransition.bind(i))
		
		i+=1
	
	# spawn player
	var player = load("res://Scenes/player.tscn").instantiate()
	self.add_child(player)
	if PlayerData.curScene == null:
		i = 0
	else:
		i = fromScenes.find(PlayerData.curScene)
	player.position = $Spawns.get_child(i).position
	
	PlayerData.curScene = self.name.to_lower()
	
	# spawn camera
	camera = load("res://Scenes/camera.tscn").instantiate()
	self.add_child(camera)
	camera.player = player
	camera.position = player.position
	
	# start
	pass # Replace with function body.

func EnteredTransition(_player, ind):
	for i in objects.size():
		if objects[i] == null:
			SaveData.SetRoomData(self, i, false)
	nextScene = toScenes[ind]
	timer.start(.2)
	camera.blackoutTarget = 1
	# lock player controls
	pass

func ToNextRoom():
	get_tree().change_scene_to_file("res://Levels/"+nextScene+".tscn")
	pass
