extends Node3D

var reloadTime : float
var startReloadTimer : bool = false #has to be initilated at start
var currentPartIndex : int
var playSoundAndAnim : bool
var forceReloadStop : bool = false

var cW #current weapon
@onready var weaponManager : Node3D = %WeaponManager #weapon manager

func getCurrentWeapon(currentWeapon):
	cW = currentWeapon
	
func _process(delta : float):
	if cW.isReloading and startReloadTimer and !forceReloadStop:
		reloadFollow(delta)
	elif forceReloadStop:
		cW.isReloading = false
		startReloadTimer = false
		return
		
func reload():
	reloadStart()
	
func reloadStart():
	if cW.hasToReload:
		if (!cW.isReloading and \
		#the type of ammunition the weapon is using still as reserve
		weaponManager.ammoManager.ammoDict[cW.ammoType] > cW.nbProjShotsAtSameTime and \
		#the magazine isn't full
		cW.totalAmmoInMag != cW.totalAmmoInMagRef and \
		!cW.isShooting): 
			cW.isReloading = true
			
			#for more than 1 part, you need to enter a multiple of total number of ammo the magazine can contain
			#for example, for a shotgun that can contain 8 shells, the number of parts to reload possible are : 1, 2, 4, 8
			#if you choose a number like 3, or 5, it will reload 3/8, or 5/8 at once, which is not possible, so be sure to enter a number of part allowing the weapon to reload ammunition units
			if (cW.totalAmmoInMagRef % cW.nbPartsNeeded) != 0:
				push_error("The number of parts set is not correct, cannot insert %d of ammunition" % (cW.nbPartsNeeded / cW.totalAmmoInMagRef))
				cW.isReloading = false
			else:
				currentPartIndex = 0
				reloadTime = cW.reloadTimePerPart
				forceReloadStop = false
				playSoundAndAnim = true
				startReloadTimer = true
				#the rest is been processed is reloadTimeProcess, then reloadFollow
	else:
		print("No need to reload")
		
func reloadFollow(delta : float):
	if playSoundAndAnim:
		playSoundAndAnim = false
		weaponManager.weaponSoundManagement(cW.reloadSound, cW.reloadSoundSpeed)
		
		if cW.shootAnimName != "":
			weaponManager.animManager.playAnimation("ReloadAnim%s" % cW.weaponName, cW.reloadAnimSpeed, true)
		else:
			print("%s doesn't have a reload animation" % cW.weaponName)
			
	if reloadTime > 0.0: reloadTime -= delta
	else:
		if currentPartIndex < cW.nbPartsNeeded: #-1, because if not it loop one extra time
			if cW.nbPartsNeeded == 1:
				onePartReloadCalculus()
			else:
				multiPartReloadCalculus()
				
			currentPartIndex += 1
			
			if currentPartIndex < cW.nbPartsNeeded:
				reloadTime = cW.reloadTimePerPart
				playSoundAndAnim = true
			else:
				print("Reload complete")
				cW.isReloading = false
		else:
			print("Reload complete")
			cW.isReloading = false
			
func onePartReloadCalculus():
	#explanation of the use of the min function here
	#case 1: if there's enough ammo to completely refill the magazine
	#case 2: if there's not enough ammo left, we refill the magazine with the remaining ammo.
	var nbnbAmmoToRefill : int = min(cW.totalAmmoInMagRef - cW.totalAmmoInMag, weaponManager.ammoManager.ammoDict[cW.ammoType])
	
	if nbnbAmmoToRefill <= cW.totalAmmoInMagRef and nbnbAmmoToRefill >= cW.nbProjShotsAtSameTime:
		#refill the magazine, and subtract the number from the ammo manager
		cW.totalAmmoInMag += nbnbAmmoToRefill
		weaponManager.ammoManager.ammoDict[cW.ammoType] -= nbnbAmmoToRefill
		
func multiPartReloadCalculus():
	var nbAmmoToRefill = cW.totalAmmoInMagRef / cW.nbPartsNeeded
	if weaponManager.ammoManager.ammoDict[cW.ammoType] >= nbAmmoToRefill and \
	cW.totalAmmoInMag <= cW.totalAmmoInMagRef - nbAmmoToRefill:
		#add number of ammo to the magazine, and substract it from the ammo manager
		cW.totalAmmoInMag += nbAmmoToRefill
		weaponManager.ammoManager.ammoDict[cW.ammoType] -= nbAmmoToRefill
	else:
		print("Not enough ammunition in bag, or magazine complete")
		forceReloadStop = true
		
func autoReload():
	#auto reload the weapon if he can reload, has to reload, has auto reload enabled, has enought ammo in the ammo manager, and the magazine is empty
	if cW.autoReload and !cW.isReloading and \
	weaponManager.ammoManager.ammoDict[cW.ammoType] > 0 and \
	cW.totalAmmoInMag <= 0: 
		reload()
