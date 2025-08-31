extends Resource

class_name WeaponResource

@export_group("General variables")
@export var weaponName : String
@export var weaponId : int
var weaponSlot : WeaponSlot

@export_group("Type variables")
enum types
{
	NULL, HITSCAN, PROJECTILE
}
@export var type = types.NULL 

@export_group("Animation variables")
@export var animBlendTime : float
@export var equipAnimName : String
@export var equipAnimSpeed : float = 1.0
@export var unequipAnimName : String
@export var unequipAnimSpeed : float = 1.0
@export var shootAnimName : String
@export var shootAnimSpeed : float = 1.0
@export var reloadAnimName : String
@export var reloadAnimSpeed : float = 1.0

@export_group("Sound variables")
@export var equipSound : AudioStream
@export var equipSoundSpeed : float = 1.0
@export var unequipSound : AudioStream
@export var unequipSoundSpeed : float = 1.0
@export var shootSound : AudioStream
@export var shootSoundSpeed : float = 1.0
@export var reloadSound : AudioStream
@export var reloadSoundSpeed : float = 1.0

@export_group("Ammunition variables")
@export var totalAmmoInMag : int 
@export var totalAmmoInMagRef : int 
@export var ammoType : String
@export var allAmmoInMag : bool = false

@export_group("Equip variables")
@export var equipTime : float

@export_group("Unequip variables")
@export var unequipTime : float

@export_group("Shoot variables")
var isShooting : bool = false 
@export var canAutoShoot : bool 
@export var nbProjShotsAtSameTime : int
@export var nbProjShots : int
@export var minSpread : float
@export var maxSpread : float 
@export var maxRange : float 
@export var damagePerProj : float 
@export var damageDropoff : Curve
@export_range(0.0, 15.0, 0.01) var headshotDamageMult : float = 1.0
@export var timeBetweenShots : float 

@export_group("Reload variables")
var isReloading : bool = false
@export var hasToReload : bool = true
@export var autoReload : bool = true
@export var nbPartsNeeded : int = 1
@export var reloadTimePerPart : float

@export_group("Recoil variables")
@export var baseRotSpeed : float = 0.0
@export var targetRotSpeed : float = 0.0
@export var recoilVal : Vector3 = Vector3.ZERO

@export_group("Projectile variables")
@export var isProjExplosive : bool = false
@export var projRef : PackedScene
@export var projMoveSpeed : float 
@export var projTimeBeforeVanish : float 
@export var projGravityVal : float

@export_group("Position variables")
@export var position : Array[Vector3] = [Vector3.ZERO, Vector3.ZERO]

@export_group("Tilt variables")
@export_range(0.0, 20.0, 0.01) var tiltRotSpeed : float = 0.0
@export_range(0.0, 1.0, 0.01) var tiltRotAmount : float = 0.0

@export_group("Sway variables")
@export var minSwayVal : Vector2 = Vector2.ZERO
@export var maxSwayVal : Vector2 = Vector2.ZERO
@export_range(0, 0.2, 0.01) var swaySpeedPos: float = 0.0
@export_range(0, 0.2, 0.01) var swaySpeedRot : float = 0.0
@export_range(0, 0.5, 0.01) var swayAmountPos : float = 0.0
@export_range(0, 100.0, 0.1) var swayAmountRot : float = 0.0

@export_group("Bob variables")
var bobPos : Array[Vector3]
@export_range(0.0, 0.1, 0.001) var bobFreq : float = 0.0
@export_range(0.0, 0.1, 0.001) var bobAmount : float = 0.0
@export_range(0.0, 50.0, 1.0) var bobSpeed : float = 0.0
@export var onIdleBobFreqDivider : float = 0.0

@export_group("Muzzle flash variables")
@export var muzzleFlashRef : PackedScene
@export var showMuzzleFlash : bool
