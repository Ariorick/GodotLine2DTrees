extends Node
# LayerNamesUtil

var layers := Array()
var started: bool = false

func _ready():
	if started:
		return
	
	layers.resize(21)
	for i in range(1, 21):
		layers[i] = ProjectSettings.get_setting("layer_names/2d_physics/layer_" + str(i))
	
	for layer in layers:
		if layer != null or layer != "":
			print(layer)

func get_collision_mask(names: Array) -> int:
	var mask = 0
	for name in names:
		if layers.find(name) == -1:
			push_error("Wrong layer name: " + name)
		mask += pow(2, layers.find(name) - 1)
	return mask

