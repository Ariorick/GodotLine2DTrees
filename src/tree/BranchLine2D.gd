extends Line2D
class_name BranchLine2D

# public vars
var position_on_branch: float
var order: int
var leaf_count: int
var leaf_texture: Texture
var leaf_scale: float = 1.0
var leaf_color1: Color
var leaf_color2: Color
var growth: float = 1.0

var tween: Tween

onready var start_width = width
onready var start_position = position
onready var path = points


var broken := false

func _ready():
	if order > 1:
		tween = Tween.new()
		add_child(tween)
		start_tween()
	
	
	for i in leaf_count:
		add_sprite(Random.f_range(0.7/order, 1.0), Random.angle())
#	viewport.add_child(sprite)


func add_sprite(position_on_branch: float, rotation: float):
	var sprite = LeafSprite.new()
	sprite.position_on_branch = position_on_branch
	sprite.centered = false
	sprite.z_index = 1
	sprite.position = points[int((points.size() -1) * position_on_branch)]
	sprite.texture = leaf_texture
	sprite.scale = Vector2.ONE * leaf_scale
	sprite.rotation = rotation
	if Random.boolean():
		sprite.modulate = leaf_color1
	else:
		sprite.modulate = leaf_color2
	add_child(sprite)

func _process(delta):
	#Branches braking off
#	if OS.get_ticks_msec() > 10000 and order > 2 and randf() < 0.001:
#		reparent()
#		broken = true
#	if broken:
#		global_position += Vector2(-1, 3)
#		rotation -= 0.01
#		return
	
	var own_growth = growth
	var order_k = order + 1
	if order_k > 1:
		own_growth = max(0, growth * (order_k- 1) - (order_k-2))
		
	
	var new_points = Array(path)
	points = PoolVector2Array(new_points.slice(0, (path.size() - 1) * (own_growth)))
	position = start_position - points[0] * own_growth
	width = start_width * own_growth
	
	
	for child in get_children():
		if not child is Sprite and not child is Tween:
			child.growth = own_growth
			child.start_position = points[child.position_on_branch * (points.size() -1)]
		if child is Sprite:
			child.scale = (Vector2.ONE * leaf_scale * own_growth) * min(1, (1 - child.position_on_branch + own_growth))
			child.position = points[child.position_on_branch * (points.size() -1)]

func start_tween():
	var time = 1.5
	var value = Random.f_range(-0.1, 0.1) * sqrt(order)
	tween.interpolate_property(self, "rotation", rotation, value, time)
	tween.connect("tween_completed", self, "on_tween_completed")
	tween.start()

func on_tween_completed(object, key):
	start_tween()

func reparent():
	var saved_position = global_position
	var new_parent = find_parent("TreeBase")
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = saved_position
