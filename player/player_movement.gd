extends CharacterBody3D

signal running_sound(_position:Vector3)
signal toggling_sound(_position:Vector3)

var rng = RandomNumberGenerator.new()

var hidden = false

var front_look = true

var moved = false
var moved_last = false

var up_look = false
var down_look = false
var left_look = false
var right_look = false

var acted_last = false

var left_moved = false

var right_moved = false

var last_left_moved = false

var last_right_moved = false

@export var up_degrees = 45
@export var down_degrees = -45
@export var left_degrees = 45
@export var right_degrees = -45

@export var left_move = -10.0
@export var right_move = 10.0

@export var computer: CSGBox3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func desk_hide():
	hidden = true
	velocity.z = -2
	position.y = -2
	pass
	
func desk_unhide():
	hidden = false
	#position.z = 0
	velocity.z = 2
	#position.y = -1
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	if acted_last:
#		$Camera3D.rotation.x = (up_degrees if up_look else (down_degrees if down_look else 0))
#		$Camera3D.rotation.y = (left_degrees if left_look else (right_degrees if right_look else 0))
	
	
#func _physics_process(delta):
#	move_and_slide()
#	velocity.z /= 1.25
"""
func _input(event):
	acted_last = true
	if event.is_action_pressed("up_look"):
		if down_look:
			down_look = false
		else:
			up_look = true
	elif event.is_action_pressed("down_look"):
		if up_look:
			up_look = false
		else:
			down_look = true
	elif event.is_action_pressed("left_look"):
		if right_look:
			right_look = false
		else:
			left_look = true
	elif event.is_action_pressed("right_look"):
		if left_look:
			left_look = false
		else:
			right_look = true
	elif event.is_action_pressed("flashlight_toggle"):
		#print_debug("camera toggled")
		$Camera3D/Flashlight.light_toggle()
		#$Camera3D.rotation.x
		return
	elif event.is_action_pressed("interact_toggle") and front_look:
		computer.toggle_backlight()
		print_debug("computer toggled")
		return
	elif event.is_action_pressed("flashlight_switch"):
		$Camera3D/Flashlight.hand_switch()
		return
	else:
		acted_last = false
	front_look = not (left_look or right_look or up_look or down_look)
	print_debug(front_look)
"""

func _process(_delta):#_physics_process(delta):
	acted_last = true
	if Input.is_action_just_pressed("up_look"):
		if down_look:
			down_look = false
		else:
			up_look = true
	elif Input.is_action_just_pressed("down_look"):
		if up_look:
			up_look = false
		else:
			down_look = true
	elif Input.is_action_just_pressed("left_look"):
		if right_look:
			right_look = false
		else:
			left_look = true
	elif Input.is_action_just_pressed("right_look"):
		if left_look:
			left_look = false
		else:
			right_look = true
	elif Input.is_action_just_pressed("flashlight_toggle"):
		#print_debug("camera toggled")
		$CameraSet/Flashlight.light_toggle()
		toggling_sound.emit(position)
		#$Camera3D.rotation.x
		return
	elif Input.is_action_just_pressed("interact_toggle"):
		if hidden:
			desk_unhide()
			return
		elif front_look and not moved:
			computer.toggle_backlight()
			toggling_sound.emit(position)
			print_debug("computer toggled")
			return
		elif down_look and not moved:
			desk_hide()
			return
		elif left_look and not left_moved:
			$RunningAudioPlayer3D.playing = true
			#$RunningAudioPlayer3D.play()			
			moved_last = true
			if right_moved:
				right_moved = false
			else:
				left_moved = true
				last_left_moved = true
				last_right_moved = false
			running_sound.emit(position)
				
		elif right_look and not right_moved:
			$RunningAudioPlayer3D.playing = true
			#$RunningAudioPlayer3D.play()
			moved_last = true
			if left_moved:
				left_moved = false
			else:
				right_moved = true
				last_right_moved = true
				last_left_moved = false
			running_sound.emit(position)
				
	elif Input.is_action_just_pressed("flashlight_switch"):
		$CameraSet/Flashlight.hand_switch()
		toggling_sound.emit(position)
		return
	else:
		acted_last = false
	front_look = not (left_look or right_look or up_look or down_look)
	moved = (left_moved or right_moved)
	
	if acted_last:
		$CameraSet.rotation.x = (up_degrees if up_look else (down_degrees if down_look else 0))
		$CameraSet.rotation.y = (left_degrees if left_look else (right_degrees if right_look else 0))
		#$Camera3D.rotate_y(left_degrees if left_look else (right_degrees if right_look else 0))
		#velocity.x = (0 if not moved_last else (left_move if left_moved else (right_move if right_moved else 0)))
		#velocity.x = (0 if not moved_last else (left_move if left_moved else (right_move if right_moved else -position.x)))
		if moved_last:
			velocity.x = (left_move if left_moved else (right_move if right_moved else -position.x))
			$CameraSet/Flashlight.rotation.x = 0.125
			$CameraSet/Flashlight.rotation.y = 0.125
			#while true:
				#move_and_slide()
			#while ((position.x < right_move) if right_moved else (position.x > left_move)):
				#move_and_slide()
			#velocity.x = 0
			moved_last = false
		#mo
		#$RunningAudioPlayer3D.stream_paused = true

func _physics_process(delta):
	move_and_slide()
	if ((position.x >= right_move) if right_moved else ((position.x <= left_move) if left_moved else (position.x >= 0 if last_left_moved else position.x <= 0))):
		$CameraSet/Flashlight.rotation.x = 0
		$CameraSet/Flashlight.rotation.y = 0
		$CameraSet/Camera3D.rotation.z = 0
		velocity.x = 0
		#running_sound.emit(position)
	else:
		$CameraSet/Flashlight.rotate_x(rng.randf_range(-1*delta, delta))
		$CameraSet/Flashlight.rotate_y(rng.randf_range(-1*delta, delta))
		$CameraSet/Camera3D.rotate_z(rng.randf_range(-0.75*delta, 0.75*delta))
		running_sound.emit(position)
	if hidden and (position.z <= -2):
		velocity.z = 0
	elif not hidden and (position.z >= 0):
		velocity.z = 0
		position.y = 0
		#$Camera3D/Flashlight.rota
		#$Camera3D/Flashlight.rotation.y = $Camera3D/Flashlight.rotation.x/1.5#rng.randf_range(-25, 25)
		#$Camera3D/Flashlight.rotate_y($Camera3D/Flashlight.rotation.x/(1.5*delta))

func _you_died():
	get_tree().change_scene_to_file("res://menus/Death/Fired_scene.tscn")
	pass

#func _input(event):
#	if event.is_action("walk_forward"):
#		velocity.z = -1
#		#position.z -= 1
#	elif event.is_action("walk_backward"):
#		velocity.z = 1
#		velocity.z += 1
#	else:
#		velocity.z = 0
#	#move_and_slide()
#	pass
