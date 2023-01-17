extends Sprite
class_name LeafSprite

var position_on_branch: float
onready var start_position = position
onready var created_time = OS.get_ticks_msec()

func _ready():
	set_process(false)
	yield(get_tree().create_timer(Random.f_range(1, 50)), "timeout")
	
	var saved_position = global_position
	var new_parent = find_parent("TreeBase")
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = saved_position
	set_process(true)

func _process(delta):
	rotation += 0.02
	global_position += Vector2(-4, 1)
