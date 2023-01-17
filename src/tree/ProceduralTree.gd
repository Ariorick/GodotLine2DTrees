extends Node2D
class_name ProceduralTree

# This is a resource of type Branch, that you can get by saving the result of generation
# If you set this parameter, all Branch Settings will be ignored, but Visual Settings are still applied
export(Resource) var tree: Resource = null

export var __ = 'Branch settings'
export var length = 5;
export var branch_length = 5
export var branch_count = 2.8
export(float, -3.14, 3.14) var first_angle = 0.0
export(float, 0, 1000) var first_length = 200.0

export var ___ = 'Visual Settings'
export(float, 0, 1) var growth = 1.0

export var trunk_color = Color("#6c584c")

export(int, 0, 20) var leaf_count = 7
export(Texture) var leaf_texture: Texture
export(float, 0, 10) var leaf_scale = 1.0
export(Color) var leaf_color1 = Color("#DDE5B6")
export(Color) var leaf_color2 = Color("#ADC178")


var root: BranchLine2D

func _ready():
	if tree == null:
		generate()
	else:
		draw()

func generate():
	tree = create_tree(length, 1)
	draw()

func draw():
	delete_children($TreeBase)
	root = draw_branch(tree, null, null)


# Create new Branch resource, representing the tree
func create_tree(length: int, order: int) -> Branch:
	var root := Branch.new()
	root.order = order
	
	var points := PoolVector2Array()
	points.append(Vector2.ZERO)
	for i in branch_length + 1 + 2 - order:
		var last = points[points.size() - 1]
		if order == 1 and i == 0:
			points.append(last + Vector2(0, -1).rotated(first_angle) * first_length * 0.75)
		else:
			points.append(last + Vector2(0, -1).rotated(Random.f_range(-1.3, 1.3) / (i + 1)) * first_length / (i + 1) / order)
	root.path = points
	
	if length > 0:
		var branches = Array()
		var corrected_branch_count = int(branch_count) + (1 if Random.boolean(fposmod(branch_count, 1)) else 0)
		for i in corrected_branch_count + 2 - order:
			var new_branch = create_tree(length - 1, order + 1)
			new_branch.start_in_parent = Random.f_range(0.2, 0.7)
			branches.append(new_branch)
		root.branches = branches
	
	
	return root

func _process(delta):
	root.growth = pow(growth, 0.35)

# Use Branch to make new Line2D's 
func draw_branch(branch: Branch, parent_line, parent_branch) -> BranchLine2D:
	var line := BranchLine2D.new()
	line.order = branch.order
	line.leaf_texture = leaf_texture
	line.leaf_scale = leaf_scale
	line.leaf_count = leaf_count
	line.leaf_color1 = leaf_color1
	line.leaf_color2 = leaf_color2
	
	line.default_color = trunk_color
	line.antialiased = true
	line.width = 15
	
	var curve = Curve2D.new()
	curve.bake_interval = 1.0
	var points = branch.path
	curve.add_point(points[0], Vector2.ZERO)
	for i in range(1, points.size() - 2):
		var v_out = points[i+1] - points[i-1]
		var between = (points[i-1] - points[i+1])/4
		var in_point = between
		curve.add_point(points[i], in_point, -in_point)
	line.points = curve.get_baked_points()
	
	
	
	var width_curve = Curve.new()
	width_curve.add_point(Vector2(0, 1))
	width_curve.add_point(Vector2(1, 0))
	line.width_curve = width_curve
	
	if parent_line != null:
		var position_in_parent = int((parent_line.points.size() - 1) * branch.start_in_parent)
		line.position_on_branch = branch.start_in_parent
		line.position = parent_line.points[position_in_parent]
		line.width = parent_line.width * (1 - branch.start_in_parent) * 0.8
	
	if parent_line != null:
		parent_line.add_child(line)
	else:
		$TreeBase.add_child(line)
	
	for child_branch in branch.branches:
		draw_branch(child_branch, line, branch)
	
	return line

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
