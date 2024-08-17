extends Node

@onready var music = $Music

enum MUSIC_TRACKS {MAIN_MENU, DEFAULT_LEVEL, CREDITS}
enum SFX_TRACKS {UPGRADE, ROCKFALL, JUMP}

const MUSIC_PATHS = {
	MUSIC_TRACKS.MAIN_MENU : "res://Art/MenuTheme.mp3",
	MUSIC_TRACKS.DEFAULT_LEVEL : "res://Art/MenuTheme.mp3",
	MUSIC_TRACKS.CREDITS : ""
}

const SFX_PATHS = {
	SFX_TRACKS.UPGRADE : "res://Art/Pickup.mp3",
	SFX_TRACKS.ROCKFALL : "res://Art/RockFall.mp3",
	SFX_TRACKS.JUMP : "res://Art/Jump.mp3"
}

var currentMusic = null
var audioSpeed = 1.0

func ChangeMusic(track:MUSIC_TRACKS):
	if currentMusic == track:
		return 0
	music.stream = load(MUSIC_PATHS[track])
	music.play()
	currentMusic = track

func PlaySFX(track:SFX_TRACKS, useWeight:bool = false):
	var sfx = AudioStreamPlayer.new()
	add_child(sfx)
	sfx.stream = load(SFX_PATHS[track])
	
	var pitch = 1.0
	if useWeight:
		pitch = audioSpeed
	pitch = pitch + randf_range(-.05, 0.05)
	sfx.pitch_scale = pitch
	sfx.finished.connect(Callable(sfx, "queue_free"))
	sfx.play()

func ChangeSpeed(weight:int):
	audioSpeed = 1.0 + (weight * .05)
	music.pitch_scale = audioSpeed

func ChangeVolume(bus, percent:float):
	AudioServer.set_bus_volume_db(bus, linear_to_db(percent/100))
