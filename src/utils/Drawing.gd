class_name Drawing

static func draw_circle(node: Node2D, radius: float, color: Color):
	var maxerror = 0.25
	if radius <= 0.0:
		return
	var maxpoints = 1024 # I think this is renderer limit

	var numpoints = ceil(PI / acos(1.0 - maxerror / radius))
	numpoints = clamp(numpoints, 3, maxpoints)

	var points = PoolVector2Array([])

	for i in numpoints + 1:
		var phi = i * PI * 2.0 / numpoints
		var v = Vector2(sin(phi), cos(phi))
		points.push_back(v * radius)
	node.draw_polyline(points, color)

static func draw_vectors_in_circle(
		node: Node2D, 
		circle_size: float,
		vector_scale: float,
		vectors: Array, 
		vector_color: Color,
		circle_color: Color
	):
	for v in vectors:
		node.draw_line(
			Vector2.ZERO, 
			v * vector_scale, 
			vector_color
			)
		draw_circle(node, circle_size, circle_color)

static func draw_directions(
		node: Node2D, 
		directions: Array, 
		color: Color
	):
	var vectors := Array()
	var red_vectors := Array()
	for dir in directions:
		if dir.collider != null:
			red_vectors.append(dir.get_direction() * dir.distance)
		else:
			vectors.append(dir.get_direction() * dir.distance)
	draw_vectors_in_circle(node, 50, 1, vectors, Color.white, Color.white)
	draw_vectors_in_circle(node, 50, 1, red_vectors, Color.red, Color.white)

