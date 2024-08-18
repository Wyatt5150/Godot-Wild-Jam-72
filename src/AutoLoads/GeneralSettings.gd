extends Control

@onready var masterSlider = $AudioSettings/Master/MasterSlider
@onready var musicSlider = $AudioSettings/Music/MusicSlider
@onready var sfxSlider = $AudioSettings/SFX/SFXSlider

func _ready():
	masterSlider.value_changed.connect(Callable(Audio, "ChangeVolume").bind("Master"))
	musicSlider.value_changed.connect(Callable(Audio, "ChangeVolume").bind("Music"))
	sfxSlider.value_changed.connect(Callable(Audio, "ChangeVolume").bind("SFX"))
	
	masterSlider.value = 50
	musicSlider.value = 50
	sfxSlider.value = 50
