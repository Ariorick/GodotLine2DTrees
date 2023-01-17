extends Node

func add_by_id(id: String, count = 1):
	if Inventory.is_valid_id(trim_input(id)):
		Inventory.add(trim_input(id), count)
	else:
		Console.write_line('No such item: ' + id + '!')

func craft(id: String, count = 1):
	if Inventory.is_valid_id(trim_input(id)):
		if not Inventory.craft(trim_input(id), count):
			Console.write_line('Not enough resources!')
		else:
			Console.write_line(id + ' crafted!')
	else:
		Console.write_line('No such item: ' + id + '!')


func print_recipies():
	var result := Array()
	var result_string := ""
	for item in Inventory.item_types.values():
		if not item.recipe.empty():
			result_string += item.id + ": " + str(item.recipe) + " \n"
			result.append(item)
	Console.write_line(result_string)

func print_item_types():
	var result := Array()
	for item in Inventory.item_types:
		result.append(item.id)
	Console.write_line(str(result))

func trim_input(input: String) -> String:
	return input.to_lower().trim_suffix(' ').trim_prefix(' ')
