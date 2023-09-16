@tool
extends EditorPlugin

const editorAddon = preload("res://addons/inputmapperpresetloader/InputMapperPresets.tscn")
var InputMapperPresetsScene


func _enter_tree():
	InputMap.load_from_project_settings()
	
	InputMapperPresetsScene = editorAddon.instantiate()
	add_tool_menu_item("Input Mapper Preset Loader", InputMapperPresetsScene)


func _exit_tree():
	remove_tool_menu_item("Input Mapper Preset Loader")
	InputMapperPresetsScene.free()
