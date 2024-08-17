extends CanvasLayer

@onready var buttons = $ColorRect/Buttons

var button_map = {
	"KeyBind" : "ColorRect/Panels/KeyBindings",
	"General" : "ColorRect/Panels/GeneralSettings"
}

func _ready():
	for button in buttons.get_children():
		button.pressed.connect(Callable(self, "ShowMenu").bind(button.name))
	ShowMenu("General")
	Close()

func Open():
	self.show()
	get_tree().set_deferred("paused", true)

func Close():
	self.hide()
	get_tree().set_deferred("paused", false)

func HideAll():
	for button in buttons.get_children():
		var node = get_node_or_null(button_map[button.name])
		if node != null: node.hide()

func ShowMenu(button:String):
	HideAll()
	var node = get_node_or_null(button_map[button])
	if node != null: node.show()
