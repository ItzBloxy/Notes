extends CodeEdit

# Starting font size (tweak in the Inspector if you like)
@export var font_size: int = 14

# Clamp limits so you don't zoom to oblivion
const MIN_FONT_SIZE: int = 4
const MAX_FONT_SIZE: int = 100

func _ready() -> void:
	# Apply the initial font size override
	_apply_font_size()

func _process(_delta: float) -> void:
	# Zoom in?
	if Input.is_action_pressed("zoom-in"):
		font_size = clamp(font_size - 1, MIN_FONT_SIZE, MAX_FONT_SIZE)
		_apply_font_size()
	# Zoom out?
	elif Input.is_action_pressed("zoom-out"):
		font_size = clamp(font_size + 1, MIN_FONT_SIZE, MAX_FONT_SIZE)
		_apply_font_size()

func _apply_font_size() -> void:
	# Overrides the "font_size" constant for this Control
	add_theme_font_size_override("font_size", font_size)
