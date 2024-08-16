extends CharacterBody2D

var player
var blackout
var blackoutTarget

func _ready():
	blackout = $Blackout
	blackoutTarget=1
	$Timer.start(.2)
	pass

func _physics_process(delta):
	if blackout.modulate.a != blackoutTarget:
		blackout.modulate.a = move_toward(blackout.modulate.a, blackoutTarget, 5*delta)
	velocity = (player.position - position)*5
	move_and_slide()


func _on_timer_timeout():
	$Timer.stop()
	blackoutTarget = 0
	pass # Replace with function body.
