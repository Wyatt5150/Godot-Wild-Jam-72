# ADD THIS NODE AS A CHILD OF ANY LEVEL
extends Node2D

# key: area2d, value: next scene
@export var transitions : Dictionary

# key: prev scene, value: node at spawn location
@export var spawns : Dictionary	= {"default": null}

# objects connected to save data
@export var objects : Array	

var nextScene
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	# load objects
	var saveData = SaveData.GetRoomSave(self)
	for i in objects.size():
		if !saveData[i]:
			objects[i].queue_free()
			
	# set up out going transitions
	nextScene = null
	for area in transitions.keys():
		area.set_collision_mask(1)
		area.set_collision_layer(0)
		area.area_entered.connect(EnteredTransition.bind(transitions[area]))
	
	# spawn player
	player = load("res://Scenes/player.tscn").instance()
	if spawns.has(PlayerData.curScene):
		player.position = spawns[PlayerData.curScene].position
	else:
		if spawns["default"] == null:
			player.position = spawns[spawns.keys()[0]].position
		else:
			player.position = spawns["default"].position
		print(self.name, " does not have a spawn point for ", PlayerData.curScene)
		
	PlayerData.curScene = self.name
	
	# start
	
	pass # Replace with function body.

func EnteredTransition(next):
	nextScene = next
	# lock player controls
	pass

func ToNextRoom():
	get_tree().change_scene_to_file(transitions[nextScene])
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
