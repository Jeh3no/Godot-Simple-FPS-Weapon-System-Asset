extends Node3D

var weaponStack : Array[int] = [] #weapons current wielded by play char
var weaponList : Dictionary = {} #all weapons available in the game (key = weapon name, value = wepakn resource)
@export var weaponResources : Array[WeaponResource] 
@export var startWeapons : Array[WeaponSlot]

var cW = null #current weapon
var cWM = null #current weapon model
var weaponIndex : int = 0

#weapon changes variables
var canChangeWeapons : bool = true
var canUseWeapon : bool = true

#reload variable
var hasToCancelReload : bool = false

var rng = RandomNumberGenerator.new()

@export_group("Keybind variables")
@export var shoot_action : String
@export var reload_action : String
@export var weapon_wheel_up_action : String
@export var weapon_wheel_down_action : String

@onready var playChar : CharacterBody3D = $"../../../.."
@onready var cameraHolder : Node3D = %CameraHolder
@onready var cameraRecoilHolder : Node3D = %CameraRecoilHolder
@onready var camera : Camera3D = %Camera
@onready var weaponContainer : Node3D = %WeaponContainer
@onready var shootManager : Node3D = %ShootManager
@onready var reloadManager : Node3D = %ReloadManager
@onready var ammoManager : Node3D = %AmmunitionManager
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var animManager : Node3D = %AnimationManager
@onready var audioManager : PackedScene = preload("res://Scenes/AudioManagerScene.tscn")
@onready var bulletDecal : PackedScene = preload("res://Scenes/BulletDecalScene.tscn")
@onready var hud : CanvasLayer = %HUD
@onready var reticle : CenterContainer = %Crosshair
@onready var linkComponent : Node3D = $"../../../../LinkComponent"

func _ready():
	initialize()
	
func initialize():
	for weapon in weaponResources:
		#create dict to refer weapons
		weaponList[weapon.weaponId] = weapon
		
	for weapo in weaponList.keys():
		#weaponsEmplacements[weapo] = weaponIndex
		cW = weaponList[weapo] #set each weapon to current, to acess properties useful to set up animations slicing and select correct weapon slot
		
		for weaponSlot in weaponContainer.get_children():
			if weaponSlot.weaponId == cW.weaponId: #id correspondant
				
				#if weapon is in the predetermined start weapons list
				for startWeapon in startWeapons:
					if startWeapon.weaponId == cW.weaponId: 
						weaponStack.append(cW.weaponId)
						
				cW.weSl = weaponSlot #get weapon slot script ref from weapon list (allows to get access to model, attack point, ...)
				weaponIndex += 1
				cWM = cW.weSl.model
				cWM.visible = false
				
				forceAttackPointTransformValues(cW.weSl.attackPoint)
				
				cW.bobPos = cW.position
				
	if weaponStack.size() > 0:
		enterWeapon(weaponStack[0])
		
func exitWeapon(nextWeapon : int):
	if nextWeapon != cW.weaponId:
		canChangeWeapons = false
		canUseWeapon = false
		
		var wasReloading = !cW.canReload #si canReload faux, était en train de recharger
		if cW.canShoot: cW.canShoot = false
		if cW.canReload: cW.canReload = false
		
		if cW.unequipAnimName != "":
			animManager.playModelAnimation("UnequipAnim%s" % cW.weaponName, cW.unequipAnimSpeed, false)
		await get_tree().create_timer(cW.unequipTime).timeout
		
		#if the weapon was in reloadind phase, instant reload
		if wasReloading:
			wasReloading = false
			#cas 1 : s'il y a assez de munitions pour reremplir entièrement le chargeur
			#cas 2 : plus assez de munitions, on remplit le chargeur avec les munitions qui reste
			var nbAmmoToRefill : int = min(cW.totalAmmoInMagRef - cW.totalAmmoInMag, ammoManager.ammoDict[cW.ammoType])
			cW.totalAmmoInMag += nbAmmoToRefill
			ammoManager.ammoDict[cW.ammoType] -= nbAmmoToRefill 
			
		cWM.visible = false
		
		enterWeapon(nextWeapon)
	
