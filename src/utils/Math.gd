extends Node
class_name Math

# rounds closer to positive infinity if .
static func round_up(value: float) -> int:
	if value > 0:
		if value - int(value) > 0:
			return int(value) + 1
	return int(value)

static func round_up_v(v: Vector2) -> Vector2:
	return Vector2(round_up(v.x), round_up(v.y))

static func round_v(v: Vector2) -> Vector2:
	return Vector2(round(v.x), round(v.y))

static func is_between(value, a, b):
	if b > a:
		return value >= a and value <= b
	else:
		return value >= b and value <= a

static func angle_between(from: Vector2, to: Vector2):
	return fposmod(to.angle()-from.angle() + PI, PI*2) - PI

static func angle_to_angle(from: float, to: float):
	return fposmod(to-from + PI, PI*2) - PI

static func bool_sign(value: bool) -> int:
	if value:
		return 1
	else:
		return -1
