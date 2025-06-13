extends StaticBody3D

@export var ammoToRefill : Dictionary = {}

func _on_detect_area_area_entered(area: Area3D):
	if area.get_parent() is PlayerCharacter:
		var playChar = area.get_parent()
		var linkToAmmoRefill : Node3D = playChar.get_node("LinkComponent")
		
		if linkToAmmoRefill != null:
			linkToAmmoRefill.ammoRefillLink(ammoToRefill)
		else:
			print("Player character can't refill ammunition")
			
		queue_free()