func enterWeapon(nextWeapon : int):
	cW = weaponList[nextWeapon]
	nextWeapon = 0
	cWM = cW.weSl.model
	cWM.visible = true
	
	shootManager.getCurrentWeapon(cW)
	reloadManager.getCurrentWeapon(cW)
	animManager.getCurrentWeapon(cW, cWM)
	
	weaponSoundManagement(cW.equipSound, cW.equipSoundSpeed)
	
	animPlayer.playback_default_blend_time = cW.animBlendTime
	
	if cW.equipAnimName != "":
		animManager.playModelAnimation("EquipAnim%s" % cW.weaponName, cW.equipAnimSpeed, false)
	await get_tree().create_timer(cW.equipTime).timeout
	
	if !cW.canShoot: cW.canShoot = true
	if !cW.canReload: cW.canReload = true
	canUseWeapon = true
	canChangeWeapons = true
	
func _process(delta : float):
	if cW != null and cWM != null and canUseWeapon:
		weaponInputs()
		
		reloadManager.autoReload()
		
	displayStats()
	
func weaponInputs():
	if Input.is_action_pressed(shoot_action): shootManager.shoot()
			
	if Input.is_action_just_pressed(reload_action): reloadManager.reload()
	
	if Input.is_action_just_pressed(weapon_wheel_up_action):
		if canChangeWeapons and cW.canShoot and cW.canReload:
			weaponIndex = min(weaponIndex + 1, weaponStack.size() - 1) #From first element of weapon stack to last element 
			changeWeapon(weaponStack[weaponIndex])
			
	if Input.is_action_just_pressed(weapon_wheel_down_action):
		if canChangeWeapons and cW.canShoot and cW.canReload:
			weaponIndex = max(weaponIndex - 1, 0) #From last element of weapon stack to first element 
			changeWeapon(weaponStack[weaponIndex])
		
func displayStats():
	hud.displayWeaponStack(weaponStack.size())
	hud.displayWeaponName(cW.weaponName)
	hud.displayTotalAmmoInMag(cW.totalAmmoInMag)
	hud.displayTotalAmmo(ammoManager.ammoDict[cW.ammoType])
	
func changeWeapon(nextWeapon : int):
	if canChangeWeapons and cW.canShoot and cW.canReload:
		exitWeapon(nextWeapon)
	else:
		push_error("Can't change weapon now")
		return 
	
func displayMuzzleFlash():
	if cW.muzzleFlashRef != null:
		var muzzleFlashInstance = cW.muzzleFlashRef.instantiate()
		add_child(muzzleFlashInstance)
		muzzleFlashInstance.global_position = cW.weSl.muzzleFlashSpawner.global_position
		muzzleFlashInstance.emitting = true
	else:
		push_error("%s doesn't have a muzzle flash reference" % cW.weaponName)
		return
		
func displayBulletHole(colliderPoint : Vector3, colliderNormal : Vector3):
	var bulletDecalInstance = bulletDecal.instantiate()
	get_tree().get_root().add_child(bulletDecalInstance)
	bulletDecalInstance.global_position = colliderPoint
	bulletDecalInstance.look_at(colliderPoint - colliderNormal, Vector3.UP)
	bulletDecalInstance.rotate_object_local(Vector3(1.0, 0.0, 0.0), 90)
	
func weaponSoundManagement(soundName : AudioStream, soundSpeed : float):
	var audioIns : AudioStreamPlayer3D = audioManager.instantiate()
	get_tree().get_root().add_child(audioIns)
	audioIns.global_transform = cW.weSl.attackPoint.global_transform
	audioIns.bus = "Sfx"
	audioIns.pitch_scale = soundSpeed
	audioIns.stream = soundName
	audioIns.play()
	
func forceAttackPointTransformValues(attackPoint : Marker3D):
	if attackPoint.rotation != Vector3.ZERO: attackPoint.rotation = Vector3.ZERO
