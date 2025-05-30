extends CanvasLayer

@onready var weaponStackLabelText = %WeaponStackLabelText
@onready var weaponNameLabelText = %WeaponNameLabelText
@onready var totalAmmoInMagLabelText = %TotalAmmoInMagLabelText
@onready var totalAmmoLabelText = %TotalAmmoLabelText

func displayWeaponStack(weaponStack : int):
	weaponStackLabelText.set_text(str(weaponStack))
	
func displayWeaponName(weaponName : String):
	weaponNameLabelText.set_text(str(weaponName))
	
func displayTotalAmmoInMag(totalAmmoInMag : int):
	totalAmmoInMagLabelText.set_text(str(totalAmmoInMag))
	
func displayTotalAmmo(totalAmmo):
	totalAmmoLabelText.set_text(str(totalAmmo))
