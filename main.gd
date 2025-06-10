extends Control

@onready var code_edit  : CodeEdit   = $CodeEdit
@onready var open_dlg   : FileDialog = $FileDialog
@onready var save_dlg   : FileDialog = $FileSave

const OPEN_ACTION := "open_file"
const SAVE_ACTION := "save_file"
const SAVE_AS_ACTION := "save_save_file"

var current_path := ""      # remembers the last file you opened / saved

func _ready() -> void:
	_ensure_shortcuts_exist()
	open_dlg.file_selected.connect(_on_open_selected)
	save_dlg.file_selected.connect(_on_save_selected)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(OPEN_ACTION):
		accept_event()                      # stops the keystroke reaching CodeEdit :contentReference[oaicite:0]{index=0}
		open_dlg.popup_centered_ratio()
	elif event.is_action_pressed("save_save_file"):   # ← NEW branch
		accept_event()
		save_dlg.current_file = "untitled"
		save_dlg.popup_centered_ratio()
	elif event.is_action_pressed(SAVE_ACTION):
		accept_event()
		if current_path.is_empty():
			save_dlg.current_file = "untitled"
			save_dlg.popup_centered_ratio()
		else:
			_save_to(current_path)          # quick-save

func _on_open_selected(path: String) -> void:
	var txt := FileAccess.get_file_as_string(path)   # one-liner loader :contentReference[oaicite:1]{index=1}
	if txt.is_empty():
		push_warning("Couldn't read %s" % path)
		return
	code_edit.text = txt
	current_path   = path

func _on_save_selected(path: String) -> void:
	_save_to(path)

func _save_to(path: String) -> void:
	var f := FileAccess.open(path, FileAccess.WRITE)  # open for writing :contentReference[oaicite:2]{index=2}
	if f:
		f.store_string(code_edit.text)
		f.close()
		current_path = path
	else:
		push_warning("Can't write to %s" % path)

func _ensure_shortcuts_exist() -> void:
	if not InputMap.has_action(OPEN_ACTION):
		InputMap.add_action(OPEN_ACTION)
		var ie := InputEventKey.new()
		ie.physical_keycode = KEY_O
		ie.ctrl_pressed = true
		InputMap.action_add_event(OPEN_ACTION, ie)

	if not InputMap.has_action(SAVE_ACTION):
		InputMap.add_action(SAVE_ACTION)
		var ie := InputEventKey.new()
		ie.physical_keycode = KEY_S
		ie.ctrl_pressed = true
		InputMap.action_add_event(SAVE_ACTION, ie)
