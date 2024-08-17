extends Control

var level = "res://Levels/start.tscn"

func _on_start_pressed():
	get_tree().change_scene_to_file(level)

func _on_exit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	Settings.Open()
