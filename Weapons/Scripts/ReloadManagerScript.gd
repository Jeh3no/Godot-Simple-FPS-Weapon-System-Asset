extends Node3D

var cW #current weapon

@onready var weapM : Node3D = %WeaponManager #weapon manager

func getCurrentWeapon(currWeap):
	cW = currWeap
	
func reload():
	if cW.hasToReload:
		if (cW.canReload and weapM.ammoManager.ammoDict[cW.ammoType] > 0 and cW.totalAmmoInMag != cW.totalAmmoInMagRef and weapM.ammoManager.ammoDict[cW.ammoType] >= cW.nbProjShotsAtSameTime and cW.canShoot): 
			cW.canReload = false 
			
			var nbPartsNeeded : int = 1
			
			if cW.multiPartReload: nbPartsNeeded = abs(cW.totalAmmoInMagRef/cW.nbProjShotsAtSameTime - cW.totalAmmoInMag/cW.nbProjShotsAtSameTime)
			else: nbPartsNeeded = 1
			
			for i in range(0, nbPartsNeeded):
				weapM.weaponSoundManagement(cW.reloadSound, cW.reloadSoundSpeed)
				
				if cW.reloadAnimName != "":
					weapM.animManager.playModelAnimation("ReloadAnim%s" % cW.weaponName, cW.reloadAnimSpeed, false)
				
				await get_tree().create_timer(cW.reloadTime).timeout if nbPartsNeeded == 1 else get_tree().create_timer(cW.multiPartReloadTime).timeout
				
				if cW.multiPartReload:
					multiPartReloadCalculus()
				else:
					reloadCalculus()
					
			cW.canReload = true
	else:
		print("No need to reload")
		
func reloadCalculus():
	if !cW.multiPartReload:
		#cas 1 : s'il y a assez de munitions pour reremplir entièrement le chargeur
		#cas 2 : plus assez de munitions, on remplit le chargeur avec les munitions qui reste
		var nbAmmoToRefill : int = min(cW.totalAmmoInMagRef - cW.totalAmmoInMag, weapM.ammoManager.ammoDict[cW.ammoType])
		
		if nbAmmoToRefill <= cW.totalAmmoInMagRef and nbAmmoToRefill >= cW.nbProjShotsAtSameTime:
			cW.totalAmmoInMag += nbAmmoToRefill
			weapM.ammoManager.ammoDict[cW.ammoType] -= nbAmmoToRefill
			
func multiPartReloadCalculus():
	if weapM.ammoManager.ammoDict[cW.ammoType] >= cW.nbProjShotsAtSameTime:
		cW.totalAmmoInMag += cW.nbProjShotsAtSameTime
		weapM.ammoManager.ammoDict[cW.ammoType] -= cW.nbProjShotsAtSameTime
		
func autoReload():
	if cW.autoReload and cW.canReload and weapM.ammoManager.ammoDict[cW.ammoType] > 0 and cW.totalAmmoInMag <= 0: reload()
