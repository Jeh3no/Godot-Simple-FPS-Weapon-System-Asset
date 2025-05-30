extends Node3D

@onready var ammoManager : Node3D = $"../CameraHolder/CameraRecoilHolder/Camera/WeaponManager/AmmunitionManager"
@onready var weaponManager : Node3D = $"../CameraHolder/CameraRecoilHolder/Camera/WeaponManager"

func ammoRefillLink(ammoDict : Dictionary):
	for key in ammoDict.keys():
		if key in ammoManager.ammoDict:
			var nbAmmoToRefill : int = min(ammoManager.maxNbPerAmmoDict[key] - ammoManager.ammoDict[key], ammoDict[key])
			ammoManager.ammoDict[key] += nbAmmoToRefill
