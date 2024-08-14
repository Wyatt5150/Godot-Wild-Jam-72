extends CanvasLayer

func _ready():
	Close()

func Open():
	self.show()
	get_tree().set_deferred("paused", true)

func Close():
	self.hide()
	get_tree().set_deferred("paused", false)
