extends CharacterBody3D

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

    #there is a tremendous issue with the display of damage number, that i don't understand, and i didn't manage to resolve it, so i've put an option to disable it, so that you don't see its errors (which don't affect gameplay  in any way, I might add)
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
		
		
		
		
		
		
		
		
		
