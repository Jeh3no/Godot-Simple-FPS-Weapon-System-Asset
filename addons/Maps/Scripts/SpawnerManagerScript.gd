extends Node3D

var listSpawners : Array[Node3D] = []
var rng = RandomNumberGenerator.new()

@onready var playChar : CharacterBody3D = $"../PlayerCharacter"

func _ready():
	setSpawnerList()
	
	setPlayCharSpawner()
	
func setSpawnerList():
	for spawner in get_children(): listSpawners.append(spawner)
	
func setPlayCharSpawner():
	if playChar != null: 
		#set play char position at a spawner point randomly chosen
		playChar.global_position = listSpawners[rng.randf_range(0, listSpawners.size())].global_position
	
func respawn():
	setPlayCharSpawner()
	
	

		
