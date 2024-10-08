extends Node

@onready var music = $Music

enum MUSIC_TRACKS {MAIN_MENU, DEFAULT_LEVEL, POST_DASH}
enum SFX_TRACKS {UPGRADE, ROCKFALL, JUMP, DASH}

const MUSIC_PATHS = {
	MUSIC_TRACKS.MAIN_MENU : "res://Art/Title.mp3",
	MUSIC_TRACKS.DEFAULT_LEVEL : "res://Art/BackgroundTheme.mp3",
	MUSIC_TRACKS.POST_DASH : "res://Art/Post Dash.mp3"
}

const SFX_PATHS = {
	SFX_TRACKS.UPGRADE : "res://Art/Pickup.mp3",
	SFX_TRACKS.ROCKFALL : "res://Art/RockFall.mp3",
	SFX_TRACKS.JUMP : "res://Art/Whoosh.mp3",
	SFX_TRACKS.DASH : "res://Art/Whoosh.mp3"
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
	sfx.set_bus("SFX")
	
	var pitch = 1.0
	if useWeight:
		pitch = audioSpeed
	pitch = pitch + randf_range(-.05, 0.05)
	sfx.pitch_scale = pitch
	sfx.finished.connect(Callable(sfx, "queue_free"))
	sfx.play()

func Play2DSFX(track:SFX_TRACKS, node:Node2D, useWeight:bool = false):
	var sfx = AudioStreamPlayer2D.new()
	node.add_child(sfx)
	sfx.stream = load(SFX_PATHS[track])
	sfx.set_bus("SFX")
	
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

func ChangeVolume(percent:float, bus:StringName):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(percent/100))
