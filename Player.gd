extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 50
const MAXSPEED=50
const MAXGRAVITY=100
const JUMPSPEED=500

var PlayerLife=100
var is_hit=false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var movement=Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	if Input.is_action_pressed("left"):
		movement.x=-MAXSPEED
		$AnimatedSprite.play("Walk")
		$AnimatedSprite.set_flip_h(true)
	elif Input.is_action_pressed("right"):
		movement.x=MAXSPEED
		$AnimatedSprite.play("Walk")
		$AnimatedSprite.set_flip_h(false)
	elif !is_hit:
		movement.x=0
		$AnimatedSprite.play("Idle")
		
		
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			movement.y=-JUMPSPEED
	
	movement.y+=GRAVITY
	
	if movement.y> MAXGRAVITY:
		movement.y=MAXGRAVITY
		
	movement=move_and_slide(movement,UP)
	


func TakeDamage(damage):
	if !is_hit:
		PlayerLife-=damage
		is_hit=true
		$AnimatedSprite.play("Hit")
		print("Taking Damage")
		print(PlayerLife)
	if(PlayerLife<=0):
		queue_free()
		


func _on_AnimatedSprite_animation_finished():
	if is_hit && $AnimatedSprite.animation=="Hit":
		is_hit=false
		$AnimatedSprite.play("Idle")
