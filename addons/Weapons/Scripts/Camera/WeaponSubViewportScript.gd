extends SubViewport

var screenSize : Vector2

func _ready():
	screenSize = get_window().size
	size = screenSize
