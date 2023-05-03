extends KinematicBody


signal collected_coin
export (PackedScene) var foot_dust
export (NodePath) var animationTree
export var normal_speed:= 8
export var max_speed := 12
export var acceleration = 8
export var deceleration = 10
export var jump_height:= 10.0
export var gravity_multiplier := 3
export var low_jump_gravity_multiplier := 2.0
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
var movement_speed : float
var earth_gravity:= 9.807
var jump_released = false
var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN
var respawn_point = Vector3(0,2.5,0)
var last_checkpoint = null
var stop_on_slope := true
var collected_coins = 0
onready var floor_max_angle: float = deg2rad(46.0)
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)
onready var health = $Health
onready var healthbar = $UI/Interface/HealthBar
onready var _anim_tree = get_node(animationTree) 
onready var _spring_arm : SpringArm = $SpringArm
onready var _model : Spatial = $PlayerMesh

func _physics_process(delta:float) -> void:
	# Jumping conditionals
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_falling := _velocity.y < 0.0 and not is_on_floor() or _velocity.y < 0.0 and not is_on_floor() and is_on_wall()
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	var is_idling := is_on_floor() and -1 < _velocity.x and _velocity.x < 1 and -1 < _velocity.z and _velocity.z < 1
	var is_running := is_on_floor() and not is_zero_approx(_velocity.x) and movement_speed == max_speed
	var is_walking := is_on_floor() and not is_zero_approx(_velocity.x) and movement_speed == normal_speed

	# Directions
	get_movement_direction()
		
	slopes(delta)
	#Horizontal And Vertical Movement Speed
	apply_movement(delta)
	
	if is_jumping:
		_velocity.y +=  jump_height
		jump_released = false
		_snap_vector = Vector3.ZERO
		_anim_tree["parameters/playback"].travel("Jumping")
		$Jumping.play()
	
	elif is_idling:
		_snap_vector = Vector3.DOWN
		_anim_tree["parameters/playback"].travel("Idle")
	elif is_walking:
		_snap_vector = Vector3.DOWN
		_anim_tree["parameters/playback"].travel("Walking")
		if !$Walking.playing:
			$Walking.play()
		
	elif is_running:
		_snap_vector = Vector3.DOWN
		_anim_tree["parameters/playback"].travel("Running")
		if !$Running.playing:
			handle_footdust()
			$Running.play()
	
	elif just_landed:
		_snap_vector = Vector3.DOWN
		
	elif is_falling:
		_anim_tree["parameters/playback"].travel("Jumping")
	
	if Vector2(_velocity.z, _velocity.x).length() > 0.2:
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y = look_direction.angle()
		
	if health.current == 0:
		kill()
		
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector,
	 Vector3.UP, stop_on_slope , 4 , floor_max_angle)
	
func _ready():
	health.connect("changed", healthbar, "set_value")
	health.connect("max_changed", healthbar, "set_max")
	health.initialize()

func handle_footdust():
	if(is_on_floor()):
		var footdust = foot_dust.instance()
		footdust.emitting = true
		footdust.transform.origin = $PlayerMesh/Foot.global_translation
		get_parent().add_child(footdust)
	
func slopes(delta):
	#Slope Condition
	if is_on_floor():
		_snap_vector = -get_floor_normal() - get_floor_velocity() * delta
		
		if _velocity.y < 0:
			_velocity.y = 0
			
	else:
		if _snap_vector != Vector3.ZERO && _velocity.y != 0:
			_velocity.y = 0
		
		_snap_vector = Vector3.ZERO	
		
		player_gravity(delta)
	
func get_movement_direction():
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
	
	return move_direction.normalized() if move_direction.length() > 1 else move_direction 
	
func apply_movement(delta):
	#Horizontal Movement
	movement_speed = normal_speed
	
	if Input.is_action_pressed("Run"):
		movement_speed = max_speed
		
	var temp_vel := _velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = get_movement_direction() * movement_speed
	
	if get_movement_direction().dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
		
	if not is_on_floor():
		temp_accel *= air_control
		
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	
	_velocity.x = temp_vel.x
	_velocity.z = temp_vel.z
		
func player_gravity(delta):
	_velocity.y -= gravity * delta
	
	if _velocity.y < 0.0 and not is_on_floor() :
		_velocity.y -=  gravity * delta
	elif _velocity.y > 0 && jump_released:
		_velocity.y -=  gravity * low_jump_gravity_multiplier * delta
		
	if Input.is_action_just_released("jump"):
		jump_released = true;
	
func _process(_delta)->void: 
	if _spring_arm != null:
		_spring_arm.translation = translation

func kill():
	global_transform.origin = respawn_point
	GlobalSettings.score -= 50
	health.current = 3
	
func hurt_Sound():
	$Hurt.play()
	

func set_checkpoint(pos,object):
	respawn_point = pos
	if last_checkpoint:
		last_checkpoint.is_current_checkpoint = false
	last_checkpoint = object
	object.is_current_checkpoint = true


func _on_EnemyDetection_body_entered(body):
	if body.is_in_group("Enemies"):
		health.current -= 1
		_velocity = (global_transform.origin - body.global_transform.origin).normalized()*30
		_velocity.y = 5
		_snap_vector = Vector3.ZERO
		move_and_slide_with_snap(_velocity,_snap_vector)

		$Hurt.play()
		
