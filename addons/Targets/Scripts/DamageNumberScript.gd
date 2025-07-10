## Code written by Minoqi @2024 under the MIT license
## Documentation: https://github.com/Minoqi/minos-damage-numbers-for-godot

extends Node

## Variables
enum DamageType{
	NORMAL,
	CRITICAL_HIT,
	BURN,
	POISON,
	STUN
}

# Labels
var damageNumber : PackedScene = preload("../../Targets/Scenes/DamageNumberScene.tscn")

# Colors
var normalColor : Color = Color(248, 248, 242, 255)
var criticalColor : Color = Color(255, 85, 85, 255)

# Tweens
var upTweenAmount : float = 0.5
var upTweenLength : float = 0.25
var downTweenLength : float = 0.5


func getLabel() -> Label3D:
	#create new label3D
	var newLabel : Label3D
	
	newLabel = damageNumber.instantiate()
	add_child(newLabel)
	
	return newLabel
	
func displayNumber(value : float, position : Vector3, fontSize : int, damageType : DamageType = DamageType.NORMAL) -> void:
	var numberLabel : Label3D = getLabel()
	
	#set properties
	numberLabel.global_position = position
	numberLabel.text = str(int(value))
	numberLabel.font_size = fontSize
	
	match damageType:
		DamageType.NORMAL:
			numberLabel.modulate = normalColor / 255
		DamageType.CRITICAL_HIT:
			numberLabel.modulate = criticalColor / 255
			
	animateDisplay(numberLabel)
	
func animateDisplay(currentDisplay : Label3D) -> void:
	var originalYPos : float = currentDisplay.global_position.y
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(currentDisplay, "position:y", originalYPos + upTweenAmount, upTweenLength).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(currentDisplay, "position:y", originalYPos, downTweenLength).set_ease(Tween.EASE_IN).set_delay(upTweenLength)
	tween.parallel().tween_property(currentDisplay, "font_size", 0, 0.4).set_ease(Tween.EASE_IN).set_delay(0.6)
	
	await tween.finished
	
	currentDisplay.visible = false
	currentDisplay.queue_free()
