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
var damageNumber : PackedScene = preload("res://Scenes/DamageNumberScene.tscn")

# Colors
var normalColor : Color = Color(248, 248, 242, 255)
var criticalColor : Color = Color(255, 85, 85, 255)

# Tween
var upTweenAmount : float = 0.5
var upTweenLength : float = 0.25
var downTweenLength : float = 0.5


func _get_label() -> Label3D:
	var newLabel : Label3D
	
	newLabel = damageNumber.instantiate()
	add_child(newLabel)
	
	return newLabel
	
func display_number(_value : int, _position : Vector3, _fontSize : int, _damageType : DamageType = DamageType.NORMAL) -> void:
	var numberLabel : Label3D = _get_label()
	numberLabel.global_position = _position
	numberLabel.text = str(_value)
	numberLabel.font_size = _fontSize
	
	match _damageType:
		DamageType.NORMAL:
			numberLabel.modulate = normalColor / 255
		DamageType.CRITICAL_HIT:
			numberLabel.modulate = criticalColor / 255
		_:
			numberLabel.modulate = normalColor / 255
	
	_animate_display(numberLabel)
	
	
func _animate_display(_currentDisplay : Label3D) -> void:
	var originalYPos : float = _currentDisplay.global_position.y
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(_currentDisplay, "position:y", originalYPos + upTweenAmount, upTweenLength).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(_currentDisplay, "position:y", originalYPos, downTweenLength).set_ease(Tween.EASE_IN).set_delay(upTweenLength)
	#tween.parallel().tween_property(_currentDisplay, "modulate:a", 0, downTweenLength).set_ease(Tween.EASE_IN).set_delay(upTweenLength)
	tween.parallel().tween_property(_currentDisplay, "font_size", 0, 0.4).set_ease(Tween.EASE_IN).set_delay(0.6)
	
	await tween.finished
	
	_currentDisplay.visible = false
	_currentDisplay.queue_free()
