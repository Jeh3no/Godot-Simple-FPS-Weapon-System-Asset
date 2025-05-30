extends CharacterBody3D

var health : int = 100
var healthRef : int
var isDisabled : bool = false

@onready var animManager : AnimationPlayer = $AnimationPlayer
@onready var damNumSpawnPoint : Marker3D = $DamageNumberSpawnPoint

func _ready():
	healthRef = health
	animManager.play("idle")
	
func hitscanHit(damageVal : float, hitscanDir : Vector3, hitscanPos : Vector3):
	health -= damageVal
	
	DamageNumberScript.display_number(damageVal, damNumSpawnPoint.global_position, 110, DamageNumberScript.DamageType.NORMAL)
	
	if health <= 0.0:
		isDisabled = true
		animManager.play("fall")
		
func projectileHit(damageVal : float, hitscanDir : Vector3):
	health -= damageVal
	
	DamageNumberScript.display_number(damageVal, damNumSpawnPoint.global_position, 110, DamageNumberScript.DamageType.NORMAL)
	
	if health <= 0.0:
		isDisabled = true
		animManager.play("fall")
		
		
		
		
		
		
		
		
		
