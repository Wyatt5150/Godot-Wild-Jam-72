extends Area2D

@export var collectableType:PlayerData.UPGRADE_TYPE = PlayerData.UPGRADE_TYPE.DASH

@onready var sprite = $Sprite2D

const DASH_TEXTURE = preload("res://Art/Dash.png")
const SPEED_TEXTURE = preload("res://Art/Clock.png")

func _ready():
	match collectableType:
		PlayerData.UPGRADE_TYPE.DASH:
			sprite.texture = DASH_TEXTURE
			self.rotation_degrees = 0.0
		PlayerData.UPGRADE_TYPE.LIGHT:
			sprite.texture = DASH_TEXTURE
			self.rotation_degrees = 270.0
		PlayerData.UPGRADE_TYPE.DARK:
			sprite.texture = DASH_TEXTURE
			self.rotation_degrees = 90.0
		PlayerData.UPGRADE_TYPE.SPEED:
			sprite.texture = SPEED_TEXTURE
			self.rotation_degrees = 0.0


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.UpgradeHandler(collectableType)
		Audio.ChangeSFX(Audio.SFX_TRACKS.UPGRADE)
		self.queue_free()
