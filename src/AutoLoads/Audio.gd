extends Node

@onready var music = $Music
@onready var sfx = $SFX

enum MUSIC_TRACKS {MAIN_MENU, DEFAULT_LEVEL, CREDITS}
enum SFX_TRACKS {UPGRADE}

const MUSIC_PATHS = {
	MUSIC_TRACKS.MAIN_MENU : "res://Art/MenuTheme.mp3",
	MUSIC_TRACKS.DEFAULT_LEVEL : "",
	MUSIC_TRACKS.CREDITS : ""
}

const SFX_PATHS = {
	SFX_TRACKS.UPGRADE : "res://Art/Pickup.mp3"
}

var currentMusic = null
var currentSFX = null

func _ready():
	ChangeMusic(MUSIC_TRACKS.MAIN_MENU)

func ChangeMusic(track:MUSIC_TRACKS):
	if currentMusic == track:
		return 0
	music.stream = load(MUSIC_PATHS[track])
	music.play()
	currentMusic = track

func ChangeSFX(track:SFX_TRACKS):
	if currentSFX != track:
		sfx.stream = load(SFX_PATHS[track])
	if !sfx.playing:
		sfx.play()
	currentSFX = track

func ChangeSpeed(weight:int):
	pass

func ChangeVolume(bus, percent:float):
	
	pass
