extends RigidBody3D

#properties variables
var isExplosive : bool = false
var direction : Vector3 
var damage : float
var timeBeforeVanish : float 
var bodiesList : Array = []

#references variables
@onready var mesh = $Mesh
@onready var hitbox = $Hitbox

@export_group("Sound variables")
@onready var audioManager : PackedScene = preload("res://Scenes/AudioManagerScene.tscn")
@export var explosionSound : AudioStream

@export_group("Particles variables")
@onready var particlesManager : PackedScene = preload("res://Scenes/ParticlesManagerScene.tscn")

func _process(delta):
	if timeBeforeVanish > 0.0: timeBeforeVanish -= delta
	else: hit()
		
func _on_body_entered(body):
	hit()
	applyDamage(body)

func hit():
	mesh.visible = false
	hitbox.call_deferred("disabled", true)
	
	if isExplosive: explode()

func applyDamage(body):
	if body.is_in_group("Enemies") and body.has_method("projectileHit"):
			body.projectileHit(damage, direction)
			
	if body.is_in_group("HitableObjects") and body.has_method("projectilHit"):
		body.projectileHit(damage, direction)
	
func explode():
	weaponSoundManagement(explosionSound)
	
	var particlesIns
	if particlesIns == null:
		particlesIns = particlesManager.instantiate()
		particlesIns.particleToEmit ="Explosion"
		particlesIns.global_transform = global_transform
		get_tree().get_root().add_child(particlesIns)
		
	queue_free()
	
func weaponSoundManagement(soundName):
	if soundName != null:
		var audioIns = audioManager.instantiate()
		audioIns.global_transform = global_transform
		get_tree().get_root().add_child(audioIns)
		audioIns.bus = "Sfx"
		audioIns.volume_db = 5.0
		audioIns.stream = soundName
		audioIns.play()
	else:
		print("Projectile doesn't have an explosion sound")
	
