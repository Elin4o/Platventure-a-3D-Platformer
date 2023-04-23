extends KinematicBody

export var gravity = 10
export var speed = 5
export var minimum_speed = 3

onready var anim_player = $Enemy_Middle/AnimationPlayer
onready var agent : NavigationAgent = $NavigationAgent
onready var target_location : Node = $"../Player"
onready var target = get_parent().get_node("Player")

var xlocation = rand_range(-30,30)
var zlocation = rand_range(-30,30)

var follow_player = false

var player_escape = false

var rot_speed = 0.05

var idle_speed = rand_range(minimum_speed, speed)
var move_or_not = [true, false]
var start_move = move_or_not[randi() % move_or_not.size()]

enum {
	IDLE,
	FOLLOWING
	}
	
var state = IDLE

func _on_Detection_Area_body_entered(body):
	if body.is_in_group("Player"):
		rot_speed = 0.1
		follow_player = true
		state = FOLLOWING
	
func _process(delta):
	match state:
		IDLE:
			anim_player.play("Orc Idle-loop")
		FOLLOWING:
			anim_player.play("Zombie Run-loop")			

	if follow_player == true:
		if $"../Player" != null:
			var global_pos = self.global_transform.origin
			var target_pos = target.global_transform.origin
			var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
			var wrotation = Quat(global_transform.basis).slerp(Quat(wtransform.basis), rot_speed)
			self.global_transform = Transform(Basis(wrotation), global_pos)
   
			agent.set_target_location(target_location.transform.origin)
			#move to player
			var next = agent.get_next_location()
			var velocity = (next - transform.origin).normalized() * speed  * delta
			move_and_collide(velocity)
	elif player_escape == false:
		#idle action
		var global_pos = self.global_transform.origin
		var wtransform = self.global_transform.looking_at(Vector3(xlocation, global_pos.y, zlocation), Vector3.UP)
		var wrotation = Quat(global_transform.basis).slerp(Quat(wtransform.basis), rot_speed)
		self.global_transform = Transform(Basis(wrotation), global_pos)
		
		if start_move == true:
			var velocity = global_transform.basis.z.normalized() * idle_speed * delta
			move_and_collide(-velocity)
			state = FOLLOWING
		else:
		 #enemy look at player when player escape
			state = IDLE
			global_pos = self.global_transform.origin
			var target_pos = target.global_transform.origin
			wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
			wrotation = Quat(global_transform.basis).slerp(Quat(wtransform.basis), rot_speed)
			self.global_transform = Transform(Basis(wrotation), global_pos)
  
	if not is_on_floor():
		move_and_collide(-global_transform.basis.y.normalized() * gravity * delta)
	
func _on_Detection_Area_body_exited(body):
	 if body.is_in_group("Player"):
			rot_speed = 0.05
			follow_player = false
			#when player escape enemy wait and look at player
			player_escape = true
			$Idling_Timer.start()
			state = IDLE
#timer for random looking
func _on_Timer_timeout():
	$Looking_Timer.set_wait_time(rand_range(4,8))
	xlocation = rand_range(-15,15) 
	zlocation = rand_range(-15,15)
	#random speed of idle move
	idle_speed = rand_range(minimum_speed, speed)
	#enemy will move or just look around
	start_move = move_or_not[randi() % move_or_not.size()]
	$Looking_Timer.start()

func _on_NavigationAgent_velocity_computed(safe_velocity):
	move_and_collide(safe_velocity)

func _on_Timer2_timeout():
 #enemy going back to idle action
	player_escape = false
	state = IDLE

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
		body._velocity.y = 15
		body._snap_vector = Vector3.ZERO
		body.move_and_slide_with_snap(body._velocity,body._snap_vector)

