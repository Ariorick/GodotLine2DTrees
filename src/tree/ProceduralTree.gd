extends Node2D
class_name ProceduralTree

export var length = 5;
export var branch_length = 5
export var branch_count = 3
export(Texture) var leaf_texture: Texture
export(float, 0, 10) var leaf_scale = 1.0
export(float, 0, 1) var growth = 1.0

func _ready():
	generate()

func generate():
	delete_children($TreeBase)
	delete_children($ViewportContainer/Viewport)
	var tree = create_tree(length, 1)
	draw_branch(tree, null, null)

func create_tree(length: int, order: int) -> Branch:
	var root := Branch.new()
	root.order = order
	
	var points := PoolVector2Array()
	points.append(Vector2.ZERO)
	for i in branch_length + 1 + 2 - order:
		var last = points[points.size() - 1]
		points.append(last + Vector2(0, -1).rotated(Random.f_range(-1.3, 1.3) / (i + 1)) * 200 / (i + 1) / order)
	root.path = points
	
	if length > 0:
		var branches = Array()
		for i in branch_count + 2 - order:
			var new_branch = create_tree(length - 1, order + 1)
			new_branch.start_in_parent = Random.f_range(0.2, 0.7)
			branches.append(new_branch)
		root.branches = branches
	
	
	return root


func draw_branch(branch: Branch, parent_line, parent_branch):
	var line := BranchLine2D.new()
	line.order = branch.order
	line.viewport_container = $ViewportContainer
	line.leaf_texture = leaf_texture
	line.leaf_scale = leaf_scale
	
	line.antialiased = true
	line.width = 15
	
	var curve = Curve2D.new()
	var points = branch.path
	curve.add_point(points[0], Vector2.ZERO)
	for i in range(1, points.size() - 2):
		var v_out = points[i+1] - points[i-1]
		var between = (points[i-1] - points[i+1])/4
		var in_point = between
		curve.add_point(points[i], in_point, -in_point)
	line.points = curve.get_baked_points()
	
	if parent_line != null:
		parent_line.add_child(line)
	else:
		$TreeBase.add_child(line)
	
	
	var width_curve = Curve.new()
	width_curve.add_point(Vector2(0, 1))
	width_curve.add_point(Vector2(1, 0))
	line.width_curve = width_curve
	
	if parent_line != null:
		var position_in_parent = int((parent_line.points.size() - 1) * branch.start_in_parent)
		line.position = parent_line.points[position_in_parent]
		line.width = parent_line.width * (1 - branch.start_in_parent) * 0.8
	
	for child_branch in branch.branches:
		draw_branch(child_branch, line, branch)

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
