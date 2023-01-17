extends Node
class_name ArrayUtils

static func filter_array_from_nulls(array: Array) -> Array:
	var new_array = Array()
	for item in array:
		if is_instance_valid(item):
			new_array.append(item)
	return new_array


static func map(array: Array, map_function: FuncRef) -> Array:
	var output := []
	for value in array:
		output.append(map_function.call_func(value))
	return output

static func map_by_var(array: Array, var_name: String) -> Array:
	var output := []
	for value in array:
		output.append(value.get(var_name))
	return output

static func filter(array: Array, filter_function: FuncRef) -> Array:
	var output := []
	for value in array:
		if filter_function.call_func(value):
			output.append(value)
	return output

static func sort_by_var(array: Array, var_name: String) -> Array:
	var output := Array()
	output.append_array(array)
	output.sort_custom(VarComparator.new(var_name), "compare")
	return output

static func sort_by_func(array: Array, func_name: String) -> Array:
	var output := Array()
	output.append_array(array)
	output.sort_custom(FuncComparator.new(func_name), "compare")
	return output

# Ascending sorter
class VarComparator:
	var var_name: String
	
	func _init(var_name):
		self.var_name = var_name
	
	func compare(a, b) -> bool:
		return a.get(var_name) < b.get(var_name)


# Ascending sorter
class FuncComparator:
	var func_name: String
	
	func _init(func_name):
		self.func_name = func_name
	
	func compare(a, b) -> bool:
		return a.call(func_name) < b.call(func_name)
