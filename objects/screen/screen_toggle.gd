extends Node3D

signal screen_on(_position:Vector3)

@export var material: StandardMaterial3D

# Called when the node enters the scene tree for the first time.
#func _ready():
#	material = get_surface_material(0)
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if material.emission_enabled:
		screen_on.emit(position)
	pass

func set_backlight(status:bool):
	#material.backlight_enabled = status
	$Button_holder/Button.position.z *= -1
	$Button_holder/Button/OmniLight3D.visible = not status
	material.emission_enabled = status
	$AmbienceStreamPlayer3D.playing = status
	$OmniLight3D.light_energy *= (2.0 if status else 0.5)
	$Button_holder/AudioStreamPlayer3D.pitch_scale = (1.0 if status else 0.85)
	$Button_holder/AudioStreamPlayer3D.play()
	if status:
		screen_on.emit(position)
	
func toggle_backlight():
	set_backlight(not material.emission_enabled)#material.backlight_enabled)


func _on_ambience_stream_player_3d_finished():
	if material.emission_enabled:
		$AmbienceStreamPlayer3D.playing = true
	pass # Replace with function body.
