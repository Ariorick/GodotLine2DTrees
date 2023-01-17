extends Line2D
class_name BranchLine2D

# public vars
var position_on_branch: float
var order: int
var viewport_container: ViewportContainer
var leaf_count: int
var leaf_texture: Texture
var leaf_scale: float = 1.0
var growth: float = 1.0

var viewport: Viewport
var tween: Tween
var sprite: Sprite

onready var start_width = width
onready var start_position = position
onready var path = points

func _ready():
	viewport = viewport_container.get_child(0)
	if order > 1:
		tween = Tween.new()
		add_child(tween)
		start_tween()
	
	
	for i in leaf_count:
		add_sprite(Random.f_range(0.7/order, 1.0), Random.angle())
#	viewport.add_child(sprite)


func add_sprite(position_on_branch: float, rotation: float):
	sprite = LeafSprite.new()
	sprite.position_on_branch = position_on_branch
	sprite.centered = false
	sprite.z_index = 1
	sprite.position = points[int((points.size() -1) * position_on_branch)]
	sprite.texture = leaf_texture
	sprite.scale = Vector2.ONE * leaf_scale
	sprite.rotation = rotation
	if Random.boolean():
		sprite.modulate = Color("#DDE5B6")
	else:
		sprite.modulate = Color("#ADC178")
	add_child(sprite)

func _process(delta):
	var own_growth = growth
	var order_k = order + 1
	if order_k > 1:
		own_growth = max(0, growth * (order_k- 1) - (order_k-2))
		
	
#	scale = Vector2.ONE * own_growth
	var new_points = Array(path)
#	points = PoolVector2Array(new_points.slice((path.size() - 1) * (1-own_growth), path.size() - 1))
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
