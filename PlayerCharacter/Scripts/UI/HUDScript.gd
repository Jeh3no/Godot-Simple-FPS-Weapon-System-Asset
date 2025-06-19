extends CanvasLayer

@onready var currStateLabelText = %CurrStateLabelText
@onready var currDirLabelText = %CurrDirectionLabelText
@onready var desiredMoveSpeedLabelText = %DesiredMoveSpeedLabelText
@onready var velocityLabelText = %VelocityLabelText
@onready var nbJumpsInAirAllowedLabelText = %NbJumpsInAirAllowedLabelText

@onready var weaponStackLabelText = %WeaponStackLabelText
@onready var weaponNameLabelText = %WeaponNameLabelText
@onready var totalAmmoInMagLabelText = %TotalAmmoInMagLabelText
@onready var totalAmmoLabelText = %TotalAmmoLabelText

func displayCurrentState(currState : String):
	currStateLabelText.set_text(str(currState))
	
func displayCurrentDirection(currDir : Vector3):
	currDirLabelText.set_text(str(currDir))
	
func displayDesiredMoveSpeed(desMoveSpeed : float):
	desiredMoveSpeedLabelText.set_text(str(desMoveSpeed))
	
func displayVelocity(vel : float):
	velocityLabelText.set_text(str(vel))
	
func displayNbJumpsInAirAllowed(nbJumpsInAirAllowed : int):
	nbJumpsInAirAllowedLabelText.set_text(str(nbJumpsInAirAllowed))
	
#----------------------------------------------------------------------------
	
func displayWeaponStack(weaponStack : int):
	weaponStackLabelText.set_text(str(weaponStack))
	
func displayWeaponName(weaponName : String):
	weaponNameLabelText.set_text(str(weaponName))
	
func displayTotalAmmoInMag(totalAmmoInMag : int, nbProjShotsAtSameTime : int):
	totalAmmoInMagLabelText.set_text(str(totalAmmoInMag/nbProjShotsAtSameTime))
	
func displayTotalAmmo(totalAmmo : int, nbProjShotsAtSameTime : int):
	totalAmmoLabelText.set_text(str(totalAmmo/nbProjShotsAtSameTime))
	
	
	
	
	
