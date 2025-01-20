extends CharacterBody3D

@onready var agent = $NavigationAgent3D

@export var player: CharacterBody3D

@export var patroll_targets : Array[Node3D]

var current_patroll_index := 0

var patroll_target_count : int

var patrolling := false

var chasing := false

@export var SPEED = 5

@export var target: Vector3
var last_target: Vector3
#var last_distance = 0

var just_alerted := false

var timer_started := false

var first_step := false

@export var level := 1

@export var reset_target: bool = true

@export var target_distance := 3.0

@export var turnaway_distance := 5.0

@export var direct_attack_distance := 15.0

@export var reset_wait_time := 5.0

@export var use_enemy_variables := false

@export var remove_self := false

func global_to_local(from:Vector3):
	return transform.origin + from
	
func set_global_ray_target(to:Vector3):
	$RayCast3D.target_position = global_to_local(to)

func start_patrolling():
	if patrolling:
		current_patroll_index += 1
	patrolling = true
	if current_patroll_index >= patroll_target_count:
		current_patroll_index = 0
	target = patroll_targets[current_patroll_index].global_position

func stop_chase():
	chasing = false
	#print_debug('Timer stopped with ', $Timer.time_left)
	last_target = target
	timer_started = false
	$Timer.paused = true
	reset_timer()
	
func _sound_played(target_position):
	chasing = true
	just_alerted = true
	patrolling = false
	#print_debug('Target distance', position.distance_to(target_position))
	if position.distance_to(target_position) <= direct_attack_distance:
		target = target_position
		#print_debug('Direct attack', target_position)
	else:
		set_global_ray_target(target_position)
		target = $RayCast3D.get_collision_point()
		#print_debug('distanced attack', $RayCast3D.get_collision_point())
	
func reset_timer():
	$Timer.wait_time = reset_wait_time

func _ready():
	if remove_self:
		queue_free()
	#$AudioListener3D.get_listener_transform()
	elif use_enemy_variables:
		SPEED = EnemyVariables.SPEED
		level = EnemyVariables.level
		target_distance = EnemyVariables.target_distance
		turnaway_distance = EnemyVariables.turnaway_distance
		direct_attack_distance = EnemyVariables.direct_attack_distance
		reset_wait_time = EnemyVariables.reset_wait_time
	
	patroll_target_count = len(patroll_targets)
		
	reset_timer()
	last_target = global_position
	if reset_target:
		target = global_position
	SPEED *= 1.0+(level/10.0)
	direct_attack_distance += 5*level
	#else:
		#updateTargetLocation(target)

func _physics_process(_delta):
	#$RayCast3D.force_raycast_update()
	#print_debug($RayCast3D.get_collision_point())
	look_at(target)
	#look_at(agent.get_next_path_position())
	rotation.x = 0
	rotation.z = 0
	if target != last_target:
		updateTargetLocation(target)
		var current_target_distance = position.distance_to(target)
		#print_debug(position.distance_to(target))
		#print(floor(current_target_distance), ' ', round(last_distance))
		#print($Timer.is_stopped())
		if current_target_distance < turnaway_distance and not just_alerted:
			if not timer_started:
				$Timer.start(reset_wait_time)
				timer_started = true
				#print_debug('Timer started with ', $Timer.time_left)
				#get_tree().paused = true
			else:
				$Timer.paused = false
				#print_debug('Timer continued with ', $Timer.time_left)
		elif current_target_distance > target_distance:
			#print_debug('Timer paused with ', $Timer.time_left)
			$Timer.paused = true
			if first_step:
				if not $Step1.playing:
					$Step1.play()
					first_step = false
			else:
				if not $Step2.playing:
					$Step2.play()
					first_step = true
			var current_location = global_transform.origin
			var next_location = agent.get_next_path_position()
			var new_velocity = (next_location - current_location).normalized() * SPEED
			if is_on_floor() or is_on_wall() or is_on_ceiling():
				new_velocity.y = 0
			#rotate_y((current_location - next_location).normalized().x)
			#look_at(next_location)
			#rotate_y(180)
			#look_at(next_location + current_location * new_velocity)
			#look_at(target-new_velocity)
			rotation.x = 0
			rotation.z = 0
			velocity = new_velocity
			move_and_slide()
		else:
			#target has been reached
			stop_chase()
			pass
		just_alerted = false
		#last_distance = current_target_distance
		#print_debug(last_distance)
		#print_debug(round(last_distance))
		#print_debug(floor(last_distance))
		#print_debug(target == last_target)
	elif not chasing:
		start_patrolling()

func updateTargetLocation(_target:Vector3):
	agent.set_target_position(_target)
	
func _on_timer_timeout():
	print_debug('Timer ran out!')
	#visible = false
	stop_chase()
	pass # Replace with function body.
	
#const JUMP_VELOCITY = 4.5
#
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#
#
#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y -= gravity * delta

#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
#	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#	if direction:
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)
#
#	move_and_slide()



