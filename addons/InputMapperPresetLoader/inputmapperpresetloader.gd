@tool
extends EditorPlugin

const editorAddon = preload("res://addons/inputmapperpresetloader/InputMapperPresets.tscn")
var InputMapperPresetsScene


func _enter_tree():
	InputMap.load_from_project_settings()
	
	InputMapperPresetsScene = editorAddon.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, InputMapperPresetsScene)


func _exit_tree():
	remove_control_from_docks(InputMapperPresetsScene)
	InputMapperPresetsScene.free()