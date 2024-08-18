extends CanvasLayer

@onready var buttons = $ColorRect/Buttons
@onready var panels = $ColorRect/Panels

var button_map = {
	"HowTo" : "ColorRect/Panels/HowTo",
	"KeyBind" : "ColorRect/Panels/KeyBindings",
	"General" : "ColorRect/Panels/GeneralSettings",
	"Credits" : "ColorRect/Panels/Credits"
}

func _ready():
	for button in buttons.get_children():
		button.pressed.connect(Callable(self, "ShowMenu").bind(button.name))
	ShowMenu("HowTo")
	Close()

func Open():
	self.show()
	get_tree().set_deferred("paused", true)

func Close():
	self.hide()
	get_tree().set_deferred("paused", false)

func HideAll():
	for panel in panels.get_children():
		panel.hide()

func ShowMenu(button:String):
	HideAll()
	var node = get_node_or_null(button_map[button])
	if node != null: node.show()
