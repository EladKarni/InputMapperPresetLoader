@tool
extends Control

@onready var btn_save_preset = %BtnSavePreset
@onready var btn_load_preset = %BtnLoadPreset
@onready var lin_ed_preset_name = %LinEdPresetName
@onready var dropdown = %Dropdown
@onready var btn_import = %BtnImport
@onready var confirmation_dialog = $ConfirmationDialog


@onready var file_dialog = $FileDialog


var folder_path : String


# Called when the node enters the scene tree for the first time.
func _ready():
	btn_load_preset.pressed.connect(on_btn_pressed_load)
	btn_save_preset.pressed.connect(on_btn_pressed_save)
	btn_import.pressed.connect(on_btn_pressed_import)
	confirmation_dialog.confirmed.connect(on_confirmed_restart)
	
	file_dialog.dialog_hide_on_ok = true
	file_dialog.access = 2
	file_dialog.dir_selected.connect(on_folder_selected)
	btn_import.disabled = true


func on_folder_selected(path):
	folder_path = path
	btn_import.disabled = false
	dir_contents(path)


func on_confirmed_restart():
	EditorPlugin.new().get_editor_interface().restart_editor()


func on_btn_pressed_import():
	var file_path = folder_path.path_join(dropdown.get_item_text(dropdown.selected))
	var config = ConfigFile.new()
	var err = config.load(file_path)
	
	if err != OK:
		return
	
	for input_name in config.get_section_keys("input"):
		var action_obj = config.get_value("input", input_name)
		ProjectSettings.set_setting("input/" + input_name, action_obj)
	ProjectSettings.save()
	confirmation_dialog.popup_centered()

func on_btn_pressed_load():
	file_dialog.popup_centered()


func on_btn_pressed_save():
	if lin_ed_preset_name.text != null:
		save_test_file()


func save_test_file():
	InputMap.load_from_project_settings()
	var config = ConfigFile.new()
	var Actions = InputMap.get_actions()
	
	for action in Actions:
		if not action.begins_with("ui"):
			var input_object = {
				"deadzone": InputMap.action_get_deadzone(action),
				"events": InputMap.action_get_events(action)
			}
			config.set_value("input", action, input_object)

	# Save it to a file (overwrite if already exists).
	config.save(folder_path.path_join(lin_ed_preset_name.text + ".godot"))


func dir_contents(path):
	dropdown.clear()
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.ends_with(".godot"):
					dropdown.add_item(file_name)
			file_name = dir.get_next()

	else:
		print("An error occurred when trying to access the path.")
