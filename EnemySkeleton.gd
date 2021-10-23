extends KinematicBody2D


const UP=Vector2(0,-1)
const GRAVITY=25
const MAXSPEED=50
const MAXGRAVITY=50
const WeaponDamage=5

var movement=Vector2()
var moving_right=true
var player_in_range=false
var is_attacking=false

onready var AnimatedSprite: = $AnimatedSprite
onready var HitBox: = get_node("Area2D/HitBox")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if(!$DownRay.is_colliding()  || $RightRay.is_colliding()):
		var collider=$RightRay.get_collider()
		if collider && collider.name=="Player":
			movement=Vector2.ZERO
			player_in_range=true
		else:
			moving_right=!moving_right
			scale.x=-scale.x
	
	attack()
	animate()
	move_enemy()
	
func attack():
	if player_in_range && AnimatedSprite.animation != "ATTACK":
		AnimatedSprite.play("ATTACK")
		is_attacking=true
	elif player_in_range && !AnimatedSprite.playing:
		is_attacking=false
	
func animate():
	if is_attacking:
		return
		
	if movement!=Vector2.ZERO:
		$AnimatedSprite.play("WALK")
	else:
		$AnimatedSprite.play("IDLE")

func move_enemy():
	movement.y+=GRAVITY
	
	if(movement.y>MAXGRAVITY):
		movement.y=MAXGRAVITY
		
	if(is_on_floor()):
		movement.y=0
	
	if !player_in_range:	
		movement.x=MAXSPEED if moving_right else -MAXSPEED
	
	movement=move_and_slide(movement,UP)



func _on_AnimatedSprite_frame_changed():
	if AnimatedSprite.animation=="ATTACK" && AnimatedSprite.frame >= 7 && AnimatedSprite.frame <=8:
		HitBox.disabled=false
		print("HITBOX ACTIVATED")
	else:
		HitBox.disabled=true
		print("HITBOX DESACTIVADED")


func _on_Area2D_body_entered(body):
	if body.has_method("TakeDamage"):
		body.TakeDamage(WeaponDamage)
