extends Line2D
class_name BranchLine2D

# public vars
var order: int
var viewport_container: ViewportContainer
var leaf_texture: Texture
var leaf_scale: float

var viewport: Viewport
var tween: Tween
var sprite: Sprite

func _ready():
	viewport = viewport_container.get_child(0)
	tween = Tween.new()
	add_child(tween)
	start_tween()
	
	sprite = Sprite.new()
#	viewport.add_child(sprite)
	add_child(sprite)
	sprite.z_index = 1
	sprite.position = points[int(points.size() * 0.8)]
	sprite.texture = leaf_texture
	sprite.scale = Vector2.ONE * leaf_scale

func _process(delta):
	pass
#	sprite.position = global_position + points[int(points.size() * 0.8)].rotated(rotation)

func start_tween():
	var time = 1.5
	var value = Random.f_range(-0.1, 0.1) * sqrt(order)
	tween.interpolate_property(self, "rotation", rotation, value, time)
	tween.connect("tween_completed", self, "on_tween_completed")
	tween.start()

func on_tween_completed(object, key):
	start_tween()
