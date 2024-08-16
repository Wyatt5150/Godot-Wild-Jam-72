extends Node

var roomSaveData:Dictionary

func _ready():
	pass # Replace with function body.

func GetRoomSave(room):
	if !roomSaveData.has(room.name):
		var arr = []
		for i in room.objects.size():
			arr.push_back(true)
		roomSaveData[room.name] = arr

	return roomSaveData[room.name]
