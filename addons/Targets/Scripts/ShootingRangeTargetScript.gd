extends CharacterBody3D

class_name ShootingRangeTarget

@export var health : float = 100.0
var healthRef : float
var isDisabled : bool = false

@onready var animManager : AnimationPlayer = $AnimationPlayer

func _ready():
	healthRef = health
	animManager.play("idle")
	
func hitscanHit(damageVal : float, _hitscanDir : Vector3, _hitscanPos : Vector3):
	health -= damageVal
	
	print("Hitscan hit, target health : ", health)
	
	if health <= 0.0 and !isDisabled:
		isDisabled = true
		animManager.play("fall")
		
func projectileHit(damageVal : float, _hitscanDir : Vector3):
	health -= damageVal
	
	print("Projectile hit, target health : ", health)
	
	if health <= 0.0 and !isDisabled:
		isDisabled = true
		animManager.play("fall")
		
		
		
		
		
		
		
		
		
