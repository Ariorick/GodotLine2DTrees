extends Node

var _rng : = RandomNumberGenerator.new()

func _ready():
	_rng.randomize()
	pass


func f_range(start: float, end: float)  -> float:
	return _rng.randf_range(start, end)

func i_range(start: int, end: int) -> int:
	return _rng.randi_range(start, end)

func angle() -> float:
	return _rng.randf_range(-PI, PI)

# returns random point with set radius
func point_within_radius(radius: float) -> Vector2:
	return point_on_radius(radius) * f_range(0, 1)

# returs random point with set radius
func point_on_radius(radius: float) -> Vector2:
	return direction(0, PI) * radius

# Returns float with random change less then percent_radius
func around_pradius(value: float, percent_radius: float) -> float:
	return _rng.randf_range(value * (1 - percent_radius), value * (1 + percent_radius))

# Returns float with random change less then radius
func around_fradius(value: float, radius: float) -> float:
	return _rng.randf_range(value - radius, value + radius)

# Returns angle Vector direction with change in angle less then angle_difference
func direction(angle: float, angle_difference: float) -> Vector2:
	var new_angle = around_fradius(angle, angle_difference)
	return Vector2(cos(new_angle), sin(new_angle))

func around_point_on_radius(point: Vector2, radius: float) -> Vector2:
	return point + point_on_radius(radius)

func boolean(true_chance: float = 0.5):
	return _rng.randf_range(0, 1) <= true_chance
