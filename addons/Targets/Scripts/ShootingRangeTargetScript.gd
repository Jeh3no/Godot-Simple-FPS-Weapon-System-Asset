extends CharacterBody3D

class_name ShootingRangeTarget

var canDisplayDamageNumber : bool = false
var health : float = 100.0
var healthRef : float
var isDisabled : bool = false

@onready var animManager : AnimationPlayer = $AnimationPlayer
@onready var damNumSpawnPoint : Marker3D = $DamageNumberSpawnPoint

func _ready():
	healthRef = health
	animManager.play("idle")
	
func hitscanHit(damageVal : float, _hitscanDir : Vector3, _hitscanPos : Vector3):
	health -= damageVal

	#About the display of damage number, there are some tremendous errors with it, that i don't understand, and i didn't manage to resolve it, so i've put an option to disable it, so that you don't see theses errors (which don't affect gameplay in any way, i might add, but i preferred to add an option to not trigger them).
	if !isDisabled and canDisplayDamageNumber:
		DamageNumberScript.displayNumber(damageVal, damNumSpawnPoint.global_position, 110, DamageNumberScript.DamageType.NORMAL)
	
	if health <= 0.0:
		isDisabled = true
		animManager.play("fall")
		
func projectileHit(damageVal : float, _hitscanDir : Vector3):
	health -= damageVal
	
	if !isDisabled and canDisplayDamageNumber:
		DamageNumberScript.displayNumber(damageVal, damNumSpawnPoint.global_position, 110, DamageNumberScript.DamageType.NORMAL)
	
	if health <= 0.0:
		isDisabled = true
		animManager.play("fall")
		
		
		
		
		
		
		
		
		
