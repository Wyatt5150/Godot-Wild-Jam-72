extends Control

var level = "res://Levels/start.tscn"

func _ready():
	Audio.ChangeMusic(Audio.MUSIC_TRACKS.MAIN_MENU)

func _on_start_pressed():
	Audio.ChangeMusic(Audio.MUSIC_TRACKS.DEFAULT_LEVEL)
	get_tree().change_scene_to_file(level)

func _on_exit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	Settings.Open()
