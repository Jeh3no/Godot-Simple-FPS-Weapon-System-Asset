extends Node3D

var ammoDict : Dictionary = { #key = ammo type, value = ammo start number
	"LightAmmo" : 90,
	"MediumAmmo" : 60,
	"HeavyAmmo" : 9,
	"ShellAmmo" : 128,
	"RocketAmmo" : 3,
	"GrenadeAmmo" : 12
}

var maxNbPerAmmoDict : Dictionary = { #key = ammo type, value = ammo max number
	"LightAmmo" : 360,
	"MediumAmmo" : 360,
	"HeavyAmmo" : 50,
	"ShellAmmo" : 640,
	"RocketAmmo" : 15,
	"GrenadeAmmo" : 60
}
	
