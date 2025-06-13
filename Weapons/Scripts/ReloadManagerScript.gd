extends Node3D

var cW #current weapon

@onready var weapM : Node3D = %WeaponManager #weapon manager

func getCurrentWeapon(currWeap):
	#get current weapon resources
	cW = currWeap
	
func reload():
	if cW.hasToReload:
		if (cW.canReload and 
		#has enought ammo of the correct type
		weapM.ammoManager.ammoDict[cW.ammoType] > 0 and
		#the magazine isn't full
		cW.totalAmmoInMag != cW.totalAmmoInMagRef and
		#has >= ammo than the number of projectiles required for a shot
		weapM.ammoManager.ammoDict[cW.ammoType] >= cW.nbProjShotsAtSameTime
		and cW.canShoot): 
			cW.canReload = false 
			
			var nbPartsNeeded : int = 1
			
			#calculate the number of reload parts needed (for example, for a shotgun, 8 parts for 8 bullets)
			if cW.multiPartReload: nbPartsNeeded = abs(cW.totalAmmoInMagRef/cW.nbProjShotsAtSameTime - cW.totalAmmoInMag/cW.nbProjShotsAtSameTime)
			#if weapon doesn't need a multi part reload
			else: nbPartsNeeded = 1
			
			for i in range(0, nbPartsNeeded):
				weapM.weaponSoundManagement(cW.reloadSound, cW.reloadSoundSpeed)
				
				if cW.reloadAnimName != "":
					weapM.animManager.playModelAnimation("ReloadAnim%s" % cW.weaponName, cW.reloadAnimSpeed, false)
				else:
					print("%s doesn't have a reload animation" % cW.weaponName)
					
				if nbPartsNeeded == 1: await get_tree().create_timer(cW.reloadTime).timeout
				elif nbPartsNeeded > 1: await get_tree().create_timer(cW.multiPartReloadTime).timeout
				
				if cW.multiPartReload:
					multiPartReloadCalculus()
				else:
					reloadCalculus()
					
			cW.canReload = true
	else:
		print("No need to reload")
		
func reloadCalculus():
	if !cW.multiPartReload:
		#explanation of the use of the min function here
		#case 1: if there's enough ammo to completely refill the magazine
		#case 2: if there's not enough ammo left, we refill the magazine with the remaining ammo.
		var nbAmmoToRefill : int = min(cW.totalAmmoInMagRef - cW.totalAmmoInMag, weapM.ammoManager.ammoDict[cW.ammoType])
		
		if nbAmmoToRefill <= cW.totalAmmoInMagRef and nbAmmoToRefill >= cW.nbProjShotsAtSameTime:
			#refill the magazine, and subtract the number from the ammo manager
			cW.totalAmmoInMag += nbAmmoToRefill
			weapM.ammoManager.ammoDict[cW.ammoType] -= nbAmmoToRefill
			
func multiPartReloadCalculus():
	if weapM.ammoManager.ammoDict[cW.ammoType] >= cW.nbProjShotsAtSameTime:
		#add number of projectiles required for a shot to the magazine, and substract it from the ammo manager
		cW.totalAmmoInMag += cW.nbProjShotsAtSameTime
		weapM.ammoManager.ammoDict[cW.ammoType] -= cW.nbProjShotsAtSameTime
		
func autoReload():
	#auto reload the weapon if he can reload, has to reload, has auto reload enabled, has enought ammo in the ammo manager, and the magazine is empty
	if cW.autoReload and cW.canReload and weapM.ammoManager.ammoDict[cW.ammoType] > 0 and cW.totalAmmoInMag <= 0: reload()
