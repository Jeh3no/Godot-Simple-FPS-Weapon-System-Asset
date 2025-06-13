extends Node3D

@onready var ammoManager : Node3D = %AmmunitionManager
@onready var weaponManager : Node3D = %WeaponManager

func ammoRefillLink(ammoDict : Dictionary):
	for key in ammoDict.keys():
		if key in ammoManager.ammoDict:
			#two cases for the min function here : 
			#1 : 
			var nbAmmoToRefill : int = min(ammoManager.maxNbPerAmmoDict[key] - ammoManager.ammoDict[key], ammoDict[key])
			ammoManager.ammoDict[key] += nbAmmoToRefill
