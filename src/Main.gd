extends Node2D


func _ready():
	Ref.viewport = $ViewportContainer/Viewport



func _on_Button_pressed():
	$ProceduralTree.generate()
	$AnimationPlayer.play("growth")
