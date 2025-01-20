extends StaticBody3D

var light_on = false

@export var button_lower_percentage = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hand_switch():
	$SwitchStreamPlayer3D.play()
	position.x *= -1

func light_status(status:bool):
	light_on = status
	$SpotLight3D.visible = status
	$Button/OmniLight3D.visible = not status
	$Button.position.y *= (1/button_lower_percentage if light_on else button_lower_percentage)
	$Button/AudioStreamPlayer3D.pitch_scale = (1.0 if status else 0.8)
	$Button/AudioStreamPlayer3D.play()
	
func light_toggle():
	light_status(not light_on)
