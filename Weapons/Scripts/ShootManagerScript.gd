extends Node3D

var cW #current weapon
var pointOfCollision : Vector3 = Vector3.ZERO

@onready var weapM : Node3D = %WeaponManager #weapon manager

func getCurrentWeapon(currWeap):
	cW = currWeap
	
func shoot():
	#si l'arme a des munitions dans son chargeur, et n'est pas en train de recharger
	if cW.canShoot and ((cW.totalAmmoInMag > 0 and cW.totalAmmoInMag >= cW.nbProjShotsAtSameTime) or (cW.allAmmoInMag and weapM.ammoManager.ammoDict[cW.ammoType] > 0)) and cW.canReload:
		cW.canShoot = false
		
		for i in range(cW.nbProjShots):
			if ((cW.totalAmmoInMag > 0 and cW.totalAmmoInMag >= cW.nbProjShotsAtSameTime) or (cW.allAmmoInMag and weapM.ammoManager.ammoDict[cW.ammoType] > 0)):
				
				weapM.weaponSoundManagement(cW.shootSound, cW.shootSoundSpeed)
				
				if cW.shootAnimName != "":
					weapM.animManager.playModelAnimation("ShootAnim%s" % cW.weaponName, cW.shootAnimSpeed, true)
				else:
					print("%s doesn't have a shoto animation" % cW.weaponName)
					
				for j in range(0, cW.nbProjShotsAtSameTime):
					if cW.allAmmoInMag: weapM.ammoManager.ammoDict[cW.ammoType] -= 1 #for doom like weapons
					else: cW.totalAmmoInMag -= 1
						
					pointOfCollision = getCameraPOV()
											
					if cW.type == cW.types.HITSCAN: hitscanShot(pointOfCollision)
					elif cW.type == cW.types.PROJECTILE: projectileShot(pointOfCollision)
					
				if cW.showMuzzleFlash: weapM.displayMuzzleFlash()
				
				weapM.cameraRecoilHolder.setRecoilValues(cW.baseRotSpeed, cW.targetRotSpeed)
				weapM.cameraRecoilHolder.addRecoil(cW.recoilVal)
				
				await get_tree().create_timer(cW.timeBetweenShots).timeout
				
			else:
				print("Not enought ammunitions to shoot")
				
		cW.canShoot = true
		
	else:
		print("Can't shoot, or is already shooting")
		
func getCameraPOV():  
	var camera : Camera3D = %Camera
	var window : Window = get_window()
	var viewport : Vector2i
	
	#match viewport to window size, to ensure that the raycast goes in the right direction
	match window.content_scale_mode:
		window.CONTENT_SCALE_MODE_VIEWPORT:
			viewport = window.content_scale_size
		window.CONTENT_SCALE_MODE_CANVAS_ITEMS:
			viewport = window.content_scale_size
		window.CONTENT_SCALE_MODE_DISABLED:
			viewport = window.get_size()
			
	#Start raycast in camera position, and launch it in camera direction 
	var raycastStart = camera.project_ray_origin(viewport/2)
	var raycastEnd
	if cW.type == cW.types.HITSCAN: raycastEnd = raycastStart + camera.project_ray_normal(viewport/2) * cW.maxRange 
	if cW.type == cW.types.PROJECTILE: raycastEnd = raycastStart + camera.project_ray_normal(viewport/2) * 280
	
	#Create intersection space to contain possible collisions 
	var newIntersection = PhysicsRayQueryParameters3D.create(raycastStart, raycastEnd)
	var intersection = get_world_3d().direct_space_state.intersect_ray(newIntersection)
	
	#If the raycast has collide with something, return collision point transform properties
	if !intersection.is_empty():
		var collisionPoint = intersection.position
		return collisionPoint 
	#Else, return the end of the raycast (so nothing, because he hasn't collide with anything) 
	else:
		return raycastEnd 
		
func hitscanShot(pointOfCollisionHitscan : Vector3):
	#set up weapon shot sprad 
	var spread = Vector3(weapM.rng.randf_range(cW.minSpread, cW.maxSpread), weapM.rng.randf_range(cW.minSpread, cW.maxSpread), weapM.rng.randf_range(cW.minSpread, cW.maxSpread))
	
	#calculate direction of the hitscan bullet 
	var hitscanBulletDirection = (pointOfCollisionHitscan - cW.weSl.attackPoint.get_global_transform().origin).normalized()
	
	#create new intersection space to contain possibe collisions 
	var newIntersection = PhysicsRayQueryParameters3D.create(cW.weSl.attackPoint.get_global_transform().origin, pointOfCollisionHitscan + spread + hitscanBulletDirection * 2)
	newIntersection.collide_with_areas = true
	newIntersection.collide_with_bodies = true 
	var hitscanBulletCollision = get_world_3d().direct_space_state.intersect_ray(newIntersection)
	
	#if the raycast has collide
	if hitscanBulletCollision: 
		var collider = hitscanBulletCollision.collider
		var colliderPoint = hitscanBulletCollision.position
		var colliderNormal = hitscanBulletCollision.normal 
		var finalDamage : int
		
		if collider.is_in_group("Enemies") and collider.has_method("hitscanHit"):
			finalDamage = cW.damagePerProj * cW.damageDropoff.sample(pointOfCollisionHitscan.distance_to(global_position) / cW.maxRange)
			collider.hitscanHit(finalDamage, hitscanBulletDirection, hitscanBulletCollision.position)
		
		elif collider.is_in_group("EnemiesHead") and collider.has_method("hitscanHit"):
				finalDamage = cW.damagePerProj * cW.headshotDamageMult * cW.damageDropoff.sample(pointOfCollisionHitscan.distance_to(global_position) / cW.maxRange)
				collider.hitscanHit(finalDamage, hitscanBulletDirection, hitscanBulletCollision.position)
		
		elif collider.is_in_group("HitableObjects") and collider.has_method("hitscanHit"): 
			finalDamage = cW.damagePerProj * cW.damageDropoff.sample(pointOfCollisionHitscan.distance_to(global_position) / cW.maxRange)
			collider.hitscanHit(finalDamage/6, hitscanBulletDirection, hitscanBulletCollision.position)
			weapM.displayBulletHole(colliderPoint, colliderNormal)
			
		else:
			weapM.displayBulletHole(colliderPoint, colliderNormal)
			
func projectileShot(pointOfCollisionProjectile : Vector3):
	#set up weapon shot sprad 
	var spread = Vector3(weapM.rng.randf_range(cW.minSpread, cW.maxSpread), weapM.rng.randf_range(cW.minSpread, cW.maxSpread), weapM.rng.randf_range(cW.minSpread, cW.maxSpread))
	
	#Calculate direction of the projectile
	var projectileDirection = ((pointOfCollisionProjectile - cW.weSl.attackPoint.get_global_transform().origin).normalized() + spread)
	
	#Instantiate projectile
	var projInstance = cW.projRef.instantiate()
	
	#set projectile properties 
	projInstance.global_transform = cW.weSl.attackPoint.global_transform
	projInstance.direction = projectileDirection
	projInstance.damage = cW.damagePerProj
	projInstance.timeBeforeVanish = cW.projTimeBeforeVanish
	projInstance.gravity_scale = cW.projGravityVal
	projInstance.isExplosive = cW.isProjExplosive
	
	get_tree().get_root().add_child(projInstance)
	
	projInstance.set_linear_velocity(projectileDirection * cW.projMoveSpeed)
