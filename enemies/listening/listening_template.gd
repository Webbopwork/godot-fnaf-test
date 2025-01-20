extends Node3D

@export var SoundPlayer: AudioStreamPlayer3D

#var Ray = RayCast3D

# Assuming you have a Character node named "Player" and an AudioStreamPlayer node named "SoundPlayer" in your scene
#extends CharacterBody3D

# A global variable to store the sound location
var sound_location = Vector3.ZERO

func _ready():
	# Connect the sound player's play signal to a function
	#SoundPlayer.connect("play", self, "_on_sound_played")
	pass

func _on_sound_played():
	# Get the current position of the sound player node
	var sound_position = SoundPlayer.global_position
	
	# Check if the sound position is close enough to the character's position
	if (sound_position - global_position).length() < 10:
		# Get the global location of the sound using raycasting
		var space_state = get_world_3d().direct_space_state
		#var ray = new Ray(global_position, sound_position - global_position)
		#var hit = get_node("SceneTree").get_ray_cast(ray)
		#var hit = space_state.intersect_ray(Vector2(0, 0), Vector2(50, 100))
		#var ray_paremeters = space_state.PhysicsRayQueryParameters3D()
		#ray_paremeters.from = 
		#var hit = space_state.intersect_ray(#ray_paremeters)
#		var hit = space_state.
		
		# If there is a hit node, store its global location as the sound location
#		if hit:
#			sound_location = hit.global_transform.origin
		
		# Print the sound location for debugging purposes
		print("Sound location:", sound_location)
