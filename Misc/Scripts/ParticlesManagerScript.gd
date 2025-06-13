extends Node3D

class_name ParticlesManager

var positionToFollow : Vector3
var particleToEmit : String
var lifeTime : float

@onready var debris : GPUParticles3D = $DebrisParticles
@onready var smoke : GPUParticles3D = $SmokeParticles
@onready var fire : GPUParticles3D = $FireParticles

func _ready():
	match particleToEmit:
		"Explosion":
			lifeTime = smoke.lifetime
			debris.emitting = true
			smoke.emitting = true
			fire.emitting = true
			
	await get_tree().create_timer(lifeTime).timeout
	
	queue_free()
