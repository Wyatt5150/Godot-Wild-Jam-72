extends Control

var bindings:Dictionary
var buttons:Dictionary

@export var butTheme : Theme
var timerLabel
var timer:Timer

var waitForInput = false
var settingAction:String
var settingIndex:int

# Called when the node enters the scene tree for the first time.
func _ready():
	timerLabel = $Label2
	timer = $Timer
	bindings = {
		"Left": [KEY_A, KEY_LEFT, null, null],
		"Right": [KEY_D, KEY_RIGHT, null, null],
		"Dash": [KEY_SHIFT, null, null, null],
		"Jump": [KEY_SPACE, null, null, null],
		"Lighten": [KEY_W, KEY_UP, null, null],
		"Darken": [KEY_S, KEY_DOWN, null, null],
	}
	
	var incr = 0
			
	for key in bindings.keys():
		if !InputMap.has_action(key):
			InputMap.add_action(key)
		var arr = []
		buttons[key] = arr
		var label:Label = Label.new()
		$Actions.add_child(label)
		label.text = key
		label.position.y = incr*80
		label.horizontal_alignment =HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment =VERTICAL_ALIGNMENT_CENTER
		label.size = Vector2(260,80)
		for i in 4:
			arr.push_back(make_binding_button(key,i,label))
			set_binding(key, bindings[key][i], i)
		incr+=1
	
func make_binding_button(action, index, parent):
	var but:Button = Button.new()
	parent.add_child(but)
	but.theme = butTheme
	but.size = Vector2(250,69)
	but.position = Vector2(400*index+287, 0)
	but.button_up.connect(pressed_binding.bind(action, index))
	
	var clear:Button = Button.new()
	parent.add_child(clear)
	clear.theme = butTheme
	clear.text = "X"
	clear.size = Vector2(69,69)
	clear.position = Vector2(but.position.x+260, 0)
	clear.button_down.connect(clear_binding.bind(action, index))
	return but

func _process(_delta):
	if !timer.is_stopped():
		timerLabel.text = str(int(timer.time_left)+1)

func _input(event):
	if !waitForInput or !event.is_pressed():
		return
	var e = null
	
	match settingIndex:
		0, 1:
			if event is InputEventKey:
				e = event.get_physical_keycode()
		2:
			if event is InputEventMouseButton:
				e = event.get_button_index()
		3:
			if event is InputEventJoypadButton:
				e = event.get_button_index()
				
	if e == null:
		return
	
	waitForInput = false
	timer.stop()
	$Label.text = ""
	timerLabel.text = ""
	set_binding(settingAction, e, settingIndex)

func pressed_binding(action, index):
	if waitForInput:
		return
	match index:
		0,1:
			$Label.text = "Press the desired key"
		2:
			$Label.text = "Press the desired mouse button"
		3:
			$Label.text = "Press the desired controller button"
	$Label.text += " (wait to cancel)"
	settingAction = action
	settingIndex = index
	waitForInput = true
	timer.start(5)

func set_binding(action, event, index = 0):
	if event == null:
		if index < 4 and index >= 0:
			bindings[action][index] = event	
			buttons[action][index].text = ""
		return false
	var e
	var eName =""
	match index:
		0, 1:
			e = InputEventKey.new()
			e.set_physical_keycode(event)
			var code = DisplayServer.keyboard_get_keycode_from_physical(e.get_physical_keycode())
			eName = OS.get_keycode_string(code)
		2:
			e = InputEventMouseButton.new()
			e.set_button_index(event)
			match event:
				1: eName = "Left"
				2: eName = "Right"
				3: eName = "Middle"
				4: eName = "WheelUp"
				5: eName = "WheelDown"
				6: eName = "WheelLeft"
				7: eName = "WheelRight"
				8: eName = "Extra 1"
				9: eName = "Extra 2"
				_: eName = "Unlabeled"
		3:
			e = InputEventJoypadButton.new()
			e.set_button_index(event)
			match event:
				0: eName = "A/Cross"
				1: eName = "B/Circle"
				2: eName = "X/Square"
				3: eName = "Y/Triangle"
				4: eName = "Back/Select"
				5: eName = "Home"
				6: eName = "Menu/Options"
				7: eName = "LeftStick"
				8: eName = "RightStick"
				9: eName = "LB/L1"
				10: eName = "RB/R1"
				11: eName = "Up"
				12: eName = "Down"
				13: eName = "Left"
				14: eName = "Right"
				_: eName = "Unlabeled"
		_:
			print("invalid index value: " , index)
			return false
	
	clear_binding(action,index)
	bindings[action][index] = event
	InputMap.action_add_event(action, e)
	buttons[action][index].text = eName
	
	return true

func clear_binding(action, index):
	if bindings[action][index] == null:
		return
	var bind
	match index:
		0,1:
			bind = InputEventKey.new()
			bind.set_physical_keycode(bindings[action][index])
		2:
			bind = InputEventMouseButton.new()
			bind.set_button_index(bindings[action][index])
		3:
			bind = InputEventJoypadButton.new()
			bind.set_button_index(bindings[action][index])
	
	InputMap.action_erase_event(action, bind)
	buttons[action][index].text = ""
	
func _on_timer_timeout():
	timer.stop()
	waitForInput = false
	$Label.text = ""
	timerLabel.text = ""
