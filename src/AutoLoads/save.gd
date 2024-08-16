extends Node

var roomSaveData:Dictionary

func _ready():
	pass # Replace with function body.

func reset():
	roomSaveData = {}

func GetRoomSave(room):
	if !roomSaveData.has(room.name):
		var arr = []
		for i in room.objects.size():
			arr.push_back(true)
		roomSaveData[room.name] = arr

	return roomSaveData[room.name]

func SetRoomData(room, index, val):
	roomSaveData[room.name][index] = val
