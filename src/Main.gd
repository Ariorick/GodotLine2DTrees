extends Node2D


func _ready():
	Ref.viewport = $ViewportContainer/Viewport



func _on_Button_pressed():
	for tree in $Trees.get_children():
		tree.generate()
	$AnimationPlayer.stop()
	$AnimationPlayer.play("growth")


func _on_HSlider_value_changed(value):
	for tree in $Trees.get_children():
		tree.growth = value


func _on_SaveButton_pressed():
	$CanvasLayer/FileDialog.popup_centered()


func _on_FileDialog_file_selected(path):
	var result = ResourceSaver.save(path, $Trees/ProceduralTree.tree)
	print(result)
